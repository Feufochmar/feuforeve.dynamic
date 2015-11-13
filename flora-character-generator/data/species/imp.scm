(species imp
  (name "Imp")
  (reference-link "http://floraverse.com/wiki/species/imp")
  (citizen? #t)
  (tribal? #t)
  (isolated? #t)
  (mimic-chooser (character-data)
    (letrec*
      ((find-parent-base-species
          (lambda (parent-of)
            (let* ((parent-data (parent-of character-data))
                   (true-species (if parent-data (species-of parent-data) #f))
                   (base-species (if parent-data (base-species parent-data) #f)))
              (if (and true-species (mimic? true-species))
                  base-species
                  true-species))))
       (mother-species (find-parent-base-species mother))
       (father-species (find-parent-base-species father))
       (pick-random-species
         (lambda ()
            (let ((parents-species-keys (pick-from (possible-parents (species-of character-data)))))
              (cond
                ((not (eq? 'imp (car parents-species-keys))) (get-species (car parents-species-keys)))
                ((not (eq? 'imp (cdr parents-species-keys))) (get-species (cdr parents-species-keys)))
                (#t (pick-random-species))
              ))))
      )
      (cond
        ((and father-species mother-species) (if (pick-boolean) father-species mother-species))
        (father-species father-species)
        (mother-species mother-species)
        (#t (pick-random-species)))))
  (common-regions polaris hellside)
  (distributions
    (affinity (* 1) (earth 500) (lava 100) (clay 100) (sand 100)
              (crystal 100) (magnet 100) (water 10) (fire 10) (air 10)
              (spirit 10))
    (sex (both 1))
    (ages (infant 1) (child 1) (adolescent 4) (young-adult 8) (adult 12) (ageless-adult 12)))
  (reproduction
    (common-pattern? #t)
    (crossbreed-with
      ; Animals - Althar 1
      pendragon bookwyrm vinedra dyevern
      ; Animals - Althar 2
      pricklehog sicklehog
      ; Animals - Althar 3
      goatato gossheep star-anisheep
      ; Animals - Althar 4
      oregagnome cilantroll sorrelf fennelf
      ; Animals - Althar 5
      sand-hippo sea-snamel
      ; Animals - Althar 6
      puppea snappea-turtle lycheel saffrog
      ; Animals - Bugs of Deep Mountain
      ; None
      ; Animals - Cherran
      tomato-oh flamingon pomegrub frogola catermelon ankirschelosaur
      ; Animals - Citrico
      zanahorsia clementillo pumpkit kikinut taro-moth caterpither salamango
      ; Animals - Extra
      habaneron wasabika tetradish zwiebat seahorseradish cheeli mustallusk ghost-ray
      ; Animals - Musapeel
      platorgon bananavern starfinch lemarlon momonkey pearimate ananantelope
      ; Animals - Polaris
      berry-bunny pfig lettuce-lion moletato aubergoose
      ; Animals - Southwest Owel Coast - 1
      sea-bear kamerge armor-fish sucker-shark bweehorse
      ; Animals - Southwest Owel Coast - 2
      diamond-head-dolphin peliclam sack-jelly coif-crab polester
      ; Animals - Southwest Owel Coast - 3
      rockabelly-whale shell-slicer-whale
      ; Animals - Southwest Owel Coast - 4
      squinker rubbyou mark-knocker beavering
      ; Animals - Southwest Owel Coast - 5
      sharker slugrub pastelbit gel-squinker drip-seel
      ; Animals - Southwest Owel Coast - 6
      watercolor-buffalo pangochoir chromadillo prism-star
      ; Animals - Southwest Owel Coast - 7
      giraffe-roller palette-fish glazemodo spraypaint-skunk
      ; Animals - Southwest Owel Coast - 8
      sack-anemone pearly-whelk cleaner-shrimp porcelain-plate-crab bell-shelled-tortoise
      ; Animals - Southwest Owel Coast - 9
      charcoal-chicken stamp-roller sponge-frog gum-shooter living-likeness
      ; Animals - Stemm
      pommeranian fiddeleon snowl muddler broccolamb cauliflamb scalamar zucchinu gingrake
      ; Animals - Trebol - Screaming Island Animals
      mandrake jack
      ; Animals - Trebol - 1
      melodingo smelodingo bandragon trebol-bweehorse backwater-bweehorse
      ; Aurorian Fox
      aurorian-fox
      ; Beholding Siren
      ; None
      ; Cagroo
      cagroo shagroo cagrugong swagroo cotton-cagroodle bogroo cagroodle
      ; Cockatrice
      cockatrice
      ; Coralshell turtle
      coralshell-turtle
      ; Flowercat
      flowercat
      ; Foxbat
      foxbat foxbat-spirit
      ; Frilled Petal Dragon
      frilled-petal-dragon petaltrice flower-dragorgon pomegragon blueberrygon
      ; Fruit Frog
      ; None
      ; Gelbeast
      ; None
      ; Hanged Man
      hanged-man
      ; Imp
      ; See above
      ; Manticore
      manticore
      ; Masked Owl
      ; None
      ; Moahu
      ; None
      ; Necropossum
      necropossum deathwalker bansheep bonefish nekopossum shackal
      ; Owel Treant
      owel-treant
      ; Painted Alligator
      painted-alligator
      ; Pygmy Pyzky
      pygmy-pyzky
      ; Revealeon
      ; None
      ; Rock Candies
      rock-candies
      ; Satyr
      satyr satyrbun satyrqorn satyrfox flower-candies goatixy
      ; Scrapgoat
      scrapgoat diogoat
      ; Sea Dragon
      sea-dragon seavern sea-dragorgon trojan-dragon
      ; Singing Rabbat
      singing-rabbat chirping-rabbat rugarabbat vampire-rabbat
      ; Vanguard
      vanguard
      ; Weed Wolf
      weed-wolf maple-dog pin-bull palmeranian pine-hound shruppy weeping-woodle
      ;
      ; Undescribed
      uniqorn commons-fox borealan-fox gorgon kelpie arachoon mouse bastian clover-lamb cat jackal
    )))
