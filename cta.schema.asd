(defsystem :cta.schema
  :license "Public Domain"
  :author "Eli Naeher"
  :description "DAO definitions for CTA Bus Tracker API"
  :version (:read-file-form "VERSION")
  :depends-on (:simple-date :local-time :postmodern)
  :components ((:module "schema"
                        :components ((:file "package")
                                     (:file "route" :depends-on ("package"))
                                     (:file "stop" :depends-on ("package"))
                                     (:file "stop-event" :depends-on ("package"))
                                     (:file "stop-route-direction" :depends-on ("package"))
                                     (:file "event-log" :depends-on ("package"))))))
