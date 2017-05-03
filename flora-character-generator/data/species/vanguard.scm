(species vanguard
  (name "Vanguard")
  (reference-link "http://floraverse.com/comic/flora/page/194-vanguard-species/")
  (citizen? #t)
  (common-regions
    citrico-archipelago citrico-capital twin-luxuries dewclaw althar miaoustok carrot-crook national-port-of-owel
    treefall kadath auroria
    glissod eastar jewell cenastre)
  (distributions
    (affinity (* 1) (water 50) (acid 10) (ice 30) (cloud 10) (poison 30) (sound 30)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      sea-dragon
      ;
      bonefish surf-tiger sea-bearring)
    (special-cases
      ((father bonefish) (mother surf-tiger)) ((father surf-tiger) (mother bonefish))
      ((father bonefish) (mother sea-bearring)) ((father sea-bearring) (mother bonefish))
      ((father surf-tiger) (mother sea-bearring)) ((father sea-bearring) (mother surf-tiger))
    )))
