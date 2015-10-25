;; Floraverse character generator
;; JSON Output of a character
(define-module (flora-character-generator json-output)
  #:version (0 0 1)
  #:use-module (oop goops)
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
  #:export (character->json-object)
  #:duplicates (merge-generics))

(define-method (word->json-object (word <word>))
  `((word-phonemes
      ,(string-append
         "#("
         (string-join
           (map (lambda (phon) (symbol->string (key phon))) (phonemes word))
           " ")
         ")"))
    (word-language ,(key (word-language word)))
    (transcription ,(transcription word #t))
    (pronounciation ,(pronounciation word))))

(define-method (words->json-object (words <pair>))
  `((transcription ,(transcription words #t))
    (pronounciation ,(pronounciation words))))

(define-method (names->json-object (char <character>))
  (let* ((fam (family char))
         (names (fam-names fam))
         (lang (language-character names)))
    `((short ,(words->json-object (short-name fam)))
      (full ,(words->json-object (full-name fam)))
      (given
        ,(list->vector
           (map
             word->json-object
             (character-given-names names))))
      (other ,(word->json-object (character-other-name names)))
      (language
        ((name ,(key lang))
         (key ,(key lang)))))))

(define-method (species->json-object (char <character>))
  (let ((sp (species char))
        (bsp (base-species (self (family char)))))
    `((name ,(name sp))
      (key ,(key sp))
      (mimic-name ,(and bsp (name bsp)))
      (mimic-key ,(and bsp (key bsp))))))

(define-method (affinity->json-object (char <character>))
  (let ((aff (affinity char)))
    `((name ,(name aff))
      (key ,(key aff)))))

(define-method (gender->json-object (char <character>))
  (let ((gen (gender char)))
    `((title ,(title-full gen))
      (key ,(key gen))
      (pronouns ,(string-append (subject-pronoun gen) "/"
                                (object-pronoun gen) "/"
                                (genitive-adjective gen) "/"
                                (reflexive-pronoun gen))))))

(define-method (birthdate->json-object (char <character>))
  (let ((date (birthday char)))
    `((day ,(day date))
      (month ((name ,(name (month date)))
              (key ,(number (month date)))))
      (astrological-sign ((name ,(name (astrological-sign date)))
                          (key ,(key (astrological-sign date))))))))

(define-method (birth-place->json-object (char <character>))
  (name (birth-place char)))

(define-method (sex->json-object (char <character>))
  `((description ,(description (sex char)))
    (key ,(key (sex char)))))

(define-method (living-place->json-object (char <character>))
  (name (living-place char)))

(define-method (age->json-object (char <character>))
  `((description ,(description (age char)))
    (key ,(key (age char)))))

(define-method (profession->json-object (char <character>))
  (profession char))

(define-method (size->json-object (char <character>))
  (size char))

(define-method (weight->json-object (char <character>))
  (weight char))

(define-method (natures->json-object (char <character>))
  (list->vector (natures char)))

(define-method (traits->json-object (char <character>))
  (list->vector (traits char)))

(define-method (motto->json-object (char <character>))
  (motto char))

(define-method (character->json-object (char <character>))
  `((names ,(names->json-object char))
    (species ,(species->json-object char))
    (affinity ,(affinity->json-object char))
    (gender ,(gender->json-object char))
    (birthdate ,(birthdate->json-object char))
    (birth-place ,(birth-place->json-object char))
    (sex ,(sex->json-object char))
    (living-place ,(living-place->json-object char))
    (age ,(age->json-object char))
    (profession ,(profession->json-object char))
    (size ,(size->json-object char))
    (weight ,(weight->json-object char))
    (natures ,(natures->json-object char))
    (traits ,(traits->json-object char))
    (motto ,(motto->json-object char))
   ))
