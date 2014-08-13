(in-package :cta.controller)

(defun load-configuration ()
  (log:write-log :info "Loading configuration file")
  (load (merge-pathnames sb-ext:*core-pathname* *config-file*)))

(defun init ()
  (log:write-log :info "Initializing chicago-transit")
  (load-configuration)
  (log:write-log :info "Starting Swank listener")
  (swank:create-server)
  (log:write-log :info "Initializing lparallel kernel")
  (setf lparallel:*kernel* (lparallel:make-kernel 10))
  (start))

(defun exit ()
  (log:write-log :info "Shutting down")
  (stop))

(pushnew 'init sb-ext:*init-hooks*)
(pushnew 'exit sb-ext:*exit-hooks*)
