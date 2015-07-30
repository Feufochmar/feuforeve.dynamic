;; Distributions of values
;; Distributions are list of items associated to a number indicating its frequency.
;; When an element is picked from the list, the frequency of the items is taken into account.
(define-module (ffch distribution)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (srfi srfi-1)
  #:export (make-distribution add-to-distribution pick-from)
)

;;;;
;; Class definition
(define-class <distribution> (<object>)
  (total #:accessor total #:init-form 0)
  (lst-items #:accessor lst-items #:init-form (list))
  (items #:getter items #:init-form (make-hash-table))
)

;;;;
;; Consturctors

;; Empty distribution
(define-method (make-distribution)
  (make <distribution>))

;; Distribution from a list of pairs.
;; The first element of a pair is the item and the second is the frequency.
(define-method (make-distribution (dist <pair>))
  (let* ((result (make-distribution))
         (ttl
           (fold
             (lambda (elem prev)
                 (hash-set! (items result) (car elem) (cdr elem))
                 (+ prev (cdr elem)))
             0 dist)))
    (set! (lst-items result) dist)
    (set! (total result) ttl)
    result
  ))

;;;;
;; Add an item to a distribution
(define-method (add-to-distribution (dist <distribution>) itm)
  (let ((occurences (hash-ref (items dist) itm)))
    (if occurences
        (hash-set! (items dist) itm (+ occurences 1))
        (hash-set! (items dist) itm 1))
    (set! (lst-items dist) (hash-map->list (lambda (k v) (cons k v)) (items dist)))
    (set! (total dist) (+ 1 (total dist)))
  ))

;;;;
;; Pick from a distribution
(define-method (pick-from (dist <distribution>))
  (letrec ((search
             (lambda (lst subtotal roll)
               (let ((new-subtotal (+ subtotal (cdar lst))))
                    (if (< roll new-subtotal)
                        (caar lst)
                        (search (cdr lst) new-subtotal roll)))
              )))
    (search
      (lst-items dist)
      0
      (random (total dist)))
  ))
