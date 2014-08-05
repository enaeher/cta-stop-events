(in-package :cta.schema)

(defclass route ()
  ((id     :col-type string
           :initarg :id
           :reader id
           :documentation "The route number")
   (name   :col-type string
           :initarg :name
           :reader name
           :documentation "The name of the route"))
  (:metaclass pomo:dao-class)
  (:keys id)
  (:documentation "A ROUTE is a bus route as identified by the Chicago Transit Authority. In particular, express, limited, and A/B variants of the same-numbered route are separate ROUTEs."))
