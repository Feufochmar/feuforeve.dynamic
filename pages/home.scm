(define-module (pages home)
  #:use-module (ffch article)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (pages default-template)
  #:export (load-pages:home)
  #:duplicates (merge-generics)
)

;; Load redirections
(define (load-redirections wcontainer)
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
    )))

(define home-template
  (default-template
    default-meta
    (navigation
      (section ((style-class "nav-item")) (hyperlink ((to "/")) "Home"))
      (section ((style-class "nav-item")) (hyperlink ((to "/AboutMe")) "About me"))
    )))

;; Home page
(define (load-home wcontainer)
  (add-weblet wcontainer (list "")
    (templated-weblet
      home-template
      (lambda (query)
        (article ((title "Feuforêve: home")(author "Feufochmar")(date "2015-08-01"))
          (paragraph
            "Hello, I'm "
            (hyperlink ((to "/AboutMe")) "Feufochmar")
            " and this is my personnal website."))
          ))))


;; 404 error page
(define (load-404 wcontainer)
  (add-weblet wcontainer (list "404")
    (templated-weblet
      home-template
      (lambda (query)
        (article ((title "Not found")(author "404"))
          (paragraph
            "Sorry, but you are looking for something that does not exist."))
      ))))

;; About Feufochmar
(define (load-about-me wcontainer)
  (add-weblet wcontainer (list "AboutMe")
    (templated-weblet
      home-template
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
      ))))

;; Load all
(define (load-pages:home wcontainer)
  (load-redirections wcontainer)
  (load-home wcontainer)
  (load-404 wcontainer)
  (load-about-me wcontainer))
