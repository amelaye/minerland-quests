-- Chapitre 23 — Les mystères du passé (paleotest). Audit : docs/audit/ch22_ch23.md.
-- Sur Minerland, les dinosaures ne se capturent pas : ils renaissent des fossiles grâce aux machines (choix de
-- l'administratrice). Chaîne pacifique : creuser → analyser → cultiver → planter ou faire éclore → monter.
-- Analyse et culture sont des machines (pas de grille) : on détecte la pose de ce qu'elles produisent (arbre fossile,
-- œuf : integrations/paleotest.lua) et la monte d'un dinosaure adulte (integrations/rides.lua). L'éclosion et
-- l'imprégnation n'émettent rien.
local Q = minerland_quests

Q.register_quest({
	id = "ch23.fossil_dig", title = "Coup de pioche au Jurassique", difficulty = 2, icon = "paleotest:fossil_block",
	description = "Dans la pierre dorment les os de créatures disparues depuis des millénaires. À toi de les exhumer !",
	hint = "Les blocs de fossiles sont plus fréquents en profondeur ; le permafrost suspect se trouve sous la neige.",
	trigger = { type = "dig", items = { "paleotest:fossil_block", "paleotest:suspicious_permafrost" } },
	requires = { "ch01.first_tool" }, mods = { "paleotest" },
	reward = { items = { "default:book 1" } },
})
Q.register_quest({
	id = "ch23.field_guide", title = "Le carnet du paléontologue", difficulty = 1, icon = "paleotest:field_guide",
	description = "Un fossile, un livre et un peu d'encre bleue : ton carnet de terrain recense toutes tes trouvailles.",
	trigger = { type = "craft", items = { "paleotest:field_guide" } },
	requires = { "ch23.fossil_dig" }, mods = { "paleotest" },
	reward = { items = { "default:copper_ingot 3" } },
})
Q.register_quest({
	id = "ch23.whip", title = "Le fouet du soigneur", difficulty = 2, icon = "paleotest:whip",
	description = "Les grands herbivores obéissent au fouet… à condition de le manier avec respect.",
	trigger = { type = "craft", items = { "paleotest:whip" } },
	requires = { "ch23.fossil_dig" }, mods = { "paleotest" },
	reward = { items = { "farming:wheat 6" } },
})
Q.register_quest({
	id = "ch23.fossil_analyzer", title = "Monter son labo", difficulty = 2, icon = "paleotest:fossil_analyzer",
	description = "L'analyseur extrait l'ADN des fossiles. Ton laboratoire de paléontologie est ouvert !",
	hint = "Du cuivre, du bronze et de l'acier.",
	trigger = { type = "place", items = { "paleotest:fossil_analyzer" } },
	requires = { "ch23.field_guide" }, mods = { "paleotest" },
	reward = { items = { "default:bronze_ingot 2" } },
})
Q.register_quest({
	id = "ch23.dna_cultivator", title = "L'incubateur à ADN", difficulty = 2, icon = "paleotest:dna_cultivator",
	description = "Le cultivateur transforme l'ADN en graine ou en œuf. La vie renaît du passé !",
	hint = "Il demande un seau d'eau et du bronze. Mets-y l'ADN obtenu à l'analyseur.",
	trigger = { type = "place", items = { "paleotest:dna_cultivator" } },
	requires = { "ch23.fossil_analyzer" }, mods = { "paleotest" },
	reward = { items = { "default:torch 6" } },
})
Q.register_quest({
	id = "ch23.living_fossil", title = "Une forêt venue du passé", difficulty = 3, icon = "paleotest:metasequoia_sapling",
	description = "Un fossile végétal, une culture patiente : plante un métaséquoia, l'arbre des dinosaures.",
	hint = "Choisis un terrain dégagé : l'arbre devient immense.",
	trigger = { type = "place", items = { "paleotest:metasequoia_sapling" } },
	requires = { "ch23.dna_cultivator" }, mods = { "paleotest" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch23.dino_egg", title = "Un œuf bien au chaud", difficulty = 3, icon = "paleotest:dna_cultivator",
	description = "L'œuf sorti du cultivateur doit être posé au sol, près d'une source de chaleur, pour éclore.",
	objective = "Poser un œuf de dinosaure.",
	hint = "Pose l'œuf près d'une torche et patiente : le petit sortira bientôt.",
	trigger = { type = "custom", key = "paleotest:egg_placed" },
	requires = { "ch23.dna_cultivator" }, mods = { "paleotest" },
	reward = { items = { "farming:wheat 10", "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch23.dino_ride", title = "En selle sur un tricératops !", difficulty = 4, icon = "paleotest:whip", final = true,
	description = "Ton dinosaure a grandi : fouet en main, grimpe sur son dos pour une balade préhistorique.",
	objective = "Monter sur un dinosaure.",
	hint = "Il faut un adulte (tricératops, tyrannosaure ou quetzalcoatlus) et le fouet en main.",
	trigger = { type = "custom", key = "rides:dinosaur" },
	requires = { "ch23.dino_egg", "ch23.whip" }, mods = { "paleotest" },
	reward = { items = { "default:gold_ingot 2" }, title = "Mémoire du Jurassique" },
})
