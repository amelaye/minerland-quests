-- Chapitre 8 — L'art de la décoration (xdecor, homedecor_modpack, moreblocks, signs_lib).
-- Audit : docs/audit/ch07_ch08.md.
-- Détectable : pose des nœuds simples (xdecor, homedecor sans multi-blocs, moreblocks) et fabrication en grille.
-- Non détectable : meubles homedecor multi-blocs (lit, piano…) posés par set_node, texte d'un panneau, découpe à la
-- scie circulaire (table de travail personnalisée) → non retenus.
local Q = minerland_quests

Q.register_quest({
	id = "ch08.workbench", title = "L'atelier du décorateur", difficulty = 1, icon = "xdecor:workbench",
	description = "Tout décorateur commence par un établi. C'est là que naissent chaises, tables et lanternes.",
	hint = "Quatre planches de bois.",
	trigger = { type = "craft", items = { "xdecor:workbench" } },
	requires = { "ch01.planks" }, mods = { "xdecor" },
	reward = { items = { "default:wood 16" } },
})
Q.register_quest({
	id = "ch08.saw", title = "Menuisier de précision", difficulty = 2, icon = "moreblocks:circular_saw",
	description = "La scie circulaire taille marches, dalles et moulures dans presque tous les matériaux.",
	hint = "De l'acier et du bois.",
	trigger = { type = "craft", items = { "moreblocks:circular_saw" } },
	requires = { "ch01.planks" }, mods = { "moreblocks" },
	reward = { items = { "default:tree 6" } },
})
Q.register_quest({
	id = "ch08.light", title = "Une lueur chaleureuse", difficulty = 1, icon = "xdecor:lantern",
	description = "Une lanterne, une bougie ou une lampe à huile : la lumière douce fait tout le charme d'une maison.",
	trigger = { type = "place", items = { "xdecor:lantern", "xdecor:lantern_hanging", "xdecor:candle",
		"homedecor:candle", "homedecor:oil_lamp", "homedecor:oil_lamp_tabletop" } },
	requires = { "ch08.workbench" },
	reward = { items = { "default:glass 6" } },
})
Q.register_quest({
	id = "ch08.seat", title = "Une chaise pour souffler", difficulty = 1, icon = "xdecor:chair",
	description = "Après une longue journée de travail, rien ne vaut un bon siège.",
	trigger = { type = "place", items = { "xdecor:chair", "xdecor:cushion", "homedecor:kitchen_chair_wood",
		"homedecor:armchair" } },
	requires = { "ch08.workbench" },
	reward = { items = { "wool:white 4" } },
})
Q.register_quest({
	id = "ch08.table", title = "Mettre la table", difficulty = 1, icon = "xdecor:table",
	description = "Une table solide, et voilà le cœur de la maison : repas, jeux et grandes discussions.",
	hint = "Trois dalles de bois et deux bâtons.",
	trigger = { type = "place", items = { "xdecor:table" } },
	requires = { "ch08.workbench" }, mods = { "xdecor" },
	reward = { items = { "vessels:drinking_glass 2" } },
})
Q.register_quest({
	id = "ch08.stairs", title = "Monter d'un étage", difficulty = 1, icon = "moreblocks:stair_wood",
	description = "Une maison de caractère a un étage, et un étage a besoin d'un escalier.",
	hint = "Six planches en escalier dans la grille donnent huit marches.",
	trigger = { type = "craft", items = { "moreblocks:stair_wood" } },
	requires = { "ch08.saw" }, mods = { "moreblocks" },
	reward = { items = { "default:sign_wall_wood 2" } },
})
Q.register_quest({
	id = "ch08.window", title = "Une vue imprenable", difficulty = 2, icon = "xdecor:woodframed_glass",
	description = "De belles fenêtres à croisillons laissent entrer le soleil… et la curiosité des voisins.",
	trigger = { type = "place", items = { "xdecor:woodframed_glass", "homedecor:window_quartered" } },
	requires = { "ch08.light" },
	reward = { items = { "dye:blue 2", "dye:red 2" } },
})
Q.register_quest({
	id = "ch08.textiles", title = "Tapis et rideaux", difficulty = 2, icon = "homedecor:rug_persian",
	description = "Un tapis moelleux, des rideaux colorés : le confort se niche dans les détails.",
	hint = "Il faut de la laine, parfois teinte.",
	trigger = { type = "place", items = { "homedecor:rug_small", "homedecor:rug_persian", "homedecor:rug_large",
		"homedecor:curtain_open", "xdecor:curtain_red" } },
	requires = { "ch08.seat" },
	reward = { items = { "default:paper 4" } },
})
Q.register_quest({
	id = "ch08.painting", title = "Une touche d'art", difficulty = 2, icon = "xdecor:painting_1", final = true,
	description = "Un tableau au mur, et ta maison devient une demeure. Le sujet est une surprise à chaque pose !",
	hint = "Le tableau se fabrique avec des bâtons et du papier.",
	trigger = { type = "place", items = { "xdecor:painting_1", "xdecor:painting_2", "xdecor:painting_3",
		"xdecor:painting_4" } },
	requires = { "ch08.window", "ch08.textiles", "ch08.table" }, mods = { "xdecor" },
	reward = { items = { "default:gold_ingot 1" }, title = "Âme d'artiste" },
})
