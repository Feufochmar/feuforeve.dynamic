(define-module (main)
  #:use-module (ffch article)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (arnytron arnytron)
  #:use-module (ice-9 regex)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))

;; ArnYtron3000 generator
(define ArnYtron3000 (arnytron))

;; Webcontainer dispatching pages
(define wcontainer (webcontainer 8080))

;; Main template
(define (main-template meta)
  (webtemplate
    meta
    (header
      (section ((style-class "banner"))
        (hyperlink ((to "/"))
          (image ((alt "Feuforêve")) "http://static.feuforeve.fr/images/feuforeve-banner.png")))
      (section ((style-class "menubar"))
        (section ((style-class "menubar-item")(title "Flora character generator"))
          (hyperlink ((to "/FloraCharacterGenerator")) "Generator")(linefeed)
          (hyperlink ((to "/FloraCharacterGenerator/pick...")) "Pick a species")(linefeed)
          (hyperlink ((to "/FloraCharacterGenerator/about")) "Infos")
        )
        (section ((style-class "menubar-item")(title "ArnYtron3000"))
          (hyperlink ((to "/ArnYtron3000")) "ArnYtron3000")(linefeed)
          (hyperlink ((to "/ArnYtron3000/brut")) "Plain text output")(linefeed)
          (hyperlink ((to "/ArnYtron3000/json")) "Json output")(linefeed)
          (hyperlink ((to "/ArnYtron3000/about")) "Infos")(linefeed)
        )
        (section ((style-class "menubar-item")(title "Flag generator"))
          (hyperlink ((to "/FlagGenerator")) "FlagGenerator")(linefeed)
          (hyperlink ((to "/FlagGenerator/about")) "Infos")(linefeed)
        )
        (section ((style-class "menubar-item")(title "Other stuff"))
          (hyperlink ((to "/AboutMe")) "About me")(linefeed)
        )
      )
      (section ((style-class "reset-layout")))
      )
    (footer
      "©2015 Feufochmar"
    )
  ))

;;
(define feuforeve-template
  (main-template
    (metadata
      (stylesheets "http://static.feuforeve.fr/css/feuforeve.css")
    )))

;; 404 error page
(add-weblet wcontainer (list "404")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Not found")(author "404"))
        (paragraph
          "Sorry, but you are looking for something that does not exist."))
    )
  ))

;; Redirections
(add-redirections wcontainer
  (list
    (cons (list "robots.txt") "http://static.feuforeve.fr/robots.txt")
    ;; Favicons
    (cons (list "favicon.ico") "http://static.feuforeve.fr/favicons/favicon.ico")
    (cons (list "favicon.png") "http://static.feuforeve.fr/favicons/favicon.png")
    (cons (list "apple-touch-icon.png") "http://static.feuforeve.fr/favicons/apple-touch-icon.png")
    (cons (list "apple-touch-icon-precomposed.png")
          "http://static.feuforeve.fr/favicons/apple-touch-icon-precomposed.png")
    ;; Old links to the floraverse character generator
    (cons (list "generator-v1") "http://feuforeve.fr/FloraCharacterGenerator")
    (cons (list "generator-v2") "http://feuforeve.fr/FloraCharacterGenerator")
    (cons (list "generator") "http://feuforeve.fr/FloraCharacterGenerator")
    (cons (list "generator2") "http://feuforeve.fr/FloraCharacterGenerator")
  ))

;; Main page
(add-weblet wcontainer (list "")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Feuforêve: home")(author "Feufochmar")(date "2015-08-01"))
        (paragraph
          "Hello, I'm "
          (hyperlink ((to "/AboutMe")) "Feufochmar")
          " and this is my personnal website."
        )
      )
    )))

;; Flora character generator
(add-weblet wcontainer (list "FloraCharacterGenerator")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Flora character generator")(author "feuforeve.fr"))
        (paragraph
          "Soon..."
        )
      )
    )))

;; Flora character generator : tumblr sendmail output
(add-weblet wcontainer (list "FloraCharacterGenerator" "sendmail")
  (weblet ((error-code 200)
           (content-type "text/plain;charset=UTF-8"))
    ((path query port)
     (display "Soon..." port)(newline port)
     )
  ))

;; Flora character generator: Pick a species
(add-weblet wcontainer (list "FloraCharacterGenerator" "pick...")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Flora character generator: pick...")(author "feuforeve.fr"))
        (paragraph
          "Soon..."
        )
      )
    )))

