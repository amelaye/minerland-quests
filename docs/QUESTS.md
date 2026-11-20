# Catalogue des quêtes

> Fichier **généré** par `python3 tools/gen_docs.py` (ou `make docs`). Ne pas modifier à la main.

Version du mod : 1.0.0 — 193 quêtes, 25 chapitres.

## Partie I — Les Fondamentaux

*Premiers pas, premier toit, premières richesses*

### Chapitre 1 — Bienvenue à Minerland (7 quêtes)

Bienvenue, voyageur ! Avant de bâtir des cathédrales et des trains, il faut savoir manier la hache. Ce chapitre t'apprend les gestes de base : couper, fabriquer, ranger.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch01.first_log` | Bûcheron du dimanche | Minage (creuser) : groupe `tree` | — | `default:apple 3` | Minage (creuser) | — |
| `ch01.planks` | Des planches, encore des planches | Fabrication : groupe `wood` ×4 | Bûcheron du dimanche (`ch01.first_log`) | `default:torch 4` | Fabrication | — |
| `ch01.sticks` | Bâton de pèlerin | Fabrication : `default:stick` | Des planches, encore des planches (`ch01.planks`) | `default:coal_lump 4` | Fabrication | — |
| `ch01.first_tool` | Mon premier outil | Fabrication : `default:pick_wood`, `default:pick_stone`, `default:axe_wood`, `default:axe_stone`, `default:shovel_wood`, `default:shovel_stone` | Bâton de pèlerin (`ch01.sticks`) | `default:torch 8` | Fabrication | — |
| `ch01.chest_craft` | Un coffre pour mes trésors | Fabrication : `default:chest` | Des planches, encore des planches (`ch01.planks`) | `default:paper 3` | Fabrication | — |
| `ch01.chest_place` | Chaque chose à sa place | Pose de bloc : `default:chest` | Un coffre pour mes trésors (`ch01.chest_craft`) | `default:book 1` | Pose de bloc | — |
| `ch01.furnace` | Le feu sacré ★ | Pose de bloc : `default:furnace` | Mon premier outil (`ch01.first_tool`), Chaque chose à sa place (`ch01.chest_place`) | `default:steel_ingot 2`, titre « Apprenti de Minerland » | Pose de bloc | — |

### Chapitre 2 — Mon premier chez-moi (7 quêtes)

Un toit, une porte, un lit et une lampe : voilà de quoi se sentir chez soi. Et n'oublie pas de protéger ton terrain, la Reine y tient !

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch02.door_craft` | On ne rentre pas sans frapper | Fabrication : `doors:door_wood`, `doors:door_glass`, `doors:door_steel` | Des planches, encore des planches (`ch01.planks`) | `default:glass 6` | Fabrication | doors |
| `ch02.door_place` | Pas de porte, pas de chez-soi | Pose de bloc : `doors:door_wood_a`, `doors:door_wood_b`, `doors:door_glass_a`, `doors:door_glass_b`, `doors:door_steel_a`, `doors:door_steel_b` | On ne rentre pas sans frapper (`ch02.door_craft`) | `default:torch 8` | Pose de bloc | doors |
| `ch02.bed` | Au lit, les marmottes ! | Fabrication : `beds:bed`, `beds:fancy_bed`, `beds:bed_bottom`, `beds:fancy_bed_bottom` | Des planches, encore des planches (`ch01.planks`) | `default:bookshelf 1` | Fabrication | beds |
| `ch02.light` | Que la lumière soit | Pose de bloc : `default:torch`, `default:torch_wall`, `default:torch_ceiling` ×3 | Pas de porte, pas de chez-soi (`ch02.door_place`) | `default:coal_lump 6` | Pose de bloc | — |
| `ch02.protector` | Propriété privée | Pose de bloc : `protector:protect`, `protector:protect2` | Pas de porte, pas de chez-soi (`ch02.door_place`) | `default:gold_ingot 1` | Pose de bloc | protector |
| `ch02.furniture` | Un intérieur qui a du chien | Pose de bloc : `default:bookshelf`, `default:sign_wall_wood`, `default:fence_wood` | Au lit, les marmottes ! (`ch02.bed`) | `default:book 2` | Pose de bloc | — |
| `ch02.locked_chest` | Mon coffre-fort ★ | Pose de bloc : `default:chest_locked` | Que la lumière soit (`ch02.light`), Propriété privée (`ch02.protector`), Un intérieur qui a du chien (`ch02.furniture`) | `default:steel_ingot 3`, titre « Propriétaire terrien » | Pose de bloc | — |

### Chapitre 3 — Les joies de l'agriculture (8 quêtes)

La faim est désactivée à Minerland, mais rien ne vaut un potager bien tenu. Bêche, sème, récolte… et transforme tes récoltes en bons produits.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch03.hoe` | La houe, amie du jardinier | Fabrication : `farming:hoe_wood`, `farming:hoe_stone`, `farming:hoe_steel` | — | `farming:seed_wheat 8` | Fabrication | farming |
| `ch03.till` | Retourner la terre | Labourer de la terre avec une houe. | La houe, amie du jardinier (`ch03.hoe`) | `bucket:bucket_empty 1` | Intégration `farming:till` | farming |
| `ch03.sow` | Petite graine deviendra grande | Semer une graine sur de la terre labourée. | Retourner la terre (`ch03.till`) | `farming:seed_cotton 4` | Intégration `farming:sow` | farming |
| `ch03.wheat` | Moisson dorée | Minage (creuser) : `farming:wheat_8` ×5 | Petite graine deviendra grande (`ch03.sow`) | `farming:bread 3` | Minage (creuser) | farming |
| `ch03.varieties` | Un potager varié | Minage (creuser) : `farming:carrot_8`, `farming:potato_4`, `farming:tomato_8`, `farming:corn_8`, `farming:cucumber_4`, `farming:pumpkin_8`, `farming:melon_8`, `farming:onion_5`, `farming:garlic_5`, `farming:barley_8`, `farming:rice_8`, `farming:beanpole_5`, `farming:cotton_8` ×5 | Moisson dorée (`ch03.wheat`) | `default:steel_ingot 1` | Minage (creuser) | farming |
| `ch03.flour` | Le moulin à bras | Fabrication : `farming:flour` | Moisson dorée (`ch03.wheat`) | `default:apple 5` | Fabrication | farming |
| `ch03.bread` | Le pain de la maison | Dégustation : `farming:bread` | Le moulin à bras (`ch03.flour`) | `farming:seed_wheat 4`, `default:torch 6` | Dégustation | farming |
| `ch03.recipe` | Chef de la ferme ★ | Fabrication : `farming:salad`, `farming:carrot_juice`, `farming:potato_salad`, `farming:popcorn` | Un potager varié (`ch03.varieties`), Le moulin à bras (`ch03.flour`) | `default:gold_ingot 1`, titre « Main verte » | Fabrication | farming |

### Chapitre 4 — Les trésors de la terre (10 quêtes)

