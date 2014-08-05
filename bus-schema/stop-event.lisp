(in-package :bus-schema)

(defclass stop-event ()
  ((stop-time :col-type simple-date:timestamp
              :initarg :stop-time
              :reader stop-time
              :documentation "The (approximate) time of the stop")
   (direction :col-type string
              :initarg :direction
              :reader direction
              :documentation "The direction in which the bus was traveling (East Bound, North Bound, etc.)")
   (stop-id   :col-type bigint
              :initarg :stop-id
              :reader %stop-id
              :documentation "A foreign key referencing stop.id")
   (bus-id    :col-type bigint
              :initarg :bus-id
              :reader %bus-id
              :documentation "A foreign key referencing bus.id")
   (route-id  :col-type bigint
              :initarg :route-id
              :reader %route-id
              :documentation "A foreign key referencing route.id"))
  (:metaclass pomo:dao-class)
  (:keys stop-time stop-id route-id direction)
  (:documentation "A BUS-STOP-EVENT records  the time and direction at
  which a given bus on a given route made a stop."))
