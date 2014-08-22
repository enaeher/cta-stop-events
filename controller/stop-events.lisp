(in-package :cta.controller)

(defun find-fulfilled-predictions (a b)
  "A and B should each be hash tables of keyed by bus ID, the values
  of which are lists of predictions in ascending chronological
  order. This function tries to determine which predictions from A
  have been fulfilled by the time that B was generated.

It does this by (for each bus) looking at the earliest predicted stop
in B, then trying to find that stop in the ordered list of predictions
for A. If it does, it considers all predictions in A which are earlier
than the prediction for that stop to have been fulfilled.

Returns a flat list of all fulfilled predictions."
  (loop
     :for key :being :the :hash-keys :of a
     :using (hash-value prediction-list-a)
     :for prediction-list-b := (gethash key b)
     ;; we could simplify the next bit by using set-intersection, but
     ;; it could return wrong results in certain pathological cases,
     ;; where A has a predicted stop which is later than the first
     ;; stop in B but does not occur in B. In theory this shouldn't
     ;; happen, but I'm not certain enough of that to trust
     ;; set-intersection.
     :for position := (alexandria:when-let (first-prediction-b (car prediction-list-b))
                        (position (api:prediction-stop first-prediction-b) prediction-list-a :key 'api:prediction-stop))
     :when position
     :nconc (subseq prediction-list-a 0 position)))

(defun prediction->stop-event (prediction)
  (make-instance 'schema:stop-event
                 :stop-route-direction (schema:get-stop-route-direction-id (api:prediction-stop prediction)
                                                                           (api:prediction-route prediction)
                                                                           (api:prediction-direction prediction))
                 :stop-time (api:prediction-predicted-time prediction)
                 :bus (api:prediction-bus prediction)))

(defun generate-stop-intervals ()
  (log:write-log :info "Generating stop intervals")
  (pomo:execute (:select (:generate-stop-intervals)))
  (log:write-log :info "Done generating stop intervals"))

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
        (setf *previous-predictions* new-predictions))
      (log:write-log :info "Done generating stop events")
      (generate-stop-intervals)
      (pomo:save-dao (make-instance 'schema:event-log :event-type "STOP-EVENTS")))))
