;;;; model.lisp

(in-package #:chimpyblog)

(file-enable-sql-reader-syntax)

;;;; Post
(def-view-class post ()
  ((id
    :accessor id :initarg :id :type integer
    :db-constraints (:not-null :auto-increment) :db-kind :key)
   (slug
    :accessor slug :initarg :slug :type string)
   (title
    :accessor title :initarg :title :type string)
   (body
    :accessor body :initarg :body :type string)))

(defun get-post-by-slug (slug)
  (caar (select 'post :where [= [slot-value 'post 'slug] slug])))

(defun get-all-posts ()
  (select 'post :flatp t))

(defmethod perma-link ((post post))
  (let ((post-link (concatenate 'string "/" (slug post)))
	(post-title (title post)))
    (with-html-output (*standard-output* nil :indent t)
      (:h2 (:a :href post-link (str post-title))))))

;;;; User
(def-view-class user ()
  ((id
    :accessor id :initarg :id :type integer
    :db-constraints (:not-null :auto-increment) :db-kind :key)
   (email
    :accessor email :initarg :email :type string)
   (name
    :accessor name :initarg :name :type string)
   (password
    :accessor password :initarg :password :type string))
  (:base-table chimpyblog-user))

(defun get-user-by-name (name)
  (caar (select 'user :where [= [slot-value 'user 'name] name])))

(defun get-user-by-id (id)
  (caar (select 'user :where [= [slot-value 'user 'id] id])))