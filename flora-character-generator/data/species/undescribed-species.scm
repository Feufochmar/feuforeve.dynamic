;; Species that has not been described yet
;; They can be generated in ascendents and partners of the generated characters,
;; but not as generated characters
(species uniqorn
  (name "Uniqorn")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species commons-fox
  (name "Commons Fox")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species borealan-fox
  (name "Borealan Fox")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species gorgon
  (name "Gorgon")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species kelpie
  (name "Kelpie")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species arachoon
  (name "Arachoon")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species mouse
  (name "Mouse")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species bastian
  (name "Bastian")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      pygmy-bastian)))

(species rugaru
  (name "Rugaru")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species clover-lamb
  (name "Clover Lamb")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      bansheep truce-tiger)
    (special-cases
      ((father bansheep) (mother truce-tiger)) ((father truce-tiger) (mother bansheep))
    )))

(species cat
  (name "Cat")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)))

(species jackal
  (name "Jackal")
  (reference-link "http://floraverse.com")
  (distributions
    (affinity (* 44) (psi 112))) ; Spirit/PSI is at 11.2 % according to the bearrings species sheet
  (reproduction
    (common-pattern? #t)))

(species rakshasa
  (name "Rakshasa")
  (reference-link "http://floraverse.com")
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      atrocitiger)))
