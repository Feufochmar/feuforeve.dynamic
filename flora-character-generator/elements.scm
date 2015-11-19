;; Floraverse character generator
;; Elements
(define-module (flora-character-generator elements)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:export (<element> name key pick-main-hue
            get-element element-keys
           )
)

(define-class <element> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (main-hues #:getter main-hues #:init-keyword #:main-hues #:init-form (vector)))

(define-method (pick-main-hue (elem <element>))
  (if (and
        (< 0 (vector-length (main-hues elem)))
        (< 0 (random 10)))
      (modulo (+ 360 (random 20) -10 (pick-from (main-hues elem))) 360)
      (random 360)))

;; Data singleton
(define *data:elements* (make-hash-table))

(define-method (get-element (key <symbol>))
  (hash-ref *data:elements* key))

(define-method (element-keys)
  (hash-map->list (lambda (k v) k) *data:elements*))

;; Damta syntax
(define-syntax elements
  (syntax-rules (hues)
    ((_ (key name (hues h* ...)) ...)
     (begin
       (hash-set!
         *data:elements*
         (quote key)
         (make <element> #:key (quote key) #:name name #:main-hues (vector h* ...))) ...))))

;; Include the data to fill *data:elements*
(include "data/elements.scm")
