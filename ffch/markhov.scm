;; Markhov chains
(define-module (ffch markhov)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch distribution)
  #:export (markhov-chain add-example generate
           )
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

;; Generate a list from the chains
(define-method (generate (generator <markhov-chain>))
  (letrec
    ((pick-list
      (lambda (result prev)
        (let ((next (pick-from (hash-ref (next-item-map generator) prev))))
          (if (not next)
              (reverse result)
              (pick-list (cons next result) (append (cdr prev) (list next))))
        ))))
    (pick-list (list) (make-list (order generator) #f))
  ))
