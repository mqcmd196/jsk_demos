#!/usr/bin/env roseus

(load "package://elevator_move_base_pr2/src/state/push-elevator-button.l")
(load "package://elevator_move_base_pr2/src/state-machine-main.l")

(initialize-env)

(look-button-state '((panel-name . "/elevator_call_panel")))
