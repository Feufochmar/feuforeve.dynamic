;; Abilities derived from the descriptions on the species sheets
(ability
  (name "Cold Tolerance")
  (category "Thermodynamics")
  (description "A person with the Cold Tolerance ability can live in very cold environments without the need of protecting themselves from the low temperatures.")
  (restrictions
    (is-species aurorian-fox cagroodle swirl-fox)))

(ability
  ;; same as above, but restriction on affinity
  (name "Cold Tolerance")
  (category "Thermodynamics")
  (description "A person with the Cold Tolerance ability can live in very cold environments without the need of protecting themselves from the low temperatures.")
  (restrictions
    (has-affinity ice)))

(ability
  (name "Heat Tolerance")
  (category "Thermodynamics")
  (description "A person with the Heat Tolerance ability can live in very hot environments without the need of protecting themselves from the high temperatures.")
  (restrictions
    (has-affinity fire lava)))

(ability
  (name "Lava Walker")
  (category "Thermodynamics")
  (description "A person with the Lava Walker ability can walk on lava or swim in lava (depending on the viscosity of the lava) without sustaining damage from the heat.")
  (restrictions
    (has-affinity lava)))

(ability
  (name "Hypnotizing Glare")
  (category "Mind Control")
  (description "A person with the Hypnotizing Glare ability can suggest behaviour and practice mind control on other individuals with their gaze. Individuals with horizontal pupils are immune against the sugestions of users of the Hypnotizing Glare ability.")
  (restrictions
    (is-species cockatrice)))

(ability
  (name "Rooster Crow Syndrome")
  (category "Disability")
  (description "A person with the Rooster Crow Syndrome ability are debilitated upon hearing the crow of a rooster. The hearing of a rooster crow gives persons with the Rooster Crow Syndrome painful headaches and can render them immobile for several days.")
  (restrictions
    (is-species cockatrice)))

(ability
  (name "Lisk Speaker")
  (category "Language")
  (description "A person with the Lisk Speaker ability can understand Lisk and speak it innately.")
  (restrictions
    (is-species cockatrice)))

(ability
  (name "Plant Speaker")
  (category "Language")
  (description "A person with the Plant Speaker ability can understand and talk to any kind of sentient plant innately.")
  (restrictions
    (is-species flowercat fruit-frog flower-frog capricornucopia owel-treant pygmy-pyzky flower-tiger)))

(ability
  (name "Weather Forecast")
  (category "Foresight")
  (description "A person with the Weather Forecast ability can predict abrupt weather changes a few days in advance.")
  (restrictions
    (is-species flowercat flower-tiger)))

(ability
  ;; Same as above, but restricted on affinities
  (name "Weather Forecast")
  (category "Foresight")
  (description "A person with the Weather Forecast ability can predict abrupt weather changes a few days in advance.")
  (restrictions
    (has-affinity air cloud storm)))

(ability
  (name "Plant Diagnosis")
  (category "Healthcare")
  (description "A person with the Plant Diagnosis ability can diagnose the condition of non-sentient plants.")
  (restrictions
    (is-species flowercat flower-tiger)))

 (ability
  (name "Plant Knowledge")
  (category "Knowledge")
  (description "A person with the Plant Knowledge ability can tell if plants are edible, poisonous, or medicinal by inspecting them briefly.")
  (restrictions
    (is-species flowercat flower-tiger)))

(ability
  (name "Fruit Sharing")
  (category "Sharing")
  (description "A person with the Fruit Sharing ability can share an ability or its effects with another individual of their choice by giving them an edible, and regenerable part of their body (such as fruits, flowers, etc.). The other individual must eat the given body part to temporarily gain the shared ability or its effects. The user cannot share the Fruit Sharing ability itself.")
  (restrictions
    (is-species fruit-frog)))

(ability
  (name "Small Adaptation")
  (category "Shapeshift")
  (description "A person with the Small Adaptation ability can make small changes to their body shape in order to get an advantage in a given situation.")
  (restrictions
    (is-species gelbeast gelbeast-wild gelbeast-pet)))

