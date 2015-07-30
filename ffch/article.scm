;; Article : Rich-text document structures
(define-module (ffch article)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:export (; Types
            <container-type> <content-type>
            <article> <section> <paragraph>
            <strong> <emphase> <deleted> <inserted> <mark>
            <hyperlink> <text-list> <linefeed> <image> <figure>
            <code> <preformatted>
            ; Getters
            contents title author date to ordered? caption alt source
            ; Construction macros and functions
            article section paragraph
            strong emphase deleted inserted mark
            hyperlink text-list linefeed image figure
            code preformatted
           )
)

;; Classes for generating rich-text documents
;; See the modules article-export-*** for output formats
;; See also doc for html : <article>, <section>

;; Generic container. Contains a list of elements
(define-class <container-type> (<object>)
  (contents #:getter contents #:init-keyword #:contents #:init-form (list)))

;; Generic content
(define-class <content-type> (<object>))

;; Article : the document with all data
(define-class <article> (<container-type>)
  (title #:getter title #:init-keyword #:title #:init-form #f)
  (author #:getter author #:init-keyword #:author #:init-form #f)
  (date #:getter date #:init-keyword #:date #:init-form #f))

;; Section : a part of the article with a title
(define-class <section> (<container-type> <content-type>)
  (title #:getter title #:init-keyword #:title #:init-form #f))

;; Paragraph : a paragraph
(define-class <paragraph> (<container-type> <content-type>))

;; Strong : to indicate things that are important
(define-class <strong> (<container-type> <content-type>))

;; Emphase : to stress thing in a text
(define-class <emphase> (<container-type> <content-type>))

;; Deleted : to indicate a correction removing something from the document
(define-class <deleted> (<container-type> <content-type>))

;; Inserted : to indicate a correction adding something to the document
(define-class <inserted> (<container-type> <content-type>))

;; Mark : to mark something
(define-class <mark> (<container-type> <content-type>))

;; Hyperlink : a link to another place
(define-class <hyperlink> (<container-type> <content-type>)
  (to #:getter to #:init-keyword #:to #:init-form #f))

;; Text-List : a list of items
;; Note : content of text-list is a list of lists of content-type and not a list of content-type
(define-class <text-list> (<container-type> <content-type>)
  (ordered? #:getter ordered? #:init-keyword #:ordered? #:init-form #f))

;; Figure : an independent block, with an optional caption
(define-class <figure> (<container-type> <content-type>)
  (caption #:getter caption #:init-keyword #:caption #:init-form #f))

;; Code : Indicate an element of code
(define-class <code> (<container-type> <content-type>))

;; Preformatted : a block of preformatted text : all spaces and newlines are kept
(define-class <preformatted> (<container-type> <content-type>))

;;;;
;; Not containers

;; Linefeed : a content-type indicating a line break
(define-class <linefeed> (<content-type>))

;; Image : a content-type to display an image
(define-class <image> (<content-type>)
  (alt #:getter alt #:init-keyword #:alt #:init-form #f) ;; Alternative text
  (source #:getter source #:init-keyword #:source #:init-form #f)) ;; link to image

;;;;
;; Constructor functions and macros
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

(container-type-constructor article <article>)
(container-type-constructor section <section>)
(container-type-constructor paragraph <paragraph>)
(container-type-constructor strong <strong>)
(container-type-constructor emphase <emphase>)
(container-type-constructor deleted <deleted>)
(container-type-constructor inserted <inserted>)
(container-type-constructor mark <mark>)
(container-type-constructor hyperlink <hyperlink>)
(container-type-constructor figure <figure>)
(container-type-constructor code <code>)
(container-type-constructor preformatted <preformatted>)

;; Text-list use a different syntax because of its list of contents
(define-syntax text-list
  (syntax-rules ()
    ((_ ((param value) ...) (elem* ...) ...)
     (let ((result (make <text-list> #:contents (list (list elem* ...) ...))))
        (begin
          (slot-set! result (quote param) value) ...
        )
        result
     )
    )
    ((_ (elem* ...) ...)
     (make <text-list> #:contents (list (list elem* ...) ...))
    )))

(define-method (linefeed)
  (make <linefeed>))

(define-syntax image
  (syntax-rules ()
    ((_ ((param value) ...) source)
     (let ((result (make <image> #:source source)))
        (begin
          (slot-set! result (quote param) value) ...
        )
        result
     )
    )
    ((_ source)
     (make <image> #:source source)
    )))
