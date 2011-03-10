(in-package :cl-user)

(defpackage :doeshunchentootwork
  (:use :cl)
  (:export :debug-html :standard-page :defurl :main))

(in-package :doeshunchentootwork)

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
    (:meta :http-equiv "Content-Type" :content "text/html;charset=utf-8")
    (:link :rel "favorites icon" :href "/favicon.ico"))
  (:body :style "text-align: center;"
   (:p (:a :href "https://github.com/mcandre/doeshunchentootwork" "GitHub"))
   (:h1 "Does Hunchentoot Work?")
   ,@body))))

(defmacro defurl (name &body body)
 `(progn (push (hunchentoot:create-prefix-dispatcher ,name (lambda () ,@body)) hunchentoot:*dispatch-table*)))

(defun main ()
  (format t "Loading Hunchentoot~%")

  (format t "Setting content type to UTF-8~%")
  (setf hunchentoot:*default-content-type* "text/html; charset=utf-8")

  (format t "Creating acceptor~%")

  (format t "Starting server~%")

  (hunchentoot:start (make-instance 'hunchentoot:acceptor :port 4242))

  (setq cl-who:*prologue* "<!DOCTYPE html>")

  (format t "Adding index~%")

  (defurl "" (standard-page
   (:title "Does Hunchentoot Work?")
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

  (push (hunchentoot:create-static-file-dispatcher-and-handler "/favicon.ico" "favicon.ico") hunchentoot:*dispatch-table*)

  (format t "Looping...~%")

  (loop))