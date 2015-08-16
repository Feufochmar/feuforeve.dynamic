;; Floraverse character generator
;; Species
(define-module (flora-character-generator species)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch distribution)
  #:use-module (ffch load-all)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator sexes)
  #:use-module (flora-character-generator ages-of-life)
  #:use-module (flora-character-generator genders)
  #:use-module (flora-character-generator locations)
  #:export (<species>
            ;
            key name reference-link
            ;
            get-species pick-character-species pick-pet-species pick-species
            ;
            pick-sex pick-gender pick-age-of-life pick-affinity
            pick-gender-father pick-gender-mother
           )
  #:duplicates (merge-generics))

;; Species class
(define-class <species> (<object>)
  (key #:getter key #:init-keyword #:key)
  (name #:getter name #:init-form "")
  (reference-link #:getter reference-link #:init-form "")
  (citizen? #:getter citizen? #:init-form #f)
  (tribal? #:getter tribal? #:init-form #f)
  (isolated? #:getter isolated? #:init-form #f)
  (pet? #:getter pet? #:init-form #f)
  (tamable? #:getter tamable? #:init-form #f)
  (wild? #:getter wild? #:init-form #f)
  (only-in-common-regions? #:getter only-in-common-regions? #:init-form #f)
  (foster-parent-probability #:getter foster-parent-probability #:init-form 1) ;; Between 0 and 100
  (foster-excluded #:getter foster-excluded #:init-form (list))
  (mimic? #:getter mimic? #:init-form #f)
  (mimic-base-species-chooser #:getter mimic-base-species-chooser #:init-form #f)
  ;
  (common-regions #:getter common-regions #:init-form (vector))
  ;
  (affinity-distribution
    #:getter affinity-distribution
    #:init-form (make-distribution (list (cons 'none 1))))
  (sex-distribution
    #:getter sex-distribution
    #:init-form (make-distribution (list (cons 'male 1) (cons 'female 1))))
  (ages-distribution
    #:getter ages-distribution
    #:init-form (make-distribution (list (cons 'infant 1) (cons 'child 1) (cons 'adolescent 4)
                                         (cons 'young-adult 8) (cons 'adult 12) (cons 'mature-adult 8)
                                         (cons 'elder 4))))
  (gender-distribution
    #:getter gender-distribution
    #:init-form #f) ;; Use the distribution indicated in sexes by default
  ;
  (possible-parents #:getter possible-parents #:init-form (list))
  (possible-spouses #:getter possible-spouses #:init-form (list))
  (possible-husbands #:getter possible-husbands #:init-form (list)))

(define-method (pick-sex (sp <species>))
  (get-sex (pick-from (sex-distribution sp))))

(define-method (pick-gender (sp <species>) (sx <sex>))
  (if (gender-distribution sp)
      (get-gender (pick-from (gender-distribution sp)))
      ((@ (flora-character-generator sexes) pick-gender) sx)))

(define-method (pick-age-of-life (sp <species>))
  (get-age-of-life (pick-from (ages-distribution sp))))

(define-method (pick-affinity (sp <species>))
  (get-element (pick-from (affinity-distribution sp))))

(define-method (pick-gender-father (sp <species>))
  (if (contains? 'male (sex-distribution sp))
      (pick-gender sp (get-sex 'male))
      (pick-gender sp (pick-sex sp))))

(define-method (pick-gender-mother (sp <species>))
  (if (contains? 'female (sex-distribution sp))
      (pick-gender sp (get-sex 'female))
      (pick-gender sp (pick-sex sp))))

;;;;
;; Helper class for filling the distributions slots of species
(define-class <distribution-infos> (<object>)
  (access #:getter access #:init-keyword #:access)
  (slot #:getter slot #:init-keyword #:slot)
  (item-keys #:getter item-keys #:init-keyword #:item-keys))

(define *info:distributions* (make-hash-table))

(define-method (distribution-infos (type <symbol>))
  (hash-ref *info:distributions* type))

(hash-set! *info:distributions* (quote affinity)
  (make <distribution-infos>
        #:access affinity-distribution
        #:slot (quote affinity-distribution)
        #:item-keys element-keys))
(hash-set! *info:distributions* (quote sex)
  (make <distribution-infos>
        #:access sex-distribution
        #:slot (quote sex-distribution)
        #:item-keys sex-keys))
(hash-set! *info:distributions* (quote ages)
  (make <distribution-infos>
        #:access ages-distribution
        #:slot (quote ages-distribution)
        #:item-keys ages-of-life-keys))
(hash-set! *info:distributions* (quote gender)
  (make <distribution-infos>
        #:access gender-distribution
        #:slot (quote gender-distribution)
        #:item-keys gender-keys))
;;

;; Data containers
(define *data:species* (make-hash-table))
; Temporary list as the species combinations data can only be filled in the data lock pass.
(define *data:species-combinations* (list)) ; Contains vectors [child-key father-key mother-key]
; This table cannot be placed in the <species> class
(define *data:reproduction:parents->child* (make-hash-table)) ; (father . mother) -> list of species-key

;;
(define-method (get-species (key <symbol>))
  (hash-ref *data:species* key))
(define-method (get-species (key <boolean>))
  #f)

(define-method (select-species predicate)
  (pick-from (filter predicate (hash-map->list (lambda (k v) v) *data:species*))))

(define-method (pick-character-species)
  (select-species (lambda (x) (or (citizen? x) (tribal? x) (isolated? x)))))

(define-method (pick-pet-species)
  (select-species (lambda (x) (or (pet? x) (tamable? x)))))

(define-method (pick-species)
  (select-species (lambda (x) #t)))

(define-method (keep-species-combination (child <symbol>) father mother)
  (cons (vector child father mother) *data:species-combinations*))

(define-method (process-species-combination (child <symbol>) father mother)
  (let ((child-species (get-species child))
        (father-species (get-species father))
        (mother-species (get-species mother)))
    (if child-species
        (slot-set! child-species
                   (quote possible-parents) (cons (cons father mother) (possible-parents child-species))))
    (if (and father-species mother-species)
        (begin
          (slot-set! father-species
                     (quote possible-spouses) (cons mother (possible-spouses father-species)))
          (slot-set! mother-species
                     (quote possible-husbands) (cons father (possible-husbands mother-species)))))
    (if (or father-species mother-species)
        (let ((old (hash-ref *data:reproduction:parents->child* (cons father mother))))
          (if old
              (hash-set! *data:reproduction:parents->child* (cons father mother) (cons child old))
              (hash-set! *data:reproduction:parents->child* (cons father mother) (list child)))))))

;
(define-syntax fill-species-distributions
  (syntax-rules ()
    ((_ sp)
     (begin ))
    ((_ sp (type items* ...) ...)
     (begin
       (let* ((infos (distribution-infos (quote type)))
              (access (access infos))
              (slot (slot infos))
              (item-keys (item-keys infos)))
          (slot-set! sp slot (make-distribution)) ; Reset the default value
          (fill-distribution (access sp) (item-keys) items* ...)
          ; Check against typos
          (check-only (access sp) (item-keys))) ...))))

;; Syntax definitions
(define-syntax species
  (syntax-rules (common-regions distributions reproduction common-pattern? crossbreed-with special-cases)
    ((_ key
        (slot value) ...
        (common-regions place* ...)
        (distributions distro* ...)
        (reproduction
          (common-pattern? reproduction-common?)
          (crossbreed-with compatible-species* ...)
          (special-cases ((father father-species) (mother mother-species)) ...)))
     (let ((sp (make <species> #:key (quote key))))
       (begin
         (slot-set! sp (quote slot) value) ...)
       ; Common-regions
       (slot-set! sp (quote common-regions) (vector (quote place*) ...))
       ; Distributions
       (fill-species-distributions sp distro* ...)
       ; Reproduction
       (begin
         (if reproduction-common?
             (keep-species-combination (quote key) (quote key) (quote key)))
         (map
           (lambda (x)
             (keep-species-combination (quote key) (quote key) x)
             (keep-species-combination (quote key) x (quote key)))
           (list (quote compatible-species*) ...))
         (keep-species-combination (quote key) (quote father-species) (quote mother-species)) ...)
       (hash-set! *data:species* (quote key) sp)
       sp))))

;; Load languages to fill *data:species*
(load-all-from-path "flora-character-generator/data/species")

;; Process species combinations. Can only be done there as it needs all species to be known
(map
  (lambda (vec)
    (process-species-combination
      (vector-ref vec 0)
      (vector-ref vec 1)
      (vector-ref vec 2)))
  *data:species-combinations*)

;; Check && lock data
(hash-map->list
  (lambda (k v)
    ; Check common regions
    (map
      (lambda (reg)
        (if (not (get-region reg))
            (error "Unkown region for species: " reg k)))
      (vector->list (common-regions v)))
    ; Lock parents
    (slot-set! v (quote possible-parents) (list->vector (possible-parents v)))
    ; Lock spouses
    (slot-set! v (quote possible-spouses) (list->vector (possible-spouses v)))
    ; Lock husbands
    (slot-set! v (quote possible-husbands) (list->vector (possible-husbands v)))
  )
  *data:species*)

(hash-map->list
  (lambda (parents children)
    ; lock
    (hash-set! *data:reproduction:parents->child* parents (list->vector children)))
  *data:reproduction:parents->child*)


#!
;;;;
;; Species data types defintions

(define-class <species> (<object>)
  (key #:getter get-key #:init-keyword #:key) ;; key of the species
  (name #:getter get-name #:init-keyword #:name) ;; string
  (reference-link #:getter get-reference-link #:init-keyword #:reference-link) ;; string
  (sex-distribution #:getter get-sex-distribution #:init-keyword #:sex-distribution #:init-form '((male . 1) (female . 1))) ;; distribution (sex-key . ocurrences)
  (gender-distribution #:getter get-gender-distribution #:init-keyword #:gender-distribution #:init-form #f) ;; #f or a distribution (gender-key . ocurrences)
  (affinity-distribution #:getter get-affinity-distribution #:init-keyword #:affinity-distribution #:init-form '((* . 1)) ) ;; distribution (element-key . ocurrences)
  (size-mean #:getter get-size-mean #:init-keyword #:size-mean #:init-form #f) ;; #f or size mean in meters, #f if unknown
  (size-deviation #:getter get-size-deviation #:init-keyword #:size-deviation #:init-form #f) ;; #f or standard deviation of size in meters, #f if unknown
  (common-regions #:getter get-common-regions #:init-keyword #:common-regions #:init-form '()) ;; vector of region-keys
  (common-regions-only? #:getter common-regions-only? #:init-keyword #:common-regions-only? #:init-form #f) ;; boolean
  (citizen? #:getter citizen? #:init-keyword #:citizen? #:init-form #f) ;; boolean
  (pet? #:getter pet? #:init-keyword #:pet? #:init-form #f) ;; boolean
  (wild? #:getter wild? #:init-keyword #:wild? #:init-form #f) ;; boolean
  (father-sex #:getter get-father-sex #:init-keyword #:father-sex #:init-form 'male) ;; sex-key
  (mother-sex #:getter get-mother-sex #:init-keyword #:mother-sex #:init-form 'female) ;; sex-key
  (ages-distribution #:getter get-ages-distribution #:init-keyword #:ages-distribution
                     #:init-form '( (infant . 1) (child . 1) (adolescent . 4)
                                    (young-adult . 8) (adult . 12) (mature-adult . 8) (elder . 4) )) ;; distribution (age . occurences)
  (mimic? #:getter mimic? #:init-keyword #:mimic? #:init-form #f) ;; boolean
  (base-species-chooser #:getter base-species-chooser #:init-keyword #:base-species-chooser #:init-form #f) ;; #f or lambda taking an individual
  (foster-probability #:getter foster-probability #:init-keyword #:foster-probability #:init-form 1) ;; Number between 0 and 100
  (foster-species #:getter foster-species #:init-keyword #:foster-species #:init-form #f) ;; #f or a list of species-keys
  (foster-excluded #:getter foster-excluded #:init-keyword #:foster-excluded #:init-form #f) ;; #f or a list of species-keys
)

(define-class <size> (<object>)
  (value #:getter get-value #:init-keyword #:value) ;; symbol among : huge, large, medium, small, tiny
  (numeric #:getter get-numeric #:init-keyword #:numeric) ;; real
  (numeric-valid? #:getter numeric-valid? #:init-keyword #:numeric-valid?) ;; boolean
)

;;;;
;; Data container : fact base
(define-class <species-facts> (<object>)
  (months #:accessor months #:init-form '())
  (elements #:getter get-elements #:init-form (make-hash-table))
  (elements-keys #:accessor elements-keys #:init-form '())
  (species #:getter get-species #:init-form (make-hash-table))
)

(define =species-facts= (make <species-facts>))

;; Species combinations
(define-class <species-combinations> (<object>)
  (child->parents #:accessor child->parents #:init-form (make-hash-table))
  (parents->child #:accessor parents->child #:init-form (make-hash-table))
  (spouse->husband #:accessor spouse->husband #:init-form (make-hash-table))
  (husband->spouse #:accessor husband->spouse #:init-form (make-hash-table))
)

(define =species-combinations= (make <species-combinations>))

;; When locked :
;;  - the lists used to fill the facts are replaced by their vector equivalents
;;  - the list of keys of the tables are extracted into a vector
;; This allows a simpler lookup when choosing a random element from the containers
(define (lock-species-facts)
  (set! (months =species-facts=) (list->vector (months =species-facts=)))
  (set! (elements-keys =species-facts=)
        (list->vector
          (hash-map->list
            (lambda (key val) key)
            (get-elements =species-facts=)))))

;;;;
;; Data readers

;; Pick a size from a species
(define-method (pick-size (species <species>))
  (let* ((species-mean (get-size-mean species))
         (species-deviation (get-size-deviation species))
         (mean (if species-mean species-mean 0.0))
         (deviation (if species-deviation species-deviation 1.0))
         (numeric-valid (and species-mean species-deviation))
         (numeric (+ mean (* deviation (random:normal))))
         (value
           (cond
            ((> numeric (+ mean (* deviation 1.35))) 'huge)
            ((> numeric (+ mean (* deviation 0.67))) 'large)
            ((> numeric (+ mean (* deviation -0.67))) 'medium)
            ((> numeric (+ mean (* deviation -1.35))) 'small)
            (#t 'tiny))))
        (make <size> #:value value #:numeric numeric #:numeric-valid? numeric-valid)
  ))

;; Get the list of species checking a predicate
(define-method (filter-species predicate?)
  (filter
    (lambda (sp) (predicate? sp))
    (hash-map->list (lambda (k v) v) (get-species =species-facts=))))

;; Pick a species-key from a predicate on a species
(define-method (pick-species-key predicate?)
  (get-key (pick-from (filter-species predicate?))))

;; Pick a citizen species-key
(define (pick-citizen-key)
  (pick-species-key citizen?))

;; Pick a pet species-key
(define (pick-pet-key)
  (pick-species-key pet?))

;; Pick a wild species-key
(define (pick-wild-key)
  (pick-species-key wild?))

;; Pick a parents species-key couple from a child species-key
(define-method (pick-parents (species-key <symbol>))
  (let ((possible-parents-list (hash-ref (child->parents =species-combinations=) species-key)))
    (if possible-parents-list
        (if (and (member (cons species-key species-key) possible-parents-list) (eq? 0 (random 2)))
            (cons species-key species-key)
            (pick-from possible-parents-list))
        #f)))

;; Pick a child species-key from the parent species-keys. If parents are not compatible, return #f
(define-method (pick-child (father-key <symbol>) (mother-key <symbol>))
  (let ((possible-child-list (hash-ref (parents->child =species-combinations=) (cons father-key mother-key))))
    (if possible-child-list
        (pick-from possible-child-list)
        #f)))

;; Pick a husband species-key from the spouse species-key
(define-method (pick-husband (species-key <symbol>))
  (let ((possible-husband-list (hash-ref (spouse->husband =species-combinations=) species-key)))
    (cond
     ((not possible-husband-list) #f) ;; when defining a combination, #f is a possible value for father and mother
     ((and (member species-key possible-husband-list) (eq? 0 (random 2))) species-key) ;; preference for a partner of the same species
     (#t (pick-from possible-husband-list)))))

;; Pick a spouse species-key from the husband species-key
(define-method (pick-spouse (species-key <symbol>))
  (let ((possible-spouse-list (hash-ref (husband->spouse =species-combinations=) species-key)))
    (cond
     ((not possible-spouse-list) #f) ;; when defining a combination, #f is a possible value for father and mother
     ((and (member species-key possible-spouse-list) (eq? 0 (random 2))) species-key) ;; preference for a partner of the same species
     (#t (pick-from possible-spouse-list)))))

;; Pick the age
(define-method (pick-age-of-life (species <species>))
  (get-age-of-life (pick-from-distribution (get-ages-distribution species))))

!#
