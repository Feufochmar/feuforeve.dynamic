;; Forms : for forms elements that could be combined with articles
(define-module (ffch forms)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch containers)
  #:export (; Types
            <button> <text-area>
            ; Getters
            onclick
            ; Construction macros and functions
            button text-area
           )
  #:re-export (<container-type> <content-type>
               id style-class contents
              )
)

;; Button
(define-class <button> (<container-type> <content-type>)
  (onclick #:getter onclick #:init-keyword #:onclick #:init-form #f))

;; Text area
(define-class <text-area> (<container-type> <content-type>))

;; Construction  methods
(container-type-constructor button <button>)
(container-type-constructor text-area <text-area>)
