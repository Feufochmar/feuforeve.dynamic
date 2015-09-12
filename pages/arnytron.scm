(define-module (pages arnytron)
  #:use-module (ffch article)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (arnytron arnytron)
  #:use-module (ice-9 regex)
  #:use-module (pages default-template)
  #:export (load-pages:arnytron)
  #:duplicates (merge-generics)
)

;; ArnYtron3000 generator
(define ArnYtron3000 (arnytron))

;; Template
(define arnytron-template
  (default-template
    default-meta
    "/ArnYtron3000"
    (lambda (path query)
      (navigation
        (section ((name-class "nav-item"))
                 (hyperlink ((to "/ArnYtron3000")) "Nouvelle citation"))
        (section ((name-class "nav-item"))
                 (hyperlink ((to "/ArnYtron3000/brut")) "Nouvelle citation (texte brut)"))
        (section ((name-class "nav-item"))
                 (hyperlink ((to "/ArnYtron3000/json")) "Nouvelle citation (json)"))
        (section ((name-class "nav-item"))
                 (hyperlink ((to "/ArnYtron3000/vraie")) "Vraie citation"))
        (section ((name-class "nav-item"))
                 (nav-link-to "/ArnYtron3000/about" (nav-current-path path) "À propos du générateur"))
      ))))

;; ArnyTron3000
(define (load-arnytron wcontainer)
  (add-weblet wcontainer (list "ArnYtron3000")
    (templated-weblet
      arnytron-template
      (lambda (query)
        (article ((title "ArnYtron3000")(author "feuforeve.fr"))
          (paragraph
            "Aujourd'hui, ArnYtron3000 vous salue par ces mots :" (linefeed)
            (strong (generate-citation ArnYtron3000))
          ))
      ))))

;; ArnYtron3000 raw output
(define (load-raw wcontainer)
  (add-weblet wcontainer (list "ArnYtron3000" "brut")
    (weblet ((error-code 200)
            (content-type "text/plain;charset=UTF-8"))
      ((path query port)
      (display (generate-citation ArnYtron3000) port)(newline port)
      )
    )))

;; ArnYtron3000 json output
(define (load-json wcontainer)
  (add-weblet wcontainer (list "ArnYtron3000" "json")
    (weblet ((error-code 200)
            (content-type "application/json;charset=UTF-8"))
      ((path query port)
      (let* ((raw (generate-citation ArnYtron3000))
              (pass-1 (regexp-substitute/global #f "\\\\" raw 'pre "\\\\" 'post))
              (pass-2 (regexp-substitute/global #f "\"" pass-1 'pre "\\\"" 'post)))
        (format port "{ \"greeting\": \"~a\" }" pass-2))
      (newline port)
      )
    )))

;; ArnYtron3000 about
(define (load-about wcontainer)
  (add-weblet wcontainer (list "ArnYtron3000" "about")
    (templated-weblet
      arnytron-template
      (lambda (query)
        (article ((title "À propos d'ArnYtron3000")(author "Feufochmar")(date "2015-08-02"))
          (paragraph
            "ArnYtron3000, un générateur " (deleted "d'insultes")
            " de salutations se basant sur les légendaires salutations "
            "postées par " (hyperlink ((to "http://twitter.com/ArnY")) "ArnY") " sur le canal IRC #linux de "
            (hyperlink ((to "https://www.rezosup.org/")) "RezoSup") ". "
          )
          (paragraph
            "ArnYtron3000 sait aussi ressortir "
            (hyperlink ((to "/ArnYtron3000/vraie"))
            " des vraies citations") "."
          )
        )
      ))))

;; ArnY real citations
(define (load-true wcontainer)
  (add-weblet wcontainer (list "ArnYtron3000" "vraie")
    (templated-weblet
      arnytron-template
      (lambda (query)
        (let* ((asked-date (hash-ref query "date"))
               (real-quote
                 (if asked-date
                     (pick-citation ArnYtron3000 asked-date)
                     (pick-citation ArnYtron3000)))
               (page-title
                 (if (and asked-date (not (equal? asked-date (date real-quote))))
                     (string-join
                       (list "Je ne sais pas si ArnY a salué #linux le " asked-date
                             " mais, le " (date real-quote) ", ArnY a salué #linux en disant...") "")
                     (string-join
                       (list "Le " (date real-quote) ", ArnY a salué #linux en disant...") ""))))
          (article ((title page-title)
                    (author "ArnY")(date (date real-quote)))
            (section
              (paragraph
                (strong (citation real-quote))))
            (if (not (null? (reactions real-quote)))
              (section ((title "Réactions")) (map (lambda (x) (list x (linefeed))) (reactions real-quote)))
              ""))
        )))))

(define (load-pages:arnytron wcontainer)
  (load-arnytron wcontainer)
  (load-raw wcontainer)
  (load-json wcontainer)
  (load-about wcontainer)
  (load-true wcontainer))
