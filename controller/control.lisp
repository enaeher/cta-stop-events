(in-package :cta.controller)

(defun start ()
  (log:write-log :info "Starting all timers")
  (let* ((now (local-time:now))
         (midnight (local-time:timestamp-minimize-part now :hour))
         (next-minute (local-time:timestamp-minimize-part now :sec))
         (seconds-per-day 86400)
         (seconds-per-minute 60))   
    (trivial-timers:schedule-timer *routes-and-stops-timer* (local-time:timestamp-to-universal midnight)
                                   :repeat-interval seconds-per-day
                                   :absolute-p t)
    (trivial-timers:schedule-timer *stop-events-timer* (local-time:timestamp-to-universal next-minute)
                                   :repeat-interval seconds-per-minute
                                   :absolute-p t)))

(defun stop ()
  (log:write-log :info "Stopping all timers")
  (trivial-timers:unschedule-timer *routes-and-stops-timer*)
  (trivial-timers:unschedule-timer *stop-events-timer*))

(defun debug-on ()
  (log:write-log :info "Debugging enabled")
  (pushnew :debug *features*)
  (values))

(defun debug-off ()
  (log:write-log :info "Debugging disabled")
  (setf *features* (remove :debug *features*))
  (values))
