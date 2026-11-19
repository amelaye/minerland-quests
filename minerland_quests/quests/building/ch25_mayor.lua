-- Chapitre 25 — Monsieur ou Madame le Maire (minerland_quests, areas, streets, street_signs, atm).
-- Audit : docs/audit/ch24_ch25.md. Fonder une ville par des gestes simples : sceller la charte, protéger le terrain,
-- tracer et nommer une rue, l'éclairer, installer un distributeur. Aucune quête ne prétend qu'une ville est bâtie et
-- aucune ne repose sur une validation de l'administration : « la Reine valide » reste une couleur de récit. Pas de
-- taille de ville, de population ni de coordonnées. La protection par /protect (areas, auto-protection active sur
-- Minerland) est détectée par l'API publique areas:registerOnAdd (integrations/areas.lua).
local Q = minerland_quests

Q.register_quest({
	id = "ch25.charter_write", title = "Rédiger la charte", difficulty = 3, icon = "minerland_quests:city_charter",
	description = "Sept parchemins, un lingot d'or et ton Grand Livre : la charte de fondation de ta ville est rédigée.",
	hint = "Le Grand Livre te revient après la fabrication.",
	trigger = { type = "craft", items = { "minerland_quests:city_charter" } },
	requires = { "ch02.protector" },
	reward = { items = { "default:paper 7" } },
})
Q.register_quest({
	id = "ch25.charter_seal", title = "Sceller la charte", difficulty = 1, icon = "minerland_quests:city_charter",
	description = "Accroche la charte au mur de ta future mairie : elle porte ton nom et la date de fondation.",
	hint = "Rappel des règles du royaume : on ne bâtit pas près du point d'apparition, et les grands projets se "
		.. "présentent à la Reine.",
	trigger = { type = "place", items = { "minerland_quests:city_charter" } },
	requires = { "ch25.charter_write" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch25.protect_town", title = "Borner la commune", difficulty = 2, icon = "default:sign_wall_wood",
	description = "Une commune protégée est une commune sereine : délimite ton terrain avec le système de zones.",
	objective = "Protéger une zone à ton nom avec /protect.",
	hint = "Marque deux coins avec /area_pos1 et /area_pos2, puis tape /protect suivi du nom de ta commune.",
	trigger = { type = "custom", key = "areas:protect" },
	requires = { "ch25.charter_seal" }, mods = { "areas" },
	reward = { items = { "default:sign_wall_wood 4" } },
})
Q.register_quest({
	id = "ch25.first_road", title = "La grand-rue", difficulty = 2, icon = "streets:asphalt",
	description = "Seize blocs d'asphalte bien alignés : la première rue de ta ville est tracée.",
	hint = "L'asphalte s'obtient en cuisant du gravier au four. Pose-le à seize endroits différents.",
	trigger = { type = "place", items = { "streets:asphalt" }, count = 16 },
	requires = { "ch25.charter_seal" }, mods = { "streets" },
	reward = { items = { "default:gravel 20" } },
})
Q.register_quest({
	id = "ch25.sidewalk", title = "Des trottoirs pour les piétons", difficulty = 2, icon = "streets:sidewalk",
	description = "Une rue sans trottoir, c'est dangereux ! Prépare de quoi border ta grand-rue.",
	hint = "De l'asphalte et du colorant blanc. Il en faut quatre.",
	trigger = { type = "craft", items = { "streets:sidewalk" }, count = 4 },
	requires = { "ch25.first_road" }, mods = { "streets" },
	reward = { items = { "dye:white 4" } },
})
Q.register_quest({
	id = "ch25.street_name", title = "Baptiser la rue", difficulty = 2, icon = "street_signs:sign_basic",
	description = "Rue de la Reine, avenue des Mineurs ou impasse du Dragon : à toi de baptiser ta rue !",
	hint = "Un panneau d'acier, des colorants vert et blanc et deux lingots d'acier.",
	trigger = { type = "place", items = { "street_signs:sign_basic" } },
	requires = { "ch25.first_road" }, mods = { "street_signs" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch25.bank", title = "Le distributeur de la place", difficulty = 3, icon = "atm:atm",
	description = "Une ville qui commerce a besoin d'une banque : installe un distributeur sur la grand-place.",
	trigger = { type = "place", items = { "atm:atm" } },
	requires = { "ch25.charter_seal" }, mods = { "atm" },
	reward = { items = { "currency:minegeld_10 2" } },
})
Q.register_quest({
	id = "ch25.street_lights", title = "Lumière sur la place", difficulty = 3, icon = "streets:light_vertical_off",
	final = true,
	description = "Trois réverbères et ta commune brille enfin la nuit. Elle a encore tout à bâtir, mais elle a son "
		.. "maire !",
	hint = "Les réverbères demandent une lampe de Mese. Pose-en trois à des endroits différents.",
	trigger = { type = "place", items = { "streets:light_vertical_off", "streets:light_horizontal_off",
		"streets:light_hanging_off" }, count = 3 },
	requires = { "ch25.street_name", "ch25.protect_town" }, mods = { "streets" },
	reward = { items = { "default:gold_ingot 2" }, title = "Maire de Minerland" },
})
