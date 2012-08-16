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

(defun make-slug-from-title (title)
  (string-trim "-" (cl-ppcre:regex-replace-all "[^a-z0-9-]+" (string-downcase title) "-")))

(define-formlet (add-post-form)
    ((title text) (body textarea))
  (let* ((slug (make-slug-from-title title))
	 (new-post (make-instance 'post :title title :body body :slug slug)))
    (update-records-from-instance new-post)
    (redirect (concatenate 'string "/" slug))))

(defun add-post-page ()
  (cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:body
      (:h1 "Add new post")
      (show-formlet add-post-form)))))

(defun hash-password (password)
  (let ((password-bytes (ironclad:ascii-string-to-byte-array password)))
    (ironclad:pbkdf2-hash-password-to-combined-string password-bytes)))

(define-formlet (add-user-form)
    ((email text) (name text) (password password)
     (confirm-password password :validation ((same-as? "password") "Passwords do not match.")))
  (let* ((hashed-password (hash-password password))
	 (new-user (make-instance 'user :email email :name name :password hashed-password)))
    (update-records-from-instance new-user)
    (redirect "/")))

(defun add-user-page ()
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:body
      (:h1 "Add new user")
      (show-formlet add-user-form)))))