Sous tes pieds dorment le fer, l'or, le diamant et la mystérieuse Mese. Prends ta pioche et descends : certaines richesses ne demandent qu'à être découvertes.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch04.coal` | Gueules noires | Minage (creuser) : `default:stone_with_coal` ×3 | Mon premier outil (`ch01.first_tool`) | `default:torch 8` | Minage (creuser) | — |
| `ch04.iron` | L'âge du fer | Minage (creuser) : `default:stone_with_iron` | Gueules noires (`ch04.coal`) | `default:coal_lump 8` | Minage (creuser) | — |
| `ch04.copper_tin` | Cuivre et étain | Minage (creuser) : `default:stone_with_copper`, `default:stone_with_tin` ×2 | Gueules noires (`ch04.coal`) | `default:steel_ingot 1` | Minage (creuser) | — |
| `ch04.steel_pick` | Une pioche qui en jette | Fabrication : `default:pick_steel`, `default:pick_bronze` | L'âge du fer (`ch04.iron`) | `default:shovel_steel 1` | Fabrication | — |
| `ch04.silver` | Reflets d'argent | Minage (creuser) : `moreores:mineral_silver` | L'âge du fer (`ch04.iron`) | `default:copper_ingot 3` | Minage (creuser) | moreores |
| `ch04.gold_rush` | La ruée vers l'or | Minage (creuser) : `default:stone_with_gold` | Une pioche qui en jette (`ch04.steel_pick`) | `default:steel_ingot 3` | Minage (creuser) | — |
| `ch04.mese` | La pierre qui brille | Minage (creuser) : `default:stone_with_mese` | Une pioche qui en jette (`ch04.steel_pick`) | `default:gold_ingot 1` | Minage (creuser) | — |
| `ch04.gems` | Pierres précieuses | Minage (creuser) : `glooptest:mineral_ruby`, `glooptest:mineral_sapphire`, `glooptest:mineral_emerald`, `glooptest:mineral_topaz`, `glooptest:mineral_amethyst` | Une pioche qui en jette (`ch04.steel_pick`) | `default:gold_lump 2` | Minage (creuser) | glooptest |
| `ch04.diamond` | Diamants sur canapé | Minage (creuser) : `default:stone_with_diamond` | La ruée vers l'or (`ch04.gold_rush`) | `default:mese_crystal 1` | Minage (creuser) | — |
| `ch04.mithril` | Le métal des légendes ★ | Minage (creuser) : `moreores:mineral_mithril` | Diamants sur canapé (`ch04.diamond`), Reflets d'argent (`ch04.silver`) | `default:diamond 1`, titre « Maître mineur » | Minage (creuser) | moreores |

### Chapitre 5 — Les anneaux du ciel (8 quêtes)

Goops a forgé des anneaux merveilleux : voler, résister au feu, respirer sous l'eau, briller… Un anneau se porte comme une armure ; c'est l'Anneau d'activation, tenu en main, qui le réveille pour un temps limité.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch05.gems` | Des pierres pour un anneau | Fabrication : `goops_rings:mismatched_gems` | Pierres précieuses (`ch04.gems`) | `moreores:silver_lump 2` | Fabrication | goops_rings, glooptest |
| `ch05.activation` | L'anneau qui les commande | Fabrication : `goops_rings:activation_ring` | Pierres précieuses (`ch04.gems`) | `default:gold_lump 2` | Fabrication | goops_rings |
| `ch05.first_ring` | Bague au doigt | Fabrication : `goops_rings:celestial_ring1`, `goops_rings:infernal_ring1`, `goops_rings:abyssal_ring1`, `goops_rings:enlightning_ring1`, `goops_rings:hardening_ring1` | Pierres précieuses (`ch04.gems`) | `default:gold_lump 2` | Fabrication | goops_rings |
| `ch05.equip` | Comme une armure | Équiper un anneau dans l'inventaire d'armure. | Bague au doigt (`ch05.first_ring`) | `default:mese_crystal_fragment 4` | Intégration `rings:equip` | goops_rings, 3d_armor |
| `ch05.activate` | Que la magie opère | Activer un anneau porté avec l'Anneau d'activation. | Comme une armure (`ch05.equip`), L'anneau qui les commande (`ch05.activation`) | `default:gold_ingot 1` | Intégration `rings:activate` | goops_rings |
| `ch05.celestial` | Un éclat du ciel | Fabrication : `goops_rings:celestial_ring1` | Bague au doigt (`ch05.first_ring`) | `glooptest:amethyst_gem 1` | Fabrication | goops_rings |
| `ch05.flight` | Les ailes du ciel | Voler grâce à l'Anneau céleste activé. | Un éclat du ciel (`ch05.celestial`), Que la magie opère (`ch05.activate`) | `default:mese_crystal 1` | Intégration `rings:flight` | goops_rings |
| `ch05.other_power` | Un pouvoir de plus ★ | Activer un anneau qui n'est pas l'Anneau céleste (infernal, abyssal, lumineux ou durci). | Les ailes du ciel (`ch05.flight`) | `default:diamond 1`, titre « Seigneur des anneaux » | Intégration `rings:activate_other` | goops_rings |

## Partie II — La Vie quotidienne

*Animaux, cuisine, décoration et commerce*

### Chapitre 6 — La ferme aux animaux (8 quêtes)

Vaches, moutons, poules et chevaux n'attendent que ton affection. Apprends à les attirer, à les soigner et à profiter de leurs bienfaits — avec amour, toujours.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch06.net_maker` | Le filet du bon berger | Fabrication : `mobs:net` | Bâton de pèlerin (`ch01.sticks`) | `farming:wheat 6` | Fabrication | mobs |
| `ch06.trusted_friend` | Ami des bêtes | Apprivoiser un animal en le nourrissant. | Moisson dorée (`ch03.wheat`) | `mobs:nametag 1` | Intégration `mobs:tame` | mobs |
| `ch06.honey_hive` | Trois abeilles et un toit | Fabrication : `mobs:beehive` | Le filet du bon berger (`ch06.net_maker`) | `flowers:dandelion_yellow 4`, `flowers:rose 2` | Fabrication | mobs_animal |
| `ch06.hive_home` | La ruche au jardin | Pose de bloc : `mobs:beehive` | Trois abeilles et un toit (`ch06.honey_hive`) | `vessels:glass_bottle 4` | Pose de bloc | mobs_animal |
| `ch06.in_the_net` | Pris au filet | Capturer un animal qui t'appartient. | Le filet du bon berger (`ch06.net_maker`), Ami des bêtes (`ch06.trusted_friend`) | `mobs:fence_wood 8` | Intégration `mobs:capture` | mobs |
| `ch06.fresh_milk` | Un seau de lait tiède | Dégustation : `mobs:bucket_milk` | Ami des bêtes (`ch06.trusted_friend`) | `mobs:cheese 2` | Dégustation | mobs_animal |
| `ch06.saddle_up` | Cuir, acier et patience | Fabrication : `mobs:saddle` | Ami des bêtes (`ch06.trusted_friend`) | `mobs:horseshoe_steel 1` | Fabrication | mobs |
| `ch06.horse_ride` | En selle ! ★ | Monter sur ton cheval. | Cuir, acier et patience (`ch06.saddle_up`) | `mobs:saddle 1`, titre « Légende de l'écurie » | Intégration `rides:horse` | mob_horse |

