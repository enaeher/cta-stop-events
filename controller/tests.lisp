(defpackage :cta.controller.tests
  (:use :common-lisp :cta.controller)
  (:import-from :cta.api
                #:make-prediction
                #:prediction-stop)
  (:import-from :cta.controller
                #:find-fulfilled-predictions))

(5am:def-suite cta.controller)
(5am:in-suite cta.controller)

(5am:test record-all-stops
  "If a bus passes multiple stops, we should record all of them."
  (let ((predictions (loop :for i :from 0 :upto 9
                        :collecting (make-prediction :bus 1 :stop i)))
        (a (make-hash-table))
        (b (make-hash-table)))
    ;; in the first set of predictions, the predicted next stop is 0
    (setf (gethash 1 a) (subseq predictions 0 5))
    ;; in the second set of predictions, the predicted next stop is 3,
    ;; so the bus has passed stops 0, 1, and 2 in the interim
    (setf (gethash 1 b) (subseq predictions 3 8))
    (let ((fulfilled-predictions (find-fulfilled-predictions a b)))
      (5am:is (= 3 (length fulfilled-predictions)))
      (5am:is (equal '(0 1 2) (mapcar 'prediction-stop fulfilled-predictions))))))

(5am:test ignore-fragmented-data
  "If we cannot determine all of the stops the bus has passed (for
example, if a longer-than-usual interval has occurred between polling
runs), we should not record any stop events."
  (let ((predictions (loop :for i :from 0 :upto 9
                        :collecting (make-prediction :bus 1 :stop i)))
        (a (make-hash-table))
        (b (make-hash-table)))
    ;; in the first set of predictions, the last predicted stop is 2.
    (setf (gethash 1 a) (subseq predictions 0 2))
    ;; in the second set of predictions, the predicted next stop is
    ;; 5. With real data, we would have no way of knowing which stops
    ;; fall between 2 and 5. Since we can't do anything sensible here,
    ;; we should do nothing.
    (setf (gethash 1 b) (subseq predictions 5 9))
    (let ((fulfilled-predictions (find-fulfilled-predictions a b)))
      (5am:is (null fulfilled-predictions)))))

(5am:test no-stop-event-when-no-stop-passed
  "If the predicted next stop is the same in both a and b, the bus has
not passed any stops in the interim and no stop events should be
recorded."
  (let ((predictions (loop :for i :from 0 :upto 9
                        :collecting (make-prediction :bus 1 :stop i)))
        (a (make-hash-table))
        (b (make-hash-table)))
    (setf (gethash 1 a) predictions
          (gethash 1 b) predictions)
    (let ((fulfilled-predictions (find-fulfilled-predictions a b)))
      (5am:is (null fulfilled-predictions)))))
