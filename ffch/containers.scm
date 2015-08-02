;; Generic container-type and content-type, for usage in tree-like structures
;; Those classes should be derived.
(define-module (ffch containers)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (<container-type> <content-type>
            id style-class contents
            container-type-constructor
           )
)

;; Generic container. Contains a list of elements
(define-class <container-type> (<object>)
  (contents #:getter contents #:init-keyword #:contents #:init-form (list)))

;; Generic content
(define-class <content-type> (<object>)
  (id #:getter id #:init-keyword #:id #:init-form #f)
  (style-class #:getter style-class #:init-keyword #:style-class #:init-form #f))

;; Generic macro to build container types
(define-syntax container-type-constructor
  (syntax-rules ()
   ((_ identifier type)
    (define-syntax identifier
      (with-ellipsis ---
        (syntax-rules ()
         ((_ ((param value) ---) elem* ---)
          (let ((result (make type #:contents (list elem* ---))))
            (begin
              (slot-set! result (quote param) value) ---
            )
            result
          )
         )
         ((_ elem* ---)
          (make type #:contents (list elem* ---))
         )
        ))))))

;; Generic macro to build content types
(define-syntax content-type-constructor
  (syntax-rules ()
   ((_ identifier type)
    (define-syntax identifier
      (with-ellipsis ---
        (syntax-rules ()
          ((_ (slot value) ---)
           (let ((result (make type)))
             (begin
               (slot-set! result (quote slot) value) ---
             )
             result
           )
          )
        ))))))
