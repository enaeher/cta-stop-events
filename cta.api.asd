(defsystem :cta.api
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Methods for accessing the bus tracker API"
  :version (:read-file-form "VERSION")
  :depends-on (:cta.schema :alexandria :cxml :cl-ppcre :drakma :xpath :cl-syslog :lparallel)
  :components ((:module "api"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "util" :depends-on ("variables"))
                                     (:file "log" :depends-on ("util"))
                                     (:file "api" :depends-on ("log"))
                                     (:file "prediction" :depends-on ("log"))))))
