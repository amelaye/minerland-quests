-- Chapitre 6 — La ferme aux animaux (mobs_redo « mobs », mobs_animal, mob_horse). Audit : docs/audit/ch06_ch09.md.
-- Les gestes sur les animaux (apprivoiser, capturer, monter à cheval) n'ont aucun événement moteur : ils passent par
-- integrations/mobs.lua (enveloppe du clic droit des mobs) et integrations/rides.lua (cavalier attaché au cheval).
-- Relâcher un animal (entité ajoutée sans pose de nœud) et la naissance ne sont pas détectables : pas de quête.
local Q = minerland_quests

Q.register_quest({
	id = "ch06.net_maker", title = "Le filet du bon berger", difficulty = 1, icon = "mobs:net",
	description = "Un filet bien noué, et les petites bêtes de la ferme n'ont qu'à bien se tenir… avec douceur !",
	hint = "Cinq bâtons et deux ficelles.",
	trigger = { type = "craft", items = { "mobs:net" } },
	requires = { "ch01.sticks" }, mods = { "mobs" },
	reward = { items = { "farming:wheat 6" } },
})
Q.register_quest({
	id = "ch06.trusted_friend", title = "Ami des bêtes", difficulty = 2, icon = "farming:wheat",
	description = "Une vache, un mouton, une poule ou un lapin : nourris-le jusqu'à ce qu'il te fasse confiance. "
		.. "Il sera alors à toi pour de bon.",
	objective = "Apprivoiser un animal en le nourrissant.",
	hint = "Clic droit avec sa nourriture préférée : blé pour la vache et le mouton, graines pour la poule, carotte "
		.. "pour le lapin. Il faut plusieurs repas.",
	trigger = { type = "custom", key = "mobs:tame" },
	requires = { "ch03.wheat" }, mods = { "mobs" },
	reward = { items = { "mobs:nametag 1" } },
})
Q.register_quest({
	id = "ch06.honey_hive", title = "Trois abeilles et un toit", difficulty = 2, icon = "mobs:beehive",
	description = "Attrape trois abeilles (gentiment) et offre-leur une maison : elles te le rendront en miel.",
	hint = "Une abeille se capture à main nue ou au filet, sans l'apprivoiser. Trois abeilles font une ruche.",
	trigger = { type = "craft", items = { "mobs:beehive" } },
	requires = { "ch06.net_maker" }, mods = { "mobs_animal" },
	reward = { items = { "flowers:dandelion_yellow 4", "flowers:rose 2" } },
})
Q.register_quest({
	id = "ch06.hive_home", title = "La ruche au jardin", difficulty = 1, icon = "mobs:beehive",
	description = "Une ruche se pose au calme, près des fleurs. Le miel viendra tout seul.",
	trigger = { type = "place", items = { "mobs:beehive" } },
	requires = { "ch06.honey_hive" }, mods = { "mobs_animal" },
	reward = { items = { "vessels:glass_bottle 4" } },
})
Q.register_quest({
	id = "ch06.in_the_net", title = "Pris au filet", difficulty = 2, icon = "mobs:net",
	description = "Un animal apprivoisé peut voyager dans ton sac : capture-le au filet, au lasso ou à la main.",
	objective = "Capturer un animal qui t'appartient.",
	hint = "L'animal doit être apprivoisé et à toi. Selon l'espèce, le filet réussit plus ou moins souvent.",
	trigger = { type = "custom", key = "mobs:capture" },
	requires = { "ch06.net_maker", "ch06.trusted_friend" }, mods = { "mobs" },
	reward = { items = { "mobs:fence_wood 8" } },
})
Q.register_quest({
	id = "ch06.fresh_milk", title = "Un seau de lait tiède", difficulty = 2, icon = "mobs:bucket_milk",
	description = "Un seau vide, une vache patiente, et voilà du bon lait frais. À boire sans attendre !",
	hint = "Clic droit sur une vache avec un seau vide, puis bois le seau de lait (le seau vide te revient).",
	trigger = { type = "eat", items = { "mobs:bucket_milk" } },
	requires = { "ch06.trusted_friend" }, mods = { "mobs_animal" },
	reward = { items = { "mobs:cheese 2" } },
})
Q.register_quest({
	id = "ch06.saddle_up", title = "Cuir, acier et patience", difficulty = 2, icon = "mobs:saddle",
	description = "Un cheval ne se monte pas à cru : il lui faut une belle selle de cuir.",
	hint = "Six morceaux de cuir et deux lingots d'acier.",
	trigger = { type = "craft", items = { "mobs:saddle" } },
	requires = { "ch06.trusted_friend" }, mods = { "mobs" },
	reward = { items = { "mobs:horseshoe_steel 1" } },
})
Q.register_quest({
	id = "ch06.horse_ride", title = "En selle !", difficulty = 3, icon = "mob_horse:horse", final = true,
	description = "Apprivoise un cheval, selle-le et prends les rênes : la campagne de Minerland t'appartient.",
	objective = "Monter sur ton cheval.",
	hint = "Dix repas (blé, pomme, avoine…) pour l'apprivoiser, clic droit avec la selle, puis clic droit pour monter.",
	trigger = { type = "custom", key = "rides:horse" },
	requires = { "ch06.saddle_up" }, mods = { "mob_horse" },
	reward = { items = { "mobs:saddle 1" }, title = "Légende de l'écurie" },
})
