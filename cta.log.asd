(defsystem :cta.log
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Logging"
  :version (:read-file-form "VERSION")
  :depends-on (:cl-syslog)
  :components ((:module "log"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "log" :depends-on ("variables"))))))
