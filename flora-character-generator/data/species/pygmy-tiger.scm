;; Pygmy Tigers
(species pygmy-tiger
  (name "Pygmy Tiger")
  ;; Note: although firstly described in the turf tiger species sheet, they ave their own sheet
  (reference-link "http://floraverse.com/comic/this-means-war/407-species-pygmy-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      turf-tiger
      ;
      flower-tiger pygmy-bastian swirl-fox
      )
    (special-cases
      ((father flower-tiger) (mother pygmy-bastian)) ((father pygmy-bastian) (mother flower-tiger))
      ((father flower-tiger) (mother swirl-fox)) ((father swirl-fox) (mother flower-tiger))
      ((father pygmy-bastian) (mother swirl-fox)) ((father swirl-fox) (mother pygmy-bastian))
    )))

(species flower-tiger
  (name "Flower Tiger")
  ;; Note: described only in the turf tiger species sheet
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-tiger flowercat)
    (special-cases
      ((father flowercat) (mother pygmy-tiger)) ((father pygmy-tiger) (mother flowercat))
    )))

(species pygmy-bastian
  (name "Pygmy Bastian")
  (reference-link "http://floraverse.com/comic/this-means-war/407-species-pygmy-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-tiger bastian)
    (special-cases
      ((father bastian) (mother pygmy-tiger)) ((father pygmy-tiger) (mother bastian))
    )))

(species swirl-fox
  (name "Swirl Fox")
  (reference-link "http://floraverse.com/comic/this-means-war/407-species-pygmy-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-tiger aurorian-fox)
    (special-cases
      ((father aurorian-fox) (mother pygmy-tiger)) ((father pygmy-tiger) (mother aurorian-fox))
    )))

(species atrocitiger
  (name "Atrocitiger")
  (reference-link "http://floraverse.com/comic/this-means-war/407-species-pygmy-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-tiger rakshasa)
    (special-cases
      ((father rakshasa) (mother pygmy-tiger)) ((father pygmy-tiger) (mother rakshasa))
    )))
