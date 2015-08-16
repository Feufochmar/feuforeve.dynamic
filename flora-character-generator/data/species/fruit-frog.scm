(species fruit-frog
  (name "Fruit Frog")
  (reference-link "http://floraverse.com/comic/flora/page/221-species-fruit-frog/")
  (citizen? #t)
  (tribal? #t)
  (common-regions
    citrico-archipelago new-gnoll-nation)
  (distributions
    (affinity (* 1) (water 30) (earth 30) (acid 30))
    (sex (female 1))
    (ages (young-adult 10) (adult 15) (mature-adult 10)))
  (reproduction
    (common-pattern? #f)
    (special-cases ((father #f) (mother capricornucopia)))))

(species flower-frog
  (name "Flower Frog")
  (reference-link "http://floraverse.com/comic/flora/page/221-species-fruit-frog/")
  (citizen? #t)
  (tribal? #t)
  (common-regions
    citrico-archipelago new-gnoll-nation)
  (distributions
    (affinity (* 1) (water 30) (earth 30) (acid 30)))
  (reproduction
    (common-pattern? #f)
    (special-cases ((father #f) (mother capricornucopia)))))

(species capricornucopia
  (name "Capricornucopia")
  (reference-link "http://floraverse.com/comic/flora/page/221-species-fruit-frog/")
  (common-regions
    citrico-archipelago new-gnoll-nation)
  (distributions
    (affinity (* 1) (water 30) (earth 30) (acid 30))
    (sex (female 1)))
  (reproduction
    (common-pattern? #f)
    (special-cases ((father #f) (mother fruit-frog)))))
