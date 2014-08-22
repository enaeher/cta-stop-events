(in-package :cl-user)

(defpackage :cta.schema
  (:use #:cl #:cl-user)
  (:nicknames :schema)
  (:export
   ;; classes
   #:stop
   #:stop-event
   #:stop-route-direction
   #:route
   #:event-log
   ;; accessors
   #:id
   #:name
   ;; misc
   #:get-stop-route-direction-id
   ))
