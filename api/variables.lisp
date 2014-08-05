(in-package :cta.api)

(defparameter *bus-api-base-uri* "http://ctabustracker.com/bustime/api/v1/"
  "The base URI for constructing CTA API queries")

(defparameter *bus-api-key* "BU29sQYfFfer4NeKiwFdS2Tcz")

(defparameter *route-directions* '("North Bound" "South Bound" "East Bound" "West Bound"))

(defparameter lparallel:*kernel* (lparallel:make-kernel 20))
