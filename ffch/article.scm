;; Article : Rich-text document structures
(define-module (ffch article)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch containers)
  #:export (; Types
            <article> <header> <footer> <navigation>
            <section> <paragraph>
            <strong> <emphase> <deleted> <inserted> <mark>
            <hyperlink> <text-list> <linefeed> <image> <figure>
            <code> <preformatted> <embedded-object>
            ; Getters
            title author date to ordered? caption alt source data type
            ; Construction macros and functions
            article header footer navigation
            section paragraph
            strong emphase deleted inserted mark
            hyperlink text-list linefeed image figure
            code preformatted embedded-object
           )
  #:re-export (<container-type> <content-type>
               id name-class style contents empty?
               attribute->sxml-attribute
              )
)

;; Classes for generating rich-text documents
;; See the modules article-export-*** for output formats
;; See also doc for html : <article>, <section>

;; Article : the document with all data
(define-class <article> (<container-type>)
  (title #:getter title #:init-keyword #:title #:init-form #f)
  (author #:getter author #:init-keyword #:author #:init-form #f)
  (date #:getter date #:init-keyword #:date #:init-form #f))

;; Header : something coming first of before an article
(define-class <header> (<container-type> <content-type>))

;; Footer : something coming last or after an article
(define-class <footer> (<container-type> <content-type>))

;; Navigation: something containing links to other places
(define-class <navigation> (<container-type> <content-type>))

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

;; Embedded object: a content-type to display an embedded object element
(define-class <embedded-object> (<content-type>)
  (data #:getter data #:init-keyword #:data #:init-form #f)
  (type #:getter type #:init-keyword #:type #:init-form #f))

;;;;
;; Constructor functions and macros
(container-type-constructor article <article>)
(container-type-constructor header <header>)
(container-type-constructor footer <footer>)
(container-type-constructor navigation <navigation>)
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
(content-type-constructor embedded-object <embedded-object>)

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
