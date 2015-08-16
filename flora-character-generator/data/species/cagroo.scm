(species cagroo
  (name "Cagroo")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (tamable? #t)
  (wild? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with shagroo cagrugong swagroo cotton-cagroodle bogroo cagroodle)
    (special-cases ;; Recombination from subspecies
      ((father shagroo) (mother cagrugong)) ((father cagrugong) (mother shagroo))
      ((father shagroo) (mother swagroo)) ((father swagroo) (mother shagroo))
      ((father shagroo) (mother cotton-cagroodle)) ((father cotton-cagroodle) (mother shagroo))
      ((father shagroo) (mother bogroo)) ((father bogroo) (mother shagroo))
      ((father shagroo) (mother cagroodle)) ((father cagroodle) (mother shagroo))
      ((father cagrugong) (mother swagroo)) ((father swagroo) (mother cagrugong))
      ((father cagrugong) (mother cotton-cagroodle)) ((father cotton-cagroodle) (mother cagrugong))
      ((father cagrugong) (mother bogroo)) ((father bogroo) (mother cagrugong))
      ((father cagrugong) (mother cagroodle)) ((father cagroodle) (mother cagrugong))
      ((father swagroo) (mother cotton-cagroodle)) ((father cotton-cagroodle) (mother swagroo))
      ((father swagroo) (mother bogroo)) ((father bogroo) (mother swagroo))
      ((father swagroo) (mother cagroodle)) ((father cagroodle) (mother swagroo))
      ((father cotton-cagroodle) (mother bogroo)) ((father bogroo) (mother cotton-cagroodle))
      ((father cotton-cagroodle) (mother cagroodle)) ((father cagroodle) (mother cotton-cagroodle))
      ((father bogroo) (mother cagroodle)) ((father cagroodle) (mother bogroo))
    )))

(species shagroo
  (name "Shagroo")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (tamable? #t)
  (wild? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40) (earth 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species shagroo
  (name "Shagroo")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (tamable? #t)
  (wild? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40) (earth 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species cagrugong
  (name "Cagrugong")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species swagroo
  (name "Swagroo")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40) (earth 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species cotton-cagroodle
  (name "Cotton Cagroodle")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40) (earth 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species bogroo
  (name "Bogroo")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (wild? #t)
  (only-in-common-regions? #t)
  (common-regions croon-fens)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))

(species cagroodle
  (name "Cagroodle")
  (reference-link "http://floraverse.com/comic/flora/page/204-cagroo-species/")
  (pet? #t)
  (common-regions owel)
  (distributions
    (affinity (* 1) (water 40) (earth 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with cagroo)))
