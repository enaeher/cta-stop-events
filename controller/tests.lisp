(defpackage :cta.controller.tests
  (:use :common-lisp :cta.controller)
  (:import-from :cta.api
                #:make-prediction
                #:prediction-stop)
  (:import-from :cta.controller
                #:find-fulfilled-predictions
                #:prediction->stop-event))

(in-package :cta.controller.tests)

(5am:def-suite cta.controller)
(5am:in-suite cta.controller)

(5am:test record-one-stop
  "Simplest case"
  (let ((predictions (loop :for i :from 0 :upto 9
                        :collecting (make-prediction :bus 1 :stop i)))
        (a (make-hash-table))
        (b (make-hash-table)))
    ;; in the first set of predictions, the predicted next stop is 0
    (setf (gethash 1 a) (subseq predictions 0 5))
    ;; in the second set of predictions, the predicted next stop is 1
    (setf (gethash 1 b) (subseq predictions 1 6))
    (let ((fulfilled-predictions (find-fulfilled-predictions a b)))
      (5am:is (= 1 (length fulfilled-predictions)))
      (5am:is (equal '(0) (mapcar 'prediction-stop fulfilled-predictions))))))

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

(defmacro with-redefs ((&rest redefs) &body body)
  (let ((original-definitions (gensym)))
    `(let (,original-definitions)
       (unwind-protect
            (progn
              ,@(loop :for (fn def) :in redefs
                   :nconcing
                   `((push (list ',fn (symbol-function ',fn)) ,original-definitions)
                     (setf (symbol-function ',fn) ,def)))
              ,@body)
         (loop :for (fn def) :in ,original-definitions
            :do (setf (symbol-function fn) def))))))

(defun right-now ()
  (simple-date:universal-time-to-timestamp (get-universal-time)))

(defun roll-time (time &rest args)
  (simple-date:time-add time (apply 'simple-date:encode-interval args)))

(5am:test use-last-predicted-time-for-stop-event
  "Stop events should be timestamped based on the predicted arrival
   time of the fulfilled-prediction"
  (with-redefs ((schema:get-stop-route-direction-id (lambda (a b c) (declare (ignore a b c)) 1234)))
    (let* ((then (roll-time (right-now) :minute -5))
           (prediction (make-prediction :bus 1 :stop 0 :predicted-time then))
           (stop-event (prediction->stop-event prediction)))
      (5am:is (simple-date:time= then (schema:stop-time stop-event))))))
