;; Markhov chains
(define-module (ffch markhov)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch distribution)
  #:use-module (ffch random)
  #:export (markhov-chain add-example generate
           )
  #:duplicates (merge-generics)
)

;; Markhov chain class
(define-class <markhov-chain> (<object>)
  (next-item-map #:getter next-item-map #:init-form (make-hash-table))
  (order #:getter order #:init-keyword #:order #:init-form 1)
)

;; Constructor method
(define-method (markhov-chain)
  (markhov-chain 1))
(define-method (markhov-chain (order <integer>))
  (make <markhov-chain> #:order order))

;; Add example to the chain
(define-method (add-example (generator <markhov-chain>) (example <pair>))
  (letrec
    ((fill
        (lambda (lst prev)
          (let ((distro (hash-ref (next-item-map generator) prev))
                (next (if (null? lst) #f (car lst))))
            (if distro
                (add-to-distribution distro next)
                (begin
                  (hash-set! (next-item-map generator) prev (make-distribution))
                  (add-to-distribution (hash-ref (next-item-map generator) prev) next)))
            (if next
                (fill (cdr lst) (append (cdr prev) (list next))))
          ))))
    (fill example (make-list (order generator) #f))
  ))

;; Generate a list with an initial sequence, the sequence must be in the next-item-map
(define-method (generate-list (result <list>) (generator <markhov-chain>) (previous <list>))
  (let ((next (pick-from (hash-ref (next-item-map generator) previous))))
    (if (not next)
        (reverse result)
        (generate-list (cons next result) generator (append (cdr previous) (list next))))))

;; Generate a list from the chains
(define-method (generate (generator <markhov-chain>))
  (generate-list (list) generator (make-list (order generator) #f)))

;; Get a starting sequence from the given list.
;; Find a sequence suitable for generate-list that is the closest to the given sequence.
(define-method (get-starting-sequence (generator <markhov-chain>) (initial <list>))
  ; return the the given sequence if it is a suitable sequence
  (if (hash-ref (next-item-map generator) initial)
      initial
      (letrec ((score
                 (lambda (result a b)
                   (if (or (null? a) (null? b))
                       result
                       (score (+ result (if (equal? (car a) (car b)) 1 0)) (cdr a) (cdr b))))))
        (caar
          (sort
            (map
              (lambda (lst) (cons lst (score 0 (reverse lst) (reverse initial))))
              (shuffle
                (hash-map->list (lambda (k v) k) (next-item-map generator))))
            (lambda (a b) (> (cdr a) (cdr b))))))))

;; Generate a list from an initial sequence.
(define-method (generate (generator <markhov-chain>) (initial <list>))
  (let ((init (get-starting-sequence generator initial)))
    (generate-list (reverse initial) generator init)))
