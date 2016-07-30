;; Floraverse character generator
;; Description generator
(define-module (flora-character-generator description)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch article)
  #:use-module (ffch string)
  #:use-module (ffch colors)
  #:use-module (flora-character-generator generator)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator sexes)
  #:use-module (flora-character-generator calendar)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator ages-of-life)
  #:use-module (flora-character-generator locations)
  #:use-module (flora-character-generator languages)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator english)
  #:use-module (flora-character-generator family)
  #:use-module (flora-character-generator abilities)
  #:export (generate-character-description)
  #:duplicates (merge-generics))

;;;;
;; Utils methods
;
(define-method (with-undefined-article-and-link (species <species>) base-species)
  (let ((str-bsp (if base-species (name base-species) #f))
        (str-sp (name species)))
    (list
      (if base-species
          (get-undefined-article str-bsp)
          (get-undefined-article str-sp))
      " "
      (if base-species
          (list (hyperlink ((to (reference-link base-species))) str-bsp) " ")
          "")
      (hyperlink ((to (reference-link species))) str-sp))))

;;;;
;; Description generation
(define-method (generate-character-description (char <character>))
  (let* ((gen (gender char))
         (all-names (family char))
         (ttl (string-append
                (string-capitalize-1st (title-short gen)) " "
                (transcription (short-name all-names))))
        )
    (article ((title ttl)(author "feuforeve.fr"))
      (introduction-section char)
      (name-section char)
      (birth-section char)
      (current-situation-section char)
      (traits-section char)
      (abilities-section char)
      (family-section char)
      (pets-section char)
    )))
;
(define-method (introduction-section (char <character>))
  (let* ((gen (gender char))
         (subject (subject-pronoun gen))
         (plural (plural? gen))
         (all-names (family char))
         (sp (species char))
         (bsp (base-species (self all-names)))
         (aff (affinity char)))
    (section ((title "Introduction"))
      (paragraph
        (string-capitalize-1st (title-short gen)) " "
        (transcription (short-name all-names))
        " " (3rd-person-of "be" plural) " "
        (with-undefined-article-and-link sp bsp) " with "
        (if (eq? 'none (key aff)) "no" (with-undefined-article (name aff))) " affinity. "
      ))))
;
(define-method (name-section (char <character>))
  (let* ((gen (gender char))
         (genitive (genitive-adjective gen))
         (all-names (family char))
         (fullname (full-name all-names)))
    (section ((title "Names"))
      (paragraph
        (string-capitalize-1st genitive) " full name is "
        (transcription fullname) " and is pronounced "
        "/" (pronounciation fullname) "/. "
        (string-capitalize-1st genitive) " given name is "
        (transcription (given-name all-names)) ". "
      ))))
;
(define-method (birth-section (char <character>))
  (let* ((gen (gender char))
         (subject (subject-pronoun gen))
         (genitive (genitive-adjective gen))
         (plural (plural? gen))
         (birthdate (birthday char))
         (birthday (day birthdate))
         (birthplace (birth-place char)))
    (section ((title "Birth"))
      (paragraph
        (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " born "
        (description (sex char))
        " on the " (ordinal birthday) " of " (name (month birthdate)) " "
        (if (in-birth-place? char)
            (preposition-in (type birthplace))
            (preposition-near (type birthplace)))
        " " (hyperlink ((to (reference-link birthplace))) (name birthplace)) ". "
        (string-capitalize-1st genitive) " astrological sign is " (name (astrological-sign birthdate)) ". "
      ))))
;
(define-method (current-situation-section (char <character>))
  (let* ((gen (gender char))
         (subject (subject-pronoun gen))
         (plural (plural? gen))
         (prof (profession char))
         (livingplace (living-place char)))
    (section ((title "Current situation"))
      (paragraph
        (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
        (with-undefined-article (description (age char))) ". "
        (if prof
            (list (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
                  (with-undefined-article prof) ". ")
            "")
        (string-capitalize-1st subject) " " (3rd-person-of "live" plural) " "
        (if (in-living-place? char)
            (preposition-in (type livingplace))
            (preposition-near (type livingplace)))
        " " (hyperlink ((to (reference-link livingplace))) (name livingplace)) ". "
      ))))
;
(define-method (traits-section (char <character>))
  (let* ((gen (gender char))
         (subject (subject-pronoun gen))
         (genitive (genitive-adjective gen))
         (plural (plural? gen))
         (nats (natures char))
         (size (size char))
         (weight (weight char))
        )
    (section ((title "Physical traits and personality"))
      (if (or size weight)
          (paragraph
            (if size
                (list
                  (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
                  size " for "
                  (with-undefined-article-and-link (species char) (base-species (self (family char))))
                  ". ")
                "")
            (if weight
                (list
                  (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
                  weight ". ")
                ""))
          "")
      (paragraph
        (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
        (map (lambda (x) (string-append x ", ")) (cdr nats))
        (if (null? (cdr nats)) "" "and ") (car nats) ". "
        (traits char))
      (paragraph
        (string-capitalize-1st genitive) " motto: “" (motto char) "”")
      (figure ((caption "Fig.1: Body colors"))
        (map
          (lambda (col)
            (inline
              ((style
                  (string-append
                    "display:inline-block; width:30px; height:20px;"
                    "border-style:solid; border-width:thin;"
                    "background:" (css-value col) ";")))
              ""))
          (colors char)))
    )))

(define-method (abilities-section (char <character>))
  (let ((abilities-lst (abilities char))
        (ability-paragraph (lambda (ab) (paragraph (section ((title (name ab))) (description ab))))))
    (if (not (null? abilities-lst))
        (section ((title "Abilities"))
          (map ability-paragraph abilities-lst))
        "")))

(define-method (family-section (char <character>))
  (letrec* ((gen (gender char))
            (subject (subject-pronoun gen))
            (genitive (genitive-adjective gen))
            (plural (plural? gen))
            (fam (family char))
            (ch-father (father fam))
            (ch-mother (mother fam))
            (ch-foster (foster fam))
            (partners-children (partners-and-children fam))
            (parent-paragraph
              (lambda (parent parent-type gmother gfather)
                (let ((gm (if gmother (gmother fam) #f))
                      (gf (if gfather (gfather fam) #f)))
                  (list
                    (string-capitalize-1st genitive) " " parent-type ", " (transcription (name parent))
                    ", is " (with-undefined-article-and-link (species parent) (base-species parent)) ". "
                    (if gm (parent-paragraph gm (string-append parent-type "'s " "mother") #f #f) "")
                    (if gf (parent-paragraph gf (string-append parent-type "'s " "father") #f #f) "")))))
            (partner-paragraph
              (lambda (partner+children current?)
                (let ((ptner (partner partner+children))
                      (is-mother? (mother? partner+children))
                      (cdren (children partner+children)))
                  (list
                    (string-capitalize-1st subject) " "
                    (if current?
                      (list "currently " (3rd-person-of "live" plural))
                      "formerly lived")
                    " with " (with-undefined-article-and-link (species ptner) (base-species ptner))
                    " named " (transcription (name ptner)) ". "
                    (if (not (null? cdren))
                        (list "Of this relationship, " subject " " (3rd-person-of "be" plural)
                              " the " (if is-mother? "mother" "father") " of "
                              (if (not (null? (cdr cdren)))
                                  (list
                                    (map
                                      (lambda (x)
                                        (list
                                          (with-undefined-article-and-link (species x) (base-species x))
                                          " named " (transcription (name x)) ", "))
                                      (cdr cdren))
                                    " and ")
                                  "")
                              (with-undefined-article-and-link (species (car cdren)) (base-species (car cdren)))
                              " named " (transcription (name (car cdren))) ". " (linefeed))
                        (linefeed))))))
         )
    (if (or ch-father ch-mother ch-foster (not (null? partners-children)))
        (section ((title "Family"))
          (if ch-mother
              (paragraph (parent-paragraph ch-mother "mother" gmm gfm))
              "")
          (if ch-father
              (paragraph (parent-paragraph ch-father "father" gmf gff))
              "")
          (if ch-foster
              (paragraph
                (string-capitalize-1st subject) " " (if plural "were" "was")
                (if (or ch-mother ch-father)
                    (list " not raised by " genitive " biological parent"
                          (if (and ch-mother ch-father) "s" "") " but ")
                    " raised ")
                "by " (with-undefined-article-and-link (species ch-foster) (base-species ch-foster))
                " named " (transcription (name ch-foster)))
              "")
          (if (not (null? partners-children))
              (paragraph
                (partner-paragraph (car partners-children) #t)
                (map (lambda (x) (partner-paragraph x #f)) (cdr partners-children)))
              ""))
        "")))

(define-method (pets-section (char <character>))
  (let* ((pets (pets (family char)))
         (gen (gender char))
         (subject (subject-pronoun gen))
         (plural (plural? gen))
         (display-pet
           (lambda (pet)
             (list (with-undefined-article-and-link (species pet) (base-species pet)) " named "
                   (transcription (name pet)) ", ")))
         )
    (if (not (null? pets))
        (section ((title "Pets"))
          (paragraph
            (string-capitalize-1st subject) " " (3rd-person-of "own" plural) " "
            (map display-pet (cdr pets)) (if (not (null? (cdr pets))) "and " "")
            (with-undefined-article-and-link (species (car pets)) (base-species (car pets)))
            " named " (transcription (name (car pets))) ". "
          ))
        "")))
