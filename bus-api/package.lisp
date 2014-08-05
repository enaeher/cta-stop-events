(in-package :cl-user)

(defpackage :bus-api
  (:use #:cl #:cl-user)
  (:export
   #:get-routes
   #:get-stops
   #:get-directions
   #:get-all-current-buses
   #:get-bus-prediction))
