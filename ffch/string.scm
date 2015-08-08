;; Diverse utilitary functions dealing with strings
(define-module (ffch string)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (string-capitalize-1st)
)

(define-method (string-capitalize-1st (str <string>))
  (if (string-null? str)
      ""
      (string-titlecase str 0 1)))
