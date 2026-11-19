-- Chapitre 17 — La révolution industrielle (technic). Audit : docs/audit/ch16_ch17.md.
-- Du minerai à l'atelier : minerais propres à Technic, stockage, broyage, passage à la moyenne tension (inox, donc
-- chrome profond). Une machine de chaque sorte, jamais en série. Les produits des machines (poudres, alliages,
-- plaques) ne passent pas par la grille : non détectables. Carrière et réacteur nucléaire écartés (charge serveur,
-- coût). Chapitre indépendant du 16 (seuls les fondamentaux sont requis).
local Q = minerland_quests

Q.register_quest({
	id = "ch17.zinc", title = "Le zinc, cet inconnu", difficulty = 2, icon = "technic:zinc_lump",
	description = "Le zinc, mêlé au cuivre, donne le laiton des machines. On le trouve sous la surface.",
	trigger = { type = "dig", items = { "technic:mineral_zinc" }, count = 3 },
	requires = { "ch04.copper_tin" }, mods = { "technic" },
	reward = { items = { "default:copper_ingot 4" } },
})
Q.register_quest({
	id = "ch17.iron_chest", title = "Un coffre de ferrailleur", difficulty = 2, icon = "technic:iron_chest",
	description = "Un coffre bardé de fonte : plus grand, plus solide, idéal pour l'atelier.",
	hint = "Un coffre et huit lingots de fonte.",
	trigger = { type = "craft", items = { "technic:iron_chest", "technic:iron_locked_chest" } },
	requires = { "ch04.iron" }, mods = { "technic" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch17.chromium", title = "Chrome et paillettes", difficulty = 3, icon = "technic:mineral_chromium",
	description = "Le chrome ne se trouve qu'en profondeur. Avec lui, l'acier devient inoxydable.",
	hint = "Cherche sous la profondeur 100.",
	trigger = { type = "dig", items = { "technic:mineral_chromium" } },
	requires = { "ch04.iron" }, mods = { "technic" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch17.battery_box", title = "Mettre l'énergie en boîte", difficulty = 3, icon = "technic:lv_battery_box0",
	description = "Une boîte à batteries stocke le surplus d'énergie pour les heures creuses.",
	hint = "Quatre batteries, une carcasse de machine et un câble.",
	trigger = { type = "place", items = { "technic:lv_battery_box0" } },
	requires = { "ch17.zinc" }, mods = { "technic" },
	reward = { items = { "default:tin_ingot 3" } },
})
Q.register_quest({
	id = "ch17.grinder", title = "Moulin à minerai", difficulty = 3, icon = "technic:lv_grinder",
	description = "Le broyeur réduit le minerai en poudre : chaque pépite rapporte alors deux lingots.",
	hint = "Il demande un diamant et du granite (très en profondeur).",
	trigger = { type = "place", items = { "technic:lv_grinder" } },
	requires = { "ch17.zinc" }, mods = { "technic" },
	reward = { items = { "default:iron_lump 6" } },
})
Q.register_quest({
	id = "ch17.mv_cable", title = "Monter en tension", difficulty = 3, icon = "technic:mv_cable",
	description = "La moyenne tension ouvre la voie aux grandes machines. Il te faut un câble MV ou un transformateur.",
	trigger = { type = "craft", items = { "technic:mv_transformer", "technic:mv_cable" } },
	requires = { "ch17.chromium" }, mods = { "technic" },
	reward = { items = { "default:copper_ingot 4" } },
})
Q.register_quest({
	id = "ch17.mv_machine", title = "L'usine moyenne tension", difficulty = 4, icon = "technic:mv_electric_furnace",
	description = "Une machine moyenne tension travaille plus vite et mieux. Ton atelier devient une usine.",
	hint = "Une machine basse tension, quatre lingots d'inox et un transformateur MV.",
	trigger = { type = "place", items = { "technic:mv_electric_furnace", "technic:mv_grinder",
		"technic:mv_alloy_furnace", "technic:mv_extractor", "technic:mv_compressor" } },
	requires = { "ch17.mv_cable" }, mods = { "technic" },
	reward = { items = { "default:gold_ingot 2" } },
})
Q.register_quest({
	id = "ch17.workshop", title = "L'atelier du réparateur", difficulty = 4, icon = "technic:tool_workshop", final = true,
	description = "L'atelier répare outils et armures usés grâce à l'électricité. Le sommet de l'industrie !",
	hint = "Diamant, obsidienne, tissu de carbone et piston collant.",
	trigger = { type = "place", items = { "technic:tool_workshop" } },
	requires = { "ch17.mv_machine", "ch17.grinder", "ch17.battery_box" }, mods = { "technic" },
	reward = { items = { "default:gold_ingot 2" }, title = "Capitaine d'industrie" },
})
