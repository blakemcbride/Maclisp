;;; -*- Lisp -*-
;;; Factorial; shows bignums.  (fact 30.) -- note the trailing dot:
;;; Maclisp reads and prints numbers in OCTAL unless told otherwise.

(defun fact (n)
  (cond ((zerop n) 1)
        (t (times n (fact (sub1 n))))))
