(species scrapgoat
  (name "Scrapgoat")
  (reference-link "http://floraverse.com/comic/references/329-species-scrapgoats/")
  (citizen? #t)
  (tribal? #t)
  (common-regions gloam teslic-yard)
  (distributions
    (affinity (* 100) (spirit 1) (psi 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      rock-candies sea-dragon diogoat)))

(species scrapgoat
  (name "Scrapgoat")
  (reference-link "http://floraverse.com/comic/references/329-species-scrapgoats/")
  (citizen? #t)
  (tribal? #t)
  (common-regions gloam teslic-yard)
  (distributions
    (affinity (* 50) (spirit 1) (psi 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      scrapgoat satyr)
    (special-cases
      ((father scrapgoat) (mother satyr)) ((father satyr) (mother scrapgoat))
    )))
