-- Chapitre 21 — Au plus profond de Minerland (caverealms_lite « caverealms », amethyst_new, lootchests_modpack).
-- Audit : docs/audit/ch20_ch21.md. Biomes souterrains entre −1500 et −5000 environ. Tout est naturel (« dig ») :
-- un bloc posé par un joueur puis recreusé ne compte pas. Un coffre au trésor ne se démonte qu'une fois vide ;
-- l'ouvrir n'est pas détectable. Géodes générées par geodes_lib (non audité) : à vérifier en jeu.
local Q = minerland_quests

Q.register_quest({
	id = "ch21.glow_gems", title = "Lueurs dans la mousse", difficulty = 2, icon = "caverealms:glow_gem",
	description = "Dans les grandes cavernes moussues brillent de petites gemmes bleutées. Cueille-en une !",
	hint = "On les trouve dans les cavernes très profondes, sur la mousse. Elles se cassent à la main.",
	trigger = { type = "dig", items = { "caverealms:glow_gem" } },
	requires = { "ch04.steel_pick" }, mods = { "caverealms" },
	reward = { items = { "default:torch 10" } },
})
Q.register_quest({
	id = "ch21.amethyst_geode", title = "La géode d'améthyste", difficulty = 3, icon = "amethyst_new:amethyst",
	description = "Brise la coque d'une géode et découvre son cœur violet, hérissé de cristaux.",
	hint = "Les géodes se cachent sous la profondeur 128.",
	trigger = { type = "dig", items = { "amethyst_new:amethyst" } },
	requires = { "ch04.steel_pick" }, mods = { "amethyst_new" },
	reward = { items = { "default:bronze_ingot 2" } },
})
Q.register_quest({
	id = "ch21.cave_mushrooms", title = "Cueillette souterraine", difficulty = 2, icon = "caverealms:mycena",
	description = "Les champignons des profondeurs luisent dans le noir. Promis, on ne les mange pas !",
	trigger = { type = "dig", items = { "caverealms:mycena", "caverealms:fungus" } },
	requires = { "ch21.glow_gems" }, mods = { "caverealms" },
	reward = { items = { "farming:bread 3" } },
})
Q.register_quest({
	id = "ch21.glow_crystal", title = "Le cœur des cristaux", difficulty = 3, icon = "caverealms:glow_crystal",
	description = "Cristaux, émeraudes, rubis ou améthystes luminescents : les plus rares merveilles des profondeurs.",
	hint = "Ces formations sont rares : explore patiemment les grandes cavernes.",
	trigger = { type = "dig", items = { "caverealms:glow_crystal", "caverealms:glow_emerald", "caverealms:glow_ruby",
		"caverealms:glow_amethyst", "caverealms:glow_mese" } },
	requires = { "ch21.glow_gems" }, mods = { "caverealms" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch21.amethyst_lantern", title = "Lanterne de cristal", difficulty = 3, icon = "amethyst_new:lantern",
	description = "Du bronze, de l'améthyste et un fil de Mese : une lanterne digne d'un palais souterrain.",
	trigger = { type = "place", items = { "amethyst_new:lantern" } },
	requires = { "ch21.amethyst_geode" }, mods = { "amethyst_new" },
	reward = { items = { "default:bronze_ingot 2" } },
})
Q.register_quest({
	id = "ch21.glow_bait", title = "Appâts luisants", difficulty = 2, icon = "caverealms:glow_bait",
	description = "Un ver luisant donne neuf appâts : les poissons des lacs souterrains n'y résistent pas.",
	trigger = { type = "craft", items = { "caverealms:glow_bait" } },
	requires = { "ch21.cave_mushrooms" }, mods = { "caverealms" },
	reward = { items = { "farming:string 4" } },
})
Q.register_quest({
	id = "ch21.ancient_chest", title = "Le coffre oublié", difficulty = 3, icon = "lootchests_default:stone_chest",
	final = true,
	description = "Un coffre de pierre, une urne ou un panier abandonné dans les profondeurs… Vide-le, puis "
		.. "rapporte-le en souvenir !",
	hint = "Un coffre au trésor ne se démonte qu'une fois vidé. Ceux que tu poses toi-même ne comptent pas.",
	trigger = { type = "dig", items = { "lootchests_default:stone_chest", "lootchests_default:urn",
		"lootchests_default:basket", "lootchests_default:ocean_chest" } },
	requires = { "ch21.glow_crystal", "ch21.amethyst_geode" }, mods = { "lootchests_default" },
	reward = { items = { "default:gold_ingot 2" }, title = "Cœur de cristal" },
})
