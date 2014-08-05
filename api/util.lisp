(in-package :cta.api)

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
  (ppcre:register-groups-bind (('parse-integer year)
                               ('parse-integer month)
                               ('parse-integer day)
                               ('parse-integer hour)
                               ('parse-integer minute))
      ("(\\d{4})(\\d{2})(\\d{2}) (\\d{2}):(\\d{2})" (xpath->string node xpath) :sharedp t)
    (simple-date:encode-timestamp year month day hour minute)))

;; GROUP is borrowed from Paul Graham's On Lisp by way of
;; http://lisp-univ-etc.blogspot.com/2013/01/real-list-comprehensions-in-lisp.html

(defun group (n list)
  "Split LIST into a list of lists of length N."
  (declare (integer n))
  (when (zerop n)
    (error "Group length N shouldn't be zero."))
  (labels ((rec (src acc)
             (let ((rest (nthcdr n src)))
               (if (consp rest)
                   (rec rest (cons (subseq src 0 n) acc))
                   (nreverse (cons src acc))))))
    (when list
            (rec list nil))))
