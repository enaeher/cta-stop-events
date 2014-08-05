(defsystem :bus-api
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Methods for accessing the bus tracker API"
  :version (:read-file-form "VERSION")
  :depends-on (:bus-schema :alexandria :cxml :cl-ppcre :drakma :xpath :cl-syslog)
  :components ((:module "bus-api"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "util" :depends-on ("variables"))
                                     (:file "log" :depends-on ("util"))
                                     (:file "bus" :depends-on ("util"))
                                     (:file "api" :depends-on ("log"))
                                     (:file "prediction" :depends-on ("log"))))))
