;; Floraverse character generator
;; Natures
(define-module (flora-character-generator natures)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (srfi srfi-1)
  #:export (pick-natures)
)

(define-class <natures> (<object>)
  (table #:getter table #:init-keyword #:table #:init-form (vector)))

(define-method (pick-nature (nat <natures>))
  (pick-from (pick-from (table nat))))

;; Data singleton
(define *data:natures* (make <natures>))

(define-method (pick-natures (N <number>))
  (delete-duplicates (map (lambda (x) (pick-nature *data:natures*)) (make-list N #f))))

;; Data syntax
(define-syntax natures
  (syntax-rules ()
   ((_ (cat elem* ...) ...)
    (slot-set! *data:natures* (quote table) (vector (vector cat elem* ...) ...)))))

;; Include the data to fill *data:natures*
(include "data/natures.scm")