;; Flora character generator: About
(add-weblet wcontainer (list "FloraCharacterGenerator" "about")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "About the Floraverse character generator")(author "Feufochmar")(date "2015-08-02"))
        (paragraph
          "Soon..."
        )
      )
    )))

;; ArnyTron3000
(add-weblet wcontainer (list "ArnYtron3000")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "ArnYtron3000")(author "feuforeve.fr"))
        (paragraph
          "Aujourd'hui, ArnYtron3000 vous salue par ces mots :" (linefeed)
          (strong (generate-citation ArnYtron3000))
        )
        (paragraph
          (hyperlink ((to "/ArnYtron3000")) "Une autre !")
        )
      )
    )))

;; ArnYtron3000 raw output
(add-weblet wcontainer (list "ArnYtron3000" "brut")
  (weblet ((error-code 200)
           (content-type "text/plain;charset=UTF-8"))
    ((path query port)
     (display (generate-citation ArnYtron3000) port)(newline port)
     )
  ))

;; ArnYtron3000 json output
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
  ))

;; ArnYtron3000 about
(add-weblet wcontainer (list "ArnYtron3000" "about")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "À propos d'ArnYtron3000")(author "Feufochmar")(date "2015-08-02"))
        (paragraph
          "ArnYtron3000, un générateur " (deleted "d'insultes")
          " de salutations se basant sur les légendaires salutations "
          "postées par " (hyperlink ((to "")) "ArnY") " sur le canal IRC #linux de "
          (hyperlink ((to "https://www.rezosup.org/")) "RezoSup") ". "
        )
        (paragraph
          "ArnYtron3000 sait aussi ressortir "
          (hyperlink ((to "/ArnYtron3000/vraie"))
          " des vraies citations") "."
        )
      )
    )))

;; Vrai citation d'ArnY
(add-weblet wcontainer (list "ArnYtron3000" "vraie")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (let ((real-quote (pick-citation ArnYtron3000)))
        (article ((title (string-join (list "Le " (date real-quote) ", ArnY a salué #linux en disant...") ""))
                  (author "ArnY")(date (date real-quote)))
          (section
            (paragraph
              (strong (citation real-quote))
            )
          )
          (if (not (null? (reactions real-quote)))
            (section ((title "Réactions")) (map (lambda (x) (list x (linefeed))) (reactions real-quote)))
            "")
          (section
            (paragraph
              (hyperlink ((to "/ArnYtron3000/vraie")) "Une autre !")
            )
          )
        )
      )
    )))

;; Flag generator
(add-weblet wcontainer (list "FlagGenerator")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Flag generator")(author "feuforeve.fr"))
        (paragraph
          "Soon..."
        )
      )
    )))

;; Flag generator: Svg flag
(add-weblet wcontainer (list "FlagGenerator" "RawFlag")
  (weblet ((error-code 200)
           (content-type "image/svg+xml;charset=UTF-8"))
    ((path query port)

     (newline port)
    )
  ))

;; Flag generator: about
(add-weblet wcontainer (list "FlagGenerator" "about")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "About the flag generator")(author "Feufochmar")(date "2015-08-02"))
        (paragraph
          "Soon..."
        )
      )
    )))

;; About Feufochmar
(add-weblet wcontainer (list "AboutMe")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "About: Feufochmar")(author "Feufochmar")(date "2015-08-02"))
        (section ((title "Myself"))
          (paragraph
            "I'm strange ghost lost in a strange labyrinth named Internet. "
          )
          (paragraph
            "You can find me on "
            (hyperlink ((to "http://feufochmar.deviantart.com/")) "Tumblr")
            " and "
            (hyperlink ((to "http://feufochmar.deviantart.com/")) "deviantArt") ". " (linefeed)
            "You can also contact me at " (code "feufochmar [dot] gd [at] gmail [dot] com") "."
          )
        )
        (section ((title "Website name"))
          (paragraph
            "The website name, "
            (hyperlink ((to "http://www.pokemon.com/fr/pokedex/feuforêve")) "Feuforêve")
            ", is the french name of the "
            (hyperlink ((to "http://www.pokemon.com")) "Pokémon") " "
            (hyperlink ((to "http://www.pokemon.com/us/pokedex/misdreavus")) "Misdreavus") ". "
          )
        )
      )
    )))

;; Run the webserver
(run-webcontainer wcontainer)
