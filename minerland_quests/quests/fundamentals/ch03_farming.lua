-- Chapitre 3 — Les joies de l'agriculture (farming redo de TenPlus1).
-- Labour et semis passent par core.set_node (farming/hoes.lua:78, init.lua place_seed) : détectés par
-- l'intégration integrations/farming.lua (clés farming:till et farming:sow).
local Q = minerland_quests
local CROPS = { "farming:carrot_8", "farming:potato_4", "farming:tomato_8", "farming:corn_8",
	"farming:cucumber_4", "farming:pumpkin_8", "farming:melon_8", "farming:onion_5", "farming:garlic_5",
	"farming:barley_8", "farming:rice_8", "farming:beanpole_5", "farming:cotton_8" }

Q.register_quest({
	id = "ch03.hoe", title = "La houe, amie du jardinier", difficulty = 1, icon = "farming:hoe_wood",
	description = "Avant de semer, il faut retourner la terre. Et pour ça, rien ne vaut une bonne houe.",
	hint = "Deux planches (ou pavés, ou lingots) et deux bâtons.",
	trigger = { type = "craft", items = { "farming:hoe_wood", "farming:hoe_stone", "farming:hoe_steel" } },
	mods = { "farming" },
	reward = { items = { "farming:seed_wheat 8" } },
})
Q.register_quest({
	id = "ch03.till", title = "Retourner la terre", difficulty = 1, icon = "farming:soil",
	description = "Un coup de houe sur la terre près de l'eau, et le sol devient fertile.",
	objective = "Labourer de la terre avec une houe.",
	hint = "Clic gauche avec la houe sur de la terre (avec ou sans herbe), idéalement à moins de 3 blocs d'eau.",
	trigger = { type = "custom", key = "farming:till" },
	requires = { "ch03.hoe" }, mods = { "farming" },
	reward = { items = { "bucket:bucket_empty 1" } },
})
Q.register_quest({
	id = "ch03.sow", title = "Petite graine deviendra grande", difficulty = 1, icon = "farming:seed_wheat",
	description = "Sème une graine dans ta terre labourée… et sois patient.",
	objective = "Semer une graine sur de la terre labourée.",
	hint = "Les graines de blé s'obtiennent en arrachant les hautes herbes.",
	trigger = { type = "custom", key = "farming:sow" },
	requires = { "ch03.till" }, mods = { "farming" },
	reward = { items = { "farming:seed_cotton 4" } },
})
Q.register_quest({
	id = "ch03.wheat", title = "Moisson dorée", difficulty = 1, icon = "farming:wheat",
	description = "Le blé est mûr, ses épis dorés ondulent sous le vent. C'est l'heure de la moisson !",
	hint = "Récolte des plants de blé arrivés à maturité (stade 8).",
	trigger = { type = "dig", items = { "farming:wheat_8" }, count = 5 },
	requires = { "ch03.sow" }, mods = { "farming" },
	reward = { items = { "farming:bread 3" } },
})
Q.register_quest({
	id = "ch03.varieties", title = "Un potager varié", difficulty = 2, icon = "farming:carrot",
	description = "Carottes, tomates, maïs, potirons… Un vrai jardinier ne cultive pas qu'une seule plante.",
	hint = "Récolte des légumes mûrs : carottes, pommes de terre, tomates, maïs, concombres, oignons…",
	trigger = { type = "dig", items = CROPS, count = 5 },
	requires = { "ch03.wheat" }, mods = { "farming" },
	reward = { items = { "default:steel_ingot 1" } },
})
Q.register_quest({
	id = "ch03.flour", title = "Le moulin à bras", difficulty = 2, icon = "farming:flour",
	description = "Du blé, un mortier, de l'huile de coude : voilà de la farine.",
	hint = "Fabrique d'abord un mortier et pilon (pierre + bâton), puis broie du blé dans la grille.",
	trigger = { type = "craft", items = { "farming:flour" } },
	requires = { "ch03.wheat" }, mods = { "farming" },
	reward = { items = { "default:apple 5" } },
})
Q.register_quest({
	id = "ch03.bread", title = "Le pain de la maison", difficulty = 2, icon = "farming:bread",
	description = "Cuis ta farine au fourneau et goûte le fruit de ton travail. Croustillant !",
	hint = "Mets la farine dans un fourneau allumé, puis mange un morceau de pain.",
	trigger = { type = "eat", items = { "farming:bread" } },
	requires = { "ch03.flour" }, mods = { "farming" },
	reward = { items = { "farming:seed_wheat 4", "default:torch 6" } },
})
Q.register_quest({
	id = "ch03.recipe", title = "Chef de la ferme", difficulty = 3, icon = "farming:salad", final = true,
	description = "Salade, jus de carotte, popcorn ou salade de pommes de terre : signe ta première recette élaborée.",
	hint = "Ces recettes demandent des ustensiles de farming (planche à découper, presse-agrumes, casserole, bol).",
	trigger = { type = "craft", items = { "farming:salad", "farming:carrot_juice", "farming:potato_salad",
		"farming:popcorn" } },
	requires = { "ch03.varieties", "ch03.bread" }, mods = { "farming" },
	reward = { items = { "default:gold_ingot 1" }, title = "Main verte" },
})
