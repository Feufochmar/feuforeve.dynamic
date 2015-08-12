;; Floraverse character generator
;; Sexes
(define-module (flora-character-generator sexes)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch distribution)
  #:export (<sex> description mother? gender-distribution
            ;
            get-sex
           )
)

;; Sex class
(define-class <sex> (<object>)
  (description #:getter description #:init-keyword #:description #:init-form "")
  (is-mother? #:getter is-mother? #:init-keyword #:is-mother? #:init-form #:maybe) ;; #t, #f or #:maybe
  (gender-distribution #:getter gender-distribution #:init-keyword #:gender-distribution #:init-form #f))

;; Is a mother ?
(define-method (mother? (sex <sex>))
  (if (eq? #:maybe (is-mother? sex))
      (pick-boolean)
      (is-mother? sex)))

;; Data singleton
(define *data:sexes* (make-hash-table))

(define-method (get-sex (key <symbol>))
  (hash-ref *data:sexes* key))

;; Data syntax
(define-syntax sexes
  (syntax-rules (default-gender-distribution)
    ((_ (key (slot value) ... (default-gender-distribution (gender probability) ...)) ...)
     (begin
       (let ((sex (make <sex> #:gender-distribution (make-distribution (list (cons (quote gender) probability) ...)))))
         (begin (slot-set! sex (quote slot) value) ...)
         (hash-set! *data:sexes* (quote key) sex)) ...))))

;; Include data file to fill *data:sexes*
(include "data/sexes.scm")