-- Chapitre 22 — Dragons et autres bestioles (draconis). Audit : docs/audit/ch22_ch23.md.
-- Sur Minerland, les cavernes à dragons sont actives (réglage cavern_spawning) : parois calcinées ou gelées, tas d'os
-- et magots y sont générés. Choix de l'administratrice : abattre un dragon et ramasser son butin valide la quête
-- (integrations/draconis.lua : écailles, œuf). Ces deux quêtes n'ont aucun prérequis : un butin ramassé avant
-- l'ouverture de la quête ne compterait pas, et l'œuf est rare. Tout ce qui est creusé doit être naturel. La
-- wyverne de la jungle se monte sauvage (integrations/rides.lua). Écartés (aucun événement) : bestiaire, acier
-- draconique, monture de dragon.
local Q = minerland_quests

Q.register_quest({
	id = "ch22.bone_pile", title = "Un tas d'os bien suspect", difficulty = 3, icon = "draconis:bone_pile_scorched",
	description = "Des os entassés au fond d'une caverne… Quelque chose de très gros vit par ici. Prudence !",
	hint = "Les cavernes à dragons sont profondes ; leurs parois sont calcinées ou couvertes de givre.",
	trigger = { type = "dig", items = { "draconis:bone_pile_scorched", "draconis:bone_pile_frozen" } },
	requires = { "ch04.steel_pick" }, mods = { "draconis" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch22.scorched_stone", title = "La roche a pris un coup de chaud", difficulty = 3,
	icon = "draconis:stone_scorched",
	description = "Le souffle d'un dragon a cuit la pierre de sa caverne. Rapportes-en un morceau, si tu l'oses.",
	hint = "Cette pierre est très dure : il faut une pioche en Mese ou en diamant.",
	trigger = { type = "dig", items = { "draconis:stone_scorched", "draconis:stone_frozen" } },
	requires = { "ch22.bone_pile" }, mods = { "draconis" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch22.dragon_hoard", title = "Le magot du dragon", difficulty = 4, icon = "default:goldblock",
	description = "Les dragons dorment sur des trésors : blocs d'or chez ceux du feu, blocs d'acier chez ceux de la "
		.. "glace. Emprunte-leur un bloc… sans les réveiller.",
	hint = "Seuls les blocs générés dans une caverne comptent, pas ceux posés par des joueurs.",
	trigger = { type = "dig", items = { "default:goldblock", "default:steelblock" } },
	requires = { "ch22.bone_pile" }, mods = { "draconis" },
	reward = { items = { "default:torch 12" } },
})
Q.register_quest({
	id = "ch22.scorched_bricks", title = "Maçon des cendres", difficulty = 2, icon = "draconis:stone_bricks_scorched",
	description = "Taillée en briques, la pierre des dragons fait des murs d'une beauté sombre et inquiétante.",
	hint = "Quatre pierres calcinées ou gelées donnent quatre briques.",
	trigger = { type = "craft", items = { "draconis:stone_bricks_scorched", "draconis:stone_bricks_frozen" } },
	requires = { "ch22.scorched_stone" }, mods = { "draconis" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch22.wyvern_ride", title = "Rodéo dans la canopée", difficulty = 4, icon = "default:jungleleaves",
	description = "La wyverne de la jungle est rare et ombrageuse. Grimpe sur son dos… et accroche-toi !",
	objective = "Monter sur une wyverne de la jungle.",
	hint = "Main vide, clic droit sur une wyverne. Elle n'apprécie pas toujours, garde de quoi te soigner.",
	trigger = { type = "custom", key = "rides:wyvern" },
	mods = { "draconis" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch22.draconic_forge", title = "La forge des dragons", difficulty = 3, icon = "draconis:draconic_forge_fire",
	description = "Huit pierres de caverne et un fourneau : voici la forge que seuls les dragons savent allumer. "
		.. "Un trophée pour ton atelier !",
	hint = "La forge ne fonctionne qu'avec le souffle d'un dragon apprivoisé : ici, elle est surtout décorative.",
	trigger = { type = "place", items = { "draconis:draconic_forge_fire", "draconis:draconic_forge_ice" } },
	requires = { "ch22.scorched_bricks" }, mods = { "draconis" },
	reward = { items = { "default:gold_ingot 2" }, title = "Souffle de dragon" },
})
Q.register_quest({
	id = "ch22.dragon_scales", title = "Écailles de dragon", difficulty = 4, icon = "draconis:scales_fire_dragon_red",
	description = "Affronte un dragon des cavernes et rapporte ses écailles : un trophée que peu de bâtisseurs peuvent "
		.. "exhiber. Prépare une bonne armure et de quoi te soigner !",
	objective = "Abattre un dragon et ramasser ses écailles.",
	hint = "Fais plusieurs clics droits sur le dragon vaincu pour faire tomber son butin, puis ramasse "
		.. "les écailles. Un objet donné par un autre joueur ne compte pas.",
	trigger = { type = "custom", key = "draconis:scales_pickup" },
	mods = { "draconis" },
	reward = { items = { "default:gold_ingot 2" } },
})
Q.register_quest({
	id = "ch22.dragon_egg", title = "L'œuf du dragon", difficulty = 5, icon = "draconis:egg_fire_red", final = true,
	description = "Un dragon sauvage adulte garde parfois un œuf. Vaincre le gardien et rapporter son œuf : l'exploit "
		.. "suprême des cavernes de Minerland.",
	objective = "Abattre un dragon sauvage adulte et ramasser son œuf.",
	hint = "Seul un dragon sauvage adulte laisse un œuf, une fois sur six, avec le reste de son butin "
		.. "(clics droits sur le dragon vaincu). Un œuf donné par un autre joueur ne compte pas.",
	trigger = { type = "custom", key = "draconis:egg_pickup" },
	mods = { "draconis" },
	reward = { items = { "default:diamond 1" }, title = "Fléau des dragons" },
})
