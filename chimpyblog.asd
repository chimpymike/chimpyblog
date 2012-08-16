;;;; chimpyblog.asd

(asdf:defsystem #:chimpyblog
  :serial t
  :description "A blog that thinks it's a CMS"
  :author "Chimpymike <chimpymike@gmail.com>"
  :license "Specify license here"
  :depends-on (#:hunchentoot
               #:cl-who
               #:formlets
               #:clsql
	       #:ironclad)
  :components ((:file "package")
	       (:file "model")
	       (:file "handlers")
               (:file "chimpyblog")))

