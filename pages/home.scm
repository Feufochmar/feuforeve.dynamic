(define-module (pages home)
  #:use-module (ffch article)
  #:use-module (ffch forms)
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
          (nav-link-to "/Fonts" (nav-current-path path) "Fonts"))
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
              (hyperlink ((to "http://feufochmar.tumblr.com/")) "Tumblr")
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
            (static-data "css/feuforeve.css"))
          (scripts (static-data "scripts/toy-cat-creator.js"))
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
              (hyperlink ((to (static-data "images/toy-cat-creator.svg")))
                         "Direct link")
              ". ")
            )
        )))))

;; Custom fonts
(define (font-example name)
  (paragraph ((name-class name))
    "The quick brown dog jumps over the lazy fox." (linefeed)
    "Voix ambiguë d'un cœur qui, au zéphyr, " (linefeed)
    "préfère les jattes de kiwis." (linefeed)
    "0 1 2 3 4 5 6 7 8 9 () [] {}" (linefeed)
    "A B C D E F G H I J K L M" (linefeed)
    "N O P Q R S T U V W X Y Z" (linefeed)
    "a b c d e f g h i j k l m" (linefeed)
    "n o p q r s t u v w x y z" (linefeed)
    "! \" ' . , ?" (linefeed)
    "Andre told Beleth they would work with Amdusias and Orobas." (linefeed)
    "àáćèéǵìíḱĺḿǹńòóṕŕśùúẃẁýỳź" (linefeed)
    "âĉêĝĥîĵôŝûŵŷẑãẽĩñõũṽỹäëḧïöẗüẅẍÿ"))

(define (load-custom-fonts wcontainer)
  (add-weblet wcontainer (list "Fonts")
    (templated-weblet
      (home-template
        (metadata
          (stylesheets
            (static-data "css/feuforeve.css")
            (static-data "css/custom-fonts.css"))))
      (lambda (query)
        (article ((title "Fonts")(author "Feufochmar")(date "2015-10-17"))
          (section ((title "Prattling"))
            (paragraph
              "A font inspired by the Prattle scripts appearing in the Floraverse webcomic. "
              (hyperlink ((to (static-data "fonts/Prattling.otf"))) "Download")(linefeed)
              "Note: The font is not yet finished.")
            (section ((title "Sample"))
              (section ((name-class "font-contents"))
                (section ((name-class "font-example"))
                  (font-example #f))
                (section ((name-class "font-example"))
                  (font-example "prattling")))
              (section ((title "Playfield"))
                (paragraph ((name-class "font-playfield"))
                  (text-area ((name-class "prattling")) "You can type what you want here."))))
            (section ((title "Source file and licence"))
              "The font is released under the "
              (hyperlink ((to "http://scripts.sil.org/OFL")) "SIL Open Font license") ". "
              "So you can also modify the font and share the result. "
              "Open the " (hyperlink ((to (static-data "fonts/Prattling.sfd"))) "source file") " "
              "in " (hyperlink ((to "https://fontforge.github.io/")) "fontforge") " and edit whatever you want."
            )
          )
        )))))

;; Load all
(define (load-pages:home wcontainer)
  (load-redirections wcontainer)
  (load-home wcontainer)
  (load-404 wcontainer)
  (load-about-me wcontainer)
  (load-toy-cat-creator wcontainer)
  (load-custom-fonts wcontainer)
)
