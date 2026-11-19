-- Chapitre 7 — Les petits plats dans les grands (farming, canned_food, bbq, wine, drinks, food, ethereal).
-- Audit : docs/audit/ch07_ch08.md. La faim est désactivée : la cuisine est une découverte, pas une obligation.
-- Détectable : fabrication en grille, pose des appareils, consommation (item_eat). Non détectable sans adaptateur :
-- cuisson au four, au gril ou au fumoir, fermentation au fût, pressoir (aucun craft) → remplacées par la pose de
-- l'appareil puis par une recette de grille qui utilise le produit cuit.
local Q = minerland_quests

Q.register_quest({
	id = "ch07.kitchenware", title = "Batterie de cuisine", difficulty = 1, icon = "farming:skillet",
	description = "Une casserole, une poêle ou une planche à découper : pas de bon plat sans bons ustensiles.",
	hint = "Les ustensiles se fabriquent avec de l'acier, de l'argile, du verre ou du bois.",
	trigger = { type = "craft", items = { "farming:saucepan", "farming:pot", "farming:skillet", "farming:cutting_board",
		"farming:juicer", "farming:mixing_bowl", "farming:baking_tray" } },
	requires = { "ch03.wheat" }, mods = { "farming" },
	reward = { items = { "farming:salt 4", "farming:tomato 3" } },
})
Q.register_quest({
	id = "ch07.jam", title = "Mise en bocal", difficulty = 1, icon = "canned_food:apple_jam",
	description = "Des pommes, une bouteille… et voilà une confiture maison qui se garde tout l'hiver.",
	hint = "Trois pommes et une bouteille en verre. Myrtilles, roses, tomates ou carottes marchent aussi.",
	trigger = { type = "craft", items = { "canned_food:apple_jam", "canned_food:wild_blueberry_jam",
		"canned_food:dandelion_jam", "canned_food:rose_jam", "canned_food:canned_tomato", "canned_food:canned_carrot",
		"canned_food:canned_mushrooms", "canned_food:canned_cucumber", "canned_food:canned_corn" } },
	requires = { "ch07.kitchenware" }, mods = { "canned_food" },
	reward = { items = { "vessels:glass_bottle 4" } },
})
Q.register_quest({
	id = "ch07.bbq_grill", title = "Allumer le barbecue", difficulty = 2, icon = "bbq:kettle_grill",
	description = "Un barbecue dans le jardin, c'est la promesse de grandes tablées entre voisins.",
	hint = "Le barbecue bouilloire demande de l'acier et du charbon de bois (un tronc et une torche).",
	trigger = { type = "place", items = { "bbq:kettle_grill", "bbq:propane_grill", "bbq:propane_grill_pro",
		"bbq:smoker" } },
	requires = { "ch07.kitchenware" }, mods = { "bbq" },
	reward = { items = { "bbq:charcoal_lump 6" } },
})
Q.register_quest({
	id = "ch07.burger", title = "Le burger du chef", difficulty = 2, icon = "bbq:hamburger",
	description = "Un steak grillé, du bon pain : le burger de Minerland est servi !",
	hint = "Fais griller une galette de bœuf sur le barbecue, puis assemble-la avec du pain.",
	trigger = { type = "craft", items = { "bbq:hamburger", "bbq:bacon_cheeseburger", "bbq:hotdog" } },
	requires = { "ch07.bbq_grill" }, mods = { "bbq" },
	reward = { items = { "farming:bread 3" } },
})
Q.register_quest({
	id = "ch07.barrel", title = "La cave du domaine", difficulty = 2, icon = "wine:wine_barrel",
	description = "Un fût de chêne au frais : raisin, pommes ou miel y deviennent de délicieuses boissons.",
	hint = "Le fût se fabrique avec du bois, des planches et du fer.",
	trigger = { type = "place", items = { "wine:wine_barrel" } },
	requires = { "ch07.kitchenware" }, mods = { "wine" },
	reward = { items = { "farming:grapes 6" } },
})
Q.register_quest({
	id = "ch07.drink", title = "À votre santé !", difficulty = 2, icon = "vessels:drinking_glass",
	description = "Limonade, jus de pomme, cidre ou grand cru : trinquons à Minerland !",
	hint = "Les boissons du fût se servent dans des verres. Avec modération pour celles qui en contiennent !",
	trigger = { type = "eat", items = { "ethereal:lemonade", "food:apple_juice", "drinks:jcu_apple",
		"wine:glass_sparkling_apple_juice", "wine:glass_kefir", "wine:glass_cider", "wine:glass_wine", "bbq:beer" } },
	requires = { "ch07.barrel" },
	reward = { items = { "vessels:drinking_glass 4" } },
})
Q.register_quest({
	id = "ch07.juice_press", title = "Pressé comme un citron", difficulty = 2, icon = "drinks:juice_press",
	description = "Le pressoir transforme fruits et légumes en jus bien frais. À installer dans toute bonne cuisine.",
	trigger = { type = "place", items = { "drinks:juice_press" } },
	requires = { "ch07.barrel" }, mods = { "drinks" },
	reward = { items = { "vessels:glass_bottle 4" } },
})
Q.register_quest({
	id = "ch07.grand_dish", title = "Banquet de Minerland", difficulty = 3, icon = "farming:blueberry_pie",
	final = true,
	description = "Salade, tarte aux myrtilles, ragoût ou burger maison : prépare le plat qui fera la réputation de ta "
		.. "table.",
	hint = "La plupart de ces recettes demandent des ustensiles : casserole, planche à découper, saladier…",
	trigger = { type = "craft", items = { "farming:salad", "farming:burger", "farming:blueberry_pie",
		"ethereal:hearty_stew", "farming:spanish_potatoes" } },
	requires = { "ch07.burger", "ch07.drink" },
	reward = { items = { "default:gold_ingot 1" }, title = "Toque d'or" },
})
