;; sxml-html exporter for classes of Article module
(define-module (ffch article-exporters sxml-html)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch article)
  #:export (article->sxml-html)
)

;; Contains only one method article->sxml-html defined for every datatype that make sense in the article structure.

;; Article method
(define-method (article->sxml-html (art <article>))
  (list 'article
    (if (title art) (list 'h1 (title art)) "")
    (next-method)
    (if (or (author art) (date art))
      (list 'footer
        (if (author art)
            (author art)
            "")
        (if (and (author art) (date art))
            " - "
            "")
        (if (date art)
            (date art)
            "")
      ))
  ))

;; Generic methods
(define-method (article->sxml-html (cnt <container-type>))
  (article->sxml-html cnt 1))
(define-method (article->sxml-html (cnt <container-type>) (section-level <integer>))
  (map
    (lambda (x)
      (article->sxml-html x section-level))
    (contents cnt)))

;; Terminals
(define-method (article->sxml-html (cnt <string>) (section-level <integer>))
  cnt)
(define-method (article->sxml-html (cnt <number>) (section-level <integer>))
  cnt)

;; Section
(define-method (article->sxml-html (cnt <section>) (section-level <integer>))
  (list 'section
    (if (title cnt)
      (list
        (cond
         ((eq? 1 section-level) 'h2)
         ((eq? 2 section-level) 'h3)
         ((eq? 3 section-level) 'h4)
         ((eq? 4 section-level) 'h5)
         (#t 'h6))
        (title cnt))
      "")
    (map
      (lambda (x)
        (article->sxml-html x (+ 1 section-level)))
      (contents cnt))))

;; Paragraph
(define-method (article->sxml-html (cnt <paragraph>) (section-level <integer>))
  (list 'p
    (next-method)))

;; Strong
(define-method (article->sxml-html (cnt <strong>) (section-level <integer>))
  (list 'strong
    (next-method)))

;; Emphase
(define-method (article->sxml-html (cnt <emphase>) (section-level <integer>))
  (list 'em
    (next-method)))

;; Deleted
(define-method (article->sxml-html (cnt <deleted>) (section-level <integer>))
  (list 'del
    (next-method)))

;; Inserted
(define-method (article->sxml-html (cnt <inserted>) (section-level <integer>))
  (list 'ins
    (next-method)))

;; Mark
(define-method (article->sxml-html (cnt <mark>) (section-level <integer>))
  (list 'mark
    (next-method)))

;; Hyperlink
(define-method (article->sxml-html (cnt <hyperlink>) (section-level <integer>))
  (list 'a (if (to cnt) (list '@ (list 'href (to cnt))) "")
    (next-method)))

;; Text lists
(define-method (article->sxml-html (cnt <text-list>) (section-level <integer>))
  (list (if (ordered? cnt) 'ol 'ul)
    (map
      (lambda (x)
        (list 'li
          (map (lambda (y) (article->sxml-html y section-level)) x)
        ))
      (contents cnt))))

;; Figure
(define-method (article->sxml-html (cnt <figure>) (section-level <integer>))
  (list 'figure
    (next-method)
    (if (caption cnt)
        (list 'figcaption (caption cnt))
        "")))

;; Code
(define-method (article->sxml-html (cnt <code>) (section-level <integer>))
  (list 'code
    (next-method)))

;; Preformatted
(define-method (article->sxml-html (cnt <preformatted>) (section-level <integer>))
  (list 'pre
    (next-method)))

;; Linefeed
(define-method (article->sxml-html (cnt <linefeed>) (section-level <integer>))
  (list 'br))

;; Image
(define-method (article->sxml-html (cnt <image>) (section-level <integer>))
  (list 'img
    (list '@
      (list 'alt (if (alt cnt) (alt cnt) ""))
      (list 'src (source cnt)))))
