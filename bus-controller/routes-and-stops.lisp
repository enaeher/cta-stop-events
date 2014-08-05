(in-package :bus-controller)

(defun maybe-make-stop-route-direction (stop route direction)
  (let ((dao (make-instance 'schema:stop-route-direction
                            :stop (schema:id stop)
                            :route (schema:id route)
                            :direction direction)))
    (unless (pomo:dao-exists-p dao)
      (pomo:save-dao dao))))

(defun refresh-routes-and-stops ()
  "Refresh the 'static' data (routes and stops) from the API and store
the results to the database. Currently this function makes no attempt
to deal with stops that are removed (i.e. stop appearing in the API)."
  (pomo:with-connection *database-connection-spec*
    (dolist (route (api:get-routes))
      (pomo:save-dao route)
      (dolist (direction (api:get-directions route))
        (dolist (stop (api:get-stops route direction))
          (maybe-make-stop-route-direction stop route direction)
          (pomo:save-dao stop))))))
