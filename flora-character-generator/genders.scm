;; Floraverse character generator
;; Genders
(define-module (flora-character-generator genders)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (<gender>
            key title-short title-full subject-pronoun object-pronoun genitive-adjective reflexive-pronoun plural?
            ;
            get-gender gender-keys
           )
  #:duplicates (merge-generics))

;; Gender class
(define-class <gender> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (title-short #:getter title-short #:init-keyword #:title-short #:init-form "")
  (title-full #:getter title-full #:init-keyword #:title-full #:init-form "")
  (subject-pronoun #:getter subject-pronoun #:init-keyword #:subject-pronoun #:init-form "")
  (object-pronoun #:getter object-pronoun #:init-keyword #:object-pronoun #:init-form "")
  (genitive-adjective #:getter genitive-adjective #:init-keyword #:genitive-adjective #:init-form "")
  (reflexive-pronoun #:getter reflexive-pronoun #:init-keyword #:reflexive-pronoun #:init-form "")
  (number #:getter number #:init-keyword #:number #:init-form #:singular)) ;; keyword among: #:singular  #:plural

(define-method (plural? (gen <gender>))
  (eq? #:plural (number gen)))

;; Data singleton
(define *data:genders* (make-hash-table))

(define-method (get-gender (key <symbol>))
  (hash-ref *data:genders* key))

(define-method (gender-keys)
  (hash-map->list (lambda (k v) k) *data:genders*))

;; Data syntax
(define-syntax genders
  (syntax-rules ()
    ((_ (key (slot value) ...) ...)
     (begin
       (let ((gen (make <gender> #:key (quote key))))
         (begin (slot-set! gen (quote slot) value) ...)
         (hash-set! *data:genders* (quote key) gen)) ...))))

;; Include the data to fill *data:genders*
(include "data/genders.scm")
