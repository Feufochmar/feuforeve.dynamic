(define-module (pages flora-character-generator)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (flora-character-generator description)
  #:use-module (flora-character-generator generator)
  #:use-module (flora-character-generator species)
  #:use-module (ffch article-exporters markdown-tumblr)
  #:use-module (pages default-template)
  #:export (load-pages:flora-character-generator)
  #:duplicates (merge-generics)
)

;;
(define (character-bindings query)
  (let ((bound-parameters (make-character-bound-parameters))
        (species-key-str (hash-ref query "species"))
       )
    (if species-key-str
        (set! (species bound-parameters) (string->symbol species-key-str)))
    bound-parameters))

;; Template
(define fcg-template
  (default-template
    default-meta
    "/FloraCharacterGenerator"
    (lambda (path query)
      (let* ((bound-parameters (character-bindings query))
             (species-key (species bound-parameters))
             (species (if species-key (get-species species-key) #f)))
        (navigation
          (if species
              (section
                ((name-class "nav-item"))
                (hyperlink
                  ((to (string-append "/FloraCharacterGenerator?species=" (symbol->string species-key))))
                  (string-append "New character (" (name species) ")")))
              "")
          (section
            ((name-class "nav-item"))
            (hyperlink ((to "/FloraCharacterGenerator"))
                       (if species
                           "New character (random species)"
                           "New character")))
          (section
            ((name-class "nav-item"))
            (nav-link-to "/FloraCharacterGenerator/pick..." (nav-current-path path) "Pick a species..."))
          (section
            ((name-class "nav-item"))
            (nav-link-to "/FloraCharacterGenerator/about" (nav-current-path path) "About the generator"))
        )))))

;; Flora character generator
(define (load-fcg-generator wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator")
    (templated-weblet
      fcg-template
      (lambda (query)
        (let ((bound-parameters (character-bindings query)))
          (generate-character-description (generate-character bound-parameters)))
      ))))

;; Flora character generator : tumblr sendmail output
(define (load-fcg-sendmail wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "sendmail")
    (weblet ((error-code 200)
             (content-type "text/plain;charset=UTF-8"))
      ((path query port)
       (let* ((bound-parameters (character-bindings query))
              (art (generate-character-description (generate-character bound-parameters))))
         (display (article->markdown-tumblr art) port)(newline port)
       )))))

;; Flora character generator: Pick a species
(define (load-fcg-pick wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "pick...")
    (templated-weblet
      fcg-template
      (lambda (query)
        (article ((title "Floraverse character generator: pick...")(author "feuforeve.fr"))
          (paragraph
            "Choose a species: "
            (form ((submit-action "/FloraCharacterGenerator") (submit-method "GET"))
              (selector ((name "species") (size 15))
                (map
                  (lambda (x)
                    (cons (symbol->string (key x)) (name x)))
                  (list-character-species)))
              (linefeed)
              (submit-button (value "Generate"))
            )))))))

;; Flora character generator: About
(define (load-fcg-about wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "about")
    (templated-weblet
      fcg-template
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
          ))))))

;; Load all pages
(define (load-pages:flora-character-generator wcontainer)
  (load-fcg-generator wcontainer)
  (load-fcg-sendmail wcontainer)
  (load-fcg-pick wcontainer)
  (load-fcg-about wcontainer))
