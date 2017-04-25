;; Floraverse character generator
;; Languages
(define-module (flora-character-generator languages)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch markhov)
  #:use-module (ffch load-all)
  #:use-module (ffch string)
  #:export (key phoneme
            <word>
            native-transcription latin-transcription pronounciation transcription
            word-language phonemes
            <language>
            empty-word generate-word
            ;
            <language-bound-parameters>
            make-language-bound-parameters father mother bound-language
            bound-given-name bound-other-name bound-family-name bound-gender
            ;
            family-names full-name short-name given-name mother-name father-name
            gff-given-name gmf-given-name gfm-given-name gmm-given-name
            character-given-names character-other-name language-character
            pick-language get-language
            ;
            gender-key
            gmm gfm gmf gff
            gmm-family-name gfm-family-name gmf-family-name gff-family-name
           )
)

;; Phoneme class
(define-class <phoneme> (<object>)
  (key #:accessor key #:init-keyword #:key)
  (pronounciation #:getter pronounciation #:init-keyword #:pronounciation #:init-form "")
  (native-transcription #:getter native-transcription #:init-keyword #:native-transcription #:init-form "")
  (latin-transcription #:getter latin-transcription #:init-keyword #:latin-transcription #:init-form ""))

;; Word class
(define-class <word> (<object>)
  (word-language #:getter word-language #:init-keyword #:word-language)
  (phonemes #:getter phonemes #:init-keyword #:phonemes #:init-form (list)))

(define-method (native-transcription (w <word>))
  (string-normalize-nfc (apply string-append (map native-transcription (phonemes w)))))

(define-method (native-transcription (w <word>) (capitalize? <boolean>))
  (string-capitalize-1st (native-transcription w)))

(define-method (latin-transcription (w <word>))
  (string-normalize-nfc (apply string-append (map latin-transcription (phonemes w)))))

(define-method (latin-transcription (w <word>) (capitalize? <boolean>))
  (string-capitalize-1st (latin-transcription w)))

(define-method (pronounciation (w <word>))
  (apply string-append (map pronounciation (phonemes w))))

; for lists of words
(define-method (native-transcription (lst <pair>))
  (string-join (map native-transcription lst) " "))

(define-method (native-transcription (lst <pair>) (capitalize? <boolean>))
  (string-join (map (lambda (x) (native-transcription x capitalize?)) lst) " "))

(define-method (latin-transcription (lst <pair>))
  (string-join (map latin-transcription lst) " "))

(define-method (latin-transcription (lst <pair>) (capitalize? <boolean>))
  (string-join (map (lambda (x) (latin-transcription x capitalize?)) lst) " "))

(define-method (pronounciation (lst <pair>))
  (string-join (map pronounciation lst) " "))

;; The transcription shows the native trasncription and latin transcription
(define-method (transcription name)
  (let ((native-transcr (native-transcription name #t))
        (latin-transcr (latin-transcription name #t)))
    (string-append
      native-transcr
      (if (equal? native-transcr latin-transcr)
          ""
          (string-append " (" latin-transcr ")")))))

;; Naming rules class
(define-class <naming-rules> (<object>)
  (given-names-min-nb #:getter given-names-min-nb #:init-keyword #:given-names-min-nb #:init-form 1)
  (given-names-max-nb #:getter given-names-max-nb #:init-keyword #:given-names-max-nb #:init-form 1)
  (full-name #:getter full-name #:init-keyword #:full-name #:init-form (make-hash-table))
  (short-name #:getter short-name #:init-keyword #:short-name #:init-form (make-hash-table))
  (father-short-name #:getter father-short-name #:init-keyword #:father-short-name #:init-form (make-hash-table))
  (mother-short-name #:getter mother-short-name #:init-keyword #:mother-short-name #:init-form (make-hash-table)))

;; Language class
(define-class <language> (<object>)
  (key #:getter key #:init-keyword #:key #:init-form #f)
  (phonemes #:getter phonemes #:init-keyword #:phonemes #:init-form (make-hash-table))
  (word-generator #:getter word-generator #:init-keyword #:word-generator #:init-form (markhov-chain 2))
  (naming-rules #:getter naming-rules #:init-keyword #:naming-rules #:init-form #f))

;
(define-method (phoneme (lang <language>) (key <symbol>))
  (hash-ref (phonemes lang) key))

(define-method (empty-word (lang <language>))
  (make <word> #:word-language lang))

(define-method (generate-word (lang <language>))
  (make <word>
        #:word-language lang
        #:phonemes (map (lambda (x) (phoneme lang x)) (generate (word-generator lang)))))

; Useful check when adding a new language
(define-method (check-example (lang <language>) (example <pair>))
  (map
    (lambda (x)
      (if (not (phoneme lang x))
          (error "Unreferenced phoneme in language: " (key lang) x example)))
    example))

;; Individual class & Family names class
;; Needed to load languages
;; Individual is not exported

; Language-related bound parameters
(define-class <language-bound-parameters> (<object>)
  (father #:getter father #:init-keyword #:father #:init-form #f)
  (mother #:getter mother #:init-keyword #:mother #:init-form #f)
  (bound-language #:accessor bound-language #:init-form #f)
  (bound-given-name #:accessor bound-given-name #:init-form #f)
  (bound-other-name #:accessor bound-other-name #:init-form #f)
  (bound-family-name #:accessor bound-family-name #:init-form #f)
  (bound-gender #:accessor bound-gender #:init-form #f))

(define-method (make-language-bound-parameters)
  (let* ((gff (make <language-bound-parameters>))
         (gmf (make <language-bound-parameters>))
         (gfm (make <language-bound-parameters>))
         (gmm (make <language-bound-parameters>))
         (father (make <language-bound-parameters> #:father gff #:mother gmf))
         (mother (make <language-bound-parameters> #:father gfm #:mother gmm)))
    (make <language-bound-parameters> #:father father #:mother mother)))

;;
(define-class <individual> (<object>)
  (language-individual #:getter language-individual #:init-keyword #:language-individual)
  (given-name #:getter given-name #:init-keyword #:given-name)
  (gender-key #:getter gender-key #:init-keyword #:gender-key))

(define-method (individual
                 (lang <language>)
                 (gender-key <symbol>)
                 bound-word)
  (make <individual>
        #:language-individual lang
        #:given-name (or bound-word (generate-word lang))
        #:gender-key gender-key))
;;
(define-class <family-names> (<object>)
  (language-character #:getter language-character #:init-keyword #:language-character)
  (gender-key-character #:getter gender-key-character #:init-keyword #:gender-key-character)
  (gender-key-name-character #:getter gender-key-name-character #:init-keyword #:gender-key-name-character)
  (character-given-names #:getter character-given-names #:init-keyword #:character-given-names)
  (mother #:getter mother #:init-keyword #:mother)
  (father #:getter father #:init-keyword #:father)
  (gmm #:getter gmm #:init-keyword #:gmm)
  (gfm #:getter gfm #:init-keyword #:gfm)
  (gmf #:getter gmf #:init-keyword #:gmf)
  (gff #:getter gff #:init-keyword #:gff)
  (gmm-family-name #:getter gmm-family-name #:init-keyword #:gmm-family-name)
  (gfm-family-name #:getter gfm-family-name #:init-keyword #:gfm-family-name)
  (gmf-family-name #:getter gmf-family-name #:init-keyword #:gmf-family-name)
  (gff-family-name #:getter gff-family-name #:init-keyword #:gff-family-name)
  (character-other-name #:getter character-other-name #:init-keyword #:character-other-name))

(define* (family-names
           #:key constraints language
                 character-gender
                 mother-gender father-gender
                 gmm-gender gfm-gender
                 gmf-gender gff-gender)
  (let* ((naming (naming-rules language))
        (mother-lang (or (bound-language (mother constraints))
                          language))
        (father-lang (or (bound-language (father constraints))
                          language))
        (gmm-lang (or (bound-language (mother (mother constraints)))
                      mother-lang))
        (gfm-lang (or (bound-language (father (mother constraints)))
                      mother-lang))
        (gmf-lang (or (bound-language (mother (father constraints)))
                      father-lang))
        (gff-lang (or (bound-language (father (father constraints)))
                      father-lang)))
    (make <family-names>
      #:language-character language
      #:gender-key-character character-gender
      #:gender-key-name-character (hash-key* (full-name naming) character-gender)
      #:character-given-names
        (or (bound-given-name constraints)
            (map
              (lambda (x) (generate-word language))
              (make-list (pick-from (given-names-min-nb naming) (given-names-max-nb naming)) #f)))
      #:mother (and mother-gender
                    (individual mother-lang mother-gender (bound-given-name (mother constraints))))
      #:father (and father-gender
                    (individual father-lang father-gender (bound-given-name (father constraints))))
      #:gmm (and gmm-gender
                (individual gmm-lang gmm-gender (bound-given-name (mother (mother constraints)))))
      #:gfm (and gfm-gender
                (individual gfm-lang gfm-gender (bound-given-name (father (mother constraints)))))
      #:gmf (and gmf-gender
                (individual gmf-lang gmf-gender (bound-given-name (mother (father constraints)))))
      #:gff (and gff-gender
                (individual gff-lang gff-gender (bound-given-name (father (father constraints)))))
      #:gmm-family-name (and gmm-gender
                            (or (bound-family-name (mother (mother constraints)))
                                (generate-word gmm-lang)))
      #:gfm-family-name (and gfm-gender
                            (or (bound-family-name (father (mother constraints)))
                                (generate-word gfm-lang)))
      #:gmf-family-name (and gmf-gender
                            (or (bound-family-name (mother (father constraints)))
                                (generate-word gmf-lang)))
      #:gff-family-name (and gff-gender
                            (or (bound-family-name (father (father constraints)))
                                (generate-word gff-lang)))
      #:character-other-name (or (bound-other-name constraints) (generate-word language)))))

#!
(define-syntax family-names
  (syntax-rules (constraints language genders character mother father gmm gfm gmf gff)
    ((_ (constraints bound-parameters)
        (language lang)
        (genders
          (character character-gender)
          (mother mother-gender)
          (father father-gender)
          (gmm gmm-gender)
          (gfm gfm-gender)
          (gmf gmf-gender)
          (gff gff-gender)))
     (let* ((naming (naming-rules lang))
            (mother-lang (or (bound-language (mother bound-parameters))
                             lang))
            (father-lang (or (bound-language (father bound-parameters))
                             lang))
            (gmm-lang (or (bound-language (mother (mother bound-parameters)))
                          mother-lang))
            (gfm-lang (or (bound-language (father (mother bound-parameters)))
                          mother-lang))
            (gmf-lang (or (bound-language (mother (father bound-parameters)))
                          father-lang))
            (gff-lang (or (bound-language (father (father bound-parameters)))
                          father-lang)))
       (make <family-names>
         #:language-character lang
         #:gender-key-character character-gender
         #:gender-key-name-character (hash-key* (full-name naming) character-gender)
         #:character-given-names
           (or (bound-given-name bound-parameters)
               (map
                 (lambda (x) (generate-word lang))
                 (make-list (pick-from (given-names-min-nb naming) (given-names-max-nb naming)) #f)))
         #:mother (and mother-gender
                       (individual mother-lang mother-gender (bound-given-name (mother bound-parameters))))
         #:father (and father-gender
                       (individual father-lang father-gender (bound-given-name (father bound-parameters))))
         #:gmm (and gmm-gender
                    (individual gmm-lang gmm-gender (bound-given-name (mother (mother bound-parameters)))))
         #:gfm (and gfm-gender
                    (individual gfm-lang gfm-gender (bound-given-name (father (mother bound-parameters)))))
         #:gmf (and gmf-gender
                    (individual gmf-lang gmf-gender (bound-given-name (mother (father bound-parameters)))))
         #:gff (and gff-gender
                    (individual gff-lang gff-gender (bound-given-name (father (father bound-parameters)))))
         #:gmm-family-name (and gmm-gender
                                (or (bound-family-name (mother (mother bound-parameters)))
                                    (generate-word gmm-lang)))
         #:gfm-family-name (and gfm-gender
                                (or (bound-family-name (father (mother bound-parameters)))
                                    (generate-word gfm-lang)))
         #:gmf-family-name (and gmf-gender
                                (or (bound-family-name (mother (father bound-parameters)))
                                    (generate-word gmf-lang)))
         #:gff-family-name (and gff-gender
                                (or (bound-family-name (father (father bound-parameters)))
                                    (generate-word gff-lang)))
         #:character-other-name (or (bound-other-name bound-parameters) (generate-word lang)))))))
!#
; Short methods for use in language definitions
(define-method (GiNa (names <family-names>))
  (list (car (character-given-names names))))

(define-method (GiNa% (names <family-names>))
  (character-given-names names))

(define-method (OtNa (names <family-names>))
  (list (character-other-name names)))

;
(define-method (ascendant-given-name (names <family-names>) (rst <list>))
  (if (null? rst)
      (list (empty-word (language-character names)))
      (if ((car rst) names)
          (list (given-name ((car rst) names)))
          (ascendant-given-name names (cdr rst)))))

(define-method (GiNaM (names <family-names>))
  (ascendant-given-name names (list mother father)))

(define-method (GiNaF (names <family-names>))
  (ascendant-given-name names (list father mother)))

(define-method (GiNaGMM (names <family-names>))
  (ascendant-given-name names (list gmm gfm gmf gff)))

(define-method (GiNaGFM (names <family-names>))
  (ascendant-given-name names (list gfm gmm gff gmf)))

(define-method (GiNaGMF (names <family-names>))
  (ascendant-given-name names (list gmf gff gmm gfm)))

(define-method (GiNaGFF (names <family-names>))
  (ascendant-given-name names (list gff gmf gfm gmm)))

(define-method (ascendant-family-name (names <family-names>) (rst <list>))
  (if (null? rst)
      (list (empty-word (language-character names)))
      (if ((car rst) names)
          (list ((car rst) names))
          (ascendant-family-name names (cdr rst)))))

(define-method (FaGMM (names <family-names>))
  (ascendant-family-name names (list gmm-family-name gfm-family-name gmf-family-name gff-family-name)))

(define-method (FaGFM (names <family-names>))
  (ascendant-family-name names (list gfm-family-name gmm-family-name gff-family-name gmf-family-name)))

(define-method (FaGMF (names <family-names>))
  (ascendant-family-name names (list gmf-family-name gff-family-name gmm-family-name gfm-family-name)))

(define-method (FaGFF (names <family-names>))
  (ascendant-family-name names (list gff-family-name gmf-family-name gfm-family-name gmm-family-name)))

;
(define-method (get-name (names <family-names>) name-type (lang <language>) (gender-key <symbol>))
  (let ((rules (naming-rules lang)))
    (apply
      append
      (map
        (lambda (x) (x names))
        (hash-ref* (name-type rules) gender-key)))))

(define-method (full-name (names <family-names>))
  (get-name names full-name (language-character names) (gender-key-name-character names)))

(define-method (short-name (names <family-names>))
  (get-name names short-name (language-character names) (gender-key-name-character names)))

(define-method (given-name (names <family-names>))
  (car (character-given-names names)))

(define-method (mother-name (names <family-names>))
  (if (mother names)
      (get-name names mother-short-name (language-individual (mother names)) (gender-key (mother names)))
      (list (empty-word (language-character names)))))

(define-method (father-name (names <family-names>))
  (if (father names)
      (get-name names father-short-name (language-individual (father names)) (gender-key (father names)))
      (list (empty-word (language-character names)))))

(define-method (gff-given-name (names <family-names>))
  (GiNaGFF names))
(define-method (gmf-given-name (names <family-names>))
  (GiNaGMF names))
(define-method (gfm-given-name (names <family-names>))
  (GiNaGFM names))
(define-method (gmm-given-name (names <family-names>))
  (GiNaGMM names))

;; Language singleton
(define *data:languages* (make-hash-table))

(define-method (pick-language)
  (cdr (pick-from *data:languages*)))

(define-method (get-language (language-key <symbol>))
  (hash-ref *data:languages* language-key))

;; Data syntax
(define-syntax language
  (syntax-rules (names name-rules words generator-order phonemes examples)
   ((_ language-key
       (names
         (names-slot names-value) ...
         (name-rules (name-hash-slot (gender-key fun ...) ...) ...))
       (words
         (generator-order order)
         (phonemes (phoneme-key phoneme-pronounciation phoneme-native-transcr phoneme-latin-transcr) ...)
         (examples (example-key ...) ...)))
    (let* ((naming-rules (make <naming-rules>))
           (lang (make <language>
                      #:key (quote language-key)
                      #:word-generator (markhov-chain order)
                      #:naming-rules naming-rules)))
      (begin (slot-set! naming-rules (quote names-slot) names-value) ...)
      (begin (let ((nhs name-hash-slot)) (hash-set! (nhs naming-rules) (quote gender-key) (list fun ...)) ...) ...)
      (begin
        (hash-set! (phonemes lang)
                   (quote phoneme-key)
                   (make <phoneme>
                         #:key (quote phoneme-key)
                         #:native-transcription phoneme-native-transcr
                         #:latin-transcription phoneme-latin-transcr
                         #:pronounciation phoneme-pronounciation)) ...)
      (begin (check-example lang (list (quote example-key) ...)) ...)
      (begin (add-example (word-generator lang) (list (quote example-key) ...)) ...)
      (hash-set! *data:languages* (quote language-key) lang)
      lang))))

;; Load languages to fill *data:languages*
(load-all-from-path "flora-character-generator/data/languages")
