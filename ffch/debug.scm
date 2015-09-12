;; Code monitoring functions && syntaxes
(define-module (ffch debug)
  #:version (0 0 1)
  #:export (measure-time
           )
)

;;;;
;; Syntax to measure time taken by a block of instructions
(define-syntax measure-time
  (syntax-rules ()
    ((_ str body* ...)
     (let ((start-time (get-internal-real-time)))
       (let ((result (begin body* ...)))
         (format #t "~a: ~a s\n" str
                 (exact->inexact (/ (- (get-internal-real-time) start-time) internal-time-units-per-second)))
         result)))))
