(species satyr
  (name "Satyr")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      flowercat satyrbun satyrqorn satyrfox flower-candies)
    (special-cases
      ((father satyrbun) (mother satyrqorn)) ((father satyrqorn) (mother satyrbun))
      ((father satyrbun) (mother satyrfox)) ((father satyrfox) (mother satyrbun))
      ((father satyrbun) (mother flower-candies)) ((father flower-candies) (mother satyrbun))
      ((father satyrqorn) (mother satyrfox)) ((father satyrfox) (mother satyrqorn))
      ((father satyrqorn) (mother flower-candies)) ((father flower-candies) (mother satyrqorn))
      ((father satyrfox) (mother flower-candies)) ((father flower-candies) (mother satyrfox))
    )))

(species satyrbun
  (name "Satyrbun")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      satyr singing-rabbat)
    (special-cases
      ((father satyr) (mother singing-rabbat)) ((father singing-rabbat) (mother satyr))
    )))

(species satyrqorn
  (name "Satyrqorn")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      satyr uniqorn)
    (special-cases
      ((father satyr) (mother uniqorn)) ((father uniqorn) (mother satyr))
    )))

(species satyrfox
  (name "Satyrfox")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      satyr aurorian-fox commons-fox borealan-fox)
    (special-cases
      ((father satyr) (mother aurorian-fox)) ((father aurorian-fox) (mother satyr))
      ((father satyr) (mother commons-fox)) ((father commons-fox) (mother satyr))
      ((father satyr) (mother borealan-fox)) ((father borealan-fox) (mother satyr))
    )))

(species flower-candies
  (name "Flower Candies")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      satyr rock-candies)
    (special-cases
      ((father satyr) (mother rock-candies)) ((father rock-candies) (mother satyr))
    )))

(species goatixy
  (name "Goatixy")
  (reference-link "http://floraverse.com/comic/flora/page/193-satyr-species/")
  (citizen? #t)
  (common-regions croon-fens gnawth)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (cloud 40) (clay 40))
    (gender (masculine 10) (feminine 85) (neutral-person 4) (neutral-thing 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      satyr satyrbun satyrqorn satyrfox flower-candies)
    (special-cases )))
