-- Structure officielle du Grand Livre : 6 parties, 25 chapitres.
-- Les quêtes sont dans les sous-dossiers (un fichier par chapitre).
local Q = minerland_quests

Q.register_part({ id = "fundamentals", order = 1, numeral = "I", title = "Les Fondamentaux",
	subtitle = "Premiers pas, premier toit, premières richesses", illustration = "mlq_part_fundamentals.png" })
Q.register_part({ id = "daily_life", order = 2, numeral = "II", title = "La Vie quotidienne",
	subtitle = "Animaux, cuisine, décoration et commerce", illustration = "mlq_part_daily_life.png" })
Q.register_part({ id = "transport", order = 3, numeral = "III", title = "Les Transports",
	subtitle = "Routes, rails, ciel, mers et hauteurs", illustration = "mlq_part_transport.png" })
Q.register_part({ id = "technology", order = 4, numeral = "IV", title = "Sciences et Technologies",
	subtitle = "Électricité, industrie et automatisation", illustration = "mlq_part_technology.png" })
Q.register_part({ id = "exploration", order = 5, numeral = "V", title = "L'Aventure",
	subtitle = "Mondes extraordinaires et créatures fabuleuses", illustration = "mlq_part_exploration.png" })
Q.register_part({ id = "building", order = 6, numeral = "VI", title = "Les Grands Projets",
	subtitle = "Bâtisseurs et fondateurs de cités", illustration = "mlq_part_building.png" })

local function ch(id, part, title, icon, intro)
	Q.register_chapter({ id = id, part = part, title = title, icon = icon, intro = intro })
end

-- PARTIE I
ch("ch01", "fundamentals", "Bienvenue à Minerland", "default:tree",
	"Bienvenue, voyageur ! Avant de bâtir des cathédrales et des trains, il faut savoir manier la hache. "
	.. "Ce chapitre t'apprend les gestes de base : couper, fabriquer, ranger.")
ch("ch02", "fundamentals", "Mon premier chez-moi", "default:chest",
	"Un toit, une porte, un lit et une lampe : voilà de quoi se sentir chez soi. Et n'oublie pas de protéger ton "
	.. "terrain, la Reine y tient !")
ch("ch03", "fundamentals", "Les joies de l'agriculture", "farming:wheat",
	"La faim est désactivée à Minerland, mais rien ne vaut un potager bien tenu. Bêche, sème, récolte… "
	.. "et transforme tes récoltes en bons produits.")
ch("ch04", "fundamentals", "Les trésors de la terre", "default:pick_steel",
	"Sous tes pieds dorment le fer, l'or, le diamant et la mystérieuse Mese. Prends ta pioche et descends : "
	.. "certaines richesses ne demandent qu'à être découvertes.")
ch("ch05", "fundamentals", "Les anneaux du ciel", "goops_rings:celestial_ring1",
	"Goops a forgé des anneaux merveilleux : voler, résister au feu, respirer sous l'eau, briller… Un anneau se "
	.. "porte comme une armure ; c'est l'Anneau d'activation, tenu en main, qui le réveille pour un temps limité.")

-- PARTIE II
ch("ch06", "daily_life", "La ferme aux animaux", "mobs:lasso",
	"Vaches, moutons, poules et chevaux n'attendent que ton affection. Apprends à les attirer, à les soigner "
	.. "et à profiter de leurs bienfaits — avec amour, toujours.")
ch("ch07", "daily_life", "Les petits plats dans les grands", "farming:bread",
	"Ici, on ne cuisine pas pour survivre, mais pour le plaisir ! Barbecue, conserves, jus de fruits et grands crus : "
	.. "à toi les recettes de Minerland.")
ch("ch08", "daily_life", "L'art de la décoration", "moreblocks:circular_saw",
	"Une maison sans meubles, c'est une grotte avec une porte. Scies, tables, lampes et coussins : "
	.. "fais de ton foyer le plus douillet du royaume.")
ch("ch09", "daily_life", "Les affaires sont les affaires", "currency:minegeld",
	"Le Minegeld fait tourner le royaume. Ouvre boutique, propose tes marchandises et découvre les rouages "
	.. "de l'économie de Minerland.")

