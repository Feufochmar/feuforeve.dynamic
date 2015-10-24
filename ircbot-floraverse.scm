(define-module (ircbot-floraverse)
  #:use-module (ffch ircbot)
  ;
  #:use-module (ffch string)
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
  ;
  #:export (main)
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))
(set-port-encoding! (current-output-port) "UTF-8")

;;
(define (add-undefined-article species base-species)
  (let ((str-bsp (if base-species (name base-species) #f))
        (str-sp (name species)))
    (string-append
      (if base-species
          (get-undefined-article str-bsp)
          (get-undefined-article str-sp))
      " "
      (if base-species
          (string-append str-bsp " ")
          "")
      str-sp)))

;; Since output is limited to ~500 characters, do not print everything
;; Only a subset (introduction + birth + traits) is printed
(define (generate-description character)
  (let* ((gen (gender character))
         (subject (subject-pronoun gen))
         (genitive (genitive-adjective gen))
         (plural (plural? gen))
         (fam (family character))
         (sp (species character))
         (bsp (base-species (self fam)))
         (aff (affinity character))
         (nats (natures character))
         (size (size character))
         (weight (weight character))
         (birthdate (birthday character))
         (birthday (day birthdate))
         (birthplace (birth-place character)))
    (string-append
      ; Introduction
      (string-capitalize-1st (title-short gen)) " "
      (transcription (short-name fam) #t) " (/" (pronounciation (short-name fam)) "/)"
      " " (3rd-person-of "be" plural) " "
      (add-undefined-article sp bsp) " with "
      (if (eq? 'none (key aff)) "no" (with-undefined-article (name aff))) " affinity. "
      ; Birth
      (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " born "
      (description (sex character))
      " on the " (ordinal birthday) " of " (name (month birthdate)) " "
      "(sign: " (name (astrological-sign birthdate)) ") "
      (if (in-birth-place? character)
            (preposition-in (type birthplace))
            (preposition-near (type birthplace)))
      " " (name birthplace) ". "
      ; Traits
      (if (or size weight)
          (string-append
            (if size
                (string-append
                  (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
                  size " for "
                  (add-undefined-article sp bsp)
                  ". ")
                "")
            (if weight
                (string-append
                  (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
                  weight ". ")
                ""))
          "")
      (string-append
        (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " "
        (string-join (map (lambda (x) (string-append x ", ")) (cdr nats)) "")
        (if (null? (cdr nats)) "" "and ") (car nats) ". "
        (string-join (traits character) ""))
    )))

(define (add-handlers ircbot)
  ; Add commands
  (add-command-handler!
    ircbot
    "help"
    (lambda (ircbot channel asker args)
      (send-privmsg ircbot asker
                    (if (null? args)
                        "Possible commands: generate character-generator reference help"
                        (let ((cmd (car args)))
                             (cond
                               ((string=? cmd "help")
                                "help: get help about the commands")
                               ((string=? cmd "generate")
                                "generate: generate a new character, character species as optional parameter")
                               ((string=? cmd "character-generator")
                                "character-generator: return the link to the full version of character generator")
                               ((string=? cmd "reference")
                                "reference: with a species or area as parameter, return the reference")
                               (#t "Unknown command. Possible commands: generate character-generator reference help")
                             ))))))
  (add-command-handler!
    ircbot
    "generate"
    (lambda (ircbot channel asker args)
      (let* ((bound-parameters
               (let ((bp (make-character-bound-parameters)))
                 (fill-bound-parameters bp `((species . ,(string->symbol (string-downcase (string-join args "-"))))))
                 bp))
             (character (generate-character bound-parameters)))
        (send-privmsg ircbot asker (generate-description character)))))
  (add-command-handler!
    ircbot
    "character-generator"
    (lambda (ircbot channel asker args)
      (send-privmsg ircbot channel (string-append asker ": http://feuforeve.fr/FloraCharacterGenerator"))))
  (add-command-handler!
    ircbot
    "reference"
    (lambda (ircbot channel asker args)
      (let* ((species-key (string->symbol (string-downcase (string-join args "-"))))
             (species (get-species species-key)))
        (send-privmsg ircbot channel
                      (string-append
                        asker ": "
                        (if species
                            (reference-link species)
                            (let ((place (find-place (string-join args " "))))
                                 (if place
                                     (reference-link place)
                                     (string-append "No data on " (string-join args " "))))))))))
)

(define (main args)
  (let ((ircbot (make-ircbot-from-command-line-args args)))
    (if ircbot
        (begin
          (add-handlers ircbot)
          ; Run bot
          (run-bot ircbot)
          ; run-bot exits on disconnection - restart
          (main args)))))
