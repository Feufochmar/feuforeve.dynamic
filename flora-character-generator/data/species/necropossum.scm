;; Necropossum
(species necropossum
  (name "Necropossum")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions glissod)
  (distributions
    (affinity (* 1) (spirit 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger grisly-bearring)
    (special-cases
      ((father deathwalker) (mother bansheep)) ((father bansheep) (mother deathwalker))
      ((father deathwalker) (mother bonefish)) ((father bonefish) (mother deathwalker))
      ((father deathwalker) (mother nekopossum)) ((father nekopossum) (mother deathwalker))
      ((father deathwalker) (mother vampire-rabbat)) ((father vampire-rabbat) (mother deathwalker))
      ((father deathwalker) (mother shackal)) ((father shackal) (mother deathwalker))
      ((father deathwalker) (mother tomb-tiger)) ((father tomb-tiger) (mother deathwalker))
      ((father deathwalker) (mother grisly-bearring)) ((father grisly-bearring) (mother deathwalker))
      ((father bansheep) (mother bonefish)) ((father bonefish) (mother bansheep))
      ((father bansheep) (mother nekopossum)) ((father nekopossum) (mother bansheep))
      ((father bansheep) (mother vampire-rabbat)) ((father vampire-rabbat) (mother bansheep))
      ((father bansheep) (mother shackal)) ((father shackal) (mother bansheep))
      ((father bansheep) (mother tomb-tiger)) ((father tomb-tiger) (mother bansheep))
      ((father bansheep) (mother grisly-bearring)) ((father grisly-bearring) (mother bansheep))
      ((father bonefish) (mother nekopossum)) ((father nekopossum) (mother bonefish))
      ((father bonefish) (mother vampire-rabbat)) ((father vampire-rabbat) (mother bonefish))
      ((father bonefish) (mother shackal)) ((father shackal) (mother bonefish))
      ((father bonefish) (mother tomb-tiger)) ((father tomb-tiger) (mother bonefish))
      ((father bonefish) (mother grisly-bearring)) ((father grisly-bearring) (mother bonefish))
      ((father nekopossum) (mother vampire-rabbat)) ((father vampire-rabbat) (mother nekopossum))
      ((father nekopossum) (mother shackal)) ((father shackal) (mother nekopossum))
      ((father nekopossum) (mother tomb-tiger)) ((father tomb-tiger) (mother nekopossum))
      ((father nekopossum) (mother grisly-bearring)) ((father grisly-bearring) (mother nekopossum))
      ((father vampire-rabbat) (mother shackal)) ((father shackal) (mother vampire-rabbat))
      ((father vampire-rabbat) (mother tomb-tiger)) ((father tomb-tiger) (mother vampire-rabbat))
      ((father vampire-rabbat) (mother grisly-bearring)) ((father grisly-bearring) (mother vampire-rabbat))
      ((father shackal) (mother tomb-tiger)) ((father tomb-tiger) (mother shackal))
      ((father shackal) (mother grisly-bearring)) ((father grisly-bearring) (mother shackal))
      ((father tomb-tiger) (mother grisly-bearring)) ((father grisly-bearring) (mother tomb-tiger))
    )))

;; Deadwood
(species deadwood
  (name "Deadwood")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (wild? #t)
  (common-regions glissod)
  (distributions
    (affinity (* 1) (spirit 40)))
  (reproduction
    (common-pattern? #f)))

;; Deathwalker
(species deathwalker
  (name "Deathwalker")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions althar)
  (distributions
    (affinity (* 1) (spirit 30) (poison 30)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum manticore)
    (special-cases
      ((father necropossum) (mother manticore)) ((father manticore) (mother necropossum))
    )))

;; Bansheep
(species bansheep
  (name "Bansheep")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions hellside)
  (distributions
    (affinity (* 1) (spirit 30) (sound 30)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum clover-lamb)
    (special-cases
      ((father necropossum) (mother clover-lamb)) ((father clover-lamb) (mother necropossum))
    )))

;; Bonefish
(species bonefish
  (name "Bonefish")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions glissod)
  (distributions
    (affinity (* 1) (spirit 30) (water 30)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum vanguard)
    (special-cases
      ((father necropossum) (mother vanguard)) ((father vanguard) (mother necropossum))
    )))

;; Nekopossum
(species nekopossum
  (name "Nekopossum")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions glissod)
  (distributions
    (affinity (* 1) (spirit 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum cat)
    (special-cases
      ((father necropossum) (mother cat)) ((father cat) (mother necropossum))
    )))

;; For Vampire Rabbat, see Singing Rabbats

;; Shackal
(species shackal
  (name "Shackal")
  (reference-link "http://floraverse.com/comic/short-stories/376-monsters-from-monsters/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions althar)
  (distributions
    (affinity (* 1) (spirit 40)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      necropossum jackal)
    (special-cases
      ((father necropossum) (mother jackal)) ((father jackal) (mother necropossum))
    )))
