;; Diverse utilitary functions dealing with randomness
(define-module (ffch random)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (srfi srfi-1)
  #:export (pick-boolean shuffle pick-from hash-ref* hash-key* hash-key-ref*)
)

;;;;
;; Pick a boolean
(define (pick-boolean)
  (eq? 0 (random 2)))

;;;;
;; Shuffle a list
(define-method (shuffle (lst <list>))
  (sort lst (lambda (a b) (pick-boolean))))

;;;;
;; Pick an item from a collection
(define-method (pick-from (vec <vector>))
  (vector-ref vec (random (vector-length vec))))

(define-method (pick-from (lst <list>))
  (pick-from (list->vector lst)))

(define-method (pick-from (hsh <hashtable>))
  (pick-from (hash-map->list (lambda (k v) (cons k v)) hsh)))

;;;;
;; Pick an integer from a range [mn, mx)
(define-method (pick-from (mn <integer>) (mx <integer>))
  (if (eq? mn mx)
      mn
      (+ mn (random (- mx mn)))))

;;;;
;; Take at most n element in a list.
;; If the list has less than n elements, returns the input
;; Else returns the first n elements of the list
;; Note: the take function in guile fails in the first case
(define-method (take-at-most (lst <list>) (n <integer>))
  (letrec ((tam (lambda (in-lst n out-lst)
                  (if (or (null? in-lst) (<= n 0))
                      (reverse out-lst)
                      (tam (cdr in-lst) (- n 1) (cons (car in-lst) out-lst))))))
    (tam lst n (list))))

;;;;
;; Pick given number of items from a collection
(define-method (pick-from (lst <list>) (n <integer>))
  (take-at-most (shuffle lst) n))

(define-method (pick-from (vec <vector>) (n <integer>))
  (list->vector (pick-from (vector->list vec) n)))

(define-method (pick-from (hsh <hashtable>) (n <integer>))
  (pick-from (hash-map->list (lambda (k v) (cons k v)) hsh) n))

;;;;
;; Get an element from a table from its key or a random element if there is no value associated to the key
;; Return #f if the table is empty
(define-method (hash-ref* (hsh <hashtable>) key)
  (let ((ref (hash-ref hsh key)))
    (if ref
        ref
        (let ((lst (hash-map->list (lambda (k v) v) hsh)))
          (if (null? lst)
              #f
              (pick-from lst))))))

;;;;
;; Return the input key if it is associated to a value in the table or a random key if the key is not associated
;; to a value.
;; Return #f if the table is empty
(define-method (hash-key* (hsh <hashtable>) key)
  (let ((ref (hash-ref hsh key)))
    (if ref
        key
        (let ((lst (hash-map->list (lambda (k v) k) hsh)))
          (if (null? lst)
              #f
              (pick-from lst))))))

;;;;
;; Return the couple (key . value) if the input key is associated to a value in the table or a random couple
;; if the key is not associated to a value.
;; Return #f is the table is empty
(define-method (hash-key-ref* (hsh <hashtable>) key)
  (let ((ref (hash-ref hsh key)))
    (if ref
        (cons key ref)
        (let ((lst (hash-map->list (lambda (k v) (cons k v)) hsh)))
          (if (null? lst)
              #f
              (pick-from lst))))))

;;
