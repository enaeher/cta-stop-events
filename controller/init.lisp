(in-package :cta.controller)

(defun load-configuration ()
  (log:write-log :info "Loading configuration file")
  (load *config-file*))

(defun init ()
  (log:write-log :info "Initializing chicago-transit")
  (load-configuration)
  (log:write-log :info "Starting Swank listener")
  (swank:create-server)
  (log:write-log :info "Initializing lparallel kernel")
  (setf lparallel:*kernel* (lparallel:make-kernel 10))
  (refresh-routes-and-stops)
  (start))

(defun exit ()
  (log:write-log :info "Shutting down")
  (stop))

(pushnew 'init sb-ext:*init-hooks*)
(pushnew 'exit sb-ext:*exit-hooks*)