### Chapitre 7 — Les petits plats dans les grands (8 quêtes)

Ici, on ne cuisine pas pour survivre, mais pour le plaisir ! Barbecue, conserves, jus de fruits et grands crus : à toi les recettes de Minerland.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch07.kitchenware` | Batterie de cuisine | Fabrication : `farming:saucepan`, `farming:pot`, `farming:skillet`, `farming:cutting_board`, `farming:juicer`, `farming:mixing_bowl`, `farming:baking_tray` | Moisson dorée (`ch03.wheat`) | `farming:salt 4`, `farming:tomato 3` | Fabrication | farming |
| `ch07.jam` | Mise en bocal | Fabrication : `canned_food:apple_jam`, `canned_food:wild_blueberry_jam`, `canned_food:dandelion_jam`, `canned_food:rose_jam`, `canned_food:canned_tomato`, `canned_food:canned_carrot`, `canned_food:canned_mushrooms`, `canned_food:canned_cucumber`, `canned_food:canned_corn` | Batterie de cuisine (`ch07.kitchenware`) | `vessels:glass_bottle 4` | Fabrication | canned_food |
| `ch07.bbq_grill` | Allumer le barbecue | Pose de bloc : `bbq:kettle_grill`, `bbq:propane_grill`, `bbq:propane_grill_pro`, `bbq:smoker` | Batterie de cuisine (`ch07.kitchenware`) | `bbq:charcoal_lump 6` | Pose de bloc | bbq |
| `ch07.burger` | Le burger du chef | Fabrication : `bbq:hamburger`, `bbq:bacon_cheeseburger`, `bbq:hotdog` | Allumer le barbecue (`ch07.bbq_grill`) | `farming:bread 3` | Fabrication | bbq |
| `ch07.barrel` | La cave du domaine | Pose de bloc : `wine:wine_barrel` | Batterie de cuisine (`ch07.kitchenware`) | `farming:grapes 6` | Pose de bloc | wine |
| `ch07.drink` | À votre santé ! | Dégustation : `ethereal:lemonade`, `food:apple_juice`, `drinks:jcu_apple`, `wine:glass_sparkling_apple_juice`, `wine:glass_kefir`, `wine:glass_cider`, `wine:glass_wine`, `bbq:beer` | La cave du domaine (`ch07.barrel`) | `vessels:drinking_glass 4` | Dégustation | — |
| `ch07.juice_press` | Pressé comme un citron | Pose de bloc : `drinks:juice_press` | La cave du domaine (`ch07.barrel`) | `vessels:glass_bottle 4` | Pose de bloc | drinks |
| `ch07.grand_dish` | Banquet de Minerland ★ | Fabrication : `farming:salad`, `farming:burger`, `farming:blueberry_pie`, `ethereal:hearty_stew`, `farming:spanish_potatoes` | Le burger du chef (`ch07.burger`), À votre santé ! (`ch07.drink`) | `default:gold_ingot 1`, titre « Toque d'or » | Fabrication | — |

### Chapitre 8 — L'art de la décoration (9 quêtes)

Une maison sans meubles, c'est une grotte avec une porte. Scies, tables, lampes et coussins : fais de ton foyer le plus douillet du royaume.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch08.workbench` | L'atelier du décorateur | Fabrication : `xdecor:workbench` | Des planches, encore des planches (`ch01.planks`) | `default:wood 16` | Fabrication | xdecor |
| `ch08.saw` | Menuisier de précision | Fabrication : `moreblocks:circular_saw` | Des planches, encore des planches (`ch01.planks`) | `default:tree 6` | Fabrication | moreblocks |
| `ch08.light` | Une lueur chaleureuse | Pose de bloc : `xdecor:lantern`, `xdecor:lantern_hanging`, `xdecor:candle`, `homedecor:candle`, `homedecor:oil_lamp`, `homedecor:oil_lamp_tabletop` | L'atelier du décorateur (`ch08.workbench`) | `default:glass 6` | Pose de bloc | — |
| `ch08.seat` | Une chaise pour souffler | Pose de bloc : `xdecor:chair`, `xdecor:cushion`, `homedecor:kitchen_chair_wood`, `homedecor:armchair` | L'atelier du décorateur (`ch08.workbench`) | `wool:white 4` | Pose de bloc | — |
| `ch08.table` | Mettre la table | Pose de bloc : `xdecor:table` | L'atelier du décorateur (`ch08.workbench`) | `vessels:drinking_glass 2` | Pose de bloc | xdecor |
| `ch08.stairs` | Monter d'un étage | Fabrication : `moreblocks:stair_wood` | Menuisier de précision (`ch08.saw`) | `default:sign_wall_wood 2` | Fabrication | moreblocks |
| `ch08.window` | Une vue imprenable | Pose de bloc : `xdecor:woodframed_glass`, `homedecor:window_quartered` | Une lueur chaleureuse (`ch08.light`) | `dye:blue 2`, `dye:red 2` | Pose de bloc | — |
| `ch08.textiles` | Tapis et rideaux | Pose de bloc : `homedecor:rug_small`, `homedecor:rug_persian`, `homedecor:rug_large`, `homedecor:curtain_open`, `xdecor:curtain_red` | Une chaise pour souffler (`ch08.seat`) | `default:paper 4` | Pose de bloc | — |
| `ch08.painting` | Une touche d'art ★ | Pose de bloc : `xdecor:painting_1`, `xdecor:painting_2`, `xdecor:painting_3`, `xdecor:painting_4` | Une vue imprenable (`ch08.window`), Tapis et rideaux (`ch08.textiles`), Mettre la table (`ch08.table`) | `default:gold_ingot 1`, titre « Âme d'artiste » | Pose de bloc | xdecor |

### Chapitre 9 — Les affaires sont les affaires (8 quêtes)

Le Minegeld fait tourner le royaume. Ouvre boutique, propose tes marchandises et découvre les rouages de l'économie de Minerland.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch09.small_change` | Faire de la monnaie | Fabrication : `currency:minegeld` | — | `currency:minegeld_5 2` | Fabrication | currency |
| `ch09.safe_keeping` | Un coffre pour mes économies | Fabrication : `currency:safe` | Faire de la monnaie (`ch09.small_change`) | `currency:minegeld_10 1` | Fabrication | currency |
| `ch09.safe_installed` | Le coffre est scellé | Pose de bloc : `currency:safe` | Un coffre pour mes économies (`ch09.safe_keeping`) | `default:steel_ingot 2` | Pose de bloc | currency |
| `ch09.market_stall` | Mon étal d'échange | Pose de bloc : `currency:shop` | Faire de la monnaie (`ch09.small_change`) | `default:sign_wall_wood 2` | Pose de bloc | currency |
| `ch09.smart_crafter` | La boutique intelligente | Fabrication : `smartshop:shop` | — | `default:chest_locked 1` | Fabrication | smartshop |
| `ch09.shop_opening` | Ouverture officielle | Pose de bloc : `smartshop:shop` | La boutique intelligente (`ch09.smart_crafter`) | `currency:minegeld_10 2` | Pose de bloc | smartshop |
| `ch09.first_purchase` | Première affaire conclue | Acheter un article payant dans le Smartshop d'un autre joueur. | Faire de la monnaie (`ch09.small_change`) | `currency:minegeld_10 1` | Intégration `smartshop:purchase` | smartshop |
| `ch09.first_sale` | Le client est roi ★ | Vendre un article payant à un autre joueur dans ton Smartshop, pendant que tu es en ligne. | Ouverture officielle (`ch09.shop_opening`) | `currency:minegeld_50 1`, titre « Sens des affaires » | Intégration `smartshop:sale` | smartshop |

