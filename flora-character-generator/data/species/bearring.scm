(species bearring
  (name "Bearring")
  (reference-link "http://floraverse.com/comic/pages/613-bearrings-common/")
  (citizen? #t)
  (common-regions owel)
  (distributions
    (affinity (* 47) (psi 47))) ; Spirit/PSI is at 4.7 %, but 4.7 % is also when affinities are evenly distributed
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      sea-bearring singing-bearrub twinkle-tiger grisly-bearring
      )
    (special-cases
      ((father sea-bearring) (mother singing-bearrub)) ((father singing-bearrub) (mother sea-bearring))
      ((father sea-bearring) (mother twinkle-tiger)) ((father twinkle-tiger) (mother sea-bearring))
      ((father sea-bearring) (mother grisly-bearring)) ((father grisly-bearring) (mother sea-bearring))
      ((father singing-bearrub) (mother twinkle-tiger)) ((father twinkle-tiger) (mother singing-bearrub))
      ((father singing-bearrub) (mother grisly-bearring)) ((father grisly-bearring) (mother singing-bearrub))
      ((father twinkle-tiger) (mother grisly-bearring)) ((father grisly-bearring) (mother twinkle-tiger))
    )))

(species sea-bearring
  (name "Sea Bearring")
  (reference-link "http://floraverse.com/comic/pages/613-bearrings-common/")
  (citizen? #t)
  (common-regions owel)
  (distributions
    (affinity (* 47) (psi 47)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      bearring vanguard)
    (special-cases
      ((father bearring) (mother vanguard)) ((father vanguard) (mother bearring))
    )))

(species singing-bearrub
  (name "Singing Bearrub")
  (reference-link "http://floraverse.com/comic/pages/613-bearrings-common/")
  (citizen? #t)
  (common-regions owel)
  (distributions
    (affinity (* 47) (psi 47)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      bearring singing-rabbat)
    (special-cases
      ((father bearring) (mother singing-rabbat)) ((father singing-rabbat) (mother bearring))
    )))

(species twinkle-tiger
  (name "Twinkle Tiger")
  (reference-link "http://floraverse.com/comic/pages/613-bearrings-common/")
  (citizen? #t)
  (common-regions owel)
  (distributions
    (affinity (* 47) (psi 47)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      bearring turf-tiger)
    (special-cases
      ((father bearring) (mother turf-tiger)) ((father turf-tiger) (mother bearring))
    )))

(species grisly-bearring
  (name "Grisly Bearring")
  (reference-link "http://floraverse.com/comic/pages/613-bearrings-common/")
  (citizen? #t)
  (common-regions owel)
  (distributions
    (affinity (* 47) (psi 47)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      bearring necropossum)
    (special-cases
      ((father bearring) (mother necropossum)) ((father necropossum) (mother bearring))
    )))
