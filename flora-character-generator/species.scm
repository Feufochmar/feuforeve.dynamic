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
            get-species pick-character-species pick-pet-species pick-wild-species pick-species
            ;
            pick-sex pick-gender pick-age-of-life pick-affinity
            pick-gender-father pick-gender-mother
            pick-birth-place pick-living-place
            ;
            family-species base-species species-of mother father foster-parent individual-species
            partners+children
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

(define-method (pick-birth-place (sp <species>))
  (if (or (only-in-common-regions? sp) (and (< 0 (vector-length (common-regions sp))) (> 7 (random 10))))
      (pick-place (pick-from (common-regions sp)))
      (pick-place)))

(define-method (pick-living-place (sp <species>) (birth-place <place>))
  (cond
    ((eq? 0 (random 3)) birth-place)
    ((pick-boolean) (pick-place (area birth-place)))
    (#t (pick-birth-place sp))))

;; Family stuff
(define-class <individual> (<object>)
  (species-of #:getter species-of #:init-keyword #:species-of)
  (base-species #:getter base-species #:init-keyword #:base-species #:init-form #f)
  (mother #:getter mother #:init-keyword #:mother #:init-form #f)
  (father #:getter father #:init-keyword #:father #:init-form #f)
  (foster-parent #:getter foster-parent #:init-keyword #:foster-parent #:init-form #f))

(define-method (make-individual (sp <species>) (generate-parents? <boolean>) (generate-gparents? <boolean>))
  (let* ((possible-parents-lst (possible-parents sp))
         (parent-species-keys
            (if (and generate-parents? (< 0 (vector-length possible-parents-lst)))
               (pick-from (possible-parents sp))
               #f))
         (father-species (if (and generate-parents? parent-species-keys) (get-species (car parent-species-keys)) #f))
         (mother-species (if (and generate-parents? parent-species-keys) (get-species (cdr parent-species-keys)) #f))
         (father-individual (if father-species (make-individual father-species generate-gparents? #f) #f))
         (mother-individual (if mother-species (make-individual mother-species generate-gparents? #f) #f))
         ;
         (foster-parent-species
           (if (and generate-parents? (< (random 100) (foster-parent-probability sp)))
               (select-species
                  (lambda (x)
                    (and (not (member (key x) (foster-excluded sp)))
                         (or (citizen? x) (tribal? x) (isolated? x)))))
               #f))
         (foster-parent (if foster-parent-species (make-individual foster-parent-species #f #f) #f))
         (self
           (make <individual>
                 #:species-of sp
                 #:mother mother-individual
                 #:father father-individual
                 #:foster-parent foster-parent))
        )
    (slot-set!
      self
      (quote base-species)
      (if (mimic? sp)
          ((mimic-base-species-chooser sp) self)
          #f))
    self))
;
(define-method (family-species (sp <species>))
  (make-individual sp #t #t))

(define-method (individual-species (sp <species>))
  (make-individual sp #f #f))

(define-method (individual-species (sp <species>) (father <individual>) (mother <individual>))
  (let ((self (make <individual> #:species-of sp #:mother mother #:father father)))
    (slot-set!
      self
      (quote base-species)
      (if (mimic? sp)
          ((mimic-base-species-chooser sp) self)
          #f))
    self))

(define-method (partners+children (self <individual>) (age <age-of-life>) (sex <sex>) (gender <gender>))
  (let* ((sp (species-of self))
         (nb-children-per-partner (pick-nb-partners-children age))
        )
    (map
      (lambda (x)
        (let* ((nb-child x)
               (is-mother? (mother? sex))
               (partner-possible-list (if is-mother? possible-husbands possible-spouses))
               (partner-species
                 (cond
                  ((eq? 0 (random 16))
                   (pick-character-species))
                  ((< 0 (vector-length (partner-possible-list sp)))
                   (get-species (pick-from (partner-possible-list sp))))
                  (#t (pick-character-species))))
               (partner (individual-species partner-species))
               (possible-child-list
                 (or (hash-ref *data:reproduction:parents->child*
                               (if is-mother?
                                   (cons (key partner-species) (key sp))
                                   (cons (key sp) (key partner-species))))
                     (vector)))
              )
          (list
            partner
            is-mother?
            (filter identity
              (map
                (lambda (y)
                  (if (< 0 (vector-length possible-child-list))
                      (individual-species
                        (get-species (pick-from possible-child-list))
                        (if is-mother? partner self)
                        (if is-mother? self partner))
                      #f))
                (make-list nb-child #f))))))
      nb-children-per-partner)))

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

(define-method (pick-wild-species)
  (select-species (lambda (x) (or (wild? x) (tamable? x)))))

(define-method (pick-species)
  (select-species (lambda (x) #t)))

(define-method (keep-species-combination (child <symbol>) father mother)
  (set! *data:species-combinations* (cons (vector child father mother) *data:species-combinations*)))

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

;;
(define-syntax fill-specific-species-distribution
 (syntax-rules ()
   ((_ sp slot item-keys (k v) ...)
     (begin
       (slot-set! sp (quote slot) (make-distribution))
       (fill-distribution (slot sp) (item-keys) (k v) ...)
       (check-only (slot sp) (item-keys))))))

(define-syntax fill-species-distributions
  (syntax-rules (affinity sex ages gender)
    ((_ sp)
     (begin ))
    ((_ sp (affinity items* ...))
     (fill-specific-species-distribution sp affinity-distribution element-keys items* ...))
    ((_ sp (sex items* ...))
     (fill-specific-species-distribution sp sex-distribution sex-keys items* ...))
    ((_ sp (ages items* ...))
     (fill-specific-species-distribution sp ages-distribution ages-of-life-keys items* ...))
    ((_ sp (gender items* ...))
     (fill-specific-species-distribution sp gender-distribution gender-keys items* ...))
    ((_ sp (type items* ...) ...)
     (begin
       (fill-species-distributions sp (type items* ...)) ...))))

(define-syntax fill-species-reproduction
  (syntax-rules (common-pattern? crossbreed-with special-cases father mother)
   ((_ key)
    (begin))
   ((_ key (common-pattern? reproduction-common?))
    (if reproduction-common?
        (keep-species-combination (quote key) (quote key) (quote key))))
   ((_ key (crossbreed-with compatible-species* ...))
    (map
        (lambda (x)
          (keep-species-combination (quote key) (quote key) x)
          (keep-species-combination (quote key) x (quote key)))
        (list (quote compatible-species*) ...)))
   ((_ key (special-cases ((father father-species) (mother mother-species)) ...))
    (begin
      (keep-species-combination (quote key) (quote father-species) (quote mother-species)) ...))
   ((_ key (itms* ...) ...)
    (begin
      (fill-species-reproduction key (itms* ...)) ...))))

;; Syntax definitions
(define-syntax species
  (syntax-rules (common-regions distributions reproduction mimic-chooser)
    ((_ sp key (reproduction reprod* ...))
     (fill-species-reproduction key reprod* ...))
    ((_ sp key (distributions distro* ...))
     (fill-species-distributions sp distro* ...))
    ((_ sp key (common-regions place* ...))
     (slot-set! sp (quote common-regions) (vector (quote place*) ...)))
    ((_ sp key (mimic-chooser (chardata) funblock* ...))
     (begin
       (slot-set! sp (quote mimic?) #t)
       (slot-set! sp (quote mimic-base-species-chooser) (lambda (chardata) funblock* ...))))
    ((_ sp key (slot value))
     (slot-set! sp (quote slot) value))
    ((_ key
        (itms* ...) ...)
     (let ((sp (make <species> #:key (quote key))))
       (begin
         (species sp key (itms* ...)) ...)
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
