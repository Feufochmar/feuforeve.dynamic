(species sea-dragon
  (name "Sea Dragon")
  (reference-link "http://floraverse.com/comic/flora/page/195-sea-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago citrico-capital twin-luxuries althar carrot-crook national-port-of-owel
    kadath auroria glissod)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (ice 15) (clay 15) (storm 15) (crystal 50)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      vanguard seavern sea-dragorgon trojan-dragon coralshell-turtle)
    (special-cases
      ((father seavern) (mother sea-dragorgon)) ((father sea-dragorgon) (mother seavern))
      ((father seavern) (mother trojan-dragon)) ((father trojan-dragon) (mother seavern))
      ((father sea-dragorgon) (mother trojan-dragon)) ((father trojan-dragon) (mother sea-dragorgon))
    )))

(species seavern
  (name "Seavern")
  (reference-link "http://floraverse.com/comic/flora/page/195-sea-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago citrico-capital twin-luxuries althar carrot-crook national-port-of-owel
    kadath auroria glissod)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (ice 15) (clay 15) (storm 15) (crystal 50)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      sea-dragon cockatrice)
    (special-cases
      ((father sea-dragon) (mother cockatrice)) ((father cockatrice) (mother sea-dragon))
    )))

(species sea-dragorgon
  (name "Sea Dragorgon")
  (reference-link "http://floraverse.com/comic/flora/page/195-sea-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago citrico-capital twin-luxuries althar carrot-crook national-port-of-owel
    kadath auroria glissod)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (ice 15) (clay 15) (storm 15) (crystal 50)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      sea-dragon gorgon)
    (special-cases
      ((father sea-dragon) (mother gorgon)) ((father gorgon) (mother sea-dragon))
    )))

(species trojan-dragon
  (name "Trojan Dragon")
  (reference-link "http://floraverse.com/comic/flora/page/195-sea-dragon-species/")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (common-regions
    citrico-archipelago citrico-capital twin-luxuries althar carrot-crook national-port-of-owel
    kadath auroria glissod)
  (distributions
    (affinity (* 1) (water 40) (air 40) (earth 40) (ice 15) (clay 15) (storm 15) (crystal 50)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      sea-dragon kelpie)
    (special-cases
      ((father sea-dragon) (mother kelpie)) ((father kelpie) (mother sea-dragon))
    )))
