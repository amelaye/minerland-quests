-- Chapitre 11 — Le monde ferroviaire (advtrains et extensions, farebox, tsm_railcorridors).
-- Audit : docs/audit/ch11_ch12_ch15.md. Poser des rails ou des wagons, conduire, atteler et manœuvrer les
-- aiguillages exigent des privilèges (track_builder, train_operator, railway_operator) que les joueurs ordinaires
-- n'ont pas : aucune quête ne le demande. Le joueur fabrique pièces, rails et signaux pour les chantiers convenus
-- avec l'administration, aménage une gare hors des voies et voyage comme passager (integrations/rides.lua).
local Q = minerland_quests

Q.register_quest({
	id = "ch11.wheelwright", title = "Le charron du rail", difficulty = 1, icon = "advtrains:wheel",
	description = "Avant les locomotives, il y a les roues. Le métier de cheminot commence à l'atelier.",
	trigger = { type = "craft", items = { "advtrains:wheel" } },
	mods = { "advtrains" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch11.rail_forge", title = "Cinquante rails pour la Compagnie", difficulty = 2, icon = "advtrains:dtrack_placer",
	description = "Six lingots d'acier, trois bâtons : cinquante rails sortent de l'atelier. Confie-les à un poseur de "
		.. "voies pour les chantiers approuvés par l'administration.",
	hint = "Poser des rails demande un privilège spécial : la fabrication, elle, est ouverte à tous.",
	trigger = { type = "craft", items = { "advtrains:dtrack_placer", "advtrains:dtrack_tieless_placer" } },
	requires = { "ch11.wheelwright" }, mods = { "advtrains" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch11.signalman", title = "Rouge, vert… en avant !", difficulty = 2, icon = "advtrains:signal_wall_l_off",
	description = "Sans signaux, pas de sécurité. Fabrique ton premier signal ferroviaire.",
	trigger = { type = "craft", items = { "advtrains:signal_wall_l_off", "advtrains_signals_ks:hs_danger_0" } },
	requires = { "ch11.wheelwright" }, mods = { "advtrains" },
	reward = { items = { "default:mese_crystal_fragment 3" } },
})
Q.register_quest({
	id = "ch11.platform", title = "Attention à la marche", difficulty = 2, icon = "advtrains:platform_high_stonebrick",
	description = "Un quai bien droit, à la bonne hauteur : les voyageurs te remercieront.",
	hint = "Pose le quai à au moins deux blocs des rails : tout près des voies, il faut le privilège de poseur de voies.",
	trigger = { type = "place", items = { "advtrains:platform_high_stonebrick" } },
	mods = { "advtrains" },
	reward = { items = { "default:stonebrick 16" } },
})
Q.register_quest({
	id = "ch11.ticket_office", title = "Le guichet de la gare", difficulty = 2, icon = "farebox:farebox",
	description = "Une gare digne de ce nom a son guichet : installe une borne de paiement ou un portillon.",
	trigger = { type = "place", items = { "farebox:farebox", "farebox:faregate" } },
	requires = { "ch11.platform" }, mods = { "farebox" },
	reward = { items = { "currency:minegeld_5 2" } },
})
Q.register_quest({
	id = "ch11.old_mine", title = "Les rails oubliés", difficulty = 2, icon = "carts:rail",
	description = "Sous terre, d'anciennes galeries de mine cachent encore leurs vieux rails. Récupère-les !",
	hint = "Ces galeries étayées de bois se trouvent en profondeur. Les rails que tu poses toi-même ne comptent pas.",
	trigger = { type = "dig", items = { "carts:rail" } },
	reward = { items = { "default:torch 10" } },
})
Q.register_quest({
	id = "ch11.first_journey", title = "En voiture !", difficulty = 2, icon = "advtrains:wheel",
	description = "Les lignes de Minerland t'attendent : monte dans une voiture de voyageurs et profite du paysage.",
	objective = "Voyager dans une voiture de voyageurs d'un train.",
	hint = "Clic droit sur une voiture de voyageurs arrêtée en gare.",
	trigger = { type = "custom", key = "rides:train" },
	mods = { "advtrains" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch11.steam_engine", title = "La locomotive à vapeur", difficulty = 4, icon = "advtrains:newlocomotive",
	final = true,
	description = "Chaudière, cheminée, poste de conduite et roues : assemble une vraie locomotive. Un conducteur "
		.. "agréé saura la mettre sur les rails.",
	hint = "Fabrique d'abord la chaudière, la cheminée et le poste de conduite.",
	trigger = { type = "craft", items = { "advtrains:newlocomotive" } },
	requires = { "ch11.rail_forge", "ch11.signalman", "ch11.first_journey" }, mods = { "advtrains" },
	reward = { items = { "default:gold_ingot 2" }, title = "Âme du rail" },
})
