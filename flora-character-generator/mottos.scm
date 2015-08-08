;; Floraverse character generator
;; Mottos
(define-module (flora-character-generator mottos)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch string)
  #:export (pick-motto)
)

(define-class <mottos> (<object>)
  (prefix #:getter prefix #:init-keyword #:prefix #:init-form (vector))
  (prefixable #:getter prefixable #:init-keyword #:prefixable #:init-form (vector))
  (unprefixable #:getter unprefixable #:init-keyword #:unprefixable #:init-form (vector)))

;; Data singleton
(define *data:mottos* (make <mottos>))

(define-method (pick-motto)
  (if (pick-boolean)
      (pick-from (unprefixable *data:mottos*))
      (let ((pfx (pick-from (prefix *data:mottos*)))
            (sfx (pick-from (prefixable *data:mottos*))))
        (string-capitalize-1st (string-append pfx sfx)))))

;; Data syntax
(define-syntax mottos
  (syntax-rules ()
   ((_ (slot val* ...) ...)
    (begin
      (slot-set! *data:mottos* (quote slot) (vector val* ...)) ...
    ))))

;; Include data to fill *data:mottos*
(include "data/mottos.scm")
