(in-package :cl-user)

(defpackage :bus-api
  (:use #:cl #:cl-user)
  (:nicknames :api)
  (:export
   #:get-routes
   #:get-stops
   #:get-directions
   #:get-all-current-buses
   #:get-predictions
   
   #:stop
   #:prediction
   #:bus
   #:direction
   #:route
   #:prediction-type
   #:prediction-time
   #:predicted-time))
