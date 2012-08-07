;;;; package.lisp

(defpackage #:chimpyblog
  (:use #:cl #:hunchentoot #:cl-who #:formlets #:clsql)
  (:shadowing-import-from :clsql :select))

