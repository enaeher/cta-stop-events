(in-package :bus-api)

(defun get-routes ()
  (let ((routes (get-cta-data "getroutes" 
                       :xpath "bustime-response/route"
                       :callback 'xml->route)))
    (write-log :info "getroutes returned ~d routes" (length routes))
    routes))

(defun xml->route (node)
  (make-instance 'schema:route
                 :id  (xpath->string node "rt")
                 :name (xpath->string node "rtnm")))

(defun get-directions (route)
  (get-cta-data "getdirections"
                :xpath "bustime-response/dir"
                :callback 'xpath:string-value
                :parameters `(:rt ,(schema:id route))))

(defun get-stops (route direction)
  (get-cta-data "getstops"
                :xpath "bustime-response/stop"
                :callback 'xml->stop
                :parameters `(:rt ,(schema:id route)
                                  :dir ,direction)))

(defun xml->stop (node)
  (make-instance 'schema:stop
                 :id (xpath->number node "stpid")
                 :name (xpath->string node "stpnm")
                 :latitude (xpath->number node "lat")
                 :longitude (xpath->number node "lon")))

(defun get-vehicles ()
  (get-cta-data "getvehicles"
                :xpath "bustime-response/vehicle"
                :callback 'xml->bus))

(defun get-all-current-buses ()
  "The current, documented version of the API provides no way to get a
list of every bus in one call. Luckily, this undocumented, unsupported
endpoint of the old API will give us the information that we need."
  (let ((*bus-api-base-uri* "http://ctabustracker.com/bustime/"))
    (get-cta-data "map/getBusesForRouteAll.jsp" 
                  :xpath "buses/bus"
                  :callback #'xml->bus)))

(defun xml->bus (node)
  (make-instance 'bus
                 :id (xpath->number node "id")
                 :route (xpath->string node "rt")))