## Partie III — Les Transports

*Routes, rails, ciel, mers et hauteurs*

### Chapitre 10 — Sur les chapeaux de roues ! (9 quêtes)

À bicyclette, en 4L ou en DeLorean : la route est à toi ! Du vélo au carburant vert, apprends à rouler avec style.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch10.first_bike` | Deux roues et un guidon | Fabrication : `bike:bike` | — | `default:tin_ingot 3` | Fabrication | bike |
| `ch10.bike_ride` | En selle, Marcel ! | Monter sur un vélo. | Deux roues et un guidon (`ch10.first_bike`) | `biofuel:phial_fuel 2` | Intégration `rides:bike` | bike |
| `ch10.city_car` | Ma première citadine | Fabrication : `vehicles:masda_spawner`, `vehicles:masda2_spawner`, `vehicles:ute_spawner`, `vehicles:ute2_spawner`, `vehicles:nizzan_spawner`, `vehicles:nizzan2_spawner`, `vehicles:astonmaaton_spawner`, `vehicles:pooshe_spawner`, `vehicles:pooshe2_spawner`, `vehicles:lambogoni_spawner`, `vehicles:lambogoni2_spawner`, `vehicles:fewawi_spawner`, `vehicles:fewawi2_spawner`, `vehicles:musting_spawner`, `vehicles:musting2_spawner`, `vehicles:tractor_spawner`, `vehicles:geep_spawner` | Deux roues et un guidon (`ch10.first_bike`) | `default:steel_ingot 4` | Fabrication | vehicles |
| `ch10.engine` | Le cœur de la machine | Fabrication : `automobiles_lib:engine` | Ma première citadine (`ch10.city_car`) | `default:steel_ingot 6` | Fabrication | automobiles_lib |
| `ch10.first_car` | La doyenne des routes | Fabrication : `automobiles_roadster:roadster`, `automobiles_buggy:buggy`, `automobiles_beetle:beetle`, `automobiles_beetle:beetle_conv`, `automobiles_catrelle:catrelle`, `automobiles_coupe:coupe`, `automobiles_delorean:delorean`, `automobiles_trans_am:trans_am`, `automobiles_motorcycle:motorcycle`, `automobiles_vespa:vespa` | Le cœur de la machine (`ch10.engine`) | `biofuel:bottle_fuel 2` | Fabrication | automobiles_lib |
| `ch10.road_trip` | Plein phares sur la départementale | Conduire une voiture. | La doyenne des routes (`ch10.first_car`) | `biofuel:bottle_fuel 2` | Intégration `rides:car` | — |
| `ch10.refinery` | L'alambic vert | Pose de bloc : `biofuel:refinery` | — | `default:sapling 10` | Pose de bloc | biofuel |
| `ch10.fuel_can` | Un bidon pour la route | Fabrication : `biofuel:fuel_can` | L'alambic vert (`ch10.refinery`) | `biofuel:phial_fuel 4` | Fabrication | biofuel |
| `ch10.delivery_van` | La 4L fourgonnette ★ | Fabrication : `automobiles_catrelle:catrelle_4f` | Plein phares sur la départementale (`ch10.road_trip`), Un bidon pour la route (`ch10.fuel_can`) | `default:steelblock 1`, titre « As du volant » | Fabrication | automobiles_catrelle |

### Chapitre 11 — Le monde ferroviaire (8 quêtes)

Les rails font la fierté de Minerland. Avant de bâtir une ligne (avec l'accord de l'administration et les conseils du Grand Maître des trains), apprends à fabriquer voies, signaux et matériel roulant.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch11.wheelwright` | Le charron du rail | Fabrication : `advtrains:wheel` | — | `default:steel_ingot 2` | Fabrication | advtrains |
| `ch11.rail_forge` | Cinquante rails pour la Compagnie | Fabrication : `advtrains:dtrack_placer`, `advtrains:dtrack_tieless_placer` | Le charron du rail (`ch11.wheelwright`) | `default:steel_ingot 3` | Fabrication | advtrains |
| `ch11.signalman` | Rouge, vert… en avant ! | Fabrication : `advtrains:signal_wall_l_off`, `advtrains_signals_ks:hs_danger_0` | Le charron du rail (`ch11.wheelwright`) | `default:mese_crystal_fragment 3` | Fabrication | advtrains |
| `ch11.platform` | Attention à la marche | Pose de bloc : `advtrains:platform_high_stonebrick` | — | `default:stonebrick 16` | Pose de bloc | advtrains |
| `ch11.ticket_office` | Le guichet de la gare | Pose de bloc : `farebox:farebox`, `farebox:faregate` | Attention à la marche (`ch11.platform`) | `currency:minegeld_5 2` | Pose de bloc | farebox |
| `ch11.old_mine` | Les rails oubliés | Minage (creuser) : `carts:rail` | — | `default:torch 10` | Minage (creuser) | — |
| `ch11.first_journey` | En voiture ! | Voyager dans une voiture de voyageurs d'un train. | — | `default:gold_ingot 1` | Intégration `rides:train` | advtrains |
| `ch11.steam_engine` | La locomotive à vapeur ★ | Fabrication : `advtrains:newlocomotive` | Cinquante rails pour la Compagnie (`ch11.rail_forge`), Rouge, vert… en avant ! (`ch11.signalman`), En voiture ! (`ch11.first_journey`) | `default:gold_ingot 2`, titre « Âme du rail » | Fabrication | advtrains |

### Chapitre 12 — Métros et tramways (7 quêtes)

