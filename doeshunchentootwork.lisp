#!/bin/bash
#|
exec ccl -l $0 ${1+"$@"}
exit
|#

;;; doeshunchentootwork.lisp

(format t "Loading Quicklisp~%")

;;; Hide stupid Quicklisp warnings
(handler-bind ((warning #'muffle-warning))
  ;;; Load Quicklisp.
  (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init))))

(format t "Loading Hunchentoot~%")

;;; Hide stupid warnings from dependencies
(handler-bind ((warning #'muffle-warning))
  ;;; Load dependencies.
  (asdf:oos 'asdf:load-op 'hunchentoot :verbose nil)
  (asdf:oos 'asdf:load-op 'cl-who :verbose nil))

(format t "Setting content type to UTF-8~%")
(setf hunchentoot:*default-content-type* "text/html; charset=utf-8")

(format t "Creating acceptor~%")

(defvar acceptor (make-instance 'hunchentoot:acceptor :port 4242))

(format t "Starting server~%")

(hunchentoot:start acceptor)

(setq cl-who:*prologue* "<!DOCTYPE html>")

(defmacro debug-html (&body body)
`(cl-who:with-html-output-to-string (*standard-output* nil :prologue nil :indent t)
  ,@body))

;;; From Adam Peterson's "Lisp for the Web"
;;; http://www.adampetersen.se/articles/lispweb.htm
(defmacro standard-page ((&key title) &body body)
`(cl-who:with-html-output-to-string (*standard-output* nil :prologue t :indent t)
  (:html
   (:head
    (:title ,title)
    (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8"))
  (:body :style "text-align: center;"
   (:p (:a :href "https://github.com/mcandre/doeshunchentootwork" "GitHub"))
   (:h1 "Does Hunchentoot work?")
   ,@body))))

(defmacro defurl (name &body body)
 `(progn (push (hunchentoot:create-prefix-dispatcher ,name (lambda () ,@body)) hunchentoot:*dispatch-table*)))

(format t "Adding index~%")

(defurl "" (standard-page
 (:title "Does Hunchentoot work?")
 (:p "You betcha!")
 (:h2 "Implementation")
 (:p
  #+abcl "ABCL"
  #+allegro "Allegro CL"
  #+clozure "CCL"
  #+clisp "CLISP"
  #+cmu "CMUCL"
  #+ecl "ECL"
  #+gcl "GCL"
  #+lispworks "LispWorks"
  #+sbcl "SBCL"
  #+wcl "WCL"
  #+xcl "XCL"
  )
 (:h2 "Operating System")
 (:p
  #+darwin "Mac OS X"
  #+linux "Linux"
  #+(and :unix (and (not :darwin) (not :linux))) "Unix"
  #+win32 "Windows"
  #+haiku "Haiku"
  )
 (:h2 "*features*")
 (:p (cl-who:str *features*))))

(format t "Looping~%")

(loop)
