#!/usr/bin/env roseus
(setq *elevator-spot* t)
(load "package://spoteus/spot-interface.l")

(unless (boundp '*ri*) (setq *ri* (instance spot-interface :init)))
(unless (boundp '*detection* t) (load "package://elevator_spot/scripts/detection.l"))
(unless (boundp '*speech-recognition-service* t) (load "package://elevator_spot/scripts/detection.l"))

(defun elevator-spot(start-floor goal-floor)
  ;; Using front camera to get in the elevator
  ;; change locomotion mode, see
  ;; https://dev.bostondynamics.com/protos/bosdyn/api/proto_reference.html?highlight=locomotion_hint#locomotionhint
  (send *ri* :set-locomotion-mode 4)
  (check-elevator-open "front" :th 500)
  (send *ri* :go-pos 2.5 0 0)
  ;; check elevator arrive
  ;; (wait-for-julius-trigger "すすんで")
  (check-elevator-open "back")
  ;; nazodance sinakya
  (send *ri* :go-pos -2.5 0 0)
  (send *ri* :set-locomotion-mode 1))
