(ages-of-life
  (infant
    (description "infant")
    (can-have-pet? #f)
    (max-nb-partners 0)
    (max-children-by-partner 0)
    (professions
      (from-other-ages )))
  (child
    (description "child")
    (can-have-pet? #t)
    (max-nb-partners 0)
    (max-children-by-partner 0)
    (professions
      (from-other-ages )))
  (adolescent
    (description "adolescent")
    (can-have-pet? #t)
    (max-nb-partners 0)
    (max-children-by-partner 0)
    (professions
      (from-other-ages )
      "apprentice" "student"))
  (young-adult
    (description "young adult")
    (can-have-pet? #t)
    (max-nb-partners 2)
    (max-children-by-partner 2)
    (professions
      (from-other-ages adolescent)
      "accountant" "acoustician" "actor" "ambulance driver" "animal trainer" "archivist" "armourer" "assassin"
      "assistant" "athlete" "bailiff" "baker" "barber" "barkeeper" "bartender" "basket maker" "blackmailer"
      "blacksmith" "bladesmith" "bodyguard" "bookbinder" "bookkeeper" "bookseller" "bootlegger" "bounty hunter"
      "brewer" "building worker" "burglar" "butcher" "butler" "cabinetmaker" "cameraman" "caretaker" "carpenter"
      "carriage driver" "cartoonist" "ceramist" "chariot racer" "checkout operator" "cheesemaker" "chef"
      "chocolatier" "city guard" "cleaner" "clerk" "clocksmith" "commercial artist" "composer" "conductor"
      "confectioner" "cook" "cooper" "coppersmith" "counterfeiter" "court clerk" "crane driver" "crooner"
      "customs official" "cutler" "dancer" "decorator" "doorkeeper" "dressmaker" "driver" "drug dealer" "dyer"
      "electrician" "embroiderer" "engraver" "excavator driver" "explorer" "farmer" "farrier" "filing clerk"
      "film editor" "firefighter" "first aider" "fisherman" "fishing guard" "fishmonger" "fitter" "fletcher"
      "florist" "footman" "forest ranger" "forger" "fundraiser" "furrier" "gardener" "gladiator" "glass-blower"
      "glazier" "glover" "goldsmith" "guard" "guide" "gunsmith" "hacker" "hatter" "healer" "hijacker" "hitman"
      "homeless person" "homemaker" "horticulturist" "hotelier" "housebreaker" "housewrecker" "illustrator"
      "innkeeper" "ironsmith" "jester" "jeweller" "journalist" "laboratory technician" "lacemaker" "leather worker"
      "legionnaire" "librarian" "lifeguard" "livestock farmer" "locksmith" "logger" "logistician" "lumberjack"
      "machine-operator" "mason" "master of ceremonies" "mechanic" "mercenary" "merchant" "messenger" "militiaman"
      "milliner" "miner" "model maker" "monitor" "monk" "musical instrument maker" "musician" "nurse" "nurseryman"
      "organiser" "painter" "papermaker" "pastry chef" "peace officier" "performer" "pharmaceutical assistant"
      "photographer" "pickpocket" "pirate" "plumber" "police officer" "porter" "potter" "priest" "prisoner"
      "professor" "proofreader" "prostitute" "puppeteer" "real estate agent" "receiver of stolen goods"
      "receptionist" "referee" "reporter" "rescue worker" "restaurateur" "rifleman" "roofer" "ropemaker" "saddler"
      "sailor" "salesman" "satirist" "sculptor" "secretary" "seller" "servant" "shipwright" "shoemaker" "shopkeeper"
      "silversmith" "singer" "slave" "slave trader" "smuggler" "soldier" "sommelier" "sportsman" "spy"
      "stallholder" "stone carver" "stonemason" "storekeeper" "stuffer" "sweet maker" "tailor" "tanner"
      "tapestry weaver" "teaching assistant" "technician" "thatcher" "thief" "tile setter" "toymaker" "trapper"
      "tutor" "undertaker" "unemployed person" "waiter" "warden" "weaver" "wheelwright" "wigmaker" "wine-grower"
      "wine-maker" "wood carver" "worker" "writer"))
  (adult
    (description "adult")
    (can-have-pet? #t)
    (max-nb-partners 4)
    (max-children-by-partner 3)
    (professions
      (from-other-ages young-adult)
      "actuary" "adjudicator" "adviser" "anaesthetist" "analyst" "arbitrator" "archeologist" "architect"
      "auctioneer" "auditor" "banker" "bargainer" "biologist" "broker" "bursar" "buyer" "chemist" "cinematographer"
      "client service manager" "coach" "costume designer" "demographer" "dentist" "designer" "detective"
      "development director" "diplomat" "doctor" "editor-in-chief" "engineer" "expert" "fashion designer"
      "film director" "forecaster" "geographer" "geologist" "graphic designer" "historian" "industrial designer"
      "inspector" "insurer" "intendant" "interpreter" "inventor" "judge" "landscaper" "land surveyor" "lawyer"
      "lecturer" "legal expert" "magistrate" "maître d'" "majordomo" "manager" "mapmaker" "marketing manager"
      "mathematician" "mediator" "midwife" "necromancer" "negotiator" "non-commissioned officer" "oenologist"
      "officer" "ophthalmologist" "optician" "osteopath" "perfumer" "personnel director" "pharmacist" "philosopher"
      "physicist" "physiotherapist" "pilot" "potioneer" "presenter" "press agent" "producer" "production manager"
      "programmer" "project manager" "prophet" "prosecutor" "psychiatrist" "psychologist" "quartermaster"
      "real estate manager" "recruitment manager" "representative" "researcher" "restorer" "sales manager"
      "shipowner" "sociologist" "specialist" "speech therapist" "sportscaster" "steward" "study director"
      "superintendant" "surgeon" "task-force director" "tax assessor" "taxman" "tax specialist" "teacher"
      "town-planner" "trader" "trainer" "translator" "treasurer" "valuer" "vet" "weapons instructor" "wizard"))
  (mature-adult
    (description "mature adult")
    (can-have-pet? #t)
    (max-nb-partners 6)
    (max-children-by-partner 5)
    (professions
      (from-other-ages young-adult adult)
      "diviner" "godfather" "seer"))
  (elder
    (description "elder")
    (can-have-pet? #t)
    (max-nb-partners 8)
    (max-children-by-partner 7)
    (professions
      (from-other-ages young-adult adult mature-adult)
      "pensioner" "retired person" "sage"))
  (ageless-adult
    (description "ageless adult")
    (can-have-pet? #t)
    (max-nb-partners 50)
    (max-children-by-partner 3)
    (professions
      (from-other-ages young-adult adult mature-adult)))
)
