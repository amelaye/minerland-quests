-- Chapitre 2 — Mon premier chez-moi (default, doors, beds, protector).
-- Les lits MTG sont posés via set_node sans callback (beds/api.lua:115) : on valide leur fabrication.
local Q = minerland_quests

Q.register_quest({
	id = "ch02.door_craft", title = "On ne rentre pas sans frapper", difficulty = 1, icon = "doors:door_wood",
	description = "Une maison sans porte, c'est un courant d'air avec un toit.",
	hint = "Six planches en deux colonnes.",
	trigger = { type = "craft", items = { "doors:door_wood", "doors:door_glass", "doors:door_steel" } },
	requires = { "ch01.planks" }, mods = { "doors" },
	reward = { items = { "default:glass 6" } },
})
Q.register_quest({
	id = "ch02.door_place", title = "Pas de porte, pas de chez-soi", difficulty = 1, icon = "doors:door_wood",
	description = "Installe ta porte. Bonus : tu peux maintenant claquer la porte avec élégance.",
	trigger = { type = "place", items = { "doors:door_wood_a", "doors:door_wood_b", "doors:door_glass_a",
		"doors:door_glass_b", "doors:door_steel_a", "doors:door_steel_b" } },
	requires = { "ch02.door_craft" }, mods = { "doors" },
	reward = { items = { "default:torch 8" } },
})
Q.register_quest({
	id = "ch02.bed", title = "Au lit, les marmottes !", difficulty = 1, icon = "beds:bed",
	description = "Après une longue journée de construction, rien ne vaut un bon lit douillet.",
	hint = "Laine ou coton + planches. Il suffit d'en fabriquer un.",
	trigger = { type = "craft", items = { "beds:bed", "beds:fancy_bed", "beds:bed_bottom", "beds:fancy_bed_bottom" } },
	requires = { "ch01.planks" }, mods = { "beds" },
	reward = { items = { "default:bookshelf 1" } },
})
Q.register_quest({
	id = "ch02.light", title = "Que la lumière soit", difficulty = 1, icon = "default:torch",
	description = "Les nuits de Minerland sont belles, mais un peu sombres. Éclaire ta maison.",
	hint = "Pose trois torches à trois endroits différents (sol, mur ou plafond).",
	trigger = { type = "place", items = { "default:torch", "default:torch_wall", "default:torch_ceiling" }, count = 3 },
	requires = { "ch02.door_place" },
	reward = { items = { "default:coal_lump 6" } },
})
Q.register_quest({
	id = "ch02.protector", title = "Propriété privée", difficulty = 2, icon = "protector:protect",
	description = "À Minerland, on protège ses constructions. Un bloc de protection et les voisins indélicats "
		.. "resteront à la porte.",
	hint = "Le bloc Protector protège une zone autour de lui. Clic droit dessus pour gérer les membres.",
	trigger = { type = "place", items = { "protector:protect", "protector:protect2" } },
	requires = { "ch02.door_place" }, mods = { "protector" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch02.furniture", title = "Un intérieur qui a du chien", difficulty = 1, icon = "default:bookshelf",
	description = "Une bibliothèque, un panneau ou une barrière : un premier meuble pour personnaliser ton nid.",
	trigger = { type = "place", items = { "default:bookshelf", "default:sign_wall_wood", "default:fence_wood" } },
	requires = { "ch02.bed" },
	reward = { items = { "default:book 2" } },
})
Q.register_quest({
	id = "ch02.locked_chest", title = "Mon coffre-fort", difficulty = 2, icon = "default:chest_locked", final = true,
	description = "Un coffre à serrure, et voilà ta maison officiellement digne de ce nom.",
	hint = "Un coffre + un lingot de fer dans la grille, puis pose-le.",
	trigger = { type = "place", items = { "default:chest_locked" } },
	requires = { "ch02.light", "ch02.protector", "ch02.furniture" },
	reward = { items = { "default:steel_ingot 3" }, title = "Propriétaire terrien" },
})
