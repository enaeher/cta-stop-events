(in-package :cta.controller)

(defparameter *routes-and-stops-timer* (trivial-timers:make-timer 'refresh-routes-and-stops
                                                                  :thread t
                                                                  :name "Refresh all routes and stops"))

(defparameter *stop-events-timer* (trivial-timers:make-timer 'generate-stop-events
                                                             :thread t
                                                             :name "Generate and store stop events"))