(ability
  (name "Translator")
  (category "Language")
  (description "A person with the Translator ability can learn the basis of a language in a few hours and a new language in a few days.")
  (restrictions
    (is-species gelbeast)))

(ability
  (name "Disease Filter")
  (category "Healing")
  (description "A person with the Disease Filter ability can cure diseases and toxines from food to render it edible.")
  (restrictions
    (is-species gelbeast)))

(ability
  ;; Same as above, but with affinity restrictions
  (name "Disease Filter")
  (category "Healing")
  (description "A person with the Disease Filter ability can cure diseases and toxines from food to render it edible.")
  (restrictions
    (has-affinity poison)))

(ability
  (name "Magic Frailty")
  (category "Robustness")
  (description "A person with the Magic Frailty ability is extremely succeptible to magic of any kind.")
  (restrictions
    (is-species gelbeast gelbeast-wild gelbeast-pet)))

(ability
  (name "Blob Body")
  (category "Robustness")
  (description "A person with the Blob Body ability is extremely resiliant to physical injury due to their lack of bones and internal organs.")
  (restrictions
    (is-species gelbeast gelbeast-wild gelbeast-pet)))

(ability
  (name "Instinctal Craft")
  (category "Knowledge")
  (description "A person with the Instinctal Craft ability knows innately how to make an item of a specific kind. The kind of items depends on the species.")
  (restrictions
    (is-species hanged-man)))

(ability
  (name "Light Levitation")
  (category "Telekinesis")
  (description "A person with the Light Levitation ability can levitate small and light items with their mind.")
  (restrictions
    (is-species hanged-man)))

(ability
  ;; Same as above, but with affinity restrictions
  (name "Light Levitation")
  (category "Telekinesis")
  (description "A person with the Light Levitation ability can levitate small and light items with their mind.")
  (restrictions
    (has-affinity psi spirit)))

(ability
  (name "Possession")
  (category "Death")
  (description "A person with the Possession ability can take possession of a dead body and use it as their own body.")
  (restrictions
    (is-species hanged-man)))

(ability
  (name "Amphibious")
  (category "Body Type")
  (description "A person with the Amphibious ability can breathe in air and underwater.")
  (restrictions
    (has-affinity water)))

(ability
  (name "Diamond Skin")
  (category "Robustness")
  (description "A person with the Diamond Skin ability can withstand extreme pressures.")
  (restrictions
    (has-affinity earth crystal)))

(ability
  (name "Watching Session")
  (category "Knowledge")
  (description "A person with the Watching Session ability can acquire knowledge by observing a choosen subject during sessions of several hours. A user retains what they have learnt in a session only if they stay focused during the whole session. The knowledge aquisition process is made quicker if the user is interested in the subject studied.")
  (restrictions
    (is-species masked-owl masked-owl-hybrid)))

(ability
  (name "Knowledge Eater")
  (category "Knowledge")
  (description "A person with the Knowledge Eater ability sustains themselves by learning new things. They do not need to eat food or drink water to survive.")
  (restrictions
    (is-species masked-owl)))

(ability
  (name "Words Everywhere")
  (category "Summoning")
  (description "A person with the Words Everywhere ability can communicate with others by summoning magical glyphs, which float and glow in the air. The glyphs can be understood by any individual, regardless of what languages the individual actually knows. The glyphs remain until the user dismisses them of leave their immediate vicinity.")
  (restrictions
    (is-species moahu)))

(ability
  (name "Artifical Body")
  (category "Body Type")
  (description "A person with the Artifical Body ability does not have a biological body, being built rather than born, and are thus immune to most kinds of poisons, diseases and medicines.")
  (restrictions
    (is-species moahu deadwood)))

