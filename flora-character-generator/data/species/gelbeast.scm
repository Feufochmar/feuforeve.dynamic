(species gelbeast
  (name "Gelbeast")
  (reference-link "http://floraverse.com/comic/flora/page/206-gelbeast-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (mimic-chooser (character-data)
    (select-species (lambda (sp) (and (not (mimic? sp)) (or (citizen? sp) (tribal? sp) (isolated? sp))))))
  (common-regions treefall)
  (distributions
    (affinity (* 1) (water 50))
    (sex (none 1)))
  (reproduction
    (common-pattern? #t)))

(species gelbeast-wild
  (name "Gelbeast")
  (reference-link "http://floraverse.com/comic/flora/page/206-gelbeast-species/")
  (wild? #t)
  (mimic-chooser (character-data)
    (select-species (lambda (sp) (and (not (mimic? sp)) (wild? sp)))))
  (common-regions treefall)
  (distributions
    (affinity (* 1) (water 50))
    (sex (none 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with gelbeast-pet)))

(species gelbeast-pet
  (name "Gelbeast")
  (reference-link "http://floraverse.com/comic/flora/page/206-gelbeast-species/")
  (pet? #t)
  (tamable? #t)
  (mimic-chooser (character-data)
    (select-species (lambda (sp) (and (not (mimic? sp)) (or (pet? sp) (tamable? sp))))))
  (common-regions treefall)
  (distributions
    (affinity (* 1) (water 50))
    (sex (none 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with gelbeast-wild)))
