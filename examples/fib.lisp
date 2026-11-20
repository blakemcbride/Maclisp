;;; -*- Lisp -*-
;;; Naive Fibonacci.  Try it interpreted, then compile it with
;;;   :complr lisper;fib lisp
;;; and load LISPER;FIB FASL to see the difference in (runtime).

(defun fib (n)
  (cond ((lessp n 2) n)
        (t (plus (fib (difference n 1)) (fib (difference n 2))))))
