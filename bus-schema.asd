(defsystem :bus-schema
  :license "Public Domain"
  :author "Eli Naeher"
  :description "DAO definitions for CTA Bus Tracker API"
  :version (:read-file-form "VERSION")
  :depends-on (:simple-date :postmodern)
  :components ((:module "bus-schema"
                        :components ((:file "package")
                                     (:file "route" :depends-on ("package"))
                                     (:file "stop" :depends-on ("package"))
                                     (:file "stop-event" :depends-on ("package"))))))
