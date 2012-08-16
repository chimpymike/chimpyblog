(in-package #:chimpyblog)

(defun home-page-view (posts)
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:body
      (:h1 "Posts")
      (:h2 (:a :href "/add-post" "Add a new post"))
      (:div
       (mapcar #'perma-link posts))))))
