(in-package :cta.schema)

(defclass stop-route-direction ()
  ((id             :col-type integer
                   :reader id
                   :documentation "Synthetic SERIAL key")
   (stop           :col-type integer
                   :initarg :stop
                   :reader stop
                   :documentation "The CTA-provided stop identifier")
   (route          :col-type string
                   :initarg :route
                   :reader route
                   :documentation "The ID of a route which stops at this stop")
   (direction      :col-type string
                   :initarg :direction
                   :reader direction
                   :documentation "The name of a direction available at the given stop"))
  (:metaclass pomo:dao-class)
  (:keys id)
  (:documentation "Associations STOPs with ROUTEs and DIRECTIONs. A
  STOP may have any number of ROUTEs, and generally has either one or
  two DIRECTIONs per ROUTE."))

(defun get-stop-route-direction-id (stop-id route-id direction)
  (pomo:query (:select 'id :from 'stop-route-direction :where (:and (:= 'stop stop-id)
                                                                    (:= 'route route-id)
                                                                    (:= 'direction direction)))
              :single))
