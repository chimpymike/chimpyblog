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

