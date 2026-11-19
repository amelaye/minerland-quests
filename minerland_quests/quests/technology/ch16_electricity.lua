-- Chapitre 16 — L'électricité pour les nuls (technic). Audit : docs/audit/ch16_ch17.md.
-- La chaîne minimale d'un réseau Technic : câble, four à alliage, carcasse, générateur, câbles posés, poste de
-- commutation, puis une première machine. Une seule petite installation : chaque poste de commutation force le
-- chargement de deux blocs de carte, aucune quête n'en demande plus d'un. « Produire de l'énergie » ou « faire
-- tourner une machine » n'émettent aucun événement (ABM sans joueur) : la quête finale est la pose de la machine.
-- On cible toujours le nom de base des nœuds (jamais les variantes _active obtenues par swap_node).
local Q = minerland_quests

Q.register_quest({
	id = "ch16.copper_cable", title = "Le fil d'Ariane", difficulty = 1, icon = "technic:lv_cable",
	description = "Du cuivre, du papier : voici ton premier câble électrique. Toute l'aventure Technic commence ici.",
	trigger = { type = "craft", items = { "technic:lv_cable" } },
	requires = { "ch04.copper_tin" }, mods = { "technic" },
	reward = { items = { "default:copper_ingot 3" } },
})
Q.register_quest({
	id = "ch16.alloy_kiln", title = "Le four des alchimistes", difficulty = 1, icon = "technic:coal_alloy_furnace",
	description = "Ce four à charbon mélange les métaux : cuivre et zinc y deviennent du laiton.",
	hint = "Huit briques, sans électricité.",
	trigger = { type = "craft", items = { "technic:coal_alloy_furnace" } },
	requires = { "ch16.copper_cable" }, mods = { "technic" },
	reward = { items = { "default:coal_lump 8" } },
})
Q.register_quest({
	id = "ch16.wiring", title = "Tirer des câbles", difficulty = 1, icon = "technic:lv_cable",
	description = "Un réseau, ce sont des câbles bien tirés, de la source jusqu'aux machines.",
	hint = "Pose cinq câbles basse tension à cinq endroits différents.",
	trigger = { type = "place", items = { "technic:lv_cable" }, count = 5 },
	requires = { "ch16.copper_cable" }, mods = { "technic" },
	reward = { items = { "default:copper_ingot 2" } },
})
Q.register_quest({
	id = "ch16.casing", title = "Une carcasse solide", difficulty = 2, icon = "technic:machine_casing",
	description = "Toute machine Technic repose sur une carcasse : de la fonte et un soupçon de laiton.",
	hint = "La fonte s'obtient en recuisant un lingot d'acier au four ; le laiton sort du four à alliage.",
	trigger = { type = "craft", items = { "technic:machine_casing" } },
	requires = { "ch16.alloy_kiln" }, mods = { "technic" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch16.generator", title = "Que la lumière soit !", difficulty = 2, icon = "technic:lv_generator",
	description = "Un générateur à combustible, et ton réseau a enfin du courant à distribuer.",
	trigger = { type = "place", items = { "technic:lv_generator" } },
	requires = { "ch16.casing" }, mods = { "technic" },
	reward = { items = { "default:coal_lump 10" } },
})
Q.register_quest({
	id = "ch16.switching", title = "Le chef d'orchestre", difficulty = 2, icon = "technic:switching_station",
	description = "Le poste de commutation répartit l'énergie entre générateurs et machines. Un seul suffit par réseau.",
	hint = "Il se pose sur un câble du réseau.",
	trigger = { type = "place", items = { "technic:switching_station" } },
	requires = { "ch16.generator", "ch16.wiring" }, mods = { "technic" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch16.first_machine", title = "Ma première machine", difficulty = 2, icon = "technic:lv_electric_furnace",
	final = true,
	description = "Four électrique, broyeur ou compresseur : branche ta première machine sur le réseau et regarde-la "
		.. "travailler.",
	hint = "Le four électrique est le moins cher. Relie-la au réseau par un câble.",
	trigger = { type = "place", items = { "technic:lv_electric_furnace", "technic:lv_alloy_furnace",
		"technic:lv_grinder", "technic:lv_extractor", "technic:lv_compressor" } },
	requires = { "ch16.switching" }, mods = { "technic" },
	reward = { items = { "default:gold_ingot 1" }, title = "Fée électricité" },
})
