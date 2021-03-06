(defun move-to-through-door-eng2-2f (userdata)
  (let ((co (cdr (assoc :goal userdata)))
	cur co-2f d1 d2 ret (thr 10500))
    (setq cur (send (send *ri* :state :worldcoords "eng2/2f") :worldpos))
    (setq co-2f (send
	  (send *tfl* :lookup-transform "eng2/2f" "world" (ros::time 0))
	  :transform co))
    (when (and (string= (send *scene* :name) "eng2")
	       (string= (send *scene* :current-floor co) "eng2/2f")
	       (or (< (elt (send co-2f :worldpos) 0) thr (elt cur 0))
		   (< (elt cur 0) thr (elt (send co-2f :worldpos) 0))))
      (setq d1 (make-coords :pos (float-vector (- thr 750) -27000 0))
	    d2 (make-coords :pos (float-vector (+ thr 1500) -27000 0)))
      (when (< (elt (send co-2f :worldpos) 0) thr (elt cur 0))
	(send d1 :rotate pi :z)	(send d2 :rotate pi :z)
	(setq tmp d1 d1 d2 d2 tmp)) ;; swap
      (when (not (send *ri* :move-to d1 :frame-id "eng2/2f"))
	(return-from move-to-through-door-eng2-2f :failed))
      (switch-global-planner-observation nil) ;;disable tilt scan
      (setq ret (send *ri* :move-to d2 :frame-id "eng2/2f"))
      (switch-global-planner-observation t) ;;enable tilt scan
      (when (not ret) (return-from move-to-through-door-eng2-2f :failed)))
    (send *ri* :move-to co)
    :succeeded))
