(in-package :bus-api)

(defclass bus ()
  ((id    :initarg :id
          :reader id
          :documentation "The vehicle ID")
   (route :initarg :route
          :reader route
          :documentation "The route ID")))
