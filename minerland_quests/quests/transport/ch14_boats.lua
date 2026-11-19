-- Chapitre 14 — Larguez les amarres ! (motorboat, fishing_boat, nautilus, biofuel, ferry linetrack).
-- Audit : docs/audit/ch13_ch14.md. Mettre un bateau à l'eau crée une entité (aucun événement), la pêche du chalutier
-- n'a aucune mécanique et la profondeur atteinte par le Nautilus reviendrait à lire des coordonnées : non retenus.
-- Détectable : fabrication et embarquement (integrations/rides.lua, qui remonte du siège à l'embarcation).
local Q = minerland_quests

Q.register_quest({
	id = "ch14.hull", title = "Une coque qui flotte", difficulty = 2, icon = "motorboat:hull",
	description = "Tout bateau commence par une coque étanche. Le reste viendra ensuite.",
	trigger = { type = "craft", items = { "motorboat:hull" } },
	mods = { "motorboat" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch14.fuel_bottle", title = "Plein d'essence verte", difficulty = 2, icon = "biofuel:bottle_fuel",
	description = "Les moteurs marins boivent du biocarburant : prépare une bonne bouteille avant de prendre la mer.",
	hint = "Quatre fioles de biocarburant, produites par la raffinerie de biomasse.",
	trigger = { type = "craft", items = { "biofuel:bottle_fuel" } },
	mods = { "biofuel" },
	reward = { items = { "default:tin_ingot 2" } },
})
Q.register_quest({
	id = "ch14.ferry_ride", title = "Passager du ferry", difficulty = 1, icon = "motorboat:boat",
	description = "Les ferries relient les rives du royaume : monte à bord et profite de la traversée.",
	objective = "Voyager à bord d'un ferry.",
	hint = "Clic droit sur un ferry à quai.",
	trigger = { type = "custom", key = "rides:ferry" },
	reward = { items = { "biofuel:phial_fuel 2" } },
})
Q.register_quest({
	id = "ch14.motorboat", title = "Moteur, ça tourne !", difficulty = 4, icon = "motorboat:boat",
	description = "Coque, moteur et barre : ton bateau à moteur est prêt à fendre les flots.",
	hint = "Le moteur demande un bloc de Mese et un diamant.",
	trigger = { type = "craft", items = { "motorboat:boat" } },
	requires = { "ch14.hull" }, mods = { "motorboat" },
	reward = { items = { "biofuel:fuel_can 1" } },
})
Q.register_quest({
	id = "ch14.fishing_boat", title = "Le chalutier de la baie", difficulty = 3, icon = "fishing_boat:boat",
	description = "Un solide chalutier, avec sa cabine et son pont : de quoi partir en mer avec tout l'équipage.",
	trigger = { type = "craft", items = { "fishing_boat:boat" } },
	requires = { "ch14.hull" }, mods = { "fishing_boat" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch14.nautilus", title = "Vingt mille lieues sous les blocs", difficulty = 4, icon = "nautilus:boat",
	description = "Le Nautilus plonge là où les autres bateaux n'osent pas aller. Le capitaine Nemo n'a qu'à bien se "
		.. "tenir !",
	hint = "Ses moteurs demandent un diamant et un cristal de Mese.",
	trigger = { type = "craft", items = { "nautilus:boat_wooden", "nautilus:boat" } },
	requires = { "ch14.hull" }, mods = { "nautilus" },
	reward = { items = { "default:glass 6" } },
})
Q.register_quest({
	id = "ch14.board_boat", title = "Capitaine à bord", difficulty = 3, icon = "fishing_boat:boat", final = true,
	description = "Bateau à moteur, chalutier ou sous-marin : prends place à bord et largue les amarres !",
	objective = "Monter à bord d'un bateau ou d'un sous-marin.",
	hint = "Seul le propriétaire pilote le bateau à moteur et le Nautilus.",
	trigger = { type = "custom", key = "rides:boat" },
	requires = { "ch14.hull", "ch14.fuel_bottle" },
	reward = { items = { "default:gold_ingot 2" }, title = "Pied marin" },
})
