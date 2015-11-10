;; Floraverse character generator
;; Elements
(define-module (flora-character-generator elements)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (<element> name key pick-main-hue
            get-element element-keys
           )
)

(define-class <element> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (name #:getter name #:init-keyword #:name #:init-form ""))

(define-method (pick-main-hue (elem <element>))
  (random 360))

;; Data singleton
(define *data:elements* (make-hash-table))

(define-method (get-element (key <symbol>))
  (hash-ref *data:elements* key))

(define-method (element-keys)
  (hash-map->list (lambda (k v) k) *data:elements*))

;; Damta syntax
(define-syntax elements
  (syntax-rules ()
    ((_ (key val) ...)
     (begin
       (hash-set! *data:elements* (quote key) (make <element> #:key (quote key) #:name val)) ...))))

;; Include the data to fill *data:elements*
(include "data/elements.scm")
