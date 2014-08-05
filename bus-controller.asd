(defsystem :bus-controller
  :license "Public Domain"
  :author "Eli Naeher"
  :description "Controller for reading from the bus tracker API and writing the results to the database"
  :version (:read-file-form "VERSION")
  :depends-on (:bus-api)
  :components ((:module "bus-controller"
                        :components ((:file "package")
                                     (:file "variables" :depends-on ("package"))
                                     (:file "routes-and-stops" :depends-on ("variables"))
                                     (:file "stop-events" :depends-on ("variables"))))))
