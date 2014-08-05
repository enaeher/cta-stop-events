(in-package :bus-api)

(defparameter *syslog-identifier* "bus-api")

(defparameter *bus-api-base-uri* "http://ctabustracker.com/bustime/api/v1/"
  "The base URI for constructing CTA API queries")

(defparameter *bus-api-key* "BU29sQYfFfer4NeKiwFdS2Tcz")

(defparameter *route-directions* '("North Bound" "South Bound" "East Bound" "West Bound"))

(defparameter *cta-server-stream* nil
  "Holds the HTTP stream which is reused for the individual bus prediction requests and bound by WITH-CTA-STREAM.")
