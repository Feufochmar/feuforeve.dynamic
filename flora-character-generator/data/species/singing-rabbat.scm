(species singing-rabbat
  (name "Singing Rabbat")
  (reference-link "http://floraverse.com/comic/flora/page/312-species-singing-rabbat/")
  (citizen? #t)
  (common-regions
    owel eastar)
  (distributions
    (affinity (* 1) (air 80) (light 50) (cloud 50) (storm 50) (sound 50)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      chirping-rabbat rugarabbat vampire-rabbat satyrbun)
    (special-cases
      ((father chirping-rabbat) (mother rugarabbat)) ((father rugarabbat) (mother chirping-rabbat))
      ((father chirping-rabbat) (mother vampire-rabbat)) ((father vampire-rabbat) (mother chirping-rabbat))
      ((father chirping-rabbat) (mother satyrbun)) ((father satyrbun) (mother chirping-rabbat))
      ((father rugarabbat) (mother vampire-rabbat)) ((father vampire-rabbat) (mother rugarabbat))
      ((father rugarabbat) (mother satyrbun)) ((father satyrbun) (mother rugarabbat))
      ((father vampire-rabbat) (mother satyrbun)) ((father satyrbun) (mother vampire-rabbat))
    )))

(species chirping-rabbat
  (name "Chirping Rabbat")
  (reference-link "http://floraverse.com/comic/flora/page/312-species-singing-rabbat/")
  (citizen? #t)
  (common-regions
    owel eastar)
  (distributions
    (affinity (* 1) (air 30) (light 15) (cloud 15) (storm 15) (sound 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      singing-rabbat manticore)
    (special-cases
      ((father singing-rabbat) (mother manticore)) ((father manticore) (mother singing-rabbat))
    )))

(species rugarabbat
  (name "Rugarabbat")
  (reference-link "http://floraverse.com/comic/flora/page/312-species-singing-rabbat/")
  (citizen? #t)
  (common-regions
    owel eastar)
  (distributions
    (affinity (* 1) (air 30) (light 15) (cloud 15) (storm 15) (sound 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      singing-rabbat rugaru)
    (special-cases
      ((father singing-rabbat) (mother rugaru)) ((father rugaru) (mother singing-rabbat))
    )))

(species vampire-rabbat
  (name "Vampire Rabbat")
  (reference-link "http://floraverse.com/comic/flora/page/312-species-singing-rabbat/")
  (citizen? #t)
  (common-regions
    owel eastar)
  (distributions
    (affinity (* 1) (spirit 30) (air 30)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      singing-rabbat necropossum)
    (special-cases
      ((father singing-rabbat) (mother necropossum)) ((father necropossum) (mother singing-rabbat))
    )))

;; For Satyrbun, see Satyrs
