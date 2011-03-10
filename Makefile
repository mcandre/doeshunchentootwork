EXECUTABLE=doeshunchentootwork

all: doeshunchentootwork.lisp
	ccl -l makefile.lisp

clean:
	rm $(EXECUTABLE)
	rm *.*fsl
