(in-package :bus-api)

(defclass prediction ()
  ((type      :initarg :type
              :reader prediction-type)
   (route     :initarg :route
              :reader route)
   (bus       :initarg :bus
              :reader bus)
   (stop      :initarg :stop
              :reader stop)
   (direction :initarg :direction
              :reader direction)
   (time      :initarg :time
              :reader prediction-time)
   (predicted-time :initarg :predicted-time
                   :reader predicted-time)))

(defun xml->prediction (node)
  (make-instance 'prediction
                 :type (xpath->string node "typ")
                 :bus (xpath->number node "vid")
                 :stop (xpath->number node "stpid")
                 :direction (xpath->string node "rtdir")
                 :route (xpath->string node "rt")
                 :time (xpath->simple-date node "tmstmp")
                 :predicted-time (xpath->simple-date node "prdtm")))

(defun get-predictions (buses)
  (%get-predictions-fast buses))

(defun %get-predictions-fast (buses)
  "Takes a list of BUSES. Requests all predictions for each group of
  10 buses (the maximum allowed per request by the API). Discards all
  but the first prediction for each bus, which will be the
  earliest (the API documentation guarantees that predictions will be
  returned in ascending order of prdtm), and returns the list of these
  earliest predictions. Destructively modifies BUSES."
  (let ((predictions (make-hash-table :size 1000 :synchronized t)))
    (lparallel:pmapc
     (lambda (ten)
       (dolist (prediction (get-cta-data "getpredictions"
                                         :xpath "bustime-response/prd"
                                         :callback 'xml->prediction
                                         :parameters `(:vid ,(format nil "~{~a~^,~}" (mapcar 'id ten)))))
         (unless (gethash (bus prediction) predictions)
           (setf (gethash (bus prediction) predictions) prediction))))
     (group 10 buses))
    predictions))

(defun %get-predictions-slow (buses)
  "Gets predictions for each bus in BUSES one-by-one. This allows us
to use the top parameter to retrieve only the first prediction for
each bus. This conses much less than %get-predictions-fast, but takes
roughly twice as long due to the additional network overhead."
  (let ((predictions (make-hash-table :size 1000 :synchronized t)))
    (lparallel:pmapc
     (lambda (bus)
       (alexandria:when-let (prediction (car (get-cta-data "getpredictions"
                                                           :xpath "bustime-response/prd"
                                                           :callback 'xml->prediction
                                                           :parameters `(:vid ,(princ-to-string (id bus))
                                                                              :top "1"))))
         (setf (gethash (bus prediction) predictions) prediction)))
     buses)
    predictions))


