(defsystem :cta.api
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Methods for accessing the bus tracker API"
  :version (:read-file-form "VERSION")
  :depends-on (:cta.log :cta.schema :alexandria :cxml :cl-ppcre :drakma :xpath :lparallel :fiveam)
  :components ((:module "api"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "util" :depends-on ("variables"))
                                     (:file "api" :depends-on ("util"))
                                     (:file "prediction" :depends-on ("util"))
                                     (:file "tests" :depends-on ("prediction"))))))
