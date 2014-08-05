(in-package :bus-api)

(defclass prediction ()
  ((type      :initarg :type
              :reader prediction-type)
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
                 :time (xpath->simple-date node "tmstmp")
                 :predicted-time (xpath->simple-date node "prdtm")))

(defun get-predictions-fast (buses)
  "Takes a list of BUSES. Requests all predictions for each group of
  10 buses (the maximum allowed per request by the API). Discards all
  but the first prediction for each bus, which will be the
  earliest (the API documentation guarantees that predictions will be
  returned in ascending order of prdtm), and returns the list of these
  earliest predictions. Destructively modifies BUSES."
  (flet ((get-ten-more ()
           (let (ten)
             (dotimes (i 10)
               (alexandria:when-let (bus (pop buses))
                 (push (id bus) ten)))
             ten)))
    (let ((predictions (loop
                          :for ten := (get-ten-more)
                          :while ten
                          :for all-predictions := (get-cta-data "getpredictions"
                                                                :xpath "bustime-response/prd"
                                                                :callback 'xml->prediction
                                                                :parameters `(:vid ,(format nil "~{~a~^,~}" ten)))
                          :nconcing (loop
                                       :for bus :in ten
                                       :for prediction := (find bus all-predictions :key 'bus)
                                       :when prediction
                                       :collect prediction))))
      (write-log :info "getpredictions (fast) returned ~d predictions" (length predictions))
      predictions)))

(defun get-predictions-slow (buses)
  "Gets predictions for each bus in BUSES one-by-one. This allows us
to use the top parameter to retrieve only the first prediction for
each bus."
  (let ((predictions (loop
                        :for bus :in buses
                        :nconc (get-cta-data "getpredictions"
                                             :xpath "bustime-response/prd"
                                             :callback 'xml->prediction
                                             :parameters `(:vid ,(princ-to-string (id bus))
                                                                :top "1")))))
    (write-log :info "getpredictions (slow) returned ~d predictions" (length predictions))
    predictions))
