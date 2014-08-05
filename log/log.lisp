(in-package :cta.log)

(defun write-log (level &rest args)
  (unless (and (eql level :debug)
               (not (member :debug *features*)))
    (syslog:log *syslog-identifier* :local7 level (apply 'format (cons nil args)))))
