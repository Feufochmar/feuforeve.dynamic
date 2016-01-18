;; Abilities derived from the descriptions on the species sheets
(ability
  (name "Cold Tolerance")
  (category "Thermodynamics")
  (description "A person with the Cold Tolerance ability can live in very cold environments without the need of protecting themselves from the low temperatures.")
  (restrictions
    (is-species aurorian-fox cagroodle)))

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


;;;;
(ability
  (name "Fae Speaker")
  (category "Language")
  (description "A person with the Fae Speaker ability can understand Fae and speak it innately.")
  (restrictions
    (is-species
       pygmy-pyzky
       necropossum deathwalker bansheep bonefish nekopossum vampire-rabbat shackal tomb-tiger
       oregagnome cilantroll sorrelf fennelf)))

(ability
  (name "Plant Speaker")
  (category "Language")
  (description "A person with the Plant Speaker ability can understand and talk to any kind of plant innately.")
  (restrictions
    (is-species
       flowercat)))
