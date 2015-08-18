(define-module (main)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (arnytron arnytron)
  #:use-module (flag-generator flag-generator)
  #:use-module (flora-character-generator description)
  #:use-module (flora-character-generator generator)
  #:use-module (ffch article-exporters markdown-tumblr)
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
      (generate-character-description (generate-character))
    )))

;; Flora character generator : tumblr sendmail output
(add-weblet wcontainer (list "FloraCharacterGenerator" "sendmail")
  (weblet ((error-code 200)
           (content-type "text/plain;charset=UTF-8"))
    ((path query port)
     (let ((art (generate-character-description (generate-character))))
       (display (article->markdown-tumblr art) port)(newline port)
     ))))

;; Flora character generator: Pick a species
(add-weblet wcontainer (list "FloraCharacterGenerator" "pick...")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "Floraverse character generator: pick...")(author "feuforeve.fr"))
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
      (article ((title "About the Floraverse Character Generator")(author "Feufochmar")(date "2015-08-18"))
        (section ((title "The generator"))
          (paragraph
            "The Floraverse Character Generator generates characters living in the "
            (hyperlink ((to "http://floraverse.com")) "Floraverse") " world. "
            "It is inspired by " (hyperlink ((to "http://fav.me/d7569je")) "this journal post on deviantArt")
            ", which originally used the "
            (hyperlink ((to "http://marnok.com/content/_adventure/101npcs.php")) "Marnok's NPC generator") ". "))
        (section ((title "History"))
          (paragraph
            "The current generator deployed on feuforeve.fr is the third version of the generator. " (linefeed)
            "The first version was written in Java and was originally a desktop application, and I then added "
            "the feature to run it as a webservice. " (linefeed)
            "The second version was written in Guile Scheme and ran only as a webservice. " (linefeed)
            "The current version is based on the second version and is the result of the merger "
            "of the different generators that are hosted on this website into a single project "
            "as they were sharing some code. "))
        (section ((title "Sources"))
          (paragraph
            "The first and second versions of the generator are open-source and released under the terms of "
            "the GNU General Public License version 2 or any later version (GPLv2+). "
            "The sources are provided through " (hyperlink ((to "http://git-scm.com/")) "git") " repositories."
            "The third version is not (yet) open-sourced. ")
          (section ((title "Java generator"))
            (paragraph
              "The first generator requires a Java 8 Runtime Environment (JRE) to run. "
              "It requires a Java 8 Development Kit (JDK) and ant to build. ")
            (paragraph
              "To get the sources, clone the repository "
              (code "http://projects.feuforeve.fr/flora-npc-generator-java.git") ". "
              "You can do this under GNU/Linux by typing in a terminal: "
              (preformatted
                (code "git clone http://projects.feuforeve.fr/flora-npc-generator-java.git")))
            (paragraph
              "This generator can run in two different modes. "
              "By default, it runs as a desktop application. "
              "To run the generator as a webservice, the argument " (code "-server")
              " must be added to the command line. "
              "The output format of the webservice can be configured between html, xml and json. "))
          (section ((title "Scheme generator"))
            (paragraph
              "The second generator requires "
              (hyperlink ((to "http://www.gnu.org/software/guile/")) "GNU Guile 2") " to run. ")
            (paragraph
              "To get the sources, clone the repository "
              (code "http://projects.feuforeve.fr/flora-character-generator-scm.git") ". "
              "You can do this under GNU/Linux by typing in a terminal: "
              (preformatted
                (code "git clone http://projects.feuforeve.fr/flora-character-generator-scm.git")))
            (paragraph
              "The generator only runs in server mode and mainly outputs as html. "
              "There is a special output at " (code "/sendmail") " in order to post generated "
              "characters on " (hyperlink ((to "http://floraversegenerators.tumblr.com/")) "Tumblr")
              " using " (code "sendmail") ". "
              "Unlike the first generator, this generator also allows to choose the species "
              "of the generated character. "))
        )))))

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

