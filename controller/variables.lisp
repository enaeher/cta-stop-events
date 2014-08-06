(in-package :cta.controller)

(defparameter *database-connection-spec* '("cta" "eli" "" "localhost") "(<dbname> <username> <password> <host>)")

(defparameter *previous-predictions* nil "Bound to the last set of predictions retrieved.")
