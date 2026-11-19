-- Chapitre 12 — Métros et tramways (trainblocks, metrosigns, doxy_mini_tram, linetrack).
-- Audit : docs/audit/ch11_ch12_ch15.md.
-- Transport urbain, distinct du ferroviaire général : signalétique, station, tramway. Les panneaux metrosigns sortent
-- d'une machine (pas de fabrication en grille) et la pose d'un tram exige train_operator : seules la machine et les
-- pièces fabricables sont retenues ; voyager se détecte par integrations/rides.lua.
local Q = minerland_quests

Q.register_quest({
	id = "ch12.subway_sign", title = "Le M qui brille", difficulty = 1, icon = "trainblocks:subwayblock",
	description = "Une station de métro se repère de loin grâce à son grand M lumineux.",
	trigger = { type = "craft", items = { "trainblocks:subwayblock" } },
	mods = { "trainblocks" },
	reward = { items = { "default:glass 4" } },
})
Q.register_quest({
	id = "ch12.line_number", title = "Ligne 1, direction Minerland", difficulty = 1, icon = "trainblocks:line1",
	description = "Chaque ligne a son numéro : les voyageurs ne doivent jamais se perdre.",
	trigger = { type = "craft", items = { "trainblocks:line1" } },
	requires = { "ch12.subway_sign" }, mods = { "trainblocks" },
	reward = { items = { "default:stonebrick 8" } },
})
Q.register_quest({
	id = "ch12.platform_number", title = "Quai numéro un", difficulty = 1, icon = "trainblocks:platformsign1",
	description = "Accroche le numéro du quai : « Le métro à destination du centre partira voie 1 ».",
	trigger = { type = "place", items = { "trainblocks:platformsign1" } },
	requires = { "ch12.line_number" }, mods = { "trainblocks" },
	reward = { items = { "default:torch 6" } },
})
Q.register_quest({
	id = "ch12.station_hall", title = "Le hall de la station", difficulty = 2, icon = "trainblocks:station_block",
	description = "Le grand hall accueille les voyageurs : il doit être clair, propre et bien signalé.",
	trigger = { type = "place", items = { "trainblocks:station_block" } },
	requires = { "ch12.subway_sign" }, mods = { "trainblocks" },
	reward = { items = { "default:meselamp 2" } },
})
Q.register_quest({
	id = "ch12.sign_writer", title = "L'imprimerie des panneaux", difficulty = 2, icon = "metrosigns:sign_writer",
	description = "La machine à panneaux imprime plans de lignes et noms de stations, comme dans les grandes capitales.",
	hint = "Elle demande des matériaux de base (basic_materials) ; ses cartouches d'encre se fabriquent aussi.",
	trigger = { type = "craft", items = { "metrosigns:sign_writer" } },
	mods = { "metrosigns" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch12.tram_template", title = "Le gabarit du tramway", difficulty = 2,
	icon = "minitram_crafting_recipes:minitram_template",
	description = "Avant de construire un tramway, il faut son gabarit : la première pièce d'un grand projet urbain.",
	trigger = { type = "craft", items = { "minitram_crafting_recipes:minitram_template" } },
	mods = { "minitram_crafting_recipes" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch12.metro_ride", title = "Prendre le métro", difficulty = 2, icon = "trainblocks:subwayblock", final = true,
	description = "Ta station est prête : monte dans une rame de métro, un tramway ou un bus, et laisse-toi porter.",
	objective = "Voyager dans un métro, un tramway ou un bus.",
	hint = "Clic droit sur une voiture arrêtée à une station.",
	trigger = { type = "custom", key = "rides:metro" },
	requires = { "ch12.station_hall", "ch12.tram_template" },
	reward = { items = { "default:gold_ingot 1" }, title = "Ticket gagnant" },
})
