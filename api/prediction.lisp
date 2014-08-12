(in-package :cta.api)

(defstruct prediction
  type
  route
  bus
  stop
  direction
  timestamp
  predicted-time)

(defun xml->prediction (node)
  (make-prediction
   :type (xpath->string node "typ")
   :bus (xpath->number node "vid")
   :stop (xpath->number node "stpid")
   :direction (xpath->string node "rtdir")
   :route (xpath->string node "rt")
   :timestamp (xpath->simple-date node "tmstmp")
   :predicted-time (xpath->simple-date node "prdtm")))

(defun process-predictions (predictions)
  (process-cta-data predictions
                    :xpath "bustime-response/prd"
                    :callback 'xml->prediction))

(defun get-predictions (buses)
  "Takes a list of BUSES. Requests all predictions for each group of
  10 buses (the maximum allowed per request by the API). Builds a hash
  table keyed by bus ID of the list of predictions for each bus, in
  original order (which is guaranteed by the API documentation to be
  ascending chronological order)."
  (let ((predictions (make-hash-table :size 1000 :synchronized t)))
    (lparallel:pmapc
     (lambda (ten)
       (dolist (prediction (process-predictions
                            (retrieve-cta-data "getpredictions"
                                               :parameters `(:vid ,(format nil "~{~a~^,~}" (mapcar 'bus-id ten))))))
         ;; build up the list of predictions in reverse order; we will reverse them after
         (setf (gethash (prediction-bus prediction) predictions)
               (cons prediction (gethash (prediction-bus prediction) predictions)))))
     (group 10 buses))
    ;; reverse the order of the lists that are the values in the hash table
    (maphash (lambda (k v) (setf (gethash k predictions) (nreverse v))) predictions)
    predictions))


