(define-module (pages flag-generator)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (flag-generator flag-generator)
  #:use-module (pages default-template)
  #:export (load-pages:flag-generator)
  #:duplicates (merge-generics)
)

;; Template
(define (flag-generator-template meta)
  (default-template
    meta
    (navigation
      (section ((style-class "nav-item")) (hyperlink ((to "/FlagGenerator")) "Flag generator"))
      (section ((style-class "nav-item")) (hyperlink ((to "/FlagGenerator/RawFlag")) "Flag generator (Raw SVG)"))
      (section ((style-class "nav-item")) (hyperlink ((to "/FlagGenerator/about")) "About the generator"))
    )))

;; Flag generator
(define (load-flag-generator wcontainer)
  (add-weblet wcontainer (list "FlagGenerator")
    (templated-weblet
      (flag-generator-template
        (metadata
          (stylesheets
            "http://static.feuforeve.fr/css/feuforeve.css"
            "http://static.feuforeve.fr/css/flag-generator.css")
          (scripts "http://static.feuforeve.fr/scripts/flag-generator.js")
          (onload "getFlag();")))
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
      ))))

;; Flag generator: Svg flag
(define (load-flag-generator-raw wcontainer)
  (add-weblet wcontainer (list "FlagGenerator" "RawFlag")
    (weblet ((error-code 200)
            (content-type "image/svg+xml;charset=UTF-8"))
      ((path query port)
      (generate-flag 600 port) ;; flag width: 600
      (newline port)
      )
    )))

;; Flag generator: about
(define (load-flag-generator-about wcontainer)
  (add-weblet wcontainer (list "FlagGenerator" "about")
    (templated-weblet
      (flag-generator-template default-meta)
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
      ))))

;; Load all pages
(define (load-pages:flag-generator wcontainer)
  (load-flag-generator wcontainer)
  (load-flag-generator-raw wcontainer)
  (load-flag-generator-about wcontainer))
