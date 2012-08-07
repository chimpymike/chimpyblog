;;;; chimpyblog.lisp

(in-package #:chimpyblog)

;;;; Database utilities
(defun db-create (host db-name username password)
  (create-database (list host db-name username password) :database-type :postgresql))

(defun db-connect (host db-name username password)
  (connect (list host db-name username password) :database-type :postgresql))

(defun create-tables ()
  (mapcar #'create-view-from-class '(post)))

(defun drop-tables ()
  (mapcar #'drop-view-from-class '(post)))