Le transport urbain a ses codes : quais, signalétique, tramways qui serpentent entre les maisons. Dessine les stations de demain.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch12.subway_sign` | Le M qui brille | Fabrication : `trainblocks:subwayblock` | — | `default:glass 4` | Fabrication | trainblocks |
| `ch12.line_number` | Ligne 1, direction Minerland | Fabrication : `trainblocks:line1` | Le M qui brille (`ch12.subway_sign`) | `default:stonebrick 8` | Fabrication | trainblocks |
| `ch12.platform_number` | Quai numéro un | Pose de bloc : `trainblocks:platformsign1` | Ligne 1, direction Minerland (`ch12.line_number`) | `default:torch 6` | Pose de bloc | trainblocks |
| `ch12.station_hall` | Le hall de la station | Pose de bloc : `trainblocks:station_block` | Le M qui brille (`ch12.subway_sign`) | `default:meselamp 1` | Pose de bloc | trainblocks |
| `ch12.sign_writer` | L'imprimerie des panneaux | Fabrication : `metrosigns:sign_writer` | — | `default:steel_ingot 2` | Fabrication | metrosigns |
| `ch12.tram_template` | Le gabarit du tramway | Fabrication : `minitram_crafting_recipes:minitram_template` | — | `default:steel_ingot 4` | Fabrication | minitram_crafting_recipes |
| `ch12.metro_ride` | Prendre le métro ★ | Voyager dans un métro, un tramway ou un bus. | Le hall de la station (`ch12.station_hall`), Le gabarit du tramway (`ch12.tram_template`) | `default:gold_ingot 1`, titre « Ticket gagnant » | Intégration `rides:metro` | — |

### Chapitre 13 — Les fous volants (8 quêtes)

Minerland est une terre d'aviateurs ! Deltaplane, Super Cub, PA-28, Ju 52 ou hydravion : fabrique ton appareil… et demande à Luffy de te faire passer ton brevet.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch13.windsock` | D'où vient le vent ? | Fabrication : `airutils:wind` | — | `default:steel_ingot 2` | Fabrication | airutils |
| `ch13.papi` | Les feux de la piste | Fabrication : `airutils:papi` | D'où vient le vent ? (`ch13.windsock`) | `default:glass 4` | Fabrication | airutils |
| `ch13.glider_craft` | Des ailes de toile | Fabrication : `hangglider:hangglider` | — | `wool:white 3` | Fabrication | hangglider |
| `ch13.first_glide` | Le grand saut | Planer en deltaplane. | Des ailes de toile (`ch13.glider_craft`) | `default:steel_ingot 2` | Intégration `hangglider:glide` | hangglider |
| `ch13.cub_wings` | Une aile pour le Super Cub | Fabrication : `supercub:wings` | — | `default:steel_ingot 3` | Fabrication | supercub |
| `ch13.repair_kit` | La caisse à outils du mécano | Fabrication : `airutils:repair_tool` | — | `default:steel_ingot 2` | Fabrication | airutils |
| `ch13.first_plane` | Mon premier coucou | Fabrication : `supercub:supercub`, `ju52:ju52`, `pa28:pa28`, `hidroplane:hidro` | Une aile pour le Super Cub (`ch13.cub_wings`) | `biofuel:fuel_can 1` | Fabrication | airutils |
| `ch13.board_plane` | Embarquement immédiat ★ | Monter à bord d'un avion. | Mon premier coucou (`ch13.first_plane`), Le grand saut (`ch13.first_glide`) | `default:gold_ingot 2`, titre « Ailes de Minerland » | Intégration `rides:aviation` | — |

### Chapitre 14 — Larguez les amarres ! (7 quêtes)

Mers, lacs et rivières n'attendent que ta proue. Bateau à moteur, chalutier ou sous-marin Nautilus : hissez haut !

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch14.hull` | Une coque qui flotte | Fabrication : `motorboat:hull` | — | `default:steel_ingot 3` | Fabrication | motorboat |
| `ch14.fuel_bottle` | Plein d'essence verte | Fabrication : `biofuel:bottle_fuel` | — | `default:tin_ingot 2` | Fabrication | biofuel |
| `ch14.ferry_ride` | Passager du ferry | Voyager à bord d'un ferry. | — | `biofuel:phial_fuel 2` | Intégration `rides:ferry` | — |
| `ch14.motorboat` | Moteur, ça tourne ! | Fabrication : `motorboat:boat` | Une coque qui flotte (`ch14.hull`) | `biofuel:fuel_can 1` | Fabrication | motorboat |
| `ch14.fishing_boat` | Le chalutier de la baie | Fabrication : `fishing_boat:boat` | Une coque qui flotte (`ch14.hull`) | `default:steel_ingot 4` | Fabrication | fishing_boat |
| `ch14.nautilus` | Vingt mille lieues sous les blocs | Fabrication : `nautilus:boat_wooden`, `nautilus:boat` | Une coque qui flotte (`ch14.hull`) | `default:gold_ingot 2` | Fabrication | nautilus |
| `ch14.board_boat` | Capitaine à bord ★ | Monter à bord d'un bateau ou d'un sous-marin. | Une coque qui flotte (`ch14.hull`), Plein d'essence verte (`ch14.fuel_bottle`) | `default:gold_ingot 2`, titre « Pied marin » | Intégration `rides:boat` | — |

### Chapitre 15 — Prenons de la hauteur ! (7 quêtes)

Télésièges, ascenseurs réalistes et cabines de téléportation : grimper n'a jamais été aussi confortable. Les tutoriels de l'Académie t'attendent.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch15.steel_rope` | Le câble du téléphérique | Fabrication : `chair_lift:steel_rope` | — | `default:steel_ingot 3` | Fabrication | chair_lift |
| `ch15.pylon` | Le premier pylône | Pose de bloc : `chair_lift:pole_body`, `chair_lift:pole_arm_end`, `chair_lift:wheel_powered` | Le câble du téléphérique (`ch15.steel_rope`) | `default:steel_ingot 2` | Pose de bloc | chair_lift |
| `ch15.chair` | Un siège pour deux skis | Fabrication : `chair_lift:seat` | Le câble du téléphérique (`ch15.steel_rope`) | `wool:white 2` | Fabrication | chair_lift |
| `ch15.chair_ride` | Les pieds dans le vide | Monter sur un siège de télésiège. | Un siège pour deux skis (`ch15.chair`) | `default:mese_crystal_fragment 4` | Intégration `rides:chairlift` | chair_lift |
| `ch15.lift_controller` | Le cerveau de l'ascenseur | Pose de bloc : `celevator:controller`, `celevator:car_standard`, `elevator:elevator_off` | — | `default:copper_ingot 4` | Pose de bloc | — |
| `ch15.travelnet` | La boîte à téléporter | Pose de bloc : `travelnet:travelnet`, `travelnet:elevator`, `locked_travelnet:travelnet` | — | `default:mese_crystal_fragment 4` | Pose de bloc | — |
| `ch15.lift_ride` | Dernier étage, on descend ! ★ | Monter dans une cabine d'ascenseur. | Le cerveau de l'ascenseur (`ch15.lift_controller`), Les pieds dans le vide (`ch15.chair_ride`) | `default:gold_ingot 1`, titre « Tête dans les nuages » | Intégration `rides:elevator` | — |

## Partie IV — Sciences et Technologies

*Électricité, industrie et automatisation*

### Chapitre 16 — L'électricité pour les nuls (7 quêtes)

