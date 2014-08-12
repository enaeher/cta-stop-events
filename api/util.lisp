(in-package :cta.api)

(defun process-cta-data (xml &key (callback #'identity) (xpath "/"))
  (xpath:map-node-set->list
   (lambda (node) (funcall callback node))  
   (xpath:evaluate xpath (%parse-xml-from-stream xml))))

(defun %get-stream-from-api (uri parameters)
  (handler-case
      (drakma:http-request uri
                           :parameters parameters
                           :want-stream t)
    (error (e)
      (log:write-log :err (format nil "Error requesting ~A: ~A" uri e)))))

(defun %parse-xml-from-stream (stream)
  (handler-case
      (cxml:parse stream (cxml-dom:make-dom-builder))
    (error (e)
        (log:write-log :err (format nil "Error parsing XML: ~A" e)))))

(defun retrieve-cta-data (name &key parameters)
  (let* ((base-uri (concatenate 'string *bus-api-base-uri* name))
         (parameters (cons (cons "key" *bus-api-key*)
                           (loop for (key value) on parameters by #'cddr
                              collecting (cons (string-downcase key) value))))
         (final-uri (concatenate 'string base-uri "?" (drakma::alist-to-url-encoded-string parameters :utf8 'drakma:url-encode))))
    (log:write-log :debug final-uri)
    (%get-stream-from-api base-uri parameters)))

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
