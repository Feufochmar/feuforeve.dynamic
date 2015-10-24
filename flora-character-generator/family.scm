;; Floraverse character generator
;; Family generation
;; Note: no specific data associated to these definitions
(define-module (flora-character-generator family)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator sexes)
  #:use-module (flora-character-generator languages)
  #:use-module (flora-character-generator species)
  #:use-module (flora-character-generator ages-of-life)
  #:export (<individual> given-name species
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
  ((@ (flora-character-generator languages) given-name) (fam-names full-family)))

(define-method (short-name (full-family <full-family>))
  ((@ (flora-character-generator languages) short-name) (fam-names full-family)))

(define-method (full-name (full-family <full-family>))
  ((@ (flora-character-generator languages) full-name) (fam-names full-family)))

;;
(define-method (generate-family (species <species>) (sex <sex>) (gender <gender>)
                                (lang <language>) (age <age-of-life>))
  (let* ((famsp ((@ (flora-character-generator species) family-species) species))
         (famsp-father ((@ (flora-character-generator species) father) famsp))
         (famsp-mother ((@ (flora-character-generator species) mother) famsp))
         (famsp-gff (if famsp-father ((@ (flora-character-generator species) father) famsp-father) #f))
         (famsp-gmf (if famsp-father ((@ (flora-character-generator species) mother) famsp-father) #f))
         (famsp-gfm (if famsp-mother ((@ (flora-character-generator species) father) famsp-mother) #f))
         (famsp-gmm (if famsp-mother ((@ (flora-character-generator species) mother) famsp-mother) #f))
         ;
         (gender-father-key (if famsp-father (key (pick-gender-father (species-of famsp-father))) #f))
         (gender-mother-key (if famsp-mother (key (pick-gender-mother (species-of famsp-mother))) #f))
         (gender-gff-key (if famsp-gff (key (pick-gender-father (species-of famsp-gff))) #f))
         (gender-gmf-key (if famsp-gmf (key (pick-gender-mother (species-of famsp-gmf))) #f))
         (gender-gfm-key (if famsp-gfm (key (pick-gender-father (species-of famsp-gfm))) #f))
         (gender-gmm-key (if famsp-gmm (key (pick-gender-mother (species-of famsp-gmm))) #f))
         (gender-key (key gender))
         ;
         (famnm (family-names
                  (language lang)
                  (genders
                    (character gender-key)
                    (mother gender-mother-key)
                    (father gender-father-key)
                    (gmm gender-gmm-key)
                    (gfm gender-gfm-key)
                    (gmf gender-gmf-key)
                    (gff gender-gff-key))))
         ;
         (make-individual
           (lambda (indiv namefunc)
             (if indiv
                (make <individual>
                     #:name (namefunc famnm)
                     #:species (species-of indiv)
                     #:base-species ((@ (flora-character-generator species) base-species) indiv))
                #f)))
         (make-pet
           (lambda ()
             (let ((sp-indiv (individual-species (pick-pet-species))))
               (make <individual>
                     #:name (generate-word (if (pick-boolean) lang (pick-language)))
                     #:species (species-of sp-indiv)
                     #:base-species ((@ (flora-character-generator species) base-species) sp-indiv)))))
         (partners-and-children
           (map
             (lambda (x)
               (let ((partner-lang (if (pick-boolean) lang (pick-language))))
                 (make <partner-and-children>
                       #:partner
                         (make <individual>
                               #:name (generate-word partner-lang)
                               #:species (species-of (car x))
                               #:base-species ((@ (flora-character-generator species) base-species) (car x)))
                       #:mother? (cadr x)
                       #:children
                         (map
                            (lambda (y)
                              (make <individual>
                                    #:name (generate-word (if (pick-boolean) lang partner-lang))
                                    #:species (species-of y)
                                    #:base-species ((@ (flora-character-generator species) base-species) y)))
                            (caddr x)))))
             (partners+children famsp age sex gender)))
        )
    (make <full-family>
      #:fam-names famnm
      #:fam-species famsp
      #:gff (make-individual famsp-gff gff-given-name)
      #:gmf (make-individual famsp-gmf gmf-given-name)
      #:gfm (make-individual famsp-gfm gfm-given-name)
      #:gmm (make-individual famsp-gmm gmm-given-name)
      #:father (make-individual famsp-father father-name)
      #:mother (make-individual famsp-mother mother-name)
      #:foster
        (let ((foster-p (foster-parent famsp)))
             (if foster-p
                 (make <individual>
                       #:name (generate-word (if (pick-boolean) lang (pick-language)))
                       #:species (species-of foster-p)
                       #:base-species ((@ (flora-character-generator species) base-species) foster-p))
                 #f))
      #:self
        (make <individual>
              #:name #f #:species species
              #:base-species ((@ (flora-character-generator species) base-species) famsp))
      #:partners-and-children partners-and-children
      #:pets
        (if (can-have-pet? age)
            (map (lambda (x) (make-pet)) (make-list (pick-from 0 5) #f))
            (list))
    )))
