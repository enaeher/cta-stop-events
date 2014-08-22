(in-package :cta.controller)

(defun maybe-make-stop-route-direction (stop route direction)
  (unless (schema:get-stop-route-direction-id (schema:id stop)
                                              (schema:id route)
                                              direction)
    (pomo:insert-dao (make-instance 'schema:stop-route-direction
                                    :stop (schema:id stop)
                                    :route (schema:id route)
                                    :direction direction))))

(defun refresh-routes-and-stops ()
  "Refresh the 'static' data (routes and stops) from the API and store
the results to the database. Currently this function makes no attempt
to deal with stops that are removed (i.e. stop appearing in the API)."
  (sb-sys:with-interrupts
    (log:write-log :info "Begin refreshing routes and stops")
    (pomo:with-connection *database-connection-spec*
      (dolist (route (api:get-routes))
        (pomo:save-dao route)
        (dolist (direction (api:get-directions route))
          (dolist (stop (api:get-stops route direction))
            (pomo:save-dao stop)
            (maybe-make-stop-route-direction stop route direction)))))
    (pomo:save-dao (make-instance 'schema:event-log :event-type "ROUTES-AND-STOPS"))
    (log:write-log :info "Done refreshing routes and stops")))
