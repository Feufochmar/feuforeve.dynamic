; Low intelect
(species foxbat
  (name "Foxbat")
  (reference-link "http://floraverse.com/wiki/species/foxbat")
  (pet? #t)
  (tamable? #t)
  (wild? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (spirit 0) (aura 0) (poison 0) (sound 0) (magnet 0) (psi 0)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      foxbat-spirit)))

; High intelect
(species foxbat-spirit
  (name "Foxbat")
  (reference-link "http://floraverse.com/wiki/species/foxbat")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions dewclaw peril)
  (distributions
    (affinity (* 0) (spirit 1) (aura 1) (poison 1) (sound 1) (magnet 1) (psi 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      foxbat)))
