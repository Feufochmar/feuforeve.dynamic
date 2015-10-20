(define-module (pages default-template)
  #:use-module (oop goops)
  #:use-module (ffch article)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:export (default-template default-meta nav-link-to nav-current-path static-data)
  #:duplicates (merge-generics)
)

(define *static-file-path* "http://static.feuforeve.fr")

(define-method (static-data (relative-path <string>))
  (string-append *static-file-path* "/" relative-path))

(define-method (nav-current-path (path <list>))
  (string-append "/" (string-join path "/")))

(define-method (nav-link-to (to-path <string>) (current-path <string>) (title <string>))
  (if (equal? to-path current-path)
      title
      (hyperlink ((to to-path)) title)))

(define-method (apply-2nd-level (navigation-2nd-level <navigation>) path query)
  navigation-2nd-level)
(define-method (apply-2nd-level (navigation-2nd-level <applicable>) path query)
  (navigation-2nd-level path query))

;; Main template
(define (default-template meta 1st-level-path navigation-2nd-level)
  (webtemplate
    meta
    (lambda (path query)
      (header
        (section ((name-class "banner"))
          (hyperlink ((to "/"))
            (image ((alt "Feuforêve")) (static-data "images/feuforeve-banner.png"))))
        (navigation
          (section ((name-class "nav-item"))
            (strong (nav-link-to "/" 1st-level-path "Home")))
          (section ((name-class "nav-item"))
            (strong (nav-link-to "/FloraCharacterGenerator" 1st-level-path "Flora character generator")))
          (section ((name-class "nav-item"))
            (strong (nav-link-to "/ArnYtron3000" 1st-level-path "ArnYtron3000")))
          (section ((name-class "nav-item"))
            (strong (nav-link-to "/FlagGenerator" 1st-level-path "Flag Generator")))
          (section ((name-class "nav-item"))
            (strong (nav-link-to "/DailyIsland" 1st-level-path "Daily Island"))))
        (apply-2nd-level navigation-2nd-level path query)))
    (footer
      "©2015 Feufochmar")
  ))

(define default-meta
  (metadata (stylesheets (static-data "css/feuforeve.css"))))