(ability
  (name "Body Reclamation")
  (category "Creation")
  (description "A person with the Body Reclamation ability can incorporate bodies of recently deceased into artifacts to create new individuals. The new individual often share behaviours, personality traits, and elemental affinities of the incorporated body.")
  (restrictions
    (is-species moahu)))

(ability
  (name "Fae Speaker")
  (category "Language")
  (description "A person with the Fae Speaker ability can understand Fae and speak it innately.")
  (restrictions
    (is-species
       necropossum deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger
       pygmy-pyzky
       oregagnome cilantroll sorrelf fennelf)))

(ability
  (name "Play Dead")
  (category "Death")
  (description "A person with the Play Dead ability comes back to life after their death as long as their brain remains intact. After their death, they are unable to reproduce and their body needs special upkeep to prevent decomposition.")
  (restrictions
    (is-species
       necropossum deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger)))

(ability
  (name "Play Life")
  (category "Puppeting")
  (description "A person with the Play Life ability can manipulate dead bodies and artificial non-living bodies (like dolls, puppets and mannequins) and order them around.")
  (restrictions
    (is-species
       necropossum deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger)))

(ability
  (name "Venomous")
  (category "Disease")
  (description "A person with the Venomous ability can produce venom and inject it with a specific body part (stings, fangs, claws, ...). The venom effects depends on the species, individuals and affinities.")
  (restrictions
    (is-species
       manticore deathwalker)))

(ability
  (name "Fatal Nightmares Venom")
  (category "Disease")
  (description "A person with the Fatal Nightmares Venom ability produces a deadly venom that affects only sleeping individuals. The venom poisons dreams, becoming nightmares. The targeted individual cannot wake up anymore and the nightmares end when the victims' heart stops.")
  (restrictions
    (is-species
       deathwalker)))

(ability
  (name "Power Ballad")
  (category "Song")
  (description "A person with the Power Ballad ability can shred the soul of other individual by singing and shouting.")
  (restrictions
    (is-species
       bansheep)))

(ability
  (name "No Response")
  (category "Disease")
  (description "A person with the No Response ability produces a nasty venom that poisons and shuts down the immune system. The venom often results in localized diseases and infection around wounds inflicted by the user.")
  (restrictions
    (is-species
       bonefish)))

(ability
  (name "Now You See Him")
  (category "Illusion")
  (description "A person with the Now You See Him ability is really at standing still. The longer theyr stand still, the harder it is to see them, rendering them invisible to others.")
  (restrictions
    (is-species
       shackal)))

(ability
  (name "Spirit Chains")
  (category "Death")
  (description "A person with the Spirit Chains ability can chain souls to an area and seal off spirits.")
  (restrictions
    (is-species
       shackal)))

(ability
  (name "Feral Indifference")
  (category "Nature")
  (description "A person with the Feral Indifference ability are never attacked by feral animals unless they provoke them.")
  (restrictions
    (is-species
       pygmy-pyzky)))

(ability
  (name "Feral Control")
  (category "Nature")
  (description "A person with the Feral Control ability can issue minor commands to small feral animals. Although the animals may ignore the commands, they tend to follow them.")
  (restrictions
    (is-species
       pygmy-pyzky)))

(ability
  (name "Nature Boost")
  (category "Nature")
  (description "A person with the Nature Boost ability makes nature flourish around their living place. An area under the effect of Nature Boost sees plants growing quicker, wild animal presence increasing, weather becoming more docile, and other effects depending on the area and its affinity. The effects are amplified if several persons with the Nature Boost ability are present in the same area.")
  (restrictions
    (is-species
       pygmy-pyzky)))

(ability
  (name "Wind Pacification")
  (category "Weather")
  (description "A person with the Wind Pacification ability can stop wind from hitting anything inside an area. The extent of the protected area depends on the user control on the ability.")
  (restrictions
    (is-species pygmy-pyzky)))

(ability
  ;; Same as above, but with affinity restrictions
  (name "Wind Pacification")
  (category "Weather")
  (description "A person with the Wind Pacification ability can stop wind from hitting anything inside an area. The extent of the protected area depends on the user control on the ability.")
  (restrictions
    (has-affinity storm air)))

