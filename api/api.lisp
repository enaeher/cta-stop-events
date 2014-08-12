(in-package :cta.api)

(defun xml->route (node)
  (make-instance 'schema:route
                 :id  (xpath->string node "rt")
                 :name (xpath->string node "rtnm")))

(defun process-routes (routes)
  (process-cta-data routes
                    :xpath "bustime-response/route"
                    :callback 'xml->route))

(defun get-routes ()
  (process-routes (retrieve-cta-data "getroutes")))

(defun process-directions (directions)
  (process-cta-data directions
                    :xpath "bustime-response/dir"
                    :callback 'xpath:string-value))

(defun get-directions (route)
  (process-directions (retrieve-cta-data "getdirections"
                                         :parameters `(:rt ,(schema:id route)))))

(defun xml->stop (node)
  (make-instance 'schema:stop
                 :id (xpath->number node "stpid")
                 :name (xpath->string node "stpnm")
                 :latitude (xpath->number node "lat")
                 :longitude (xpath->number node "lon")))

(defun process-stops (stops)
  (process-cta-data stops
                    :xpath "bustime-response/stop"
                    :callback 'xml->stop))

(defun get-stops (route direction)
  (process-stops (retrieve-cta-data "getstops"
                                    :parameters `(:rt ,(schema:id route) :dir ,direction))))

(defstruct bus
  id
  route)

(defun xml->bus (node)
  (make-bus 
   :id (xpath->number node "id")
   :route (xpath->string node "rt")))

(defun process-buses (buses)
  (process-cta-data buses
                    :xpath "buses/bus"
                    :callback #'xml->bus))

(defun get-all-current-buses ()
  "The current, documented version of the API provides no way to get a
list of every bus in one call. Luckily, this undocumented, unsupported
endpoint of the old API will give us the information that we need."
  (let ((*bus-api-base-uri* "http://ctabustracker.com/bustime/"))
    (process-buses (retrieve-cta-data "map/getBusesForRouteAll.jsp"))))
