;; Generic container-type and content-type, for usage in tree-like structures
;; Those classes should be derived.
(define-module (ffch containers)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (<container-type> <content-type>
            id name-class style contents empty?
            container-type-constructor
            content-type-constructor
            attribute->sxml-attribute
            ;
            <trigger-content-type> on-focus-in on-focus-out on-activate
            on-click on-mouse-down on-mouse-up on-mouse-over on-mouse-move on-mouse-out
           )
)

;; Generic container. Contains a list of elements
(define-class <container-type> (<object>)
  (contents #:getter contents #:init-keyword #:contents #:init-form (list)))

(define-method (empty? (cnt <container-type>))
  (null? (contents cnt)))

;; Generic content
(define-class <content-type> (<object>)
  (id #:getter id #:init-keyword #:id #:init-form #f)
  (name-class #:getter name-class #:init-keyword #:name-class #:init-form #f)
  (style #:getter style #:init-keyword #:style #:init-form #f))

;; Trigger content
(define-class <trigger-content-type> (<content-type>)
  (on-focus-in #:getter on-focus-in #:init-keyword #:on-focus-in #:init-form #f)
  (on-focus-out #:getter on-focus-out #:init-keyword #:on-focus-out #:init-form #f)
  (on-activate #:getter on-activate #:init-keyword #:on-activate #:init-form #f)
  (on-click #:getter on-click #:init-keyword #:on-click #:init-form #f)
  (on-mouse-down #:getter on-mouse-down #:init-keyword #:on-mouse-down #:init-form #f)
  (on-mouse-up #:getter on-mouse-up #:init-keyword #:on-mouse-up #:init-form #f)
  (on-mouse-over #:getter on-mouse-over #:init-keyword #:on-mouse-over #:init-form #f)
  (on-mouse-move #:getter on-mouse-move #:init-keyword #:on-mouse-move #:init-form #f)
  (on-mouse-out #:getter on-mouse-out #:init-keyword #:on-mouse-out #:init-form #f))

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

;; Generic macro for exporting attributes to sxml
(define-syntax attribute->sxml-attribute
  (syntax-rules ()
    ((_ cnt attr-cnt attr-sxml)
     (if (attr-cnt cnt)
        (list (list attr-sxml (attr-cnt cnt)))
        (list)))
    ((_ cnt attr-cnt)
     (attribute->sxml-attribute cnt attr-cnt (quote attr-cnt)))))