(ability
  (name "Flower Colors")
  (category "Shape Changing")
  (description "A person with the Flower Colors ability can change the colors of flowers.")
  (restrictions
    (is-species pygmy-pyzky)))

(ability
  (name "Vegetarian")
  (category "Diet")
  (description "A person with the Vegetarian ability can only eat food made from plants. They get food illness if they eat meat.")
  (restrictions
    (is-species pygmy-pyzky)))

(ability
  (name "Crowd Camo")
  (category "Society")
  (description "A person with the Crowd Camo ability can fit into new groups easily and swiftly. The larger the group, the more seamless the assimilation.")
  (restrictions
    (is-species pygmy-tiger flower-tiger pygmy-bastian swirl-fox atrocitiger)))

(ability
  (name "Leon Speaker")
  (category "Language")
  (description "A person with the Leon Speaker ability can understand Leon and speak it innately.")
  (restrictions
    (is-species
       revealeon surveilleon strawberry-man)))

(ability
  (name "Eye Spy")
  (category "Shape Changing")
  (description "A person with the Eye Spy ability can observe and completely memorize their surrounding environment. They are then able to replay this observation, or memory, in the form of taking on the appearance of anything within it. The memories are not perfect, however, and the forms they take on are flawed in some way. If they do not periodically refresh their memory, their appearance will start to degrade over time.")
  (restrictions
    (is-species
       revealeon surveilleon)))

(ability
  (name "Bad Sleeper")
  (category "Mind Control")
  (description "A person with the Bad Sleeper ability is immune to all forms of hypnosis.")
  (restrictions
    (is-species
       rock-candies flower-candies glam-candies
       fruit-frog flower-frog capricornucopia
       )))

(ability
  (name "Grower")
  (category "Body Shape")
  (description "A person with the Grower ability grows things on their body. The kind of things they grow depends on the species.")
  (restrictions
    (is-species
       rock-candies flower-candies glam-candies
       coralshell-turtle
       satyr satyrqorn satyrfox goatixy diogoat
       )))

(ability
  (name "Electrical Insulation")
  (category "Body Shape")
  (description "A person with the Electrical Insulation ability is immune to all but strong electric currents.")
  (restrictions
    (is-species
       rock-candies flower-candies glam-candies)))

(ability
  (name "Venom Ferment")
  (category "Healing")
  (description "A person with the Venom Ferment ability processes all ingested poison into alcohol.")
  (restrictions
    (is-species
       satyr satyrbun satyrqorn satyrfox flower-candies goatixy diogoat)))

(ability
  (name "Recycle")
  (category "Shape Shifting")
  (description "A person with the Recycle ability is able to insert into their body any item of interest that physically fit. They will then integrate the item into their body, which cause gradual changes in their appearance, affinities and abilities. If they do not consume the required nutrients to allow for continued integration and growth of the item, they will shed it and their appearance will slowly revert to its look pre-integration.")
  (restrictions
    (is-species
       scrapgoat diogoat stripe-goat)))

(ability
  (name "Catalyst Needed")
  (category "Healing")
  (description "A person with the Catalyst Needed ability is unable to physically heal on their own. They need a catalyst of some kind to start and maintain the healing process, degrading the item for this use thereafter. The user is able to tell if a catalyst item can still be used for the healing process.")
  (restrictions
    (is-species
       sea-dragon seavern sea-dragorgon trojan-dragon)))

(ability
  (name "Energy Reader")
  (category "Knowledge")
  (description "A person with the Energy Reader ability can tell how much a crystal contains magic energy.")
  (restrictions
    (has-affinity crystal)))

(ability
  (name "Properties Listener")
  (category "Hearing")
  (description "A person with the Properties Listener ability can discern with the sense of hearing additionnal informations or properties that are inaudible to individual without the Properties Listener ability. The kind of properties heard depends on the individual.")
  (restrictions
    (is-species
       singing-rabbat chirping-rabbat rugarabbat vampire-rabbat satyrbun)))