Un générateur, quelques câbles et hop : la lumière fut ! Premiers pas dans Technic, en toute sécurité.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch16.copper_cable` | Le fil d'Ariane | Fabrication : `technic:lv_cable` | Cuivre et étain (`ch04.copper_tin`) | `default:copper_ingot 3` | Fabrication | technic |
| `ch16.alloy_kiln` | Le four des alchimistes | Fabrication : `technic:coal_alloy_furnace` | Le fil d'Ariane (`ch16.copper_cable`) | `default:coal_lump 8` | Fabrication | technic |
| `ch16.wiring` | Tirer des câbles | Pose de bloc : `technic:lv_cable` ×5 | Le fil d'Ariane (`ch16.copper_cable`) | `default:copper_ingot 2` | Pose de bloc | technic |
| `ch16.casing` | Une carcasse solide | Fabrication : `technic:machine_casing` | Le four des alchimistes (`ch16.alloy_kiln`) | `default:steel_ingot 4` | Fabrication | technic |
| `ch16.generator` | Que la lumière soit ! | Pose de bloc : `technic:lv_generator` | Une carcasse solide (`ch16.casing`) | `default:coal_lump 10` | Pose de bloc | technic |
| `ch16.switching` | Le chef d'orchestre | Pose de bloc : `technic:switching_station` | Que la lumière soit ! (`ch16.generator`), Tirer des câbles (`ch16.wiring`) | `default:steel_ingot 3` | Pose de bloc | technic |
| `ch16.first_machine` | Ma première machine ★ | Pose de bloc : `technic:lv_electric_furnace`, `technic:lv_alloy_furnace`, `technic:lv_grinder`, `technic:lv_extractor`, `technic:lv_compressor` | Le chef d'orchestre (`ch16.switching`) | `default:gold_ingot 1`, titre « Fée électricité » | Pose de bloc | technic |

### Chapitre 17 — La révolution industrielle (8 quêtes)

Broyer, fondre, allier, stocker : tes minerais valent bien plus une fois traités. Bienvenue dans l'industrie lourde de Minerland.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch17.zinc` | Le zinc, cet inconnu | Minage (creuser) : `technic:mineral_zinc` ×3 | Cuivre et étain (`ch04.copper_tin`) | `default:copper_ingot 4` | Minage (creuser) | technic |
| `ch17.iron_chest` | Un coffre de ferrailleur | Fabrication : `technic:iron_chest`, `technic:iron_locked_chest` | L'âge du fer (`ch04.iron`) | `default:steel_ingot 2` | Fabrication | technic |
| `ch17.chromium` | Chrome et paillettes | Minage (creuser) : `technic:mineral_chromium` | L'âge du fer (`ch04.iron`) | `default:steel_ingot 4` | Minage (creuser) | technic |
| `ch17.battery_box` | Mettre l'énergie en boîte | Pose de bloc : `technic:lv_battery_box0` | Le zinc, cet inconnu (`ch17.zinc`) | `default:tin_ingot 3` | Pose de bloc | technic |
| `ch17.grinder` | Moulin à minerai | Pose de bloc : `technic:lv_grinder` | Le zinc, cet inconnu (`ch17.zinc`) | `default:iron_lump 6` | Pose de bloc | technic |
| `ch17.mv_cable` | Monter en tension | Fabrication : `technic:mv_transformer`, `technic:mv_cable` | Chrome et paillettes (`ch17.chromium`) | `default:copper_ingot 4` | Fabrication | technic |
| `ch17.mv_machine` | L'usine moyenne tension | Pose de bloc : `technic:mv_electric_furnace`, `technic:mv_grinder`, `technic:mv_alloy_furnace`, `technic:mv_extractor`, `technic:mv_compressor` | Monter en tension (`ch17.mv_cable`) | `default:gold_ingot 2` | Pose de bloc | technic |
| `ch17.workshop` | L'atelier du réparateur ★ | Pose de bloc : `technic:tool_workshop` | L'usine moyenne tension (`ch17.mv_machine`), Moulin à minerai (`ch17.grinder`), Mettre l'énergie en boîte (`ch17.battery_box`) | `default:gold_ingot 2`, titre « Capitaine d'industrie » | Pose de bloc | technic |

### Chapitre 18 — L'ère de Techage (9 quêtes)

Techage raconte l'histoire de la technique, âge après âge : du charbon de bois aux énergies du futur. Un parcours à part, avec ses propres machines.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch18.ta1_lighter` | Paille et bois sec | Fabrication : `techage:lighter` | — | `default:wood 10` | Fabrication | techage |
| `ch18.ta1_charcoal` | Le charbonnier patient | Minage (creuser) : `techage:charcoal` | Paille et bois sec (`ch18.ta1_lighter`) | `default:coal_lump 6` | Minage (creuser) | techage |
| `ch18.ta1_meltingpot` | Le creuset du forgeron | Pose de bloc : `techage:meltingpot` | Paille et bois sec (`ch18.ta1_lighter`) | `default:copper_ingot 3` | Pose de bloc | techage |
| `ch18.ta1_mill` | Au fil de l'eau | Pose de bloc : `techage:ta1_mill` | Le creuset du forgeron (`ch18.ta1_meltingpot`) | `farming:wheat 8` | Pose de bloc | techage |
| `ch18.ta2_flywheel` | Que la vapeur soit ! | Pose de bloc : `techage:flywheel` | Le creuset du forgeron (`ch18.ta1_meltingpot`) | `default:steel_ingot 3` | Pose de bloc | techage |
| `ch18.ta2_grinder` | Broyer la pierre | Fabrication : `techage:ta2_grinder_pas` | Que la vapeur soit ! (`ch18.ta2_flywheel`) | `default:steel_ingot 2` | Fabrication | techage |
| `ch18.ta3_oil` | L'odeur du pétrole | Pose de bloc : `techage:oilexplorer` | Broyer la pierre (`ch18.ta2_grinder`) | `default:gold_ingot 1` | Pose de bloc | techage |
| `ch18.ta3_robot` | Mon premier robot | Pose de bloc : `signs_bot:box` | L'odeur du pétrole (`ch18.ta3_oil`) | `default:steel_ingot 4` | Pose de bloc | signs_bot |
| `ch18.ta4_solar` | Capter le soleil ★ | Fabrication : `techage:ta4_solar_module` | L'odeur du pétrole (`ch18.ta3_oil`) | `default:gold_ingot 2`, titre « Visionnaire » | Fabrication | techage |

### Chapitre 19 — Les machines intelligentes (7 quêtes)

