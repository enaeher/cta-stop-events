(in-package :cta.controller)

(defparameter *database-connection-spec* '("cta" "eli" "" "localhost"))

(defparameter *previous-predictions* nil "Bound to the last set of predictions retrieved.")
