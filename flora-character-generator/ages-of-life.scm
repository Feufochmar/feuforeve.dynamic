;; Floraverse character generator
;; Ages of life
(define-module (flora-character-generator ages-of-life)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:export (<age-of-life> description can-have-pet?
            pick-profession pick-nb-partners-children
            ;
            get-age-of-life ages-of-life-keys
           )
  #:duplicates (merge-generics))

;;
(define-class <age-of-life> (<object>)
  (description #:getter description #:init-keyword #:descriprion #:init-form "")
  (professions #:getter professions #:init-keyword #:professions #:init-form (vector))
  (can-have-pet? #:getter can-have-pet? #:init-keyword #:can-have-pet? #:init-form #f)
  (max-nb-partners #:getter max-nb-partners #:init-keyword #:max-nb-partners #:init-form 0)
  (max-children-by-partner #:getter max-children-by-partner #:init-keyword #:max-children-by-partner #:init-form 0))

;;
(define-method (pick-profession (age <age-of-life>))
  (if (< 0 (vector-length (professions age)))
      (pick-from (professions age))
      #f))

(define-method (pick-nb-partners-children (age <age-of-life>))
  (map
    (lambda (x) (random (+ 1 (max-children-by-partner age))))
    (make-list (random (+ 1 (max-nb-partners age))) #f)))

;; Data singleton
(define *data:ages-of-life* (make-hash-table))

;;
(define-method (get-age-of-life (key <symbol>))
  (hash-ref *data:ages-of-life* key))

(define-method (ages-of-life-keys)
  (hash-map->list (lambda (k v) k) *data:ages-of-life*))

;; Data syntax
(define-syntax ages-of-life
  (syntax-rules (professions from-other-ages)
    ((_ (key (slot value) ... (profession (from-other-ages ages* ...) prof* ...)) ...)
     (let ((professions-of-age (make-hash-table)))
       (let ((age (make <age-of-life>))
             (initial-professions (list prof* ...)))
         (begin (slot-set! age (quote slot) value) ...)
         (hash-set! professions-of-age (quote key) initial-professions)
         (slot-set! age (quote professions)
           (list->vector
             (append
               (apply append
                 (map
                   (lambda (x) (hash-ref professions-of-age x))
                   (list (quote ages*) ...)))
               initial-professions)))
         (hash-set! *data:ages-of-life* (quote key) age)) ...))))

;; Include data to fill *data:ages-of-life*
(include "data/ages-of-life.scm")
