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
     :using (hash-value prediction-a)
     :when (alexandria:when-let (prediction-b (gethash key b))
             (not (eql (api:stop prediction-a) (api:stop prediction-b))))
     :collect prediction-a))

(defun prediction->stop-event (prediction)
  (make-instance 'schema:stop-event
                 :route (api:route prediction)
                 :bus (api:bus prediction)
                 :stop (api:stop prediction)
                 :direction (api:direction prediction)
                 :stop-time (api:predicted-time prediction)))
