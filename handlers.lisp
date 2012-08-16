(in-package #:chimpyblog)

(defun get-slug-from-uri (uri)
  (string-trim '(#\/) uri))

(defun show-post ()
  (let* ((requested-post-slug (get-slug-from-uri (request-uri*)))
	 (requested-post (get-post-by-slug requested-post-slug)))
    (if requested-post
	(progn
	  (with-slots (title body) requested-post
	    (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
	      (:html
	       (:body
		(:h1 (str title))
		(:div :class "body" (str body)))))))
	nil)))
