(in-package :bus-schema)

(defclass stop ()
  ((id             :col-type string
                   :initarg :id
                   :reader id
                   :documentation "The CTA-provided stop identifier")
   (route-id       :col-type string
                   :initarg :route-id
                   :reader %route-id
                   :documentation "A foreign key referencing route.id")
   (direction      :col-type string
                   :initarg :direction
                   :reader direction
                   :documentation "A direction name")
   (latitude       :col-type decimal
                   :initarg :latitude
                   :reader latitude
                   :documentation "A WGS 84 latitude in decimal degrees")
   (longitude      :col-type decimal
                   :initarg :longitude
                   :reader longitude
                   :documentation "A WGS 84 longitude in decimal degrees")
   (name           :col-type string
                   :initarg :name
                   :reader name
                   :documentation "The name of the stop (e.g., the nearest intersection)"))
  (:metaclass pomo:dao-class)
  (:keys id)
  (:documentation "A STOP is a location along a given route at which a
  bus stops while traveling in a given direction. Physical stops at
  which multiple routes stop are represented in the database by one
  STOP per route."))
