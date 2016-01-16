;; Floraverse character generator
;; Abilities
(define-module (flora-character-generator abilities)
  #:version (0 0 1)
  #:use-module (oop goops)
  #:use-module (ffch random)
  #:use-module (ffch load-all)
  #:use-module (flora-character-generator elements)
  #:use-module (flora-character-generator species)
  #:export (<ability> name category description
            ;
            pick-abilities
           )
  #:duplicates (merge-generics))

;; Class definition
(define-class <ability> (<object>)
  (name #:getter name #:init-keyword #:name #:init-form "")
  (category #:getter category #:init-keyword #:category #:init-form "")
  (description #:getter description #:init-keyword #:description #:init-form "")
  (restrictions #:getter restrictions #:init-form (make-hash-table)))

;; Data singleton
(define *data:abilities* (list))

(define-method (pick-abilities (n <integer>) (species <species>) (affinity <element>))
  (pick-from
    (shuffle
      (filter
        (lambda (x)
          (let ((species-restrictions (hash-ref (restrictions x) #:species))
                (affinity-restrictions (hash-ref (restrictions x) #:affinity)))
            (or (and species-restrictions affinity-restrictions (member (key species) species-restrictions) (member (key affinity) affinity-restrictions))
                (and (not affinity-restrictions) species-restrictions (member (key species) species-restrictions))
                (and (not species-restrictions) affinity-restrictions (member (key affinity) affinity-restrictions)))))
        *data:abilities*))
    n))

;; Data syntax
(define-syntax ability
  (syntax-rules (restrictions is-species has-affinity)
    ((_ ab (is-species sp ...))
     (hash-set! (restrictions ab) #:species (list (quote sp) ...)))
    ((_ ab (has-affinity af ...))
     (hash-set! (restrictions ab) #:affinity (list (quote af) ...)))
    ((_ ab (restrictions itm ...))
     (begin
       (ability ab itm) ...))
    ((_ ab (slot val))
     (slot-set! ab (quote slot) val))
    ((_ itm ...)
     (let ((ab (make <ability>)))
       (begin
         (ability ab itm) ...)
       (set! *data:abilities* (cons ab *data:abilities*))
       ab))))

;; Load abilities to fill *data:abilities*
(load-all-from-path "flora-character-generator/data/abilities")




#!
(ability
  (name "Fae Speaker")
  (category "Language")
  (description "A person with the Fae Speaker can understand the Fae langage and speak it innately. They don't need to learn it.")
  (restrictions
    (is-species
       pygmy-pyzky
       necropossum deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger
       oregagnome cilantroll sorrelf fennelf)))

(ability
  ;; original idea by Shikka
  (name "Dream Item")
  (category "Summoning")
  (description "A person with the Dream Item ability can summon ethereal items and body parts made of light or spirit energy. The user must really appreciate to get such objects to be able to create them. The user can maintain and use the ethereal objects as long as they keep good thoughts.")
  (restrictions
    (has-affinity spirit light)))
!#
