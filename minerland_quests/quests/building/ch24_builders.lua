-- Chapitre 24 — Les grands bâtisseurs (darkage, mydoors, facade). Audit : docs/audit/ch24_ch25.md.
-- Les grands chantiers à petite échelle : pierre noble, bois teinté, portes ouvragées, façades. Aucune quête ne
-- demande une construction géante. L'échafaudage est écarté (choix de l'administratrice) ; les formes de la machine à
-- façonner ne sont pas des recettes de grille : on détecte leur pose.
local Q = minerland_quests

local CASTLE_DOORS = {}
for n = 1, 13 do
	CASTLE_DOORS[#CASTLE_DOORS + 1] = "my_castle_doors:door" .. n .. "_a"
	CASTLE_DOORS[#CASTLE_DOORS + 1] = "my_castle_doors:door" .. n .. "_b"
end

Q.register_quest({
	id = "ch24.marble_quarry", title = "Carrière de marbre", difficulty = 2, icon = "darkage:marble",
	description = "Le marbre veiné dort dans certaines couches de roche. Ouvre ta carrière et taille-en dix blocs.",
	hint = "Seuls les blocs naturels comptent, pas ceux que tu as posés.",
	trigger = { type = "dig", items = { "darkage:marble" }, count = 10 },
	requires = { "ch01.first_tool" }, mods = { "darkage" },
	reward = { items = { "default:stonebrick 20" } },
})
Q.register_quest({
	id = "ch24.marble_tiles", title = "Le dallage du palais", difficulty = 2, icon = "darkage:marble_tile",
	description = "Des dalles de marbre bien taillées : le sol d'un palais n'attend plus que toi.",
	hint = "Quatre blocs de marbre donnent deux dalles. Il en faut quatre.",
	trigger = { type = "craft", items = { "darkage:marble_tile" }, count = 4 },
	requires = { "ch24.marble_quarry" }, mods = { "darkage" },
	reward = { items = { "default:glass 10" } },
})
Q.register_quest({
	id = "ch24.stained_wood", title = "Une touche de teinture", difficulty = 1, icon = "my_door_wood:wood_red",
	description = "Un peu de colorant sur du bois, et voilà la matière première des plus belles portes.",
	hint = "Un bloc de bois et un colorant. Il en faut trois.",
	trigger = { type = "craft", items = { "my_door_wood:wood_red", "my_door_wood:wood_grey", "my_door_wood:wood_dark_grey",
		"my_door_wood:wood_brown", "my_door_wood:wood_white", "my_door_wood:wood_yellow", "my_door_wood:wood_black" },
		count = 3 },
	requires = { "ch01.planks" }, mods = { "my_door_wood" },
	reward = { items = { "dye:white 2", "dye:red 2" } },
})
Q.register_quest({
	id = "ch24.castle_gate", title = "Une porte de château", difficulty = 2, icon = "my_castle_doors:door1",
	description = "Bois sombre, ferrures d'acier : une porte digne des remparts de la Reine.",
	hint = "De l'acier, du verre et du bois teinté gris foncé.",
	trigger = { type = "place", items = CASTLE_DOORS },
	requires = { "ch24.stained_wood" }, mods = { "my_castle_doors" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch24.secret_passage", title = "Le passage secret", difficulty = 3, icon = "my_hidden_doors:hidden_doorbookshelf",
	description = "Une bibliothèque qui pivote sur elle-même… Chaque château qui se respecte a son passage secret.",
	hint = "Fabrique d'abord une porte cachée grise (six bois gris foncé), puis ajoute une bibliothèque.",
	trigger = { type = "craft", items = { "my_hidden_doors:hidden_doorbookshelf" } },
	requires = { "ch24.stained_wood" }, mods = { "my_hidden_doors" },
	reward = { items = { "default:book 2" } },
})
Q.register_quest({
	id = "ch24.shaper", title = "L'atelier du tailleur de pierre", difficulty = 4, icon = "facade:shaper",
	description = "La machine à façonner sculpte colonnes, corniches et bas-reliefs dans la pierre et le marbre.",
	hint = "Un diamant, deux blocs d'acier et deux lingots.",
	trigger = { type = "craft", items = { "facade:shaper" } },
	requires = { "ch24.marble_tiles" }, mods = { "facade" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch24.colonnade", title = "Une colonnade pour la place", difficulty = 3, icon = "facade:marble_column",
	final = true,
	description = "Quatre colonnes de pierre ou de marbre, bien alignées : ta grand-place a enfin l'allure d'un forum.",
	hint = "Taille les colonnes à la machine à façonner, puis pose-en quatre à des endroits différents.",
	trigger = { type = "place", items = { "facade:stone_column", "facade:marble_column", "facade:sandstone_column",
		"facade:stone_columnia_mid", "facade:marble_columnia_mid" }, count = 4 },
	requires = { "ch24.shaper" }, mods = { "facade" },
	reward = { items = { "default:gold_ingot 2" }, title = "Pierre angulaire" },
})
