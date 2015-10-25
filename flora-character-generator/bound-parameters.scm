;; Floraverse character generator
;; Bound parameters
(define-module (flora-character-generator bound-parameters)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (flora-character-generator languages)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator calendar)
  #:use-module (flora-character-generator sexes)
  #:use-module (flora-character-generator locations)
  #:use-module (flora-character-generator ages-of-life)
  #:export (<bound-parameters> make-bound-parameters fill-bound-parameters
            ;
            language-parameters species-parameters bound-affinity bound-gender
            birthdate-parameters bound-birth-place bound-sex
            bound-living-place bound-age bound-profession
           )
  #:duplicates (merge-generics))

; Character bound parameters class when generating a character
(define-class <bound-parameters> (<object>)
  (language-parameters #:getter language-parameters #:init-form (make-language-bound-parameters))
  (species-parameters #:getter species-parameters #:init-form (make-species-bound-parameters))
  (bound-affinity #:accessor bound-affinity #:init-form #f)
  (bound-gender #:accessor bound-gender #:init-form #f)
  (birthdate-parameters #:getter birthdate-parameters #:init-form (make-birthdate-bound-parameters))
  (bound-birth-place #:accessor bound-birth-place #:init-form #f)
  (bound-sex #:accessor bound-sex #:init-form #f)
  (bound-living-place #:accessor bound-living-place #:init-form #f)
  (bound-age #:accessor bound-age #:init-form #f)
  (bound-profession #:accessor bound-profession #:init-form #f)
)

(define-method (make-bound-parameters)
  (make <bound-parameters>))

;
(define (sloppy-assq-ref alist key)
  (let ((pr (sloppy-assq key alist)))
    (and pr (cdr pr))))

;; Define the getters used in the other modules
(define (get-checked-language language-key)
  (and (symbol? language-key) (get-language language-key)))

(define (get-checked-species species-key)
  (and (symbol? species-key) (get-species species-key)))

(define (get-checked-element element-key)
  (and (symbol? element-key) (get-element element-key)))

(define (get-checked-gender gender-key)
  (and (symbol? gender-key) (get-gender gender-key)))

(define-method (check-add-birthdate (bound-parameters <bound-parameters>) birthdate)
  (if (list? birthdate)
      (let* ((month-id (sloppy-assq-ref birthdate 'month))
             (day-id (sloppy-assq-ref birthdate 'day))
             (astrological-sign-id (sloppy-assq-ref birthdate 'astrological-sign))
             (month-param (and (integer? month-id) (find-month month-id)))
             (day-param (and (integer? day-id) day-id))
             (astrological-sign-param
               (and (symbol? astrological-sign-id) (get-astrological-sign astrological-sign-id)))
            )
        (set! (month (birthdate-parameters bound-parameters)) month-param)
        (set! (day (birthdate-parameters bound-parameters)) day-param)
        (set! (astrological-sign (birthdate-parameters bound-parameters)) astrological-sign-param))))

(define (get-checked-place place-name)
  (and (string? place-name) (place-from-name place-name)))

(define (get-checked-sex sex-id)
  (and (symbol? sex-id) (get-sex sex-id)))

(define (get-checked-age age-id)
  (and (symbol? age-id) (get-age-of-life age-id)))

(define (get-checked-profession profession)
  (and (string? profession) profession))

;
(define-method (fill-bound-parameters (bound-parameters <bound-parameters>) (constraints <list>))
  ;(write constraints)(newline)
  (check-add-given-names bound-parameters (sloppy-assq-ref constraints 'given-names))
  (check-add-other-name bound-parameters (sloppy-assq-ref constraints 'other-name))
  (set! (bound-language (language-parameters bound-parameters))
        (get-checked-language (sloppy-assq-ref constraints 'language)))
  (set! (bound-species (species-parameters bound-parameters))
        (get-checked-species (sloppy-assq-ref constraints 'species)))
  (set! (bound-base-species (species-parameters bound-parameters))
        (get-checked-species (sloppy-assq-ref constraints 'base-species)))
  (set! (bound-affinity bound-parameters)
        (get-checked-element (sloppy-assq-ref constraints 'affinity)))
  (set! (bound-gender bound-parameters)
        (get-checked-gender (sloppy-assq-ref constraints 'gender)))
  (check-add-birthdate bound-parameters (sloppy-assq-ref constraints 'birthdate))
  (set! (bound-birth-place bound-parameters)
        (get-checked-place (sloppy-assq-ref constraints 'birth-place)))
  (set! (bound-sex bound-parameters)
        (get-checked-sex (sloppy-assq-ref constraints 'sex)))
  (set! (bound-living-place bound-parameters)
        (get-checked-place (sloppy-assq-ref constraints 'living-place)))
  (set! (bound-age bound-parameters)
        (get-checked-age (sloppy-assq-ref constraints 'age)))
  (set! (bound-profession bound-parameters)
        (get-checked-profession (sloppy-assq-ref constraints 'profession)))
)

(define-method (check-word (word <list>))
  (let* ((phn (sloppy-assq-ref word 'word-phonemes))
         (lang (get-language (sloppy-assq-ref word 'word-language)))
         (phon (and lang phn (vector? phn)
                    (map
                      (lambda (x)
                        (and (symbol? x)
                             (phoneme lang x)))
                      (vector->list phn))))
        )
    (if (member #f phon)
        #f
        (make <word> #:word-language lang #:phonemes phon))))

(define-method (check-add-given-names (bound-parameters <bound-parameters>) names)
  (set!
    (bound-given-name (language-parameters bound-parameters))
    (and (vector? names)
         (let ((lst-names
                 (map
                   (lambda (x) (and (list? x) (eq? (length x) 2) (check-word x)))
                   (vector->list names))))
           (if (member #f lst-names)
               #f
               lst-names)))))

(define-method (check-add-other-name (bound-parameters <bound-parameters>) name)
  (set!
    (bound-other-name (language-parameters bound-parameters))
    (and (list? name) (eq? (length name) 2) (check-word name))))
