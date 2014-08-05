(in-package :cl-user)

(defpackage :bus-schema
  (:use #:cl #:cl-user)
  (:nicknames :schema)
  (:export
   ;; classes
   #:stop
   #:stop-event
   #:stop-direction
   #:route
   ;; accessors
   #:id
   #:name
   ))
