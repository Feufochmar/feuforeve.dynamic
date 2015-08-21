;; Webtemplates
(define-module (ffch webtemplates)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch weblets)
  #:use-module (ffch article)
  #:use-module (ffch article-exporters sxml-html)
  #:use-module (sxml simple)
  #:export (templated-weblet metadata webtemplate
           )
)

;; Templated weblet
(define (templated-weblet template article-generator)
  (weblet
    ((error-code 200) (content-type "text/html;charset=UTF-8"))
    ((path query port)
     (display "<!DOCTYPE html>\n" port)
     (sxml->xml
       (template path query (article-generator query))
       port))
  ))

;; Html Metadata
(define-class <metadata> (<object>)
  (stylesheets #:getter stylesheets #:init-keyword #:stylesheets #:init-form (list))
  (scripts #:getter scripts #:init-keyword #:scripts #:init-form (list))
  (onload #:getter onload #:init-keyword #:onload #:init-form #f))

(define-syntax metadata
  (syntax-rules ()
    ((_ (slot values* ...) ...)
     (let ((meta (make <metadata>)))
       (begin
         (slot-set! meta (quote slot) (list values* ...)) ...
       )
       meta))))

;;
(define-method (head (meta <metadata>) (art <article>))
  (list 'head
    (list 'title (title art))
    (list 'meta (list '@ (list 'charset "UTF-8")))
    (map
      (lambda (x)
        (list 'script
          (list '@
            (list 'src x)
          ) ""))
      (scripts meta))
    (map
      (lambda (x)
        (list 'link
          (list '@
            (list 'href x)
            (list 'rel "stylesheet")
            (list 'type "text/css")
            (list 'media "all")
          )))
      (stylesheets meta))
  ))

;; Elements before article. In a webtemplate, can be a header or a lambda
(define-method (apply-before (before <applicable>) path query)
  (before path query))
(define-method (apply-before (before <header>) path query)
  before)

;; Elements after article. In a webtemplate, can be a footer or a lambda
(define-method (apply-after (after <applicable>) path query)
  (after path query))
(define-method (apply-after (after <footer>) path query)
  after)

(define-method (webtemplate (meta <metadata>) before after)
  (lambda (path query art)
    (list 'html
      (head meta art)
      (list 'body (if (onload meta) (list '@ (list 'onload (onload meta))) "")
        (article->sxml-html (apply-before before path query))
        (article->sxml-html art)
        (article->sxml-html (apply-after after path query))))))