-- PARTIE III
ch("ch10", "transport", "Sur les chapeaux de roues !", "bike:bike",
	"À bicyclette, en 4L ou en DeLorean : la route est à toi ! Du vélo au carburant vert, apprends à rouler "
	.. "avec style.")
ch("ch11", "transport", "Le monde ferroviaire", "advtrains:dtrack_placer",
	"Les rails font la fierté de Minerland. Avant de bâtir une ligne (avec l'accord de l'administration et les "
	.. "conseils du Grand Maître des trains), apprends à fabriquer voies, signaux et matériel roulant.")
ch("ch12", "transport", "Métros et tramways", nil,
	"Le transport urbain a ses codes : quais, signalétique, tramways qui serpentent entre les maisons. "
	.. "Dessine les stations de demain.")
ch("ch13", "transport", "Les fous volants", nil,
	"Minerland est une terre d'aviateurs ! Deltaplane, Super Cub, PA-28, Ju 52 ou hydravion : fabrique ton "
	.. "appareil… et demande à Luffy de te faire passer ton brevet.")
ch("ch14", "transport", "Larguez les amarres !", nil,
	"Mers, lacs et rivières n'attendent que ta proue. Bateau à moteur, chalutier ou sous-marin Nautilus : "
	.. "hissez haut !")
ch("ch15", "transport", "Prenons de la hauteur !", nil,
	"Télésièges, ascenseurs réalistes et cabines de téléportation : grimper n'a jamais été aussi confortable. "
	.. "Les tutoriels de l'Académie t'attendent.")

-- PARTIE IV
ch("ch16", "technology", "L'électricité pour les nuls", "technic:lv_cable",
	"Un générateur, quelques câbles et hop : la lumière fut ! Premiers pas dans Technic, en toute sécurité.")
ch("ch17", "technology", "La révolution industrielle", "technic:mv_cable",
	"Broyer, fondre, allier, stocker : tes minerais valent bien plus une fois traités. Bienvenue dans "
	.. "l'industrie lourde de Minerland.")
ch("ch18", "technology", "L'ère de Techage", nil,
	"Techage raconte l'histoire de la technique, âge après âge : du charbon de bois aux énergies du futur. "
	.. "Un parcours à part, avec ses propres machines.")
ch("ch19", "technology", "Les machines intelligentes", nil,
	"Circuits, câbles de données, tubes pneumatiques et foreuses géantes : quand tes machines se mettent à "
	.. "penser (presque) toutes seules.")

-- PARTIE V
ch("ch20", "exploration", "Les portes de l'Enfer", nil,
	"Derrière un cadre d'obsidienne s'ouvre un monde de feu. Allume le portail, récolte ses étranges matériaux "
	.. "et forge des objets venus d'ailleurs.")
ch("ch21", "exploration", "Au plus profond de Minerland", nil,
	"Cristaux luminescents, géodes et champignons géants : les profondeurs cachent des merveilles… "
	.. "et quelques trésors oubliés.")
ch("ch22", "exploration", "Dragons et autres bestioles", nil,
	"Des dragons dorment dans les cavernes ! Découvre leurs secrets, leurs écailles et les objets qui "
	.. "permettent de vivre à leurs côtés.")
ch("ch23", "exploration", "Les mystères du passé", nil,
	"Fossiles, ADN et laboratoires : la science de Minerland ressuscite les créatures d'antan. "
	.. "À toi de jouer les paléontologues.")

-- PARTIE VI
ch("ch24", "building", "Les grands bâtisseurs", nil,
	"Échafaudages, façades, arches et portes ouvragées : les grands chantiers demandent de grands outils. "
	.. "Prépare-toi à bâtir des merveilles.")
ch("ch25", "building", "Monsieur ou Madame le Maire", "minerland_quests:city_charter",
	"Fonder une ville, c'est un rêve et beaucoup de travail. Scelle ta charte, trace les rues, installe "
	.. "la signalisation et les commerces. (La Reine valide toujours les grands projets !)")
