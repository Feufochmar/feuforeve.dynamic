(define-module (arnytron arnytron)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (arnytron greetings)
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
  (generator #:getter generator #:init-keyword #:generator #:init-form (markhov-chain 1))
)

;; Constructor
(define-method (arnytron)
  (let ((generator (markhov-chain 1)))
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
                  #:reactions (cadddr x))
              ))
            greetings))
    )
  ))

;; Generate a quote
(define-method (generate-citation (arny <arnytron>))
  (string-join (generate (generator arny)) " "))

;; Pick a citation
(define-method (pick-citation (arny <arnytron>))
  (pick-from (citations arny)))
