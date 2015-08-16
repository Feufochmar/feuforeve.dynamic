(species frilled-petal-dragon
  (name "Frilled Petal Dragon")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (wild? #t)
  (common-regions
    citrico-archipelago dewclaw paranoia ever-hopeful heart-mountain carrot-crook dendain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      coralshell-turtle petaltrice flower-dragorgon pomegragon blueberrygon gum-shooter salamango)
    (special-cases
      ((father petaltrice) (mother flower-dragorgon)) ((father flower-dragorgon) (mother petaltrice))
      ((father petaltrice) (mother pomegragon)) ((father pomegragon) (mother petaltrice))
      ((father petaltrice) (mother blueberrygon)) ((father blueberrygon) (mother petaltrice))
      ((father flower-dragorgon) (mother pomegragon)) ((father pomegragon) (mother flower-dragorgon))
      ((father flower-dragorgon) (mother blueberrygon)) ((father blueberrygon) (mother flower-dragorgon))
      ((father pomegragon) (mother blueberrygon)) ((father blueberrygon) (mother pomegragon))
    )))

(species petaltrice
  (name "Petaltrice")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago dewclaw heart-mountain carrot-crook dendain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      frilled-petal-dragon cockatrice)
    (special-cases
      ((father frilled-petal-dragon) (mother cockatrice)) ((father cockatrice) (mother frilled-petal-dragon))
    )))

(species flower-dragorgon
  (name "Flower Dragorgon")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago dewclaw heart-mountain carrot-crook dendain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      frilled-petal-dragon gorgon)
    (special-cases
      ((father frilled-petal-dragon) (mother gorgon)) ((father gorgon) (mother frilled-petal-dragon))
    )))

(species frilled-pigmy-dragon
  (name "Frilled Pigmy Dragon")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (wild? #t)
  (tamable? #t)
  (common-regions
    auroria)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)))

(species frilled-petal-dragosaur
  (name "Frilled Petal Dragosaur")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (wild? #t)
  (common-regions
    deep-mountain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)))

(species pomegragon
  (name "Pomegragon")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (wild? #t)
  (common-regions
    citrico-archipelago dewclaw heart-mountain carrot-crook dendain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      frilled-petal-dragon)))

(species blueberrygon
  (name "Blueberrygon")
  (reference-link "http://floraverse.com/comic/flora/page/203-frilled-petal-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (wild? #t)
  (common-regions
    citrico-archipelago dewclaw heart-mountain carrot-crook dendain)
  (distributions
    (affinity (* 1) (fire 15) (water 15) (air 15) (earth 15) (light 15)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      frilled-petal-dragon)))
