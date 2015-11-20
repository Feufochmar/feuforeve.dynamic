;; Floraverse character generator
;; Traits
(define-module (flora-character-generator traits)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch string)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator natures)
  #:use-module (flora-character-generator locations)
  #:use-module (flora-character-generator english)
  #:export (pick-traits)
  #:duplicates (merge-generics))

;; Data singletons
(define *data:word-categories* (make-hash-table))
(define *data:traits* (make-hash-table))
(define *data:trait-categories* (list))

;;
(define-method (interpret-token token (gender <gender>) (species <species>))
  (cond
    ((string? token) token)
    ((eq? 'gender:subject token) (subject-pronoun gender))
    ((eq? 'gender:genitive token) (genitive-adjective gender))
    ((eq? 'gender:self token) (reflexive-pronoun gender))
    ((and (pair? token) (eq? 'verb (car token))) (3rd-person-of (cadr token) (plural? gender)))
    ((eq? 'character:species token) (name species))
    ((and (pair? token) (eq? 'pick:category (car token)))
     (pick-from (hash-ref *data:word-categories* (cadr token))))
    ((eq? 'pick:nature token) (car (pick-natures 1)))
    ((eq? 'pick:species:wild token) (name (pick-wild-species)))
    ((eq? 'pick:species:pet token) (name (pick-pet-species)))
    ((eq? 'pick:species:citizen token) (name (pick-character-species)))
    ((eq? 'pick:species:plant token) (name (pick-plant-species)))
    ((eq? 'pick:place token) (name (pick-place)))
    ((and (pair? token) (eq? 'plural (car token)))
     (plural-of (interpret-token (cadr token) gender species)))
    ((and (pair? token) (eq? 'undefined-article (car token)))
     (with-undefined-article (interpret-token (cadr token) gender species)))
    (#t (error "Invalid token: " token))
  ))
;
(define-method (interpret-trait (trait <pair>) (gender <gender>) (species <species>))
  (let ((str-trait (string-join (map (lambda (x) (interpret-token x gender species)) trait) " ")))
    (string-capitalize-1st (string-append str-trait ". "))))

;; Pick a list of traits
(define-method (pick-traits (n <integer>) (gender <gender>) (species <species>))
  (let* ((cats (pick-from *data:trait-categories* n))
         (trts (map (lambda (x) (pick-from (hash-ref *data:traits* x))) cats)))
    (map (lambda (t) (interpret-trait t gender species)) trts)))

;; Data syntax
(define-syntax traits-data
  (syntax-rules (word-categories traits)
    ((_ (word-categories (category-key category-item* ...) ...)
        (traits (trait-category trts* ...) ...))
     (begin
       (begin
         (hash-set! *data:word-categories* (quote category-key) (vector category-item* ...)) ...)
       (begin
         (begin
           (set! *data:trait-categories* (cons (quote trait-category) *data:trait-categories*))
           (hash-set! *data:traits* (quote trait-category) (vector (quote trts*) ...))) ...)))))

;; Include data to fill the singletons
(include "data/traits.scm")
