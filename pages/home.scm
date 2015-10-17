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

(define (home-template meta)
  (default-template
    meta
    "/"
    (lambda (path query)
      (navigation
        (section
          ((name-class "nav-item"))
          (nav-link-to "/" (nav-current-path path) "Home"))
        (section
          ((name-class "nav-item"))
          (nav-link-to "/ToyCatCreator" (nav-current-path path) "Toy Cat Creator"))
        (section
          ((name-class "nav-item"))
          (nav-link-to "/AboutMe" (nav-current-path path) "About me"))
      ))))

;; Home page
(define (load-home wcontainer)
  (add-weblet wcontainer (list "")
    (templated-weblet
      (home-template default-meta)
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
      (home-template default-meta)
      (lambda (query)
        (article ((title "Not found")(author "404"))
          (paragraph
            "Sorry, but you are looking for something that does not exist."))
      ))))

;; About Feufochmar
(define (load-about-me wcontainer)
  (add-weblet wcontainer (list "AboutMe")
    (templated-weblet
      (home-template default-meta)
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

;; Toy cat creator
(define (load-toy-cat-creator wcontainer)
  (add-weblet wcontainer (list "ToyCatCreator")
    (templated-weblet
      (home-template
        (metadata
          (stylesheets
            "http://static.feuforeve.fr/css/feuforeve.css")
          (scripts "http://static.feuforeve.fr/scripts/toy-cat-creator.js")
          (onload "initToyCatCreator();")))
      (lambda (query)
        (article ((title "Toy Cat Creator")(author "Feufochmar")(date "2015-10-17"))
          (section
            (paragraph ((id "preset.link"))
              "Link to current selection")
            (paragraph
              (embedded-object
                (id "toy.cat.creator")
                (data "toy-cat-creator.svg")
                (type "image/svg+xml")))
          )
          (section ((title "About"))
            (paragraph
              "The Toy Cat Creator is a small dress up game starring the toy cat demon Beleth from "
              (hyperlink ((to "http://floraverse.com")) "Floraverse") ". ")
            (paragraph
              "The game is contained inside an SVG image and is made under Inkscape. "
              "The image is released under the "
              (hyperlink ((to "https://creativecommons.org/licenses/by-sa/3.0/fr/"))
                         "Creative Commons Attribution Share-Alike CC BY-SA") ". ")
            (paragraph
              (hyperlink ((to "http://static.feuforeve.fr/images/toy-cat-creator.svg"))
                         "Direct link")
              ". ")
            )
        )))))

(define (load-toy-cat-creator-svg wcontainer)
  (add-redirections wcontainer
    (list
      (cons (list "toy-cat-creator.svg") "http://static.feuforeve.fr/images/toy-cat-creator.svg")
    )))

;; Load all
(define (load-pages:home wcontainer)
  (load-redirections wcontainer)
  (load-home wcontainer)
  (load-404 wcontainer)
  (load-about-me wcontainer)
  (load-toy-cat-creator wcontainer)
  (load-toy-cat-creator-svg wcontainer)
)
