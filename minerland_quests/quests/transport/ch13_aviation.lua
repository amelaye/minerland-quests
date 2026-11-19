-- Chapitre 13 — Les fous volants (airutils, ju52, pa28, supercub, hidroplane, hangglider).
-- Audit : docs/audit/ch13_ch14.md.
-- Poser un avion crée une entité (aucun événement), faire le plein, décoller ou atterrir n'émettent rien : la
-- progression repose sur la fabrication, sur le vol en deltaplane (API publique hangglider.is_gliding, adaptateur
-- integrations/hangglider.lua) et sur l'embarquement (integrations/rides.lua). Le brevet de Luffy reste un récit :
-- aucun mod ne le vérifie, aucune quête ne le suppose. Fabriquer couvre aussi les recettes de réparation et de
-- teinture du deltaplane (même objet produit) : limite acceptée, l'action reste une vraie fabrication.
local Q = minerland_quests

Q.register_quest({
	id = "ch13.windsock", title = "D'où vient le vent ?", difficulty = 1, icon = "airutils:wind",
	description = "Tout aérodrome digne de ce nom a sa manche à air. C'est le premier outil du pilote.",
	trigger = { type = "craft", items = { "airutils:wind" } },
	mods = { "airutils" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch13.papi", title = "Les feux de la piste", difficulty = 2, icon = "airutils:papi",
	description = "Les feux PAPI guident les avions à l'atterrissage. Ta piste devient un vrai terrain d'aviation.",
	hint = "Il faut un cristal de Mese.",
	trigger = { type = "craft", items = { "airutils:papi" } },
	requires = { "ch13.windsock" }, mods = { "airutils" },
	reward = { items = { "default:glass 4" } },
})
Q.register_quest({
	id = "ch13.glider_craft", title = "Des ailes de toile", difficulty = 1, icon = "hangglider:hangglider",
	description = "Une toile, une armature légère : le deltaplane est l'aéronef le plus simple du royaume.",
	trigger = { type = "craft", items = { "hangglider:hangglider" } },
	mods = { "hangglider" },
	reward = { items = { "wool:white 3" } },
})
Q.register_quest({
	id = "ch13.first_glide", title = "Le grand saut", difficulty = 2, icon = "hangglider:hangglider",
	description = "Du haut d'une falaise, déploie ton deltaplane et laisse-toi porter par le vent.",
	objective = "Planer en deltaplane.",
	hint = "Utilise le deltaplane en plein saut. Attention : certains propriétaires ferment l'espace aérien de leur "
		.. "terrain, et le survoler fait chuter le pilote.",
	trigger = { type = "custom", key = "hangglider:glide" },
	requires = { "ch13.glider_craft" }, mods = { "hangglider" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch13.cub_wings", title = "Une aile pour le Super Cub", difficulty = 2, icon = "supercub:wings",
	description = "Laine, ficelle et bois : les ailes du Super Cub sont le premier pas vers un vrai avion.",
	trigger = { type = "craft", items = { "supercub:wings" } },
	mods = { "supercub" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch13.repair_kit", title = "La caisse à outils du mécano", difficulty = 2, icon = "airutils:repair_tool",
	description = "Un avion bien entretenu est un avion qui vole longtemps. Garde toujours tes outils à portée de main.",
	trigger = { type = "craft", items = { "airutils:repair_tool" } },
	mods = { "airutils" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch13.first_plane", title = "Mon premier coucou", difficulty = 4, icon = "supercub:supercub",
	description = "Super Cub, PA-28, hydravion ou le vénérable Ju 52 : assemble ton premier avion.",
	hint = "Le Ju 52 ne demande que de l'étain et de l'acier ; le PA-28 et le Super Cub demandent un bloc de diamant et "
		.. "un bloc de Mese.",
	trigger = { type = "craft", items = { "supercub:supercub", "ju52:ju52", "pa28:pa28", "hidroplane:hidro" } },
	requires = { "ch13.cub_wings" }, mods = { "airutils" },
	reward = { items = { "biofuel:fuel_can 1" } },
})
Q.register_quest({
	id = "ch13.board_plane", title = "Embarquement immédiat", difficulty = 3, icon = "ju52:ju52", final = true,
	description = "Monte à bord d'un avion, aux commandes ou comme passager. Et n'oublie pas : Luffy fait passer le "
		.. "brevet aux pilotes en herbe !",
	objective = "Monter à bord d'un avion.",
	hint = "Le Ju 52 accepte des passagers ; les autres avions se pilotent par leur propriétaire.",
	trigger = { type = "custom", key = "rides:aviation" },
	requires = { "ch13.first_plane", "ch13.first_glide" },
	reward = { items = { "default:gold_ingot 2" }, title = "Ailes de Minerland" },
})
