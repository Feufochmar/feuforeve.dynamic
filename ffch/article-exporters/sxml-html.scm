;; sxml-html exporter for classes of Article module
(define-module (ffch article-exporters sxml-html)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:export (article->sxml-html)
  #:duplicates (merge-generics)
)

;; The only method exported is article->sxml-html, defined for every article datatype and in two variants


;; Generic methods
(define-method (article->sxml-html (cnt <container-type>))
  (article->sxml-html cnt 1))
(define-method (article->sxml-html (cnt <container-type>) (section-level <integer>))
  (map
    (lambda (x)
      (article->sxml-html x section-level))
    (contents cnt)))

;; Elements of the attributes list of a container
(define-method (attributes-of (cnt <content-type>))
  (append
    (attribute->sxml-attribute cnt id)
    (attribute->sxml-attribute cnt name-class 'class)
    (attribute->sxml-attribute cnt style 'style)
  ))

;; Elements of the attributes list of a container
(define-method (attributes-of (cnt <trigger-content-type>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt on-focus-in 'onfocusin)
    (attribute->sxml-attribute cnt on-focus-out 'onfocusout)
    (attribute->sxml-attribute cnt on-activate 'onactivate)
    (attribute->sxml-attribute cnt on-click 'onclick)
    (attribute->sxml-attribute cnt on-mouse-down 'onmousedown)
    (attribute->sxml-attribute cnt on-mouse-up 'onmouseup)
    (attribute->sxml-attribute cnt on-mouse-over 'onmouseover)
    (attribute->sxml-attribute cnt on-mouse-move 'onmousemove)
    (attribute->sxml-attribute cnt on-mouse-out 'onmouseout)
  ))

;; Article
(define-method (article->sxml-html (art <article>))
  (list 'article
    (if (title art) (list 'h1 (title art)) "")
    (if (or (author art) (date art))
      (list 'div (list '@ (list 'class "author-date"))
        (if (author art)
            (list 'span (list '@ (list 'class "author")) (author art))
            "")
        (if (and (author art) (date art))
            " - "
            "")
        (if (date art)
            (list 'time (date art))
            "")
      ))
    (next-method)
  ))

;; Header as contained block
(define-method (article->sxml-html (cnt <header>) (section-level <integer>))
  (list
    'header
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Footer as contained block
(define-method (article->sxml-html (cnt <footer>) (section-level <integer>))
  (list
    'footer
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Navigation as contained block
(define-method (article->sxml-html (cnt <navigation>) (section-level <integer>))
  (list
    'nav
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Terminals
(define-method (article->sxml-html (cnt <string>) (section-level <integer>))
  cnt)
(define-method (article->sxml-html (cnt <number>) (section-level <integer>))
  cnt)
(define-method (article->sxml-html (cnt <list>) (section-level <integer>))
  (map (lambda (x) (article->sxml-html x section-level)) cnt))

;; Section
(define-method (article->sxml-html (cnt <section>) (section-level <integer>))
  (list
    'section
    (append (list '@) (attributes-of cnt))
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
  (list
    'p
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Strong
(define-method (article->sxml-html (cnt <strong>) (section-level <integer>))
  (list
    'strong
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Emphase
(define-method (article->sxml-html (cnt <emphase>) (section-level <integer>))
  (list
    'em
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Deleted
(define-method (article->sxml-html (cnt <deleted>) (section-level <integer>))
  (list
    'del
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Inserted
(define-method (article->sxml-html (cnt <inserted>) (section-level <integer>))
  (list
    'ins
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Mark
(define-method (article->sxml-html (cnt <mark>) (section-level <integer>))
  (list
    'mark
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Hyperlink
(define-method (attributes-of (cnt <hyperlink>))
  (append
    (attribute->sxml-attribute cnt to 'href)
    (next-method)))

(define-method (article->sxml-html (cnt <hyperlink>) (section-level <integer>))
  (list
    'a
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Text lists
(define-method (article->sxml-html (cnt <text-list>) (section-level <integer>))
  (list
    (if (ordered? cnt) 'ol 'ul)
    (append (list '@) (attributes-of cnt))
    (map
      (lambda (x)
        (list 'li
          (map (lambda (y) (article->sxml-html y section-level)) x)
        ))
      (contents cnt))))

;; Figure
(define-method (article->sxml-html (cnt <figure>) (section-level <integer>))
  (list
    'figure
    (append (list '@) (attributes-of cnt))
    (next-method)
    (if (caption cnt)
        (list 'figcaption (caption cnt))
        "")))

;; Code
(define-method (article->sxml-html (cnt <code>) (section-level <integer>))
  (list
    'code
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Preformatted
(define-method (article->sxml-html (cnt <preformatted>) (section-level <integer>))
  (list
    'pre
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Linefeed
(define-method (article->sxml-html (cnt <linefeed>) (section-level <integer>))
  (list 'br))

;; Image
(define-method (attributes-of (cnt <image>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt alt)
    (attribute->sxml-attribute cnt source 'src)))

(define-method (article->sxml-html (cnt <image>) (section-level <integer>))
  (list
    'img
    (append (list '@) (attributes-of cnt))))

;; Embedded object
(define-method (attributes-of (cnt <embedded-object>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt data)
    (attribute->sxml-attribute cnt type)))

(define-method (article->sxml-html (cnt <embedded-object>) (section-level <integer>))
  (list
    'object
    (append (list '@) (attributes-of cnt))
    " "))

;; Inline
(define-method (article->sxml-html (cnt <inline>) (section-level <integer>))
  (list
    'span
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Inline
(define-method (article->sxml-html (cnt <block>) (section-level <integer>))
  (list
    'div
    (append (list '@) (attributes-of cnt))
    (next-method)))

;;;;;;
;; Forms elements

;; Form
(define-method (attributes-of (cnt <form>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt submit-action 'action)
    (attribute->sxml-attribute cnt submit-method 'method)))

(define-method (article->sxml-html (cnt <form>) (section-level <integer>))
  (list
    'form
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Label
(define-method (attributes-of (cnt <label>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt for)))

(define-method (article->sxml-html (cnt <label>) (section-level <integer>))
  (list
    'label
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Form content type
(define-method (attributes-of (cnt <form-content-type>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt name)))

;; Button
(define-method (attributes-of (cnt <button>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt onclick)))

(define-method (article->sxml-html (cnt <button>) (section-level <integer>))
  (list
    'button
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Text area
(define-method (article->sxml-html (cnt <text-area>) (section-level <integer>))
  (list
    'textarea
    (append (list '@) (attributes-of cnt))
    (next-method)))

;; Selector
(define-method (attributes-of (cnt <selector>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt size)))

(define-method (article->sxml-html (cnt <selector>) (section-level <integer>))
  (list
    'select
    (append (list '@) (attributes-of cnt))
    (map
      (lambda (x)
        (list 'option (list '@ (list 'value (car x))) (cdr x)))
      (contents cnt))))

;; Input content type
(define-method (attributes-of (cnt <input-content-type>))
  (append
    (next-method)
    (attribute->sxml-attribute cnt value)))

(define-method (article->sxml-html (cnt <input-content-type>) (section-level <integer>))
  (list
    'input
    (append (list '@) (attributes-of cnt))))

;; Submit button
(define-method (attributes-of (cnt <submit-button>))
  (append
    (next-method)
    (list (list 'type "submit"))))

;; Checkbox
(define-method (attributes-of (cnt <checkbox>))
  (append
    (next-method)
    (list (list 'type "checkbox"))
    (if (checked cnt)
        (list (list 'checked "checked"))
        (list))))

;; Text input
(define-method (attributes-of (cnt <text-input>))
  (append
    (next-method)
    (list (list 'type "text"))))
