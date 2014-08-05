(in-package :cta.schema)

(defclass stop-event ()
  ((stop-time :col-type simple-date:timestamp
              :initarg :stop-time
              :reader stop-time
              :documentation "The (approximate) time of the stop")
   (direction :col-type string
              :initarg :direction
              :reader direction
              :documentation "The direction in which the bus was traveling (East Bound, North Bound, etc.)")
   (stop      :col-type integer
              :initarg :stop
              :reader stop
              :documentation "A foreign key referencing stop.id")
   (bus       :col-type integer
              :initarg :bus
              :reader bus
              :documentation "The ID of the bus making the stop. Currently, we don't store buses so this is not a foreign key.")
   (route     :col-type integer
              :initarg :route
              :reader route
              :documentation "A foreign key referencing route.id"))
  (:metaclass pomo:dao-class)
  (:keys stop-time stop-id route-id direction)
  (:documentation "A BUS-STOP-EVENT records  the time and direction at
  which a given bus on a given route made a stop."))
