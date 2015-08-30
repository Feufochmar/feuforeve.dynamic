;; Range of numbers
(define-module (ffch range)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (range)
)

(define-method (range (mn <number>) (mx <number>) (step <number>))
  (letrec ((helper
             (lambda (lst current)
               (if (< current mn)
                   lst
                   (helper (cons current lst) (- current step))))))
    (helper (list) mx)))

(define-method (range (mn <number>) (mx <number>))
  (range mn mx 1))
