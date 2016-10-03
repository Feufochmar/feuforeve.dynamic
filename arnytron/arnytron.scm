(define-module (arnytron arnytron)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (arnytron data greetings)
  #:use-module (ffch markhov)
  #:use-module (ffch random)
  #:export (arnytron generate-citation pick-citation
            date citation reactions
           )
)

;; Citation class
(define-class <citation> (<object>)
  (use-in-generator? #:getter use-in-generator? #:init-keyword #:use-in-generator? #:init-form #f)
  (date #:getter date #:init-keyword #:date #:init-form "")
  (citation #:getter citation #:init-keyword #:citation #:init-form "")
  (reactions #:getter reactions #:init-keyword #:reactions #:init-form (list))
)

;; Arnytron
(define-class <arnytron> (<object>)
  (citations #:getter citations #:init-keyword #:citations #:init-form (vector))
  (citation-map #:getter citations-map #:init-keyword #:citation-map #:init-form (make-hash-table))
  (generator #:getter generator #:init-keyword #:generator #:init-form (markhov-chain 1))
)

;; Constructor
(define-method (arnytron)
  (let* ((generator (markhov-chain 1))
         (tron
           (make <arnytron>
                 #:generator generator
                 #:citations
                   (list->vector
                     (map
                       (lambda (x)
                         (let ((use? (car x))
                               (cite (caddr x)))
                           (if use? (add-example generator (string-split cite #\space)))
                           (make <citation>
                             #:use-in-generator? use?
                             #:date (cadr x)
                             #:citation cite
                             #:reactions (cadddr x))))
                       greetings)))))
    (for-each
      (lambda (x)
        (hash-set! (citations-map tron) (date x) x))
      (vector->list (citations tron)))
    tron))

;; Generate a quote
(define-method (generate-citation (arny <arnytron>))
  (string-join (generate (generator arny)) " "))

;; Generate a quote from a sequence
(define-method (generate-citation (arny <arnytron>) (initial <list>))
  (string-join (generate (generator arny) initial) " "))

;; Pick a citation
(define-method (pick-citation (arny <arnytron>))
  (pick-from (citations arny)))

;; Pick a citation from a date
(define-method (pick-citation (arny <arnytron>) (date <string>))
  (or (hash-ref (citations-map arny) date)
      (pick-from (citations arny))))

