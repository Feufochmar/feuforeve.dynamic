(species moahu
  (name "Moahu")
  (reference-link "http://floraverse.com/comic/flora/page/318-species-moahu/")
  (citizen? #t)
  (foster-parent-probability 0)
  (mimic-chooser (character-data)
    (select-species (lambda (sp) (and (not (mimic? sp)) (or (citizen? sp) (tribal? sp) (isolated? sp))))))
  (common-regions holiday)
  (distributions
    (affinity (* 1) (earth 500) (lava 100) (clay 100) (sand 100)
              (crystal 100) (magnet 100) (water 10) (fire 10) (air 10)
              (spirit 10))
    (sex (none 1))
    (ages (young-adult 5) (adult 15) (ageless-adult 15)))
  (reproduction
    (common-pattern? #f)))
