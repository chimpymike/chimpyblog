;;;; chimpyblog.lisp

(in-package #:chimpyblog)

;;;; Server utilities
(defun server-start (&optional (port 4242))
  (start (make-instance 'easy-acceptor :port port)))

;;;; Database utilities
(defun db-create (host db-name username password)
  (create-database (list host db-name username password) :database-type :postgresql))

(defun db-connect (host db-name username password)
  (connect (list host db-name username password) :database-type :postgresql))

(defun create-tables ()
  (mapcar #'create-view-from-class '(post user comment)))

(defun drop-tables (&key owner)
  (mapcar (lambda (table) (drop-view-from-class table :owner owner)) '(post user comment)))

;;;; Hunchentoot dispatchers

(defun post-exists-p (uri)
  (let* ((slug (get-slug-from-uri uri))
	 (post (get-post-by-slug slug)))
    (if post t)))

(defun create-dispatch-table ()
  (setf *dispatch-table*
	(list (lambda (request) (if (post-exists-p (script-name request)) #'show-post))
	      (create-regex-dispatcher "^/$" #'home-page)
	      (create-regex-dispatcher "^/add-user/?$" #'add-user-page)
	      (create-regex-dispatcher "^/add-post/?$" #'add-post-page)
	      (create-regex-dispatcher "^/login/?$" #'login-user-page)
	      (create-regex-dispatcher "^/user/?$" #'user-page)
	      'hunchentoot:dispatch-easy-handlers)))

