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
      deathwalker bansheep bonefish nekopossum vampire-rabbat shackal)
    (special-cases
      ((father deathwalker) (mother bansheep)) ((father bansheep) (mother deathwalker))
      ((father deathwalker) (mother bonefish)) ((father bonefish) (mother deathwalker))
      ((father deathwalker) (mother nekopossum)) ((father nekopossum) (mother deathwalker))
      ((father deathwalker) (mother vampire-rabbat)) ((father vampire-rabbat) (mother deathwalker))
      ((father deathwalker) (mother shackal)) ((father shackal) (mother deathwalker))
      ((father bansheep) (mother bonefish)) ((father bonefish) (mother bansheep))
      ((father bansheep) (mother nekopossum)) ((father nekopossum) (mother bansheep))
      ((father bansheep) (mother vampire-rabbat)) ((father vampire-rabbat) (mother bansheep))
      ((father bansheep) (mother shackal)) ((father shackal) (mother bansheep))
      ((father bonefish) (mother nekopossum)) ((father nekopossum) (mother bonefish))
      ((father bonefish) (mother vampire-rabbat)) ((father vampire-rabbat) (mother bonefish))
      ((father bonefish) (mother shackal)) ((father shackal) (mother bonefish))
      ((father nekopossum) (mother vampire-rabbat)) ((father vampire-rabbat) (mother nekopossum))
      ((father nekopossum) (mother shackal)) ((father shackal) (mother nekopossum))
      ((father vampire-rabbat) (mother shackal)) ((father shackal) (mother vampire-rabbat))
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
