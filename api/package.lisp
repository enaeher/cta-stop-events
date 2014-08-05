(in-package :cl-user)

(defpackage :cta.api
  (:use #:cl #:cl-user)
  (:nicknames :api)
  (:export
   #:get-routes
   #:get-stops
   #:get-directions
   #:get-all-current-buses
   #:get-predictions

   #:bus
   #:prediction
   #:prediction-stop
   #:prediction-bus
   #:prediction-direction
   #:prediction-route
   #:prediction-type
   #:prediction-timestamp
   #:prediction-predicted-time))
