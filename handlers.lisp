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

(defun check-password (name password)
  (let ((password-bytes (ironclad:ascii-string-to-byte-array password))
	(user (get-user-by-name name)))
    (when user
      (ironclad:pbkdf2-check-password password-bytes (password user)))))

(define-formlet (login-user-form :submit "Login"
				 :general-validation (#'check-password "Bad username or password."))
    ((username text) (password password))
  (let ((user (get-user-by-name username)))
  (setf (session-value :user-id) (id user))
  (redirect "/user")))

(defun login-user-page ()
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:body
      (:h1 "Login")
      (show-formlet login-user-form)))))

(defun user-page ()
  (let* ((user-id (session-value :user-id))
	 (user (get-user-by-id user-id)))
    (if user
	(with-html-output-to-string (*standard-output* nil :indent t :prologue t)
	  (:html
	   (:body
	    (:h1 "Username: " (str (name user))))))
	(with-html-output-to-string (*standard-output nil :indent t :prologue t)
	  (:html
	   (:body
	    (:h1 "Not currently logged in.")
	    (:a :href "/login" "Login")))))))
