-- Chapitre 18 — L'ère de Techage (techage_modpack : techage, signs_bot). Audit : docs/audit/ch18.md.
-- Parcours propre à Techage, sans lien avec Technic : âge du charbon de bois (TA1), de la vapeur (TA2), du pétrole et
-- de l'électricité (TA3), des énergies renouvelables (TA4). Règle serveur : pas de machines en série, quantité 1.
-- Non détectables : allumage et réussite du meiler, machines « en marche » (swap_node), produits des machines (pas
-- de grille), points d'expérience du collisionneur (TA5 écarté), actions des robots.
local Q = minerland_quests

Q.register_quest({
	id = "ch18.ta1_lighter", title = "Paille et bois sec", difficulty = 1, icon = "techage:lighter",
	description = "Tout commence par le feu. Ce petit allume-feu servira à lancer ta première meule de charbonnier.",
	hint = "Du bois et de la paille.",
	trigger = { type = "craft", items = { "techage:lighter" } },
	mods = { "techage" },
	reward = { items = { "default:wood 10" } },
})
Q.register_quest({
	id = "ch18.ta1_charcoal", title = "Le charbonnier patient", difficulty = 2, icon = "techage:charcoal",
	description = "Une meule de bois recouverte de terre, un peu de feu… et beaucoup de patience : voici le charbon "
		.. "de bois.",
	hint = "Empile du bois, couvre-le de terre, allume-le et attends qu'il ait fini de se consumer, puis creuse le "
		.. "charbon obtenu.",
	trigger = { type = "dig", items = { "techage:charcoal" } },
	requires = { "ch18.ta1_lighter" }, mods = { "techage" },
	reward = { items = { "default:coal_lump 6" } },
})
Q.register_quest({
	id = "ch18.ta1_meltingpot", title = "Le creuset du forgeron", difficulty = 2, icon = "techage:meltingpot",
	description = "Chauffé au charbon de bois, le creuset fond les minerais. L'âge du fer commence !",
	trigger = { type = "place", items = { "techage:meltingpot" } },
	requires = { "ch18.ta1_lighter" }, mods = { "techage" },
	reward = { items = { "default:copper_ingot 3" } },
})
Q.register_quest({
	id = "ch18.ta1_mill", title = "Au fil de l'eau", difficulty = 2, icon = "techage:ta1_mill",
	description = "La roue tourne au fil de l'eau et le moulin écrase le grain. Une technique vieille comme le monde.",
	hint = "Il faut deux lingots de fer Techage, fondus dans le creuset.",
	trigger = { type = "place", items = { "techage:ta1_mill" } },
	requires = { "ch18.ta1_meltingpot" }, mods = { "techage" },
	reward = { items = { "farming:wheat 8" } },
})
Q.register_quest({
	id = "ch18.ta2_flywheel", title = "Que la vapeur soit !", difficulty = 3, icon = "techage:flywheel",
	description = "Le volant d'inertie de la machine à vapeur : l'ère industrielle est en marche.",
	trigger = { type = "place", items = { "techage:flywheel" } },
	requires = { "ch18.ta1_meltingpot" }, mods = { "techage" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch18.ta2_grinder", title = "Broyer la pierre", difficulty = 3, icon = "techage:ta2_grinder_pas",
	description = "Entraîné par la vapeur, le broyeur réduit la pierre en gravier et le gravier en sable.",
	trigger = { type = "craft", items = { "techage:ta2_grinder_pas" } },
	requires = { "ch18.ta2_flywheel" }, mods = { "techage" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch18.ta3_oil", title = "L'odeur du pétrole", difficulty = 4, icon = "techage:oilexplorer",
	description = "L'explorateur de pétrole sonde le sous-sol à la recherche de l'or noir du TA3.",
	trigger = { type = "place", items = { "techage:oilexplorer" } },
	requires = { "ch18.ta2_grinder" }, mods = { "techage" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch18.ta3_robot", title = "Mon premier robot", difficulty = 4, icon = "signs_bot:box",
	description = "Le petit robot à panneaux obéit aux instructions que tu poses devant lui. Un compagnon très appliqué !",
	trigger = { type = "place", items = { "signs_bot:box" } },
	requires = { "ch18.ta3_oil" }, mods = { "signs_bot" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch18.ta4_solar", title = "Capter le soleil", difficulty = 4, icon = "techage:ta4_solar_module", final = true,
	description = "Les modules solaires du TA4 transforment la lumière en électricité. L'avenir est radieux !",
	trigger = { type = "craft", items = { "techage:ta4_solar_module" } },
	requires = { "ch18.ta3_oil" }, mods = { "techage" },
	reward = { items = { "default:gold_ingot 2" }, title = "Visionnaire" },
})
