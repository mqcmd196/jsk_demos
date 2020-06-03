(load "package://pr2eus/pr2.l")
(load "models/room73b2-scene.l")
(load "package://pr2eus/pr2-interface.l")
;; ;; chair
;; (load "models/room73b2-chair0-object.l")
;; ;; can
;; (load "models/room73b2-georgia-emerald-mountain-object.l")
;; (load "models/room73b2-wanda-object.l")
;; ;; iemon
;; (load "models/room73b2-iemon-object.l")
;; ;; bottle
;; (load "models/room73b2-bottle-object.l")


(defun init-irt()
    (setq *pr2* (pr2))
    (setq *room* (room73b2))
    ;; ROBOT_INITIAL_POSE
    (send *pr2* :move-to (make-coords :pos #f(750 0 0) :rpy #f(0 0 0)))
    ;; chairs <- box1
    (setq *chair_1* (room73b2-chair0))
    (setq *chair_2* (room73b2-chair0))
    (setq *chair_3* (room73b2-chair0))
    (send *chair_1* :transform (make-coords :pos #f(4000.0 -1000.0 0.1) :rpy #f(0.2 0.0 0.0)))
    (send *chair_2* :transform (make-coords :pos #f(4500.0 -300.0 0.1) :rpy #f(0.8 0.0 0.0)))
    (send *chair_3* :transform (make-coords :pos #f(6000.0 300.0 0.1) :rpy #f(1.4 0.0 0.0)))
    ;; trash
    (setq *can_1* (room73b2-georgia-emerald-mountain))
    (setq *can_2* (room73b2-wanda))
    (setq *carton_1* (room73b2-iemon))
    (setq *bottle_1* (room73b2-bottle))
    (setq *trashbox* (room73b2-trashbox0))
    (send *can_1* :transform (make-coords :pos #f(7500.0 1000.0 30.0) :rpy #f(0.0 0.0 1.571)))
    (send *can_2* :transform (make-coords :pos #f(9500.0 2000.0 30.0) :rpy #f(0.0 0.0 1.571)))
    (send *carton_1* :transform (make-coords :pos #f(8000.0 3000.0 0.0) :rpy #f(0.0 0.0 1.571)))
    (send *bottle_1* :transform (make-coords :pos #f(11000.0 3000.0 45.0) :rpy #f(0.0 0.0 1.571)))
    (send *trashbox* :transform (make-coords :pos #f(1000.0 -1000.0 0.0) :rpy #f(0 0 0)))
    ;; mini box
    (setq *box_1* (room73b2-empty-box))
    (setq *box_2* (room73b2-empty-box))
    (send *box_1* :transform (make-coords :pos #f(11200.0 0.0 675.0) :rpy #f(0.0 0.0 0.0)) :world)
    (send *box_2* :transform (make-coords :pos #f(11200.0 1000.0 675.0) :rpy #f(0.0 0.0 0.0)) :world)
    ;; view
    (objects (list *pr2* *room* *chair_1* *chair_2* *chair_3* *can_1* *can_2* *carton_1* *bottle_1* *trashbox* *box_1* *box_2*)))

(defun init-simulator()
    (setq *ri* (instance pr2-interface :init :objects (send *room* :objects)))
    (send *ri* :angle-vector (send *pr2* :reset-pose) 5000))

;; move chairs
(defun move-chairs()
    )

;; collect trash
(defun collect-trash)

;; collect box
(defun collect-box)