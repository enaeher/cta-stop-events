(defpackage :cta.api.tests
  (:use :common-lisp :cta.api)
  (:import-from :cta.api
                #:process-routes
                #:process-directions
                #:process-stops
                #:process-buses
                #:process-predictions))

(defparameter *sample-responses-directory* (cl-fad:merge-pathnames-as-directory
                                            (asdf/system:system-source-directory :cta)
                                            "api/"
                                            "sample-responses/"))

(defun open-xml (filename)
  (open (cl-fad:merge-pathnames-as-file *sample-responses-directory* filename)
        :element-type '(unsigned-byte 8)
        :external-format :utf8))

(5am:def-suite cta.api)
(5am:in-suite cta.api)

(5am:test process-responses
  "Basic sanity checking: can we successfully parse and process the
sample responses in the API documentation at
http://www.transitchicago.com/assets/1/developer_center/BusTime_Developer_API_Guide.pdf"
  (5am:is (process-routes (open-xml "getroutes.xml")))
  (5am:is (process-directions (open-xml "getdirections.xml")))
  (5am:is (process-stops (open-xml "getstops.xml")))
  (5am:is (process-predictions (open-xml "getpredictions.xml")))
  (5am:is (process-buses (open-xml "getBusesForRouteAll.jsp.xml"))))

