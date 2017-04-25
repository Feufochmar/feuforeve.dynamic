;; Distributions of values
;; Distributions are list of items associated to a number indicating its frequency.
;; When an element is picked from the list, the frequency of the items is taken into account.
(define-module (ffch distribution)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (srfi srfi-1)
  #:export (make-distribution add-to-distribution fill-distribution pick-from check-only contains?
            distribution->list)
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
(define-method (add-to-distribution (dist <distribution>) itm (additional-occurences <integer>))
  (let ((occurences (hash-ref (items dist) itm)))
    (if occurences
        (hash-set! (items dist) itm (+ occurences additional-occurences))
        (hash-set! (items dist) itm additional-occurences))
    (set! (lst-items dist) (hash-map->list (lambda (k v) (cons k v)) (items dist)))
    (set! (total dist) (+ additional-occurences (total dist)))
  ))

(define-method (add-to-distribution (dist <distribution>) itm)
  (add-to-distribution dist itm 1))

;;;;
;; Macro to fill a distribution by specifying:
;; - the items of the distribution
;; - a default number of occurences for every item
;; - the number of occurences for a set of items
(define-syntax fill-distribution
  (syntax-rules (*)
    ((_ distro item-list (* default-occurences))
     (let ((h (make-hash-table)))
       (map
         (lambda (x) (hash-set! h x default-occurences))
         item-list)
       (hash-map->list (lambda (k v) (add-to-distribution distro k v)) h)))
    ((_ distro item-list (* default-occurences) (itm occurences) ...)
     (let ((h (make-hash-table)))
       (map
         (lambda (x) (hash-set! h x default-occurences))
         item-list)
       (begin
         (hash-set! h (quote itm) occurences) ...)
       (hash-map->list (lambda (k v) (add-to-distribution distro k v)) h)))
    ((_ distro item-list (itm occurences) ...)
     (fill-distribution distro item-list (* 0) (itm occurences) ...))))

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

;;;;
;; Check that the items of the distribution are only in the list of the given items
(define-method (check-only (dist <distribution>) (lst <pair>))
  (hash-map->list
    (lambda (k v)
      (if (not (member k lst))
          (error "Distribution contains an unknown item: " k)))
    (items dist)))

;;;;
;; Check if an item is in the distribution
(define-method (contains? itm (dist <distribution>))
  (member itm (hash-map->list (lambda (k v) k) (items dist))))

;;;;
;; Transform a distribution to a list
;; Takes a procedure of 2 arguments to transform the distribution into a list, like a map
;;  - the first argument is an item of the distribution
;;  - the second argument is the occurence
(define-method (distribution->list (proc <procedure>) (dist <distribution>))
  (map (lambda (x) (proc (car x) (cdr x))) (lst-items dist)))
