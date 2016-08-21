(define-module (floraverse-postbot)
  #:use-module (oauth oauth1)
  #:use-module (json)
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
  #:duplicates (merge-generics)
)

;; To avoid using the C locale in guile-2.0
(setlocale LC_ALL "")

;; Initialize the random number generator
(set! *random-state* (random-state-from-platform))

(define *twitter-root* "https://api.twitter.com/1.1")
(define *status-update* "/statuses/update.json")

;; Twitter keys
(define *twitter-username* "...")
(define *twitter-consumer-key* "...")
(define *twitter-consumer-secret* "...")
(define *twitter-access-token* "...")
(define *twitter-access-token-secret* "...")

;; Useful tools
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

(define (take lst n)
  (if (>= 0 n)
      '()
      (cons (car lst) (take (cdr lst) (- n 1)))))

; Introduction
(define (intro-tweet character)
  (let* ((gen (gender character))
         (plural (plural? gen))
         (fam (family character))
         (sp (species character))
         (bsp (base-species (self fam)))
         (aff (affinity character)))
    (string-append
      (string-capitalize-1st (title-short gen)) " "
      (transcription (short-name fam)) " (/" (pronounciation (short-name fam)) "/)"
      " " (3rd-person-of "be" plural) " "
      (add-undefined-article sp bsp) " with "
      (if (eq? 'none (key aff)) "no" (with-undefined-article (name aff))) " affinity.")))

; Birth
(define (birth-tweet character)
  (let* ((gen (gender character))
         (subject (subject-pronoun gen))
         (plural (plural? gen))
         (fam (family character))
         (birthdate (birthday character))
         (birthday (day birthdate))
         (birthplace (birth-place character)))
    (string-append
      (string-capitalize-1st subject) " " (3rd-person-of "be" plural) " born "
      (description (sex character))
      " on the " (ordinal birthday) " of " (name (month birthdate)) " "
      "(sign: " (name (astrological-sign birthdate)) ") "
      (if (in-birth-place? character)
            (preposition-in (type birthplace))
            (preposition-near (type birthplace)))
      " " (name birthplace) ".")))

; Natures
(define (natures-tweet character)
  (let* ((gen (gender character))
         (subject (subject-pronoun gen))
         (plural (plural? gen))
         (fam (family character))
         (sp (species character))
         (bsp (base-species (self fam)))
         (nats (natures character))
         (size (size character))
         (weight (weight character)))
    (string-append
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
        (if (null? (cdr nats)) "" "and ") (car nats) ".")
    )))

; Traits - Only the first 4 are used
(define (traits-tweet character)
  (let* ((lst (traits character))
         (trts (if (> 4 (length lst)) lst (take lst 4))))
    (string-join trts "")))

;; Extract Status Id of tweet from the json answer
(define (extract-status-id str)
  (hash-ref (json-string->scm str) "id_str"))

;; Post a status, return the id
(define (post-status msg)
  (let ((credentials (oauth1-credentials *twitter-consumer-key* *twitter-consumer-secret*))
        (access (oauth1-credentials *twitter-access-token* *twitter-access-token-secret*)))
    (extract-status-id
      (oauth1-client-request
        (string-append *twitter-root* *status-update*)
        credentials
        access
        #:method 'POST
        #:params `((status . ,msg))
      ))))

;; Post a reply, return the id
(define (post-reply msg in-reply-to-id)
  (let ((credentials (oauth1-credentials *twitter-consumer-key* *twitter-consumer-secret*))
        (access (oauth1-credentials *twitter-access-token* *twitter-access-token-secret*)))
    (if in-reply-to-id
        (extract-status-id
            (oauth1-client-request
              (string-append *twitter-root* *status-update*)
              credentials
              access
              #:method 'POST
              #:params `((status . ,(string-append "@" *twitter-username* " " msg))
                        (in_reply_to_status_id . ,in-reply-to-id))
            ))
        #f)))

;; Fill the twitter keys before using this
(let* ((character (generate-character))
       (intro (intro-tweet character))
       (birth (birth-tweet character))
       (natures (natures-tweet character))
       (traits (traits-tweet character))
       (id-intro #f) (id-birth #f) (id-natures #f) (id-traits #f)
      )
  (set! id-intro (post-status (intro-tweet character)))
  (display id-intro)(newline)
  (set! id-birth (post-reply (birth-tweet character) id-intro))
  (display id-birth)(newline)
  (set! id-natures (post-reply (natures-tweet character) id-birth))
  (display id-natures)(newline)
  (set! id-traits (post-reply (traits-tweet character) id-natures))
  (display id-traits)(newline)
)
