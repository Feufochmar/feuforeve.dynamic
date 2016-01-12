;; Turf Tigers
(species turf-tiger
  (name "Turf Tiger")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-tiger
      ;
      thistle-tiger tomb-tiger surf-tiger glam-candies stripe-goat truce-tiger
      )
    (special-cases
      ((father thistle-tiger) (mother tomb-tiger)) ((father tomb-tiger) (mother thistle-tiger))
      ((father thistle-tiger) (mother surf-tiger)) ((father surf-tiger) (mother thistle-tiger))
      ((father thistle-tiger) (mother glam-candies)) ((father glam-candies) (mother thistle-tiger))
      ((father thistle-tiger) (mother stripe-goat)) ((father stripe-goat) (mother thistle-tiger))
      ((father thistle-tiger) (mother truce-tiger)) ((father truce-tiger) (mother thistle-tiger))
      ((father tomb-tiger) (mother surf-tiger)) ((father surf-tiger) (mother tomb-tiger))
      ((father tomb-tiger) (mother glam-candies)) ((father glam-candies) (mother tomb-tiger))
      ((father tomb-tiger) (mother stripe-goat)) ((father stripe-goat) (mother tomb-tiger))
      ((father tomb-tiger) (mother truce-tiger)) ((father truce-tiger) (mother tomb-tiger))
      ((father surf-tiger) (mother glam-candies)) ((father glam-candies) (mother surf-tiger))
      ((father surf-tiger) (mother stripe-goat)) ((father stripe-goat) (mother surf-tiger))
      ((father surf-tiger) (mother truce-tiger)) ((father truce-tiger) (mother surf-tiger))
      ((father glam-candies) (mother stripe-goat)) ((father stripe-goat) (mother glam-candies))
      ((father glam-candies) (mother truce-tiger)) ((father truce-tiger) (mother glam-candies))
      ((father stripe-goat) (mother truce-tiger)) ((father truce-tiger) (mother stripe-goat))
    )))

(species thistle-tiger
  (name "Thistle Tiger")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      flowercat turf-tiger)
    (special-cases
      ((father flowercat) (mother turf-tiger)) ((father turf-tiger) (mother flowercat))
    )))

(species tomb-tiger
  (name "Tomb Tiger")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum turf-tiger)
    (special-cases
      ((father necropossum) (mother turf-tiger)) ((father turf-tiger) (mother necropossum))
    )))

(species surf-tiger
  (name "Surf Tiger")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      vanguard turf-tiger)
    (special-cases
      ((father vanguard) (mother turf-tiger)) ((father turf-tiger) (mother vanguard))
    )))

(species glam-candies
  (name "Glam Candies")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      rock-candies turf-tiger)
    (special-cases
      ((father rock-candies) (mother turf-tiger)) ((father turf-tiger) (mother rock-candies))
    )))

(species stripe-goat
  (name "Stripe Goat")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      scrapgoat turf-tiger)
    (special-cases
      ((father scrapgoat) (mother turf-tiger)) ((father turf-tiger) (mother scrapgoat))
    )))

(species truce-tiger
  (name "Truce Tiger")
  (reference-link "http://floraverse.com/comic/this-means-war/406-species-turf-tigers/")
  (citizen? #t)
  (distributions
    (affinity (* 1)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      clover-lamb turf-tiger)
    (special-cases
      ((father clover-lamb) (mother turf-tiger)) ((father turf-tiger) (mother clover-lamb))
    )))
