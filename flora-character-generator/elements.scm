;; Floraverse character generator
;; Elements
(define-module (flora-character-generator elements)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (get-element
           )
)

;; Data singleton
(define *data:elements* (make-hash-table))

(define-method (get-element (key <symbol>))
  (hash-ref *data:elements* key))

;; Damta syntax
(define-syntax elements
  (syntax-rules ()
    ((_ (key val) ...)
     (begin
       (hash-set! *data:elements* (quote key) val) ...))))

;; Include the data to fill *data:elements*
(include "data/elements.scm")
