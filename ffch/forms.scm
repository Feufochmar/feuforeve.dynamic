;; Forms : for forms elements that could be combined with articles
(define-module (ffch forms)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch containers)
  #:export (; Types
            <form> <label>
            <form-content-type> <button> <text-area>
            <input-content-type> <selector> <submit-button> <checkbox> <text-input>
            ; Getters
            submit-action submit-method name onclick size value checked for
            ; Construction macros and functions
            form button text-area selector submit-button checkbox label text-input
           )
  #:re-export (<container-type> <content-type>
               id name-class style contents empty?
               attribute->sxml-attribute
              )
)

;; Form
(define-class <form> (<container-type> <content-type>)
  (submit-action #:getter submit-action #:init-keyword #:submit-action #:init-form #f)
  (submit-method #:getter submit-method #:init-keyword #:submit-method #:init-form #f))

;; Label for a form item
(define-class <label> (<container-type> <content-type>)
  (for #:getter for #:init-keyword #:for #:init-form #f))

;; In a form, every element have a name
(define-class <form-content-type> (<content-type>)
  (name #:getter name #:init-keyword #:name #:init-form #f))

;; Button
(define-class <button> (<container-type> <form-content-type>)
  (onclick #:getter onclick #:init-keyword #:onclick #:init-form #f))

;; Text area
(define-class <text-area> (<container-type> <form-content-type>))

;; Selector
(define-class <selector> (<container-type> <form-content-type>)
  (size #:getter size #:init-keyword #:size #:init-form 0))

;; Input elements
(define-class <input-content-type> (<form-content-type>)
  (value #:getter value #:init-keyword #:value #:init-form #f))

;; Submit button
(define-class <submit-button> (<input-content-type>))

;; Checkbox
(define-class <checkbox> (<input-content-type>)
  (checked #:getter checked #:init-keyword #:checked #:init-form #f))

;; Text input
(define-class <text-input> (<input-content-type>))

;; Construction  methods
(container-type-constructor form <form>)
(container-type-constructor label <label>)
(container-type-constructor button <button>)
(container-type-constructor text-area <text-area>)
(content-type-constructor submit-button <submit-button>)
(content-type-constructor checkbox <checkbox>)
(content-type-constructor text-input <text-input>)

;; Text-list use a different syntax because of its list of contents
(define-syntax selector
  (syntax-rules ()
    ((_ ((param value) ...) lst-cons)
     (let ((result (selector lst-cons)))
        (begin
          (slot-set! result (quote param) value) ...)
        result))
    ((_ ((param value) ...) (option-key option-text) ...)
     (let ((result (selector (option-key option-text) ...)))
        (begin
          (slot-set! result (quote param) value) ...)
        result))
    ((_ (option-key option-text) ...)
     (make <selector> #:contents (list (cons option-key option-text) ...)))
    ((_ lst-cons)
     (make <selector> #:contents lst-cons))
  ))
