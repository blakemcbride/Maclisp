;;; -*- Lisp -*-
;;; Late-Maclisp conveniences, all autoloaded on first use:
;;; DEFMACRO and backquote, SETF, LET, LOOP, FORMAT.

(setq base 10. ibase 10. *nopoint t)    ;decimal in, decimal out, no trailing "."

(defmacro square (x)
  `(let ((y ,x)) (* y y)))

(defun squares (n)
  (loop for i from 1 to n collect (square i)))

(defun show (n)
  (format t "~%The first ~D squares are ~S~%" n (squares n)))
