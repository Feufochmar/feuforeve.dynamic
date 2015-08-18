;; markdown-tumblr exporter for classes of Article module
;; To use with the mail posting feature & sendmail
(define-module (ffch article-exporters markdown-tumblr)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch article)
  #:export (article->markdown-tumblr)
  #:duplicates (merge-generics)
)

;; The only method exported is article->markdown-tumblr, defined for every article datatype and in two variants

;; Generic data types
(define-method (article->markdown-tumblr (cnt <container-type>))
  (apply string-append (map article->markdown-tumblr (contents cnt))))

;; Terminals
(define-method (article->markdown-tumblr (cnt <string>))
  cnt)
(define-method (article->markdown-tumblr (cnt <number>))
  (number->string cnt))
(define-method (article->markdown-tumblr (cnt <list>))
  (apply string-append (map article->markdown-tumblr cnt)))

;; By default, ignore the non-container content-type
(define-method (article->markdown-tumblr (cnt <content-type>))
  "")

;; Article
(define-method (article->markdown-tumblr (cnt <article>))
  (string-append
    (if (title cnt)
        (string-append "Subject: " (title cnt) "\n")
        "")
    "!m\n"
    (next-method)
    "\n"
    "#floraverse,#generated character,#character generator\n"
    ".\n"))

;; Section
;; Note: since tumblr does not like headings, all is at the same level and section's title is just set to bold
(define-method (article->markdown-tumblr (cnt <section>))
  (string-append
    (if (title cnt)
        (string-append "**" (title cnt) "**\n  \n")
        "")
    (next-method)))

;; Paragraph
(define-method (article->markdown-tumblr (cnt <paragraph>))
  (string-append
    (next-method)
    "\n  \n"))

;; Strong
(define-method (article->markdown-tumblr (cnt <strong>))
  (string-append "**" (next-method) "**"))

;; Emphase
(define-method (article->markdown-tumblr (cnt <emphase>))
  (string-append "*" (next-method) "*"))

;; Hyperlink
(define-method (article->markdown-tumblr (cnt <hyperlink>))
  (string-append "[" (next-method) "](" (to cnt) ")"))

(define-method (article->markdown-tumblr (cnt <text-list>))
  (apply string-append
    (map
      (lambda (x)
        (string-append
          (if (ordered? cnt)
              "1.  "
              "+   ")
          (apply string-append (map article->markdown-tumblr x))
          "\n"))
      (contents cnt))))

(define-method (article->markdown-tumblr (cnt <code>))
  (string-append "`" (next-method) "`"))

(define-method (article->markdown-tumblr (cnt <preformatted>))
  (string-append "    " (next-method)))

(define-method (article->markdown-tumblr (cnt <linefeed>))
  (string-append "  \n"))
