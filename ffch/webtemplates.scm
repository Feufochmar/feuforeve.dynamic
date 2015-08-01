;; Webtemplates
(define-module (ffch webtemplates)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch weblets)
  #:use-module (ffch article)
  #:use-module (ffch article-exporters sxml-html)
  #:use-module (sxml simple)
  #:export (templated-weblet
            webtemplate
           )
)

;; Templated weblet
(define (templated-weblet template article-generator)
  (weblet
    ((error-code 200) (content-type "text/html;charset=UTF-8"))
    ((path query port)
     (display "<!DOCTYPE html>\n" port)
     (sxml->xml
       (template (article-generator query))
       port))
  ))

;; Html Metadata
(define-class <html-metadata> (<object>)
  (stylesheets #:getter stylesheets #:init-keyword #:stylesheets #:init-form (list))
  (scripts #:getter scripts #:init-keyword #:scripts #:init-form (list)))

(define-syntax html-metadata
  (syntax-rules ()
    ((_ (slot values* ...) ...)
     (let ((metadata (make <html-metadata>)))
       (begin
         (slot-set! metadata (quote slot) (list values* ...)) ...
       )
       metadata))))

;;
(define-syntax webtemplate
  (syntax-rules (metadata before after)
   ((_ (metadata meta* ...)
       (before-article bfr* ...)
       (after-article aft* ...))
    (let ((meta (html-metadata meta* ...)))
      (lambda (art)
        (list 'html
          (list 'head
            (list 'title (title art))
            (list 'meta (list '@ (list 'charset "UTF-8")))
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
            (map
              (lambda (x)
                (list 'script
                  (list '@
                    (list 'src x)
                  )))
              (scripts meta))
          )
          (list 'body
            (list 'div (list bfr* ...))
            (article->sxml-html art)
            (list 'div (list aft* ...))
          )
        )))
   )))
