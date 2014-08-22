(in-package :cta.schema)

(defclass stop-event ()
  ((stop-time            :col-type simple-date:timestamp
                         :initarg :stop-time
                         :reader stop-time
                         :documentation "The (approximate) time of the stop")
   (stop-route-direction :col-type integer
                         :initarg :stop-route-direction
                         :reader stop-route-direction
                         :documentation "A foreign key referencing stop_route_direction")
   (bus                  :col-type integer
                         :initarg :bus
                         :reader bus
                         :documentation "The ID of the bus making the
                         stop. Currently, we don't store buses so this
                         is not a foreign key."))
  (:metaclass pomo:dao-class)
  (:keys stop-route-direction stop-time)
  (:documentation "A BUS-STOP-EVENT records  the time and direction at
  which a given bus on a given route made a stop."))
