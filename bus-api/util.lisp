(in-package :bus-api)

(defun get-cta-data (name &key (callback #'identity) (xpath "/") parameters)
  (xpath:map-node-set->list
   (lambda (node) (funcall callback node))  
   (xpath:evaluate xpath (%cta-api-call name parameters))))

(defun %cta-api-call (name parameters)
  (let* ((base-uri (concatenate 'string *bus-api-base-uri* name))
         (parameters (cons (cons "key" *bus-api-key*)
                           (loop for (key value) on parameters by #'cddr
                              collecting (cons (string-downcase key) value))))
         (final-uri (concatenate 'string base-uri (drakma::alist-to-url-encoded-string parameters :utf8 'drakma:url-encode))))
    (write-log :debug final-uri)
    (cxml:parse 
     (drakma:http-request base-uri
                          :parameters parameters
                          :want-stream t)
     (cxml-dom:make-dom-builder))))

(defun xpath->number (node xpath)
  (xpath:number-value (xpath:evaluate xpath node)))

(defun xpath->string (node xpath)
  (xpath:string-value (xpath:evaluate xpath node)))

(defun xpath->simple-date (node xpath)
  (ppcre:register-groups-bind (year month day hour minute)
      ("(\\d{4})(\\d{2})(\\d{2}) (\\d{2}):(\\d{2})" (xpath->string node xpath) :sharedp t)
    (simple-date:encode-timestamp (parse-integer year)
                                  (parse-integer month)
                                  (parse-integer day)
                                  (parse-integer hour)
                                  (parse-integer minute))))
