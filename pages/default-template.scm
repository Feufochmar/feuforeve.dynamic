(define-module (pages default-template)
  #:use-module (ffch article)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:export (default-template default-meta)
  #:duplicates (merge-generics)
)

;; Main template
(define (default-template meta navigation-2nd-level)
  (webtemplate
    meta
    (header
      (section ((style-class "banner"))
        (hyperlink ((to "/"))
          (image ((alt "Feuforêve")) "http://static.feuforeve.fr/images/feuforeve-banner.png")))
      (navigation
        (section ((style-class "nav-item")) (hyperlink ((to "/")) "Home"))
        (section ((style-class "nav-item")) (hyperlink ((to "/FloraCharacterGenerator")) "Flora character generator"))
        (section ((style-class "nav-item")) (hyperlink ((to "/ArnYtron3000")) "ArnYtron3000"))
        (section ((style-class "nav-item")) (hyperlink ((to "/FlagGenerator")) "Flag Generator"))
      )
      navigation-2nd-level)
    (footer
      "©2015 Feufochmar"
    )
  ))

(define default-meta
  (metadata (stylesheets "http://static.feuforeve.fr/css/feuforeve.css")))
