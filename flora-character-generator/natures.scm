;; Floraverse character generator
;; Natures
(define-module (flora-character-generator natures)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (srfi srfi-1)
  #:export (pick-natures)
)

;; Data singleton
(define *data:natures* (vector))

(define-method (pick-nature)
  (pick-from (pick-from *data:natures*)))

(define-method (pick-natures (N <number>))
  (delete-duplicates (map (lambda (x) (pick-nature)) (make-list N #f))))

;; Data syntax
(define-syntax natures
  (syntax-rules ()
   ((_ (cat elem* ...) ...)
    (set! *data:natures* (vector (vector cat elem* ...) ...)))))

;; Include the data to fill *data:natures*
(include "data/natures.scm")