Circuits, câbles de données, tubes pneumatiques et foreuses géantes : quand tes machines se mettent à penser (presque) toutes seules.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch19.first_wire` | Le fil d'Ariane du mese | Pose de bloc : `mesecons:wire_00000000_off` | — | `default:mese_crystal_fragment 4` | Pose de bloc | mesecons |
| `ch19.first_lamp` | Et la lumière fut (presque) | Pose de bloc : `mesecons_lamp:lamp_off` | Le fil d'Ariane du mese (`ch19.first_wire`) | `default:glass 4` | Pose de bloc | mesecons_lamp |
| `ch19.piston` | Pousse-toi de là ! | Pose de bloc : `mesecons_pistons:piston_normal_off` | Le fil d'Ariane du mese (`ch19.first_wire`) | `default:steel_ingot 2` | Pose de bloc | mesecons_pistons |
| `ch19.sorting_tube` | Le grand tri | Pose de bloc : `pipeworks:mese_tube_000000` | Le fil d'Ariane du mese (`ch19.first_wire`) | `default:steel_ingot 3` | Pose de bloc | pipeworks |
| `ch19.digtron` | Le cœur de la foreuse | Pose de bloc : `digtron:controller` | Le fil d'Ariane du mese (`ch19.first_wire`) | `default:torch 12` | Pose de bloc | digtron |
| `ch19.silicon_brain` | Un cerveau de sable et de mese | Fabrication : `mesecons_luacontroller:luacontroller0000` | Et la lumière fut (presque) (`ch19.first_lamp`) | `default:mese_crystal_fragment 4` | Fabrication | mesecons_luacontroller |
| `ch19.digiline_screen` | Le tableau d'affichage ★ | Pose de bloc : `digilines:lcd` | Un cerveau de sable et de mese (`ch19.silicon_brain`), Pousse-toi de là ! (`ch19.piston`) | `default:gold_ingot 2`, titre « Esprit logique » | Pose de bloc | digilines |

## Partie V — L'Aventure

*Mondes extraordinaires et créatures fabuleuses*

### Chapitre 20 — Les portes de l'Enfer (5 quêtes)

Derrière un cadre d'obsidienne s'ouvre un monde de feu. Allume le portail, récolte ses étranges matériaux et forge des objets venus d'ailleurs.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch20.obsidian` | Le verre des volcans | Minage (creuser) : `default:obsidian` ×4 | Une pioche qui en jette (`ch04.steel_pick`) | `bucket:bucket_empty 1` | Minage (creuser) | — |
| `ch20.mese_fragments` | Éclats de Mese | Fabrication : `default:mese_crystal_fragment` | La pierre qui brille (`ch04.mese`) | `default:obsidian 2` | Fabrication | — |
| `ch20.frame` | Un cadre d'obsidienne | Pose de bloc : `default:obsidian` ×10 | Le verre des volcans (`ch20.obsidian`) | `default:mese_crystal_fragment 2` | Pose de bloc | — |
| `ch20.light_portal` | Une étincelle de Mese | Allumer un portail du Nether. | Un cadre d'obsidienne (`ch20.frame`), Éclats de Mese (`ch20.mese_fragments`) | `default:gold_ingot 1` | Intégration `nether:portal_lit` | nether |
| `ch20.first_rack` | Premiers pas en enfer ★ | Minage (creuser) : `nether:rack` | Une étincelle de Mese (`ch20.light_portal`) | `default:gold_ingot 2`, titre « Cœur de braise » | Minage (creuser) | nether |

### Chapitre 21 — Au plus profond de Minerland (7 quêtes)

Cristaux luminescents, géodes et champignons géants : les profondeurs cachent des merveilles… et quelques trésors oubliés.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch21.glow_gems` | Lueurs dans la mousse | Minage (creuser) : `caverealms:glow_gem` | Une pioche qui en jette (`ch04.steel_pick`) | `default:torch 10` | Minage (creuser) | caverealms |
| `ch21.amethyst_geode` | La géode d'améthyste | Minage (creuser) : `amethyst_new:amethyst` | Une pioche qui en jette (`ch04.steel_pick`) | `default:bronze_ingot 2` | Minage (creuser) | amethyst_new |
| `ch21.cave_mushrooms` | Cueillette souterraine | Minage (creuser) : `caverealms:mycena`, `caverealms:fungus` | Lueurs dans la mousse (`ch21.glow_gems`) | `farming:bread 3` | Minage (creuser) | caverealms |
| `ch21.glow_crystal` | Le cœur des cristaux | Minage (creuser) : `caverealms:glow_crystal`, `caverealms:glow_emerald`, `caverealms:glow_ruby`, `caverealms:glow_amethyst`, `caverealms:glow_mese` | Lueurs dans la mousse (`ch21.glow_gems`) | `default:gold_ingot 1` | Minage (creuser) | caverealms |
| `ch21.amethyst_lantern` | Lanterne de cristal | Pose de bloc : `amethyst_new:lantern` | La géode d'améthyste (`ch21.amethyst_geode`) | `default:bronze_ingot 2` | Pose de bloc | amethyst_new |
| `ch21.glow_bait` | Appâts luisants | Fabrication : `caverealms:glow_bait` | Cueillette souterraine (`ch21.cave_mushrooms`) | `farming:string 4` | Fabrication | caverealms |
| `ch21.ancient_chest` | Le coffre oublié ★ | Minage (creuser) : `lootchests_default:stone_chest`, `lootchests_default:urn`, `lootchests_default:basket`, `lootchests_default:ocean_chest` | Le cœur des cristaux (`ch21.glow_crystal`), La géode d'améthyste (`ch21.amethyst_geode`) | `default:gold_ingot 2`, titre « Cœur de cristal » | Minage (creuser) | lootchests_default |

### Chapitre 22 — Dragons et autres bestioles (8 quêtes)

Des dragons dorment dans les cavernes ! Découvre leurs secrets, leurs écailles et les objets qui permettent de vivre à leurs côtés.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch22.bone_pile` | Un tas d'os bien suspect | Minage (creuser) : `draconis:bone_pile_scorched`, `draconis:bone_pile_frozen` | Une pioche qui en jette (`ch04.steel_pick`) | `default:steel_ingot 3` | Minage (creuser) | draconis |
| `ch22.scorched_stone` | La roche a pris un coup de chaud | Minage (creuser) : `draconis:stone_scorched`, `draconis:stone_frozen` | Un tas d'os bien suspect (`ch22.bone_pile`) | `default:gold_ingot 1` | Minage (creuser) | draconis |
| `ch22.dragon_hoard` | Le magot du dragon | Minage (creuser) : `default:goldblock`, `default:steelblock` | Un tas d'os bien suspect (`ch22.bone_pile`) | `default:torch 12` | Minage (creuser) | draconis |
| `ch22.scorched_bricks` | Maçon des cendres | Fabrication : `draconis:stone_bricks_scorched`, `draconis:stone_bricks_frozen` | La roche a pris un coup de chaud (`ch22.scorched_stone`) | `default:steel_ingot 2` | Fabrication | draconis |
| `ch22.wyvern_ride` | Rodéo dans la canopée | Monter sur une wyverne de la jungle. | — | `default:gold_ingot 1` | Intégration `rides:wyvern` | draconis |
| `ch22.draconic_forge` | La forge des dragons | Pose de bloc : `draconis:draconic_forge_fire`, `draconis:draconic_forge_ice` | Maçon des cendres (`ch22.scorched_bricks`) | `default:gold_ingot 2`, titre « Souffle de dragon » | Pose de bloc | draconis |
| `ch22.dragon_scales` | Écailles de dragon | Abattre un dragon et ramasser ses écailles. | — | `default:gold_ingot 2` | Intégration `draconis:scales_pickup` | draconis |
| `ch22.dragon_egg` | L'œuf du dragon ★ | Abattre un dragon sauvage adulte et ramasser son œuf. | — | `default:diamond 1`, titre « Fléau des dragons » | Intégration `draconis:egg_pickup` | draconis |

### Chapitre 23 — Les mystères du passé (8 quêtes)

