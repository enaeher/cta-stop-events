(in-package :cta.schema)

(defclass event-log ()
  ((id          :col-type integer
                :documentation "Synthetic key")
   (event-time  :col-type local-time:timestamp
                :initarg :event-time
                :initform (local-time:now)
                :documentation "A timestamp for this event")
   (event-type  :col-type string
                :initarg :event-type
                :documentation "Should be one of ROUTES-AND-STOPS or STOP-EVENTS.")
   (description :col-type string
                :initarg :description
                :documentation "Human-readable description of the event."))
  (:metaclass pomo:dao-class)
  (:keys id)
  (:documentation "Logs each run of the loops (eventually, it should
  be possible to use this data to exclude downtime from our interval
  calculations)."))
