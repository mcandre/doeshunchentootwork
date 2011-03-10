(asdf:oos 'asdf:load-op 'doeshunchentootwork :verbose nil)

(let ((filename #+windows "doeshunchentootwork.exe" #-windows "doeshunchentootwork"))
	#+clisp (saveinitmem filename :init-function #'doeshunchentootwork:main :executable t :norc t)
	#+sbcl (save-lisp-and-die filename :toplevel #'doeshunchentootwork:main :executable t)
	#+clozure (save-application filename :toplevel-function #'doeshunchentootwork:main :prepend-kernel t))

(quit)