(ability
  (name "Quality Listener")
  (category "Hearing")
  (description "A person with the Quality Listener ability can discern, with the sense of hearing, if a given item is of good quality.")
  (restrictions
    (is-species
       singing-rabbat chirping-rabbat rugarabbat vampire-rabbat satyrbun)))

(ability
  (name "Value Listener")
  (category "Hearing")
  (description "A person with the Value Listener ability can discern, with the sense of hearing, the value that someone places in an item.")
  (restrictions
    (is-species
       singing-rabbat chirping-rabbat rugarabbat vampire-rabbat satyrbun)))

(ability
  (name "Prophecy Song")
  (category "Prediction")
  (description "A person with the Prophecy Song ability may dream of a song being sung to them. The song is always without lyrics, consisting of just melodies and tones. The song is the form their prophecies take, and they’re always for the individual who sang it to them in the dream. A person with the Prophecy Song ability will usually attempt to seek that individual out and sing the song back to them. If this happens, the two will share a dream detailing the events of the prophecy. If more than one individual hears the song, the prophecy and dream will be shared among all of them.")
  (restrictions
    (is-species
       singing-rabbat chirping-rabbat rugarabbat vampire-rabbat satyrbun)))

(ability
  (name "Weak War")
  (category "Robustness")
  (description "A person with the Weak War ability can render all forms of combat, either physical or magic, during a fight incapable of causing grievous or permanent injury to anyone subjected to them.")
  (restrictions
    (is-species
       turf-tiger thistle-tiger tomb-tiger surf-tiger glam-candies stripe-goat truce-tiger)))

(ability
  (name "Sand Swimmer")
  (category "Moving")
  (description "A person with the Sand Swimmer ability can swim and move in the sand as if it was water.")
  (restrictions
    (is-species sand-hippo)))

(ability
  ;; Same as above, but restricted on affinity
  (name "Sand Swimmer")
  (category "Moving")
  (description "A person with the Sand Swimmer ability can swim and move in the sand as if it was water.")
  (restrictions
    (has-affinity sand)))

(ability
  (name "Hypnotizing Lights")
  (category "Mind Control")
  (description "A person with the Hypnotizing Lights ability can suggest behaviour and practice mind control on other individuals by emitting lights with their bodies.")
  (restrictions
    (is-species nauticorn)))

(ability
  ;; Same as above, but restricted on affinity
  (name "Hypnotizing Lights")
  (category "Mind Control")
  (description "A person with the Hypnotizing Lights ability can suggest behaviour and practice mind control on other individuals by emitting lights with their bodies.")
  (restrictions
    (has-affinity light)))

(ability
  (name "Spicy Cloud")
  (category "Clouds")
  (description "A person with the Spicy Cloud ability can breathe out or emit volatile and spicy oils that cause burns.")
  (restrictions
    (is-species capsicorn)))

(ability
  ;; Same as above, but restricted on affinity
  (name "Spicy Cloud")
  (category "Clouds")
  (description "A person with the Spicy Cloud ability can breathe out or emit volatile and spicy oils that cause burns.")
  (restrictions
    (has-affinity acid)))

(ability
  (name "Astral Projection")
  (category "Consciousness")
  (description "A person with the Astral Projection ability can project their conciousness in spiritual form when they are asleep, and can explore the world around them when dreaming. When they wake up, they can remember their explorations.")
  (restrictions
    (is-species bearring singing-bearrub twinkle-tiger grisly-bearring)))

(ability
  ;; Same as above, but restricted on affinity
  (name "Astral Projection")
  (category "Consciousness")
  (description "A person with the Astral Projection ability can project their conciousness in spiritual form when they are asleep, and can explore the world around them when dreaming. When they wake up, they can remember their explorations.")
  (restrictions
    (has-affinity spirit psi)))