;; Flag generator template
(define flag-generator-template
  (main-template
    (metadata
      (stylesheets
        "http://static.feuforeve.fr/css/feuforeve.css"
        "http://static.feuforeve.fr/css/flag-generator.css"
      )
      (scripts "http://static.feuforeve.fr/scripts/flag-generator.js"
      )
      (onload "getFlag();")
    )))

;; Flag generator
(add-weblet wcontainer (list "FlagGenerator")
  (templated-weblet
    flag-generator-template
    (lambda (query)
      (article ((title "Flag generator")(author "feuforeve.fr"))
        (section
          (button ((onclick "getFlag();")) "New flag")
          (section ((id "flag")))
        )
        (section ((title "Source code"))
          (text-area ((id "raw")))
          (paragraph
            "To save the flag, copy and paste the code into a text file and save as with a "
            (code "'svg'") " extension.")
        )
        (section
          (paragraph
            "The generated flags (and their source code) are released under the "
            (hyperlink ((to "http://creativecommons.org/publicdomain/zero/1.0/"))
              "Creative Commons CC0 1.0 Universal (CC0 1.0) Public Domain Dedication") "."))
      )
    )))

;; Flag generator: Svg flag
(add-weblet wcontainer (list "FlagGenerator" "RawFlag")
  (weblet ((error-code 200)
           (content-type "image/svg+xml;charset=UTF-8"))
    ((path query port)
     (generate-flag 600 port) ;; flag width: 600
     (newline port)
    )
  ))

;; Flag generator: about
(add-weblet wcontainer (list "FlagGenerator" "about")
  (templated-weblet
    feuforeve-template
    (lambda (query)
      (article ((title "About the flag generator")(author "Feufochmar")(date "2015-08-08"))
        (section ((title "The generator"))
          (paragraph
            "The generator generates flags as svg images and "
            "the source code of the flag is given in the text area below the flag. ")
          (section ((title "Generation process"))
            (paragraph
              "The generator first chooses a division of the field (plain color, bicolor or tricolor, "
              "horizontal or vertical, stripes, ...). It then chooses the colors to use. "
              "The generator chooses for each parts of the division pattern a couple of colors: a light color "
              "and a dark color. The generator finish the flag by choosing charges to put on the flag "
              "(star, cross, ...).")
            (paragraph
              "The colors and charges combination greatly depends on the chosen division, "
              "and the generator use a rule when combining colors: when the field uses a dark color, the charges "
              "above it use light colors (and vice-versa). This is inspired by a heraldic rule regarding "
              "how colors are combined: no metal (light color) on metal nor tincture (dark color) on tincture. "
              "In fact, the generator draws inspiration from heraldry and there are indeed many heraldic references "
              "inside the source code. "
            ))
          (section ((title "Why not providing a flag designer ?"))
            (paragraph
              "I don't do this because the generator puts some constraints on the generated flag and there is "
              "a large combinatory when a flag is generated."
              "If you want to design your own flag, you may want to use "
              (hyperlink ((to "http://flag-designer.appspot.com/")) "Scrontch's Flag Designer") ". "))
        )
        (section ((title "Licence of the generated flags"))
          (section
            (paragraph
              "Since I don't care at all about what you do with the generated flags, "
              "the generated flags (and their source code) are released under " (deleted "public domain") " the "
              (hyperlink ((to "http://creativecommons.org/publicdomain/zero/1.0/"))
                "Creative Commons CC0 1.0 Universal (CC0 1.0) Public Domain Dedication") "."))
          (section ((title "Why public domain is stroke ?"))
            (paragraph
              "Because of the french laws not allowing me to release anything under public domain. "
              "So I use a licence giving more or less the same rights as public domain instead. "
              "However, the french author's rights laws also require attribution. "
              "I don't care about it, so I'm fine if you don't give attribution. "
              "If you want to give attribution, link to the generator page "
              (hyperlink ((to "http://feuforeve.fr/FlagGenerator"))
                (code "http://feuforeve.fr/FlagGenerator")) "."))
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
