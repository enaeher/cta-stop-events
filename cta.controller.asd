(defsystem :cta.controller
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Controller for reading from the bus tracker API and writing the results to the database"
  :version (:read-file-form "VERSION")
  :depends-on (:cta.api)
  :components ((:module "controller"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "routes-and-stops" :depends-on ("variables"))
                                     (:file "stop-events" :depends-on ("variables"))))))