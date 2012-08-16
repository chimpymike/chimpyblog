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
  (mapcar #'create-view-from-class '(post user)))

(defun drop-tables ()
  (mapcar #'drop-view-from-class '(post user)))


