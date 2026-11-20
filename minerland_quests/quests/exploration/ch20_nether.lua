-- Chapitre 20 — Les portes de l'Enfer (nether, variante minetest-mods). Audit : docs/audit/ch20_ch21.md.
-- Choix de l'administratrice : le chapitre est centré sur la CONSTRUCTION et l'ALLUMAGE du portail. Aucune quête
-- ne repose sur une altitude ou une coordonnée : l'arrivée se prouve en creusant la roche du Nether, qui n'existe
-- que là-bas. L'allumage (fragment de cristal de Mese posé sur le cadre d'obsidienne, consommé seulement en cas de
-- réussite) est détecté par integrations/nether.lua et fonctionne avec les deux variantes du mod.
local Q = minerland_quests

Q.register_quest({
	id = "ch20.obsidian", title = "Le verre des volcans", difficulty = 2, icon = "default:obsidian",
	description = "Là où la lave rencontre l'eau naît l'obsidienne, noire et brillante. Il en faudra pour le portail.",
	hint = "Verse de l'eau sur de la lave immobile, puis creuse l'obsidienne avec une pioche en acier ou mieux.",
	trigger = { type = "dig", items = { "default:obsidian" }, count = 4 },
	requires = { "ch04.steel_pick" },
	reward = { items = { "bucket:bucket_empty 1" } },
})
Q.register_quest({
	id = "ch20.mese_fragments", title = "Éclats de Mese", difficulty = 2, icon = "default:mese_crystal_fragment",
	description = "Un cristal de Mese se brise en neuf éclats. L'un d'eux suffira à réveiller le portail.",
	hint = "Un cristal de Mese seul dans la grille.",
	trigger = { type = "craft", items = { "default:mese_crystal_fragment" } },
	requires = { "ch04.mese" },
	reward = { items = { "default:obsidian 2" } },
})
Q.register_quest({
	id = "ch20.frame", title = "Un cadre d'obsidienne", difficulty = 2, icon = "default:obsidian",
	description = "Quatre blocs de large, cinq de haut, l'intérieur vide : le cadre du portail se dresse.",
	hint = "Pose au moins dix blocs d'obsidienne à des endroits différents ; les coins du cadre sont facultatifs.",
	trigger = { type = "place", items = { "default:obsidian" }, count = 10 },
	requires = { "ch20.obsidian" },
	reward = { items = { "default:mese_crystal_fragment 2" } },
})
Q.register_quest({
	id = "ch20.light_portal", title = "Une étincelle de Mese", difficulty = 3, icon = "default:mese_crystal_fragment",
	description = "Un éclat de Mese contre l'obsidienne, et le vortex violet s'éveille… Le passage est ouvert !",
	objective = "Allumer un portail du Nether.",
	hint = "Clic droit sur le cadre avec un fragment de cristal de Mese (pas un cristal entier). Le fragment n'est "
		.. "consommé que si le portail s'allume.",
	trigger = { type = "custom", key = "nether:portal_lit" },
	requires = { "ch20.frame", "ch20.mese_fragments" }, mods = { "nether" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch20.first_rack", title = "Premiers pas en enfer", difficulty = 3, icon = "nether:rack", final = true,
	description = "Tu as franchi le portail ! Rapporte un morceau de cette roche rouge que l'on ne trouve que dans le "
		.. "Nether.",
	hint = "La roche du Nether se creuse avec n'importe quelle pioche.",
	trigger = { type = "dig", items = { "nether:rack" } },
	requires = { "ch20.light_portal" }, mods = { "nether" },
	reward = { items = { "default:gold_ingot 2" }, title = "Cœur de braise" },
})
