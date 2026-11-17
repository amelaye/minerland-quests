-- Chapitre 1 — Bienvenue à Minerland (minetest_game). Ids vérifiés : docs/MOD_AUDIT.md § default.
local Q = minerland_quests

Q.register_quest({
	id = "ch01.first_log", title = "Bûcheron du dimanche", difficulty = 1, icon = "default:tree",
	description = "Tout grand voyage commence par un arbre. Choisis-en un beau et donne-lui un petit coup de hache.",
	hint = "Creuse un tronc d'arbre (à la main ou avec une hache). Les troncs posés par un joueur ne comptent pas.",
	trigger = { type = "dig", groups = { "tree" } },
	reward = { items = { "default:apple 3" } },
})
Q.register_quest({
	id = "ch01.planks", title = "Des planches, encore des planches", difficulty = 1, icon = "default:wood",
	description = "Un tronc, c'est bien. Quatre planches, c'est mieux !",
	hint = "Place un tronc dans la grille de fabrication de ton inventaire.",
	trigger = { type = "craft", groups = { "wood" }, count = 4 },
	requires = { "ch01.first_log" },
	reward = { items = { "default:torch 4" } },
})
Q.register_quest({
	id = "ch01.sticks", title = "Bâton de pèlerin", difficulty = 1, icon = "default:stick",
	description = "Le bâton : humble, léger, indispensable à presque tous les outils du royaume.",
	hint = "Deux planches l'une au-dessus de l'autre donnent quatre bâtons.",
	trigger = { type = "craft", items = { "default:stick" } },
	requires = { "ch01.planks" },
	reward = { items = { "default:coal_lump 4" } },
})
Q.register_quest({
	id = "ch01.first_tool", title = "Mon premier outil", difficulty = 1, icon = "default:pick_stone",
	description = "Une pioche, une hache ou une pelle : fabrique-toi de quoi attaquer le monde.",
	hint = "Bâtons + planches ou pavés. La recette s'affiche dans le guide d'Unified Inventory.",
	trigger = { type = "craft", items = { "default:pick_wood", "default:pick_stone", "default:axe_wood",
		"default:axe_stone", "default:shovel_wood", "default:shovel_stone" } },
	requires = { "ch01.sticks" },
	reward = { items = { "default:torch 8" } },
})
Q.register_quest({
	id = "ch01.chest_craft", title = "Un coffre pour mes trésors", difficulty = 1, icon = "default:chest",
	description = "Huit planches en couronne et te voilà propriétaire d'un coffre tout neuf.",
	hint = "Huit planches autour d'une case vide.",
	trigger = { type = "craft", items = { "default:chest" } },
	requires = { "ch01.planks" },
	reward = { items = { "default:paper 3" } },
})
Q.register_quest({
	id = "ch01.chest_place", title = "Chaque chose à sa place", difficulty = 1, icon = "default:chest",
	description = "Un coffre dans le sac ne range rien du tout. Pose-le quelque part !",
	trigger = { type = "place", items = { "default:chest" } },
	requires = { "ch01.chest_craft" },
	reward = { items = { "default:book 1" } },
})
Q.register_quest({
	id = "ch01.furnace", title = "Le feu sacré", difficulty = 1, icon = "default:furnace", final = true,
	description = "Huit pavés et un peu de courage : le fourneau te permettra de cuire, fondre et rêver.",
	hint = "Huit pavés autour d'une case vide, puis pose le fourneau.",
	trigger = { type = "place", items = { "default:furnace" } },
	requires = { "ch01.first_tool", "ch01.chest_place" },
	reward = { items = { "default:steel_ingot 2" }, title = "Apprenti de Minerland" },
})
