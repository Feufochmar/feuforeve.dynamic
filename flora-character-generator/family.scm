;; Floraverse character generator
;; Family generation
;; Note: no specific data associated to these definitions
(define-module (flora-character-generator family)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator sexes)
  #:use-module ((flora-character-generator languages) #:renamer (symbol-prefix-proc 'lang:))
  #:use-module ((flora-character-generator species) #:renamer (symbol-prefix-proc 'sp:))
  #:use-module (flora-character-generator ages-of-life)
  #:use-module (flora-character-generator bound-parameters)
  #:export (<individual> name species base-species
            <full-family> gff gmf gfm gmm father mother foster self partners-and-children pets
            generate-family given-name short-name full-name fam-names
            <partner-and-children> partner mother? children
           )
  #:duplicates (merge-generics))


;; Classes
(define-class <individual> (<object>)
  (name #:getter name #:init-keyword #:name)
  (species #:getter species #:init-keyword #:species)
  (base-species #:getter base-species #:init-keyword #:base-species))
;;
(define-class <partner-and-children> (<object>)
  (partner #:getter partner #:init-keyword #:partner)
  (mother? #:getter mother? #:init-keyword #:mother?) ;; #t if the main-individual is the mother of the children
  (children #:getter children #:init-keyword #:children))
;
(define-class <full-family> (<object>)
  (gff #:getter gff #:init-keyword #:gff #:init-form #f)
  (gmf #:getter gmf #:init-keyword #:gmf #:init-form #f)
  (gfm #:getter gfm #:init-keyword #:gfm #:init-form #f)
  (gmm #:getter gmm #:init-keyword #:gmm #:init-form #f)
  (father #:getter father #:init-keyword #:father #:init-form #f)
  (mother #:getter mother #:init-keyword #:mother #:init-form #f)
  (foster #:getter foster #:init-keyword #:foster #:init-form #f)
  (self #:getter self #:init-keyword #:self)
  (fam-names #:getter fam-names #:init-keyword #:fam-names)
  (fam-species #:getter fam-species #:init-keyword #:fam-species)
  (partners-and-children #:getter partners-and-children #:init-keyword #:partners-and-children #:init-form (list))
  (pets #:getter pets #:init-keyword #:pets #:init-form (list)))

(define-method (given-name (full-family <full-family>))
  (lang:given-name (fam-names full-family)))

(define-method (short-name (full-family <full-family>))
  (lang:short-name (fam-names full-family)))

(define-method (full-name (full-family <full-family>))
  (lang:full-name (fam-names full-family)))

;;
(define-method (generate-family (bound-parameters <bound-parameters>)
                                (species sp:<species>) (sex <sex>) (gender <gender>)
                                (lang lang:<language>) (age <age-of-life>))
  (let* ((famsp (sp:family-species (species-parameters bound-parameters) species))
         (famsp-father (sp:father famsp))
         (famsp-mother (sp:mother famsp))
         (famsp-gff (and famsp-father (sp:father famsp-father)))
         (famsp-gmf (and famsp-father (sp:mother famsp-father)))
         (famsp-gfm (and famsp-mother (sp:father famsp-mother)))
         (famsp-gmm (and famsp-mother (sp:mother famsp-mother)))
         ;
         (gender-father-key
           (and famsp-father
                (key (or (lang:bound-gender (lang:father (language-parameters bound-parameters)))
                         (sp:pick-gender-father (sp:species-of famsp-father))))))
         (gender-mother-key
           (and famsp-mother
                (key (or (lang:bound-gender (lang:mother (language-parameters bound-parameters)))
                         (sp:pick-gender-mother (sp:species-of famsp-mother))))))
         (gender-gff-key
           (and famsp-gff
                (key (or (lang:bound-gender (lang:father (lang:father (language-parameters bound-parameters))))
                         (sp:pick-gender-father (sp:species-of famsp-gff))))))
         (gender-gmf-key
           (and famsp-gmf
                (key (or (lang:bound-gender (lang:mother (lang:father (language-parameters bound-parameters))))
                         (sp:pick-gender-mother (sp:species-of famsp-gmf))))))
         (gender-gfm-key
           (and famsp-gfm
                (key (or (lang:bound-gender (lang:father (lang:mother (language-parameters bound-parameters))))
                         (sp:pick-gender-father (sp:species-of famsp-gfm))))))
         (gender-gmm-key
           (and famsp-gmm
                (key (or (lang:bound-gender (lang:mother (lang:mother (language-parameters bound-parameters))))
                         (sp:pick-gender-mother (sp:species-of famsp-gmm))))))
         (gender-key (key gender))
         ;
         (famnm (lang:family-names
                  #:constraints (language-parameters bound-parameters)
                  #:language lang
                  #:character-gender gender-key
                  #:mother-gender gender-mother-key
                  #:father-gender gender-father-key
                  #:gmm-gender gender-gmm-key
                  #:gfm-gender gender-gfm-key
                  #:gmf-gender gender-gmf-key
                  #:gff-gender gender-gff-key))
         ;
         (make-individual
           (lambda (indiv namefunc)
             (if indiv
                (make <individual>
                     #:name (namefunc famnm)
                     #:species (sp:species-of indiv)
                     #:base-species (sp:base-species indiv))
                #f)))
         (make-pet
           (lambda ()
             (let ((sp-indiv (sp:individual-species (sp:pick-pet-species))))
               (make <individual>
                     #:name (lang:generate-word (if (pick-boolean) lang (lang:pick-language)))
                     #:species (sp:species-of sp-indiv)
                     #:base-species (sp:base-species sp-indiv)))))
         (partners-and-children
           (map
             (lambda (x)
               (let ((partner-lang (if (pick-boolean) lang (lang:pick-language))))
                 (make <partner-and-children>
                       #:partner
                         (make <individual>
                               #:name (lang:generate-word partner-lang)
                               #:species (sp:species-of (car x))
                               #:base-species (sp:base-species (car x)))
                       #:mother? (cadr x)
                       #:children
                         (map
                            (lambda (y)
                              (make <individual>
                                    #:name (lang:generate-word (if (pick-boolean) lang partner-lang))
                                    #:species (sp:species-of y)
                                    #:base-species (sp:base-species y)))
                            (caddr x)))))
             (sp:partners+children famsp age sex gender)))
        )
    (make <full-family>
      #:fam-names famnm
      #:fam-species famsp
      #:gff (make-individual famsp-gff lang:gff-given-name)
      #:gmf (make-individual famsp-gmf lang:gmf-given-name)
      #:gfm (make-individual famsp-gfm lang:gfm-given-name)
      #:gmm (make-individual famsp-gmm lang:gmm-given-name)
      #:father (make-individual famsp-father lang:father-name)
      #:mother (make-individual famsp-mother lang:mother-name)
      #:foster
        (let ((foster-p (sp:foster-parent famsp)))
             (if foster-p
                 (make <individual>
                       #:name (lang:generate-word (if (pick-boolean) lang (lang:pick-language)))
                       #:species (sp:species-of foster-p)
                       #:base-species (sp:base-species foster-p))
                 #f))
      #:self
        (make <individual>
              #:name #f #:species species
              #:base-species (sp:base-species famsp))
      #:partners-and-children partners-and-children
      #:pets
        (if (can-have-pet? age)
            (map (lambda (x) (make-pet)) (make-list (pick-from 0 5) #f))
            (list))
    )))
