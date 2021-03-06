(species masked-owl
  (name "Masked Owl")
  (reference-link "http://floraverse.com/comic/flora/page/306-species-masked-owls/")
  (citizen? #t)
  (isolated? #t)
  (foster-parent-probability 80)
  (common-regions owel)
  (distributions
    (affinity (* 1) (spirit 100) (aura 100) (poison 100) (sound 100) (magnet 100) (psi 100))
    (sex (none 1)))
  (reproduction
    (common-pattern? #f)
    (special-cases
      ((father masked-owl) (mother #f)) ((father #f) (mother masked-owl))
      ((father masked-owl-hybrid) (mother #f)) ((father #f) (mother masked-owl-hybrid))
    )))

(species masked-owl-hybrid
  (name "Masked Owl Hybrid")
  (reference-link "http://floraverse.com/comic/flora/page/306-species-masked-owls/")
  (citizen? #t)
  (isolated? #t)
  (foster-parent-probability 100)
  (foster-excluded (list 'masked-owl))
  (mimic-chooser (character-data)
    (let* ((foster (foster-parent character-data))
            (base-species-foster (if foster (base-species foster) #f))
            (species-foster (if foster (species-of foster) #f))
            (species (if base-species-foster base-species-foster species-foster))
          )
      (if species
          species
          (select-species
            (lambda (sp)
              (and (not (mimic? sp))
                   (or (citizen? sp) (tribal? sp) (isolated? sp))
                   (not (eq? 'masked-owl (key sp)))))))))
  (common-regions owel)
  (distributions
    (affinity (* 1) (spirit 100) (aura 100) (poison 100) (sound 100) (magnet 100) (psi 100))
    (sex (none 1)))
  (reproduction
    (common-pattern? #f)
    (special-cases
      ((father masked-owl) (mother #f)) ((father #f) (mother masked-owl))
      ((father masked-owl-hybrid) (mother #f)) ((father #f) (mother masked-owl-hybrid))
    )))
