(define-module (pages flora-character-generator)
  #:use-module (ffch article)
  #:use-module (ffch forms)
  #:use-module (ffch weblets)
  #:use-module (ffch webtemplates)
  #:use-module (ffch json)
  #:use-module (flora-character-generator description)
  #:use-module (flora-character-generator generator)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator json-output)
  #:use-module (ffch article-exporters markdown-tumblr)
  #:use-module (pages default-template)
  #:use-module (web request)
  #:use-module (rnrs bytevectors)
  #:export (load-pages:flora-character-generator)
  #:duplicates (merge-generics)
)

;;
(define (character-bindings query)
  (let ((bound-parameters (make-character-bound-parameters))
        (species-key-str (hash-ref query "species"))
       )
    (if species-key-str
        (fill-bound-parameters bound-parameters `((species . ,(string->symbol species-key-str)))))
    bound-parameters))

;; Template
(define (fcg-template meta)
  (default-template
    meta
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
            (nav-link-to "/FloraCharacterGenerator/sheet" (nav-current-path path) "Character Sheet Generator"))
          (section
            ((name-class "nav-item"))
            (nav-link-to "/FloraCharacterGenerator/about" (nav-current-path path) "About the generator"))
        )))))

;; Flora character generator
(define (load-fcg-generator wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator")
    (templated-weblet
      (fcg-template default-meta)
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
      (fcg-template default-meta)
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

;;
;; Flora character generator - Character sheet version
(define (lock-view entry-id)
  (list
    (checkbox (checked #f) (id (string-append "lock." entry-id)))
    (label ((for (string-append "lock." entry-id))) " ")))

(define (output-view entry-id)
  (text-input (id (string-append "output." entry-id))))

(define (parameter-view parameter-name entry-id)
  (list (lock-view entry-id) " " parameter-name ": " (output-view entry-id)))

(define (family-member-view character key-id display-family-name?)
  (section ((title character))
    (paragraph
      (parameter-view "Given name" (string-append key-id ".name")) (linefeed)
      (parameter-view "Species" (string-append key-id ".species")) (linefeed)
      (parameter-view "Gender" (string-append key-id ".gender")) (linefeed)
      (parameter-view "Language" (string-append key-id ".language"))
      (if display-family-name?
          (list (linefeed) (parameter-view "Family name" (string-append key-id ".name.family")))
          ""))))

(define (load-fcg-sheet wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "sheet")
    (templated-weblet
      (fcg-template
        (metadata
          (stylesheets
            (static-data "css/feuforeve.css")
            (static-data "css/character-sheet.css"))
          (scripts (static-data "scripts/character-sheet.js"))
          (onload "updateSheet();")))
      (lambda (query)
        (article ((title "Character Sheet Generator")(author "feuforeve.fr"))
          (section
            (paragraph
              "While the character generator generates a description, "
              "this version displays the generated character in a simpler way as a character sheet, "
              "but unlike the other generator, this version allows you to lock parameters "
              "when generating a new character to keep them instead of being overwritten. "
              (linefeed)
              "Click on the lock next to a characteristic to lock or unlock it over generation." (linefeed)
              (button ((onclick "updateSheet();")) "Generate Character"))
          )
          (section ((id "character.sheet"))
            (section ((title "Names"))
              (paragraph
                "Short name: " (output-view "short.name")
                " Pronounced: " (output-view "short.name.pronounciation")
                (linefeed)
                "Full name: " (output-view "full.name")
                " Pronounced: " (output-view "full.name.pronounciation")
                (linefeed)
                "Short and full names are computed from several parameters and cannot be locked directly."
                (linefeed)(linefeed)
                (parameter-view "Given names" "given.names")
                " Pronounced: " (output-view "given.names.pronounciation")
                (linefeed)
                (parameter-view "Other name" "other.name")
                " Pronounced: " (output-view "other.name.pronounciation")
                (linefeed)
                (parameter-view "Language" "language")
              ))
            (section ((title "Main traits"))
              (paragraph
                (parameter-view "Species" "species") (linefeed)
                (parameter-view "Affinity" "affinity") (linefeed)
                (parameter-view "Gender" "gender") " Pronouns: " (output-view "gender.pronouns")))
            (section ((title "Birth"))
              (paragraph
                (parameter-view "Month of birth" "birthdate.month") (linefeed)
                (parameter-view "Day of birth" "birthdate.day") (linefeed)
                (parameter-view "Astrological sign" "astrological.sign") " "
                " The astrological sign depends on the month and day of birth."
                (linefeed)(linefeed)
                (parameter-view "Birth place" "birth.place") (linefeed)
                (parameter-view "Sex" "sex")))
            (section ((title "Current situation"))
              (paragraph
                (parameter-view "Living place" "living.place") (linefeed)
                (parameter-view "Age" "age") (linefeed)
                (parameter-view "Profession" "profession")))
            (section ((title "Physical and personality traits"))
              (paragraph
                (parameter-view "Size" "size") (linefeed)
                (parameter-view "Weight" "weight") (linefeed)
                (parameter-view "Main personality traits" "traits.nature") (linefeed)
                (parameter-view "Other traits" "traits.other") " "
                " The pronouns will be wrong if you lock this and not the gender." (linefeed)
                (parameter-view "Motto" "motto")))
            (section ((title "Family"))
              (paragraph
                (section ((title "Mother side"))
                  (paragraph
                    (family-member-view "Mother" "mother" #f)
                    (family-member-view "Grandmother" "grandmother.mother" #t)
                    (family-member-view "Grandfather" "grandfather.mother" #t)))
                (section ((title "Father side"))
                  (paragraph
                    (family-member-view "Father" "father" #f)
                    (family-member-view "Grandmother" "grandmother.father" #t)
                    (family-member-view "Grandfather" "grandfather.father" #t)))
                (paragraph
                  "Partners, children and pets are not displayed currently. They will never be lockable though.")))
          )
        )
      ))))

;; Backend for character sheet
(define (sheet-bindings query)
  (let* ((request (hash-ref query 'request))
         (request-body (hash-ref query 'request-body))
         (content-type (and request (request-content-type request)))
         (content-encoding
           (and content-type (eq? (caadr content-type) 'charset) (cdadr content-type)))
         (constraints-request-string
                (and content-type (eq? (car content-type) 'text/x-sexpr)
                     content-encoding (equal? content-encoding "UTF-8")
                     request-body (utf8->string request-body)))
         (bound-parameters (make-character-bound-parameters)))
    (catch #t
      (lambda ()
        (if constraints-request-string
            (let ((input (read (open-input-string constraints-request-string))))
              (if (list? input)
                  (fill-bound-parameters bound-parameters input)))))
      (lambda (key . rest)
        (display "Error while reading constraints - ignoring data\n")))
    bound-parameters))

(define (load-fcg-sheet-backend wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "sheet" "backend")
    (weblet ((error-code 200)
             (content-type "application/json;charset=UTF-8"))
      ((path query port)
       (let* ((bound-parameters (sheet-bindings query))
             )
         (display
           (json (character->json-object (generate-character bound-parameters)))
           port)
         (newline port)
       )))))

;; Flora character generator: About
(define (load-fcg-about wcontainer)
  (add-weblet wcontainer (list "FloraCharacterGenerator" "about")
    (templated-weblet
      (fcg-template default-meta)
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
  (load-fcg-sheet wcontainer)
  (load-fcg-sheet-backend wcontainer)
  (load-fcg-about wcontainer))
