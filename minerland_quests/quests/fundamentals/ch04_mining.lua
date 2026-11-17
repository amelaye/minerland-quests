-- Chapitre 4 — Les trésors de la terre (default, moreores, glooptest).
-- « Miner » = creuser le minerai naturel : recevoir un minerai d'un autre joueur ou recreuser un bloc posé
-- ne compte pas (core/events.lua).
local Q = minerland_quests

Q.register_quest({
	id = "ch04.coal", title = "Gueules noires", difficulty = 1, icon = "default:coal_lump",
	description = "Le charbon, c'est la torche de demain. Descends un peu et ouvre l'œil.",
	trigger = { type = "dig", items = { "default:stone_with_coal" }, count = 3 },
	requires = { "ch01.first_tool" },
	reward = { items = { "default:torch 8" } },
})
Q.register_quest({
	id = "ch04.iron", title = "L'âge du fer", difficulty = 2, icon = "default:iron_lump",
	description = "Le fer se cache dans la pierre, souvent un peu plus bas que le charbon.",
	hint = "Il faut au moins une pioche en pierre.",
	trigger = { type = "dig", items = { "default:stone_with_iron" } },
	requires = { "ch04.coal" },
	reward = { items = { "default:coal_lump 8" } },
})
Q.register_quest({
	id = "ch04.copper_tin", title = "Cuivre et étain", difficulty = 2, icon = "default:copper_lump",
	description = "Mélange-les plus tard et tu obtiendras du bronze. Mais d'abord, il faut les trouver !",
	trigger = { type = "dig", items = { "default:stone_with_copper", "default:stone_with_tin" }, count = 2 },
	requires = { "ch04.coal" },
	reward = { items = { "default:steel_ingot 1" } },
})
Q.register_quest({
	id = "ch04.steel_pick", title = "Une pioche qui en jette", difficulty = 2, icon = "default:pick_steel",
	description = "Fonds ton fer, forge une pioche en acier : les profondeurs n'ont qu'à bien se tenir.",
	hint = "Cuis le minerai de fer au fourneau, puis trois lingots et deux bâtons.",
	trigger = { type = "craft", items = { "default:pick_steel", "default:pick_bronze" } },
	requires = { "ch04.iron" },
	reward = { items = { "default:shovel_steel 1" } },
})
Q.register_quest({
	id = "ch04.silver", title = "Reflets d'argent", difficulty = 2, icon = "moreores:silver_lump",
	description = "Plus discret que l'or, l'argent sert aux anneaux et à de jolis outils.",
	trigger = { type = "dig", items = { "moreores:mineral_silver" } },
	requires = { "ch04.iron" }, mods = { "moreores" },
	reward = { items = { "default:copper_ingot 3" } },
})
Q.register_quest({
	id = "ch04.gold_rush", title = "La ruée vers l'or", difficulty = 3, icon = "default:gold_lump",
	description = "Certaines richesses ne demandent qu'à être découvertes. À toi de creuser !",
	hint = "L'or se trouve plus en profondeur que le fer.",
	trigger = { type = "dig", items = { "default:stone_with_gold" } },
	requires = { "ch04.steel_pick" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch04.mese", title = "La pierre qui brille", difficulty = 3, icon = "default:mese_crystal",
	description = "La Mese, cristal jaune et mystérieux, alimente bien des machines de Minerland.",
	trigger = { type = "dig", items = { "default:stone_with_mese" } },
	requires = { "ch04.steel_pick" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch04.gems", title = "Pierres précieuses", difficulty = 3, icon = "glooptest:ruby_gem",
	description = "Rubis, saphirs, émeraudes, topazes et améthystes : les joailliers de Minerland en raffolent.",
	hint = "Ces gemmes servent aussi à fabriquer les anneaux (chapitre 5).",
	trigger = { type = "dig", items = { "glooptest:mineral_ruby", "glooptest:mineral_sapphire",
		"glooptest:mineral_emerald", "glooptest:mineral_topaz", "glooptest:mineral_amethyst" } },
	requires = { "ch04.steel_pick" }, mods = { "glooptest" },
	reward = { items = { "default:gold_lump 2" } },
})
Q.register_quest({
	id = "ch04.diamond", title = "Diamants sur canapé", difficulty = 4, icon = "default:diamond",
	description = "Le diamant : le plus dur, le plus rare, le plus convoité. Il t'attend très bas.",
	trigger = { type = "dig", items = { "default:stone_with_diamond" } },
	requires = { "ch04.gold_rush" },
	reward = { items = { "default:mese_crystal 1" } },
})
Q.register_quest({
	id = "ch04.mithril", title = "Le métal des légendes", difficulty = 5, icon = "moreores:mithril_lump", final = true,
	description = "Tout au fond du monde dort le mithril, le métal des héros. Prépare des torches… beaucoup de torches.",
	hint = "Le mithril n'apparaît qu'à très grande profondeur.",
	trigger = { type = "dig", items = { "moreores:mineral_mithril" } },
	requires = { "ch04.diamond", "ch04.silver" }, mods = { "moreores" },
	reward = { items = { "default:diamond 1" }, title = "Maître mineur" },
})
