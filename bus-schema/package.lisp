(in-package :cl-user)

(defpackage :bus-schema
  (:use #:cl #:cl-user)
  (:nicknames :schema)
  (:export
   ;; classes
   #:stop-event
   #:route
   #:stop
   #:activity-log
   ;; accessors
   #:id
   #:direction-name
   #:stop-time
   #:name
   ))