Fossiles, ADN et laboratoires : la science de Minerland ressuscite les créatures d'antan. À toi de jouer les paléontologues.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch23.fossil_dig` | Coup de pioche au Jurassique | Minage (creuser) : `paleotest:fossil_block`, `paleotest:suspicious_permafrost` | Mon premier outil (`ch01.first_tool`) | `default:book 1` | Minage (creuser) | paleotest |
| `ch23.field_guide` | Le carnet du paléontologue | Fabrication : `paleotest:field_guide` | Coup de pioche au Jurassique (`ch23.fossil_dig`) | `default:copper_ingot 3` | Fabrication | paleotest |
| `ch23.whip` | Le fouet du soigneur | Fabrication : `paleotest:whip` | Coup de pioche au Jurassique (`ch23.fossil_dig`) | `farming:wheat 6` | Fabrication | paleotest |
| `ch23.fossil_analyzer` | Monter son labo | Pose de bloc : `paleotest:fossil_analyzer` | Le carnet du paléontologue (`ch23.field_guide`) | `default:bronze_ingot 2` | Pose de bloc | paleotest |
| `ch23.dna_cultivator` | L'incubateur à ADN | Pose de bloc : `paleotest:dna_cultivator` | Monter son labo (`ch23.fossil_analyzer`) | `default:torch 6` | Pose de bloc | paleotest |
| `ch23.living_fossil` | Une forêt venue du passé | Pose de bloc : `paleotest:metasequoia_sapling` | L'incubateur à ADN (`ch23.dna_cultivator`) | `default:gold_ingot 1` | Pose de bloc | paleotest |
| `ch23.dino_egg` | Un œuf bien au chaud | Poser un œuf de dinosaure. | L'incubateur à ADN (`ch23.dna_cultivator`) | `farming:wheat 10`, `default:gold_ingot 1` | Intégration `paleotest:egg_placed` | paleotest |
| `ch23.dino_ride` | En selle sur un tricératops ! ★ | Monter sur un dinosaure. | Un œuf bien au chaud (`ch23.dino_egg`), Le fouet du soigneur (`ch23.whip`) | `default:gold_ingot 2`, titre « Mémoire du Jurassique » | Intégration `rides:dinosaur` | paleotest |

## Partie VI — Les Grands Projets

*Bâtisseurs et fondateurs de cités*

### Chapitre 24 — Les grands bâtisseurs (7 quêtes)

Échafaudages, façades, arches et portes ouvragées : les grands chantiers demandent de grands outils. Prépare-toi à bâtir des merveilles.

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch24.marble_quarry` | Carrière de marbre | Minage (creuser) : `darkage:marble` ×10 | Mon premier outil (`ch01.first_tool`) | `default:stonebrick 20` | Minage (creuser) | darkage |
| `ch24.marble_tiles` | Le dallage du palais | Fabrication : `darkage:marble_tile` ×4 | Carrière de marbre (`ch24.marble_quarry`) | `default:glass 10` | Fabrication | darkage |
| `ch24.stained_wood` | Une touche de teinture | Fabrication : `my_door_wood:wood_red`, `my_door_wood:wood_grey`, `my_door_wood:wood_dark_grey`, `my_door_wood:wood_brown`, `my_door_wood:wood_white`, `my_door_wood:wood_yellow`, `my_door_wood:wood_black` ×3 | Des planches, encore des planches (`ch01.planks`) | `dye:white 2`, `dye:red 2` | Fabrication | my_door_wood |
| `ch24.castle_gate` | Une porte de château | Pose de bloc : `my_castle_doors:door1_a`, `my_castle_doors:door1_b`, `my_castle_doors:door2_a`, `my_castle_doors:door2_b`, `my_castle_doors:door3_a`, `my_castle_doors:door3_b`, `my_castle_doors:door4_a`, `my_castle_doors:door4_b`, `my_castle_doors:door5_a`, `my_castle_doors:door5_b`, `my_castle_doors:door6_a`, `my_castle_doors:door6_b`, `my_castle_doors:door7_a`, `my_castle_doors:door7_b`, `my_castle_doors:door8_a`, `my_castle_doors:door8_b`, `my_castle_doors:door9_a`, `my_castle_doors:door9_b`, `my_castle_doors:door10_a`, `my_castle_doors:door10_b`, `my_castle_doors:door11_a`, `my_castle_doors:door11_b`, `my_castle_doors:door12_a`, `my_castle_doors:door12_b`, `my_castle_doors:door13_a`, `my_castle_doors:door13_b` | Une touche de teinture (`ch24.stained_wood`) | `default:steel_ingot 3` | Pose de bloc | my_castle_doors |
| `ch24.secret_passage` | Le passage secret | Fabrication : `my_hidden_doors:hidden_doorbookshelf` | Une touche de teinture (`ch24.stained_wood`) | `default:book 2` | Fabrication | my_hidden_doors |
| `ch24.shaper` | L'atelier du tailleur de pierre | Fabrication : `facade:shaper` | Le dallage du palais (`ch24.marble_tiles`) | `default:steel_ingot 4` | Fabrication | facade |
| `ch24.colonnade` | Une colonnade pour la place ★ | Pose de bloc : `facade:stone_column`, `facade:marble_column`, `facade:sandstone_column`, `facade:stone_columnia_mid`, `facade:marble_columnia_mid` ×4 | L'atelier du tailleur de pierre (`ch24.shaper`) | `default:gold_ingot 2`, titre « Pierre angulaire » | Pose de bloc | facade |

### Chapitre 25 — Monsieur ou Madame le Maire (8 quêtes)

Fonder une ville, c'est un rêve et beaucoup de travail. Scelle ta charte, trace les rues, installe la signalisation et les commerces. (La Reine valide toujours les grands projets !)

| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |
|---|---|---|---|---|---|---|
| `ch25.charter_write` | Rédiger la charte | Fabrication : `minerland_quests:city_charter` | Propriété privée (`ch02.protector`) | `default:paper 7` | Fabrication | — |
| `ch25.charter_seal` | Sceller la charte | Pose de bloc : `minerland_quests:city_charter` | Rédiger la charte (`ch25.charter_write`) | `default:gold_ingot 1` | Pose de bloc | — |
| `ch25.protect_town` | Borner la commune | Protéger une zone à ton nom avec /protect. | Sceller la charte (`ch25.charter_seal`) | `default:sign_wall_wood 4` | Intégration `areas:protect` | areas |
| `ch25.first_road` | La grand-rue | Pose de bloc : `streets:asphalt` ×16 | Sceller la charte (`ch25.charter_seal`) | `default:gravel 20` | Pose de bloc | streets |
| `ch25.sidewalk` | Des trottoirs pour les piétons | Fabrication : `streets:sidewalk` ×4 | La grand-rue (`ch25.first_road`) | `dye:white 4` | Fabrication | streets |
| `ch25.street_name` | Baptiser la rue | Pose de bloc : `street_signs:sign_basic` | La grand-rue (`ch25.first_road`) | `default:steel_ingot 2` | Pose de bloc | street_signs |
| `ch25.bank` | Le distributeur de la place | Pose de bloc : `atm:atm` | Sceller la charte (`ch25.charter_seal`) | `currency:minegeld_10 2` | Pose de bloc | atm |
| `ch25.street_lights` | Lumière sur la place ★ | Pose de bloc : `streets:light_vertical_off`, `streets:light_horizontal_off`, `streets:light_hanging_off` ×3 | Baptiser la rue (`ch25.street_name`), Borner la commune (`ch25.protect_town`) | `default:gold_ingot 2`, titre « Maire de Minerland » | Pose de bloc | streets |

---
★ = quête finale du chapitre. « Mods requis » : si l'un manque sur le serveur, la quête est affichée comme *Indisponible* et ne bloque pas les suivantes.
