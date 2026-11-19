-- Chapitre 15 — Prenons de la hauteur ! (chair_lift, celevator, elevator ; travelnet en branche secondaire).
-- Audit : docs/audit/ch11_ch12_ch15.md (et tutoriels de l'Académie sur les télésièges et les ascenseurs).
-- Détectable : fabrication des pièces, pose des pylônes et des commandes, et via integrations/rides.lua le fait de
-- s'asseoir sur un siège de télésiège ou de monter dans une cabine d'ascenseur. Non détectable : pose du câble et
-- du siège (entités), démarrage de la roue motrice, téléportation travelnet.
local Q = minerland_quests

Q.register_quest({
	id = "ch15.steel_rope", title = "Le câble du téléphérique", difficulty = 2, icon = "chair_lift:steel_rope",
	description = "Tout télésiège tient à un fil… d'acier, heureusement. Fabrique le câble.",
	trigger = { type = "craft", items = { "chair_lift:steel_rope" } },
	mods = { "chair_lift" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch15.pylon", title = "Le premier pylône", difficulty = 2, icon = "chair_lift:pole_body",
	description = "Un pylône solide, un bras, une roue : la ligne du télésiège prend forme.",
	hint = "Suis le tutoriel des télésièges de l'Académie : fût du pylône, bras, puis roue motrice.",
	trigger = { type = "place", items = { "chair_lift:pole_body", "chair_lift:pole_arm_end",
		"chair_lift:wheel_powered" } },
	requires = { "ch15.steel_rope" }, mods = { "chair_lift" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch15.chair", title = "Un siège pour deux skis", difficulty = 2, icon = "chair_lift:seat",
	description = "Un siège confortable, accroché au câble : la montagne n'a qu'à bien se tenir.",
	trigger = { type = "craft", items = { "chair_lift:seat" } },
	requires = { "ch15.steel_rope" }, mods = { "chair_lift" },
	reward = { items = { "wool:white 2" } },
})
Q.register_quest({
	id = "ch15.chair_ride", title = "Les pieds dans le vide", difficulty = 2, icon = "chair_lift:seat",
	description = "Assieds-toi, baisse la barre de sécurité… et admire la vue !",
	objective = "Monter sur un siège de télésiège.",
	trigger = { type = "custom", key = "rides:chairlift" },
	requires = { "ch15.chair" }, mods = { "chair_lift" },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch15.lift_controller", title = "Le cerveau de l'ascenseur", difficulty = 3, icon = "celevator:controller",
	description = "Un ascenseur réaliste se pilote depuis son contrôleur. Installe-le, puis la cabine.",
	hint = "Le tutoriel des ascenseurs de l'Académie détaille chaque pièce.",
	trigger = { type = "place", items = { "celevator:controller", "celevator:car_standard", "elevator:elevator_off" } },
	reward = { items = { "default:copper_ingot 4" } },
})
Q.register_quest({
	id = "ch15.travelnet", title = "La boîte à téléporter", difficulty = 3, icon = "travelnet:travelnet",
	description = "Une cabine Travelnet relie les villes du royaume en un clin d'œil. Pose la tienne et donne-lui un "
		.. "nom.",
	trigger = { type = "place", items = { "travelnet:travelnet", "travelnet:elevator", "locked_travelnet:travelnet" } },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch15.lift_ride", title = "Dernier étage, on descend !", difficulty = 3, icon = "celevator:car_standard",
	final = true,
	description = "Cabine appelée, portes fermées : en route vers les étages ! Du télésiège à l'ascenseur, plus rien "
		.. "ne t'arrête.",
	objective = "Monter dans une cabine d'ascenseur.",
	trigger = { type = "custom", key = "rides:elevator" },
	requires = { "ch15.lift_controller", "ch15.chair_ride" },
	reward = { items = { "default:gold_ingot 1" }, title = "Tête dans les nuages" },
})
