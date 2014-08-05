(in-package :cta.schema)

(defclass stop ()
  ((id             :col-type int
                   :initarg :id
                   :reader id
                   :documentation "The CTA-provided stop identifier")
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
