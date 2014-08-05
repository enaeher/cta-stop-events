(in-package :bus-schema)

(defclass stop-direction ()
  ((stop           :col-type integer
                   :initarg :stop
                   :reader stop
                   :documentation "The CTA-provided stop identifier")
   (direction      :col-type string
                   :initarg :direction
                   :reader direction
                   :documentation "The name of a direction available at the given stop."))
  (:metaclass pomo:dao-class)
  (:keys stop direction)
  (:documentation "Associations STOPs with DIRECTIONs. A STOP may
  generally either have one or two directions."))
