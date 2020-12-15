(ros::roseus-add-msgs "geometry_msgs")
(ros::roseus-add-msgs "posedetection_msgs")

(load "package://elevator_move_base_fetch/src/ros-callback-manager.l")


;; get vector in vlist , that is least median distance
(defun lmeds-vector (vlist)
  (find-extream
   vlist
   #'(lambda (p) (let ((diffs (mapcar #'(lambda (p1) (distance p p1)) vlist)))
                   (elt (sort diffs #'<) (/ (length diffs) 2))))
   #'<=))

(defun lmeds-pose (pose-list)
  (make-coords :pos (lmeds-vector (send-all pose-list :pos))
               :rot (quaternion2matrix
                     (lmeds-vector (mapcar #'matrix2quaternion
                                           (send-all pose-list :rot))))))


;; posedetectiondb -> tf client class
(defclass posedetectiondb-client
  :super ros-callback-object
  :slots (objects prev-tm poselist fixed-frame filter-type tfl tfb))

(defmethod posedetectiondb-client
  (:init (objs
          &key (topic "ObjectDetection")
               ((:fixed-frame _fixed) "/base_link")
               ((:filter-type ft) :lmeds))
   (setq objects objs)
   (setq fixed-frame _fixed)
   (setq filter-type ft)
   (setq prev-tm (ros::time 0))
   (setq tfl (instance ros::transform-listener :init))
   (setq tfb (instance ros::transform-broadcaster :init))
   (send-super :init topic posedetection_msgs::ObjectDetection :detection-cb))

  (:update-coords (coords &optional (relative :local))
   "Filter detection pose, and move obj to the estimated coords"
   (when (< 5 (send (ros::time- (ros::time-now) prev-tm) :to-sec))
     (setq poselist nil))
   (setq prev-tm (ros::time-now))
   (when (not (equal coords (car poselist)))
     (push (send coords :copy-worldcoords) poselist)
     (when (< 20 (length poselist))
       (nreverse poselist)
       (pop poselist)
       (nreverse poselist)))
   (case filter-type
     (:lmeds
      (send object :move-to (lmeds-pose poselist) relative))
     (t
      (send object :move-to coords relative))))

  (:detection-cb (msg)
   (dolist (object-msg (send msg :objects))
     (dolist (object objects)
       (when (substringp (string-left-trim "/" (send object :name))
                         (string-left-trim "/" (send object-msg :type)))
         ;; broadcast transform
         (send tfl :wait-for-transform
               fixed-frame (send msg :header :frame_id)
               (send msg :header :stamp) 1)
         (let* ((pose (instance geometry_msgs::PoseStamped :init
                                :header (send msg :header)
                                :pose (send object-msg :pose)))
                (coords (ros::tf-pose->coords (send pose :pose)))
                (objcoords (send tfl :transform-pose
                                 fixed-frame pose)))
           (ros::ros-info "posedetection-cb type: ~A, coords: ~A"
                          (send object-msg :type) coords)
           (when objcoords
             (send self :update-coords objcoords :world)
             (putprop object (send msg :header :stamp) :stamp)
             (send tfb :send-transform object
                   fixed-frame (send object :name)
                   (send msg :header :stamp)))
           )))))
  )


(defun init-posedetectiondb-client (objects &key topic)
  (let ((clients
         (if topic
             (instance posedetectiondb-client :init objects :topic topic)
           (instance posedetectiondb-client :init objects))))
    (ros::ros-info "initialize posedetection db client with ~A~%"
                   (send-all objects :name))
    clients))