(locations
  (types
    (city (name "city") (preposition-in "in") (preposition-near "near"))
    (town (name "town") (preposition-in "in") (preposition-near "near"))
    (lake (name "lake") (preposition-in "along") (preposition-near "near"))
    (river (name "river") (preposition-in "along") (preposition-near "near"))
    (seashore (name "seashore") (preposition-in "along") (preposition-near "near"))
    (plain (name "plain") (preposition-in "on") (preposition-near "near"))
    (cave (name "cave") (preposition-in "in") (preposition-near "near"))
    (hill (name "hill") (preposition-in "on") (preposition-near "near"))
    (swamp (name "swamp") (preposition-in "in") (preposition-near "near"))
    (wall (name "wall") (preposition-in "on") (preposition-near "near"))
    (forest (name "forest") (preposition-in "in") (preposition-near "near"))
    (valley (name "valley") (preposition-in "in") (preposition-near "near"))
    (ruins (name "ruins") (preposition-in "in") (preposition-near "near"))
    (island (name "island") (preposition-in "in") (preposition-near "near"))
    (grassland (name "grassland") (preposition-in "in") (preposition-near "near"))
    (village (name "village") (preposition-in "in") (preposition-near "near"))
    (mountain (name "mountain") (preposition-in "on") (preposition-near "near"))
    (plateau (name "plateau") (preposition-in "on") (preposition-near "near"))
    (sinkhole (name "sinkhole") (preposition-in "in") (preposition-near "near"))
    (oasis (name "oasis") (preposition-in "in") (preposition-near "near"))
    (somewhere (name "somewhere") (preposition-in "") (preposition-near "")))
  (regions
    (region topside
            ((name "Topside")
             (reference-link "http://floraverse.com/"))
      (region owel
             ((name "Owel")
              (reference-link "http://floraverse.deviantart.com/art/Owel-Geography-441905405"))
        (region citrico-archipelago
                ((name "Citrico Archipelago")
                 (reference-link "http://floraverse.com/comic/flora/page/99-the-citrico-archipelago/"))
          (region polaris
                  (name "Polaris Island")
                  (places
                    (city "Polaris")
                    (town "Aurora" "Darrow" "Toro" "Duke" "Reka")
                    (lake "Lake Aurora" "Lake Darrow" "Lake Toro" "Lake Duke" "Lake Reka")))
          (region citrico
                  (name "Citrico Island")
                  (places
                    (city "Citrico")
                    (town "Cutie" "Cara Cara" "Clement" "Ham" "Navel")))
          (region musapeel
                  (name "Musapeel Island")
                  (places
                    (city "Musapeel")
                    (town "Burr" "Manza" "Caven")))
          (region cherran
                  (name "Cherran Island")
                  (places
                    (city "Cherran")
                    (town "Napoleon" "Ranier")))
          (region stemm
                  (name "Stemm Island")
                  (places
                    (city "Stemm")
                    (town "Snow" "Snap" "String")))) ; Citrico Archipelago End
        (region southwest-owel
                ((name "Southwest Owel")
                 (reference-link "http://floraverse.com/comic/references/172-southwest-owel-map/"))
          (region citrico-capital
                  (name "Mainland Citrico")
                  (places
                    (city "Citrico Capital")
                    (town "Zest" "Rind" "Pith" "Alua" "Nox" "The Dropoff")
                    (river "Miaoustok River")))
          (region twin-luxuries
                  (name "Twin Luxuries")
                  (places
                    (city "West Luxury" "East Luxury")
                    (town "Wishbone")
                    (seashore "Luxury Cove")))
          (region dewclaw
                  (name "Dewclaw Region")
                  (places
                    (city "Dewclaw")
                    (town "Talon" "Haunch" "Catfish Crossing")
                    (lake "Catfish Lake")
                    (plain "Dewclaw Flats")))
          (region moggy
                  (name "Moggy Region")
                  (places
                    (city "Moggy")
                    (town "Spur" "Whisker")
                    (cave "Moggy Mines")))
          (region peace-quiet
                  (name "Peace & Quiet Region")
                  (places
                    (town "Peace" "Quiet")))) ; End of Southwest Owel
        ; There should be more intermediaries regions between those and Owel
        (region mew-york-territories
                ((name "Mew York Territories")
                 (reference-link "http://floraverse.com/comic/references/547-mew-york-territories/"))
          (region lakeside-district
                  (name "Lakeside")
                  (places
                    (town "Port Innsmouth")
                    (lake "Lake Miaoustok")
                    (river "Miaoustok River")))
          (region west-district
                  (name "West District")
                  (places
                    (town "Port Lemin" "Appleton" "West York Harbor" "Ascot" "Tyria")
                    (river "Miaoustok River")))
          (region north-district
                  (name "North District")
                  (places
                    (town "Port Poppy" "Glowbug" "Foxfire")
                    (river "Miaoustok River")))
          (region mew-york-reservoir
                  (name "Mew York Wildlife Reserve")
                  (places
                    (lake "Mew York Reservoir")))
          (region the-terraces
                  (name "The Terraces")
                  (places
                    (town "Peacock" "Suntrap")))
          (region central-district
                  (name "Central District")
                  (places
                    (city "Mew York City")))
          (region scrump
                  (name "Scrump")
                  (places
                    (town "Snitch" "Rustle")))
          (region vandalroot-district
                  (name "Vandalroot District")
                  (places
                    (town "Catkin" "Hedgetown")))) ; End of Mew York Territories
        (region althar
                ((name "Althar Province")
                 (reference-link "http://floraverse.com/comic/references/375-althar-province/"))
          (region upper-altar
                  (name "Upper Althar")
                  (places
                    (town "Upper Althar")
                    (river "Seif Straits")
                    (village "The Crystal Farms")
                    (valley "Sere Valley"))) ; Sere Valley put there, but not sure if correct
          (region delta-islands
                  (name "Delta Islands")
                  (places
                    (city "Althar") ; put there so that reference lookup is ok
                    (river "Miaoustok River")
                    (village "Perish")
                    (town "Petal")))
          (region lower-althar
                  (name "Lower Althar")
                  (places
                    (city "Lower Althar")
                    (grassland "The Pharms" "The Hatchery" "Flower" "Paradise Fields")
                    (lake "Trickle Lakes" "Fickle Lakes"))))
        (region auroria
                (name "Auroria Territories")
                (reference-link "http://floraverse.com/comic/references/550-auroria-territories/")
                (places
                  (city "Auroria")
                  (town "Cirrus Checkpoint A" "Cirrus Checkpoint B" "Cirrus Checkpoint C"
                        "Coraldome" "Eelgrass" "Giddy" "Frostpaw" "Season" "Mush" "Rime"
                        "Fossil Valley")
                  (plain "Auroria Desert" "Auroria Plains")
                  (forest "Auroria Forest" "Auroria Taiga")
                  (seashore "Frosty Bay")))
        (region kadath
                (name "Kadath Territories")
                (reference-link "http://floraverse.com/comic/references/553-kadath-territories/")
                (places
                  (city "Kadath")
                  (town "Ariathens" "Sand Fresco" "Flamebridge" "New Atlantis" "Limew" "Ria")
                  (forest "Brittle Woods" "Shifting Woods" "Amalgamate Grotto")
                  (seashore "Frosty Bay")))
        ; Owel regions below are not as known as above
        (region beheaded-city
                (name "Beheaded City Region")
                (places
                  (city "Beheaded City")))
        (region ventose-flats
                (name "Ventose Flats")
                (places
                  (plain "Ventose Flats")))
        (region new-gnoll-nation
                (name "N.E.W. Gnoll Nation")
                (places
                  (city "Crunchbone" "Bonecrunch" "Bonecrush")
                  (hill "Gnolls's Knolls")
                  (lake "Three Gnoll Lake's")))
        (region aromia
                (name "Aromia Region")
                (places
                  (city "Aromia")))
        (region croon-fens
                (name "Croon Fens")
                (places
                  (city "Croon Hamlets")
                  (swamp "Marshtune Glades" "Croon Fens")))
        (region quarantine
                (name "Quarantine")
                (places
                  (town "Kadath Outpost")
                  (wall "The Quarantine")))
        (region natures-folly
                ((name "Nature's Folly")
                 (restricted? #t))
          (region paranoia
                  (name "Paranoia Region")
                  (places
                    (town "Paranoia")
                    (swamp "Neck-Deep Mire")))
          (region void-forest
                  (name "Void Forest Area")
                  (places
                    (forest "Void Forest")))
          (region ever-hopeful
                  (name "Ever Hopeful Region")
                  (places
                    (valley "Beholder Gorge")
                    (ruins "Ever Hopeful")))
          (region heavens-keys
                  (name "Heaven's Keys Archipelago")
                  (places
                    (island "Heaven's Keys")))) ; End of Nature's Folly
        (region gloam
                (name "Gloam Region")
                (places
                  (city "Gloam")
                  (lake "Neon Lake")
                  (forest "Fulgid Forest")))
        (region miaoustok
                (name "Miaoustok Region")
                (places
                  (city "Miaoustok")
                  (lake "Lake Miaoustok")))
        (region stony-barrens
                (name "Stony Barrens")
                (places
                  (plain "Stony Barrens")))
        (region peril
                (name "Peril")
                (places
                  (forest "Peril")
                  (village "Good Intentions")))
        (region prospector
                (name "Prospector Region")
                (places
                  (city "Prospector")))
        (region heart-mountain
                (name "Heart Mountain")
                (places
                  (mountain "Heart Mountain")))
        (region carrot-crook
                (name "Carrot Crook")
                (places
                  (seashore "Carrot Crook")))
        (region candy-rock
                (name "Candy Rock Region")
                (places
                  (city "Candy Rock")
                  (lake "Candy Lake")
                  (plateau "Candy Mesa")))
        (region teslic-yard
                (name "Teslic Yard")
                (places
                  (plateau "Teslic Yard")))
        (region gnawth
                (name "Gnawth Region")
                (places
                  (city "Gnawth")
                  (river "Miaoustok River")))
        (region national-port-of-owel
                (name "National Port of Owel Region")
                (places
                  (city "National Port of Owel")
                  (river "Miaoustok River")))
        (region treefall
                (name "Treefall Region")
                (places
                  (city "Treefall")
                  (lake "Treefall Lake")
                  (forest "Treefall Greens")))
        (region deep-plateau
                (name "Deep Plateau")
                (places
                  (sinkhole "Deep Plateau")))
        (region deep-mountain
                (name "Deep Mountain")
                (places
                  (sinkhole "Deep Mountain")
                  (sinkhole "Deep Mountain summit")))
        (region holiday
                (name "Holiday Region")
                (places
                  (city "Holiday")
                  (swamp "Holiday Marsh")))
        (region honeycomb-plateau
                (name "Honeycomb Plateau")
                (places
                  (plateau "Honeycomb Plateau")))
        (region dendain
                (name "Dendain")
                (places
                  (plateau "Dendain")
                  (oasis "Sandsong Oasis")))
        (region olive-hills
                (name "Olive Hills")
                (places
                  (hill "Olive Hills")))
        (region mossy-depression
                (name "Mossy Depression")
                (places
                  (swamp "Mossy Depression")))) ; Owel End
      ; Continents cited on diverse species sheets
      (region eastar
              (name "Eastar")
              (restricted? #t)
              (places
                (somewhere "somewhere in Eastar")))
      (region glissod
              (name "Glissod")
              (restricted? #t)
              (places
                (somewhere "somewhere in Glissod")))
      (region jewell
              (name "Jewell")
              (restricted? #t)
              (places
                (somewhere "somewhere in Jewell")))
      (region cenastre
              (name "Cenastre")
              (restricted? #t)
              (places
                (somewhere "somewhere in Cenastre")))) ; Topside end
    (region hellside
            ((name "Hellside"))
      (region blackjack-isles
              ((name "Blackjack Isles")
               (reference-link "http://floraverse.com/comic/flora/page/296-the-blackjack-isles/"))
        (region trebol
                ((name "Trebol"))
          (region turnstile
                  (name "Turnstile")
                  (places
                    (city "Vinyl")))
          (region bluegrass
                  (name "Bluegrass")
                  (places
                    (city "Foxtrot")
                    (hill "Bluegrass Hills")
                    (mountain "Bluegrass Mountains")
                    (lake "Lake Simile")))
          (region ballero
                  (name "Ballero")
                  (places
                    (city "Sonata")
                    (town "A" "B" "C" "D" "E" "F" "G" "R")))
          (region r-bop
                  (name "R-Bop")
                  (places
                    (city "Fundango")
                    (town "Slide")))
          (region disco-disco
                  (name "Disco-Disco")
                  (places
                    (city "Galop")
                    (town "Shufflebugg" "Skip")))
          (region screaming-island
                  (name "Screaming Island")
                  (places
                    (island "Screaming Island")))) ; End of Trebol
        (region chance
                ((name "Chance"))
          (region diamond-spiral
                  (name "Diamond Spiral")
                  (places
                    (city "Hindsight")))
          (region pixel
                  (name "Pixel")
                  (places
                    (town "Rainbow" "Prism")
                    (plain "Tilt Acres")))
          (region penny
                  (name "Penny")
                  (places
                    (town "Dime" "Nickel")
                    (forest "Buck Woods")))) ; End of Chance
        (region cardios
                ((name "Cardios"))
          (region coeur
                  (name "Cœur")
                  (places
                    (city "Cupid")
                    (town "Rosiere")
                    (mountain "Rosy Mounts")
                    (river "Wish River" "Bone River")))
          (region axon
                  (name "Axon")
                  (places
                    (town "Coma" "Vaxine")
                    (mountain "Rosy Mounts")
                    (river "Wish River")))
          (region sacral
                  (name "Sacral")
                  (places
                    (town "Casette" "Shallow")
                    (mountain "Rosy Mounts")
                    (river "Bone River")))) ; End of Cardios
        (region pike
                ((name "Pike"))
          (region angel-tear-downstream
                  (name "Angel Tear Downstream")
                  (places
                    (city "Spoke" "Circuit")
                    (river "Angel Tear River")))
          (region stockade
                  (name "Stokade")
                  (places
                    (town "The Vault")))
          (region battery
                  (name "Battery")
                  (places
                    (town "Terminal")))
          (region gods-gate
                  (name "God's Gate")
                  (restricted? #t)
                  (places
                    (town "The Citadel" "Bastion")
                    (river "Angel Tear River")
                    (mountain "Divine Mounts")))))) ; End of Pike, End of Blackjack Isles, End of hellside
    ; Nowhere
    (region nowhere
            (name "Nowhere")
            (restricted? #t)
            (places
              (somewhere "Nowhere")))))
