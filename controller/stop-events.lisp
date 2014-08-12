(in-package :cta.controller)

(defun find-fulfilled-predictions (a b)
  "A and B should each be hash tables of predictions keyed by bus
  ID. This function will return the set of predictions from A where a
  prediction for the same bus also occurs in B, but with a different
  predicted next stop. (The idea is that these are predictions of
  stops which actually occurred at some time during the interval
  between the generation of A and B.)"
  (loop
     :for key :being :the :hash-keys :of a
     :using (hash-value prediction-list-a)
     :for prediction-a := (car prediction-list-a)
     :when (alexandria:when-let (prediction-b (car (gethash key b)))
             (not (eql (api:prediction-stop prediction-a) (api:prediction-stop prediction-b))))
     :collect prediction-a))

(defun prediction->stop-event (prediction)
  (make-instance 'schema:stop-event
                 :route (api:prediction-route prediction)
                 :bus (api:prediction-bus prediction)
                 :stop (api:prediction-stop prediction)
                 :direction (api:prediction-direction prediction)
                 :stop-time (api:prediction-predicted-time prediction)))

(defun generate-stop-events ()
  (sb-sys:with-interrupts
    (log:write-log :info "Begin generating stop events")
    (sb-ext:gc :full t)
    (pomo:with-connection *database-connection-spec*
      (let ((new-predictions (api:get-predictions (api:get-all-current-buses))))
        (if *previous-predictions*
            (dolist (prediction (find-fulfilled-predictions *previous-predictions* new-predictions))
              (pomo:save-dao (prediction->stop-event prediction)))
            (log:write-log :info "No previous stop events found (first run)"))
        (setf *previous-predictions* new-predictions)))
    (log:write-log :info "Done generating stop events")))
