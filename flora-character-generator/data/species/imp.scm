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
      flowercat foxbat foxbat-spirit cockatrice vanguard painted-alligator rock-candies hanged-man pygmy-pyzky
      manticore aurorian-fox satyr satyrbun satyrqorn satyrfox flower-candies goatixy sea-dragon seavern
      sea-dragorgon trojan-dragon coralshell-turtle frilled-petal-dragon petaltrice flower-dragorgon
      pomegragon blueberrygon cagroo shagroo cagrugong swagroo cotton-cagroodle bogroo cagroodle weed-wolf
      maple-dog pin-bull palmeranian pine-hound shruppy weeping-woodle owel-treant pommeranian fiddeleon
      snowl muddler broccolamb cauliflamb scalamar zucchinu gingrake tomato-oh flamingon pomegrub frogola
      catermelon ankirschelosaur platorgon bananavern starfinch lemarlon momonkey pearimate ananantelope
      zanahorsia clementillo pumpkit kikinut taro-moth caterpither salamango myrticke muscant berry-bunny
      pfig lettuce-lion moletato aubergoose habaneron wasabika tetradish zwiebat seahorseradish cheeli
      mustallusk ghost-ray sea-bear kamerge armor-fish sucker-shark bweehorse diamond-head-dolphin peliclam
      sack-jelly coif-crab polester rockabelly-whale shell-slicer-whale squinker rubbyou mark-knocker beavering
      sharker slugrub pastelbit gel-squinker drip-seel watercolor-buffalo pangochoir chromadillo spool-spider
      prism-star giraffe-roller palette-fish glazemodo spraypaint-skunk sack-anemone pearly-whelk cleaner-shrimp
      porcelain-plate-crab urn-urchin bell-shelled-tortoise doubloon-barnacle charcoal-chicken stamp-roller
      sponge-frog gum-shooter living-likeness mandrake jack melodingo smelodingo bandragon trebol-bweehorse
      backwater-bweehorse singing-rabbat scrapgoat
      uniqorn commons-fox borealan-fox gorgon kelpie arachoon mouse bastian
    )))
