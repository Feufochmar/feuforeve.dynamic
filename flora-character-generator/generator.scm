;; Floraverse character generator
;; Character generator
(define-module (flora-character-generator generator)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch distribution)
  #:use-module (flora-character-generator mottos)
  #:use-module (flora-character-generator natures)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator sexes)
  #:use-module (flora-character-generator calendar)
  #:use-module (flora-character-generator ages-of-life)
  #:use-module (flora-character-generator locations)
  #:use-module (flora-character-generator languages)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator traits)
  #:use-module (flora-character-generator family)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator bound-parameters)
  #:use-module (flora-character-generator palette)
  #:export (generate-character
            ;
            <character>
            motto natures gender sex birthday affinity age profession
            birth-place in-birth-place? living-place in-living-place?
            language family species size weight traits colors
           )
  #:duplicates (merge-generics))

;; Character class
(define-class <character> (<object>)
  (motto #:getter motto #:init-keyword #:motto)
  (natures #:getter natures #:init-keyword #:natures)
  (gender #:getter gender #:init-keyword #:gender)
  (sex #:getter sex #:init-keyword #:sex)
  (birthday #:getter birthday #:init-keyword #:birthday)
  (affinity #:getter affinity #:init-keyword #:affinity)
  (age #:getter age #:init-keyword #:age)
  (profession #:getter profession #:init-keyword #:profession)
  (birth-place #:getter birth-place #:init-keyword #:birth-place)
  (in-birth-place? #:getter in-birth-place? #:init-keyword #:in-birth-place?) ;; in or near ?
  (living-place #:getter living-place #:init-keyword #:living-place)
  (in-living-place? #:getter in-living-place? #:init-keyword #:in-living-place?) ;; in or near ?
  (language #:getter language #:init-keyword #:language)
  (species #:getter species #:init-keyword #:species)
  (family #:getter family #:init-keyword #:family)
  (size #:getter size #:init-keyword #:size)
  (weight #:getter weight #:init-keyword #:weight)
  (traits #:getter traits #:init-keyword #:traits)
  (colors #:getter colors #:init-keyword #:colors)
)

;
(define-method (pick-weight)
  (let ((numeric (random:normal)))
    (cond
      ((> numeric 1.35) "obese")
      ((> numeric 0.67) "fat")
      ((> numeric 0.15) "plump")
      ((> numeric -0.15) #f)
      ((> numeric -0.67) "slim")
      ((> numeric -1.35) "thin")
      (#t "emaciated"))))

(define-method (pick-size)
  (let ((numeric (random:normal)))
    (cond
      ((> numeric 1.35) "huge")
      ((> numeric 0.67) "large")
      ((> numeric -0.67) "medium-sized")
      ((> numeric -1.35) "small")
      (#t "tiny"))))

(define-method (generate-character)
  (generate-character (make-bound-parameters)))

(define-method (generate-character (bound-parameters <bound-parameters>))
  (let* ((species (or (bound-species (species-parameters bound-parameters)) (pick-character-species)))
         (sex (or (bound-sex bound-parameters) (pick-sex species)))
         (gender (or (bound-gender (language-parameters bound-parameters)) (pick-gender species sex)))
         (age (or (bound-age bound-parameters) (pick-age-of-life species)))
         (lang (or (bound-language (language-parameters bound-parameters)) (pick-language)))
         (affinity (or (bound-affinity bound-parameters) (pick-affinity species)))
         (birth-place (or (bound-birth-place bound-parameters) (pick-birth-place species)))
         (way-of-life (pick-way-of-life species))
        )
    (make <character>
      #:motto (or (bound-motto bound-parameters) (pick-motto))
      #:natures (or (bound-natures bound-parameters) (pick-natures (+ 2 (random 3))))
      #:gender gender
      #:sex sex
      #:birthday (pick-birthday (birthdate-parameters bound-parameters))
      #:affinity affinity
      #:age age
      #:profession (or (bound-profession bound-parameters)
                       (if (eq? way-of-life #:citizen) (pick-profession age) #f))
      #:birth-place birth-place
      #:in-birth-place? (if (eq? way-of-life #:isolated) #f (pick-boolean))
      #:living-place (or (bound-living-place bound-parameters)
                         (pick-living-place species birth-place))
      #:in-living-place? (if (eq? way-of-life #:isolated) #f (pick-boolean))
      #:language lang
      #:species species
      #:family (generate-family bound-parameters species sex gender lang age)
      #:size (or (bound-size bound-parameters) (pick-size))
      #:weight (or (bound-weight bound-parameters) (pick-weight))
      #:traits (or (bound-traits bound-parameters) (pick-traits (+ 3 (random 3)) gender species))
      #:colors (pick-palette affinity species)
    )))
