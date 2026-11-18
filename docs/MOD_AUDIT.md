# Audit des mods de Minerland

> Fichier **généré** par `python3 tools/gen_mod_audit.py`. Sources : `docs/audit/`. Ne pas éditer à la main.

## 1. Méthode

- Liste des mods du serveur : relevé du dossier `/home/minetest/luanti5_15_1/mods` fourni par l'administration (17/11/2026) — `docs/audit/server_mods.txt`. La page « mods » du wiki est obsolète.
- Le serveur n'est pas accessible depuis le poste de développement : les sources publiques des mods ont été clonées en lecture seule (`.audit_src/`, `make fetch-sources`). **Les versions installées peuvent différer** : tout identifiant est aussi revérifié à l'exécution (une quête dont l'objet n'existe pas devient « Indisponible »). Sur le serveur : `python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods --index index.json` puis `python3 tools/validate_quests.py --index index.json`.
- Présence d'un dossier ≠ mod activé dans `world.mt` : chaque quête déclare ses mods requis.
- Index : 286 mods, 3138 objets littéraux, 729 alias ; 543 identifiants dynamiques vérifiés à la main (`docs/audit/verified_*.txt`).
- Sémantique des événements et classement de fiabilité : `docs/audit/README.md`.

## 2. Inventaire du serveur

| Dossier serveur | Source auditée | Mods (nom `mod.conf`) | Chapitres | État |
|---|---|---|---|---|
| `3d_armor` | `3d_armor` @ a4f311c 2026-07-20 | `3d_armor`, `3d_armor_ip`, `3d_armor_sfinv`, `3d_armor_stand`, `3d_armor_ui`, `armor_admin` … (+11) | ch05 | audité |
| `3d_armor_flyswim` | — | — | — | sans source |
| `BBQ` | `bbq` @ 1a72f7c 2019-08-09 | `bbq` | — | audité |
| `Biofuel` | `biofuel` @ 959aa0d 2026-08-31 | `biofuel` | — | audité |
| `DCM` | — | — | — | sans source |
| `abriglass` | — | — | — | sans source |
| `abripanes` | — | — | — | sans source |
| `adaptation_modpack` | — | — | — | sans source |
| `advtrains` | `advtrains` @ 2b59ab8 2026-11-11 | `advtrains`, `advtrains_assets`, `advtrains_interlocking`, `advtrains_line_automation`, `advtrains_luaautomation`, `advtrains_signals_japan` … (+5) | — | audité |
| `advtrains_horntrack` | `advtrains_horntrack` @ 9fd718c 2025-08-21 | `advtrains_horntrack` | — | audité |
| `advtrains_platform` | `advtrains_platform` @ 448513b 2023-03-13 | `advtrains_platform` | — | audité |
| `advtrains_train_jpntlr600` | `advtrains_train_jpntlr600` @ 6f10f72 2024-08-29 | `advtrains_train_jpntlr600` | — | audité |
| `advtrains_train_orient_express` | `advtrains_train_orient_express` @ 4a16119 2025-11-22 | `advtrains_train_orient_express` | — | audité |
| `advtrains_train_zugspitzbahn` | `advtrains_train_zugspitzbahn` @ 48d11c5 2023-06-22 | `advtrains_train_zugspitzbahn` | — | audité |
| `airutils` | `airutils` @ 5c21c92 2026-08-16 | `airutils` | — | audité |
| `ambience` | — | — | — | sans source |
| `amethyst_new` | `amethyst_new` @ 87ed79d 2026-09-26 | `amethyst_new` | — | audité |
| `animalworld` | `animalworld` @ ac835da 2024-07-25 | `animalworld` | — | audité |
| `appliances` | `appliances` @ 6fe2c25 2025-05-15 | `appliances` | — | audité |
| `areas` | `areas` @ 377ad68 2026-09-12 | `areas` | — | audité |
| `armor_toggle` | — | — | — | sans source |
| `artdeco` | — | — | — | sans source |
| `atl_path` | — | — | — | sans source |
| `atm` | `atm` @ 1401a40 2025-08-11 | `atm` | — | audité |
| `automobiles_pck` | `automobiles_pck` @ 4e01858 2026-10-14 | `automobiles_beetle`, `automobiles_buggy`, `automobiles_catrelle`, `automobiles_coupe`, `automobiles_delorean`, `automobiles_lib` … (+4) | — | audité |
| `awards` | `awards` @ 9d2b458 2026-06-01 | `awards` | — | audité |
| `bakedclay` | — | — | — | sans source |
| `basic_materials` | `basic_materials` @ f626da0 2026-09-13 | — | — | audité |
| `basic_trains` | `basic_trains` @ 4eca8d9 2025-06-11 | `advtrains_train_industrial`, `advtrains_train_japan`, `advtrains_train_steam`, `advtrains_train_subway` | — | audité |
| `beautiflowers` | — | — | — | sans source |
| `beowulf` | — | — | — | local |
| `bike` | `bike` @ 9912953 2025-06-29 | `bike` | — | audité |
| `billboard` | — | — | — | sans source |
| `biome_lib` | — | — | — | sans source |
| `bonemeal` | `bonemeal` @ 5b41154 2026-10-09 | `bonemeal` | — | audité |
| `c_doors` | — | — | — | sans source |
| `canned_food` | `canned_food` @ 4d061e9 2021-08-05 | `canned_food` | — | audité |
| `caverealms_lite` | `caverealms_lite` @ 6af99e8 2019-06-02 | `caverealms` | — | audité |
| `celevator` | `celevator` @ f938829 2026-09-06 | `celevator` | — | audité |
| `chair_lift` | `chair_lift` @ 5f2d365 2022-10-25 | `chair_lift` | — | audité |
| `chester` | — | — | — | local |
| `christmas` | — | — | — | sans source |
| `christmas_decor` | — | — | — | sans source |
| `church` | — | — | — | sans source |
| `clubbing` | — | — | — | sans source |
| `colored_concrete` | — | — | — | sans source |
| `controls` | — | — | — | sans source |
| `cottages` | `cottages` @ ab7f7e1 2026-01-02 | `cottages` | — | audité |
| `creatura` | `creatura` @ 4eb507c 2025-12-25 | `creatura` | — | audité |
| `currency` | `currency` @ 6472e8b 2026-05-31 | `currency` | — | audité |
| `darkage` | `darkage` @ 494f81c 2025-11-22 | `darkage` | — | audité |
| `death_compass` | — | — | — | sans source |
| `demoiselle` | — | — | — | sans source |
| `digilines` | `digilines` @ 3f6e553 2026-07-06 | `digilines` | — | audité |
| `digistuff` | `digistuff` @ 0dcdf51 2026-11-15 | `digistuff` | — | audité |
| `digtron` | `digtron` @ 9ae31a6 2026-10-28 | `digtron` | — | audité |
| `discordmt` | — | — | — | sans source |
| `display_modpack` | — | — | — | sans source |
| `doxy_mini_tram` | `doxy_mini_tram` @ 62438bd 2023-07-02 | `minitram_crafting_recipes`, `minitram_konstal_105`, `minitram_konstal_105_liveries`, `multi_component_liveries`, `visual_line_number_displays` | — | audité |
| `draconis` | `draconis` @ 5ad66e4 2026-02-18 | `draconis` | — | audité |
| `drawers` | `drawers` @ 5c8aa86 2026-09-11 | `drawers` | — | audité |
| `dreambuilder_hotbar` | — | — | — | sans source |
| `drinks` | `drinks` @ 5c0c081 2026-08-30 | `drinks` | — | audité |
| `edit_skin` | — | — | — | sans source |
| `elevator` | `elevator` @ 9d3c23f 2024-02-29 | `elevator` | — | audité |
| `emote` | — | — | — | sans source |
| `ethereal` | `ethereal` @ c467e70 2026-11-12 | `ethereal` | — | audité |
| `everness` | — | — | — | sans source |
| `facade` | `facade` @ d200201 2026-06-14 | `facade` | — | audité |
| `factory_bridges` | `factory_bridges` @ 51fc786 2026-09-10 | `factory_bridges` | — | audité |
| `fakelib` | — | — | — | sans source |
| `farebox` | `farebox` @ ae059f2 2020-11-08 | `farebox` | — | audité |
| `farming` | `farming` @ 26b6fc5 2026-11-14 | — | — | audité |
| `fireworkz` | — | — | — | sans source |
| `fishing_boat` | `fishing_boat` @ e18fc13 2026-01-25 | `fishing_boat` | — | audité |
| `food` | `food` @ 9b97006 2018-08-03 | `food`, `food_basic` | — | audité |
| `friandises` | — | — | — | local |
| `gemalde` | — | — | — | sans source |
| `geodes_lib` | — | — | — | sans source |
| `glass_stained` | — | — | — | sans source |
| `gloopblocks` | — | — | — | sans source |
| `glooptest` | `glooptest` @ cad8dd0 2025-08-19 | `glooptest` | ch04, ch05 | audité |
| `hazmat_suit` | — | — | — | sans source |
| `hbdrunk` | — | — | — | sans source |
| `headanim` | — | — | — | sans source |
| `headlamp` | — | — | — | sans source |
| `hidroplane` | `hidroplane` @ 1452b1d 2026-01-11 | `hidroplane` | — | audité |
| `home_workshop_modpack` | — | — | — | sans source |
| `homedecor_modpack` | `homedecor_modpack` @ 992739d 2026-02-15 | `building_blocks`, `fake_fire`, `homedecor_3d_extras`, `homedecor_bathroom`, `homedecor_bedroom`, `homedecor_books` … (+29) | — | audité |
| `ilights` | — | — | — | sans source |
| `illumination` | — | — | — | sans source |
| `industrial_signs` | — | — | — | sans source |
| `jelys_pizzaria` | `jelys_pizzaria` @ 21ad7cd 2024-09-23 | `jelys_pizzaria` | — | audité |
| `ju52` | `ju52` @ b1f5df9 2026-07-18 | `ju52` | — | audité |
| `laptop` | — | — | — | sans source |
| `leads` | `leads` @ 49d3740 2026-07-09 | `leads` | — | audité |
| `led_marquee` | — | — | — | sans source |
| `letters` | — | — | — | sans source |
| `linetrack` | `linetrack` @ 2ae4e15 2025-08-12 | `linetrack` | — | audité |
| `livingnether` | `livingnether` @ 3d4c278 2024-07-25 | `livingnether` | — | audité |
| `locked_travelnet` | `locked_travelnet` @ 4167eb0 2019-03-11 | `locked_travelnet` | — | audité |
| `locks` | `locks` @ e789726 2023-01-29 | `locks` | — | audité |
| `lootchests_modpack` | `lootchests_modpack` @ 9b09d4b 2025-09-23 | `lootchests`, `lootchests_default`, `lootchests_magic_materials` | — | audité |
| `ltc4000e` | `ltc4000e` @ a3222ae 2024-09-14 | `ltc4000e` | — | audité |
| `luanti-fmod` | `fmod` @ b414049 2024-04-02 | `fmod` | — | audité |
| `luanti-futil` | `futil` @ b7ed1eb 2024-12-23 | `futil` | — | audité |
| `luanti-smartshop` | `smartshop` @ 8d73436 2025-10-16 | `smartshop` | — | audité |
| `luanti-tieless-tracks` | `tieless_tracks` @ f38321b 2026-11-10 | `tieless_tracks` | — | audité |
| `ma_pops_furniture` | — | — | — | sans source |
| `mailbox` | — | — | — | sans source |
| `mesecons` | `mesecons` @ aca87db 2026-09-01 | `mesecons`, `mesecons_alias`, `mesecons_blinkyplant`, `mesecons_button`, `mesecons_commandblock`, `mesecons_delayer` … (+26) | — | audité |
| `metrosigns` | `metrosigns` @ 43f079f 2026-02-06 | `metrosigns` | — | audité |
| `minekart` | — | — | — | local |
| `minerland_fix_darkage` | — | — | — | local |
| `minerland_fix_draconis` | — | — | — | local |
| `minerland_fix_hemp` | — | — | — | local |
| `minerland_fix_npc` | — | — | — | local |
| `minerland_fix_powerg` | — | — | — | local |
| `minerland_fix_silicon` | — | — | — | local |
| `minerland_fix_techage` | — | — | — | local |
| `minetest-fmod` | `fmod` @ b414049 2024-04-02 | `fmod` | — | audité |
| `minetest-futil` | `futil` @ b7ed1eb 2024-12-23 | `futil` | — | audité |
| `minetest-hangglider` | `hangglider` @ 17419f7 2025-10-19 | `hangglider` | — | audité |
| `minetest-moretrains` | `moretrains` @ 59ee0e4 2021-12-01 | `moretrains_basic`, `moretrains_gondola`, `moretrains_industrial`, `moretrains_japan`, `moretrains_nightline`, `moretrains_steam` … (+1) | — | audité |
| `minetest_hudbars` | — | — | — | sans source |
| `minetest_tsm_railcorridors` | `tsm_railcorridors` @ 5b2016d 2023-04-22 | `tsm_railcorridors` | — | audité |
| `mob_core` | `mob_core` @ 1835b85 2023-01-28 | `mob_core` | — | audité |
| `mob_horse` | `mob_horse` @ aa3ad5e 2026-10-17 | `mob_horse` | — | audité |
| `mobkit` | — | — | — | sans source |
| `mobs_animal` | `mobs_animal` @ 49a43c8 2026-11-08 | `mobs_animal` | — | audité |
| `mobs_npc` | `mobs_npc` @ 7b71dcb 2026-10-24 | `mobs_npc` | — | audité |
| `mobs_redo` | `mobs` @ bb7e3d5 2026-11-16 | `mobs` | — | audité |
| `mod-cleaner` | — | — | — | local |
| `mod_plume` | — | — | — | sans source |
| `modlib` | — | — | — | sans source |
| `monitoring` | — | — | — | local |
| `moreblocks` | `moreblocks` @ 8c3de6c 2026-07-21 | `moreblocks` | — | audité |
| `moredecorations` | — | — | — | local |
| `morelights` | — | — | — | sans source |
| `moremachines` | `moremachines` @ 715d5b0 2017-02-06 | `moremachines` | — | audité |
| `moreores` | `moreores` @ 73c8696 2025-03-16 | `moreores` | ch04 | audité |
| `moretrees` | `moretrees` @ 79ea6f7 2026-08-29 | `moretrees` | — | audité |
| `motorboat` | `motorboat` @ ae36510 2026-06-12 | `motorboat` | — | audité |
| `mydeck` | — | — | — | sans source |
| `mydoors` | `mydoors` @ d007c57 2025-03-31 | `my_castle_doors`, `my_cottage_doors`, `my_default_doors`, `my_door_wood`, `my_fancy_doors`, `my_future_doors` … (+6) | — | audité |
| `nautilus` | `nautilus` @ df4fa14 2026-07-05 | `nautilus` | — | audité |
| `nether` | `nether` @ 5480dba 2026-10-04 | — | — | audité |
| `other_worlds` | `other_worlds` @ 411e997 2026-03-27 | `other_worlds` | — | audité |
| `override` | — | — | — | sans source |
| `pa28` | `pa28` @ 6c11335 2024-10-05 | `pa28` | — | audité |
| `paleotest` | `paleotest` @ 7f3c5fa 2020-12-17 | `paleotest` | — | audité |
| `pipeworks` | `pipeworks` @ 15794da 2026-11-13 | `pipeworks` | — | audité |
| `pkarcs` | — | — | — | sans source |
| `plantlife_modpack` | — | — | — | sans source |
| `playerlist` | — | — | — | sans source |
| `power_generators` | `power_generators` @ 2f58b45 2026-01-04 | `power_generators` | — | audité |
| `protector` | `protector` @ d72ad45 2026-09-20 | `protector` | ch02 | audité |
| `public_death_messages` | — | — | — | sans source |
| `pvp_areas` | — | — | — | sans source |
| `radar_atc` | — | — | — | local |
| `rangedweapons` | — | — | — | sans source |
| `rings` | `rings` @ 7082275 2022-07-12 | `goops_rings` | ch05 | audité |
| `scaffolding` | `scaffolding` @ dbbbc3f 2024-08-10 | `scaffolding` | — | audité |
| `scifi_nodes` | — | — | — | sans source |
| `shipwrecks` | `shipwrecks` @ 16b3ca0 2026-10-25 | `shipwrecks` | — | audité |
| `signs_lib` | `signs_lib` @ 897b30b 2026-03-14 | `signs_lib` | — | audité |
| `spawn_command` | — | — | — | sans source |
| `spectator_mode` | — | — | — | sans source |
| `stairs` | — | — | — | sans source |
| `street_signs` | `street_signs` @ 94eb27d 2024-06-09 | `street_signs` | — | audité |
| `streets` | `streets` @ fd02b1a 2023-11-10 | `streets` | — | audité |
| `supercub` | `supercub` @ 490e586 2026-01-11 | `supercub` | — | audité |
| `symmetool` | — | — | — | sans source |
| `tape_measure` | — | — | — | sans source |
| `techage_modpack` | `techage_modpack` @ de4c1a5 2026-10-09 | `autobahn`, `basic_materials`, `compost`, `doclib`, `hyperloop`, `lcdlib` … (+13) | — | audité |
| `technic` | `technic` @ 856ee6a 2026-11-10 | `concrete`, `extranodes`, `technic`, `technic_chests`, `technic_cnc`, `technic_worldgen` … (+1) | — | audité |
| `teleport-request` | — | — | — | sans source |
| `terraform` | — | — | — | sans source |
| `tfl_s7stock_modpack` | `tfl_s7_stock_modpack` @ 961d047 2023-06-22 | `tfl_s7_stock_modpack` | — | audité |
| `toolranks` | — | — | — | sans source |
| `trainblocks_bc` | `trainblocks` @ a312afc 2021-01-22 | `trainblocks` | — | audité |
| `travelnet` | `travelnet` @ 6b9f084 2026-10-25 | `travelnet` | — | audité |
| `ts_workshop` | — | — | — | sans source |
| `unifieddyes` | — | — | — | sans source |
| `unified_inventory` | `unified_inventory` @ 3679deb 2026-08-22 | `unified_inventory` | — | audité |
| `vehicles` | `vehicles` @ dd795db 2023-03-01 | `vehicles` | — | audité |
| `visible_wielditem` | — | — | — | sans source |
| `vps_blocker` | — | — | — | local |
| `waffles` | `waffles` @ f9ee996 2024-01-01 | `waffles` | — | audité |
| `windmill` | — | — | — | sans source |
| `wine` | `wine` @ 763ec46 2026-09-26 | `wine` | — | audité |
| `worldedit` | — | — | — | sans source |
| `xban2` | — | — | — | sans source |
| `xcompat` | — | — | — | sans source |
| `xdecor` | `xdecor` @ 43a7753 2026-02-22 | `xdecor` | — | audité |
| `xnether` | `xnether` @ 2071814 2024-07-01 | `xnether` | — | audité |
| `xocean` | `xocean` @ 061afc5 2025-03-13 | `xocean` | — | audité |

Bilan : 105 dossiers audités, 16 mods locaux sans source publique, 76 hors périmètre des quêtes (sources non récupérées).

Décision : le mod `awards` sera **supprimé** du serveur ; le livre n'en dépend pas et n'y fait pas appel.

## 3. Fiches détaillées par chapitre

<!-- source : docs/audit/ch01_ch05.md -->
### Audit — Partie I (chapitres 1 à 5)

Périmètre : `minetest_game` (default, doors, beds…), `farming` (redo de TenPlus1), `moreores`, `glooptest`,
`goops_rings` (dossier serveur `rings`) + `3d_armor`, `protector`, `areas`, `bonemeal`, `locks`, `moretrees`,
`unified_inventory` (API) et `awards` (décision). Conventions : docs/audit/README.md. Identifiants dynamiques :
`docs/audit/verified_part1.txt`.

## 1. Fiches par mod

### minetest_game (mods `default`, `doors`, `beds`, `bucket`, `vessels`…) — sources : `.audit_src/minetest_game` @ 9e895af (2026-10-30)
- Rôle : jeu de base ; objets et nœuds fondamentaux.
- Objets utiles : `default:tree` (+ `aspen_tree`, `jungletree`, `pine_tree`, `acacia_tree`, tous du groupe `tree`) —
  `default/nodes.lua:699` ; `default:wood`, `default:stick` — `craftitems.lua:336` ; `default:chest` /
  `default:chest_locked` (générés par `default.chest.register_chest`) — `chests.lua:313,329` ; `default:furnace` —
  `furnace.lua:363` ; `default:torch` (+ `_wall`, `_ceiling`) — `torch.lua:22,78,103` ; minerais
  `default:stone_with_{coal,iron,copper,tin,gold,mese,diamond}` — `nodes.lua:1195-1307` ; `default:mese_crystal`,
  `default:diamond`, `default:steel_ingot`, `default:bronze_ingot`… — `craftitems.lua` ;
  `default:bookshelf`, `default:meselamp`, `default:ladder_wood`, `default:fence_wood` (`nodes.lua:2692`),
  `default:sign_wall_wood` (`nodes.lua:2580,2637`).
- Portes : `doors:door_wood`, `door_glass`, `door_steel` (objets) ; nœuds posés `…_a` / `…_b` — `doors/init.lua:259,465,468`.
- Lits : `beds:bed`, `beds:fancy_bed` (alias de `…_bottom`) — `beds/api.lua:47,203`.
- Événements : voir ci-dessous.
  - `dig` / `craft` / `place` : fiables pour les nœuds et recettes de grille standard.
  - **Portes** : `on_place` pose les deux nœuds puis **appelle lui-même** `core.registered_on_placenodes`
    (`doors/init.lua:192-215`) → `place` fiable sur `doors:door_*_a|_b`.
  - **Lits** : `on_place` pose par `core.set_node` (`beds/api.lua:115-116`) sans callback → `place` **impossible** ;
    on valide la **fabrication** (recette dans `def.recipe` → `register_craft`, résolue en `beds:bed_bottom`).
  - **Torches** : `on_place` → `core.item_place` (`torch.lua:46-68`) : `place` fiable ; le nœud posé dépend du support
    (`torch`, `torch_wall`, `torch_ceiling`).
- Limites : les troncs/planches de `moretrees` passent aussi par le groupe `tree`/`wood` si le mod est actif.

### farming (redo, TenPlus1) — sources : `.audit_src/farming` @ 26b6fc5 (2026-11-14)
- Rôle : cultures (`farming.register_plant`), houes, sol labouré (`farming:soil`, `farming:soil_wet`), aliments.
- Dépendances : `default` ; optionnels nombreux (`stairs`, `vessels`, `bucket`…).
- Objets : graines `farming:seed_<culture>` ; stade final `farming:<culture>_<N>` (blé 8, carotte 8, pomme de terre 4,
  tomate 8, maïs 8, concombre 4, citrouille 8, melon 8, oignon 5, ail 5, orge 8, riz 8, haricot `beanpole_5`, coton 8) —
  `farming/crops/*.lua` (champ `steps`) ; houes `farming:hoe_{wood,stone,steel}` — `hoes.lua:125-145` ;
  ustensiles `farming:mortar_pestle`, `juicer`, `cutting_board`, `bowl`… — `item_recipes.lua:1320-1345` ;
  aliments `farming:flour`, `bread`, `salad`, `carrot_juice`, `potato_salad`, `popcorn`, `baked_potato` — `item_food.lua`.
- Événements :
  - **Récolte** : `dig` du stade final (`farming:wheat_8`) → fiable.
  - **Labour** : la houe fait `core.set_node` (`hoes.lua:78`) → pas de `place` ; **adaptateur A** (enveloppe du `on_use` des
    houes, comparaison du nœud avant/après) : `integrations/farming.lua` → `farming:till`.
  - **Semis** : `farming.place_seed` fait `core.set_node` (`init.lua`, ~l.484) → **adaptateur A** (enveloppe du `on_place` des
    graines) : `farming:sow`.
  - **Transformation** : farine, salade, jus, popcorn = recettes de grille (`craft`, fiable) ; le pain est une **cuisson**
    (`type = cooking`, pas de `craft`) → on valide le fait de **manger** le pain (`eat`).
- Limites : les recettes d'ustensiles utilisent des groupes (`group:food_*`) ; la version serveur peut différer (dépôt très
  actif en 2026).

### moreores — sources : `.audit_src/moreores` @ 73c8696
- Minerais : `moreores:mineral_silver`, `moreores:mineral_mithril` (générés par `add_ore`, `init.lua:98-142,577`) ;
  lingots/pépites `moreores:silver_ingot|lump`, `mithril_ingot|lump` ; l'étain est un **alias** vers `default:stone_with_tin`
  (`init.lua:500`).
- Événements : `dig` des minerais, fiable. Le mithril n'apparaît qu'en grande profondeur (`oredef_deep`).

### glooptest — sources : `.audit_src/glooptest` @ cad8dd0
- Minerais de gemmes `glooptest:mineral_{ruby,sapphire,emerald,topaz,amethyst}` (générés, `ore_api.lua:36`, `ore.lua:477-677`,
  dans `default:stone`) ; gemmes `glooptest:*_gem` (`ore.lua:507-707`, groupe `glooptest_gem`) ; autres minerais
  (kalite, alatro, talinite, akalin, arol, desert_iron…) et verre de cristal.
- Événements : `dig` fiable. Sert aussi de matière première des anneaux.

### goops_rings (mod.conf `name = goops_rings`, dossier serveur `rings`) — sources : `.audit_src/rings` @ 7082275 (2022-07-12)
- Dépendances : `moreores`, `3d_armor`, `default` ; optionnel `glooptest` (sinon gemmes/minerais de secours intégrés,
  `glooptest.lua`).
- **Fonctionnement réel (lu dans le code)** :
  - 5 modèles × 4 niveaux : `goops_rings:<modèle>_ring<niveau>` (`items.lua:75-87`) ; modèles : `celestial` (vol),
    `infernal` (résistance au feu), `abyssal` (respiration), `enlightning` (lumière), `hardening` (poing de fer).
  - Un anneau est une **armure** de type « ring » (`items.lua:5`) : on l'équipe comme une pièce d'armure.
  - **Anneau d'activation** `goops_rings:activation_ring` (`activation.lua:312`) : clic gauche **en main** → active l'effet de
    l'anneau porté pendant `15 s × 2^(niveau-1)` puis 15 s de recharge (réglages `rings_dur`, `rings_cooldown`) ; clic droit
    → désactive ; accroupi + clic gauche → bascule du mode **automatique** (qui peut utiliser l'anneau depuis l'inventaire,
    `activation.lua:38-45`) ; accroupi + clic droit → affichage HUD.
  - **Vol** : l'effet « Flight Privilege » (`effects.lua:210`) **donne temporairement le privilège `fly`** à l'activation
    (`fly_on_activate`) et le **retire** à la désactivation ; refusé si le joueur a déjà `fly` en permanence (`fly_check`).
    Le livre ne donne donc jamais `fly` : c'est le mod qui le fait, de façon temporaire.
  - **Recettes** (`items.lua:95-125`) : niveau 1 = **5 gemmes du même type** + 2 pépites d'argent + 2 pépites d'or (améthyste =
    céleste, rubis = infernal, saphir = abyssal, topaze = lumineux, émeraude = durci) ; niveau 2 = 5 anneaux de niveau 1 + 4
    pépites d'or ; niveau 3 = 5 anneaux niveau 2 + mithril ; niveau 4 = 8 anneaux niveau 3 + 1 diamant. Donc niveau 3 ≈ 125
    gemmes, niveau 4 ≈ 1000 : **seul le niveau 1 est raisonnable en quête**.
  - Anneau d'activation : 4 pépites d'or + émeraude, saphir, rubis, améthyste, topaze (`activation.lua:323`).
  - `goops_rings:mismatched_gems` : 5 gemmes quelconques → 5 gemmes dépareillées (`items.lua:126-135`) ;
    `goops_rings:random_ring<n>` : anneau aléatoire.
- Événements :
  - **Fabrication** (anneaux, anneau d'activation, gemmes dépareillées) : `craft` fiable.
  - **Équipement** : callback public `armor:register_on_equip(function(player, index, stack))`
    (`3d_armor/api.lua:271`), appelé par `armor:equip` (clic droit en main, `api.lua:688-712`) et par le dépôt dans
    l'inventaire d'armure (`init.lua:162`) → **A, fiable** ; il est aussi appelé à la connexion pour une armure déjà portée
    (`init.lua:254`), acceptable (le joueur l'avait équipée).
  - **Activation / vol** : état public `rings.users[nom].flags.status == 1` et `.fx.name` (`activation.lua:5-30`,
    `effects.lua:210-231`), lu toutes les 2 s → **A, fiable** (`integrations/rings.lua`, aucune fonction du mod remplacée).
- Limites : mod ancien (2022) ; vol nécessitant la touche de vol du client (K par défaut).

### protector (TenPlus1) — sources : `.audit_src/protector` @ d72ad45
- Objets : `protector:protect`, `protector:protect2` (`init.lua:649,687`), `protector:chest`, `protector:tool`.
- Événements : `place` fiable (`on_place = check_overlap` → `core.item_place`, `init.lua:446,587`), refus en cas de chevauchement.

### areas, bonemeal, locks, moretrees (non retenus en quêtes)
- `areas` (`name = areas`) : protection par commandes (`/protect`) soumise aux privilèges `areas` que l'administratrice
  accorde — **pas de quête** (privilège, wiki « mod area activé avec le privilège fast »).
- `bonemeal` : `bonemeal:mulch|bonemeal|fertiliser` (`init.lua:459-481`) — utilisation = modification de nœuds sans événement ;
  seule la fabrication serait détectable (non retenue).
- `locks` : `locks:lock|key|shared_locked_chest…` (`init.lua:754-787`) — possible plus tard (pose d'un coffre partagé).
- `moretrees` : nombreux troncs ; le groupe `tree` inclut ses troncs, donc la quête « premier tronc » les accepte.

### unified_inventory (mod `unified_inventory`) — sources : `.audit_src/unified_inventory` @ 3679deb
- API (lue dans `api.lua:587-598`, `internal.lua:290-336`, `doc/mod_api.txt`) :
  `unified_inventory.register_page(name, { get_formspec = function(player, style) … return { formspec, draw_inventory?,
  draw_item_list?, formspec_prepend? } end })` ; `unified_inventory.register_button(name, { type = "image", image, tooltip,
  hide_lite?, condition?, action? })` (par défaut `action` ouvre la page du même nom) ;
  `unified_inventory.set_inventory_formspec(player, page)` ; `unified_inventory.current_page[nom]`.
- Contraintes : `formspec_version[4]` ; `size[17.75,12.25]` (mode complet) ou `size[14,9.75]` (mode lite) ; boutons d'onglets en bas
  (complet, `y=11.0`) ou en colonne à droite (lite, `x=10.5`) ; le formspec de la page est inséré après le fond
  `background9[… ui_formbg_9_sliced.png …]` ; le style (`style.formw`, `style.main_button_y`, `style.is_lite_mode`…) est transmis à
  `get_formspec`. Les champs de la page arrivent avec `formname == ""`.
- Limite : UI redessine l'inventaire avec `ui.set_inventory_formspec` ; une page qui se rafraîchit doit passer par cette fonction.

### awards — **supprimé du serveur**
Décision de l'administratrice (17/11/2026) : aucune intégration, aucune dépendance, aucun son emprunté.

## 2. Chapitres et quêtes candidates

### Chapitre 1 — Bienvenue à Minerland
| slug | idée | type | identifiants | Fiab. | remarque |
|---|---|---|---|---|---|
| first_log | Bûcheron du dimanche | dig | groupe `tree` | F | troncs posés par un joueur ignorés |
| planks | Des planches | craft | groupe `wood` ×4 | F | |
| sticks | Bâton de pèlerin | craft | `default:stick` | F | |
| first_tool | Mon premier outil | craft | `default:pick_wood`… | F | |
| chest_craft / chest_place | coffre fabriqué / posé | craft / place | `default:chest` | F | |
| furnace | Le feu sacré | place | `default:furnace` | F | quête finale |

### Chapitre 2 — Mon premier chez-moi
| slug | idée | type | identifiants | Fiab. | remarque |
|---|---|---|---|---|---|
| door_craft / door_place | porte fabriquée / posée | craft / place | `doors:door_*`, `doors:door_*_a|_b` | F | les portes rappellent les callbacks |
| bed | Au lit, les marmottes ! | craft | `beds:bed`, `beds:fancy_bed` | F | pose **non** détectable (`set_node`) |
| light | Que la lumière soit | place | `default:torch*` ×3 | F | positions distinctes |
| protector | Propriété privée | place | `protector:protect(2)` | F | |
| furniture | Un intérieur qui a du chien | place | bibliothèque, panneau, barrière | F | |
| locked_chest | Mon coffre-fort | place | `default:chest_locked` | F | quête finale |
| (écarté) | Fonder une aire `/protect` | — | — | I | privilège `areas` |

### Chapitre 3 — Les joies de l'agriculture
Voir §1 farming. F : récolte (`dig`), farine/salade (`craft`), pain (`eat`) ; A : labour (`farming:till`) et semis (`farming:sow`).

### Chapitre 4 — Les trésors de la terre
Tous F (`dig` des minerais natifs) : charbon, fer, cuivre/étain, argent, or, mese, gemmes (glooptest), diamant, mithril ;
F (`craft`) : pioche en acier/bronze. Plafond économique : diamant ≤ 4, mese ≤ 6 sur l'ensemble du livre.

### Chapitre 5 — Les anneaux du ciel
F (`craft`) : gemmes dépareillées, anneau d'activation, premier anneau, anneau céleste ; A : `rings:equip`, `rings:activate`,
`rings:flight`, `rings:activate_other`. Écarté : anneaux de niveau ≥ 2 (125 gemmes et plus) ; effet « lumière » et « poing de fer »
(pas d'événement d'usage plus fin que l'activation).

<!-- source : docs/audit/ch06_ch09.md -->
### Audit — Chapitre 6 « La ferme aux animaux » et Chapitre 9 « Les affaires sont les affaires »

Agent `mod-researcher`, 17/11/2026. Sources : `.audit_src/` (branches principales clonées en novembre 2026).
**Rappel : les versions installées sur le serveur peuvent différer** ; tout identifiant est revérifié à l'exécution
(`core.registered_items` / `core.registered_entities`). Chemins cités relativement à `.audit_src/`.

## Constats transverses (à lire avant les tableaux)

1. **Aucun callback global dans mobs_redo** (capture, apprivoisement, nourrissage, reproduction, traite, tonte).
   Les seuls crochets sont **par définition de mob** (`on_rightclick`, `on_breed`, `on_grown`, `on_spawn`, `do_custom`…),
   copiés dans la définition d'entité (`mobs/api.lua:3507-3519`, enregistrement `mobs/api.lua:3530`). Grep de
   `register_on`/`callbacks` dans `mobs/` : uniquement des callbacks moteur internes (`api.lua:117`, `mount.lua`).
   Les fonctions `mobs:feed_tame` (`api.lua:4336`), `mobs:capture_mob` (`api.lua:4208`), `mobs:protect` (`api.lua:4292`)
   sont des **utilitaires appelés par le `on_rightclick` de chaque mob**, pas des événements. Les remplacer serait
   « remplacer une fonction globale d'un autre mod » → interdit (README §2).
2. **Chemin réel d'une action sur un animal** : clic droit → moteur → `on_rightclick(self, clicker)` de l'entité →
   `feed_tame` (nourrit ; à `feed_count` repas : `self.tamed = true` + `owner` `api.lua:4417`, `self.horny = true`
   si `breed` `api.lua:4407`) → `protect` → `capture_mob` → actions propres (traite, tonte, selle, monte).
   Aucun de ces chemins ne déclenche `dig`/`place`/`craft`/`eat`.
3. **Adaptateur proposé `integrations/mobs_redo.lua` (A, enveloppe justifiée d'un callback de définition)** : dans
   `core.register_on_mods_loaded`, pour chaque `core.registered_entities[n]` ayant `_cmi_is_mob` (défaut de
   `mob_class`, `api.lua:162`) et un `on_rightclick` fonction, envelopper : mémoriser l'état *avant* (`tamed`,
   `owner`, `gotten`, `horny`, objet tenu), **appeler l'original en premier** et renvoyer sa valeur telle quelle,
   puis comparer l'état *après* : `tamed` faux→vrai et `owner == joueur` ⇒ `mobs:tame:<entité>` ;
   objet disparu (`self.object:get_pos() == nil`) et objet tenu `""`/`mobs:net`/`mobs:lasso` ⇒ `mobs:capture:<entité>` ;
   `mobs:shears` + `gotten` faux→vrai ⇒ `mobs:shear` ; seau + `gotten` →vrai ⇒ `mobs:milk` ; `horny` faux→vrai ⇒
   `mobs:breed_ready`. Les prototypes d'entité servent de métatable aux instances : l'enveloppe s'applique aussi aux
   mobs déjà actifs. La **naissance** réelle n'est visible que via `on_breed` (`api.lua:1390`, appelé 5 s plus tard
   dans `core.after`) : l'injecter serait plus invasif (le mouton a son propre `on_breed` qui renvoie `false`,
   `mobs_animal/sheep.lua:222`) → préférer `breed_ready`. Faux positifs : quasi nuls (contrôles propriétaire internes) ;
   **boucle capture/relâche** possible → pas de compteur > 1 sur la capture.
4. **Animal capturé = objet d'inventaire** `<entité>_set` (non empilable, données sérialisées en méta,
   `api.lua:4266-4268`, objet enregistré `api.lua:4128`) ; si `replacewith` est fourni (abeille) ou si le mob est de
   type `monster` (pas de `_set`, `api.lua:4125`), c'est l'œuf simple `<entité>` (`api.lua:4071`).
   **Relâcher** (œuf ou `_set`) = `on_place` → `core.add_entity` (`api.lua:4107`, `4167`) **sans**
   `core.item_place_node` ⇒ **aucun `register_on_placenode`** ; c'est une entité, pas un nœud (I comme `place`).
5. **Capture conditionnée** : il faut un mob **apprivoisé et possédé** par le joueur (`api.lua:4223`, `4228`), sauf
   `force_take` (abeille `mobs_animal/bee.lua:56`, rat `mobs_animal/rat.lua:64`). Outils acceptés : main vide,
   `mobs:net`, `mobs:lasso` uniquement (`api.lua:4220`), avec un pourcentage de réussite par mob.
6. **Wiki obsolète** (`.wiki_cache/tutoriels_capture.txt`) : « lasso Petz », « fouet Petz » renvoient au mod `petz`,
   **absent** de `docs/audit/server_mods.txt` et non audité ⇒ ne rien en tirer. « Lasso Mobs » = `mobs:lasso`,
   « filet » = `mobs:net`. Écarts : le panda suit le bambou (`mobs_animal/panda.lua:71`), pas le papyrus ; le sanglier
   « Mobs » est `mobs_animal:pumba` (pomme/pomme de terre, `mobs_animal/warthog.lua:71`).
   `.wiki_cache/lore.txt` : élevage et Minegeld font partie du lore d'Amelaye (ton utilisable dans les titres).

---

### mobs_redo (mod `mobs`) — sources auditées : mobs @ bb7e3d5 (version `20261114`, `api.lua:20`)
- Rôle : API de mobs (enregistrement, IA, nourrissage, capture, montures) + outils d'élevage.
- Dépendances : aucune obligatoire ; optionnelles `default, player_api, …` (`mod.conf`). **Monture inactive sans
  `player_api`** (`mount.lua:8-15`, fonctions vides).
- Objets utiles : `mobs:net` filet (craft 5 bâtons + 2 ficelles) `crafts.lua:138,145` · `mobs:lasso` (4 ficelles +
  1 diamant) `crafts.lua:119,126` · `mobs:shears` ciseaux (2 acier + bâton) `crafts.lua:155,162` · `mobs:saddle`
  selle (6 `group:leather` + 2 acier) `crafts.lua:231,238` · `mobs:nametag` (papier, teinture noire, ficelle)
  `crafts.lua:67,74` · `mobs:protector` rune (8 pierre + bloc d'or) `crafts.lua:171` · `mobs:protector2` ·
  `mobs:fence_top` `crafts.lua:265,279` · `mobs:fence_wood` (via `default.register_fence`, `crafts.lua:251`) ·
  `mobs:leather` `crafts.lua:82` (butin seulement) · `mobs:meat_raw`/`mobs:meat` (cuisson) · `mobs:meatblock`.
  `mobs:mob_reset_stick` hors créatif (`crafts.lua:303`) ; `mobs:spawner` sans recette (`spawner.lua`).
- Événements détectables : craft filet/lasso/ciseaux/selle/étiquette/rune/barrière (F, grille standard) ; pose de
  `mobs:fence_wood`/`mobs:fence_top` (F, nœuds par défaut) ; manger `mobs:meat` (F, `core.item_eat`) ; apprivoiser,
  capturer, tondre, traire (A, enveloppe §3) ; relâcher un animal (I) ; naissance (A difficile / I, §3).
- Montures : `mobs.attach` → **`player:set_attach(entity.object, …)` `mount.lua:151`** (a établi) ; détache
  `mount.lua:175`. Seul `mob_horse` l'utilise parmi les mods audités (grep `mobs.attach`).
- Limites / privilèges : `protection_bypass` permet de capturer le mob d'autrui (`api.lua:4228`) ; privilège
  `peaceful_player` (`init.lua:5`). Commande `clear_mobs` réservée `server`.
- Réglages : `mobs_spawn`, `mob_active_limit` (bloque naissances et œufs, `api.lua:1376`), `mobs_griefing`.

### mobs_animal (mod `mobs_animal`) — sources auditées : mobs_animal @ 49a43c8
- Rôle : animaux de ferme. Dépendances : `mobs` ; optionnelles `default, farming, lucky_block`.
- Entités = œufs d'apparition (`mobs:register_egg`, nom identique) + `_set` capturés (voir verified) :

| Entité | Nourriture (`follow`) | Repas → apprivoisé / reproduction | Capture main/filet/lasso % | Source |
|---|---|---|---|---|
| `mobs_animal:cow` | blé, `default:grass_1`, orge, avoine, seigle | 8 / oui | 0/5/60 ; **traite** au seau | `cow.lua:28,104,145,159` |
| `mobs_animal:sheep_<couleur>` (15) | idem vache | 8 / oui | 0/5/60 ; **tonte** (propriétaire, `wool` requis) ; teinture | `sheep.lua:88,146,258,291,386` |
| `mobs_animal:chicken` | graines (`farming:seed_*`) | 8 / oui | 30/50/80 ; pond `mobs:egg` | `chicken.lua:6,65,85` |
| `mobs_animal:bunny` | carotte, herbe | 4 / oui | 30/50/80 | `bunny.lua:61,73,75` |
| `mobs_animal:kitten` | rat, poisson cru, `mobs:glass_milk` | 4 / oui | 50/50/90 | `kitten.lua:79,92,107` |
| `mobs_animal:pumba` (phacochère) | pomme, pomme de terre | 8 / oui | 0/5/50 | `warthog.lua:6,71,79` |
| `mobs_animal:panda` | bambou | 20 / oui | 0/5/50 | `panda.lua:71,77,79` |
| `mobs_animal:penguin` | poisson | 4 / **non** | 5/50/80 | `penguin.lua:59,70,72` |
| `mobs_animal:rat` | fromage, graines | 4 / oui | 50/90/0 **sans apprivoiser** | `rat.lua:48,64` |
| `mobs_animal:bee` | — | — | 50/90/0 **sans apprivoiser** → objet `mobs_animal:bee` | `bee.lua:56` |

- Objets utiles : `mobs:beehive` ruche = **3 abeilles capturées** (`{"mobs:bee"×3}`, alias `bee.lua:88`), recette
  `bee.lua:170`, nœud `bee.lua:103` (pose standard, `after_place_node` 1 chance/4 de libérer une abeille) ·
  `mobs:honey` (butin, `item_eat`) `bee.lua:92` · `mobs:honey_block` `bee.lua:177,185` · `mobs:bucket_milk`
  (traite, `item_eat` → rend le seau) `cow.lua:220` · `mobs:glass_milk` (craft 4 verres + seau de lait) `cow.lua:231,240`
  (**aussi enregistré par animalworld** `yak.lua:203` : définitions concurrentes) · `mobs:butter` (seau + `farming:salt`)
  `cow.lua:264,279` · `mobs:cheese` (cuisson) · `mobs:cheeseblock` `cow.lua:306,314` · `mobs:egg` (nœud posable,
  lancer = poussin 1/10) `chicken.lua:237` · `mobs:chicken_egg_fried` (cuisson) · `mobs:rabbit_hide`, `mobs:chicken_feather`.
- Événements : craft ruche/beurre/verre de lait/bloc de fromage/bloc de miel (F) ; pose ruche, œuf, bloc de fromage
  (F) ; manger seau de lait, miel, fromage (F) ; traite (`core.add_item`/`inv:add_item`, `cow.lua:178-185`) et tonte
  (`core.add_item`, `sheep.lua:302`) **sans événement** → A (§3). La traite n'exige pas d'être propriétaire.
- Réglages : `mobs_animal.<mob> = false` désactive un animal (`init.lua:21`) ; `mobs_animal.eat_grass_block`.

### mob_horse (mod `mob_horse`) — sources auditées : mob_horse @ aa3ad5e
- Entité **`mob_horse:horse`** (`init.lua:59`), œuf `mob_horse:horse` (`init.lua:286`, posable en zone protégée),
  capturé `mob_horse:horse_set`. Nourriture : blé, pomme, avoine, orge, maïs (`init.lua:84`), **10 repas** →
  apprivoisé + reproduction (`init.lua:174`). Capture **lasso seul, 100 %**, propriétaire (`init.lua:247`).
- Selle : clic droit du **propriétaire** avec `mobs:saddle` sur cheval adulte (`init.lua:199-207`, objet retiré par
  `inv:remove_item`, aucun événement). Monter : sellé + propriétaire → `mobs.attach` (`init.lua:250-251`) →
  `set_attach` (`mobs/mount.lua:151`) ⇒ **(a) établi, (b) `mob_horse:horse`**, (c) aucun attachement parasite connu
  pour cette entité. Fers : `mobs:horseshoe_steel|bronze|mese|diamond` (crafts `init.lua:295-343`),
  `mobs:horseshoe_crystal` seulement si `ethereal` (`init.lua:354`).
- Événements : craft fers/selle (F) ; monter à cheval (A, `integrations/rides.lua`, famille `horse`) ; ferrer (A, §3).

### animalworld (mod `animalworld`) — sources auditées : animalworld @ ac835da (2024, ancien)
- Rôle : ~90 animaux sauvages. Dépendances : **`mobs` seul** (`mod.conf`) ; optionnelles `default, bucket, farming,
  ethereal, xocean, fishing, hunger_ng…`. **Ne dépend ni de creatura ni de mob_core** (grep vide) → ces deux mods
  sont hors périmètre ici. **Aucune monture** (grep `set_attach`/`mobs.attach` vide).
- Mécanisme : identique à mobs_redo (`feed_tame` + `capture_mob` dans chaque `on_rightclick`, toujours
  `force_take = false` ⇒ apprivoiser d'abord). Reproduction (`breed = true`) : anteater, beluga, blackgrouse, boar,
  camel, clamydosaurus, cockroach, crab, divingbeetle, echidna, fox, frog, gnu, hare, hermitcrab, iguana, kangaroo,
  koala, lobster, marmot, monkey, moose, muskox, nandu, notoptera, nymph, orangutan, oryx, reindeer, snail, tapir,
  tortoise, treelobster, wildboar, yak, zebra. Apprivoisables sans reproduction : la plupart des autres. Non
  interactifs : ant, goldenmole, kobra, mosquito, rat, scorpion, spider(male), termite, viper, wasp. `tiger` :
  chances de capture toutes à 0. Les mobs `type = "monster"` (bear, crocodile, wolf, elephant…) capturés donnent
  l'œuf simple, sans propriétaire à la relâche (`mobs/api.lua:4111`). Détail : relevé par fichier `<espèce>.lua:3-5`.
- Objets fabricables : `animalworld:bucket_milk` (yak, traite `yak.lua:76-90`), `animalworld:butter`
  `yak.lua:236,246`, `animalworld:cheeseblock` `yak.lua:287` ; trophées/peaux/tabourets (`trophies.lua`, ~80 recettes)
  **à partir de cadavres** (`animalworld:boarcorpse` + outil, `trophies.lua:593-608`) = chasse (ton pacifique à
  peser) ; réglage `animalworld.trophies` (`settingtypes.txt:2`).
- Événements : crafts beurre/bloc de fromage/trophées (F) ; apprivoiser/capturer (A, même adaptateur §3).

### leads (mod `leads`) — sources auditées : leads @ 49d3740
- Objet `leads:lead` laisse (`items.lua:32`), craft 4 `farming:string` + 1 `mesecons_materials:glue` (sinon ficelle)
  `items.lua:47-57`. Usage : clic droit sur un animal ou une barrière (`on_secondary_use`/`on_place` =
  `leads.on_lead_use`, `api.lua:463`) → `leads.add_lead` crée une **entité `leads:lead`** (`api.lua:111-141`,
  `leads.lua:536`) et consomme l'objet (`api.lua:447-451`). **Pas de `set_attach` du joueur** : la laisse est une
  entité physique ; rien pour `rides.lua`.
- API publique : fonctions (`add_lead`, `find_lead_by_leader` `api.lua:224`, `is_leashable` `api.lua:151`) mais
  **aucun callback d'événement**. Détection : A par `core.override_item("leads:lead")` enveloppant `on_secondary_use`
  et `on_place` (original d'abord ; succès si la pile renvoyée a diminué **et** `pointed_thing.ref` est un mob
  `_cmi_is_mob`) — sinon faux positifs : nouer à une barrière, **tenir un joueur en laisse** (autorisé par défaut,
  `settingtypes.txt:50`). Réglages : `leads.allow_leash_unowned` (vrai), `respect_protection`.

### mobs_npc (mod `mobs_npc`) — sources auditées : mobs_npc @ 7b71dcb — **à exclure des quêtes**
- Entités `mobs_npc:npc`, `mobs_npc:igor`, `mobs_npc:trader` (`npc.lua:32`, `igor.lua:32`, `trader.lua:62`),
  apprivoisables/capturables via les mêmes utilitaires. Les « gardes royaux » relèvent probablement de
  `minerland_fix_npc` (**sans source, non audité**) : l'adaptateur §3 doit **exclure** le préfixe `mobs_npc:` et les
  entités de ce mod.

---

## Chapitre 6 — « La ferme aux animaux »
Du filet à la selle : fabriquer ses outils d'éleveur, gagner la confiance des bêtes, puis récolter miel et lait.
Les gestes sur animaux (apprivoiser, capturer, monter) passent par un adaptateur ; tout le reste est fiable par le
moteur. Branche suggérée : filet → ruche → pose ; selle → monter à cheval (prérequis apprivoiser).

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch06.net_maker` | « Le filet du bon berger » | craft | `mobs:net` | F | — | — | 5 bâtons + 2 `farming:string` (`crafts.lua:145`) |
| `ch06.honey_hive` | « Trois abeilles et un toit » | craft | `mobs:beehive` | F | — | — | demande 3 `mobs_animal:bee` capturées (main 50 %, filet 90 %) ; prérequis `net_maker` |
| `ch06.hive_home` | « La ruche au jardin » | place | `mobs:beehive` | F | — | — | nœud standard (`bee.lua:103,130`) ; prérequis `honey_hive` |
| `ch06.fresh_milk` | « Un seau de lait tiède » | eat | `mobs:bucket_milk` | F | — | — | traite d'une vache au `bucket:bucket_empty` ; un seau offert validerait aussi (limite commune aux `eat`) |
| `ch06.saddle_up` | « Cuir, acier et patience » | craft | `mobs:saddle` | F | — | — | cuir = butin de vache/cheval (`group:leather`) |
| `ch06.trusted_friend` | « Apprivoiser une bête de la ferme » | custom | `mobs_animal:cow`, `mobs_animal:sheep_white`, `mobs_animal:chicken`… | A | `mobs:tame:<entité>` ; enveloppe `on_rightclick` (§3) | — | 4 à 20 repas selon l'espèce ; exclure `mobs_npc:*` |
| `ch06.in_the_net` | « Pris au filet » | custom | `mobs_animal:chicken`, `mobs_animal:bunny` (via `mobs:net`) | A | `mobs:capture:<entité>` ; enveloppe `on_rightclick` | — | animal apprivoisé et possédé ; pas de compteur > 1 (boucle relâche) |
| `ch06.horse_ride` | « En selle, cavalière ! » | custom | entité `mob_horse:horse` | A | `rides:horse` ; `integrations/rides.lua` (`get_attach`, `mount.lua:151`) | — | cheval apprivoisé (10 repas), sellé, à soi ; prérequis `saddle_up` + `trusted_friend` |

Hors tableau : craft `mobs:shears` / `mobs:nametag` / `mobs:horseshoe_steel` (F) ; tondre (`mobs:shear`, A),
mettre en laisse (`leads:lead`, A par `override_item`), « prêt à se reproduire » (`mobs:breed_ready`, A).
Impossibles (I) : relâcher un animal (entité, §4), naissance fiable sans injecter `on_breed`, tout ce qui repose sur
le wiki Petz.

---

### currency (mod `currency`) — sources auditées : currency @ 6472e8b
- Objets : billets `currency:minegeld` (1), `currency:minegeld_5`, `_10`, `_50`, `_100` et pièces
  `currency:minegeld_cent_5|10|25` (`craftitems.lua:3-56`), `currency:minegeld_bundle` (liasse, 9 billets quelconques,
  combustible) `craftitems.lua:59`. Change par recettes `shapeless` réversibles (`crafting.lua:28-150`).
  Nœuds : `currency:safe` coffre-fort (8 acier + 1 cristal de mese) `safe.lua:32`, `crafting.lua:2` ;
  `currency:shop` boutique d'échange (`default:sign_wall` + `default:chest_locked`) `shop.lua:128`, `crafting.lua:13`
  (variante `currency:shop_empty`, sans recette, `shop.lua:214`) ; `currency:barter` table de troc
  (`default:sign_wall` + `default:chest`) `barter.lua:111`, `crafting.lua:20`. Recettes de nœuds seulement si `default`.
- Événements : crafts (F, grille standard) ; pose coffre/boutique/troc (F : `after_place_node`/`on_construct`, pas
  d'`on_place` personnalisé). **Échange en boutique** : géré dans un `register_on_player_receive_fields` global
  (`shop.lua:285-338`), sans API ni état avant/après exploitable → I. Troc à deux joueurs (`barter.lua:147-166`) → I.
- Revenu de base : `currency:minegeld_10` toutes les 720 s, versé au prochain dig/place/craft (`income.lua`,
  réglages `currency.income_*`) — l'argent arrive donc sans action commerciale : ne jamais valider sur possession.
- Limites : les recettes de change bouclent (5 × 1 ↔ 1 × 5) ⇒ pas de compteur de craft monétaire.

### atm (mod `atm`, `depends.txt` : default, currency, mesecons?) — sources auditées : atm @ 1401a40
- Nœuds `atm:atm`, `atm:atm2`, `atm:atm3` (distributeurs, plafonds 1/10/100 billets) et `atm:wtt` (virements)
  `nodes.lua:3,22,40,61`. Recettes `crafts.lua:9-43` : acier, verre, `mesecons:wire_00000000_off` (si mesecons, sinon
  cuivre) et un billet (`currency:minegeld`, `_5`, `_10`) ; `atm2/atm3/wtt` demandent du mese.
- Mécanisme : clic droit → formulaire ; dépôt/retrait dans `register_on_player_receive_fields` (`receive_fields.lua:4-85`)
  sur un solde **public** `atm.balance[nom]` (table globale `init.lua:5`, sauvé dans le monde), départ 30, intérêt +5
  toutes les 1000 s (`interest.lua`). Pas de callback d'API.
- Événements : craft/pose (F). **Premier dépôt** : A — callback `receive_fields` propre (formulaires `atm.form*`,
  chargé après `atm` via `optional_depends`), bouton pressé `i1..c1000` positif **et** baisse du billet en inventaire
  constatée par `atm.balance` > valeur mémorisée au précédent formulaire. Faux positif : intérêt/virement reçu entre
  deux formulaires (borner à l'écart exact du bouton).

### luanti-smartshop (mod `smartshop`, « flux's fork ») — sources auditées : smartshop @ 8d73436
- Dépendances : `fmod`, `futil` (sources `fmod` @ b414049, `futil` @ b7ed1eb, dossiers serveur `luanti-*`/`minetest-*`) ;
  optionnelles `currency, default, mesecons, pipeworks…`. Version `2025-10-17`, Luanti ≥ 5.8.
- Nœuds : `smartshop:shop` (+ variantes d'état `_full`, `_empty`, `_used`, `_admin`, `drop = smartshop:shop`)
  `nodes/shop.lua:59-93` ; `smartshop:storage` (+ `_lacks_refill`, `_has_send`) `nodes/storage.lua:36-63` ; alias
  `smartshop:wifistorage` (`aliases.lua:1`). Recettes (si `default`) `crafting.lua:3-22` : boutique = 4
  `default:chest_locked` + 4 `default:sign_wall_wood` + `default:torch` ; stockage = 4 fragments de mese + 2 coffres
  verrouillés + 2 acier + cuivre.
- Pose : `after_place_node` partagé (`nodes/init.lua:4`), pas d'`on_place` ⇒ `item_place_node` ⇒ **place F**.
- **API d'achat publique** : `smartshop.api.register_on_purchase(callback)` (`api/purchase_mechanics.lua:23`),
  signature **`callback(player, shop, i)`** (`player` ObjectRef acheteur, `shop` objet `shop_class`, `i` index 1-4),
  appelée **après** un achat réussi par `api.try_purchase` (`purchase_mechanics.lua:65-70`, toutes mécaniques, y
  compris le rendu de monnaie `compat/currency.lua:189`) ; déjà utilisée par le mod (`compat/mesecons.lua:107`).
  Déclenchée par les boutons `buy<i>a|b` (`api/shop_class.lua:521-535`). Aussi `register_on_shop_empty|full`.
- **Adaptateur `integrations/smartshop.lua` (A)** : `register_on_purchase` → si `player` est un vrai joueur,
  `shop:get_owner() ~= nom` (**le propriétaire peut acheter dans sa propre boutique** en « vue client »,
  `shop_class.lua:530-533`) et `shop:get_pay_stack(i)` non vide (option « freebies ») ⇒ émettre
  `smartshop:purchase` pour l'acheteur ; option `smartshop:sale` pour `shop:get_owner()` s'il est connecté.
  Limite : comptes complices. Boutique illimitée = privilège `smartshop_admin` (`privs.lua`, réglage
  `smartshop.admin_shop_priv`) : pas une quête joueur, mais y acheter reste légitime.

### farebox (mod `farebox`, dépend de mesecons, default, doors) — sources auditées : farebox @ ae059f2 (2020)
- Nœuds `farebox:farebox` (craft 7 acier + `mesecons:mesecon`) `init.lua:153,192` ; `farebox:faregate`
  (farebox + `doors:door_steel`) `faregate.lua:5,79` ; `farebox:faregate_open` (sans recette).
- Paiement : formulaire, objet demandé quelconque, global `register_on_player_receive_fields` (`init.lua:68-116`) →
  impulsion mesecons / ouverture ; **pas d'API** ; le propriétaire peut ouvrir sans payer (`init.lua:106`) ⇒ I.
  Craft/pose (F).

### moremachines (mod `moremachines`, `depends.txt` : default, **homedecor**, food) — sources @ 715d5b0 (2017)
- Nœuds `moremachines:cashregister`, `change_machine`, `atm_machine`, `locker` (`money_machines.lua:15,51,93,126`,
  préfixe ajouté `handlers/registration.lua:35`) ; objets `moremachines:creditcard`, `dollar`, `10dollars`
  (`money_machines.lua:148,181,198`). **Aucune recette** sauf variantes verrouillées (`handlers/inventory.lua:175`) ;
  README : « Only for creative ». Les distributeurs fonctionnent au **coup de poing** (`on_punch`) et détruisent un
  billet pour faire apparaître `homedecor:coin` (`money_machines.lua:62-81`), objet absent du homedecor actuel.
- **Chargement douteux** : dépend d'un mod nommé `homedecor`, inexistant dans `homedecor_modpack` audité (seulement
  `homedecor_common`, `homedecor_*`) ⇒ à confirmer sur le serveur. Toutes actions : I.

---

## Chapitre 9 — « Les affaires sont les affaires »
Faire de la monnaie, mettre son or au coffre, ouvrir sa boutique puis conclure une vraie vente. Le commerce est une
branche indépendante (aucun prérequis hors chapitre). Branche suggérée : change → coffre ; boutique → première vente ;
distributeur → premier dépôt.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch09.small_change` | « Faire de la monnaie » | craft | `currency:minegeld` | F | — | — | casser un `currency:minegeld_5` (`crafting.lua:95`) ; une seule fois (boucle de change) |
| `ch09.safe_keeping` | « Un coffre pour mes économies » | craft | `currency:safe` | F | — | — | 8 acier + cristal de mese |
| `ch09.safe_installed` | « Le coffre est scellé » | place | `currency:safe` | F | — | — | propriétaire fixé à la pose (`safe.lua:45`) ; prérequis `safe_keeping` |
| `ch09.market_stall` | « Mon étal d'échange » | place | `currency:shop` | F | — | — | variante vide `currency:shop_empty` non posable |
| `ch09.smart_crafter` | « La boutique intelligente » | craft | `smartshop:shop` | F | — | — | 4 coffres verrouillés, 4 panneaux, torche |
| `ch09.shop_opening` | « Ouverture officielle » | place | `smartshop:shop` | F | — | — | prérequis `smart_crafter` |
| `ch09.first_purchase` | « Première affaire conclue » | custom | `smartshop:shop` | A | `smartshop:purchase` ; `smartshop.api.register_on_purchase` (`purchase_mechanics.lua:23`) | — | exclure achat chez soi et prix vide ; dépend d'une boutique tierce approvisionnée |
| `ch09.bank_deposit` | « Dépôt au guichet » | custom | `atm:atm` | A | `atm:deposit` ; `receive_fields` + `atm.balance` | — | craft `atm:atm` (F) possible en variante ; versions serveur à vérifier |

Impossibles (I) : échange `currency:shop` (pas d'API), troc `currency:barter`, paiement `farebox`, toutes les machines
`moremachines` (sans recette, créatif, chargement douteux). Ne jamais valider sur la possession de Minegeld (revenu de
base automatique, dons).

<!-- source : docs/audit/ch07_ch08.md -->
### Audit — Chapitre 7 « Les petits plats dans les grands » et Chapitre 8 « L'art de la décoration »

Agent `mod-researcher`, 17/11/2026. Sources en lecture seule dans `.audit_src/` (branches principales clonées en
novembre 2026) : **les versions installées sur le serveur peuvent différer**, toute référence est à revérifier à
l'exécution (`core.registered_items`). Identifiants non littéraux : `docs/audit/verified_ch07_ch08.txt`.
Le serveur n'a ni `thirsty`, ni `hbhunger`, ni `hunger_ng`, ni `diet`, ni `hud` (liste `server_mods.txt`) : les chemins
« sans faim » des mods ci-dessous sont ceux qui s'exécutent.

## 0. Mods sans source auditable (à signaler « non audité », aucun identifiant cité)

`ma_pops_furniture`, `ilights`, `morelights`, `glass_stained`, `abriglass` (et `abripanes`), `scifi_nodes`, `artdeco`,
`church`, `billboard`, `led_marquee`, `mailbox` (mod autonome — ne pas confondre avec `xdecor:mailbox`), `fireworkz`,
`bakedclay`, `colored_concrete`, **`unifieddyes`** (dépendance obligatoire de `homedecor_common`), `hbdrunk`, `friandises`.
Aucun n'est dans `tools/audit_sources.txt` ni dans `.audit_src/`. Pour les utiliser : ajouter leur dépôt au manifeste,
relancer `tools/fetch_sources.sh`, puis refaire un audit. Le dossier serveur `stairs` est audité ici d'après la copie de
`minetest_game` (`minetest_game/mods/stairs`) ; une variante différente n'est pas exclue.

---

## 1. Mods du chapitre 7

### BBQ (mod `bbq`) — sources auditées : bbq @ 1a72f7c
- Rôle : grills (bouilloire, propane, fumoir), sauces, épices, ~40 plats crus/cuits, bière, tas de bois.
- Dépendances : `mod.conf` ne contient que `name` ; le moteur lit alors `depends.txt` : `default` ; optionnelles
  `bucket, mobs, mobs_animal, craft_guide, food, crops, vessels, farming, xdecor`.
- Objets utiles : `bbq:kettle_grill` — barbecue bouilloire — définition effective `kettle.lua:260` (une 1re définition
  `crafts.lua:2` est écrasée, kettle.lua étant chargé après) ; recette `cooking.lua:16` (acier + 2 `bbq:charcoal_lump`) ·
  `bbq:propane_grill` — `propane_grill.lua:260`, recette `cooking.lua:36` (acier, verre, `bbq:propane`) ·
  `bbq:propane_grill_pro` — `propane_grill_pro.lua:260` · `bbq:smoker` — fumoir — `smoker.lua:260`, recette `cooking.lua:6`
  (5 acier + bois) · `bbq:charcoal_lump` — `crafts.lua:82`, recette shapeless tronc + torche `cooking.lua:146` ·
  `bbq:propane` — `crafts.lua:127`, recette 8 acier + torche `cooking.lua:116` · `bbq:beef_raw`/`bbq:beef` —
  `crafts.lua:777/784` · `bbq:hamburger_patty_raw` (`crafts.lua:413`, grille : 1 `bbq:beef_raw`, `cooking.lua:274`) →
  cuisson → `bbq:hamburger_patty` (`crafts.lua:406`, `cooking.lua:502`) · `bbq:hamburger` — `crafts.lua:399`, grille
  shapeless `farming:bread` + steak cuit (`cooking.lua:267`) · `bbq:hotdog` (`crafts.lua:420`, `cooking.lua:281`) ·
  `bbq:veggie_kebab` (`crafts.lua:203`, cuisson de `_raw` `cooking.lua:534`) · `bbq:tomato_sauce` (`crafts.lua:553`,
  grille `cooking.lua:398`) · `bbq:beer` — **nœud** — `crafts.lua:147`, grille shapeless seau d'eau + `bbq:yeast` + blé +
  sucre + verre (`cooking.lua:166`) · `bbq:yeast` (`crafts.lua:760`, lâchée par les herbes, `overrides.lua:58-79`) ·
  ustensiles `bbq:spatula` (`crafts.lua:832`, étain `default:tin_ingot`), `bbq:basting_brush`, `bbq:grill_brush`.
- Événements détectables :
  - manger : **tous les plats** (crus et cuits), `bbq:beer`, `bbq:sugar`, `bbq:pickled_peppers`, `bbq:tomato_sauce`
    ont `on_use = minetest.item_eat(n)` (`crafts.lua:173-579, 631, 671`) → `eat` **F**. Sauces, saumure, vinaigre,
    paprika, levure : pas d'`on_use` → non consommables.
  - fabriquer : sauces, plats crus, burgers/hot-dogs/sandwichs, grills, combustibles = grille standard → `craft` **F**.
  - cuire : tous les plats « cuits » (`type = "cooking"`, `cooking.lua:492-707`) sortent du grill/fumoir/four par
    `get_craft_result({method="cooking"})` dans `on_timer` (`kettle.lua:133`, `smoker.lua:133`…) → **pas** de `craft`.
    Récupérer le plat cuit : **A** possible en enveloppant `on_metadata_inventory_take` (non défini par bbq, liste `dst`)
    via `core.override_item` sur les 4 nœuds (+ variantes `_active`) ; sans adaptateur → **I**.
  - poser : grills et fumoir n'ont pas d'`on_place` → `core.item_place_node` → `place` **F** (clé = nom de l'objet posé).
    Cas du `bbq:kettle_grill` : son `after_place_node` remplace le nœud par `bbq:kettle_grill_base` + grill au-dessus
    (`kettle.lua:323-326`) mais le callback de pose reçoit bien `bbq:kettle_grill` (copie de `newnode`). Les nœuds
    `*_active` / `bbq:kettle_grill_base` ne doivent jamais être ciblés.
- Limites : `bbq:garlic`, `bbq:garlic_clove`, `bbq:garlic_braid` sont des sorties de recettes **jamais enregistrées**
  (`cooking.lua:415-436`) → inutilisables. Les vaches `mobs_animal` lâchent `bbq:beef_raw` (surcharge de la table
  `drops`, `overrides.lua:56-63`, à confirmer en jeu). Groupes alimentaires fournis par farming redo/mobs (poivron,
  oignon, fromage `mobs:cheese`/`farming:cheese_vegan`, sel `farming:salt`, poivre moulu `farming:pepper_ground`).
- Réglages : aucun `settingtypes`.

### canned_food (pas de `mod.conf` : nom = dossier `canned_food`) — sources auditées : canned_food @ 4d061e9
- Rôle : bocaux (nœuds posables) de confitures et conserves, version « marinée » `_plus` au bout d'un temps en cave.
- Dépendances : `default, vessels, flowers` ; optionnelles `ethereal, farming, unified_inventory` (`depends.txt`).
- Objets : boucle `init.lua:298-430` (31 produits, enregistrés si le mod source est présent ; confitures sucrées si
  `farming`). Exemples : `canned_food:apple_jam` (3 pommes + `vessels:glass_bottle`), `canned_food:canned_tomato`,
  `canned_food:strawberry_jam`, `canned_food:honey_jar`… (liste dans le fichier vérifié).
- Événements : fabrication = recettes **shapeless en grille** (`init.lua:409-427`) → `craft` **F** ; manger →
  `minetest.item_eat(n, "vessels:glass_bottle")` (`init.lua:324-326`) → `eat` **F** (y compris `_plus`, `init.lua:387`) ;
  poser un bocal → nœud standard → `place` **F**. La transformation en `_plus` est passive (`on_timer`, `set_node`,
  lumière ≤ 11 + bois voisin, 10 % toutes les 180 s, `init.lua:344-359`) → **I** en tant qu'action (mais manger le
  produit `_plus` reste **F**).

### wine (mod `wine`, TenPlus1) — sources auditées : wine @ 763ec46
- Rôle : fût de fermentation, ~22 boissons (verres et bouteilles), agave.
- Dépendances : aucune obligatoire ; optionnelles `default, …, unified_inventory, thirsty, farming, vessels`.
- Objets : `wine:wine_barrel` — fût — `init.lua:252`, recette grille 6 bois + 2 acier (`init.lua:639-646`) ;
  verres `wine:glass_<boisson>` / bouteilles `wine:bottle_<boisson>` construits par `wine:add_drink` (`init.lua:94-169`,
  liste `drinks.lua:3-24`) ; `wine:blue_agave` (`agave.lua:16`, `item_eat`).
- Événements :
  - boire un verre : `on_use` → `core.do_item_eat(...)` (`init.lua:117-128`) → `eat` **F**. Les **bouteilles** n'ont
    pas d'`on_use` (`init.lua:136-151`) : décor posable, non consommables.
  - fermenter : le fût fonctionne par minuteur sur son inventaire (`init.lua:485-632`) → **pas** de `craft`. Important :
    avec **unified_inventory présent** (cas du serveur), `wine:add_item` n'enregistre qu'un type d'aide visuel « barrel »
    et **aucune recette en grille** (`init.lua:61-74`) ; sans UI, une recette « chère » incluant le fût serait créée.
  - grille standard **F** : `wine:wine_barrel`, 9 verres ↔ 1 bouteille (`init.lua:155-167`), `wine:glass_mint`
    (`drinks.lua:87-93`), `wine:glass_margarita` (`drinks.lua:138-144`). `wine:glass_brandy` = cuisson (`drinks.lua:26`).
  - poser le fût : `on_place` commenté (`init.lua:268`) → `place` **F**.
- Remarque roleplay : boissons sans alcool disponibles (`kefir`, `sparkling_*_juice`, groupe `alcohol = 0`).
  `hbdrunk` (serveur, **non audité**) réagit peut-être à l'alcool : vérifier qu'il ne capture pas `register_on_item_eat`.

### drinks (mod `drinks`) — sources auditées : drinks @ 5c0c081
- Rôle : pressoir à jus, tonneau et silo de stockage, jus en verre/bouteille/seau.
- Dépendances : `bucket, default, vessels, stairs` ; optionnelles `thirsty, farming, ethereal, …`.
- Objets : `drinks:juice_press` (`drink_machines.lua:69`, recette `drink_machines.lua:3-10` : bâtons, acier, seau vide,
  2 `stairs:slab_wood`, verre), `drinks:liquid_barrel` (`:382`), `drinks:liquid_silo` (`:499`) ; jus construits en
  boucle (`drinks2.lua:3-60`, car `thirsty` absent) : `drinks:jcu_<fruit>` (verre), `drinks:jbo_<fruit>` (bouteille),
  `drinks:jsb_<fruit>`, `drinks:jbu_<fruit>` (seau). Fruits : `apple, cactus, blueberries` (default) + farming/ethereal.
- Événements : boire `jcu`/`jbo`/`jsb` → `core.item_eat` (`drinks2.lua:31-35`, `:44-46`) → `eat` **F** ; seaux `jbu` :
  pas d'`on_use`. Presser : bouton de formspec + minuteur (`drink_machines.lua:96-258`) → **pas** de `craft` ;
  récupération par `on_metadata_inventory_take` (`:259`) → **A** possible (enveloppe). Poser pressoir/tonneau → **F**.
- **Effet de bord majeur** : `core.register_alias_force('farming:carrot_juice', 'drinks:jcu_carrot')` et idem
  `farming:pineapple_juice` (`init.lua:160-161`) **désenregistrent** les jus de farming (drinks est chargé après
  farming). La recette farming du jus de carotte (`farming/item_recipes.lua:359`) produit donc `drinks:jcu_carrot`.
  La quête existante `ch03.recipe` (cible `farming:carrot_juice`) reste valable **si** la résolution d'alias du moteur de
  quêtes (`U.resolve_item`) suit l'alias : à tester.

### food (modpack rubenwardy : mods `food` + `food_basic`) — sources auditées : food @ 9b97006
- Rôle : API + plats de base (jus, soupes, gâteaux, chocolat) avec repli si d'autres mods fournissent les ingrédients.
- Dépendances : `food_basic` → `food` ; nombreuses optionnelles (`depends.txt`) dont `farming, mobs, ethereal, vessels`.
- Objets : préfixe `:food:` dans des `food.module` ; `food:apple_juice`, `food:orange_juice` (boucle
  `food_basic/init.lua:138-155`), `food:cake` (`:185`, cuisson de `food:cakemix_plain`), soupes crues/cuites (`:107-131`).
  Avec farming redo, les modules `dark_chocolate` et `baked_potato` sont **désactivés** (`support.lua:78-81`).
- Événements : `food.item_eat` → `minetest.item_eat` quand diet/hud/hbhunger absents (`food/init.lua:171-187`) → `eat`
  **F**. Jus = grille (fruit + verre, `food_basic/init.lua:146-152`) → `craft` **F** ; gâteaux/soupes cuits = cuisson → I.
- Risques : `food/init.lua` **remplace les fonctions globales** `minetest.register_item/register_node/register_craft`
  (enveloppes transparentes, `:82-129`) et appelle `minetest.setting_getbool` (`:15, 191, 210`), API dépréciée : vérifier
  dans les journaux du serveur que le mod se charge sur Luanti 5.15.

### jelys_pizzaria (mod `jelys_pizzaria`) — sources auditées : jelys_pizzaria @ 21ad7cd
- Rôle : pizzas assemblées **dans le monde** (pâte posée → rouleau → sauce → fromage → garnitures → four → roulette).
- Dépendances : `default, vessels, flowers, farming` ; optionnelles `mobs, stairs, fire, …`.
- Objets : `jelys_pizzaria:dough` (`nodes.lua:10`, grille `farming:flour` + seau d'eau `items.lua:110-117`),
  `jelys_pizzaria:rolling_pin` (`items.lua:36`, `on_place` neutralisé l.60), `jelys_pizzaria:pizza_cutter`,
  `jelys_pizzaria:pizza_oven` (`oven.lua:277`, recette 8 `jelys_pizzaria:reinforced_brick` `oven.lua:321-328`),
  `jelys_pizzaria:sauce`, `jelys_pizzaria:cheese` (`mutation_backup.lua:44`, or + mutateur !),
  `jelys_pizzaria:cheese_pizza_slice` (`nodes.lua:136`, `item_eat`).
- Événements : grille **F** (pâte, rouleau, roulette, four, briques) ; poser la pâte / le four → **F** (pas d'`on_place`) ;
  étapes d'assemblage = `on_rightclick`/`on_dig` + `set_node` (`nodes.lua:23-27, 60-77`) et tranches par `add_item`
  → **I** ; manger une part → `eat` **F**. Le fromage coûte un lingot d'or : plat « avancé ».

### waffles (mod `waffles`) — sources auditées : waffles @ f9ee996
- Objets (préfixe = nom du mod) : `waffles:waffle_maker`, `waffles:waffle_batter`, `waffles:waffle`,
  `waffles:waffle_quarter`, `waffles:waffle_stack` (voir fichier vérifié).
- Événements : gaufrier et pâte en grille → `craft` **F** ; poser le gaufrier → **F** ; la gaufre s'obtient en frappant le
  gaufrier (`maker.lua:94-110`, `inv:add_item`) → **I** ; manger `waffles:waffle`/`_quarter` (`item_eat`) → **F**.
- Réglages : `waffles.waffle_batter_recipe` change la pâte ; les réglages du gaufrier sont lus sous un nom mal
  orthographié (`crafitem_…`, `maker.lua:203-205`) → recette par défaut (étain, acier, cuivre) de fait.

### appliances (mod `appliances`, sfence) — sources auditées : appliances @ 6fe2c25
- **Bibliothèque** (API de machines utilisée par `chair_lift`, `power_generators`) : aucun objet, aucun ustensile de
  cuisine. Rien à retenir pour le chapitre 7.

### ethereal (nourriture seulement) — sources auditées : ethereal @ c467e70
- Aliments `food.lua` : `ethereal:banana`, `ethereal:orange`, `ethereal:lemon`, `ethereal:banana_bread`,
  `ethereal:hearty_stew` (`:236`, grille oignon + 2 champignons + tubercule + bol `:247-254`), `ethereal:lemonade`
  (**boisson sans alcool**, `:361`, grille citron + 2 sucres + verre + seau d'eau `:380-389`), sushis, poissons…
  Tous via `core.item_eat` (pomme dorée et fugu via `do_item_eat`) → `eat` **F** ; recettes non « cooking » → `craft` **F**.

### mobs_redo / mobs_animal — ids seulement (sources : mobs @ bb7e3d5, mobs_animal @ 49a43c8)
`mobs:cheese` (`mobs_animal/cow.lua:287`, cuisson de `mobs:bucket_milk` `:297-300`), `mobs:cheeseblock`, `mobs:butter`,
`mobs:bucket_milk`, `mobs:glass_milk`, `mobs:egg` (`chicken.lua:237`), `mobs:chicken_egg_fried` (cuisson), `mobs:meat_raw`,
`mobs:meat` (`mobs/crafts.lua:90/101`), `mobs:chicken_raw/_cooked`, `mobs:pork_raw/_cooked` (`warthog.lua:116/127`),
`mobs:mutton_raw/_cooked` (`sheep.lua:522/533`), `mobs:rabbit_raw/_cooked`, `mobs:honey` (`bee.lua:92`). Tous `item_eat`.
L'obtention dépend des mobs (traite, chasse) : garder ces objets comme **ingrédients**, pas comme cible de quête.

### farming (redo) — compléments chapitre 7 (sources : farming @ 26b6fc5 ; houes/labour : voir verified_part1.txt)
- Ustensiles (objets réutilisables rendus par `replacements`) : `farming:saucepan`, `farming:pot`, `farming:baking_tray`,
  `farming:skillet`, `farming:mortar_pestle`, `farming:cutting_board`, `farming:juicer`, `farming:mixing_bowl`
  (`item_non_food.lua:22-78`), recettes en grille `item_recipes.lua:1276-1358` (acier, argile cuite, pierre, verre) ;
  `farming:bowl` (`item_non_food.lua:248`, 3 bois `item_recipes.lua:1600-1606`).
- Plats en grille (`craft` F) : `farming:salad` (`:741`), `farming:burger` (`:730`), `farming:blueberry_pie` (`:374`),
  `farming:tomato_soup` (`:394`), `farming:mac_and_cheese`, `farming:spanish_potatoes`, `farming:gyoza`… ; cuisson (non
  craft) : `farming:bread`, `farming:baked_potato`, `farming:sugar` (`:1495-1555`).
- Manger : 70 `on_use` dans `item_food.lua`, tous `core.item_eat`/`do_item_eat` → `eat` **F**. Boissons :
  `farming:glass_water`, `farming:coffee_cup` (nœud), `farming:mint_tea`, `farming:smoothie_*` (jus de carotte/ananas :
  voir alias forcé de `drinks`).
- Wiki (`tutoriels_fruits_legumes.txt`) : liste des cultures et hauteurs de récolte, utile pour les indices.

## 2. Réponses chapitre 7

1. **Consommation (`eat`)** : passent par `item_eat`/`do_item_eat` — bbq (plats, bière **nœud**, sucre, poivrons au
   vinaigre, sauce tomate), canned_food (tous), wine (**verres** seulement), drinks (verres/bouteilles, pas les seaux),
   food, jelys (parts), waffles, farming, ethereal, mobs. Les boissons **sont bien « mangées »** via item_eat.
   Attention : `core.do_item_eat` s'arrête au premier callback `register_on_item_eat` qui renvoie une valeur ; un mod non
   audité (`hbdrunk`) pourrait masquer l'événement : à tester en jeu.
2. **Transformations** : grille → plats crus, burgers, sandwichs, sauces, conserves, jus `food`, limonade, salade,
   ustensiles, fût, pressoir, grills. Hors grille (non `craft`) → cuisson (four, grills, fumoir), fermentation (fût
   `wine`), pressoir (`drinks`), gaufrier, four à pizza, maturation des bocaux. Les nœuds de production sont tous
   posables avec `place` **F** : `bbq:kettle_grill`, `bbq:propane_grill`, `bbq:propane_grill_pro`, `bbq:smoker`,
   `wine:wine_barrel`, `drinks:juice_press`, `drinks:liquid_barrel`, `waffles:waffle_maker`, `jelys_pizzaria:pizza_oven`.
3. Candidats ci-dessous.

### Chapitre 7 — quêtes candidates
Intro : découverte gourmande (la faim est désactivée, la nourriture soigne). On commence par équiper sa cuisine, puis
deux branches parallèles (barbecue / cave et boissons) qui convergent vers un plat élaboré.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch07.kitchenware | « Batterie de cuisine » | craft | `farming:saucepan`, `farming:pot`, `farming:skillet`, `farming:cutting_board`, `farming:juicer`, `farming:mixing_bowl`, `farming:baking_tray` | F | — | aucun | racine ; recettes simples (acier/argile/verre) |
| ch07.jam | « Mise en bocal » | craft | `canned_food:apple_jam` (+ autres `canned_food:*` du fichier vérifié) | F | — | aucun | 3 pommes + bouteille ; prérequis : kitchenware |
| ch07.bbq_grill | « Allumer le barbecue » | place | `bbq:kettle_grill`, `bbq:propane_grill`, `bbq:propane_grill_pro`, `bbq:smoker` | F | — | aucun | branche barbecue ; ne pas cibler `*_active`/`_base` |
| ch07.burger | « Le burger du chef » | craft | `bbq:hamburger`, `bbq:bacon_cheeseburger`, `bbq:hotdog` | F | — | aucun | exige un steak cuit sur le grill ; après bbq_grill |
| ch07.barrel | « La cave du domaine » | place | `wine:wine_barrel` | F | — | aucun | branche boissons |
| ch07.drink | « À votre santé ! » | eat | sans alcool : `ethereal:lemonade`, `food:apple_juice`, `drinks:jcu_apple`, `wine:glass_sparkling_apple_juice`, `wine:glass_kefir` ; avec : `wine:glass_cider`, `wine:glass_wine`, `bbq:beer` | F | — | aucun | après barrel ; tester l'interaction `hbdrunk` |
| ch07.juice_press | « Pressé comme un citron » | place | `drinks:juice_press` | F | — | aucun | option ; récupérer le jus = A (enveloppe `on_metadata_inventory_take`) |
| ch07.grand_dish | « Banquet de Minerland » (final) | craft | `farming:salad`, `farming:burger`, `farming:blueberry_pie`, `ethereal:hearty_stew`, `farming:spanish_potatoes` | F | — | aucun | prérequis : burger + drink |
| ch07.grill_master | « Sorti du gril » (variante) | custom | plats cuits `bbq:*` pris dans la liste `dst` | A | `bbq:cooked` — `core.override_item` des 8 nœuds grill (on_metadata_inventory_take absent d'origine) | aucun | faux positif : plat déposé puis repris par un autre joueur |
| (écarté) | maturation des bocaux, assemblage pizza, gaufre au gaufrier | — | — | I | — | — | `set_node`/`add_item` sans événement ; remplacer par `eat` de `waffles:waffle` ou `jelys_pizzaria:cheese_pizza_slice` (F) |

Bilan ch07 : 8 F, 1 A, 3 I documentés.

---

## 3. Mods du chapitre 8

### homedecor_modpack (modpack, 36 mods) — sources auditées : homedecor_modpack @ 992739d
- Mods (nom `mod.conf`) : `homedecor_common` (dépend de `basic_materials, unifieddyes, xcompat`), `building_blocks`,
  `fake_fire`, `homedecor_3d_extras`, `homedecor_bathroom`, `homedecor_bedroom`, `homedecor_books`,
  `homedecor_climate_control`, `homedecor_clocks`, `homedecor_cobweb`, `homedecor_doors_and_gates`,
  `homedecor_electrical`, `homedecor_electronics`, `homedecor_exterior`, `homedecor_fences`, `homedecor_foyer`,
  `homedecor_furniture`, `homedecor_furniture_medieval`, `homedecor_gastronomy`, `homedecor_inbox`, `homedecor_kitchen`,
  `homedecor_laundry`, `homedecor_lighting`, `homedecor_misc`, `homedecor_office`, `homedecor_pictures_and_paintings`,
  `homedecor_plasmascreen`, `homedecor_roofing`, `homedecor_seating`, `homedecor_tables`, `homedecor_trash_cans`,
  `homedecor_wardrobe`, `homedecor_windows_and_treatments`, `itemframes`, `lavalamp` (tous dépendent de `homedecor_common`).
- Nommage : `homedecor.register(name)` → `core.register_node(":homedecor:"..name)` (`homedecor_common/registration.lua:119`) ;
  d'où des ids non littéraux (fichier vérifié). Les lampes existent en 15 niveaux `_0`…`_14` (`homedecor_lighting/init.lua:212`) ;
  les recettes produisent des **alias** (`homedecor:table_lamp_hi` → `homedecor:table_lamp_11`, `:1466-1481`).
- **Pose** : pas de `homedecor.place_node`. Nœuds simples → pose moteur → `place` **F**. Nœuds **multi-blocs**
  (`expand = {top|right|forward}`) → `on_place` personnalisé (`registration.lua:69-76`) qui pose par `core.set_node`
  (`expansion.lua:83-110`) **sans** callbacks de pose → **I** en `place` (fabriquer → `craft` F). Concernés :
  `homedecor_exterior:32,60,316`, `homedecor_misc:329,355` (billard, piano), `homedecor_seating/misc.lua:16,38,96,129,228`
  (transats, bancs, chaises de bureau), `homedecor_kitchen:17,38`, `homedecor_doors_and_gates:384,408`,
  `homedecor_clocks:146`, `homedecor_office:50`, `homedecor_laundry:92`, `homedecor_foyer:46`, `homedecor_bedroom:112`
  (lits). Autres `on_place` perso : rampe (`homedecor.place_banister`, `homedecor_misc:502`), `homedecor_exterior:201`,
  `homedecor_wardrobe:105`, `homedecor_books:67`, `homedecor_tables/misc.lua:89` → considérer **non détectables**.
  `core.rotate_node` (`homedecor_lighting:626`, `homedecor_kitchen:479`, `homedecor_roofing`) passe par
  `item_place_node` → F.
- Nœuds orientables : le nom posé est celui de l'objet ; un clic droit ou un interrupteur change ensuite le nœud
  (rideau ouvert/fermé par `set_node`, lampes par `toggle_light`) — cibler le nom posé (ex. `homedecor:curtain_open`,
  `homedecor:table_lamp_11`).
- Sièges : `lrfurn.sit` attache le joueur par `set_attach` à l'entité `homedecor_seating:seat`
  (`homedecor_seating/init.lua:135-194`, entité `:88`) → « s'asseoir » **A** via `integrations/rides.lua`.
- Limite : `unifieddyes` (non audité) fournit `after_place_node`/couleurs ; il pourrait surcharger des `on_place` :
  pour les nœuds `ud_param2_colorable` (lampes, rideaux), confirmer la pose en jeu.

### moreblocks (mod `moreblocks`) — sources auditées : moreblocks @ 8c3de6c
- Objets : `moreblocks:circular_saw` (`circular_saw.lua:426`), recette acier + 5 `group:wood` (`crafting.lua:640-649`,
  désactivable par `moreblocks.circular_saw_crafting = false`) ; Stairs+ : `moreblocks:<catégorie>_<matériau><variante>`
  (`stairsplus/common.lua:190`), ex. `moreblocks:stair_wood`, `moreblocks:slab_wood`, `moreblocks:micro_wood`.
- **Alias forcés** : pour les nœuds de `default`, `stairs:stair_*`, `stairs:slab_*`… deviennent des alias de
  `moreblocks:*` (`stairsplus/registrations.lua:75-78`) — ex. `stairs:slab_wood` → `moreblocks:slab_wood`.
- Événements : scie et escaliers/dalles en grille (`stairsplus/recipes.lua:349`, 6 blocs → 8 escaliers) → `craft` **F** ;
  pose de la scie (pas d'`on_place`, `after_place_node` ne fait que nommer le propriétaire) et des formes Stairs+
  (`core.item_place`, `common.lua:121`) → `place` **F**.
- **Découper à la scie** : la forme est prise dans la liste `output` de l'inventaire du nœud ; aucun `register_on_craft`.
  Adaptateur **A** peu invasif : `core.override_item("moreblocks:circular_saw", {on_metadata_inventory_take = …})`
  qui appelle d'abord l'original (`circular_saw.on_metadata_inventory_take`, `circular_saw.lua:348-366`) puis émet
  `moreblocks:saw_cut` si `listname == "output"` et joueur réel. Un seul nœud enveloppé, aucune boucle. Faux positifs :
  reprendre une forme recyclée (le recyclage passe aussi par `output`) ; acceptable pour une quête de découverte.
  Sans adaptateur : se limiter à fabriquer/poser la scie.

### xdecor (variante **X-Decor-libre**, mod `xdecor`) — sources auditées : xdecor @ 43a7753
- Dépendances : `default, bucket, doors, farming, stairs, xpanes` ; `min_minetest_version = 5.9`.
- Nommage : `xdecor.register(name)` → `xdecor:<name>` (`handlers/registration.lua:101,149`).
- Objets : `xdecor:workbench`, `xdecor:lantern`/`xdecor:lantern_hanging`, `xdecor:candle`, `xdecor:chair`,
  `xdecor:table`, `xdecor:cushion`, `xdecor:curtain_red` (seule couleur, `src/nodes.lua:238-240`),
  `xdecor:woodframed_glass`, `xdecor:painting_1..4` (sources : fichier vérifié).
- Pose : par défaut ou `rotate_node` → **F**. Lanterne : `on_place` perso qui appelle `core.item_place_node` avec
  `xdecor:lantern` ou `xdecor:lantern_hanging` (`src/nodes.lua:522-575`) → **F** (cibler les deux). Tableau : objet
  `xdecor:painting_1`, pose aléatoire de `painting_1..4` via `item_place_node` (`:704-741`) → **F** (cibler les quatre).
- Établi : la découpe (`workbench:get_output`, `src/workbench.lua:131-373`) passe par l'inventaire du nœud → pas de
  `craft` ; même technique d'adaptateur que la scie possible (non recommandé en plus de la scie).
- S'asseoir (chaise, coussin) : `set_pos` + `player_api.player_attached`, **pas** de `set_attach`
  (`handlers/animations.lua:60-75`) → **I** pour la détection « monter à bord ».

### signs_lib (mod `signs_lib`) — sources auditées : signs_lib @ 897b30b
- Ré-enregistre `default:sign_wall_wood` et `default:sign_wall_steel` (`standard_signs.lua:6,24`) ; pas d'`on_place` ;
  `after_place_node` peut convertir en `_onpole`, `_hanging`, `_yard` (`api.lua:943-986`) mais le callback de pose reçoit
  le nom posé → `place` **F** sur `default:sign_wall_wood`. Écrire un texte : `on_receive_fields` → contenu non fiable,
  **I** (au mieux A sans contrôle du texte). Privilège `signslib_edit` seulement pour éditer les panneaux d'autrui.

### stairs (copie `minetest_game/mods/stairs`) — sources : minetest_game @ 9e895af
`stairs.register_stair_and_slab` (`init.lua:430`) ; pour les matériaux de `default`, les ids `stairs:*` sont des alias
forcés vers `moreblocks:*` (voir moreblocks). Utiliser les noms `moreblocks:` dans les quêtes.

## 4. Réponses chapitre 8

1. Ids : voir tableau et fichier vérifié. homedecor n'a pas de `place_node` maison : les nœuds simples sont F, les
   multi-blocs (`expand`) et quelques `on_place` perso sont **non détectables** en `place`. xdecor : F partout (lanterne
   et tableau via `item_place_node`). moreblocks : F (`core.item_place`).
2. Scie : `moreblocks:circular_saw` (acier + bois) ; découpe = **A** par enveloppe d'un seul nœud (coût faible).
3. Multi-nœuds/orientables : le callback reçoit le nom de l'objet posé (`bbq:kettle_grill`, `default:sign_wall_wood`,
   `homedecor:table_lamp_11`) ; homedecor multi-blocs : aucun callback. xdecor lanterne/tableau : nom réellement posé.

### Chapitre 8 — quêtes candidates
Intro : aménager sa maison. L'établi xdecor sert de porte d'entrée, puis branches libres (lumière, mobilier, textiles,
vitrage) ; la scie circulaire ouvre une branche « menuiserie ».

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch08.workbench | « L'atelier du décorateur » | craft | `xdecor:workbench` | F | — | aucun | racine (4 planches) |
| ch08.light | « Que la lumière soit » | place | `xdecor:lantern`, `xdecor:lantern_hanging`, `xdecor:candle`, `homedecor:candle`, `homedecor:oil_lamp`, `homedecor:oil_lamp_tabletop` | F | — | aucun | bougie homedecor : `basic_materials:paraffin` + `farming:string` |
| ch08.seat | « Une chaise pour souffler » | place | `xdecor:chair`, `xdecor:cushion`, `homedecor:kitchen_chair_wood`, `homedecor:armchair` | F | — | aucun | éviter bancs/transats homedecor (multi-blocs) |
| ch08.table | « Mettre la table » | place | `xdecor:table` | F | — | aucun | 3 `stairs:slab_wood` (alias moreblocks) + 2 bâtons |
| ch08.sign | « Bienvenue chez moi » | place | `default:sign_wall_wood` | F | — | aucun | via signs_lib ; texte non vérifiable |
| ch08.window | « Une vue imprenable » | place | `xdecor:woodframed_glass`, `homedecor:window_quartered` | F | — | aucun | vitrage |
| ch08.textiles | « Tapis et rideaux » | place | `homedecor:rug_small`, `homedecor:rug_persian`, `homedecor:rug_large`, `homedecor:curtain_open`, `xdecor:curtain_red` | F | — | aucun | laine teinte requise |
| ch08.painting | « Une touche d'art » | place | `xdecor:painting_1`, `xdecor:painting_2`, `xdecor:painting_3`, `xdecor:painting_4` | F | — | aucun | pose aléatoire d'un des 4 |
| ch08.saw | « Menuisier de précision » | craft | `moreblocks:circular_saw` | F | — | aucun | branche menuiserie |
| ch08.stairs | « Monter d'un étage » | craft | `moreblocks:stair_wood` | F | — | aucun | grille 6 planches → 8 |
| ch08.saw_cut | « Coupe sur mesure » | custom | formes prises dans `output` de la scie | A | `moreblocks:saw_cut` — `core.override_item` de `moreblocks:circular_saw` (on_metadata_inventory_take) | aucun | après ch08.saw |
| ch08.sit | « Le fauteuil du maître » | custom | entité `homedecor_seating:seat` | A | `rides:seat` — adaptateur générique `rides.lua` (`get_attach`) | aucun | pas pour xdecor (pas de set_attach) |
| (écarté) | poser lit/piano/billard homedecor, écrire un panneau | — | — | I | — | — | `set_node` sans callback / texte libre : remplacer par `craft` |

Bilan ch08 : 10 F, 2 A, 2 I documentés.

## 5. Points bloquants / à vérifier sur le serveur
1. 15 mods du périmètre ch08 sans source (§0), dont `unifieddyes` (requis par homedecor) : aucun id cité.
2. `drinks` désenregistre `farming:carrot_juice`/`farming:pineapple_juice` (alias forcés) : vérifier `ch03.recipe`.
3. `moreblocks` transforme `stairs:*` (matériaux default) en alias de `moreblocks:*`.
4. `food` : API `minetest.setting_getbool` dépréciée et surcharge des fonctions globales d'enregistrement.
5. `hbdrunk` (non audité) peut interférer avec `register_on_item_eat` pour les boissons alcoolisées.
6. `wine` : avec unified_inventory, aucune boisson de fût n'est fabricable en grille (seulement au fût).

<!-- source : docs/audit/ch10.md -->
### Audit — Chapitre 10 « Sur les chapeaux de roues ! » (véhicules terrestres, carburant)

Sources : `.audit_src/` (branche principale, nov. 2026). **Les versions serveur peuvent différer** : tout identifiant est
revérifié à l'exécution (`core.registered_items`). Identifiants non littéraux : `docs/audit/verified_ch10.txt`.

**`minekart`** (dossier serveur) : **pas de source disponible**, non audité. À noter : `automobiles_lib.minmax`
appelle encore la globale `minekart.sign` (`automobiles_pck/automobiles_lib/init.lua:106-108`, reste de code ancien,
fonction jamais appelée dans le pack). Aucun identifiant `minekart:*` ne doit être utilisé.

Règle commune aux trois mods de véhicules : **le véhicule est une entité**. L'objet d'inventaire a un `on_place`
personnalisé qui appelle `core.add_entity` sans `core.item_place_node` → `register_on_placenode` ne se déclenche
**jamais**. Il n'y a **aucun hook public** de pose. L'action fiable est donc la **fabrication** (grille standard).

---

### bike (mod `bike`) — sources auditées : bike @ 9912953
- Rôle : vélo (Hume2, d'après PilzAdam/GreenDimond). Une entité, pas de carburant.
- Dépendances : aucune obligatoire ; optionnelles skinsdb, skins, u_skins, simple_skins, wardrobe, rp_crafting (`mod.conf`).
- Objets utiles :
  - `bike:bike` — vélo (objet posé, `stack_max = 1`) — `bike/init.lua:701` ; entité du même nom `init.lua:698`
  - `bike:wheel` — roue de vélo (×2 par craft) — `init.lua:30`
  - `bike:handles` — guidon — `init.lua:35`
  - `bike:painter` — peinture de vélo (outil) — `init.lua:860`
  - (`bike:hand` — main factice pendant la conduite, `init.lua:176`, à ignorer)
- Recettes (grille standard, branche `else` de `init.lua:907`, `rp_crafting` absent du serveur) :
  - `bike:wheel 2` = croix de caoutchouc autour d'un lingot de fer — `init.lua:909-916`
  - `bike:handles` = 3 fer / caoutchouc, vide, caoutchouc — `init.lua:918-924`
  - `bike:bike` = guidon, vide, caoutchouc / 3 fer / roue, vide, roue — `init.lua:926-933`
  - « caoutchouc » = `group:wood` par défaut (`init.lua:41`) **mais `technic:rubber` si `technic` est chargé**
    (`init.lua:48-50`). Technic figure sur le serveur → le vélo exige du caoutchouc technic (cuisson de
    `technic:rubber_goo`, `technic/technic/crafts.lua:209-213`, latex par robinet `tree_tap.lua`). Fer = `default:steel_ingot`.
    → un vélo coûte 9 lingots d'acier + 13 caoutchoucs : ce n'est **pas** un objet de tout début de partie.
- Événements détectables :
  - craft `bike:wheel`, `bike:handles`, `bike:bike`, `bike:painter` → **F** (register_craft shaped).
  - pose du vélo → **I** (`on_place` → `minetest.add_entity`, `init.lua:707-754`).
  - monter à bord → **A** (§2 bis) : `clicker:set_attach(self.object, "body", …)` dans `on_rightclick`
    (`init.lua:272-334`, attache `init.lua:325`) ; entité `bike:bike` ; un seul conducteur, pas de passager.
    Descente : sneak (`init.lua:568`) → `set_detach` (`init.lua:247`).
- Mécanismes / limites : clic sur un vélo sans être monté = ramassage (`init.lua:364-442`). Peindre : frapper avec
  `bike:painter` (aucun événement moteur). Le peintre sert aussi aux autos d'APercy (`automobiles_lib/init.lua:684`).
- Réglages : `mount_ownable` (défaut `false`, `settingtypes.txt`) → si `true`, seul le propriétaire peut monter
  (`init.lua:278`). `bike_max_speed` etc. ne changent que la physique. Aucun privilège.

### automobiles_pck (modpack, 10 mods) — sources auditées : automobiles_pck @ 4e01858
Mods (nom `mod.conf`) : `automobiles_lib` (bibliothèque), `automobiles_beetle`, `automobiles_buggy`,
`automobiles_catrelle`, `automobiles_coupe`, `automobiles_delorean`, `automobiles_motorcycle`, `automobiles_roadster`,
`automobiles_trans_am`, `automobiles_vespa`. Tous dépendent de `automobiles_lib` ; la lib a en optionnel
`player_api, mcl_formspec, mcl_player, emote, biofuel, dg_mapgen`.

**Correspondance avec le wiki** : « 4L fourgonnette » = `automobiles_catrelle:catrelle_4f` (« Catrelle 4F »,
mod décrit « Une 4L pour mes amis français ») ; « DeLorean DMC-12 » = `automobiles_delorean:delorean` ;
« Vespa » = `automobiles_vespa:vespa`. **« Ford T » : aucun véhicule de ce nom dans les sources** (recherche « ford »
négative). Le plus proche est `automobiles_roadster:roadster` (« Roadster », roues bois à rayons, capote : la capture
`automobiles_roadster/screenshot.jpg` montre une Ford T). **Hypothèse à faire confirmer par l'administratrice** ;
l'identifiant, lui, est lu dans le code.

- Objets communs (`automobiles_lib`) :
  - `automobiles_lib:engine` — moteur — `automobiles_lib/init.lua:779` ; recette `init.lua:791-797` :
    3 `default:steel_ingot` / `default:steelblock`, `default:mese_block` (alias de `default:mese`), `default:steelblock`.
  - `automobiles_lib:wheel` — roue — `init.lua:785` ; recette `init.lua:798-805` : 4 `default:tin_ingot`,
    4 `default:steel_ingot`, 1 `default:steelblock`.
  - `automobiles_lib:painter` — peinture (outil) — `painter.lua:148` ; recette `painter.lua:175-181` (acier, dye rouge/vert/bleu).
  - (`automobiles_lib:light` — nœud technique airlike posé par les phares via `set_node`, `init.lua:658,464` : à ignorer.)
- Véhicules (objet posé = `register_tool`, `stack_max = 1` ; **nom d'entité = nom d'objet**) — toutes les recettes
  sont dans `if minetest.get_modpath("default")` :

| Objet posé (= entité) | Source objet / entité | Recette (grille) | Composants intermédiaires | Réservoir |
|---|---|---|---|---|
| `automobiles_roadster:roadster` (Ford T ?) | `roadster_crafts.lua:19` / `roadster_entities.lua:190` | `:58-64` 4 roues roadster + moteur + carrosserie | `automobiles_roadster:wheel` (`:13`, bois+bâtons `:73-80`), `automobiles_roadster:roadster_body` (`:8`, verre, acier, 1 bloc d'acier, bois `:65-72`) | 10 |
| `automobiles_buggy:buggy` | `buggy_crafts.lua:19` / `buggy_entities.lua:169` | `:58-64` | `automobiles_buggy:wheel` (`:13`, `:73-80`), `automobiles_buggy:buggy_body` (`:8`, 7 acier + verre `:65-72`) | 10 |
| `automobiles_beetle:beetle` | `crafts.lua:14` / `entities.lua:475` | `:91-97` 4 `automobiles_lib:wheel` + moteur + carrosserie | `automobiles_beetle:beetle_body` (`:8`, `:106-113`, 3 blocs d'acier) | 10 |
| `automobiles_beetle:beetle_conv` | `crafts.lua:51` / `entities.lua:489` | `:98-105` idem + `wool:white`, 2 `wool:black` | idem | 10 |
| `automobiles_catrelle:catrelle` (4L) | `crafts.lua:14` / `entities.lua:318` | `:99-105` | `automobiles_catrelle:catrelle_body` (`:8`, `:106-113`) | 10 |
| `automobiles_catrelle:catrelle_4f` (4L fourgonnette) | `crafts.lua:52` / `entities.lua:331` | `:93-98` **une Catrelle** + `default:glass` + `default:steelblock` (amélioration) | — | 10 |
| `automobiles_coupe:coupe` | `coupe_crafts.lua:14` / `coupe_entities.lua:198` | `:54-60` | `automobiles_coupe:coupe_body` (`:8`, `:61-68`) | 10 |
| `automobiles_delorean:delorean` | `crafts.lua:14` / `entities.lua:332` | `:94-100` | `automobiles_delorean:delorean_body` (`:8`, 6 blocs d'acier `:101-108`) | 10 |
| `automobiles_trans_am:trans_am` | `crafts.lua:14` / `entities.lua:255` | `:56-62` | `automobiles_trans_am:trans_am_body` (`:8`, `default:mese` + 4 blocs `:63-70`) | 10 |
| `automobiles_motorcycle:motorcycle` | `motorcycle_crafts.lua:18` / `motorcycle_entities.lua:99` | `:57-62` roue, carrosserie, roue | `automobiles_motorcycle:wheel` (`:12`, `:71-78`), `automobiles_motorcycle:body` (`:7`, contient le moteur `:63-70`) | 5 |
| `automobiles_vespa:vespa` | `vespa_crafts.lua:19` / `vespa_entities.lua:99` | `:58-63` roue, carrosserie, roue | `automobiles_vespa:wheel` (`:13`, étain + bloc `:72-79`), `automobiles_vespa:body` (`:8`, étain + moteur `:64-71`) | 3 |

  Non fabricables (aucune recette) : `automobiles_beetle:rc_beetle` (`crafts.lua:117`, voiture télécommandée),
  `automobiles_delorean:time_machine` (`crafts.lua:52`, pose l'entité `automobiles_delorean:delorean` avec
  `_car_type = 1` → case « Flight Mode », `forms.lua:38`). Ils ne sont distribués qu'en jeu « drift »
  (`automobiles_lib/init.lua:892-911`, inactif hors `dg_mapgen`) → **I**.
  Coût indicatif : toute voiture à 4 roues `automobiles_lib:wheel` ≈ 9 à 12 blocs d'acier + 1 bloc de mese (moteur) ;
  le roadster (roues en bois) et la Vespa sont les moins chers (≈ 3 blocs d'acier + moteur).
- Carburant : table `automobiles_lib.fuel` (`init.lua:24-26`) : `biofuel:bottle_fuel` = 1, `biofuel:phial_fuel` = 0,25,
  `biofuel:fuel_can` = 10, plus `biofuel:biofuel` et `airutils:biofuel` (**inexistants sur Minerland**, voir airutils).
  Chaque véhicule naît avec `_energy = 1` (ex. `automobiles_beetle/entities.lua:395`) ; consommation selon
  l'accélération (`automobiles_lib/entities.lua:723-747`, « Out of fuel »). Faire le plein = **frapper** le véhicule
  avec le carburant en main : `on_punch` → `automobiles_lib.loadFuel` (`entities.lua:134`, `fuel_management.lua:14-43`),
  qui retire l'objet par `inv:remove_item` (aucun callback) et affiche « Full tank! ».
- Événements détectables :
  - craft de chaque véhicule, carrosserie, roue, `automobiles_lib:engine` → **F**.
  - pose d'un véhicule → **I** (`on_place` → `minetest.add_entity`, ex. `automobiles_roadster/roadster_crafts.lua:25-51`).
    Enveloppe possible de `on_place` (`core.override_item`, comparer le compte de la pile) mais **déconseillée** :
    un véhicule donné par un autre joueur validerait, et le ramassage/repose est répétable.
  - monter à bord → **A** (§2 bis), deux schémas d'attache :
    (1) **voitures** (beetle, buggy, catrelle, coupe, delorean, roadster, trans_am) : le joueur est attaché à un
    **siège intermédiaire** `automobiles_lib:pivot_mesh` (`entities.lua:1`) — conducteur `init.lua:220`, passagers
    `init.lua:304,343` — lui-même attaché à la voiture (`init.lua:191-197`). L'adaptateur doit **remonter d'un niveau**
    (`parent:get_attach()`), exactement comme le fait le mod (`automobiles_lib.getCarFromPlayer`, `formspecs.lua:3-13`) ;
    (2) **moto et Vespa** : attache **directe** à l'entité (`motorcycle_player.lua:41,164`, `vespa_player.lua:39,152`).
    Conducteur vs passager : `luaentity.driver_name == nom` (`init.lua:216`, `vespa_player.lua:27`).
    Faux positifs : `pivot_mesh` sert aussi d'axe de volant (`entities.lua:325`, sans joueur) ; aucun PNJ.
  - faire le plein → **I en v1** (aucun événement public ; `loadFuel` est une fonction globale du mod, interdit de la
    remplacer). Option **A fragile** : envelopper `on_punch` des prototypes `core.registered_entities[...]`
    (appel de l'original puis comparaison de `self._energy` avant/après) — à justifier, sensible aux versions.
  - repeindre (colorants / peintres) → **I** (frappe d'entité, aucun événement).
- Privilèges / propriété : seul le **propriétaire** (le joueur qui a posé : `ent.owner = owner`, ex.
  `roadster_crafts.lua:40`) peut conduire ; un tiers ne monte qu'en **passager** et seulement si un conducteur est à bord
  (`entities.lua:63-99`). Privilège `valet_parking` (`init.lua:831`, non accordé par défaut) ou `server` : conduire la
  voiture d'autrui → **à ne jamais exiger**. `/transfer_vehicle` (`privs = {interact}`, `init.lua:836-867`) change le propriétaire.
- Réglages (`automobiles_lib/settingtypes.txt`) : `collect_automobiles` (défaut `true` ; si `false`, un véhicule détruit
  rend moteur + roues au lieu de l'objet, `init.lua:588-593`), `noob_mode`, `motorcycle_anim_mode`, `speed_limit`.
  Aucun ne désactive une recette.

### vehicles (mod `vehicles`) — sources auditées : vehicles @ dd795db (2023)
- Rôle : véhicules « arcade » de D00Med (voitures parodiques, tracteur, camions, mais aussi tank, jet, tourelle…).
  **Aucun carburant**.
- Dépendances : `player_api` ; optionnelles `default, tnt, dye, stairs, creative, sounds`.
  Les recettes ne sont chargées que si `default` **et** `dye` sont présents (`init.lua:1844-1846`).
- Objets utiles (composants, `crafting.lua`) :
  - `vehicles:wheel` — `crafting.lua:7`, recette `:78-85` (4 `default:coal_lump` + 1 acier)
  - `vehicles:engine` — `:12`, recette `:87-94` (2 cuivre, 3 acier, 1 `default:mese_crystal`)
  - `vehicles:body` — carrosserie — `:17`, recette `:96-103` (3 verre + 1 acier)
  - `vehicles:armor`, `vehicles:gun`, `vehicles:propeller`, `vehicles:jet_engine` (`:22-40`) : usages militaires/aériens.
- Véhicules : objet `<entité>_spawner` créé par `vehicles.register_spawner` (`api.lua:672-700`, liste vérifiée dans
  `verified_ch10.txt`). Voitures civiles « simples » : `vehicles:masda_spawner` (dye:magenta + carrosserie + 2 roues +
  moteur, `crafting.lua:121-128`), `masda2`, `nizzan`, `nizzan2`, `astonmaaton`, `pooshe`, `pooshe2`, `lambogoni`,
  `lambogoni2`, `fewawi`, `fewawi2`, `musting`, `musting2`, `policecar`, `ute`, `ute2` ; utilitaires : `tractor_spawner`
  (+ `farming:hoe_steel`, `:238-245`), `ambulance_spawner` (`:379`), `firetruck_spawner` (`:361`), `geep_spawner` (`:370`).
  `vehicles:fourd_spawner` (`init.lua:1197`) n'a **aucune recette** → I.
- Événements détectables :
  - craft des composants et des `*_spawner` → **F**.
  - pose → **I** (`on_place` → `minetest.add_entity`, `api.lua:678-698`).
  - monter à bord → **A** : `vehicles.object_attach` → `player:set_attach(entity.object, …)` (`api.lua:43-61`, l.48),
    nom d'entité = nom du spawner sans `_spawner` (ex. `vehicles:masda`, `init.lua:942`) ; conducteur = `luaentity.driver`
    (`api.lua:45`). Passagers attachés directement : geep (`init.lua:457`), ambulance (`:525`), ute (`:586`), ute2 (`:654`).
    Parasites à exclure : `vehicles:missile` (clic droit attache le joueur, `init.lua:96-98`), parachute
    (`vehicles:backpack`, `init.lua:1714`), ailes `vehicles:wings` (`init.lua:1802`).
- Limites : **aucune propriété** (`object.owner = placer` est stocké mais jamais vérifié) : n'importe qui conduit
  n'importe quel véhicule. Explosion au contact de la lave ; tank/jet/tourelle/assault suit tirent des missiles
  (`tnt.boom`, `init.lua:82-84`) → **hors thème pacifique, à ne pas proposer**. Le tracteur détruit `farming:wheat_8`
  (`init.lua:432`, sans `node_dig` : pas d'événement `dig`). Avertissement : mod non maintenu depuis 2023
  (`minetest.env:` encore utilisé, `init.lua:41`).
- Réglages : `vehicles_nodes` (`settingtypes.txt`) — inopérant en pratique (`init.lua:1848` lit `vechicles_nodes`… `or true`).

### Biofuel (mod `biofuel`) — sources auditées : biofuel @ 959aa0d
- Rôle : raffinerie de biomasse → biocarburant (Lokrates). **Il n'existe ni pressoir ni huile propre au mod** : une seule
  machine, `biofuel:refinery`.
- Dépendances : aucune obligatoire ; optionnelles `default, mcl_core, hades_core, fl_*, pipeworks, hopper, wine,
  cucina_vegana, farming, basic_materials`.
- Objets utiles :
  - `biofuel:refinery` — raffinerie — `refinery.lua:499` ; état actif `biofuel:refinery_active` (`:554`, via swap).
    Recette MTG `refinery.lua:638-646` : 6 `default:tin_ingot` + 3 `default:glass`.
  - `biofuel:phial_fuel` — fiole (0,25 plein) — `biofuel.lua:10` ; produit par la raffinerie (4 biomasses → 1 fiole,
    `refinery.lua:328-359`) ; aussi `biofuel:bottle_fuel` → 4 fioles (`biofuel.lua:21-24`).
  - `biofuel:bottle_fuel` — bouteille (groupe `biofuel`) — `biofuel.lua:29` ; shapeless 4 fioles (`:35-39`) ou 9 depuis un bidon (`:48-52`).
  - `biofuel:fuel_can` — bidon (10 = plein d'une auto) — `biofuel.lua:57` ; recette 9 × `group:biofuel` (`:68-75`).
    Le groupe est aussi ajouté à des alcools `wine:bottle_*` et à `farming:bottle_ethanol`, `farming:hemp_oil`,
    `farming:sunflower_oil`, `basic_materials:oil_extract` (`biofuel.lua:81-121`, seulement s'ils existent).
  - Biomasse acceptée : groupes `flora, leaves, flower, sapling, tree, wood, stick, plant, seed`… (`refinery.lua:48`)
    + liste de nœuds (`:55`) ; nourriture seulement si `food_fuel` (`:96`, `:162-177`).
- Événements détectables :
  - pose de `biofuel:refinery` → **F** (pas d'`on_place` : placement par défaut, `on_construct` seulement `refinery.lua:388`).
  - craft `biofuel:bottle_fuel` (4 fioles), `biofuel:fuel_can`, `biofuel:refinery` → **F**.
  - production / retrait de la fiole dans la raffinerie → **I** (minuterie de nœud + `inv:set_stack`, `refinery.lua:361-386` ;
    le retrait passe par `on_metadata_inventory_take`, aucun événement de quête ; entrée possible par pipeworks/hopper).
  - faire le plein d'un véhicule → voir automobiles_pck (**I en v1**).
- Privilèges / protection : accès inventaire refusé en zone protégée d'autrui (`refinery.lua:405-462`). Aucun privilège.
- Réglages (`settingtypes.txt`) : `fuel_production_time` (10 s), `biomass_input` (4), `refinery_output` (`true` → la
  raffinerie produit des bouteilles), `food_fuel`, `refinery_log`. Aucun ne supprime une recette.

### airutils (mod `airutils`) — sources auditées : airutils @ 5c21c92 — partie commune seulement
- Rôle ici : bibliothèque d'APercy (avions) ; **aucun lien de code avec automobiles_pck** (la lib auto a sa propre
  copie de physique, peintre, inventaire). Seul point commun : le carburant.
- `airutils:biofuel` (`airutils_biofuel.lua:50`), l'alias `biofuel:biofuel` (`:61`) et la machine
  `airutils:biofuel_distiller` (`:85`, recette `:26-34`) ne sont chargés **que si le mod biofuel est absent**
  (test de la globale `biomass`, `init.lua:92-100`) ou si `airutils.force_enable_biofuel` est activé.
  Biofuel étant installé (et chargé avant, `optional_depends`), **ces objets n'existent pas sur Minerland** → ne pas
  les citer (contrôle à l'exécution recommandé).
- Réglages : `airutils_disable_tug`, `airutils_disable_repair`, `airutils_protect_in_areas`… concernent les avions.

---

## Chapitre 10 — « Sur les chapeaux de roues ! »

Du coup de pédale au plein de biocarburant : on assemble un vélo, on passe à la petite voiture « arcade » de D00Med,
puis aux automobiles d'APercy (Ford T supposée, 4L), qu'il faut alimenter avec la raffinerie de biomasse. Les poses de
véhicules ne sont pas détectables : la progression repose sur la **fabrication** et, via `integrations/rides.lua`,
sur le fait de **monter à bord**.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch10.first_bike` | « Deux roues et un guidon » | craft | `bike:bike` | F | — | aucun | caoutchouc technic exigé si technic actif (`bike/init.lua:48`) ; option préalable : craft `bike:wheel` |
| `ch10.bike_ride` | « En selle, Marcel ! » | custom | entité `bike:bike` | A | `rides:bike` — `rides.lua` lit `get_attach()` (attache `bike/init.lua:325`) | aucun | prérequis `ch10.first_bike` (sinon un vélo prêté suffit) |
| `ch10.city_car` | « Ma première citadine » | craft | `vehicles:masda_spawner` (ou liste des voitures civiles de `verified_ch10.txt`) | F | — | aucun | voie « véhicule simple », sans carburant ; ne pas inclure tank/jet/tourelle |
| `ch10.model_t` | « La doyenne des routes » | craft | `automobiles_roadster:roadster` | F | — | aucun | moteur `automobiles_lib:engine` (bloc de mese) ; « Ford T » = hypothèse à confirmer |
| `ch10.road_trip` | « Plein phares sur la départementale » | custom | entités `automobiles_*` (via `automobiles_lib:pivot_mesh`) | A | `rides:automobile` — remonter au parent du siège ; exiger `driver_name == joueur` | aucun | seul le propriétaire conduit (`entities.lua:63`) ; ~1 unité de carburant offerte |
| `ch10.refinery` | « L'alambic vert » | place | `biofuel:refinery` | F | — | aucun | branche carburant, faisable en parallèle dès l'étain |
| `ch10.fuel_can` | « Un bidon pour la route » | craft | `biofuel:fuel_can` | F | — | aucun | 9 `group:biofuel` ; variante plus simple : craft `biofuel:bottle_fuel` (4 fioles) |
| `ch10.delivery_van` | « La 4L fourgonnette » | craft | `automobiles_catrelle:catrelle_4f` | F | — | aucun | consomme une `automobiles_catrelle:catrelle` (amélioration) ; alternatives avancées : `automobiles_delorean:delorean`, `automobiles_vespa:vespa` |

Bilan : 6 F, 2 A, 0 I retenue. Arbre suggéré : `first_bike → bike_ride → city_car → model_t → road_trip` ;
branche `refinery → fuel_can` (indépendante, prérequis conseillé de `delivery_van`) ; `delivery_van` après `road_trip`
et `fuel_can`.

Écartées (I) : poser un véhicule (entités, aucun hook) ; faire le plein (pas d'événement public, enveloppe d'entité
fragile) ; récupérer une fiole de la raffinerie (minuterie + inventaire de nœud) ; repeindre ; `time_machine`,
`rc_beetle`, `fourd_spawner` (sans recette) ; tout ce qui exige `valet_parking`/`server` ; véhicules armés de `vehicles`.

<!-- source : docs/audit/ch11_ch12_ch15.md -->
### Audit — Chapitres 11 (Le monde ferroviaire), 12 (Métros et tramways), 15 (Prenons de la hauteur !)

Sources : `.audit_src/` (branches principales, nov. 2026). **Les versions installées sur le serveur peuvent différer** :
chaque identifiant est à revérifier à l'exécution (`core.registered_items`). Ids non littéraux : `verified_ch11_ch12_ch15.txt`.
Wiki lu : `regles_trains.txt`, `train_start.txt`, `regles_construction.txt`, `tutoriels_telesieges.txt`, `tutoriels_celevator.txt`.
Règle serveur (regles_trains.txt) : tout circuit est convenu avec l'administratrice, qui alloue les droits. **Aucune quête ne
doit demander de poser des rails, poser/conduire un train ou manœuvrer un aiguillage.**

## Réponses aux questions

**Q1 — Privilèges advtrains** (`advtrains/advtrains/protection.lua:8-28` ; guide `advtrains/privilege_guide.txt`) :

| Action | Privilège | Preuve |
|---|---|---|
| Poser un rail (placeur, rampe) | `track_builder` (ou `protection_bypass`) | `track_reg_helper.lua:516`, `:689` → `protection.lua:122-161` |
| Construire/creuser **à côté** d'un rail (1 bloc autour, 3 au-dessus, 1 dessous) : quais, signaux, décor | `track_builder` | surcharge de `minetest.is_protected`, `protection.lua:35-37,78-114` |
| Manœuvrer aiguillage / signal / croix de St-André | `railway_operator` | `tracks.lua:139-147`, `signals.lua:96,154`, `protection.lua:179-199` |
| Poser un wagon/loco (entité) | `train_operator` (+ zone non protégée sauf `train_admin`) | `wagons.lua:1453-1459` |
| Conduire (poste de conduite) / atteler / dételer | `train_operator` + propriétaire ou liste blanche (ou `train_admin`) | `protection.lua:164-178`, `wagons.lua:1288-1291,1310`, `couple.lua:203` |
| Outil d'enclenchement, sections, itinéraires | `interlocking` | `advtrains_interlocking/tool.lua:85,99`, `init.lua:39` |
| Rails LuaATC | `atlatc` | `advtrains_luaautomation/init.lua:17` |
| Configurer un rail d'arrêt (gare) | zone non protégée ⇒ `track_builder` de fait | `advtrains_line_automation/stoprail.lua:117` |

Exception : réglage `advtrains_allow_build_to_owner` (défaut `false`, `advtrains/settingtypes.txt`) autorise pose/manœuvre dans
une zone que le joueur protège lui-même. **Sans privilège**, un joueur peut : fabriquer tout objet (grille standard, aucune
vérification de privilège), poser quais/signaux/panneaux **hors** de la zone protégée des rails, et **monter comme passager**
(`wagon:on_rightclick`, `wagons.lua:662-746` : aucun test de privilège pour les groupes de sièges sans `driving_ctrl_access`).
Pose des rails : le placeur appelle `advtrains.trackplacer.place_track` → `advtrains.ndb.swap_node` → `minetest.swap_node`
(`trackplacer.lua:158-166`, `nodedb.lua:231-233`) ; la rampe utilise `minetest.set_node` (`track_reg_helper.lua:731`) :
**`register_on_placenode` n'est jamais déclenché** (et l'action est privilégiée) → I.
Recettes clés (grille standard) : `advtrains:dtrack_placer` ×50 = 6 `default:steel_ingot` + 3 `group:stick`
(`advtrains_train_track/init.lua:202-209`) ; `advtrains:wheel` (`crafting.lua:98-105`) ; `advtrains:boiler`, `driver_cab`,
`chimney` (`crafting.lua:78-115`) ; signaux (`crafting.lua:7-47`) ; `advtrains:trackworker` = diamant + tournevis + acier (`:68`).

**Q2 — Monter à bord (§2 bis)** : advtrains attache le voyageur **directement à l'entité wagon**, sans pivot :
`clicker:set_attach(self.object, …)` (`wagons.lua:775`). Nom d'entité = nom du wagon (`register_wagon` : préfixe `advtrains:`
ajouté si le nom n'a pas de `:`, `wagons.lua:1398-1404` ; même nom pour l'objet). Ex. `advtrains:subway_wagon`, `advtrains:bus`
(linetrack), `minitram_konstal_105:minitram_konstal_105_normal`, `advtrains_train_jpntlr600:front_unit`. Seul `set_attach` de joueur
dans tout le périmètre ferroviaire (`couple`, `discouple`, marqueurs d'interlocking ne portent pas de joueur). État public
complémentaire : `advtrains.player_to_train_mapping[nom]` (`wagons.lua:772`). Faux positifs : le conducteur (privilégié) est attaché
de la même façon → la quête « voyager » doit viser des voitures **voyageurs** (table famille limitée aux wagons `pass`). Entités
non sauvegardées (`get_staticdata`/`on_activate`, `wagons.lua:79-86,161`) : la lecture doit tolérer les déchargements.

**Q3 — Ch12** : quais `advtrains:platform_*` et `advtrains_platform:platform_*` = nœuds simples (`misc_nodes.lua:18-90`), pose par
`item_place_node` ; passages à niveau `advtrains_platform:*path_track_*` : `on_place = minetest.rotate_node` (passe par
`item_place_node`) ; `trainblocks:*` : nœuds simples sans `on_place` ; `metrosigns` : les panneaux sortent d'une **machine**
(`metrosigns:sign_writer`, prise dans l'inventaire du nœud, `machine.lua:640-672`) → ni `craft` ni grille ; seuls la machine et les
cartouches ont une recette (`machine.lua:750-806`, si `default` + `basic_materials`). `doxy_mini_tram` : pièces et tram craftables
(`minitram_crafting_recipes/init.lua:142-271`), le tram est une entité (pose `train_operator`).

**Q4 — Ch15** : voir chair_lift, celevator, elevator, travelnet ci-dessous. Aucun de ces mods n'expose de callback public
« mise en service » ; seules des enveloppes justifiées + lecture d'état public sont possibles.

## Chapitre 11 — mods

### advtrains (modpack) — sources auditées : advtrains @ 2b59ab8
- Rôle : cœur ferroviaire. Mods (`mod.conf`) : `advtrains`, `advtrains_interlocking`, `advtrains_line_automation`,
  `advtrains_luaautomation`, `advtrains_signals_japan`, `advtrains_signals_ks`, `advtrains_signals_muc_ubahn`, `advtrains_trackmap`,
  `advtrains_train_track`, `advtrains_assets`, `serialize_lib`.
- Dépendances : `advtrains` ← `serialize_lib` (opt. mesecons, mesecons_switch, digtron) ; les autres ← `advtrains` ou `advtrains_interlocking`.
- Objets utiles : `advtrains:dtrack_placer` (rails ×50) ; `advtrains:dtrack_sy_placer`, `advtrains:dtrack_s3_placer` (aiguillages),
  `advtrains:dtrack_slopeplacer`, `advtrains:dtrack_bumper_placer` — `advtrains_train_track/init.lua:184-645` ;
  `advtrains:wheel`, `advtrains:boiler`, `advtrains:driver_cab`, `advtrains:chimney` — `craft_items.lua:5-26` ;
  `advtrains:signal_off`, `advtrains:signal_wall_l_off`, `advtrains:retrosignal_off` (« deprecated ») — `signals.lua:46-237` ;
  `advtrains:across_off` (croix de St-André, sans recette) — `signals.lua:252` ; `advtrains_signals_ks:hs_danger_0`,
  `advtrains_signals_ks:mast_mast_0` — `advtrains_signals_ks/init.lua:244,575,609-623` ; `advtrains:platform_low_stonebrick`,
  `advtrains:platform_high_stonebrick` — `misc_nodes.lua:18-125` ; `advtrains_interlocking:tcb_node` (`tcb_ts_ui.lua:139`),
  `advtrains_interlocking:tool` (`tool.lua:133`) ; `advtrains_line_automation:dtrack_stop_placer` (`stoprail.lua:419`) ;
  `advtrains:trackworker` (`trackplacer.lua:348`) ; `advtrains:wagon_prop_tool` (`wagonprop_tool.lua:5`).
- Événements : craft de placeurs/roues/chaudière/signaux/quais → **F** ; pose d'un quai ou signal hors zone des rails → **F**
  (nœuds simples), mais près d'un rail exige `track_builder` ; pose de rail → **I** (swap_node + privilège) ; pose/conduite de wagon,
  aiguillage, interlocking, LuaATC → **I** (privilèges) ; voyager → **A** (rides, wagons.lua:775).
- Limites : wagons = entités (pas de `place`) ; les wagons n'ont pas de recette dans le cœur (fournis par les mods de trains).
- Réglages : `advtrains_allow_build_to_owner`, `advtrains_prot_range_side/up/down` (zone protégée autour des rails).

### advtrains_train_orient_express / advtrains_train_zugspitzbahn / tfl_s7_stock_modpack — sources : @ 4a16119 / 48d11c5 / 961d047
- Rôle : matériel roulant. Mods `advtrains_train_orient_express`, `advtrains_train_zugspitzbahn`, `tfl_s7_stock_modpack` (← advtrains).
- Objets : `advtrains:engine_electronic`, `advtrains:wagon_compartment`, `advtrains:wagon_sleep` (`orient_express/init.lua:64-217`) ;
  `advtrains:engine_zugspitzbahn`, `advtrains:wagon_zugspitzbahn` (`zugspitzbahn/init.lua:9,44`) ; `advtrains:under_s7dm`,
  `advtrains:under_s7ndm` (`tfl_s7_stock_modpack/init.lua:209,287`).
- Événements : **aucune recette** dans ces trois mods (grep `register_craft` vide) → craft I ; voyager **A** (voitures `pass`). La
  loco Zugspitzbahn n'a que des postes de conduite (`assign_to_seat_group={"dstand"}`) : un joueur ordinaire ne peut pas y monter.

### advtrains_train_jpntlr600 (mod `advtrains_train_jpntlr600`) — sources : @ 6f10f72
- Objets : `advtrains_train_jpntlr600:TLR0600_cabin` (craft, `init.lua:653-667`), `advtrains_train_jpntlr600:front_unit`,
  `advtrains_train_jpntlr600:back_unit` (`init.lua:33-34,668-685`). Variantes de couleur `Tlr600_<couleur>_front/back` via livrées.
- Événements : craft cabine/unités **F** (blocs d'étain, cuivre, acier, `advtrains:wheel`) ; voyager **A**.
- Réglages : `advtrains_train_jpntlr600_include_deprecated_trams`, `_illuminated_appearance` (`init.lua:12,19`).

### basic_trains (mods `advtrains_train_steam`, `_subway`, `_japan`, `_industrial`) — sources : @ 4eca8d9
- Objets : `advtrains:newlocomotive` (`advtrains_train_steam/init.lua:6,229` : cheminée, cabine, chaudière, 3 roues),
  `advtrains:wagon_default` (`:161,247`), `advtrains:wagon_box` (`:209,255`), `advtrains:subway_wagon` (`advtrains_train_subway/init.lua:3,148`),
  `advtrains:engine_japan`, `advtrains:wagon_japan` (`advtrains_train_japan/init.lua:26-190`, `xpanes:pane_flat`),
  `advtrains:engine_industrial` (`advtrains_train_industrial/init.lua:3,121`).
- Événements : craft **F** (coûteux : blocs d'acier) ; pose **I** (`train_operator`) ; voyager **A**.

### minetest-moretrains (dossier source `moretrains`, mods `moretrains_basic`, `_steam`, `_vintage`, `_japan`, `_industrial`, `_gondola`, `_nightline`) — @ 59ee0e4
- Pas de `mod.conf` sauf `moretrains_nightline` : nom = dossier. Objets : `advtrains:moretrains_silberling` (`moretrains_basic/init.lua:77,343`),
  `advtrains:moretrains_draisine` (`moretrains_vintage/init.lua:10,160`), `advtrains:moretrains_wagon_gondola` (`moretrains_gondola/init.lua:58,179`),
  `advtrains:moretrains_nightline_seat_car` (`moretrains_nightline/init.lua:83,140`) ; craft **F**, voyager **A**.

### advtrains_horntrack (mod `advtrains_horntrack`) — @ 9fd718c
- Objet : `advtrains_horntrack:horn_track_placer` = shapeless `advtrains:dtrack_placer` + `mesecons_noteblock:noteblock` (ou
  `farming:string`) (`tracks.lua:34,95-106,141`) ; variante tieless `:142`. Craft **F**, pose **I** (rail).

### luanti-tieless-tracks (dossier source `tieless_tracks`, mod `tieless_tracks`) — @ f38321b
- Dépend `advtrains, advtrains_train_track, advtrains_line_automation`. Objet : `advtrains:dtrack_tieless_placer` ×50 = 6 acier
  (`init.lua:10-26`) + aiguillages/croisements tieless. Craft **F**, pose **I**.

### minetest_tsm_railcorridors (source `tsm_railcorridors`, mod `tsm_railcorridors`) — @ 5b2016d
- Génération de galeries de mine (dépend `default, carts, tnt, farming`) : `carts:rail` (`gameconfig.lua:8`), coffres `default:chest`,
  wagonnets `carts:cart` (`gameconfig.lua:35-38`). Aucun objet propre. Creuser un `carts:rail` généré → **F** (`dig`, non posé par un
  joueur) ; piller un coffre → I (possession). Monter dans un `carts:cart` → **A** (rides : `carts/functions.lua:21`, entité
  `cart_entity.lua:385` ; objets d'inventaire aussi attachés, l.332, non-joueurs). Réglages `tsm_railcorridors_probability_*`.

### farebox (mod `farebox`, partie ferroviaire) — @ ae059f2
- Objets : `farebox:farebox` (`init.lua:153`, recette 7 acier + `mesecons:mesecon`, `:192`), `farebox:faregate` (`faregate.lua:5`,
  farebox + `doors:door_steel`, `:79`). Pose normale (`after_place_node`, pas d'`on_place`) → **F** ; craft **F**.
- Payer son billet : traité dans un `register_on_player_receive_fields` global (`init.lua:67-113`), seul signal = champ `buy` →
  **I** (champ de formulaire, règle 5).

## Chapitre 11 — quêtes candidates
Intro : la branche « cheminot » se joue côté atelier et quai — fabriquer pièces, rails et signaux pour les chantiers convenus avec
l'administratrice, aménager une gare hors des voies, puis voyager. Aucune quête ne pose de rail ni de wagon.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch11.wheelwright | Le charron du rail | craft | `advtrains:wheel` | F | — | aucun | tronc de la branche |
| ch11.rail_forge | Cinquante rails pour la Compagnie | craft | `advtrains:dtrack_placer`, `advtrains:dtrack_tieless_placer` | F | — | aucun | texte : « à remettre à l'administratrice » |
| ch11.signalman | Rouge, vert… en avant ! | craft | `advtrains:signal_wall_l_off`, `advtrains_signals_ks:hs_danger_0` | F | — | aucun | KS dépend d'interlocking |
| ch11.platform | Attention à la marche | place | `advtrains:platform_high_stonebrick`, `advtrains_platform:platform_high_stone` | F | — | aucun | poser hors zone des rails (sinon `track_builder`) |
| ch11.ticket_office | Le guichet de la gare | place | `farebox:farebox`, `farebox:faregate` | F | — | aucun | pré-requis : ch11.platform |
| ch11.old_mine | Les rails oubliés | dig | `carts:rail` | F | — | aucun | galeries tsm_railcorridors ; branche exploration |
| ch11.steam_engine | La locomotive à vapeur | craft | `advtrains:newlocomotive` (après `advtrains:boiler`, `advtrains:chimney`, `advtrains:driver_cab`) | F | — | aucun (pose : `train_operator`) | coûteux ; objet à confier à un conducteur |
| ch11.first_journey | En voiture ! | custom | entités `advtrains:wagon_default`, `advtrains:wagon_japan`, `advtrains:wagon_zugspitzbahn`, `advtrains:wagon_compartment`, `advtrains:moretrains_silberling` | A | `rides:train` — rides.lua, `get_attach()` → nom d'entité (`wagons.lua:775`) | aucun | dépend d'une ligne existante (Ch'Nord, Zoo, Zugspitzbahn…) |

## Chapitre 12 — mods

### advtrains_platform (pas de `mod.conf`, nom = dossier `advtrains_platform`) — @ 448513b
- Dépend `advtrains, default, stairs` (opt. moreblocks, ethereal, moreores, technic, bakedclay…). Utilise `advtrains.register_platform`
  pour chaque bloc de `list_default` (`init.lua:13-38,174-177`) et des mods optionnels présents (`init.lua:180-236`).
- Objets : `advtrains_platform:platform_low_stone` / `_high_stone` / `_high_cobble` (`misc_nodes.lua:18-121`) ; passages à niveau
  `advtrains_platform:stonebrickpath_track_1010` (`init.lua:391-496`, recette avec placeur rendu).
- Événements : craft **F** (jaune + bloc), pose **F** (nœuds simples / `rotate_node`). Hors zone de rails sans `track_builder`.

### metrosigns (mod `metrosigns`) — @ 43f079f
- Opt. `basic_materials, default, signs_api, trainblocks…`. Objets : `metrosigns:sign_writer` (`machine.lua:812`, recette
  `machine.lua:798` : plastique, acier, `basic_materials:energy_crystal_simple`, 2 `basic_materials:motor`), `metrosigns:cartridge_red`
  /`_green`/`_blue` (`:732-773`).
- Événements : craft machine/cartouches **F** ; pose machine **F** ; obtenir un panneau = prise dans la machine → **I** en `craft`
  (A possible par enveloppe `on_metadata_inventory_take`, non recommandé). Panneaux de ville selon réglages `metrosigns_create_*`
  (Londres seul par défaut, `init.lua:229-267`) ; blocs « trainblocks » non créés si `trainblocks` chargé (`init.lua:88`).

### trainblocks_bc (source `trainblocks`, mod `trainblocks`, fork probable) — @ a312afc
- Objets : `trainblocks:subwayblock` (`init.lua:19`, recette verre + teintures, `craft.lua:5`), `trainblocks:station_block` (`:303`, `craft.lua:23`),
  `trainblocks:line1`…`line10` (`init.lua:58`, `craft.lua:47-56`), `trainblocks:platformsign0…10` (`init.lua:88`, `craft.lua:59+`).
- Événements : craft **F**, pose **F** (pas d'`on_place`). Note : `trainblocks_disable_recipes` sans effet (variable globale
  testée à la place de la locale, `init.lua:13-15`) ; recettes `sbahnsignL/R` identiques (`craft.lua:171,180`) → éviter ces deux ids.

### doxy_mini_tram (modpack : `minitram_konstal_105`, `minitram_crafting_recipes`, `minitram_konstal_105_liveries`, `multi_component_liveries`, `visual_line_number_displays`) — @ 62438bd
- Objets : `minitram_crafting_recipes:minitram_template` (papier, `default:mese_crystal`, engrenage, teintures ; `init.lua:142-157`),
  `minitram_crafting_recipes:minitram_bogie` (`:245-262`), tram `minitram_konstal_105:minitram_konstal_105_normal` (`:263-271`).
  Ingrédients choisis à la volée (`choose`, `init.lua:3-11`) selon mods présents (technic, basic_materials…).
- Événements : craft **F** ; pose du tram **I** ; voyager **A** (sièges passagers, `minitram_konstal_105/init.lua:38-100`).

### linetrack (mod `linetrack`, côté rail/bus) — @ 2ae4e15
- **Aucune recette** dans le mod (grep vide) : lignes `linetrack:roadtrack_placer`, `linetrack:watertrack_placer`, quai
  `linetrack:lane_platform`, bus `advtrains:bus` et bateau `advtrains:boat` = créatif/admin. Voyager en bus → **A**
  (`advtrains:bus`, `roadline_bus.lua:10`, places `pass` portes ouvertes ou Maj). Tout le reste **I** pour joueur ordinaire.

## Chapitre 12 — quêtes candidates
Intro : la ville souterraine se reconnaît à sa signalétique : blocs lumineux, numéros de ligne, quais. Branche indépendante du
chapitre 11 (prérequis suggéré : ch11.wheelwright pour le tram).

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch12.subway_sign | Le M qui brille | craft | `trainblocks:subwayblock` | F | — | aucun | geste le plus simple |
| ch12.line_number | Ligne 1, direction Minerland | craft | `trainblocks:line1` | F | — | aucun | id de boucle (vérifié) |
| ch12.platform_number | Quai numéro un | place | `trainblocks:platformsign1` | F | — | aucun | |
| ch12.station_hall | Le hall de la station | place | `trainblocks:station_block` | F | — | aucun | |
| ch12.metro_platform | Quai de métro | place | `advtrains_platform:platform_high_stone`, `advtrains:platform_high_stonebrick` | F | — | aucun | hors zone protégée des rails |
| ch12.sign_writer | L'imprimerie des panneaux | craft | `metrosigns:sign_writer` | F | — | aucun | exige basic_materials |
| ch12.tram_template | Le gabarit du tramway | craft | `minitram_crafting_recipes:minitram_template` | F | — | aucun | branche tram |
| ch12.metro_ride | Prendre le métro | custom | entités `advtrains:subway_wagon`, `minitram_konstal_105:minitram_konstal_105_normal`, `advtrains_train_jpntlr600:front_unit`, `advtrains:bus` | A | `rides:metro` — rides.lua (`wagons.lua:775`) | aucun | ligne 1 du métro existante |

## Chapitre 15 — mods

### chair_lift (mod `chair_lift`) — @ 5f2d365
- Dépend `appliances, power_generators, basic_materials, adaptation_lib, adaptation_*`. Ingrédients résolus par `adaptation_lib`
  (`adaptation.lua:6-13` : fil d'acier, bobine vide, bloc/lingot d'acier ou variantes technic) → **revérifier les recettes en jeu**.
- Objets : `chair_lift:steel_rope` (`steel_rope.lua:71`, recette `crafting.lua:9`), `chair_lift:pole_body` (`chair_lift.lua:288`),
  `chair_lift:pole_arm` (`:311`), `chair_lift:pole_arm_shaft` (`:327`), `chair_lift:pole_arm_end` (`:359`), `chair_lift:wheel_powered`
  (`powered_wheel.lua:276`), `chair_lift:rope_wheel`, `chair_lift:wheel_part` (`craftitems.lua:4,9`), `chair_lift:seat` (objet `chair_lift_entity.lua:260`, recette `crafting.lua:86`).
- Événements : craft de toutes les pièces **F** ; pose pylônes/bras/roue **F** (nœuds sans `on_place`) ; pose du câble **I**
  (`on_place` custom + `minetest.set_node`, `steel_rope.lua:129-205`) ; pose du siège **I** (`minetest.add_entity`,
  `chair_lift_entity.lua:265-283`) ; démarrage de la roue (coup de poing, `powered_wheel.lua:297`, géré par `appliances`) → I (pas de callback
  public ; enveloppe `on_punch` possible mais faux positifs à l'arrêt) ; **monter** → **A** : `clicker:set_attach(self.object…)`
  directement sur l'entité `chair_lift:seat` (`chair_lift_entity.lua:69-80,258`), pas de pivot. Aucun privilège.

### celevator (mod `celevator`) — @ f938829
- Opt. `laptop, mesecons, digilines, xcompat, mesecons_lightstone, mesecons_button, digistuff` ; recettes selon `basic_materials`/`xcompat`.
- Objets : `celevator:controller` (`controller.lua:137`, craft `crafts.lua:219`), `celevator:drive` (`drive_entity.lua:195`, `:237`),
  `celevator:machine` (`drive_entity.lua:933`, `:409` ; pose aussi `celevator:motor`/`celevator:sheave`), `celevator:car_standard`
  (`car_standard.lua:338`, `:174`), `celevator:hwdoor_glass` (`door_2speedglass.lua:193`), `celevator:callbutton_both/_up/_down`
  (`callbuttons.lua:99-203`, `crafts.lua:147-165`), `celevator:guide_rail`, `celevator:tape`, `celevator:tape_magnets`,
  `celevator:buffer_rubber`, `celevator:governor`, `celevator:dispatcher`.
- Pose : nœuds normaux avec `after_place_node` → **F**. Attention : contrôleur/cabine/portes **annulent** la pose par `set_node(air)`
  si la place manque (`controller.lua:29-51`, `car_standard.lua:346-385`) alors que `register_on_placenode` a déjà été appelé →
  l'adaptateur/le moteur doit revérifier le nœud (faux positif possible).
- Mise en service : configuration par formulaire → `celevator.controller.run` **asynchrone** (`controller.lua:87-101,602-640`,
  `core.handle_async`) ; assistant `mem.screenstate = "oobe_*"` puis `"status"` (`controllerfw.lua:292-408`), mémoire publique dans la
  méta `mem` du nœud (`controller.lua:578`). **A** par enveloppe `on_receive_fields` du contrôleur + lecture différée (≥1 s) de la méta
  (`screenstate` hors `oobe_*`). Liaison d'un bouton d'appel : **A** enveloppe `on_receive_fields` du bouton + méta `carid` ≠ 0
  (`callbuttons.lua:244-270`). Aucun callback public.
- Première course : le joueur présent dans la cabine au départ est attaché à un **pivot** `celevator:player_holder`, lui-même attaché
  à `celevator:car_moving` (`drive_entity.lua:236-315,407-418`), seulement pendant le mouvement → **A** (rides, nom `celevator:player_holder`).
  Les entités non-joueur de la cabine sont aussi attachées (`:419-424`) : sans incidence (on ne lit que les joueurs).
- Privilèges : aucun pour l'usage ; protection de zone ; `/celevator_reloadcontroller` = `server`.

### elevator (tigris-mt, mod `elevator`) — @ 9d3c23f
- Objets : `elevator:elevator_off` (objet/cabine inactive), `elevator:elevator_on`, `elevator:shaft` (`components.lua:88`),
  `elevator:motor` (`:132`). Recettes selon branche (`crafts.lua`) ; serveur avec technic + basic_materials → branche
  `technic and basic_materials` (fonte, `basic_materials:chain_steel`, `default:mese_crystal`, `technic:motor`, diamants…).
- Pose : `on_place` → `minetest.item_place` (`components.lua:320-327`) → **F** ; activation par construction du moteur (swap) → pas d'événement.
- Voyager : `sender:set_attach(obj…)` sur l'entité `elevator:box` (`init.lua:33-45,350`), pas de pivot ; état public
  `elevator.riding[nom]` (`init.lua:68`) → **A**.

### ltc4000e (mod `ltc4000e`) — @ a3222ae
- **Ce n'est pas un ascenseur** : contrôleur de **feux de circulation** routiers (« Advanced traffic signal controller », `mod.conf`),
  armoire NEMA `ltc4000e:nema_bottom` et version sur poteau `ltc4000e:polemount` (`init.lua:338,394`), recettes `init.lua:746-780`
  (`streets:bigpole`, `mesecons_luacontroller:luacontroller0000`, `digistuff:touchscreen`, blocs d'acier). Dépend `default, digilines,
  digistuff`. Hors thème Ch15 : à rattacher éventuellement à un chapitre routier. Craft/pose F, configuration I.

### travelnet (mod `travelnet`) — @ 6b9f084 — branche secondaire
- Dépend `xcompat`. Objets : `travelnet:travelnet` + 14 couleurs (`travelnet.lua:3-24`, recette verre/acier/mese `config.lua:26-30`),
  `travelnet:elevator` (`elevator.lua:85`, recette `:160`), portes `travelnet:elevator_door_glass_closed` etc. (`doors.lua:131-145`).
- Pose : `on_place` → `core.item_place` (`register_travelnet.lua:92-104`) → **F**. Enregistrement d'une station : formulaire →
  `travelnet.on_receive_fields` (`on_receive_fields.lua:109`) ; aucun callback public ; méta publique `station_name`/`station_network`
  (`register_travelnet.lua:51-58`) → **A** (enveloppe `on_receive_fields` + lecture méta). Voyage = `player:set_pos`
  (`actions/transport_player.lua:101`), pas d'attachement → I (A fragile par comparaison de position).
- Privilèges : `travelnet_attach` (rattacher à un réseau d'autrui), `travelnet_remove` (`privs.lua:5-16`) — non nécessaires pour son propre réseau.

### locked_travelnet (pas de `mod.conf`, nom = dossier) — @ 4167eb0 (2019)
- Dépend `locks, travelnet`. Objets : `locked_travelnet:travelnet` (= `travelnet:travelnet` + `locks:lock`, `locked_travelnet.lua:121`),
  `locked_travelnet:elevator` (`locked_elevator.lua:176`). Pose `minetest.item_place` → **F**, craft **F**.
- **Compatibilité douteuse** : appelle `travelnet.update_formspec` désormais réduit à un avertissement (`travelnet/update_formspec.lua:47-50`) ;
  à tester en jeu avant toute quête d'usage.

## Chapitre 15 — quêtes candidates
Intro : des pylônes de télésiège aux ascenseurs réalistes, prendre de la hauteur demande de l'atelier, un peu de mécanique et du
courage. Deux branches : télésiège (chair_lift) et ascenseur (celevator / elevator) ; travelnet en branche secondaire.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch15.steel_rope | Le câble du téléphérique | craft | `chair_lift:steel_rope` | F | — | aucun | ingrédients via adaptation_lib |
| ch15.pylon | Le premier pylône | place | `chair_lift:pole_body`, `chair_lift:pole_arm_end`, `chair_lift:wheel_powered` | F | — | aucun | tutoriel télésièges, étapes 1-2 |
| ch15.chair | Un siège pour deux skis | craft | `chair_lift:seat` | F | — | aucun | pose sur câble = entité (non détectable) |
| ch15.chair_ride | Les pieds dans le vide | custom | entité `chair_lift:seat` | A | `rides:chairlift` — rides.lua (`chair_lift_entity.lua:73`) | aucun | prérequis ch15.chair |
| ch15.lift_controller | Le cerveau de l'ascenseur | place | `celevator:controller`, `celevator:car_standard`, `elevator:elevator_off` | F | — | aucun | revérifier le nœud (annulation possible) |
| ch15.lift_commission | Mise en service ! | custom | `celevator:controller` | A | `celevator:commissioned` — enveloppe `on_receive_fields` + méta `mem.screenstate` (`controllerfw.lua:292-408`) | aucun | async : lecture différée ≥1 s |
| ch15.lift_ride | Dernier étage, tout le monde descend | custom | entités `celevator:player_holder`, `elevator:box` | A | `rides:elevator` — rides.lua (`drive_entity.lua:412-414`, `elevator/init.lua:40`) | aucun | prérequis ch15.lift_controller |
| ch15.travelnet | La boîte à téléporter | place | `travelnet:travelnet`, `travelnet:elevator`, `locked_travelnet:travelnet` | F | — | aucun | branche secondaire ; config station : A (méta `station_name`) |

## Bilan
- Ch11 : 7 F, 1 A ; I documentés : poser rails/rampes/aiguillages, poser/conduire/atteler un train, manœuvrer aiguillages et signaux,
  interlocking, LuaATC, payer à la billetterie, crafter Orient-Express/Zugspitzbahn/S7 (pas de recette).
- Ch12 : 7 F, 1 A ; I : panneaux metrosigns (machine), tout linetrack sauf voyager, pose du tram.
- Ch15 : 5 F, 3 A ; I : pose du câble et du siège, démarrage de la roue motrice, téléportation travelnet, ltc4000e hors thème.
- Points bloquants : (1) toute action de construction ferroviaire exige `track_builder`/`train_operator`/`railway_operator` ;
  (2) les quêtes « voyager » dépendent de lignes existantes et de l'adaptateur `rides.lua` ; (3) recettes chair_lift/celevator/elevator
  dépendantes des mods présents (adaptation_lib, basic_materials, technic) → contrôle à l'exécution ; (4) locked_travelnet à tester.

<!-- source : docs/audit/ch13_ch14.md -->
### Audit — chapitres 13 « Les fous volants » et 14 « Larguez les amarres ! »

Sources lues en lecture seule dans `.audit_src/` (branche principale, novembre 2026). **Les versions du serveur peuvent
différer** : revérifier chaque objet avec `core.registered_items` au démarrage. Les identifiants non littéraux et les
noms d'entités sont dans `docs/audit/verified_ch13_ch14.txt`. Chemins relatifs à `.audit_src/`.

## Constats transverses (à lire d'abord)

1. **Poser un véhicule ne déclenche JAMAIS `place`.** Tous les objets véhicules ont un `on_place` personnalisé qui
   appelle `add_entity` (ju52/crafts.lua:29, pa28/crafts.lua:31, supercub/crafts.lua:31, hidroplane/crafts.lua:25,
   motorboat/init.lua:819, fishing_boat/init.lua:140, nautilus/init.lua:968). Aucun mod n'expose de rappel public
   à la pose, à la mise à l'eau ou au premier vol (aucun `register_on_*` ni table `callbacks` dans ces mods).
   Seule solution : envelopper `on_place` avec `core.override_item` (A, la plus invasive), ce qu'on peut éviter
   puisque « monter à bord » couvre le besoin.
2. **Monter à bord (§2 bis)** : dans les avions airutils, le fishing_boat et le motorboat, le joueur est attaché à un
   **siège intermédiaire** (`airutils:seat_base`, `fishing_boat:stand_base`, `motorboat:seat_base`), lui-même attaché à
   l'appareil. `player:get_attach()` renvoie donc le siège, pas l'appareil. **L'adaptateur `rides` doit remonter
   d'un niveau** quand le parent est l'un de ces sièges (`parent:get_attach()`), exactement comme le fait airutils
   lui-même (airutils/init.lua:544-550, airutils/lib_planes/entities.lua:914-917). `airutils:seat_base` est commun à
   tous les avions : ne jamais le mapper seul. Le Nautilus et le bateau linetrack attachent directement à l'entité.
3. **Le deltaplane est l'inverse** : l'entité `hangglider:glider` est attachée *au joueur* (hangglider/init.lua:250),
   donc `player:get_attach()` vaut nil. Il faut utiliser l'API publique `hangglider.is_gliding(player)`
   (hangglider/init.lua:47).
4. **Carburant** : le serveur a `Biofuel` (mod `biofuel`), qui définit la variable globale `biomass.convertible_groups`
   (biofuel/refinery.lua:47-48). Le carburant interne d'airutils **n'est donc pas chargé** (airutils/init.lua:93-100) :
   `airutils:biofuel`, `airutils:biofuel_distiller` et `biofuel:biofuel` n'existent pas sur le serveur. Les seuls
   carburants acceptés sont `biofuel:phial_fuel` (0,25), `biofuel:bottle_fuel` (1) et `biofuel:fuel_can` (10)
   (tables airutils/init.lua:51-53, motorboat/init.lua:9-11, nautilus/init.lua:32-34, fishing_boat via `fishing_boat.fuel`).
   On fait le plein en frappant l'appareil avec le carburant (airutils/lib_planes/entities.lua:788), ce qui n'émet aucun événement → **I**.
5. **Brevet de pilote (Luffy)** : c'est du récit, pas un mécanisme. airutils sait refuser le pilotage sans privilège
   (`_needed_licence`, airutils/lib_planes/utilities.lua:77-83), mais **aucun mod audité ne renseigne ce champ ni
   n'enregistre de privilège** (grep dans tout `.audit_src`). Aucune quête ne peut « délivrer » ou supposer un brevet.
6. **Matériaux rares** : le fuselage du PA28 et celui du Supercub (donc aussi l'hydravion) demandent un
   `default:diamondblock` **et** un `default:mese_block` ; le moteur du motorboat demande `default:mese_block` + `default:diamond` ;
   la coque du fishing_boat un `default:mese_block` ; le moteur du Nautilus `default:mese_crystal` + `default:diamond`.
   Le Ju52 n'utilise que de l'étain et de l'acier (dont 2 `default:steelblock`). `default:mese_block` est un alias de `default:mese`.
7. **demoiselle** : présent dans `server_mods.txt` mais **aucune source** (absent de `.audit_src/` et de
   `tools/audit_sources.txt`) → **non audité**, aucun identifiant cité. À ajouter au manifeste si on veut l'utiliser.

## Chapitre 13 — aviation

### airutils (mod `airutils`) — sources auditées : airutils @ 5c21c92
- Rôle : bibliothèque d'APercy (physique, sièges, carburant, réparation) et outils d'aéroport.
- Dépendances : aucune obligatoire ; optionnelles player_api, mcl_formspec, mcl_player, emote, climate_api, biofuel, signs_lib, skinsdb (mod.conf).
- Objets utiles :
  - `airutils:papi` — indicateur de pente d'approche (PAPI) — airutils_papi.lua:71 ; recette 4 `default:glass`, 1 `default:mese_crystal`, 2 `default:steel_ingot` (l.163-170)
  - `airutils:wind` — manche à air — airutils_wind.lua:128 ; recette 6 `wool:white`, 2 `default:steel_ingot` (l.186-193)
  - `airutils:repair_tool` — outil de réparation — airutils_repair.lua:4 ; 4 `default:steel_ingot` (l.9-16)
  - `airutils:tug` — outil de remorquage — airutils_tug.lua:44 ; 3 acier, 1 `default:stick`, 1 `default:diamond` (l.98-105)
  - `airutils:painter` — pistolet à peinture — painter.lua:148 ; 3 acier + `dye:red`, `dye:green`, `dye:blue` (l.174-181)
- Événements détectables :
  - craft de PAPI, manche à air, outil de réparation, tug, painter → **F** (grille standard).
  - pose du PAPI → **I** en `place` : `on_place` → `core.set_node` (airutils_papi.lua:28, 90-98). Même chose pour la manche
    à air (`set_node` + `add_entity`, airutils_wind.lua:148-157). Possible seulement avec une enveloppe `on_place` (A).
  - réparer un avion (frapper avec l'outil, retire 1 acier, entities.lua:793-807), remorquer (on_use, airutils_tug.lua:48) → **I** (aucun événement).
- Limites / privilèges : le PAPI et la manche à air refusent les zones protégées (airutils_papi.lua:3-14, airutils_wind.lua:155) ;
  seul le propriétaire peut casser le PAPI (`can_dig`, init.lua:114-118). Le tug déplace un appareil si la zone n'est pas
  protégée, si on en est propriétaire ou si on a `server`. Commandes `/eject_from_plane`, `/transfer_ownership` (interact).
- Réglages : `airutils_disable_papi`, `airutils_disable_tug`, `airutils_disable_repair` **suppriment l'objet et sa recette**
  (init.lua:58-66) ; `airutils_protect_in_areas` (lu sans valeur par défaut, init.lua:55 : désactivé si absent de la conf serveur).

### ju52 (mod `ju52`) — sources auditées : ju52 @ b1f5df9
- Rôle : avion de ligne Ju 52 (12 places, passagers qui marchent dans la cabine).
- Dépendances : airutils ; optionnelles compassgps, climate_api, biofuel, default.
- Objets utiles : `ju52:wings` — ailes — crafts.lua:3 (3 `default:tin_ingot`, 2 acier, 1 `default:steelblock`, l.48-54) ;
  `ju52:body` — fuselage — crafts.lua:8 (6 étain, 2 acier, 1 bloc d'acier, l.55-62) ; `ju52:ju52` — avion — crafts.lua:14
  (ailes au-dessus du fuselage, l.63-69). Total : 9 étain, 4 lingots d'acier, 2 blocs d'acier, aucun matériau rare.
- Événements : craft des 3 objets → **F**. Pose (`add_entity`, crafts.lua:29) → I. Monter à bord → **A** (`rides`) :
  clic droit sur l'avion → `ju52.attach_pax` (walk_map.lua:540-613) → `set_attach` sur `airutils:seat_base` (walk_map.lua:10),
  parent `ju52:ju52` (entities.lua:212). N'importe quel joueur peut monter comme passager, sauf si le propriétaire a
  verrouillé l'avion (`_passengers_locked`, walk_map.lua:439-453). Pour piloter, le propriétaire (ou `protection_bypass`) passe par le formulaire
  « Take the Control » (entities.lua:62-64, walk_map.lua:713-723).
- Attachements parasites : `ju52:cabin_interactor`, `ju52:chair_interactor`, `ju52:door_interactor`, `ju52:wheels` sont attachés
  à l'avion mais **jamais au joueur** (entities.lua:147-210, walk_map.lua:382-433) : pas de faux positif.
- Réglage `ju52.disable_craftitems` (sans settingtypes) : supprime ailes, fuselage **et la recette de l'avion** (crafts.lua:2, 47).

### pa28 (mod `pa28`) — sources auditées : pa28 @ 6c11335
- Rôle : avion léger Piper PA-28 (4 places, double commande).
- Dépendances : airutils ; optionnelles compassgps, climate_api, biofuel.
- Objets : `pa28:wings` — crafts.lua:4 (3 étain, 2 acier, 1 `default:tinblock`, l.52-58) ; `pa28:fuselage` — crafts.lua:9
  (4 étain, 3 acier, **1 `default:diamondblock` + 1 `default:mese_block`**, l.60-67) ; `pa28:pa28` — crafts.lua:16 (l.69-75).
- Événements : craft → **F** ; pose → I ; monter à bord → **A** : `airutils.on_rightclick` (entities.lua:888-1039).
  Pilote : propriétaire ou `protection_bypass` seulement (l.963-964), `set_attach` sur le siège (utilities.lua:107). Passager :
  seulement si un pilote est déjà à bord (l.1017-1030). Refusé sous l'eau (l.980). Entité `pa28:pa28` (entities.lua:88).
- Particularité : un PA28 détruit rend des ailes, 2 étain, 6 mese et 6 diamants (init.lua:38-55). Réglage `pa28.disable_craftitems`.

### supercub (mod `supercub`) — sources auditées : supercub @ 490e586
- Rôle : petit avion de brousse Super Cub (2 places).
- Dépendances : airutils ; optionnelles biofuel, climate_api.
- Objets : `supercub:wings` — crafts.lua:4 (4 `wool:white`, 1 `farming:string`, 3 `group:wood`, 1 acier, l.52-59 : **ailes bon
  marché**) ; `supercub:fuselage` — crafts.lua:9 (5 acier, 2 laine, **`default:diamondblock` + `default:mese_block`**, l.60-67) ;
  `supercub:supercub` — crafts.lua:16 (l.68-74).
- Événements : comme le PA28 (`airutils.on_rightclick`, init.lua:224). Entité `supercub:supercub` (entities.lua:36).
- Réglage `supercub.disable_craftitems` (crafts.lua:2, 51) ; il supprime aussi `hidroplane:floaters` (voir ci-dessous).

### hidroplane (mod `hidroplane`) — sources auditées : hidroplane @ 1452b1d
- Rôle : hydravion « Super Duck », un Super Cub sur flotteurs, qui décolle de l'eau (flottabilité 0,25, init.lua:87).
- Dépendances : airutils, supercub (mod.conf ; `depends.txt` obsolète ignoré) ; optionnelles biofuel, climate_api.
- Objets : `hidroplane:floaters` — flotteurs — crafts.lua:3 (5 étain, 1 acier, 2 `group:wood`, l.46-53) ; `hidroplane:hidro` —
  crafts.lua:10 = `supercub:supercub` au-dessus des flotteurs (l.54-60). L'hydravion **consomme un Supercub entier**.
- Événements : craft → **F** ; monter à bord → **A** (même code que supercub). Entité `hidroplane:hidro` (entities.lua:41) ;
  `hidroplane:floaters` est aussi une entité décorative attachée à l'avion, jamais au joueur.
- Bogue : l'objet `hidroplane:floaters` est conditionné par `supercub.disable_craftitems` (crafts.lua:2) mais sa recette par
  `hidroplane.disable_craftitems` (l.45). Sans réglage (cas par défaut), tout est disponible.

### minetest-hangglider (mod `hangglider`) — sources auditées : hangglider @ 17419f7
- Rôle : deltaplane porté, plane lentement depuis une hauteur.
- Dépendances : xcompat (**non audité** : absent de `.audit_src`) ; optionnelles areas, player_monoids, pova, unifieddyes.
- Objet : `hangglider:hangglider` (outil, init.lua:307). Recette : 3 `group:wool` + 3 `xcompat.materials.stick` (crafts.lua:95-102).
  L'identifiant réel du bâton dépend de xcompat (non vérifié).
- Événements :
  - craft → **F avec réserve** : deux recettes « de façade », réparation (papier, crafts.lua:9-22) et teinture (l.25-33), ont
    aussi `hangglider:hangglider` en sortie. Réparer ou teindre un deltaplane reçu d'un autre joueur validerait la quête. Il faut
    exclure les crafts dont `old_craft_grid` contient déjà `hangglider:hangglider` (sinon le noter comme limite connue).
  - planer → **A** par lecture lente de l'API publique `hangglider.is_gliding(player)` (init.lua:47 ; vrai tant que le joueur
    plane, remis à nil au sol, l.226-230). Pas de faux positif : seul `hangglider_use` le met à true (l.259).
- État du joueur : **aucun privilège**. Modifie la physique (`jump=0`, `gravity=0.25`, init.lua:258) via player_monoids/pova
  si présents, sinon directement ; annule les dégâts de chute en vol (l.285-292). Usure : 250 utilisations (`hangglider.uses`).
- Sécurité : si areas est présent et `hangglider.enable_flak` actif (par défaut), un propriétaire de zone peut fermer son
  espace aérien (`/area_flak`, l.26-44) : le joueur tombe à **1 PV et perd un deltaplane** (l.220-222). À signaler dans le texte de quête.

## Chapitre 14 — navigation

### motorboat (mod `motorboat`) — sources auditées : motorboat @ ae36510
- Rôle : bateau à moteur (pilote et 1 passager).
- Dépendances : **mobkit** (non audité), default, biofuel (obligatoires).
- Objets : `motorboat:hull` — coque — init.lua:793 (1 `default:glass`, 1 `group:wood`, 5 acier, l.851-857) ;
  `motorboat:engine` — moteur — init.lua:788 (4 acier, **`default:mese_block` + `default:diamond`**, l.843-849) ;
  `motorboat:boat` — outil (pile de 1) — init.lua:800 (coque + moteur, l.859-866).
- Événements : craft → **F**. Mise à l'eau : seulement sur un liquide (init.lua:817-819) → I. Monter à bord → **A** :
  pilote = propriétaire seulement (init.lua:748-763), passager seulement si le pilote est à bord (l.766-778) ; `set_attach`
  sur `motorboat:seat_base` (l.138, 192 ; entité l.359) dont le parent est `motorboat:boat` (l.404).
- Plein : frapper avec du carburant, propriétaire seulement (l.669, 690 ; plafond 10, motorboat_fuel_management.lua:58-61) → I.

### fishing_boat (mod `fishing_boat`) — sources auditées : fishing_boat @ e18fc13
- Rôle : chalutier (5 personnes, cabine où l'on marche, coffre partagé).
- Dépendances : default, player_api, airutils, biofuel (obligatoires).
- Objets : `fishing_boat:hull` — init.lua:171 (5 `group:wood`, 3 acier, **1 `default:mese_block`**, l.181-187) ;
  `fishing_boat:cabin` — init.lua:176 (5 acier, 2 `default:glass`, 3 `group:wood`, l.189-195) ; `fishing_boat:boat` — init.lua:114
  (coque + cabine côte à côte, l.197-202). Ces trois recettes disparaissent si `fishing_boat.disable_craftitems` (l.169).
- **Pêche : aucune mécanique.** Une recherche (`fish`, `rod`, `bait`, `catch`, `net`) ne trouve rien d'autre que le nom du mod ; le joueur
  ne reçoit rien → **I** pour toute quête de pêche liée à ce bateau.
- Événements : craft → **F**. Mise à l'eau : il faut au moins 2 blocs de profondeur (init.lua:128-137) → I. Monter à bord → **A** : tout
  joueur monte comme passager (entities.lua:642) sauf si le bateau est verrouillé (`/fishing_boat_lock`, forms.lua:450) ;
  `set_attach` sur `fishing_boat:stand_base` (utilities.lua:78 ; entité entities.lua:10), parent `fishing_boat:boat` (entities.lua:56).
  Le joueur reste attaché quand il marche sur le pont (walk_map.lua:233).

### nautilus (mod `nautilus`) — sources auditées : nautilus @ df4fa14
- Rôle : sous-marin (une place).
- Dépendances : **mobkit** (non audité) ; optionnelles vacuum, moreores, technic, oak, player_api, mcl_player, biofuel, default.
- Objets : `nautilus:engine` — init.lua:1006 (4 acier, `default:mese_crystal`, **`default:diamond`**, l.1038-1044) ;
  `nautilus:cabin` — init.lua:1011 (4 acier, **4 `default:steelblock`**, 1 verre, l.1046-1052) ; `nautilus:boat` — init.lua:1017
  (2 moteurs + cabine, l.1031-1036). Variantes (réglage `nautilus_variants`, activé par défaut, l.1056) : `nautilus:cabin_wooden`
  (4 `default:bronze_ingot`, 4 `group:wood`, 1 verre, nautilus_variants.lua:113-120) et `nautilus:boat_wooden` (l.106-112) ;
  les variantes acier carbone ou inox (technic) et mithril (moreores) demandent des blocs coûteux (l.123-173).
- Conditions d'usage : mise à l'eau seulement sur une eau libre, profonde d'au moins 2 blocs (init.lua:946-962). Seul le propriétaire monte
  (init.lua:800). Pression : au-delà de `deep_limit` (25 en bois, 100 en acier, nautilus_variants.lua:19, 28), la coque s'abîme
  (init.lua:503-520). Air limité seulement si vacuum est présent ou si `nautilus_air` est réglé : `get_bool` prend comme défaut la
  présence de vacuum (init.lua:37-41), donc l'air est illimité par défaut sur le serveur.
- Événements : craft → **F**. Monter à bord → **A** : `set_attach(self.object)` direct (init.lua:313), entité `nautilus:boat` (l.364),
  identique pour toutes les variantes (l.968). Plonger ou atteindre une profondeur → **I** (lecture de position = coordonnées, interdit).

### linetrack (mod `linetrack`), partie bateaux — sources auditées : linetrack @ 2ae4e15 (+ advtrains @ 2b59ab8)
- Rôle : lignes de ferry automatisées sur des « rails d'eau » (wiki : lignes F1, F2, F3, `.wiki_cache/bateaux_start.txt`).
- Dépendances : advtrains, advtrains_train_track ; optionnelles advtrains_luaautomation, _line_automation, _interlocking, bakedclay.
- Objets : wagon `advtrains:boat` (`register_wagon("boat")`, waterline_boat.lua:28 ; préfixe advtrains/wagons.lua:1400-1404).
  Rails `linetrack:watertrack*` (waterline.lua:18-197). **Aucune recette** dans linetrack (aucun `register_craft`).
- Privilèges : poser le wagon demande `train_operator` (advtrains/wagons.lua:1453) → réservé à l'équipe. Pas de quête de
  fabrication ni de pose possible.
- Événements : prendre le ferry comme passager → **A** : `wagon:get_on` → `clicker:set_attach(self.object)` (advtrains/wagons.lua:775),
  entité `advtrains:boat`. Places « Passenger area », portes ouvertes requises (waterline_boat.lua:113-125), ce qui est automatique
  aux arrêts des lignes. Pas de privilège pour voyager. La quête dépend de lignes F1 à F3 en service (à confirmer avec l'administratrice).

## Table pour l'adaptateur `rides` (§2 bis)

| Entité appareil (famille proposée) | Attache du joueur | Remonter ? |
|---|---|---|
| `ju52:ju52`, `pa28:pa28`, `supercub:supercub`, `hidroplane:hidro` (aviation) | `airutils:seat_base` (utilities.lua:99,107,129,198,249 ; ju52 walk_map.lua:10,207) | oui, 1 niveau |
| `fishing_boat:boat` (bateau) | `fishing_boat:stand_base` (utilities.lua:78, walk_map.lua:233) | oui |
| `motorboat:boat` (bateau) | `motorboat:seat_base` (init.lua:138,192) | oui |
| `nautilus:boat` (sous-marin) | direct (init.lua:313) | non |
| `advtrains:boat` (ferry) | direct (advtrains/wagons.lua:775) | non |
| deltaplane | aucune (`hangglider.is_gliding`, init.lua:47) | — |

Faux positifs ou négatifs : le pilote et les passagers sont indistincts pour `rides`. Distinguer le pilote demanderait de lire le champ interne
`driver_name` de l'entité (non documenté, fragile). Un avion airutils peut lui-même être attaché à un autre véhicule
(airutils/attach_extern_ent.lua:19) : le grand-parent reste l'avion, ce qui n'est pas gênant. Le moteur d'airutils réattache le pilote
toutes les secondes (utilities.lua:652-702) : il n'y a pas de clignotement d'état.

## Quêtes candidates — chapitre 13 « Les fous volants »
Du bricolage d'aérodrome au premier appareil complet. Le tronc commun (manche à air, PAPI, deltaplane) n'utilise aucun matériau
rare ; les avions motorisés forment une branche coûteuse (diamant et mese). Le brevet de Luffy reste un habillage narratif.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch13.windsock | « D'où vient le vent ? » | craft | `airutils:wind` | F | — | aucun | entrée du chapitre ; pas de quête `place` (set_node) |
| ch13.papi | « Les feux de la piste » | craft | `airutils:papi` | F | — | aucun | 1 mese ; disparaît si `airutils_disable_papi` |
| ch13.glider_craft | « Des ailes de toile » | craft | `hangglider:hangglider` | F | — | aucun | exclure les recettes de réparation et de teinture (`old_craft_grid`) |
| ch13.first_glide | « Le grand saut » | custom | — | A | `hangglider:glide` ; lecture ≥1 s de `hangglider.is_gliding(player)` | aucun | prérequis : glider_craft ; prévenir pour le flak |
| ch13.cub_wings | « Une aile pour Luffy » | craft | `supercub:wings` | F | — | aucun | composant bon marché (laine, ficelle, bois) |
| ch13.repair_kit | « La caisse à outils du mécano » | craft | `airutils:repair_tool` | F | — | aucun | branche ; utile pour entretenir l'avion |
| ch13.first_plane | « Mon premier coucou » | craft | `supercub:supercub` ou `ju52:ju52` ou `pa28:pa28` (au choix) | F | — | aucun | le Ju52 évite diamant et mese ; prérequis : cub_wings |
| ch13.board_plane | « Embarquement immédiat » | custom | — | A | `rides:aviation` ; `rides` remonte du siège `airutils:seat_base` | aucun | (a) établi ; passager possible sur Ju52, sinon propriétaire ; à mettre en dernier |

Variante coûteuse : craft `hidroplane:hidro` (F, consomme un Supercub). Écartées (I) : poser un avion, faire le plein, réparer,
décoller ou atterrir (aucun événement ; l'altitude reviendrait à lire des coordonnées).

## Quêtes candidates — chapitre 14 « Larguez les amarres ! »
On commence par le carburant, puis on construit coque et moteur, et l'on finit par la croisière ou la plongée. Le ferry linetrack
offre une quête sans matériau rare, à condition que les lignes F1 à F3 fonctionnent.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch14.ferry_ride | « Passager du ferry » | custom | — | A | `rides:ferry` ; entité `advtrains:boat`, attache directe | aucun | aucun matériau ; dépend des lignes en service |
| ch14.refinery | « La distillerie du port » | craft | `biofuel:refinery` | F | — | aucun | 6 étain et 3 verres ; peut aussi servir à un chapitre carburant |
| ch14.fuel_bottle | « Plein d'essence verte » | craft | `biofuel:bottle_fuel` | F | — | aucun | sans forme, 4 fioles ; les fioles sortent de la raffinerie (pas un craft) |
| ch14.hull | « Une coque qui flotte » | craft | `motorboat:hull` | F | — | aucun | ni diamant ni mese |
| ch14.motorboat | « Moteur, ça tourne ! » | craft | `motorboat:boat` | F | — | aucun | le moteur demande mese_block et diamant ; prérequis : hull |
| ch14.fishing_boat | « Le chalutier de la baie » | craft | `fishing_boat:boat` | F | — | aucun | branche ; aucune pêche réelle, ne rien promettre |
| ch14.nautilus | « Vingt mille lieues sous les blocs » | craft | `nautilus:boat_wooden` ou `nautilus:boat` | F | — | aucun | moteurs avec diamant ; variante bois si `nautilus_variants` |
| ch14.board_boat | « Capitaine à bord » | custom | — | A | `rides:boat` / `rides:submarine` ; remontée d'un niveau pour motorboat et fishing_boat | aucun | (a) établi ; propriétaire pour motorboat et Nautilus |

Écartées (I) : pêcher avec le fishing_boat (aucune mécanique), plonger ou atteindre une profondeur avec le Nautilus, mettre un bateau
à l'eau (`add_entity`), fabriquer ou poser un bateau linetrack (pas de recette, `train_operator`).

<!-- source : docs/audit/ch16_ch17.md -->
### Audit — chapitres 16 et 17 (Technic uniquement)

Périmètre : ch16 « L'électricité pour les nuls », ch17 « La révolution industrielle ». Techage est audité ailleurs et
n'est pas mélangé ici. Sources clonées en novembre 2026 (branches principales) : **les versions installées sur le
serveur peuvent différer**, et chaque identifiant doit être revérifié à l'exécution (`core.registered_items`).
Les identifiants construits dans des boucles sont dans `docs/audit/verified_ch16_ch17.txt`.

Rappel des événements (README §2) : `place` = `register_on_placenode` (via `item_place_node`, nom = **nœud posé**) ;
`craft` = grille standard uniquement (les machines Technic, le four à alliage, le broyeur, la CNC n'émettent **rien**).

## Synthèse des réponses aux questions

1. **Les identifiants** sont tous générés par des fonctions `register_*` (voir le fichier verified) :
   - câbles : `technic:lv_cable`, `technic:mv_cable`, `technic:hv_cable` (`register/cables.lua:180`)
   - générateurs à combustible : `technic:{lv,mv,hv}_generator` (`register/generator.lua:117`)
   - batteries : `technic:{lv,mv,hv}_battery_box0` (boucle 0..8, `register/battery_box.lua:268,291`)
   - machines : `technic:<tier>_<machine>` (`register/machine_base.lua:163`). Les machines existantes sont
     alloy_furnace, electric_furnace, grinder, extractor, compressor (LV et MV), plus centrifuge et freezer (MV seulement).
   - **Il n'existe ni « soudeuse » ni « mélangeur » dans Technic.** Le mélange de métaux se fait au four à alliage.
2. **Recettes.** Le pivot est `technic:machine_casing` : 8 fonte + 1 laiton (`technic/crafts.lua:172`). La fonte
   s'obtient en cuisant un lingot d'acier au four (`technic_worldgen/crafts.lua:124`). Le laiton ne sort **que** du four
   à alliage (cuivre ×2 + zinc), car Technic efface les recettes de laiton de basic_materials (`technic/crafts.lua:50`).
   Matières rares : diamant (broyeur, géothermique, moulin, atelier). Le granite n'apparaît qu'en dessous de y=-150.
   Le chrome (donc l'inox, donc tout le MV) n'apparaît qu'en dessous de y=-100.
3. **Pose.** Câbles, générateurs, batteries, machines, poste de commutation et coffres n'ont **aucun `on_place`
   personnalisé**, donc la pose est détectée en `place`. Les machines ont des variantes `_active` (et `battery_box1..8`)
   obtenues par `swap_node`. Ces variantes ne passent jamais par `item_place_node` et redonnent l'objet de base quand on
   les casse : on cible donc toujours le nom **de base**.
4. **« Réseau alimenté / machine qui a travaillé » : aucun événement moteur, aucune API publique de rappel.** Les
   machines tournent dans l'ABM du poste de commutation, sans joueur (`switching_station.lua:271-463`), et ne mémorisent
   pas de propriétaire. Alternatives F : poser successivement générateur + câble + poste de commutation + machine.
   Il existe aussi une option A (lecture lente d'un état, détaillée en §ch16).
5. **Progression.** Elle part du câble LV, passe par la carcasse et le générateur LV, puis le poste de commutation et une
   machine LV bon marché (four électrique). Le MV vient ensuite : transformateur MV, câble MV, puis une machine MV, qui
   demande de l'inox et donc de descendre profond. Le nucléaire est autorisé par les règles mais réservé à des quêtes
   finales facultatives. Aucune quête n'utilise de compteur élevé sur des machines (« soyez raisonnables »,
   `regles_construction.txt`). Chaque poste de commutation **force le chargement de 2 blocs de carte**
   (`switching_station.lua:304-305`) : il faut en demander **un seul**.

---

### technic (modpack) — sources auditées : technic @ 856ee6a

Le dossier serveur `technic` est un modpack (`modpack.conf`) qui contient 7 mods : `technic`, `technic_worldgen`,
`technic_chests`, `technic_cnc`, `wrench`, `concrete`, `extranodes`. **Il n'y a pas de `technic_armor`** dans cette
version.

### technic (mod `technic`) — sources auditées : technic/technic @ 856ee6a
- **Rôle** : réseau électrique LV/MV/HV, générateurs, machines de transformation, outils électriques.
- **Dépendances** :
  - obligatoires : `default, pipeworks, basic_materials, technic_worldgen`
  - optionnelles : `bucket, screwdriver, dye, mesecons, mesecons_mvps, digiline_remote, unified_inventory…`
    (`technic/mod.conf`). Pipeworks est donc **obligatoire**.
- **Objets utiles** (recettes en grille standard, sauf mention contraire) :
  - `technic:lv_cable` — câble BT ×6 : 6 papier + 3 lingots de cuivre — `machines/LV/cables.lua:4`
  - `technic:mv_cable` — câble MT ×3 : 6 `technic:rubber` + 3 câbles LV — `machines/MV/cables.lua:4`
  - `technic:hv_cable` — câble HT ×3 : 6 `homedecor:plastic_sheeting` (alias de `basic_materials:plastic_sheet`,
    `basic_materials/aliases.lua:1`) + 3 câbles MV — `machines/HV/cables.lua:2`
  - `technic:machine_casing` — carcasse de machine — `items.lua:127`, recette `crafts.lua:172`
  - `technic:coal_alloy_furnace` — four à alliage au combustible, sans électricité : 8 `default:brick`
    — `machines/other/coal_alloy_furnace.lua:8,40`. Variante `_active` en l.64.
  - `technic:lv_generator` — générateur BT : 6 pierre + `default:furnace` + carcasse + câble LV, 200 EU
    — `machines/LV/generator.lua:8`
  - `technic:switching_station` — poste de commutation : transfo LV + 2 cuivre + carcasse + 3 câbles LV. **Indispensable**
    pour qu'un réseau fonctionne, et doit être **posé sur un câble** (`switching_station.lua:15,31,283`).
  - `technic:power_monitor` — moniteur de puissance — `power_monitor.lua:10,19`
  - `technic:lv_transformer` / `technic:mv_transformer` / `technic:hv_transformer` — transformateurs :
    isolant ×2 + `technic:copper_coil` ×2 + fer (LV), acier au carbone (MV) ou inox (HV) — `crafts.lua:119-144`.
    L'isolant est `mesecons_materials:fiber` si mesecons_materials est présent, sinon `technic:rubber` (`crafts.lua:117`).
  - `technic:copper_coil` — bobine de cuivre : 4 `basic_materials:copper_wire` + 4 fer — `crafts.lua:102`
  - `technic:battery` — batterie RE : 6 bois + 2 cuivre + 1 étain — `register/battery_box.lua:18,72`.
    Recettes alternatives au plomb et au soufre en l.29-69.
  - `technic:lv_battery_box0` — boîte à batteries BT : 3 bois + 4 batteries + carcasse + câble LV — `LV/battery_box.lua:3`
  - **Machines LV** (recettes) :
    - `technic:electric_furnace` (alias, voir le fichier verified) : 6 pierre taillée (cobble) + carcasse + câble.
      C'est **la machine LV la moins chère**.
    - `technic:lv_alloy_furnace` : 6 briques + carcasse + câble
    - `technic:lv_grinder` : 5 pierre du désert + diamant + 2 granite + carcasse + câble
    - `technic:lv_extractor` : 4 `technic:treetap` + `basic_materials:motor` + carcasse + câble
    - `technic:lv_compressor` : pierre ×2 + moteur + 2 `mesecons:piston` + 2 fils d'argent + carcasse + câble
  - **Générateurs LV** :
    - `technic:geothermal` : granite + diamant (`LV/geothermal.lua:11`). Le nom est enregistré deux fois
      (craftitem l.24 puis node l.86) : c'est le nœud qui l'emporte.
    - `technic:water_mill` : marbre + diamant (`LV/water_mill.lua:12`)
    - `technic:solar_panel` : 3 plaquettes dopées + fil d'argent + colle (`LV/solar_panel.lua:8`)
  - **MV** : chaque machine MV se fabrique à partir de la machine LV + 4 inox + 2 `pipeworks:tube_1` + transfo MV +
    câble MV (`MV/*.lua:3`). Machines MV propres :
    - `technic:mv_centrifuge` : demande une tête de forage diamant (`MV/centrifuge.lua:1`)
    - `technic:mv_freezer` (`MV/freezer.lua:3`)
    - `technic:tool_workshop` : diamant + piston collant mesecons + carcasse + tissu de carbone + 2 obsidienne + câble MV
      (`MV/tool_workshop.lua:14-25`). Il répare les outils.
    - `technic:hydro_turbine` : 3 moulins à eau + inox (`MV/hydro_turbine.lua:11`)
  - **HV** : `technic:hv_nuclear_reactor_core` (plaques carbone et composite + carcasse + câble HT, `HV/nuclear_reactor.lua:24`),
    `technic:quarry` (`HV/quarry.lua:10`), `technic:solar_array_hv`.
  - **Minerais (technic_worldgen)** :
    - `technic:mineral_zinc` (y −32..2, et plus bas) — `technic_worldgen/nodes.lua:22`, `oregen.lua:81-106`
    - `technic:mineral_chromium` (y < −100) — `nodes.lua:13`
    - `technic:mineral_lead`, `technic:mineral_sulfur` (près de la lave), `technic:mineral_uranium` (y −300..−80)
- **Événements détectables** :
  - craft en grille de tout ce qui précède → F
  - pose du câble, des générateurs, des batteries (box0), des machines, du poste de commutation → F
    (pas d'`on_place` ; `after_place_node = pipeworks.after_place` en MV/HV, appelé par `item_place_node`)
  - pose des plaques de câble `technic:*_cable_plate_N` → F mais à éviter (6 noms selon l'orientation, `cables.lua:245-276`)
  - minage des minerais → F (`dig`)
  - production des machines (poudres, alliages, lingots), cuisson électrique → **I**
  - « réseau alimenté » → I avec les seuls callbacks, A avec un adaptateur (§ch16)
- **Mécanismes, limites, privilèges** :
  - `/powerctrl` demande `basic_privs` (admin, `switching_station.lua:246-249`).
  - `technic:admin_anchor` : ni recette ni présence dans l'inventaire créatif (`other/anchor.lua:71`), réservé à l'admin.
  - Le constructeur (`other/constructor.lua:30-60`) pose des nœuds par `set_node`, sans joueur : aucune fausse
    validation possible.
  - L'arracheuse d'arbres (`technic:treetap`) agit dans `on_use` par `swap_node` + `handle_node_drops`
    (`tools/tree_tap.lua:8-35`) : action I.
  - Moretrees est présent : les hévéas viennent de `moretrees:rubber_tree_trunk` (`technic_worldgen/init.lua:17-24`).
  - Le caoutchouc s'obtient au four à alliage (latex + poudre de charbon, `register/alloy_recipes.lua:31`) ou par cuisson
    de `technic:rubber_goo` (`crafts.lua:193-213`).
- **Réglages** : fichier de monde `technic.conf`, pas `settingtypes` (`config.lua`, `technic_worldgen/config.lua`).
  Valeurs par défaut :
  - `enable_wind_mill=false` : `technic:wind_mill` n'est **pas** enregistré
  - `enable_frames=false`, `enable_flashlight=false`
  - `enable_mining_drill/laser=true`
  - `enable_granite/marble/rubber_tree_generation=true` (sans granite ni marbre : pas de broyeur, de géothermique ni de
    moulin)
  - `technic_safe_chainsaw` (`settingtypes.txt`)

  Les valeurs réelles du serveur sont inconnues et sont à demander à l'administratrice.

### technic_worldgen (mod `technic_worldgen`) — technic/technic_worldgen @ 856ee6a
- **Rôle** : minerais, lingots (fonte, acier au carbone, inox, zinc, chrome, plomb), granite, marbre.
- **Dépendances** : `default, basic_materials` ; optionnelles `mg, moretrees`. Demande Luanti ≥ 5.14 (`init.lua:1`).
- **Objets utiles** :
  - `technic:cast_iron_ingot`, `technic:carbon_steel_ingot`, `technic:stainless_steel_ingot`, `technic:zinc_ingot`
    — `crafts.lua:31-71`
  - `technic:wrought_iron_ingot` = **alias** de `default:steel_ingot` (`crafts.lua:51`)
  - `technic:granite`, `technic:marble` (`nodes.lua:49,65`)
- **Événements** : minage des minerais → F (`dig`) ; cuisson → I.

### technic_chests (mod `technic_chests`) — technic/technic_chests @ 856ee6a
- **Rôle** : grands coffres métalliques triables.
- **Dépendances** : `default, basic_materials` ; optionnelles `moreblocks, moreores, pipeworks, tubelib`.
- **Objets** (noms générés par `register.lua:393`) :
  - `technic:iron_chest` : coffre en bois + 8 fonte (`iron_chest.lua:8`)
  - `technic:iron_locked_chest`
  - `technic:copper_chest` : coffre en fer + 8 cuivre
  - argent, or et mithril **seulement si moreores est présent**
- **Événements** : craft et pose → F (pas d'`on_place` ; le coffre verrouillé renseigne `owner` dans `after_place_node`).
- **Effet de bord** : le mod efface les recettes « coffre + lingot » de MTG et moreblocks, et remplace la recette de
  `default:chest_locked` par une recette au cadenas (`init.lua:20-60`). À signaler pour la Partie I (ch02).

### technic_cnc (mod `technic_cnc`) — technic/technic_cnc @ 856ee6a
- `technic:cnc` : machine LV (`cnc.lua:286`, recette `cnc.lua:64`).
  - Sa recette est chère : tête de forage diamant + unité logique de contrôle (chrome) + acier au carbone.
  - Les pièces taillées (`<nœud>_technic_cnc_<forme>`, `cnc_api.lua:357`) sortent de la machine, pas d'une grille
    → **I**.
  - Seuls le craft et la pose de la CNC sont F.

### wrench (mod `wrench`) — technic/wrench @ 856ee6a
- `wrench:wrench` (`init.lua:96`) : **aucune recette** dans le modpack (vérifié par grep) → I pour un joueur ordinaire.
- **Contournement de pose** : l'objet « ramassé » `wrench:picked_up_<nœud>` (`init.lua:33`) est posé par
  `item_place_node`, puis son `after_place_node` remplace le nœud par `set_node` (`init.lua:37-52,90`).
  - Le callback `place` reçoit donc le nom `wrench:picked_up_…`, pas la machine.
  - Une machine déplacée à la clé ne valide rien : c'est voulu.

### concrete (mod `concrete`), extranodes (mod `extranodes`) — technic @ 856ee6a
- `concrete` :
  - `technic:concrete_post` ×12 : 6 pierre + 3 `basic_materials:steel_bar` (`concrete/init.lua:26`)
  - `technic:blast_resistant_concrete` : plaques composites (`init.lua:35`), utile pour blinder un réacteur
  - `technic:concrete` = alias de `basic_materials:concrete_block` (`basic_materials/aliases.lua:10`)
- `extranodes` : `technic:insulator_clip` (latex + pierre + colorant, `extranodes/init.lua:223`), décor électrique.
- **Événements** : craft et pose → F.

### basic_materials (mod `basic_materials`) — basic_materials @ f626da0
- **Rôle** : petites fournitures. Dépendance `xcompat`.
- **Objets utiles** (fichiers `craftitems.lua` et `crafts.lua`) :
  - `basic_materials:copper_wire` : cuivre + 2 bobines vides → 2 (`crafts.lua:192`)
  - `basic_materials:motor` : 2 fragments de mese + 2 fils de cuivre + 2 plastique + cuivre + 2 acier → 2 (`crafts.lua:163`)
  - `basic_materials:plastic_sheet` : feuilles → extrait d'huile → paraffine → plastique, par cuisson (`crafts.lua:107-126`)
  - `basic_materials:empty_spool` : 7 plastique → 3 (`crafts.lua:91`)
  - `basic_materials:brass_ingot`
- **Alias importants** (`aliases.lua`) : `technic:motor` (l.13), `homedecor:plastic_sheeting` (l.1),
  `technic:concrete` (l.10), `technic:brass_ingot` (l.22).
- **Interaction avec Technic** : les recettes de laiton (`crafts.lua:411-441`) sont **effacées par technic**
  (`technic/crafts.lua:50-58`).

### pipeworks (mod `pipeworks`) — pipeworks @ 15794da
- **Dépendance obligatoire de technic**. Dépend lui-même de `basic_materials, xcompat, fakelib`.
- **Ingrédients utilisés par Technic** : `pipeworks:tube_1` (`tubes/registration.lua:87,215`), `pipeworks:pipe_1_empty`,
  `pipeworks:filter`, `pipeworks:mese_filter`, `pipeworks:one_way_tube`.
- Technic remplace les recettes des tubes accélérateurs et téléporteurs (`technic/crafts.lua:18-46`).
- **Faux joueurs** : déployeurs, casseurs et autocrafteur (fakelib) sont exclus par `E.real_player`. Le reste de
  pipeworks relève du ch19.

### power_generators (mod `power_generators`, sfence) — power_generators @ 2f58b45
- **Rôle** : groupes électrogènes, arbres de transmission et réseau électrique **propre**. Ses câbles
  `power_generators:electric_cableS` utilisent tubelib2 (`electric/electric_network.lua:47`).
- **Pas de lien producteur vers Technic** : `technic` n'apparaît que dans `mod.conf`. Seul `appliances` peut
  **consommer** du courant LV Technic (`appliances/power_supply.lua:95-138`).
- **Dépendances** : `appliances, tubelib2` (fourni par techage_modpack), `basic_materials`, 16 `adaptation_*`
  (adaptation_modpack).
- **Objets** :
  - `power_generators:emergency_generator` (`generators/emergency_generator.lua:11-14`, recette `crafting.lua:189`) :
    demande des pièces de moteur fabriquées en grille
  - `power_generators:electric_cableS`, `power_generators:power_meter`
- **Événements** : craft → F. Pose → F : les nœuds appliances n'ont que `after_place_node` (`appliance.lua:1301`).
- **Réglage** : `power_generators_enable_petrol_tools`.
- Le dossier `minerland_fix_powerg` (correctif local) **n'a pas de source : non audité**. Il peut modifier ce comportement.
- **Conclusion** : à garder pour une branche « hors Technic ». Ne pas le mêler au ch16, pour ne pas faire croire qu'il
  alimente un réseau Technic.

### factory_bridges (mod `factory_bridges`) — factory_bridges @ 51fc786
- **Rôle** : passerelles, garde-corps et escaliers d'acier, décor industriel. Aucune dépendance obligatoire.
- **Objets** (préfixe `FB.NAME = "factory_bridges"`, `init.lua:2`) :
  - `factory_bridges:b00` : dalle d'acier, 3 acier → 10 (`crafts.lua:21`)
  - `factory_bridges:c00` : escalier d'acier
  - `factory_bridges:a01` : garde-corps, à partir de `factory_bridges:i00` / `i01`
- **Événements** : craft et pose → F (pas d'`on_place`).

---

## Chapitre 16 — L'électricité pour les nuls

Le chapitre fait découvrir la chaîne minimale d'un réseau Technic : fabriquer la carcasse, un générateur, des câbles et
le poste de commutation, puis brancher une première machine. Il faut une seule installation, petite. Aucune quête ne
demande plus d'un générateur ni plus d'une machine.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch16.copper_cable | « Le fil d'Ariane » | craft | `technic:lv_cable` | F | — | aucun | Recette : papier + cuivre. Point d'entrée, prérequis suggéré : ch04.copper_tin |
| ch16.alloy_kiln | « Le four des alchimistes » | craft | `technic:coal_alloy_furnace` | F | — | aucun | 8 briques, sans électricité. Sert au laiton (zinc + cuivre) |
| ch16.casing | « Une carcasse solide » | craft | `technic:machine_casing` | F | — | aucun | 8 fonte (acier cuit au four) + 1 laiton. Prérequis : alloy_kiln |
| ch16.generator | « Que la lumière soit ! » | place | `technic:lv_generator` | F | — | aucun | Craft implicite (four + carcasse + câble). Ne jamais cibler `_active` |
| ch16.wiring | « Tirer des câbles » | place | `technic:lv_cable` (count 5, positions distinctes) | F | — | aucun | `distinct` par défaut si count > 1 ; câble sans `on_place` |
| ch16.switching | « Le chef d'orchestre » | place | `technic:switching_station` | F | — | aucun | Doit être posé **sur** un câble. Un seul par réseau (force le chargement de 2 blocs) |
| ch16.first_machine | « Ma première machine » | place | `technic:lv_electric_furnace`, `technic:lv_alloy_furnace`, `technic:lv_grinder`, `technic:lv_extractor`, `technic:lv_compressor` | F | — | aucun | Le four électrique est la moins chère. Suggérer le branchement dans la description |
| ch16.powered | « Ça tourne ! » (final) | custom | — | A | `technic:network_powered` : lecture lente du réseau (détail ci-dessous) | aucun | Option. Sans adaptateur, s'arrêter à first_machine |

**Branches** :
- copper_cable → alloy_kiln → casing → generator → wiring → switching → first_machine (→ powered).
- Branche annexe sans prérequis de carcasse : craft `technic:battery` (6 bois + cuivre + étain), plutôt placée au ch17.

**Adaptateur `technic:network_powered` (A)** :
- **Mémoriser** dans le stockage la position des `technic:switching_station` posés par un vrai joueur, via le callback
  `place` déjà en place, au plus 2 par joueur.
- **Lire** toutes les 2 s, pour les joueurs connectés seulement, `core.get_meta(pos)` à **ces positions uniquement**.
  On n'explore aucune zone.
- **Conditions** :
  - le nœud est toujours `technic:switching_station` ;
  - `get_int("supply") > 0` et `get_int("demand") > 0`, champs écrits à `switching_station.lua:397-398`.
- **Chargement** : le poste force le chargement de son bloc quand il est relié (l.304), donc la lecture est fiable.
- **Faux positifs** : un générateur fourni par un autre joueur sur le même réseau. C'est acceptable : le joueur a bien
  monté le réseau.
- **Faux négatifs** :
  - poste déplacé ou recassé (oublier la position sur `dig`) ;
  - poste désactivé parce qu'un autre est déjà présent (`active ~= 1`, l.286).
- **Limite** : les champs méta ne sont pas une API documentée. À revérifier selon la version.

**Rejetées (I)** :
- « produire de l'énergie » mesurée en EU.
- « faire cuire au four électrique » : machine, pas de callback.
- la pose de `technic:wind_mill`, désactivé par défaut.
- les générateurs power_generators, qui ne sont pas du Technic.

## Chapitre 17 — La révolution industrielle

Le chapitre part du minerai et va jusqu'à l'atelier. Il couvre le traitement des minerais propres à Technic, le stockage
(coffres, batteries) et le passage au MV, qui exige de l'inox, donc du chrome profond. Les quêtes visent **une** machine
de chaque sorte : aucune ne demande d'en construire en série.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| ch17.zinc | « Le zinc, cet inconnu » | dig | `technic:mineral_zinc` (count 3) | F | — | aucun | y −32..2 et plus bas. Nécessaire au laiton. Prérequis : ch16.copper_cable |
| ch17.iron_chest | « Un coffre de ferrailleur » | craft | `technic:iron_chest`, `technic:iron_locked_chest` | F | — | aucun | Coffre + 8 fonte. Stockage simple |
| ch17.battery_box | « Mettre l'énergie en boîte » | place | `technic:lv_battery_box0` | F | — | aucun | 4 `technic:battery` + carcasse + câble. Les variantes box1..8 ne sont pas posables. Prérequis : ch16.switching |
| ch17.grinder | « Moulin à minerai » | place | `technic:lv_grinder` | F | — | aucun | Diamant + granite (y < −150). Doublement des minerais (non détectable) |
| ch17.chromium | « Chrome et paillettes » | dig | `technic:mineral_chromium` | F | — | aucun | y < −100. Ouvre l'inox (four à alliage : acier au carbone ×4 + chrome) |
| ch17.mv_cable | « Monter en tension » | craft | `technic:mv_transformer`, `technic:mv_cable` (au choix) | F | — | aucun | Transfo MV = acier au carbone + bobines + isolant ; câble MV = caoutchouc |
| ch17.mv_machine | « L'usine moyenne tension » | place | `technic:mv_electric_furnace`, `technic:mv_grinder`, `technic:mv_alloy_furnace`, `technic:mv_extractor`, `technic:mv_compressor` | F | — | aucun | Machine LV + 4 inox + transfo MV. Prérequis : chromium, mv_cable |
| ch17.workshop | « L'atelier du réparateur » (final) | place | `technic:tool_workshop` | F | — | aucun | Diamant + obsidienne + tissu de carbone + piston collant. Avancé |

**Branches** :
- zinc et grinder sont indépendants entre eux.
- chromium → mv_machine → workshop.
- iron_chest est accessible dès que l'on a de la fonte.

**Variantes possibles** :
- craft `technic:copper_chest` (F) ;
- pose `factory_bridges:b00` / `c00` (F, décor d'usine, 3 lingots d'acier) ;
- pose `technic:solar_array_lv` (F, mais il faut des plaquettes dopées : coûteux).

**Option A, non recommandée — « récolter la production d'une machine »** :
- Méthode : envelopper `on_metadata_inventory_take`, que les machines Technic ne définissent pas (seulement
  `allow_*`), sur `technic:lv_grinder(_active)`, pour la liste `dst`.
- **Faux positif connu** : un joueur peut **déposer** n'importe quel objet dans `dst` puis le reprendre, car
  `inv_change` ne filtre pas la liste (`register/common.lua:174-198`). Pour cette raison, l'option est notée A faible.

**Rejetées (I)** :
- production de poudres, d'alliages ou de plaques (machines, pas de grille) ;
- pièces CNC ;
- clé `wrench:wrench` (pas de recette) ;
- tirer du latex (`on_use` de l'arracheuse) ;
- réacteur nucléaire comme quête obligatoire. Les règles l'autorisent, mais la chaîne HV/uranium est très coûteuse :
  au mieux une quête finale facultative, pose de `technic:hv_nuclear_reactor_core` (F).
- carrière `technic:quarry` : elle « ronge les sous-sols » et la règle digtron ≤ 10×10 s'applique dans le même esprit.

## Points bloquants / à confirmer par l'administratrice
1. **Réglages de `technic.conf`** dans le monde : génération du granite, du marbre et des hévéas, `enable_wind_mill`.
   Sans granite, la quête ch17.grinder est impossible.
2. **Le modpack mesecons est-il activé ?** Il fournit la colle et la fibre (isolant des transformateurs), ainsi que les
   pistons du compresseur et de l'atelier. Sans lui, ces recettes basculent ou deviennent impossibles.
3. **`moreores`** conditionne les coffres en argent, or et mithril et les cristaux d'énergie (`technic/crafts.lua:73,92`).
4. **Versions serveur inconnues** (sources de novembre 2026). `minerland_fix_powerg` et `minerland_fix_silicon` n'ont
   pas de source et n'ont pas été audités. Le second peut toucher aux plaquettes de silicium.
5. **Charge serveur** : un poste de commutation force le chargement de 2 blocs de carte et l'ABM tourne toutes les
   secondes. Il ne faut jamais demander plusieurs réseaux.

<!-- source : docs/audit/ch18.md -->
### Audit — Chapitre 18 « L'ère de Techage » (techage_modpack)

Source auditée : `.audit_src/techage_modpack` @ `de4c1a5` (2026-10-09, techage V1.24). Le serveur peut avoir une
version différente : Techage installé le 24/03/2026 « sans add-on », add-ons ajoutés le 01/04/2026. **Toute référence
est revérifiée à l'exécution** (`core.registered_items`). Chemins ci-dessous relatifs à `.audit_src/techage_modpack/`.
Techage et Technic sont deux progressions **indépendantes** : aucun prérequis croisé proposé.

## Contenu du modpack (`modpack.conf` : `name = techage_modpack`)

| Dossier | Mod (`mod.conf`) | Rôle pour le ch18 |
|---|---|---|
| `techage` | `techage` | mod principal (TA1 → TA5) — audité en détail |
| `signs_bot` | `signs_bot` | robots pilotés par panneaux — audité en détail |
| `tubelib2`, `networks`, `lcdlib`, `safer_lua`, `doclib`, `nanobasic` | idem | bibliothèques (objets de test seulement : `tubelib2/tube_test.lua`, `networks/test/*`) |
| `basic_materials` | `basic_materials` | ingrédients (moteur, engrenage, fils) |
| `minecart`, `hyperloop`, `autobahn` | idem | transports → à traiter au chapitre transports (aperçu plus bas) |
| `compost`, `techpack_stairway`, `towercrane` | idem | annexes (aperçu plus bas) |
| `ta4_jetpack`, `ta4_paraglider`, `ta4_addons` | idem | add-ons TA4 (jetpack : dépend de `3d_armor`) |
| `stamina`, `unified_inventory` | idem | `unified_inventory` existe **aussi** en dossier séparé sur le serveur : doublon de nom de mod, à vérifier côté serveur |

**Non audité** : `minerland_fix_techage` (mod local, aucune source disponible) et `minerland_fix_silicon` (local, il touche
probablement le silicium, ingrédient du wafer TA4). Leur effet sur les recettes ou objets ci-dessous est **inconnu**.

---

### techage_modpack (mod `techage`) — sources auditées : techage_modpack @ de4c1a5
- Rôle : 5 âges technologiques successifs ; chaque âge dépend des produits du précédent (`techage/README.md`).
- Dépendances : obligatoires `default, doors, flowers, tubelib2, networks, basic_materials, bucket, stairs, screwdriver,
  minecart, lcdlib, safer_lua, doclib` ; optionnelles `unified_inventory, mesecons, moreores, ethereal, digtron, farming,
  nanobasic, everness…` (`techage/mod.conf`).
- Objets emblématiques par âge (tous littéraux dans l'index sauf mention « verified ») :
  - **TA1 (Âge du fer)** :
    - `techage:lighter`, l'allumeur du meiler — `iron_age/lighter.lua:63` ; craft grille `lighter.lua:82` (bois + `farming:straw`, donne 2).
    - `techage:charcoal`, le charbon de bois produit par le meiler — `iron_age/charcoalpile.lua:197`.
    - `techage:meltingpot`, le creuset — `iron_age/meltingpot.lua:410` ; craft `:473` (7 pierres taillées + 1 lingot de cuivre).
    - Le four à charbon (foyer) n'a **pas d'objet propre** : c'est une tour de pierres taillées remplie de `techage:charcoal`, allumée par `techage:lighter`. Il passe en `techage:coal_lighter_burn` (`lighter.lua:39`) puis laisse `techage:ash` (`coalburner.lua:150`).
    - `techage:hammer_stone`, le marteau de pierre — `iron_age/hammer.lua:72` ; craft `:207`.
    - `techage:sieve`, le tamis à gravier — `iron_age/gravelsieve.lua:129` ; craft `:187`.
    - `techage:iron_ingot` — `iron_age/recipes.lua:35` ; produit **au creuset** (`recipes.lua:28`), pas en grille.
    - Moulin à eau : `techage:ta1_watermill_inv` (`ta1_watermill/watermill.lua:193`, craft `:312`), `techage:ta1_mill` (`mill.lua:79`, craft `:171`), `techage:ta1_mill_base` (`basic_machines/grinder.lua:299`), `techage:ta1_axle` (`ta1_watermill/ta1_axle.lua:36`, craft `:150`).
  - **TA2 (Âge de la vapeur)** :
    - Machine à vapeur : `techage:firebox` (`steam_engine/firebox.lua:56`, craft `:138`), `techage:boiler1`/`boiler2` (`boiler.lua:105/56`, crafts `:124/:133`), `techage:cylinder` (`cylinder.lua:76`, craft `:177`), `techage:flywheel` (`flywheel.lua:131`, craft `:232`).
    - Axes : `techage:axle` (`power/drive_axle.lua:49`, craft `:184`, donne 3), `techage:gearbox` (`power/gearbox.lua:83`).
    - Broyeur `techage:ta2_grinder_pas`, carrière `techage:ta2_quarry_pas`, tamis `techage:ta2_gravelsieve_pas`, autocrafter `techage:ta2_autocrafter_pas`, fab. électronique `techage:ta2_electronic_fab_pas` (tous verified).
    - Pont vers l'électricité : `techage:ta2_generator_off` (`ta3_power/axle2power.lua:82`).
  - **TA3 (Âge du pétrole)** :
    - Pétrole : `techage:oilexplorer` (`oil/explore.lua:245`, craft `:302`), `techage:oiltower1` (`oil/tower.lua:20`), `techage:ta3_drillbox_pas` et `techage:ta3_pumpjack_pas` (verified), `techage:ta3_distiller_base` (`oil/distiller.lua:46`).
    - Électricité : `techage:generator` (centrale à charbon, `coal_power_station/generator.lua:137`, craft `:270`), `techage:tiny_generator` (`ta3_power/tiny_generator.lua:175`, craft `:393`), `techage:ta3_akku` (`ta3_power/akkubox.lua:137`, craft `:208`), `techage:electric_cableS` (`power/electric_cable.lua:70`).
  - **TA4 (Présent)** :
    - Solaire : `techage:ta4_solar_module` (`solar/solarcell.lua:96`, craft `:259`), `techage:ta4_solar_carrier` (`:129`), `techage:ta4_solar_inverter` (`solar/inverter.lua:169`, craft `:255`).
    - Éolien : `techage:ta4_wind_turbine` (`wind_turbine/rotor.lua:209`, craft `:360`), `techage:ta4_wind_turbine_nacelle` (`:258`), `techage:pillar` (`wind_turbine/pillar.lua:17`).
    - Hydrogène et électronique : `techage:ta4_electrolyzer` (`hydrogen/electrolyzer.lua:214`), `techage:ta4_wlanchip` (`items/electronic.lua:22`).
  - **TA5 (Futur)** :
    - Téléporteur : `techage:ta5_tele_tube` (`teleport/teleport_tube.lua:72`, craft `:144`), `techage:ta5_tele_pipe` (`teleport/teleport_pipe.lua:73`).
    - Fusion : `techage:ta5_fr_controller_pas` (`fusion_reactor/controller.lua:207`, craft `:283`), `techage:ta5_fr_shell` (`shell.lua:21`, **four industriel**, pas en grille).
    - Autres : `techage:ta5_aichip` (`items/electronic.lua:42`), `techage:ta5_digitizer_pas` (`ta5_nodes/ta5_digitizer.lua:442`).
- Événements détectables :
  - **Craft grille (F)** : toutes les machines et blocs ci-dessus, sauf exceptions (`minetest.register_craft` shaped).
  - **Hors grille, `craft` jamais émis (I)** :
    - Lingots du creuset : `techage.ironage_register_recipe`, `meltingpot.lua:500`.
    - Produits du broyeur, du tamis et du rinceur : `techage.add_grinder_recipe`, `add_rinser_recipe`.
    - Électronique : `techage.recipes.add("taN_electronic_fab")`, `recipe_lib.lua:94` → `techage:vacuum_tube`, `ta4_wlanchip`, `ta5_aichip`.
    - Four industriel : `techage.furnace.register_recipe` → `ta4_silicon_wafer` (`items/silicon.lua:24`), `ta5_fr_shell`.
    - Le « recipe book » `techage.recipes.register_craft` (`basis/recipe_lib.lua:252`) ne fait qu'**afficher** ces recettes dans Unified Inventory, i3 ou craftguide (types « melting », « burning », « grinding »…). Ce n'est pas un événement. Exemple : `audit_mods --crafts` liste `techage:charcoal` (`meltingpot.lua:494`), mais c'est un affichage de type « burning ».
  - **Pose (F)** :
    - Les nœuds Techage n'ont **aucun `on_place`** propre dans les fichiers audités. La pose passe par `core.item_place` → `item_place_node` → `after_place_node` → `register_on_placenode`.
    - Le nom posé est le **nom enregistré de l'objet** : `_pas` pour les machines, jamais `_act` ni `_on`.
    - Le « numéro de nœud » Techage (`techage.add_node`, `basis/command.lua:229`) n'est qu'un entier de messagerie stocké en méta (`node_number`). `techage.register_node` (`command.lua:299`) n'enregistre que des callbacks de communication (tubes, messages). Ni l'un ni l'autre ne renomme le nœud ni ne change la pose.
  - **Creusage (F)** : `techage:charcoal` issu du meiler. Il est créé par `swap_node` (`charcoalpile.lua:116-127`), donc jamais marqué « posé ».
- Mécanismes particuliers / limites :
  - **Meiler** :
    - Construction : 26 blocs `group:wood` (3×3×3 moins le centre), 98 blocs de terre autour, `techage:lighter` au centre, allumé au briquet. L'allumage passe par `on_ignite` (`lighter.lua:66`) → `minetest.after` + `swap_node` (`iron_age/main.lua:13`). Le moteur n'émet **aucun** événement.
    - La structure n'est validée qu'au 1er tick, 20 s plus tard (`charcoalpile.lua:132,136-149`). La conversion en charbon a lieu 1200 s après (`:17,152-153`).
    - « Allumer un meiler » vaut donc **A** au mieux, par enveloppe de `on_ignite` de `techage:lighter`, avec faux positifs (meiler invalide). Mieux vaut le **dig** du charbon produit.
  - **Production, mise en service** :
    - L'état des machines est géré par `techage.NodeStates` (`basis/node_states.lua`). Le callback `on_state_change` est un champ **privé** passé à `NodeStates:new` par chaque machine (`node_states.lua:192,239-383`). Il n'existe ni registre global ni API publique pour s'y abonner.
    - Les passages en marche (`flywheel_on`, `_act`, `meltingpot_active`) se font par `swap_node`, sans callback.
    - `api.md` ne documente que des fonctions d'**enregistrement** (recettes, minerais, nœuds simples). La détection « machine allumée / produit fabriqué » est donc **I**, sauf à envelopper des callbacks de définition au cas par cas (non recommandé ici).
  - **Points d'expérience TA5** :
    - État **public** en méta joueur `techage_ex_points` (`techage.get_expoints`, `basis/lib.lua:596`). Il est incrémenté uniquement par le collisionneur TA4 (`techage.add_expoint`, `lib.lua:606`), avec **un seul collisionneur par joueur**.
    - Exigences en points : `ta5_aichip` 10 (`items/electronic.lua:94`), appairage du téléporteur 30 (`teleport_tube.lua:30`), digitizer 50 (réglage).
    - `/expoints` exige le privilège `server` (`command.lua:684-690`), `/my_expoints` est libre.
  - **Faux joueur Techage** : `techage.Fake_player` (`basis/fake_player.lua:103-117`) : `is_player()` → `false`, `get_player_name()` → `""`.
    - La carrière creuse par `techage.dig_like_player` (`lib.lua:400-425`) : `remove_node` + `after_dig_node(…, fake_player)`. Elle **n'appelle jamais** `node_dig` ni `registered_on_dignodes`.
    - Aucun fichier Techage n'appelle `registered_on_placenodes`, `item_place_node` ou `registered_on_dignodes`.
    - Les déplacements par move/fly controller utilisent `set_node`.
    - Le marteau TA1 réagit à un vrai creusage joueur (`register_on_dignode` interne, `command.lua:165`). Il vérifie `is_fake_player` (`hammer.lua:33`) puis remplace la pierre par du gravier via `swap_node`.
    - Le filtre `E.real_player` du moteur de quêtes (`core/events.lua`) rejette ces cas (`is_player()` faux, nom vide).
  - **Privilège** : la ligne électrique `techage:power_line` ne se retire qu'avec le privilège `powerline` (`power/power_line.lua:27`). Ne pas en faire une cible.
- Réglages `settingtypes` :
  - `techage_modified_recipes_enabled` est **activé par défaut dans le code** (`init.lua:48`, `~= false`), alors que `settingtypes.txt:17` annonce `false`.
  - Effets s'il est actif : suppression de la cuisson minerai de fer → acier (`iron_age/recipes.lua:174-177`) ; acier, bronze et étain faits au creuset ; briquet MTG refait en silex + minerai de fer (`recipes.lua:178,212`) ; seau en `techage:iron_ingot` (`:220`). **Impact possible sur d'autres chapitres (acier).** À vérifier dans le `minetest.conf` du serveur.
  - `techage_ore_rarity`, `techage_max_active_quarries` (défaut 0 = illimité), `techage_ammonia_recipes_enabled` (code : actif par défaut, `init.lua:55`), `techage_ta5_digitizer_expoints` (50).

### techage_modpack/signs_bot (mod `signs_bot`) — sources auditées : techage_modpack @ de4c1a5
- Rôle : robot programmé par panneaux de commandes. Agriculture, minage et transport en TA3/TA4.
- Dépendances : `default, farming, basic_materials, tubelib2` ; optionnelles `techage, minecart, doclib, compost…` (`mod.conf`).
- Objets utiles :
  - `signs_bot:box`, le boîtier du robot — `basis.lua:411`, `stack_max = 1`. Craft avec techage `basis.lua:503` : acier ×2, bois, `basic_materials:motor`, **`techage:ta4_wlanchip`**, `basic_materials:gear_steel`, étain ×2.
  - `signs_bot:sign_cmnd`, le panneau de commandes — `cmd_sign.lua:105`, craft `:352` (donne 4).
  - `signs_bot:robot` (`robot.lua:52`) : nœud mobile, ne se pose pas.
- Événements détectables :
  - **Craft de la boîte (F)**. La puce WLAN sort de la fab. électronique TA3 : le robot est donc de **niveau TA3** quand techage est présent.
  - **Pose de la boîte (F)** : pose par défaut. `after_place_node` retire la boîte si `placer` n'est pas un joueur (`basis.lua:432-436`), et `register_on_placenode` est émis avant ce retrait par les machines. Le filtre `real_player` écarte ce cas.
  - **Démarrage du robot (A, enveloppe)** :
    - Le bouton « On » passe par `on_receive_fields` (`basis.lua:316-334`) → `signs_bot.start_robot` (`:227`), qui renvoie `true` si le robot sort.
    - Méthode : `core.override_item("signs_bot:box", {on_receive_fields = …})`. Appeler l'original d'abord, puis émettre `signs_bot:start` si `fields.start` et si `tubelib2.get_mem(pos).running == true`, pour un joueur réel non bloqué par la protection.
    - Faux négatif : démarrage par capteur ou signal (`basis.lua:288-297`), ce qui est acceptable.
    - **Aucune API publique** `register_on_*` n'existe dans signs_bot.
  - **Actions du robot (I)** : récolte, pose, minage par `set_node`/`remove_node`/`swap_node` (`cmd_place.lua:67-219`, `cmd_farming.lua:46-141`), sans aucun callback moteur. Il ne valide donc jamais `dig` ni `place`. `signs_bot.lib.fake_player` (`lib.lua:303`) renvoie `is_player() = false`.
- Limites : sans techage, la recette utilise un cristal de mese (`basis.lua:512`). Sur le serveur, techage est présent, ordre garanti par `optional_depends`.

### Autres mods du modpack (aperçu, hors cœur du ch18)
- `minecart` : `minecart:cart` (`minecart/minecart.lua:16`, wagon nœud + entité). Le retrait de ballast est réservé au privilège `minecart` (`protection.lua:35,86`). Audit des wagons au chapitre transports.
- `hyperloop` :
  - `hyperloop:station` (`station.lua:248`), `hyperloop:seat` (`seat.lua:196`). **Aucun `set_attach`** dans les sources : le voyage n'est pas détectable par `rides.lua`.
  - Le pied-de-biche exige le privilège `hyperloop` (`tubecrowbar.lua:88`).
- `autobahn` : `autobahn:node1…6` (craft `init.lua:333-421`). Modifie temporairement les privilèges du joueur (`init.lua:42-127`), sans rapport avec une récompense.
- `towercrane` : donne **`fly` temporaire** dans la zone de la grue (`control.lua:72-113`). La pose de `towercrane:base` (`init.lua:243`) est possible, mais **aucune quête liée au vol**.
- `compost` (`compost:wood_barrel`, `init.lua:133`), `techpack_stairway` (`techpack_stairway:stairway`, `init.lua:442`), `ta4_jetpack` (exige `3d_armor`), `ta4_paraglider`, `ta4_addons` : non approfondis.

---

## Chapitre 18 — « L'ère de Techage »

On remonte le temps de l'industrie : meiler et creuset (TA1), vapeur et axes (TA2), pétrole et électricité (TA3),
renouvelables (TA4), puis un horizon futuriste facultatif (TA5). Branche « Robotique » greffée sur TA3.
**Règle serveur : pas de machines en masse → toutes les quêtes sont de quantité 1** (sauf le charbon, 1 bloc suffit).

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch18.ta1_lighter` | « Paille et bois sec » | craft | `techage:lighter` | F | — | aucun | `lighter.lua:82` ; point d'entrée (bois + `farming:straw`) |
| `ch18.ta1_charcoal` | « Le charbonnier patient » | dig | `techage:charcoal` | F | — | aucun | Produit par le meiler via `swap_node` : jamais marqué « posé ». Un bloc posé par un joueur est ignoré par l'anti-triche. Délai réel ≈ 20 min. Prérequis : `ta1_lighter` |
| `ch18.ta1_meltingpot` | « Le creuset du forgeron » | place | `techage:meltingpot` | F | — | aucun | Craft `meltingpot.lua:473` (cuivre). Pose par défaut. Le lingot de fer (`techage:iron_ingot`) n'est **pas** détectable (creuset) |
| `ch18.ta1_mill` | « Au fil de l'eau » | place | `techage:ta1_mill` | F | — | aucun | Craft `mill.lua:171` (2 `techage:iron_ingot`), ce qui impose d'avoir utilisé le creuset. Alternative : `techage:ta1_watermill_inv` (place émis même si retiré faute de place, `watermill.lua:224-235`) |
| `ch18.ta2_flywheel` | « Que la vapeur soit ! » | place | `techage:flywheel` | F | — | aucun | `flywheel.lua:131`, craft `:232`. Le **fonctionnement** (`flywheel_on`, par swap) est I. Prérequis : `ta1_meltingpot` |
| `ch18.ta2_grinder` | « Broyer la pierre » | craft | `techage:ta2_grinder_pas` | F | — | aucun | `grinder.lua:336` (mese, `techage:hammer_steel`, `techage:tubeS`, fer). Id reconstitué (verified) |
| `ch18.ta3_oil` | « L'odeur du pétrole » | place | `techage:oilexplorer` | F | — | aucun | `explore.lua:245`, craft `:302` (diamant, `baborium_ingot`, `vacuum_tube` de la fab. électronique TA2). Variante électrique : craft `techage:generator` (`generator.lua:270`) |
| `ch18.ta3_robot` | « Mon premier robot » | place | `signs_bot:box` | F | — | aucun | Craft `basis.lua:503` avec `techage:ta4_wlanchip` (fab. TA3). Robot populaire : branche optionnelle après `ta3_oil` |
| `ch18.ta3_robot_start` | « En avant, petit robot ! » | custom | `signs_bot:box` | A | `signs_bot:start`, enveloppe de `on_receive_fields` (`basis.lua:316-334`) | aucun | Faux négatif : démarrage par capteur. Nécessite l'électricité Techage. Facultatif |
| `ch18.ta4_solar` | « Capter le soleil » | craft | `techage:ta4_solar_module` | F | — | aucun | `solarcell.lua:259`. Wafers du four industriel TA3. Alternative éolienne : craft `techage:ta4_wind_turbine` (`rotor.lua:360`) |
| `ch18.ta5_teleport` | « Au-delà de l'espace » (facultatif) | craft | `techage:ta5_tele_tube` | F | — | aucun | `teleport_tube.lua:144`. Exige `techage:ta5_aichip` (10 points d'expérience via le collisionneur TA4, un seul par joueur). Très avancé : quête finale optionnelle, hors tronc |

Arbre suggéré : `ta1_lighter` → `ta1_charcoal` → `ta1_meltingpot` → (`ta1_mill` | `ta2_flywheel`) → `ta2_grinder` →
`ta3_oil` → (`ta3_robot` → `ta3_robot_start`) | `ta4_solar` → `ta5_teleport`. Bilan : **10 F, 1 A**.

Actions écartées (I), à documenter :
- Allumage ou réussite du meiler : `on_ignite` puis swap, structure validée 20 s après.
- Machine à vapeur, centrale ou turbine « en marche » : swap vers `_on`/`_act`, `on_state_change` privé.
- Lingots et produits du creuset, du broyeur, de la fab. électronique et du four industriel : recettes de machine, pas d'`on_craft`.
- Points d'expérience : un état public existe (`techage_ex_points`, lecture lente possible), mais il dépend d'un collisionneur géant. Trop lourd, et contraire à la règle anti-masse.
- Actions des robots, de la carrière, de l'autocrafter : faux joueurs ou `set_node`.
- Retrait de ligne électrique : privilège `powerline`.
- Vol avec la grue : `fly` temporaire.

<!-- source : docs/audit/ch19.md -->
### Audit — Chapitre 19 « Les machines intelligentes » (partie Technologie)

Sources auditées (lecture seule, branche principale clonée en novembre 2026) : `.audit_src/mesecons` @ `aca87db`,
`.audit_src/digilines` @ `3f6e553`, `.audit_src/digistuff` @ `0dcdf51`, `.audit_src/digtron` @ `9ae31a6`,
`.audit_src/pipeworks` @ `15794da` (complément de `docs/audit/ch16_ch17.md`), `.audit_src/basic_materials` @ `f626da0`.
**Les versions installées sur le serveur peuvent différer** : toute référence est revérifiée à l'exécution
(`core.registered_items`). Chemins ci-dessous relatifs à `.audit_src/`.
**Non audités** : `fakelib` (installé, dépendance de digtron et pipeworks, aucune source clonée) et `minerland_fix_silicon`
(mod local sans source). Ce dernier touche probablement le silicium, ingrédient du luacontroller : effet **inconnu**.

---

### mesecons (modpack, 32 mods) — sources auditées : mesecons @ aca87db
- Rôle : circuits logiques à signal « mese » (fils, sources, effecteurs, portes, contrôleurs programmables).
- Dépendances : chaque sous-mod dépend de `mesecons` + `mesecons_gamecompat` (alias vers `default:*` pour MTG,
  `mesecons_gamecompat/compat_mtg.lua:3-16`). Sous-mods utiles et noms réels (`mod.conf`) :
  `mesecons`, `mesecons_wires`, `mesecons_switch`, `mesecons_walllever`, `mesecons_button`, `mesecons_lamp`,
  `mesecons_lightstone`, `mesecons_torch`, `mesecons_pistons`, `mesecons_detector`, `mesecons_pressureplates`,
  `mesecons_solarpanel`, `mesecons_blinkyplant`, `mesecons_gates`, `mesecons_delayer`, `mesecons_insulated`,
  `mesecons_materials`, `mesecons_luacontroller`, `mesecons_microcontroller`, `mesecons_fpga`, `mesecons_noteblock`,
  `mesecons_movestones`, `mesecons_commandblock`. Un modpack peut être activé **partiellement** dans `world.mt` :
  vérifier chaque sous-mod à l'exécution (`core.get_modpath`).
- Mécanique commune : `mesecon.register_node(name, …)` enregistre `name.."_off"` et `name.."_on"`
  (`mesecons/util.lua:299-311`), avec drop vers `_off`. L'activation passe par `mesecon.flipstate` → `swap_node`
  (`util.lua:314-324`), ce qui ne déclenche aucun callback moteur.
- Objets utiles :
  - `mesecons:wire_00000000_off`, le fil de mese (alias `mesecons:mesecon`, `mesecons_alias/init.lua:7`) —
    boucle `mesecons_wires/init.lua:209` (verified). **Obtenu uniquement par cuisson** d'un fragment, d'un cristal
    ou d'un bloc de mese (`mesecons_wires/init.lua:239-265`, type `cooking`) : son craft n'est **pas** détectable.
  - `mesecons_switch:mesecon_switch_off`, l'interrupteur — `mesecons_switch/init.lua:5`, craft `:33` (2 acier, pavé, 2 conducteurs).
  - `mesecons_walllever:wall_lever_off`, le levier mural — `mesecons_walllever/init.lua:6`, craft `:60`.
  - `mesecons_button:button_off`, le bouton — `mesecons_button/init.lua:19`, craft `:107`.
  - `mesecons_lamp:lamp_off`, la lampe — `mesecons_lamp/init.lua:41`, craft `:67` (2 verres, 1 acier, 2 conducteurs).
  - `mesecons_lightstone:lightstone_green_off`, la pierre lumineuse verte (12 couleurs) — `mesecons_lightstone/init.lua:23,65`
    (verified), craft `:53-60`. Ingrédient de l'écran LCD de digilines.
  - `mesecons_torch:mesecon_torch_on`, la torche mese (inverseur) — `mesecons_torch/init.lua:77`, craft `:44`.
  - `mesecons_pistons:piston_normal_off` (`mesecons_pistons/init.lua:260`, craft `:459`, bois + pavé + acier + conducteur)
    et `mesecons_pistons:piston_sticky_off` (`:340`, craft `:468` avec `mesecons_materials:glue`).
  - `mesecons_detector:object_detector_off`, le détecteur de joueur (`mesecons_detector/init.lua:78`, crafts `:115-132`),
    `mesecons_detector:node_detector_off` (`:256`, crafts `:293-310`). Recettes : 7 acier + luacontroller (ou microcontroller) + conducteur.
  - Sources : `mesecons_solarpanel:solar_panel_off` (`mesecons_solarpanel/init.lua:4`, craft `:37`, 4 silicium),
    `mesecons_blinkyplant:blinky_plant_off` (`mesecons_blinkyplant/init.lua:24`, craft `:56`),
    `mesecons_pressureplates:pressure_plate_wood_off` / `_stone_off` (`mesecons_pressureplates/init.lua:94,135,146`).
  - Logique : `mesecons_gates:and_off`, `mesecons_gates:not_off`… (`mesecons_gates/init.lua:87-88,149-185`, verified),
    `mesecons_delayer:delayer_off_1` (`mesecons_delayer/init.lua:28,105`, craft `:154`), `mesecons_insulated:insulated_off`
    (`mesecons_insulated/init.lua:45`, craft `:82`, fibres).
  - `mesecons_luacontroller:luacontroller0000`, le contrôleur Lua — boucle `mesecons_luacontroller/init.lua:837-896`
    (16 noms `luacontroller<dcba>`, verified), craft `:995-1002` : **4 silicium + 5 conducteurs** (pas de mese direct ;
    le mese est dans le fil). Le luacontroller brûlé `mesecons_luacontroller:luacontroller_burnt` (`:958`) n'est pas un objet.
  - `mesecons_microcontroller:microcontroller0000` (`mesecons_microcontroller/init.lua:12,61`) : si le luacontroller est
    présent, il s'obtient **seulement** par échange shapeless avec lui (`:158-168`).
  - `mesecons_fpga:fpga0000` (`mesecons_fpga/init.lua:13-19,56`, craft `:458`, silicium) et l'outil
    `mesecons_fpga:programmer` (`mesecons_fpga/tool.lua:6`).
  - `mesecons_materials:glue` (cuisson d'une pousse, `mesecons_materials/init.lua:16`) et `mesecons_materials:fiber`
    (cuisson de la colle, `:23`) : **cuisson uniquement**, non détectables.
- **Silicium : piège d'alias.** `basic_materials` (dépendance optionnelle sur `mesecons_materials`, donc chargé après)
  fait `core.register_alias_force("mesecons_materials:silicon", "basic_materials:silicon")` (`basic_materials/aliases.lua:32`).
  L'objet réel est donc `basic_materials:silicon` (`basic_materials/craftitems.lua:39`, craft `crafts.lua:393-401` :
  3 sable + 1 acier → 4). Ne **jamais** cibler `mesecons_materials:silicon`. `minerland_fix_silicon` peut encore changer cela.
- Pose (vérifiée) : aucun `on_place` personnalisé dans le modpack, hormis l'outil FPGA (`mesecons_fpga/tool.lua:10`,
  un outil, pas un nœud). Les `after_place_node` présents sont appelés par `item_place_node` **avant**
  `register_on_placenode`, qui reçoit le nom de l'objet posé :
  - pistons : `piston_orientate` fait un `swap_node` (`mesecons_pistons/init.lua:118-128,273,353`) ;
  - fils verticaux : `mesecons_extrawires/vertical.lua:98` ;
  - movestones : `mesecons_movestones/init.lua:97`.
  Les fils changent de forme par `swap_node` dans le hook global `mesecons/services.lua:76`, sans effet sur le nom reçu.
- Événements détectables :
  - **Pose** fil / lampe / interrupteur / levier / piston / luacontroller / détecteurs : **F**.
  - **Craft** lampe, piston, interrupteur, luacontroller, détecteurs, portes, panneau solaire : **F** (grille standard).
  - **Basculer un interrupteur, un levier ou un bouton : A (enveloppe).**
    - Les callbacks sont `on_rightclick` (`mesecons_switch/init.lua:10`, `mesecons_walllever/init.lua:21`, `mesecons_button/init.lua:50`).
    - Méthode : `core.override_item` sur `mesecons_switch:mesecon_switch_off` / `mesecons_walllever:wall_lever_off`. Appeler l'original d'abord, puis émettre si le nœud est passé en `_on`.
    - Faux positifs : un interrupteur non relié compte aussi. **Aucun contrôle de protection** n'existe : on peut basculer l'interrupteur d'autrui.
  - **« Allumer une lampe par un circuit » : I.**
    - La propagation est **asynchrone** : `mesecon.receptor_on` passe par `mesecon.queue:add_action` (`mesecons/init.lua:89-91`).
    - L'effecteur (`mesecons_lamp/init.lua:58-59`) reçoit un `swap_node` sans aucun joueur.
    - Attribuer l'allumage à un joueur imposerait un scan de zone, ce qui est interdit.
  - **Programmer un luacontroller : A (enveloppe de `on_receive_fields`).**
    - Le callback `on_receive_fields` (`mesecons_luacontroller/init.lua:819-833`) contrôle la protection puis appelle `set_program` (`:809-813`).
    - Méthode : `core.override_item` sur les 16 noms `luacontroller0000…1111` (liste reconstruite par la boucle `:837-841`). Appeler l'original en premier, puis émettre `mesecons:luac_program` seulement si toutes ces conditions sont réunies :
      - `fields.program` est présent ;
      - le joueur est réel ;
      - `core.is_protected` est faux pour lui ;
      - le nœud n'est pas `_burnt` ;
      - `meta:get_string("code")` est non vide et égal à `fields.code`.
    - Faux positif : un code **erroné** compte aussi. L'erreur n'est stockée que dans le formspec (`:704-723`), et le lire serait fragile.
    - Aucune API publique `register_on_*` n'existe dans mesecons.
  - Plaques de pression, détecteurs, portes, délais en action : **I** (`set_node` ou `swap_node` par timer ou propagation, sans joueur ; `mesecons_pressureplates/init.lua:73-77`).
- Privilèges et limites :
  - Bloc de commande : `mesecons_commandblock:commandblock_off` (`mesecons_commandblock/init.lua:190`) n'a **aucune recette**. Ses commandes exigent les privilèges du propriétaire (`:165`, `server`/`ban`) : **I**, à exclure.
  - Programmer un luacontroller sur un terrain protégé exige `protection_bypass` (`:824`).
  - Surchauffe : un composant trop sollicité brûle (`mesecon.overheat_max`, 20 par défaut ; `mesecons/services.lua:88-98`).
- Coût serveur :
  - Le luacontroller est sandboxé et borné (`luacontroller_maxevents` 10000, `luacontroller_memsize` 100000, `settingtypes.txt:27-30`). L'enveloppe ne s'exécute qu'à la validation du formulaire : coût nul.
  - Chaque plaque de pression arme un timer de 0,1 s (`mesecons_pressureplates/init.lua:111-113`) : éviter d'en demander plusieurs.
- Réglages `settingtypes` : aucun réglage ne modifie les recettes. Seuls les délais, rayons de détection et limites du luacontroller sont configurables (`settingtypes.txt`).

### digilines (mod `digilines`) — sources auditées : digilines @ 3f6e553
- Rôle : bus de messages (canal + données) entre luacontrollers et périphériques.
- Dépendances : aucune obligatoire ; optionnelles `default, tubelib, tubelib2, mcl_*` (`mod.conf`).
  Utilise `mesecons_materials:fiber` et `mesecons_insulated:insulated_off` dans sa recette de fil (`init.lua:73-91`).
- Objets utiles :
  - `digilines:wire_std_00000000`, le fil digiline — boucle `wire_std.lua:22-34,86` (256 variantes, verified) ;
    craft `init.lua:86-93` (6 fibres, 2 fils isolés, 1 lingot d'or).
  - `digilines:lcd`, l'écran — `lcd.lua:283`, craft `:365` (2 acier, fil digiline, 3 `lightstone_green_off`, 3 verres).
  - `digilines:rtc`, l'horloge (`rtc.lua:31`, craft `:83`, cristal de mese), `digilines:lightsensor` (`lightsensor.lua:39`,
    craft `:85`), `digilines:chest`, le coffre digiline (`inventory.lua:278`, craft `:378`).
- Événements détectables :
  - **Pose et craft de tous ces objets : F.** Aucun `on_place`. L'`after_place_node` du LCD peut refaire un `add_node` pour corriger l'orientation (`lcd.lua:299-306`) : `register_on_placenode` reçoit tout de même `digilines:lcd`.
  - **Envoyer un message ou afficher un texte : I.** `digilines.receptor_send` (`init.lua:63-71`) n'a ni callback public ni joueur. Le LCD reçoit le message d'un luacontroller.
  - **Régler un canal** (`on_receive_fields` du LCD, `lcd.lua:320`) : A possible mais sans intérêt (aucune preuve de fonctionnement). Écarté.
- Limites : `wires_common.lua:8-9` enregistre ses propres hooks place/dig (mise à jour des connexions), sans effet sur nous.
- Réglages : `digilines_enable_lcd`, `_rtc`, `_lightsensor`, `_inventory` (`settingtypes.txt`, `init.lua:95-109`). S'ils valent
  false, l'objet **n'existe pas** : statut « indisponible ».

### digistuff (mod `digistuff`) — sources auditées : digistuff @ 0dcdf51
- Rôle : périphériques digilines (boutons, écran tactile, GPU, lumière variable, mémoire, manette…).
- Dépendances : `digilines, mesecons` ; optionnelles `default, mesecons_mvps, screwdriver, pipeworks, qos, vizlib`.
  `ioexpander` n'est chargé que si `mesecons_luacontroller` est présent (`init.lua:28`). La carte réseau (`nic`) exige
  `secure.http_mods` (`init.lua:34-41`) : à ne pas utiliser.
- Objets utiles :
  - `digistuff:button`, le bouton digiline — `switches.lua:66`, craft `:322`. Une fois configuré, il devient
    `digistuff:button_off` (`:130`) par `swap_node` (`:117`).
  - `digistuff:touchscreen`, l'écran tactile — `touchscreen.lua:231`, craft `:272` (luacontroller + `digilines:lcd` + 7 verres).
  - `digistuff:panel` (`panel.lua:109`, craft `:150`), `digistuff:light_0`, la lampe variable (`light.lua:6,14`, verified,
    craft `:80`), `digistuff:piezo` (`piezo.lua:20`, craft `:75`), `digistuff:detector` (`detector.lua:40`, craft `:115`),
    `digistuff:gpu` (`gpu.lua:936`, craft `:1011`), `digistuff:digimese` (`conductors.lua:58`, craft `:500`, bloc de mese),
    `digistuff:timer` (`timer.lua:1`, craft `:76`), `digistuff:ram` (`memory.lua:1`, craft `:167`),
    `digistuff:card_reader` (`cardreader.lua:42`, craft `:114`), `digistuff:controller`, la manette (`controller.lua:156`, craft `:339`).
- Événements détectables :
  - **Pose et craft : F.** Aucun `on_place`. Les `after_place_node` (`switches.lua:108` → `conductors.lua:13-28`) peuvent remplacer un fil **voisin** par `digistuff:receiver` (`set_node`) : l'objet posé reste reçu par le callback.
  - **Presser un bouton digiline : A (enveloppe).** `on_rightclick = digistuff.button_push(pos, node, player)` (`switches.lua:15-26,173`). Faux positif : bouton sans circuit.
  - **Toucher l'écran tactile : A (enveloppe).** `on_receive_fields` (`touchscreen.lua:213-227`) envoie les champs avec `clicker` ; il n'agit que si l'écran a été configuré par un luacontroller. Avancé, facultatif.
- Mécanismes particuliers :
  - digistuff **remplace la fonction globale** `digilines.update_autoconnect` (`conductors.lua:31-33`). Ce n'est pas notre affaire, mais à connaître en cas de bug de connexion.
  - La manette attache le joueur à l'entité `digistuff:controller_entity` (`controller.lua:119,130,286`). **Ne pas** la mapper dans `integrations/rides.lua`.
- Privilèges : aucun ; tous les réglages respectent la protection (`protection_bypass` sinon).

### digtron (mod `digtron`) — sources auditées : digtron @ 9ae31a6
- Rôle : foreuses modulaires (tunneliers) faites de blocs (contrôleur, têtes, constructeurs, stockage).
- Dépendances : `default, fakelib` ; optionnelles `pipeworks, doc, hopper, awards, catacomb, mtt`. **awards** est
  optionnel : sans lui, ses hooks `digtron.award_*` sont vides (`awards.lua:1-7`).
- Objets utiles (tous littéraux, craft `nodes/recipes.lua`) :
  - `digtron:digtron_core`, le cœur de digtron — `recipes.lua:4`, craft `:12` (4 acier + 1 fragment de mese).
  - `digtron:controller`, le module de contrôle — `node_controllers.lua:22`, craft `:21` (4 cristaux de mese + cœur).
  - `digtron:auto_controller` (`node_controllers.lua:290`, craft `:30`, 8 cristaux de mese).
  - `digtron:digger`, la tête de forage (`node_diggers.lua:103`, craft `:77`, **4 diamants**).
  - `digtron:soft_digger`, la tête de forage tendre (`node_diggers.lua:248`, craft `:86`, 4 acier).
  - `digtron:builder` (`node_builders.lua:210`, craft `:39`), `digtron:inventory` (`node_storage.lua:23`, craft `:95`),
    `digtron:fuelstore` (`node_storage.lua:110`, craft `:104`), `digtron:structure` (`node_misc.lua:4`, craft `:202`),
    `digtron:light` (`node_misc.lua:37`, craft `:68`).
- Événements détectables :
  - **Craft et pose des modules : F.** Aucun `on_place`. Seuls les `after_place_node` pipeworks (`node_storage.lua:87`) et ceux des caisses (`node_crate.lua:142,341,376`) existent.
  - **Creuser avec la foreuse : jamais un `dig`.**
    - Les nœuds sont retirés par `core.remove_node` (`util_execute_cycle.lua:241-266`), sans `node_dig` ni `on_dignode`.
    - Au déplacement, les callbacks `on_dignode` et `on_placenode` sont appelés avec `digtron.fake_player` (`class_layout.lua:381-408`, `init.lua:65`), que `real_player` rejette.
    - Le constructeur pose aussi avec ce faux joueur (`util_item_place_node.lua:171-181`).
  - **Faire avancer la foreuse d'un cycle : A (enveloppe de `on_rightclick`).**
    - Le callback `digtron:controller.on_rightclick(pos, _, clicker)` (`node_controllers.lua:53-83`) appelle `digtron.execute_dig_cycle`.
    - La foreuse avance de `dir = core.facedir_to_dir(param2)` (`util_execute_cycle.lua:287-290`).
    - Méthode : `core.override_item("digtron:controller", {on_rightclick = …})`. Lire `node.param2` **avant** l'appel, appeler l'original, puis émettre `digtron:dig_cycle` si `core.get_node(pos + dir).name == "digtron:controller"` (le contrôleur a bougé).
    - Coût O(1) par clic (cycle limité à 1 s, `node_controllers.lua:57-66`).
    - Faux positifs :
      - une foreuse sans tête qui avance dans l'air (acceptable si la quête précédente exige la pose de `digtron:digger`) ;
      - un joueur qui actionne la foreuse d'autrui, la protection étant vérifiée nœud par nœud (`class_layout.lua:78,105`).
    - Faux négatif : contrôleur automatique (`auto_controller`, cycles par timer), ce qui est voulu.
  - Ne **pas** envelopper `digtron.award_item_dug` et les autres fonctions globales : ce serait remplacer une fonction d'un autre mod, ce qui est interdit.
- Limites, règles serveur :
  - **La limite « 10×10, tunnels seulement » n'est pas codée.** Le seul plafond est `digtron_size_limit`, 1000 nœuds par défaut (`config.lua:30`, `util_execute_cycle.lua:96-100`).
  - L'administratrice peut abaisser ce réglage. Aucune quête ne doit demander une foreuse large ou plusieurs foreuses.
  - Les têtes blessent les joueurs : `digtron_damage_hp` vaut 8 par défaut (`settingtypes.txt`).
- Réglages : `digtron_uses_resources`, `digtron_cycle_time`, `digtron_lava_impassible`, `digtron_size_limit`.
  La recette de `digtron:master_builder` change si technic est présent (`recipes.lua:47-65`), et `digtron:battery_holder` n'existe qu'avec technic (`:111-131`).

### pipeworks (mod `pipeworks`) — complément tubes / tri / injecteurs — pipeworks @ 15794da
Base : `docs/audit/ch16_ch17.md` (§ pipeworks : dépendances, `pipeworks:tube_1`, `pipeworks:filter`, `pipeworks:mese_filter`,
faux joueurs fakelib). Ajouts pour le ch19 :
- Objets :
  - `pipeworks:tube_1`, le tube — craft `tubes/routing.lua:4-11` (6 `basic_materials:plastic_sheet` → 6).
  - Le plastique vient de `basic_materials:oil_extract` (craft) → `basic_materials:paraffin` (cuisson) → plastique (cuisson), `basic_materials/crafts.lua:109-125`.
  - `pipeworks:mese_tube_000000`, le tube de tri — `tubes/sorting.lua:28,37` (enregistrement « ancien », 64 noms, verified).
    Crafts `crafts.lua:205` (plastique + cristal de mese → 2) et `:215` (tube + 4 fragments, shapeless). Réglage `pipeworks_enable_mese_tube`.
  - `pipeworks:digiline_filter` (`filter-injector.lua:382,522`, craft `crafts.lua:110-118` si digilines présent).
  - `pipeworks:lua_tube000000`, le tube Lua (`tubes/lua.lua:31,833-841`, craft shapeless `:1097-1101` : tube de tri +
    luacontroller ; chargé seulement si `pipeworks_enable_lua_tube` et mesecons, `init.lua:77-78`).
  - `pipeworks:autocrafter` (`autocrafter.lua:630`, craft `crafts.lua:124`, 2 cristaux de mese).
  - `pipeworks:one_way_tube` (`tubes/routing.lua:173`, craft `crafts.lua:194`).
  - `pipeworks:teleport_tube_1` (`tubes/teleport.lua:346`, verified) : recette **remplacée par technic**
    (`technic/technic/crafts.lua:33-46`, `technic:control_logic_unit`). Niveau technic MV.
- Pose (vérifiée) : tubes et filtres-injecteurs n'ont **pas** d'`on_place`. Leur `after_place_node` (`tubes/registration.lua:135`, `filter-injector.lua:413-416`) est appelé par `item_place_node` : **F**, avec le nom de l'objet (`_000000` / `_1`) reçu par le callback avant que l'auto-connexion change la forme. Seuls les appareils à **tuyaux** (pompes, vannes) ont `on_place = pipeworks.rotate_on_place` (`devices.lua:213-801`) : hors périmètre.
- Actions :
  - **Trier ou injecter des objets : I.** Le transport se fait par entités et timers, sans joueur. L'autocrafter appelle les callbacks `on_craft` avec un **faux joueur** (`autocrafter.lua:122-141`), que `real_player` rejette.
  - **Programmer un tube Lua : A**, même méthode que le luacontroller (`tubes/lua.lua:785-800`). Doublon, écarté.

---

## Chapitre 19 — « Les machines intelligentes »

On allume d'abord ses premiers circuits mese : fil, lampe, piston. Puis on donne un cerveau à ses machines (luacontroller,
écran digiline). Deux branches indépendantes s'ouvrent ensuite : le tri pneumatique et la foreuse Digtron.
**Règles serveur** : quantité 1 partout, pas de machines en série. Digtron : une petite foreuse de tunnel, un seul cycle.
Aucune quête ne repose sur une action de machine.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch19.first_wire` | « Le fil d'Ariane du mese » | place | `mesecons:wire_00000000_off` | F | — | aucun | Fil obtenu par **cuisson** de mese (craft non détectable). Pose : chemin par défaut, autoconnexion par `swap_node` après coup. Porte d'entrée |
| `ch19.first_lamp` | « Et la lumière fut (enfin presque) » | place | `mesecons_lamp:lamp_off` | F | — | aucun | Craft `mesecons_lamp/init.lua:67`. L'allumage par circuit est I (asynchrone, sans joueur). Alternative de pose : `mesecons_switch:mesecon_switch_off`. Prérequis : `first_wire` |
| `ch19.piston` | « Pousse-toi de là ! » | place | `mesecons_pistons:piston_normal_off` | F | — | aucun | Craft `mesecons_pistons/init.lua:459`. `after_place_node` = orientation par `swap_node` (`:118-128`), callback reçu. Prérequis : `first_wire` |
| `ch19.silicon_brain` | « Un cerveau de sable et de mese » | craft | `mesecons_luacontroller:luacontroller0000` | F | — | aucun | `mesecons_luacontroller/init.lua:995` : 4 `basic_materials:silicon` (alias forcé, **pas** `mesecons_materials:silicon`) + 5 conducteurs. `minerland_fix_silicon` non audité. Prérequis : `first_lamp` |
| `ch19.hello_world` | « Hello, Minerland ! » | custom | `mesecons_luacontroller:luacontroller0000` (+ 15 variantes) | A | `mesecons:luac_program` : enveloppe `on_receive_fields` des 16 noms (`init.lua:819-841`), conditions code non vide, non brûlé, non protégé | aucun | Faux positif : code erroné. Coût nul (formulaire). Prérequis : `silicon_brain` |
| `ch19.digiline_screen` | « Le tableau d'affichage » | place | `digilines:lcd` | F | — | aucun | `lcd.lua:283`, craft `:365` (fil digiline, `mesecons_lightstone:lightstone_green_off`). Absent si `digilines_enable_lcd=false`. Variante avancée : craft `digistuff:touchscreen` (`touchscreen.lua:272`). Prérequis : `silicon_brain` |
| `ch19.sorting_tube` | « Le grand tri » | place | `pipeworks:mese_tube_000000` | F | — | aucun | `tubes/sorting.lua:28`, crafts `crafts.lua:205,215` (plastique, mese). Branche **indépendante** (prérequis `first_wire` au plus). Alternative : pose de `pipeworks:filter` (injecteur) |
| `ch19.digtron_wakes` | « La foreuse s'éveille » | custom | `digtron:controller` | A | `digtron:dig_cycle` : enveloppe `on_rightclick` (`node_controllers.lua:53`), succès si le contrôleur est à `pos + facedir_to_dir(param2)` | aucun | Branche indépendante. Repli F : pose de `digtron:controller` (craft 4 cristaux de mese). Rappel : tunnel ≤ 10×10, une foreuse. Les nœuds creusés ne valident aucun `dig` (`remove_node`) |

Quête facultative non retenue (pour rester à 8) : `ch19.lever_flip` « Clic, clac, ça marche ! », custom
`mesecons:switch_on` (A, enveloppe `on_rightclick` de `mesecons_switch:mesecon_switch_off` / `mesecons_walllever:wall_lever_off`,
émettre si le nœud passe en `_on`) — faux positif : interrupteur d'autrui ou non relié ; peut remplacer `digtron_wakes`.
Arbre suggéré : `first_wire` → (`first_lamp` | `piston`) ; `first_lamp` → `silicon_brain` → (`hello_world` | `digiline_screen`) ;
branches libres `sorting_tube` et `digtron_wakes` (prérequis au plus `first_wire`). Bilan : **6 F, 2 A** (8 candidats).

Actions écartées (I), à documenter :
- Craft du fil de mese, de la colle et des fibres : cuisson uniquement.
- Allumer une lampe, faire jouer un piston, déclencher une porte logique ou un détecteur : propagation par file d'attente
  et `swap_node`/`set_node`, sans joueur.
- Envoyer un message digiline, afficher sur le LCD ou le GPU : aucun callback public, aucun joueur.
- Creuser avec Digtron, construire avec le constructeur Digtron : `remove_node` ou faux joueur.
- Trier ou injecter des objets, autocrafter : entités et faux joueur.
- Bloc de commande : aucune recette, privilèges `server`/`ban`.
- Carte réseau digistuff : exige l'API HTTP.

<!-- source : docs/audit/ch20_ch21.md -->
### Audit — Chapitres 20 « Les portes de l'Enfer » et 21 « Au plus profond de Minerland »

Sources clonées en lecture seule (`.audit_src/`, branche principale, novembre 2026). Les versions du serveur peuvent
différer : **toute référence est revérifiée à l'exécution** (`core.registered_items`). Les chemins sont relatifs à
`.audit_src/<dossier>/`. Ids hors index : `docs/audit/verified_ch20_ch21.txt`.

**Non audités (pas de source)** : `geodes_lib` (dépendance obligatoire d'`amethyst_new`, c'est lui qui génère les géodes),
`everness` (grottes et biomes souterrains possibles). Rien n'est supposé sur leur contenu.

## Variante du dossier `nether` : minetest-mods quasi certaine

Deux sources candidates : `nether` (minetest-mods @ 5480dba) et `nether_hybriddog` (HybridDog @ 79ea36d). Les deux
s'appellent `nether` dans `mod.conf`. Ce que montre le code, comparé à `docs/audit/server_mods.txt` :
1. HybridDog **exige** `glow` et `riesenpilz` (`nether_hybriddog/nether/mod.conf`). Aucun des deux n'est dans le relevé
   du serveur : cette variante ne pourrait pas se charger.
2. `xnether` lit `nether.DEPTH_CEILING`/`DEPTH_FLOOR` (`xnether/ores.lua:36-37`, `trees.lua:391-392`). Ces champs
   n'existent que chez minetest-mods (`nether/init.lua:60-61`). L'en-tête de xnether dit « not intended to be used with
   HybridDog's Nether » (`xnether/init.lua:2-3`).
3. `livingnether` fait apparaître ses mobs sur `nether:rack`, `nether:rack_deep`, `nether:sand`, `nether:basalt`
   (`razorback.lua:73`, `noodlemaster.lua:78`, `cyst.lua:70`). Ces nœuds n'existent que chez minetest-mods.
4. Le wiki indique un Nether vers y = -5000. C'est la valeur par défaut chez minetest-mods (`nether/init.lua:60`,
   réglage `nether_depth_ymax`). Chez HybridDog, le Nether est vers y = -20000 (`nether_hybriddog/nether/common.lua:13,40`).

→ À confirmer sur le serveur : `mods/nether/mod.conf` doit contenir `depends = stairs, default` et le fichier
`portal_api.lua` doit exister. **Identifiants communs aux deux variantes** : `nether:portal` (nœud du vortex, impossible
à obtenir), plus les objets de `default` utilisés par le portail : `default:obsidian` pour le cadre et
`default:mese_crystal_fragment` pour l'allumage. **Aucun objet obtenable n'est commun** : la roche du Nether s'appelle
`nether:rack` chez minetest-mods et `nether:netherrack` chez HybridDog.
Recommandation : écrire le ch20 avec les ids minetest-mods. `core/compat.lua` marquera « indisponible » ce qui manque.
Seul l'allumage du portail (adaptateur ci-dessous) fonctionne avec les deux variantes.

**Allumage : c'est un fragment de cristal de mese, pas un cristal.** Les deux variantes surchargent `on_place` de
`default:mese_crystal_fragment` : clic droit sur l'obsidienne du cadre (`nether/init.lua:150-153` →
`portal_api.lua:2167-2186` ; `nether_hybriddog/nether/portal.lua:693-713`). Le cadre fait 4×5 (intérieur 2×3) dans les
deux variantes : 14 obsidiennes sans les coins chez minetest-mods (`init.lua:164`), contrôle du rectangle complet
chez HybridDog (`portal.lua:492-530`). Le fragment n'est consommé **que si l'allumage réussit** (`portal_api.lua:2172-2175` ;
`portal.lua:706-707`). Un portail déjà allumé renvoie `false` (`portal_api.lua:1356`).

---

### nether (mod `nether`, variante minetest-mods) — sources auditées : nether @ 5480dba
- Rôle : royaume souterrain (y -5000 à -11000) relié à la surface par des portails d'obsidienne. Ajoute aussi une API
  publique de portails.
- Dépendances : obligatoires `stairs, default` ; optionnelles `toolranks, moreblocks, mesecons, loot, dungeon_loot,
  doc_basics, fire, climate_api, ethereal, xpanes, walls` (`mod.conf`).
- Objets utiles :
  - `nether:rack` — roche du Nether (pas de recette, générée seulement dans le Nether) — `nodes.lua:174`
  - `nether:rack_deep` — roche profonde (zone « mantle ») — `nodes.lua:241`
  - `nether:glowstone` — pierre lumineuse générée en stalactites (`mapgen_decorations.lua:35`) — `nodes.lua:261`
  - `nether:sand` — `nodes.lua:251` ; `nether:basalt` (cracky 1, niveau 3) — `nodes.lua:455`
  - `nether:geode` (béryl) — `nodes.lua:185`. `nether:geodelite` (`nodes.lua:201`) donne `nether:geode` quand on la
    creuse. Les géodes n'existent qu'avec le mapgen à biomes (`init.lua:51` : tout mapgen sauf v6).
  - `nether:rack_with_gold` → donne `default:gold_lump` — `ores.lua:4`. `nether:rack_deep_with_mese` → donne 4
    `default:mese_crystal_fragment` — `ores.lua:13`. Les deux sont générés (`ores.lua:25-47`).
  - `nether:brick` — craft 4 `nether:rack` → 4 (`crafts.lua:23`) — `nodes.lua:284`
  - `nether:brick_compressed` — craft 9 briques (`crafts.lua:39`) — `nodes.lua:292`
  - `nether:brick_deep` — craft (`crafts.lua:48`) — `nodes.lua:309`
  - `nether:nether_lump` — craft 9 briques compressées (`tools.lua:114`) — `tools.lua:102`
  - `nether:nether_ingot` — par **cuisson** du lump, 30 s (`tools.lua:107`) — `tools.lua:98`
  - `nether:pick_nether` (`tools.lua:22`, craft `:123`), `nether:sword_nether` (`:83`, craft `:147`),
    `nether:axe_nether` (`:68`), `nether:shovel_nether` (`:52`). Il faut des lingots, donc beaucoup de roche : une
    pioche = 3 lingots = 243 `nether:rack`.
  - `nether:nether_block` (9 lingots) — `nodes.lua:321`, craft `crafts.lua:73`
  - Le vortex `nether:portal` (`nodes.lua:26` via `register_wormhole_node`, `portal_api.lua:2041`) ne s'obtient pas.
- Événements détectables :
  - Creuser roche, pierre lumineuse, minerais, béryl → **F** : `can_dig` standard. Seule la pierre lumineuse
    temporaire du bâton de lumière refuse d'être creusée (`nodes.lua:158-167,269,281`).
  - Craft des briques, de la brique compressée, du lump, des outils → **F** (grille standard). Le lingot (cuisson) → **I**.
  - **Allumer le portail → A** (enveloppe), méthode commune aux deux variantes : au `register_on_mods_loaded`,
    envelopper l'`on_place` actuel de `default:mese_crystal_fragment`, qui est déjà la surcharge du Nether. Appeler
    l'original en premier et renvoyer sa valeur telle quelle. Émettre si le joueur est réel, si `pt.under` était
    `default:obsidian` avant l'appel et si la pile renvoyée a perdu un objet. Faux négatifs : mode créatif (rien n'est
    consommé) et allumage par mesecons (`ignite_portal(pos, nil, …)`, `portal_api.lua:1842`). Faux positif connu : aucun,
    car un échec ne consomme rien (`portal_api.lua:2176-2179`, sinon ancien `on_place` d'un craftitem). Autre méthode, propre à minetest-mods :
    `on_ignite(portalDef, anchorPos, orientation)` (`portal_api.lua:1393-1395`). Elle ne reçoit pas le joueur et
    demande une corrélation : écartée.
  - **Traverser le portail → A** (minetest-mods seulement) : envelopper le champ
    `nether.registered_portals["nether_portal"].on_player_teleported`. Cette table est publique
    (`portal_api.lua:30`, documentée dans `portal_api.txt:111-114,258`). Le champ est nil par défaut. Il est appelé
    avec l'objet joueur juste après `set_pos` (`portal_api.lua:1471-1476`), et le joueur est retrouvé par
    `core.get_player_by_name` (`:1406`). Le sens du passage se lit avec `portalDef.is_within_realm(newPos)`
    (`init.lua:170-172`) : entrée ou retour. C'est une enveloppe de définition, sans fonction globale remplacée.
  - « Être dans le Nether » d'après l'altitude → **I** : c'est une condition de coordonnées, interdite.
  - `nether:book_of_portals` (`portal_api.lua:1808`) vient des coffres de donjon (`:1699-1709`). C'est une possession
    → **I**. `nether:lightstaff` et `nether:lightstaff_eternal` (`tools.lua:368,379`) n'ont **aucune recette** →
    **I** (créatif seulement).
- Mécanismes / limites : le portail réenregistre `default:obsidian` avec un `on_destruct` et un effecteur mesecons
  étendus (`portal_api.lua:1838-1871`). La pose d'obsidienne reste standard (place F), mais elle n'est pas propre au
  Nether. Escaliers et dalles via `stairs` (`nodes.lua:361-424`) : le serveur a son propre dossier `stairs`, donc les
  noms sont à revérifier. Aucun privilège requis.
- Réglages : `nether_realm_enabled` (désactive royaume et portail), `nether_depth_ymax`/`ymin`,
  `nether_portalBook_loot_weighting`, `nether_fasttravel_factor` (`settingtypes.txt`).

### nether — variante HybridDog (mod `nether`) — sources auditées : nether_hybriddog @ 79ea36d
- Rôle : Nether vers y -20000, avec forêt, sang, fruits téléporteurs. **Probablement pas installée** (voir plus haut).
- Dépendances : obligatoires `default, glow, riesenpilz` (absents du serveur) ; optionnelles `creative,
  fence_registration, function_delayer, stairs, watershed`.
- Objets utiles (équivalents) : `nether:netherrack` (`items.lua:71`, `can_dig` exige un outil du groupe `nether`,
  `items.lua:45-68`), `nether:netherrack_brick` (craft `crafting.lua:78`), `nether:pick_netherrack` (`items.lua:852`,
  craft en boucle `crafting.lua:36-46`), `nether:pick_mushroom` (`items.lua:826`), `nether:glowflower` (`items.lua:471`).
- Événements : creuser et crafter → **F**. Allumer le portail → **A**, même enveloppe que plus haut (succès =
  fragment consommé, `portal.lua:706-707`). Le portail d'obsidienne mène **seulement** vers le Nether (`portal.lua:568-571`).
  Pour revenir, il faut manger `nether:apple` dans un portail du Nether (`items.lua:386-398`), sans passer par
  `item_eat`. Traverser → seulement un **état public** `nether.is_player_trapped_in_nether(player)` (`portal.lua:55`).
  Il est lié au réglage `nether.trap_players`, actif par défaut, qui bloque aussi tout autre téléport vers ou depuis
  le Nether (`portal.lua:311-398`). Il n'y a pas de callback.
- Privilèges : `nether` pour les commandes `/to_hell` et autres (`init.lua:191`, `portal.lua:186-286`), hors quêtes.

### livingnether (mod `livingnether`) — sources auditées : livingnether @ 3d4c278
- Rôle : 9 mobs du Nether (mobs_redo). Ils n'apparaissent que sur des nœuds minetest-mods (voir plus haut).
- Dépendances : obligatoires `mobs, default, nether`.
- Objets : **aucun objet propre** à part les œufs et les flèches de mobs. Entités `livingnether:razorback`
  (`razorback.lua:3`), `livingnether:tardigrade` (`tardigrade.lua:3`), `livingnether:noodlemaster` (`noodlemaster.lua:3`).
  Butins : objets de `default` et d'`animalworld` (`flyingrod.lua:35-36`).
- Événements : tuer, capturer (`mobs:capture_mob`, `razorback.lua:66`) ou apprivoiser → **I** (dépend d'un mob, §3).
  Les œufs sont des objets créatifs.
- Réglages : un fichier `spawn.lua` personnalisé peut remplacer l'apparition des mobs (`init.lua:40-65`).

### xnether (mod `xnether`) — sources auditées : xnether @ 2071814
- Rôle : arbres, herbes, fleurs et minerais pour le Nether de minetest-mods.
- Dépendances : obligatoire `nether` (utilise `nether.DEPTH_*`, voir plus haut).
- Objets utiles :
  - `xnether:purple_tree` / `xnether:blue_tree` — troncs (`trees.lua:159,172`). Arbres générés par schéma sur
    `nether:rack` / `nether:rack_deep`, biome `nether_caverns` (`trees.lua:397-443`).
  - `xnether:purple_wood` / `xnether:blue_wood` — `trees.lua:186,198`, craft 1 tronc → 4 (`:371,378`)
  - `xnether:purple_sapling` / `xnether:blue_sapling` — `trees.lua:78,118`. Ils tombent des feuilles 1 fois sur 20
    (`:219-226`) et ne poussent que dans le noir, sur la roche du Nether (`:20-45`).
  - `xnether:fruit` — `trees.lua:266`, `on_use = item_eat(-3)` : **retire 3 PV** (`:287`)
  - `xnether:rack_with_gold`, `xnether:rack_deep_with_mese` — `ores.lua:15,25`. Ce sont des **doublons** des minerais
    de nether, mêmes butins, générés aussi (`ores.lua:42-63`).
  - Clôtures et poteaux lumineux (`xnether:fence_purple`, `xnether:purple_mese_post_light`… `trees.lua:293-362`) :
    recettes de `default.register_fence` et `register_mesepost` (`minetest_game/mods/default/functions.lua:385,508`).
  - Herbes et fleurs `xnether:grass_<couleur>_<1..3>` et `xnether:flower_<couleur>_<1..2>` (boucle `grass.lua:22-77`).
    Les fleurs font 1 dégât par seconde.
- Événements : creuser les troncs et minerais → **F**. Craft des planches, clôtures, poteaux → **F**. Pose d'une jeune
  pousse → **F** : `default.sapling_on_place` (`trees.lua:102-103`) appelle `registered_on_placenodes`
  (`minetest_game/mods/default/trees.lua:521`). Manger le fruit → **F**, mais il fait perdre 3 PV : déconseillé.
- Réglages : `xnether_enable_fireflies` (particules seulement).

### caverealms_lite (mod `caverealms`) — sources auditées : caverealms_lite @ 6af99e8 (2019 : le serveur a peut-être un fork plus récent)
- Rôle : grottes géantes (y -1500 à -33000) avec biomes de mousse, champignons, algues, glace, sel, obsidienne
  lumineuse et poussière de charbon. Générées dans `default:stone` (`init.lua` on_generated).
- Dépendances : aucune ; `ethereal` et `mobs_monster` modifient le contenu (voir plus bas).
- Objets utiles (tous générés, ils se creusent et donnent le nœud lui-même sauf mention) :
  - `caverealms:glow_gem` — petite gemme lumineuse, biome mousse (`init.lua:228`) — `nodes.lua:144`
  - `caverealms:glow_crystal` (`nodes.lua:2`), `caverealms:glow_ore` (`:72`), `caverealms:glow_emerald` (`:16`),
    `caverealms:glow_ruby` (`:44`), `caverealms:glow_amethyst` (`:58`) — stalagmites de cristal (`functions.lua:105-205`),
    chance 0,0002 par point de plafond ou de sol (`config.lua:33`)
  - `caverealms:fungus` (`plants.lua:4`), `caverealms:mycena` (`plants.lua:24`) — champignons du biome fongique
  - `caverealms:glow_worm` (`nodes.lua:397`), `caverealms:glow_worm_green` (`:416`) — vers suspendus au plafond
  - `caverealms:mushroom_gills` — lamelles des champignons géants, chance 0,001 (`plants.lua:90`)
  - `caverealms:thin_ice` (`nodes.lua:116`), qui se crafte en `default:water_source` (`crafting.lua:3`)
  - `caverealms:glow_bait` ×9 ← 1 `glow_worm_green` (`crafting.lua:82-92`) ; `caverealms:angler_rod`
    (`crafting.lua:66-79`). Les deux ne sont enregistrés **que si `ethereal` est présent** (`crafting.lua:63`), ce qui est
    le cas sur le serveur.
  - `caverealms:glow_obsidian` (`nodes.lua:314`) → briques (`crafting.lua:30`) et verre (`:47`) ;
    `caverealms:dm_statue` (`crafting.lua:20`) demande `caverealms:hot_cobble`, qui n'existe que dans le repaire
    y -14000 à -16000
- Événements : creuser → **F**. Craft des appâts, de la canne, des briques et du verre d'obsidienne lumineuse, de la
  statue → **F**. La pêche avec la canne appâtée ajoute l'objet directement à l'inventaire (`crafting.lua:125`) → **I**.
- Limites :
  - Avec `ethereal`, `caverealms:mushroom_cap/stem` sont des **alias** d'`ethereal:mushroom` et
    `ethereal:mushroom_trunk`, et la jeune pousse n'est pas enregistrée (`plants.lua:44-87`). Les champignons géants
    sont donc faits de nœuds ethereal (`functions.lua:362-368`).
  - Les biomes « profonds » (sel, obsidienne lumineuse, charbon) commencent sous y -7000 (`config.lua:53`), et le
    repaire est à y -14000/-16000. Le Nether occupe la tranche -5000/-11000 et sa pierre n'est pas `default:stone`.
    Ces biomes ne se trouvent donc **probablement que sous -11000**, ce qui est déconseillé pour des quêtes.
    À vérifier en jeu.
  - Sans `mobs_monster`, qui n'est pas dans le relevé, pas de maîtres de donjon (`init.lua:13-17`).
- Réglages : clés `caverealms.*` dans `minetest.conf` (`config.lua:23-53` : limites, chances, `deep_cave`, `dm_*`).

### amethyst_new (mod `amethyst_new`) — sources auditées : amethyst_new @ 87ed79d
- Rôle : géodes d'améthyste avec coque de basalte et de calcite (`init.lua:8-19`, via `geodes_lib`, **non audité**),
  plus les blocs décoratifs qui en dérivent.
- Dépendances : obligatoires `default, geodes_lib` ; optionnelles `doors, stairs, walls, mesecons, mesecons_mvps,
  lucky_block`.
- Objets utiles :
  - `amethyst_new:amethyst` — bloc, intérieur des géodes (y -31000 à -128, dans la pierre) — `nodes.lua:51`
  - `amethyst_new:amethyst_budding` — `nodes.lua:58`, donne un bloc normal quand on le creuse. Une ABM fait pousser
    des amas toutes les 240 s (`budding.lua:10-31`).
  - `amethyst_new:cluster_small` / `amethyst_new:cluster_large` — `nodes.lua:66,114`. Éclat 1 fois sur 6 pour le petit,
    toujours pour le grand.
  - `amethyst_new:amethyst_shard` — `nodes.lua:266`, craft 1 bloc → 9 (`crafting.lua:44`)
  - `amethyst_new:calcite`, `amethyst_new:basalt` — coque (`nodes.lua:22,1`) ; `amethyst_new:checkerboard` (`crafting.lua:36`)
  - `amethyst_new:tinted_glass` — 4 éclats + 1 verre → 2 (`crafting.lua:60`) — `nodes.lua:132`
  - `amethyst_new:lantern` — `lantern.lua:69`, craft `crafting.lua:75` : bronze, 4 blocs d'améthyste et
    `group:mesecon_conductor_craftable` (un fil mesecons) si mesecons est présent, sinon une torche (`:68-72`)
  - `doors:door_amethyst_bronze` / `doors:door_bronze` (`nodes.lua:161,143`, si `doors` est présent)
- Événements : creuser blocs, amas, coque → **F**. Les amas qui ont poussé par `swap_node` ne sont jamais marqués
  « posés ». Craft du verre, de la lanterne, des portes → **F**. Pose de la lanterne → **F** (pose par défaut).
  Pose d'une porte → **F** : les portes MTG appellent `registered_on_placenodes`
  (`minetest_game/mods/doors/init.lua:196`).
- Limites : l'emplacement et la fréquence des géodes dépendent de `geodes_lib` (non audité) ; dans le code de ce mod,
  `scarcity = 50`, rayon 2 à 10.
- Réglages : `lantern_light_source` (lumière seulement).

### lootchests_modpack (mods `lootchests`, `lootchests_default`, `lootchests_magic_materials`) — sources auditées : lootchests_modpack @ 9b09d4b
- Rôle : coffres au butin aléatoire. API `lootchests.register_lootchest` (`lootchests/api.lua:27`).
- Dépendances : `lootchests_default` → `default, lootchests`, plus de nombreux mods MTG (`depends.txt`).
  `lootchests_magic_materials` dépend de `magic_materials`, **absent du relevé** : il ne se chargera pas.
- Objets utiles (ids construits par `minetest.register_node(def.name, …)`, `api.lua:74`) :
  - `lootchests_default:stone_chest` (« Ancient Chest », dans et sur la pierre, y -128 à -4096, `chests.lua:73`)
  - `lootchests_default:urn` et `lootchests_default:basket` (sur la pierre, y 0 à -256, `chests.lua:37,19`)
  - `lootchests_default:ocean_chest` (sable ou pierre, y 5 à -512, `chests.lua:4`) et `lootchests_default:barrel`
    (sable, `:55`). On les trouve aussi dans les épaves (voir shipwrecks).
- Mécanisme : le mapgen pose un marqueur invisible `<nom>_marker` (`api.lua:66`, minerai ou décoration). Une LBM le
  remplace par le coffre avec `set_node` et le remplit (`api.lua:107-128`). Le coffre est donc **naturel**, jamais
  « posé ». `can_dig` n'autorise le démontage que si le coffre est **vide** (`api.lua:99-103`). Le formulaire est un
  champ de métadonnées `formspec` (`api.lua:85-93`).
- Événements :
  - **Ouvrir un coffre → I** : il n'y a pas d'`on_rightclick`, et le client ouvre directement le formulaire stocké en
    métadonnées. Le serveur n'en est pas informé.
  - **Vider puis démonter un coffre → F** (dig) : seul un joueur qui a tout pris peut le creuser. Le coffre démonté
    revient au joueur, qui peut le reposer, mais l'anti-triche ignore les nœuds reposés.
  - **Prendre un objet dans un coffre → A** (enveloppe) : `core.override_item` de chaque `lootchests_default:*` pour
    ajouter `on_metadata_inventory_take(pos, listname, index, stack, player)`. Ce callback est absent de la définition
    (`api.lua:74-104`) ; s'il existe un jour, l'appeler d'abord. Faux positif : un coffre reposé et rempli par le joueur
    lui-même. Il faut ignorer les positions du journal « posé » du moteur de quêtes.
- Réglages : `lootchests_debug` (marqueurs visibles, pas de LBM : `api.lua:7,106`).

### shipwrecks (mod `shipwrecks`) — sources auditées : shipwrecks @ 16b3ca0
- Rôle : 18 épaves (3 bois × 6 schémas, `init.lua:3-7`) posées sur le sable sous l'eau, dans les blocs entre y -64 et 64
  (`init.lua:31-70`). Les schémas contiennent `lootchests_default:ocean_chest_marker` et `barrel_marker` (lu dans les
  `.mts`).
- Dépendances : obligatoires `default, lootchests_default, stairs`.
- Objets : **aucun objet propre**. Événements : ceux de lootchests (démonter le coffre vidé → F). Une épave
  n'est pas un objet : la trouver → **I**.
- Réglages : `shipwrecks:chance` (15 %), décalages, graine (`settingtypes.txt`).

### other_worlds (mod `other_worlds`) — sources auditées : other_worlds @ 411e997
- Rôle : astéroïdes et ciel spatial **en altitude** (y 5000 à 31000, `settingtypes.txt`). Ce mod n'a **pas sa place**
  dans les profondeurs. Avec le Nether, il ne fait que changer le ciel dans la tranche du Nether
  (`skybox.lua:21-30,103`).
- Objets : `asteroid:*` et `mars:*` (`nodes.lua:4-238`). À réserver pour une éventuelle quête « espace ».

---

## Chapitre 20 — « Les portes de l'Enfer »

*Derrière un cadre d'obsidienne s'ouvre un monde de feu. Allume le portail, récolte ses étranges matériaux et forge
des objets venus d'ailleurs.* Ids de la variante minetest-mods, avec l'équivalent HybridDog en remarque. Aucun privilège.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch20.light_portal` | « Une étincelle de mese » | custom | `default:mese_crystal_fragment` sur `default:obsidian` | A | `nether:portal_lit` — enveloppe `on_place` du fragment, succès = fragment consommé (`portal_api.lua:2173` ; HD `portal.lua:707`) | aucun | Même méthode pour les **deux variantes**. Texte : « fragment », pas « cristal ». Le cadre est fait en jeu (obsidienne : pose générique, non retenue) |
| `ch20.first_rack` | « Premiers pas en enfer » | dig | `nether:rack` | F | — | aucun | Généré seulement dans le Nether, sans recette : preuve d'arrivée sans condition de coordonnées. HD : `nether:netherrack`. Prérequis suggéré : `light_portal` |
| `ch20.cross_portal` | « Aller et retour » | custom | portail `nether_portal` | A | `nether:teleported_in` / `nether:teleported_out` — enveloppe `registered_portals["nether_portal"].on_player_teleported` + `is_within_realm` (`portal_api.lua:1474`, `init.lua:170`) | aucun | minetest-mods seulement. Branche facultative : `first_rack` (F) couvre déjà l'arrivée |
| `ch20.glowstone` | « La pierre qui brûle sans feu » | dig | `nether:glowstone` | F | — | aucun | Stalactites naturelles (`mapgen_decorations.lua:35`). Variante plus profonde : `nether:glowstone_deep` |
| `ch20.nether_ores` | « L'or des damnés » | dig | `nether:rack_with_gold`, `xnether:rack_with_gold` (ou `nether:rack_deep_with_mese`, `xnether:rack_deep_with_mese`) | F | — | aucun | Deux mods génèrent le même minerai : accepter les deux ids. Niveau 2 : pioche en acier minimum |
| `ch20.purple_forest` | « Bûcheron des ténèbres » | dig | `xnether:purple_tree` (ou `xnether:blue_tree`) | F | — | aucun | Arbres naturels du biome `nether_caverns`. Suite possible : craft `xnether:purple_wood` (F, `trees.lua:371`) |
| `ch20.nether_bricks` | « Maçon infernal » | craft | `nether:brick_compressed` | F | — | aucun | 9 `nether:brick` (= 9 roches). HD : `nether:netherrack_brick` |
| `ch20.nether_pick` | « Un outil venu d'ailleurs » | craft | `nether:pick_nether` | F | — | aucun | 3 lingots, chacun obtenu par **cuisson** d'un lump (81 roches) : quête longue, fin de chapitre. Prérequis : `nether_bricks`. HD : `nether:pick_netherrack` |

Écartés : tuer ou capturer les mobs de livingnether (I) ; posséder le Livre des portails (I) ; bâton de lumière (sans
recette, I) ; manger `xnether:fruit` (F, mais −3 PV) ; « entrer dans le Nether » d'après l'altitude (I, coordonnées).

## Chapitre 21 — « Au plus profond de Minerland »

*Cristaux luminescents, géodes et champignons géants : les profondeurs cachent des merveilles… et quelques trésors
oubliés.* Ces quêtes visent les biomes caverealms entre y -1500 et -5000, au-dessus du Nether. Les géodes dépendent de
`geodes_lib` (non audité) ; `everness` n'est pas audité non plus.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch21.glow_gems` | « Lueurs dans la mousse » | dig | `caverealms:glow_gem` | F | — | aucun | Biome mousse, fréquent (`config.lua:37`). Se casse à la main. Point d'entrée |
| `ch21.cave_mushrooms` | « Cueillette souterraine » | dig | `caverealms:mycena`, `caverealms:fungus` | F | — | aucun | Biome fongique. Les champignons géants sont des nœuds ethereal sur le serveur (alias, `plants.lua:44-46`) |
| `ch21.glow_bait` | « Appâts luisants » | craft | `caverealms:glow_bait` | F | — | aucun | 1 `caverealms:glow_worm_green` → 9. Existe seulement si ethereal est présent (`crafting.lua:63`). Suite : `caverealms:angler_rod` (F) |
| `ch21.glow_crystal` | « Le cœur des cristaux » | dig | `caverealms:glow_crystal` (ou `caverealms:glow_emerald`, `caverealms:glow_ruby`, `caverealms:glow_amethyst`, `caverealms:glow_mese`) | F | — | aucun | Formations rares (chance 0,0002). Accepter toute la famille. Prérequis suggéré : `glow_gems` |
| `ch21.amethyst_geode` | « La géode d'améthyste » | dig | `amethyst_new:amethyst` | F | — | aucun | Intérieur des géodes, y ≤ -128 (`init.lua:8-19`). Génération par `geodes_lib` (non audité) : à vérifier en jeu |
| `ch21.amethyst_lantern` | « Lanterne de cristal » | place | `amethyst_new:lantern` | F | — | aucun | Craft `crafting.lua:75` : bronze, 4 blocs d'améthyste, fil mesecons. Pose par défaut. Prérequis : `amethyst_geode`. Plus simple : craft `amethyst_new:tinted_glass` (F) |
| `ch21.ancient_chest` | « Le coffre oublié » | dig | `lootchests_default:stone_chest` (ou `lootchests_default:urn`, `lootchests_default:basket`) | F | — | aucun | Coffre naturel (LBM `set_node`). Il ne se creuse que **vide** (`api.lua:99`) : le vider puis le démonter. Branche « épaves » : `lootchests_default:ocean_chest` (sous l'eau) |
| `ch21.treasure_take` | « Pilleur de trésors » | custom | `lootchests_default:*` | A | `lootchests:take` — enveloppe `on_metadata_inventory_take` ajoutée par `override_item` (absente de `api.lua:74-104`) | aucun | Ouvrir le coffre n'est **pas** détectable (formspec en métadonnées). Ignorer les coffres reposés. `ancient_chest` (F) est préférable |

Écartés : biomes profonds de caverealms (sel, obsidienne lumineuse, repaire et `caverealms:dm_statue`), probablement
sous le Nether ; pêche à la canne appâtée (I) ; trouver une épave (I) ; other_worlds (altitude, hors sujet).

## Points à confirmer par l'administratrice
1. Variante `nether` : `mods/nether/mod.conf` (`depends = stairs, default`) et présence de `portal_api.lua`.
2. `nether_depth_ymax` dans `minetest.conf` ou `world.mt` (le wiki dit -5000, la valeur par défaut).
3. `geodes_lib` et `everness` : sources inconnues. La version de `caverealms_lite` installée est-elle celle de 2019 ?
4. `lootchests_magic_materials` est-il activé ? Sans `magic_materials`, il ne peut pas se charger.

<!-- source : docs/audit/ch22_ch23.md -->
### Audit — Chapitres 22 « Dragons et autres bestioles » et 23 « Les mystères du passé »

Sources auditées (lecture seule, branche principale, nov. 2026) : `.audit_src/draconis` @ `5ad66e4`, `creatura` @ `4eb507c`,
`mob_core` @ `1835b85`, `paleotest` @ `7f3c5fa` (2020-12-17). **Les versions serveur peuvent différer** : toute référence
est revérifiée à l'exécution (`core.registered_items`). Chemins relatifs au dossier du mod concerné.
Identifiants construits dans des boucles : voir `docs/audit/verified_ch22_ch23.txt`.

**Non audités (aucune source)** :
- `minerland_fix_draconis` : mod local. Son effet sur l'apparition des dragons, les œufs, les recettes ou les nids est **inconnu**.
  C'est un point bloquant pour tout le ch22 (voir « Points à confirmer »).
- `mobkit` : dépendance obligatoire de `mob_core` et `paleotest`, installée sur le serveur (`server_mods.txt:132`), mais
  absente de `tools/audit_sources.txt`. Elle n'a pas été lue. Seuls ses appels (`mobkit.remember`, `statfunc`…) sont visibles.

---

### draconis (mod `draconis`) — sources auditées : draconis @ 5ad66e4
- Rôle : dragons de feu et de glace (œufs, croissance, monture, souffle), wyvernes de jungle, forge draconique, outils et armures.
- Dépendances : obligatoire `creatura` ; optionnelles `default, mcl_player, stairs, 3d_armor` (`mod.conf`). Les armures ne sont
  enregistrées que si `3d_armor` est présent (`init.lua:116-118`), ce qui est le cas sur le serveur.
- Objets utiles :
  - Monde des dragons (nœuds générés, pose par défaut) :
    - `draconis:bone_pile_scorched` / `draconis:bone_pile_frozen`, tas d'os des nids — `nodes.lua:228/240`.
    - `draconis:stone_scorched` / `draconis:stone_frozen`, pierre calcinée ou gelée — `nodes.lua:74/84` (cracky=1, **level=3** :
      il faut une pioche mese ou diamant, `minetest_game default/tools.lua:93,108`).
    - `draconis:soil_scorched`, sol calciné — `nodes.lua:96`. `draconis:log_scorched`, bûche calcinée par le souffle — `nodes.lua:52`.
    - Trésor des nids : `default:goldblock` (feu, `mapgen.lua:186,415`), `default:steelblock` (glace, `mapgen.lua:311,507`).
  - Construction :
    - `draconis:stone_bricks_scorched` / `draconis:stone_bricks_frozen` — craft `craftitems.lua:1177/1169` (4 pierres → 4).
    - `draconis:wood_planks_scorched` — craft `craftitems.lua:1106`.
  - Forge : `draconis:draconic_forge_fire` (`nodes.lua:649`) et `draconis:draconic_forge_ice` (`nodes.lua:872`).
    - Recettes `craftitems.lua:1122/1113` : 8 pierres calcinées ou gelées + `default:furnace`.
    - La sortie est déclarée sous l'**alias** `draconis:draconic_steel_forge_fire`/`_ice` (`nodes.lua:1103/1095`), que le moteur
      résout en `draconis:draconic_forge_*`.
  - Corps de dragon (butin d'un dragon **mort** : `draconis.drop_items`, `api/api.lua:315` ; tables `api/api.lua:1096-1127`) :
    - `draconis:dragon_bone` — `craftitems.lua:68`.
    - `draconis:scales_<feu|glace>_dragon_<couleur>` (verified).
    - `draconis:egg_fire_<couleur>` / `draconis:egg_ice_<couleur>` (verified) : 1 chance sur 6, seulement sur un dragon
      **sauvage** adulte (`api/api.lua:1119-1125`).
  - Objets avancés :
    - `draconis:libri_draconis`, le bestiaire — `api/libri.lua:413`, craft `craftitems.lua:1081/1090` (`group:dragon_scales` + livre + colorant rouge).
    - `draconis:dragonbinder` — `craftitems.lua:613`, craft `:1072` (os + `default:goldblock`) et `:1063` (alias `dragon_flute`).
    - `draconis:dragonstone_crucible` — `craftitems.lua:628`, craft `:1185`.
    - Lingots `draconis:draconic_steel_ingot_fire`/`_ice` (`:98/104`), produits par la forge seulement.
    - Armures `draconis:helmet_fire_draconic_steel`… (`armor.lua:9-75`), crafts `craftitems.lua:1401-1441`.
- Événements détectables :
  - Creuser un tas d'os, la pierre ou le sol calcinés, ou une bûche calcinée → **F**. Ces nœuds sont placés par le mapgen
    (VoxelManip) ou par le souffle (`set_node`, `api/api.lua:810`), jamais « posés par un joueur ».
  - Creuser un bloc d'or de nid → **F** techniquement. Mais tout bloc d'or non posé par un joueur compte, quel qu'en soit le générateur.
  - Fabriquer les briques, les planches ou la forge → **F** (grille standard, recettes shaped).
  - Poser la forge → **F** : pas d'`on_place`, pose par défaut. `on_construct` (`nodes.lua:661`) n'agit que si la structure est complète.
  - Poser un œuf de dragon → **F** techniquement (nœud sans `on_place`, `craftitems.lua:132`). L'obtenir exige la mort d'un dragon → **I** sur ce serveur.
  - Faire éclore un œuf → **I**. Il faut 9 tas d'os dessous (`craftitems.lua:159-186`), puis 1000 s dans le feu (œuf de feu)
    ou dans l'eau (œuf de glace) (`:249`, `:399`). Aucun callback n'est émis. Le propriétaire est le **dernier joueur passé
    à moins de 6 m** (`:231-239`), pas forcément celui qui a posé l'œuf.
  - Monter un dragon → **A** (rides, voir §2 bis ci-dessous). Conditions : être propriétaire, main vide, dragon d'âge ≥ 35
    (`api/api.lua:2208-2215`). L'âge monte de 1 toutes les 1200 s chargées (`api/api.lua:1081-1086`) ou tous les 20 repas
    cuits (`:1368-1372`), soit environ 12 h de jeu depuis l'éclosion. Comme l'œuf vient d'un combat → **I** en pratique.
  - Monter une wyverne de jungle → **A** (rides). Une wyverne **sauvage** accepte n'importe quel joueur à main vide
    (`api/api.lua:2241-2250`). Monter une wyverne sauvage lance le « dressage » : utilité `draconis:wyvern_breaking` (`api/behaviors.lua:852`).
  - Apprivoiser une wyverne → **A**. On tient de la viande (`group:food_meat`, `mobs/jungle_wyvern.lua:64-66`) dans le
    **slot 1** pendant le vol. À 100 %, le code fait `_self.owner = …` (`api/behaviors.lua:918-920`).
    - Il n'existe aucun callback public. Méthode : `rides.lua` lit `parent:get_luaentity().owner` quand le joueur est attaché.
    - Après le dressage, le joueur reste en selle (utilité `wyvern_mount`, `behaviors.lua:1402-1410`).
  - Fabriquer le bestiaire, le dragonbinder, les outils ou les armures → **F** pour le moteur, mais tous exigent os ou
    écailles, donc un dragon mort. À ne pas retenir comme quête (combat).
  - Forger un lingot draconique → **I** (machine). Il faut un dragon apprivoisé qui souffle dans la forge (`on_breath`, `nodes.lua:841`),
    99 lingots d'acier par lingot (`nodes.lua:256,601-607`) et des blocs de pierre de dragon. Ces blocs n'ont ni recette ni
    génération : seul le souffle d'un dragon sur une pile d'au moins 99 pierres au sol les crée (`api/api.lua:711-722`).
  - Pages du Libri, ordres, nom du dragon → **I** (métadonnées d'objet ou formspec, sans callback).
- §2 bis « monter à bord » :
  - (a) Le cavalier est attaché directement au dragon : `player:set_attach(self.object, "Torso.2", …)` dans
    `draconis.attach_player`, `api/mount.lua:169`. **Re-vérifié.** Le passager est attaché de la même façon (`attach_passenger`,
    `api/mount.lua:224`), après acceptation par le cavalier (`mount.lua:310-333`).
  - (b) Noms d'entité (via `creatura.register_mob` → `minetest.register_entity`, `creatura/mob_meta.lua:1247`) :
    - `draconis:fire_dragon` — `mobs/fire_dragon.lua:20`.
    - `draconis:ice_dragon` — `mobs/ice_dragon.lua:20`.
    - `draconis:jungle_wyvern` — `mobs/jungle_wyvern.lua:9`.
  - (c) Attaches parasites :
    - `draconis:mounted_player_visual` (`api/mount.lua:16`) est attaché **au dragon** (`mount.lua:96/98`), jamais au joueur.
    - Le bébé dragon « sur l'épaule » s'attache **au joueur** (`api/api.lua:2218`). Le joueur devient le parent :
      `get_attach()` du joueur reste nil.
    - Un joueur gelé est attaché à l'entité `draconis:dragon_ice` (`api/api.lua:614-621`) : ne **pas** la mettre dans la table.
    - Un passager est vu comme « à bord ». Pour une quête de cavalier, exiger `luaentity.rider == joueur` ou
      `luaentity.owner == nom` (état public).
- Mécanismes particuliers / limites / privilèges :
  - `/tamedragon` et les commandes de personnalisation exigent le privilège `draconis_admin` (`api/api.lua:1616-1624,1676,1722…`).
    Ce privilège n'est **jamais** utilisable pour une quête.
  - Le craft d'un outil ou d'une armure en acier draconique, avec des lingots de dragons différents, est annulé par le
    `register_on_craft` du mod : il rend une pile vide (`craftitems.lua:1447-1478`). `core.on_craft` enchaîne les callbacks.
    Si `minerland_quests` s'enregistre **avant** draconis, il compterait un craft annulé. `optional_depends = draconis` règle l'ordre.
  - Les wyvernes et les dragons sauvages attaquent les joueurs proches (`api/behaviors.lua:140-150`, `:1358-1390`).
    Les nids sont gardés par un dragon (nœud `creatura:spawn_node`, `mapgen.lua:207-211`). C'est risqué, mais aucune quête n'exige de combat.
  - Bug source : le filtre de biome des wyvernes est vide. Le code fait `ipairs` sur `minetest.registered_biomes`, une table
    indexée par nom (`mobs/jungle_wyvern.lua:204-211`). Résultat : apparition sur **toutes** les feuilles, sans filtre de biome
    (`creatura/spawning.lua:232-243`), à raison de 1 chance sur 60000 par tick.
- Réglages `settingtypes` :
  - **Bloquant** : `nest_spawning` et `cavern_spawning` sont lus avec `minetest.settings:get(clé, défaut)` (`mapgen.lua:9,11`).
    `Settings:get` n'accepte pas de valeur par défaut. Donc :
    - sans ligne dans `minetest.conf`, la valeur vaut nil et **aucun nid ni caverne n'est généré** ;
    - avec n'importe quelle valeur, même `false`, ils sont activés.
  - `simple_spawning` (get_bool, défaut false, `init.lua:139`) : pas d'apparition aléatoire de dragons.
  - En configuration par défaut, il n'y aurait donc **aucun dragon de feu ou de glace** sur la carte. À confirmer côté serveur.
  - `dragon_terrain_destruction` (défaut false) ne bloque pas le souffle : le souffle calcine toujours, hors zones protégées (`api/api.lua:801-811`).
  - `register_stairs` (défaut true) : ajoute les escaliers `stairs:*`.

### creatura (mod `creatura`) — sources auditées : creatura @ 4eb507c
- Rôle : API de mobs utilisée par draconis (mouvement, utilités, apparition). Dépendances : aucune (`mod.conf`).
- Objets utiles : aucun pour une quête. `creatura:spawn_node`, invisible, sert de marqueur d'apparition (`spawning.lua:356`).
  Œufs créatifs `draconis:spawn_*` (`spawning.lua:135`, `register_spawn_item`) : non fabricables.
- Événements détectables : seul callback public, `creatura.register_on_spawn(name, func)` (`spawning.lua:138`). Il signale
  l'apparition d'un mob, pas une action de joueur → **I** pour les quêtes. Aucun hook public d'apprivoisement.
- Limites : `mobs_spawn = false` coupe toutes les apparitions ABM (`spawning.lua:171`).
- Réglages : `creatura_spawn_interval`, `creatura_protected_spawn` (défaut true) ; le mapgen spawning est codé en dur à false
  (`spawning.lua:362`).

### mob_core (mod `mob_core`) — sources auditées : mob_core @ 1835b85
- Rôle : surcouche de `mobkit` (monture, apprivoisement, nom, protection), utilisée par paleotest.
- Dépendances : obligatoire `mobkit` (non audité) ; optionnelle `default` (`mod.conf`).
- Objets utiles :
  - `mob_core:protection_gem` — `craftitems.lua:8`, craft sans forme `:25` (1 `default:diamond`).
  - `mob_core:nametag` — `craftitems.lua:15`, craft `:32` (papier, `dye:black`, `farming:string`), seulement si `dye` et `farming` sont présents.
- Événements détectables :
  - Fabriquer la gemme ou l'étiquette → **F**.
  - Nommer ou protéger un mob (`mob_core.nametag`, `api.lua:1383` ; `mob_core.protect`, `api.lua:1331`) → **I** : formspec ou clic, sans callback.
  - Apprivoiser → **I** directement. `mob_core.set_owner` (`api.lua:737`) est une fonction globale d'un autre mod :
    l'envelopper est interdit (README §2). L'état public `luaentity.owner`/`tamed` reste lisible par `rides.lua`.
- §2 bis : `mob_core.mount` (`api.lua:1188`, adulte et sans conducteur) appelle `mob_core.attach`, qui fait
  `player:set_attach(entity.object, …)` (`mount.lua:84`). Ce point est établi.
- Limites : `on_dieplayer`/`on_leaveplayer` détachent le joueur (`mount.lua:56-67`).

### paleotest (mod `paleotest`) — sources auditées : paleotest @ 7f3c5fa
- Rôle : fossiles → ADN → œufs, seringues ou sacs embryonnaires → créatures préhistoriques. S'y ajoutent des plantes anciennes
  (cycas, prêles, métaséquoia) et des accessoires d'élevage.
- Dépendances : `default, walls, stairs, mobkit, mob_core` (toutes obligatoires, `mod.conf`).
- Objets utiles :
  - Fossiles (nœuds de minerai) :
    - `paleotest:fossil_block` — `nodes.lua:23`. Minerai dans `default:stone`, y ≤ 64 (`ores.lua:13-44`).
      Butin : 1 objet parmi `paleotest:fossil`, `paleotest:plant_fossil`, `bones:bones` (1/4 chacun), sinon `default:cobble`.
    - `paleotest:suspicious_permafrost` — `nodes.lua:42`, dans le pergélisol (`ores.lua:48-67`).
      Butin `paleotest:ancient_bones` (1/4).
  - Laboratoire :
    - `paleotest:fossil_analyzer` — `fossil_analyzer.lua:128`, craft `crafting.lua:84` (acier, cuivre, bronze).
    - `paleotest:dna_cultivator` — `dna_cultivator.lua:88`, craft `crafting.lua:75` (acier, verre, `bucket:bucket_water`, bronze).
  - Produits du labo : `paleotest:dna_<espèce>` (`craftitems.lua:143-236`, 19 espèces). Le cultivateur les change en
    `paleotest:egg_<dino>` (10), `paleotest:syringe_<mammifère>` (6) ou `paleotest:sac_<aquatique>` (3) (verified).
  - Plantes : `paleotest:metasequoia_sapling` (`nodes.lua:473`), `paleotest:metasequoia_tree` (`:414`),
    `paleotest:metasequoia_wood` (`:509`, craft `:553`), `paleotest:cycad_3` (`:189`), `paleotest:seeds_cycad` (`:61`).
  - Accessoires :
    - `paleotest:field_guide`, le guide de terrain — `craftitems.lua:23`, craft `crafting.lua:38` (`group:fossil`, `default:book`, `group:color_blue`).
    - `paleotest:whip`, le fouet — `craftitems.lua:12`, craft `crafting.lua:47` (`default:stick`, `farming:cotton`).
    - Mangeoires `paleotest:feeder_*` (verified), `paleotest:scratching_post` (`nodes.lua:569`), `paleotest:pursuit_ball` (`craftitems.lua:426`).
- Événements détectables :
  - Creuser un bloc fossile ou du pergélisol suspect → **F** (minerai généré). Le butin est aléatoire, mais l'événement porte
    sur le nœud creusé.
  - Fabriquer l'analyseur, le cultivateur, le guide, le fouet, les mangeoires, le poteau ou la balle → **F** (grille standard).
  - Poser l'analyseur, le cultivateur, une mangeoire → **F** : pas d'`on_place`, pose par défaut.
  - Analyser un fossile, cultiver l'ADN → **I** comme craft. Ce sont des recettes de machine à minuterie
    (`fossil_analyzer.lua:107-121`, `dna_cultivator.lua:67-82`).
  - Récupérer de l'ADN → **A** : enveloppe `core.override_item` de `on_metadata_inventory_take` de l'analyseur
    (`fossil_analyzer.lua:217`). Signature moteur `(pos, listname, index, stack, player)`. L'original est appelé d'abord.
    - Émettre si `listname == "output"` et que `stack` commence par `paleotest:dna_`.
    - Chance par fossile animal : 13 sur 64 (`fossil_analyzer.lua:6-17,40-50`).
    - Retrait autorisé seulement hors protection d'autrui (`:187-192`). Faux positif : prendre l'ADN analysé par un voisin dans une machine non protégée.
  - Planter un métaséquoia → **F**. `on_place` → `default.sapling_on_place`, qui exécute `registered_on_placenodes`
    (`minetest_game default/trees.lua:521`).
    - Le jeune plant vient uniquement du cultivateur : fossile végétal → analyseur (3 chances sur 16) → cultivateur.
    - Il pousse en 20-27 min (`nodes.lua:497`) en un arbre géant par schéma (`:467`).
  - Abattre le métaséquoia ou fabriquer ses planches → **F**. Le tronc vient de `place_schematic`, jamais d'une pose par un joueur.
  - Semer cycas ou prêles → **I** (`on_place` → `set_node`, `nodes.lua:82,247`). Creuser un cycas adulte `paleotest:cycad_3` → **F**
    (il pousse par `swap_node`, `:184`).
  - Poser un œuf → **A** : enveloppe `on_place` des objets `paleotest:egg_*` (`api/register.lua:351`, `add_entity`, aucun
    événement `place`). Émettre si l'original a consommé l'objet.
  - Faire éclore un œuf → **I**. L'œuf éclot en 100 s près d'un nœud à `light_source >= 12`, par exemple `default:torch`
    (`api/register.lua:10-19,397-413`). Aucun callback. Le bébé est « imprégné » par **tous** les joueurs à moins de 3 m,
    le dernier l'emporte (`:316-326`).
  - Apprivoiser → **I** directement : nourrir un petit (`api/api.lua:194-246`) ou imprégner (`:417-450`).
    L'état `owner` est lisible via rides.
  - Monter → **A** (rides) : triceratops, tyrannosaure, quetzalcoatlus, fouet en main, adulte (`self.child == false`).
    Il n'y a **aucun contrôle de propriétaire** (`mobs/triceratops.lua:232-233`) : un joueur peut monter le dino d'un autre.
- §2 bis :
  - (a) `mob_core.mount` → `set_attach` (`mob_core/mount.lua:84`). Le quetzalcoatlus ré-attache en vol (`api/hq_lq.lua:599`).
  - (b) Entités `paleotest:triceratops` (`mobs/triceratops.lua:135`), `paleotest:tyrannosaurus` (`mobs/tyrannosaurus.lua:145`),
    `paleotest:quetzalcoatlus` (`mobs/quetzalcoatlus.lua:154`).
  - Le carnotaure contient une logique de monture (`mobs/carnotaurus.lua:46`), mais aucun appel à `mob_core.mount` : il n'est **pas** montable.
  - (c) Parasite : un prédateur « accroché » s'attache à une **entité** cible (`api/hq_lq.lua:112`), jamais à un joueur.
- Mécanismes particuliers / limites :
  - **Aucune apparition naturelle** : pas de `register_spawn` dans le mod. Les créatures naissent seulement du laboratoire.
    Les œufs `paleotest:spawn_*` (`mob_core.register_spawn_egg`) sont créatifs. C'est favorable à un serveur pacifique.
  - Bug source : les recettes de cuisson sont inversées, cuit → cru (`crafting.lua:92-118`). La viande cuite est donc
    introuvable. La viande crue ne vient que de mobs tués : manger de la viande de dino → **I**.
  - `paleotest` ré-enregistre toutes les entités `mobkit`, les siennes et celles d'autres mods, pour gérer les seringues
    (`api/register.lua:35-94`, nom préfixé `:`).
  - Aucune capture d'animal dans paleotest : `mob_core.capture_mob` (`mob_core/api.lua:1201`) n'est jamais appelé.
    Le tutoriel « dinosaures/capture » de l'Académie (wiki) repose donc sur un autre mod, à identifier.
  - Clôture électrique `paleotest:electric_fence_wires` : 9 PV/s de dégâts (`nodes.lua:605`).
  - Pas de privilège requis pour aucune action.
- Réglages `settingtypes` :
  - `legacy_convert` est lu par `get_bool` sans défaut (`init.lua:120`). Les alias 1.x ne se chargent que si le réglage est explicitement à true.
  - `breeding` (défaut true) ; `block_breaking` (défaut false).

---

## Chapitre 22 — « Dragons et autres bestioles »

*Des dragons dorment dans les cavernes ! Découvre leurs secrets, leurs écailles et les objets qui permettent de vivre à leurs côtés.*
Serveur pacifique : aucune quête ne demande de tuer. Écailles, os, œufs, bestiaire, acier draconique et monture de dragon
exigent la mort d'un dragon, ou un dragon adulte apprivoisé, issu d'un œuf obtenu par combat. Ils sont donc écartés.
Le chapitre suit la piste des nids, la forge et la wyverne. **Tout dépend de la présence de nids ou cavernes sur la carte**
(réglage `nest_spawning`/`cavern_spawning`, voir draconis).

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch22.bone_pile` | « Un tas d'os bien suspect » | dig | `draconis:bone_pile_scorched`, `draconis:bone_pile_frozen` | F | — | aucun | `nodes.lua:228/240`. Généré autour des nids (`mapgen.lua:188,313`). Point d'entrée ; nid gardé, prudence |
| `ch22.scorched_stone` | « La roche a pris un coup de chaud » | dig | `draconis:stone_scorched` (ou `draconis:stone_frozen`) | F | — | aucun | level 3 : pioche mese ou diamant. Existe aussi là où un dragon a soufflé. Prérequis : `bone_pile` |
| `ch22.dragon_hoard` | « Le magot du dragon » | dig | `default:goldblock` (feu) ou `default:steelblock` (glace) | F | — | aucun | `mapgen.lua:186/311`. Tout bloc généré compte, même hors nid. Facultatif, à valider avec l'admin |
| `ch22.scorched_bricks` | « Maçon des cendres » | craft | `draconis:stone_bricks_scorched` | F | — | aucun | `craftitems.lua:1177` (4 pierres calcinées). Branche glace : `draconis:stone_bricks_frozen` (`:1169`) |
| `ch22.draconic_forge` | « La forge des dragons » | place | `draconis:draconic_forge_fire` (ou `draconis:draconic_forge_ice`) | F | — | aucun | Craft `craftitems.lua:1122/1113` (8 pierres + `default:furnace`) ; pose par défaut. Préférer `place` : le craft passe par un alias (`nodes.lua:1103`). La forge **ne fonctionne pas** sans dragon apprivoisé : quête décorative |
| `ch22.scorched_planks` | « Du bois qui sent le roussi » | craft | `draconis:wood_planks_scorched` | F | — | aucun | `craftitems.lua:1106`. La bûche (`draconis:log_scorched`) n'existe que là où un dragon a soufflé hors zone protégée. Facultatif |
| `ch22.wyvern_ride` | « Rodéo dans la canopée » | custom | entité `draconis:jungle_wyvern` | A | `rides:wyvern` — `rides.lua` lit `get_attach()` (attache `api/mount.lua:169` via `api/api.lua:2250`) | aucun | Wyverne sauvage : main vide + clic droit. Elle est rare (1/60000) et agressive. Branche indépendante des nids |
| `ch22.wyvern_tamed` | « Ma wyverne à moi » | custom | entité `draconis:jungle_wyvern` | A | `rides:wyvern_owner` — même lecture, plus `get_luaentity().owner == joueur` (`api/behaviors.lua:920`) | aucun | Viande (`group:food_meat`) en **slot 1** pendant le vol, +10 % par bouchée. Prérequis : `wyvern_ride` |

Arbre suggéré : `bone_pile` → `scorched_stone` → (`scorched_bricks` → `draconic_forge`) | `dragon_hoard` | `scorched_planks` ;
branche indépendante : `wyvern_ride` → `wyvern_tamed`. Bilan : **6 F, 2 A**.

Actions écartées (I) :
- Écailles, os, œufs, dragonbinder, bestiaire, outils et armures : ils exigent un dragon mort (`api/api.lua:1096-1127`).
- Éclosion, âge et monture de dragon : pas de callback ; le propriétaire de l'œuf est attribué au hasard du voisinage.
- Lingots d'acier draconique : forge à souffle.
- `/tamedragon` : privilège `draconis_admin`.

## Chapitre 23 — « Les mystères du passé »

*Fossiles, ADN et laboratoires : la science de Minerland ressuscite les créatures d'antan. À toi de jouer les paléontologues.*
Chaîne entièrement pacifique : creuser → analyser → cultiver → planter ou faire éclore → monter. Les machines ne sont pas
des crafts : leurs produits sont détectés par la **pose** de ce qu'elles donnent, ou par un adaptateur.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch23.fossil_dig` | « Coup de pioche au Jurassique » | dig | `paleotest:fossil_block` (ou `paleotest:suspicious_permafrost`) | F | — | aucun | `nodes.lua:23/42`. Plus fréquent en profondeur (`ores.lua:35-44`). Point d'entrée |
| `ch23.field_guide` | « Le carnet du paléontologue » | craft | `paleotest:field_guide` | F | — | aucun | `crafting.lua:38` : un fossile (`group:fossil`), `default:book`, colorant bleu. Prérequis : `fossil_dig` |
| `ch23.fossil_analyzer` | « Monter son labo » | place | `paleotest:fossil_analyzer` | F | — | aucun | Craft `crafting.lua:84` (cuivre, bronze, acier) ; pose par défaut |
| `ch23.dna_extracted` | « La double hélice » | custom | `paleotest:dna_*` (sortie de l'analyseur) | A | `paleotest:dna` — enveloppe `on_metadata_inventory_take` de `paleotest:fossil_analyzer` (`fossil_analyzer.lua:217`), liste `output` | aucun | 13 chances sur 64 par fossile animal. Faux positif : machine d'un voisin non protégée. Prérequis : `fossil_analyzer` |
| `ch23.dna_cultivator` | « L'incubateur à ADN » | place | `paleotest:dna_cultivator` | F | — | aucun | Craft `crafting.lua:75` (`bucket:bucket_water`, bronze). Pose par défaut |
| `ch23.living_fossil` | « Une forêt venue du passé » | place | `paleotest:metasequoia_sapling` | F | — | aucun | Événement émis par `default.sapling_on_place` (`trees.lua:521`). Fossile végétal → analyseur (3/16) → cultivateur. Arbre géant : prévoir un terrain dégagé (contrôle de protection `trees.lua:490`). Variante : craft `paleotest:metasequoia_wood` (`nodes.lua:553`) |
| `ch23.dino_egg` | « Un œuf bien au chaud » | custom | `paleotest:egg_*` | A | `paleotest:egg_placed` — enveloppe `on_place` (`api/register.lua:351`) ; émettre si l'original a consommé l'objet | aucun | L'éclosion (100 s près d'une torche) n'est **pas** détectable. Prérequis : `dna_cultivator` |
| `ch23.triceratops_ride` | « En selle sur un tricératops ! » | custom | entité `paleotest:triceratops` | A | `rides:triceratops` — `get_attach()` (attache `mob_core/mount.lua:84`) | aucun | Il faut `paleotest:whip` (craft F, `crafting.lua:47`) et un adulte (environ 13 min chargées, `mob_core/api.lua:1103-1141`). Pas de contrôle de propriétaire. Prérequis : `dino_egg` |

Arbre suggéré : `fossil_dig` → `field_guide` → `fossil_analyzer` → `dna_extracted` → `dna_cultivator` →
(`living_fossil` | `dino_egg` → `triceratops_ride`). Bilan : **5 F, 3 A**.
Variante plus F : remplacer `dna_extracted` par le craft du fouet `paleotest:whip`. On obtient 6 F, 2 A.

Actions écartées (I) :
- Analyse et culture : machines, pas d'`on_craft`.
- Éclosion, imprégnation, apprivoisement par la nourriture : aucun callback. `mob_core.set_owner` est global, on ne l'enveloppe pas.
- Semis de cycas ou prêles : `set_node` sans callback.
- Manger de la viande de dino : recettes de cuisson inversées, viande crue obtenue seulement par mise à mort.
- Capture : absente de paleotest.

## Table pour `integrations/rides.lua` (périmètre ch22-ch23)

| entité | famille proposée | attache (fichier:ligne) | remarque |
|---|---|---|---|
| `draconis:jungle_wyvern` | `wyvern` | `draconis/api/mount.lua:169` | sauvage ou apprivoisée ; propriétaire = `luaentity.owner` |
| `draconis:fire_dragon`, `draconis:ice_dragon` | `dragon` | `draconis/api/mount.lua:169` (cavalier), `:224` (passager) | réservé au propriétaire, âge ≥ 35 ; passager ≠ cavalier (`luaentity.rider`) |
| `paleotest:triceratops`, `paleotest:tyrannosaurus`, `paleotest:quetzalcoatlus` | `dinosaur` | `mob_core/mount.lua:84` | fouet en main, adulte |
| à exclure : `draconis:dragon_ice`, `draconis:mounted_player_visual` | — | `draconis/api/api.lua:621`, `api/mount.lua:96` | joueur gelé (parasite) ; visuel décoratif |

## Points à confirmer avec l'administratrice (bloquants)
1. Le ch22 dépend de la présence de nids ou de cavernes. `minetest.conf` contient-il `nest_spawning` ou `cavern_spawning` ?
   Sans ces lignes, **aucun nid n'est généré** (`mapgen.lua:9,11`). Si des dragons existent déjà sur la carte, où sont-ils ?
2. Que modifie `minerland_fix_draconis` (local, sans source) ? Apparition, œufs, recettes, dégâts ?
3. Le serveur distribue-t-il des œufs de dragon (événement, admin) ? Si oui, une quête « poser un œuf sur un nid »
   (`draconis:egg_*`, place F) deviendrait envisageable, hors tronc commun.
4. Quel mod porte le tutoriel « dinosaures/capture » de l'Académie ? Ce n'est pas paleotest.
5. Les versions installées de draconis et paleotest correspondent-elles aux commits audités ?

<!-- source : docs/audit/ch24_ch25.md -->
### Audit — Chapitre 24 « Les grands bâtisseurs » et Chapitre 25 « Monsieur ou Madame le Maire »

Agent `mod-researcher`, 18/11/2026. Sources en lecture seule dans `.audit_src/` (branches principales clonées en
novembre 2026) : **les versions installées sur le serveur peuvent différer**, toute référence est à revérifier à
l'exécution (`core.registered_items`). Identifiants non littéraux : `docs/audit/verified_ch24_ch25.txt`.
Sémantique des événements : `docs/audit/README.md` §2. Clé `place` = `newnode.name` (`core/events.lua:89`).

## 0. Mods sans source auditable : « non audité », aucun identifiant cité

| Dossier serveur | Situation |
|---|---|
| `pkarcs`, `c_doors`, `artdeco`, `church`, `symmetool`, `terraform` | absents de `.audit_src/` : non audités |
| `mailbox`, `industrial_signs`, `letters`, `billboard`, `led_marquee` | absents de `.audit_src/` : non audités (pas de quête « boîte aux lettres ») |
| `ts_workshop` | **dépendance obligatoire de `streets`** (`streets/mod.conf`), sans source : le nom exact du nœud « atelier » et sa logique de production ne sont pas vérifiables |
| `bakedclay` | matériau optionnel de `facade` (`facade/materials.lua:12-35`), sans source : on ne cite pas les variantes `facade:<couleur>_*` |
| `minerland_fix_darkage` | mod local sans source : il peut modifier `darkage` (recettes, génération). À confirmer par l'administratrice |

`symmetool` et `terraform` sont des outils de construction : même avec leur source, ils produiraient des `set_node` en masse,
et donc aucun événement `place` fiable. Ils sont à exclure de toute façon.

## 1. Mods du chapitre 24

### scaffolding (mod `scaffolding`) — sources auditées : scaffolding @ dbbbc3f (2024-08-10)
- **Variante** : le clone est celui d'**Infinatum** (bitbucket.org/Infinatum/scaffolding, `tools/audit_sources.txt:73`),
  avec `mod.conf` `name = scaffolding`. Il existe d'autres mods homonymes. **Le dossier serveur n'est pas identifié** :
  il faut le confirmer, par exemple avec `tools/audit_mods.py` sur le serveur ou en vérifiant que
  `scaffolding:scaffolding_wrench` figure dans `registered_items`.
- Dépendances : `default` (`depends.txt`). Aucun réglage `settingtypes`.
- Objets utiles :
  - `scaffolding:scaffolding` — échafaudage en bois, grimpable — `init.lua:66`. Recettes : 6 `group:wood` + 2 bâtons → 12
    (`init.lua:429`), ou 2 bois + 1 bâton → 4 (`:438`).
  - `scaffolding:iron_scaffolding` — échafaudage en fer — `init.lua:245`. Recettes : 6 lingots d'acier + 2 bâtons → 12
    (`:486`), ou 2 lingots d'acier + 1 bâton → 4 (`:495`).
  - `scaffolding:platform` (`:171`) et `scaffolding:iron_platform` (`:351`) — plateformes. Recettes `:459-471` et `:515-527`.
  - `scaffolding:scaffolding_wrench` — clé de renfort, 4 lingots d'acier — `:61`, recette `:544`.
  - Variantes `scaffolding:reinforced_*` (`:122,210,302,390`), sans recette.
- Événements détectables :
  - **craft** de l'échafaudage, des plateformes et de la clé → **F** (grille standard).
  - **pose** du premier bloc → **F** (pas d'`on_place`). En revanche, un clic droit sur un échafaudage avec un échafaudage en
    main appelle `on_rightclick` → `buildScaffolding`, qui fait `set_node` (`init.lua:49,87-103`). Les plateformes passent
    par `buildPlatform` (`:11`). Ces poses-là **ne déclenchent pas** `place` : un compteur de pose sous-compte toujours.
    Il vaut mieux viser le **craft**.
  - **renforcer avec la clé** : `on_punch` + `set_node` (`:79-86`) → **I**.
- **Duplication (piège)** : chaque coup de clé sur un échafaudage (bois ou fer, renforcé ou non) ajoute un
  `scaffolding:scaffolding` **gratuit** dans l'inventaire (`init.lua:84,142,275,322`), et la bascule peut être répétée
  sans fin. Combinée à la recette « 2 échafaudages → `default:wood` » (`:475`), elle permet de fabriquer du bois et des
  plateformes à l'infini. Conséquences :
  - aucune quête de craft comptée sur `scaffolding:platform` ;
  - garder des compteurs faibles sur le craft de planches (`ch01.planks`, `count = 4`, reste acceptable).
  - L'acier n'est pas dupliqué : le recyclage du fer exige `iron_scaffolding`.
- Autre point : l'API dépréciée `minetest.env:set_node` (`:83,141,187…`) peut provoquer des avertissements. À vérifier
  en test d'intégration. Aucun privilège : `creative` n'est pas utilisé.

### facade (mod `facade`) — sources auditées : facade @ d200201 (2026-06-14)
- Dépendances : `default` ; optionnelles `mychisel`, `columnia`, toutes deux absentes du serveur.
- **Machine, pas de craft** : les formes décoratives sortent **uniquement** du `facade:shaper` (« Shaper Machine »,
  `shaper.lua:295`). Il n'existe aucune recette de grille pour les formes. Le joueur dépose 1 bloc dans `src`, clique
  sur une forme (`on_receive_fields` → `form_handler`, `:220-264`), puis reprend le résultat dans `dst`.
- Recette de la machine (`shaper.lua:363-371`) : 1 `default:diamond` + 2 `default:steelblock` + 2 `default:steel_ingot`.
  Le coût est élevé : environ 20 lingots d'acier et un diamant.
- Nommage des formes : `facade:<sous-nom>_<forme>` (`shapes.lua:11,45,83,136,175,220,248,276,310,352,407,441,479,534`).
  - Formes : `bannerstone`, `bannerstone_corner`, `centerstone`, `column`, `column_corner`, `corbel`, `corbel_corner`,
    `corbel_corner_inner`, `carved_stone_a`, `carved_stone_a_corner`, `rgspro`, `rgspro_inner_corner`,
    `rgspro_outer_corner`, `corner_bricks` (sauf argile, `:521-524`).
  - Formes `columnia_*` (`:599-725`) : présentes car `columnia` est absent.
  - Matériaux (`materials.lua`) : `clay`, `stone`, `desert_stone`, `sandstone`, `desert_sandstone`, `silver_sandstone`
    (`:3-8`). Si darkage est présent : `basalt`, `chalk`, `gneiss`, `marble`, `ors`, `schist`, `serpentine`, `shale`,
    `slate` (`:38-48`). Si nether est présent : `rack` (`:51-53`). Exemples : `facade:stone_column`, `facade:marble_column`.
- Événements détectables :
  - **pose** d'une forme → **F**. Les formes simples n'ont pas d'`on_place`. Les `columnia_*` passent par
    `minetest.rotate_node` (`shapes.lua:608,632`) ou par `columnia_rotate` → `minetest.item_place` (`:594`).
  - craft / pose de la machine → **F** (pas d'`on_place`, `after_place_node` ne fait qu'enregistrer le propriétaire).
  - **tailler une forme** → **A**, par enveloppe d'un seul nœud. `core.override_item("facade:shaper",
    {on_metadata_inventory_take = …})` appelle d'abord l'original (`update_formspec_take`, `shaper.lua:152-171`), puis
    émet `facade:shape` si `listname == "dst"`, si l'objet commence par `facade:` et si le joueur est réel.
  - **Faux positif filtré** : un bloc brut déplacé de `src` vers `dst` (le déplacement est autorisé, `:209-217`) est
    écarté par le filtre sur le préfixe. On ne peut rien déposer dans `dst` (`:175-192`). C'est la même technique que la
    scie moreblocks (`docs/audit/ch07_ch08.md`, section moreblocks).
- Limites :
  - bug : `check_removability` lit le propriétaire avec `meta:set_string("owner")`, qui renvoie `nil` (`shaper.lua:269`).
    N'importe qui peut donc retirer une machine vide hors zone protégée ;
  - aucun privilège.

### mydoors (modpack, 12 mods) — sources auditées : mydoors @ d007c57 (2025-03-31)
Noms `mod.conf` : `my_castle_doors`, `my_cottage_doors`, `my_default_doors`, `my_door_wood`, `my_fancy_doors`,
`my_future_doors`, `my_garage_door`, `my_hidden_doors`, `my_misc_doors`, `my_old_doors`, `my_saloon_doors`,
`my_sliding_doors`. Le nom `mydoors` (dossier, `modpack.conf`) **n'est pas un nom de mod**.
- Dépendances : la plupart dépendent de `default, my_door_wood, doors` ; `my_misc_doors` ajoute `wool` ;
  `my_sliding_doors` dépend de `default, flowers` ; `my_garage_door` a pour optionnelle `basic_materials`.
- **Bois teinté** : `my_door_wood:wood_<couleur>`, couleurs `red, grey, dark_grey, brown, white, yellow, black`
  (`my_door_wood/init.lua:1-9,38,58`). Recette : 1 `default:wood` + 1 `dye:<couleur>` (`:48-55`).
  - C'est l'ingrédient de base de presque toutes les portes. Avec moreblocks, des formes Stairs+ sont ajoutées (`:14-25`).
- **Portes passant par l'API MTG** (`doors.register_door` → `doors.register`, `minetest_game/mods/doors/init.lua:549,219`) :
  - château : `my_castle_doors:door1..13` (+ `_locked`), `unlocked.lua:18`, `locked.lua:18` ;
  - cottage : `my_cottage_doors:door1..2` ;
  - métaux et bois MTG : `my_default_doors:door1..5,7..10` (bronze, cuivre, or, diamant, mese, puis bois MTG),
    recette = matériau + `doors:door_steel` + matériau (`unlocked.lua:14,23-30`) ;
  - fantaisie : `my_fancy_doors:door1..8` ;
  - dérobées : `my_hidden_doors:hidden_door<cobble|stone|wood|stone_brick|brick|desert_cobble|furnace|chest|bookshelf>`
    (`init.lua:15`), plus `my_hidden_doors:hidden_door_grey` (`:29`, 6 bois gris foncé, recette `:113`) ;
  - anciennes : `my_old_doors:door1..4` ;
  - divers : `my_misc_doors:door1..5`.
  - **Pose → F** : l'`on_place` de l'objet pose `<porte>_a`/`_b` par `set_node` (`doors/init.lua:323-327`), puis appelle
    **lui-même** `minetest.registered_on_placenodes` (`on_place_node`, `:193-215,344`) avec
    `newnode = minetest.get_node(pos)`. **La clé de pose est donc `<porte>_a` ou `<porte>_b`**, et non le nom de l'objet,
    comme `doors:door_*_a|_b` dans `docs/audit/ch01_ch05.md`. Le **craft** porte sur l'objet `<porte>` → **F**.
- **Portes à pose maison** :
  - `item_place` → **F** :
    - `my_saloon_doors:door1a_<couleur>` (7 couleurs, `my_saloon_doors/init.lua:3-11,14,44-68`), recette 5 bois teinté (`:119`) ;
    - `my_future_doors:door1a_<white|red|black>` (`framed.lua:2,5,41-64`), recette bois teinté + laine (`:202`).
    - La moitié haute est posée par `set_node` dans `after_place_node` : il ne faut viser que la moitié `…1a_…`.
  - `set_node` sans callback → **pose I** (le craft reste **F**) :
    - grille `my_misc_doors:door2a` (`bars.lua:38-80`) ;
    - portes coulissantes futuristes `my_future_doors:door2a…9a` (`sliding.lua:3-28,64-68`) ;
    - shoji `my_sliding_doors:*` (`jdoors1.lua:41-45,315,425`) ;
    - porte de garage `my_garage_door:garage_door` (`init.lua:39-73`, recette seulement si `basic_materials`, `:203`).
- Privilèges : aucun. `creative` sert seulement à ne pas consommer l'objet (`bars.lua:74`, etc.). Portes `_locked` :
  `protected = true`, seul le poseur peut les ouvrir.
- Matériaux rares :
  - `my_default_doors:door4` demande 2 `default:diamond` + une porte d'acier ; `door5` demande 2 cristaux de mese ;
  - les portes coulissantes futuristes demandent 2 blocs d'acier (`sliding.lua:5-28`) ;
  - les portes de château demandent 1 à 4 lingots d'acier.

### darkage (mod `darkage`) — sources auditées : darkage @ 494f81c (2025-11-22)
- Dépendances : `default, farming` ; optionnelles `moreblocks, stairs, unifieddyes`. Le mod local `minerland_fix_darkage`
  (non audité) peut changer ce qui suit.
- Génération : strates `register_on_generated` (`mapgen.lua:97-151`) pour `mud`, `silt`, `shale`, `slate`, `schist`,
  `basalt`, `marble`, `serpentine`, `gneiss`, et minerais en nappes `chalk`, `tuff`, `rhyolitic_tuff`, `ors`
  (`mapgen.lua:172-240`). Les zones générées **avant** l'ajout de darkage n'en contiennent pas.
- Objets utiles :
  - `darkage:marble` — marbre naturel — `nodes.lua:178`.
  - `darkage:marble_tile` — dallage, 4 marbres → 2 — `nodes.lua:186`, recette `init.lua:182`.
  - `darkage:chalk` — craie — `nodes.lua:69`, donne 2 `darkage:chalk_powder` (`:73`).
  - `darkage:chalked_bricks` — 4 pierres + 5 poudres → 4 — `nodes.lua:454`, recette `:463`.
  - `darkage:cobble_with_plaster` (`nodes.lua:78`, recette `init.lua:94`).
  - `darkage:stone_brick` — 1 `default:stone_block` — `nodes.lua:323`, recette `init.lua:274`.
  - `darkage:straw_bale` — 4 `farming:straw` — `nodes.lua:331`, recette `init.lua:282`.
  - `darkage:adobe` (`nodes.lua:22`, recette `init.lua:52`).
  - `darkage:iron_stick` (1 acier → 4, `init.lua:290`), `darkage:chain`, `darkage:iron_bars`, `darkage:lamp`
    (bâtons + torche, `furniture.lua:238`), `darkage:wood_frame`, `darkage:box`.
  - `darkage:reinforced_wood` (`building.lua:31-38,161`).
  - murets `darkage:<pierre>_wall` (`walls.lua:13,18,43-49`).
- **`darkage:rosace` n'existe pas** : sa définition est en commentaire (`furniture.lua:109`), l'index la listait à tort (corrigé : `audit_mods.py` ignore désormais les commentaires Lua).
- Événements détectables :
  - pose → **F** (aucun `on_place` dans le mod) ;
  - craft des briques, dalles et ferronneries → **F** ;
  - minage du marbre ou de la craie naturels → **F**.
  - Pièges : basalte, gneiss, ors, ardoise… existent aussi en **cuisson** (`init.lua:63,137,…`) → pas de `craft`.
    Les briques de tuf se changent seules en `old_tuff_bricks` près de l'eau (ABM `nodes.lua:376-385`).
- Réglages : aucun `settingtypes`. Stairs+ (moreblocks) est enregistré pour les pierres (`stairs.lua`) si moreblocks est présent.

### factory_bridges (mod `factory_bridges`) — déjà audité : `docs/audit/ch16_ch17.md` (§ factory_bridges @ 51fc786)
`factory_bridges:b00` (dalle d'acier) et `factory_bridges:a01` (garde-corps) : craft et pose **F**. Ils servent de
décor de chantier.

### moreblocks, xdecor — déjà audités : `docs/audit/ch07_ch08.md`
Craft et pose de `moreblocks:circular_saw` et `xdecor:workbench` : **F**. **La découpe à la scie ou à l'établi n'est pas
un craft** : il faut l'adaptateur d'enveloppe décrit dans ce rapport, sinon le classement est **I**.

## 2. Mods du chapitre 25

### streets (mod `streets`) — sources auditées : streets @ fd02b1a (2025-11-12)
- Dépendances : `default, stairs, ts_workshop, dye`. `ts_workshop` est **sans source** (§0) ; optionnelles `moreblocks`,
  `digilines`, `concrete`… Réglage : `streets.only_basic_stairsplus` (défaut `true`, `settingtypes.txt`, `global.lua:24-27`).
  Il limite seulement les variantes Stairs+ des marquages.
- **Asphalte** : `streets:asphalt` est enregistré par l'API (`api_register_all.lua:9`, données
  `streets_roadsurface/init.lua:8-21`).
  - Il s'obtient **uniquement par cuisson** de `default:gravel` (four) → **craft I**, **pose F**.
  - `streets:asphalt_red` / `streets:asphalt_blue` (`roadsurface:23-63`) et `streets:sidewalk` (`:65`, recette `:81`) :
    recettes **shapeless** de grille (asphalte + colorant) → **craft F**, **pose F**.
- **Atelier** `streets:workshop` : enregistré par `ts_workshop.register_workshop("streets","workshop",…)`
  (`streets_workshop/init.lua:642`), avec l'alias `streets:asphalt_workshop` (`:694`). Sa recette `:685-692`
  (8 asphaltes + 1 fragment de mese) se fait en grille → **craft F, si le nom est confirmé à l'exécution**.
  - **Tout ce que produit l'atelier n'est pas un craft** : panneaux routiers `streets:sign_*`, outils de marquage
    `streets:tool_*`, asphalte coloré. Base : `default:sign_wall_steel`, lingot d'acier ou asphalte, plus des colorants
    stockés (`:485-583`). La logique de production vit dans `ts_workshop`, non audité → **I**.
- **Panneaux routiers** `streets:sign_<nom>` (`api_register_all.lua:163`, ex. `streets:sign_shop`, `sign_mine`,
  `streets_signs/init.lua:139-183`) :
  - aucune recette de grille → **craft I** ;
  - **pose F** : pas d'`on_place`. `after_place_node` peut remplacer le nœud par `_polemount`/`_center` via `set_node`
    (`:105-160`), mais le callback reçoit le nom posé.
- **Marquages au sol** : l'outil `streets:tool_*` pose `streets:mark_*` par `set_node`, puis fusionne avec l'asphalte
  (`api_register_all.lua:195-245`, `set_node` `:214`) → **I**. La recette shapeless « asphalte + `streets:mark_*` » (`:296-301`) est
  inutilisable en survie : le nœud de marquage ne lâche rien (`drop = ""`, `:268`).
- **Pose F, craft F** (grille standard, pas d'`on_place` sauf `rotate_node`) :
  - `streets:bigpole` (2 aciers → 3, `streets_poles/init.lua:7,48`, `on_place = rotate_node`) ;
  - lampadaires `streets:light_vertical_off` / `streets:light_horizontal_off` / `streets:light_hanging_off`
    (`streets_light/init.lua:224,271,318`, recettes `:364-386`, avec `default:meselamp`) ;
  - `streets:delineator` (`streets_accessories/init.lua:7,32`) ;
  - `streets:guardrail` (`:165,202`) ;
  - `streets:fence_chainlink` (`:40,147`) ;
  - `streets:roadwork_pylon` (`streets_roadwork/init.lua:261,280`) ;
  - `streets:roadwork_traffic_barrier` (`:10,51`) ;
  - `streets:concrete` (`streets_concrete/init.lua:12,19`, alias vers `technic:concrete` si `concrete` est présent, `:8-10`) ;
  - bouches d'égout `streets:asphalt_manhole` (8 asphaltes + 1 acier → 4, `streets_installations/init.lua:8,70`) ;
  - bornes `streets:bollard_steel_manual_up` (`streets_bollards/init.lua:119,167`).
- **Feux tricolores** : chargés **seulement si `digilines` est présent** (`init.lua:44-48`), ce qui est le cas sur le
  serveur. `streets:trafficlight_top_off` (+ `_left_off`, `_right_off`) est enregistré dans une boucle
  (`streets_trafficlight/init.lua:1101-1102`). Recette : 6 aciers + colorants rouge, jaune et vert (`:1326-1332`).
  `streets:pedlight_top_off` (`:954,1353`). Pose et craft **F**. Le fonctionnement demande un contrôleur digilines :
  il ne doit pas faire l'objet d'une quête.
- Privilèges : seulement `protection_bypass` pour agir dans la zone d'autrui. Rien n'est exigé du joueur ordinaire.

### street_signs (mod `street_signs`) — sources auditées : street_signs @ 94eb27d (2024-06-09)
- Dépendances : `signs_lib` ; optionnelles `default, screwdriver, infrastructure`.
- Les panneaux sont enregistrés par `signs_lib.register_sign`, qui ne définit **aucun `on_place`**
  (`signs_lib/api.lua:1017-1076`) → **pose F**.
- Objets avec recette de grille → **craft F** :
  - `street_signs:sign_basic` (plaque de nom de rue, `signs_class_d.lua:39`). Recette : `default:sign_wall_steel` +
    2 `dye:green` + `dye:white` + 2 aciers (`crafting.lua:3-19`) ;
  - `street_signs:sign_basic_top_only` (`:76`, recette `crafting.lua:21-36`) ;
  - `street_signs:sign_highway_<small|medium|large>_<green|blue|yellow|orange>` (boucle `signs_misc_generic.lua:122-135`,
    recettes `crafting.lua:46-86`).
- **Sans recette** : stop, céder le passage, limitations de vitesse et autres classes R/W/M/OM (aucun `register_craft`
  dans `signs_class_*.lua`) → créatif seulement, **à ne pas viser**. Les recettes de `crafting.lua:88-135` utilisent
  `signs:sign_wall_<couleur>` (mod `basic_signs`, absent du serveur) : elles sont inertes.
- Écrire le nom de la rue : `on_receive_fields` de signs_lib → contenu non contrôlable → **I**.

### signs_lib — déjà audité : `docs/audit/ch07_ch08.md`
`default:sign_wall_wood` / `default:sign_wall_steel` (re-enregistrés `signs_lib/standard_signs.lua:6,24` ; recette du
panneau d'acier `minetest_game/mods/default/crafting.lua:59-66`). Pose **F**, texte **I**.

### protector et areas — déjà audités : `docs/audit/ch01_ch05.md`
- `protector:protect` / `protector:protect2` : la pose est **F** (`check_overlap` → `core.item_place`). C'est la façon
  la plus simple de « tout protéger ».
- `areas` : `/area_pos1`, `/area_pos2` puis `/protect` sont des commandes, sans événement moteur. Il existe pourtant une
  **API publique** `areas:registerOnAdd(func(id, area))` (`areas/api.lua:59`, `api.md:9`), appelée par `areas:add`
  (`internal.lua:111-123`) → **A conditionnel**.
  - Condition : `/protect` demande le privilège `areas.self_protection_privilege` (défaut `interact`) **et**
    `areas.self_protection = true`. Ce réglage vaut `false` par défaut (`settingtypes.txt:22-25`,
    `internal.lua:265-272`). D'après `ch01_ch05.md`, il faut un privilège accordé par l'administratrice.
  - **Tant que le réglage du serveur n'est pas confirmé : I.**
  - Faux positifs : `/add_owner` crée une sous-zone pour **un autre** joueur (`chatcommands.lua:106`, `parent ≠ nil`),
    à exclure avec `area.parent == nil`. `/set_owner` est réservé à l'administration (`:39,61`).

### Commerces — déjà audités : `docs/audit/ch06_ch09.md` (et non `ch10.md`)
- `smartshop:shop` : pose **F**. Achat : **A** via `smartshop.api.register_on_purchase` (`api/purchase_mechanics.lua:23`),
  en excluant le propriétaire et les articles gratuits.
- `currency:shop` et `atm:atm` : craft et pose **F** ; l'échange en boutique `currency` est **I**.

### minerland_quests (ce mod) — `minerland_quests/ui/items.lua`
- `minerland_quests:city_charter` (`items.lua:53`) : nœud `signlike` mural, `stack_max = 1`, sans `on_place`.
  `after_place_node` enregistre seulement le signataire (`:68-75`).
  - **craft F** : 7 `default:paper` + `default:gold_ingot` + `minerland_quests:book`, le livre étant rendu
    (`:79-87`) ;
  - **pose F**.
  - Un joueur peut recevoir une charte d'un autre. Il faut donc mettre la quête de craft **en prérequis** de la quête de
    pose.

## 3. Chapitre 24 — « Les grands bâtisseurs »

Les gros chantiers commencent par l'échafaudage. Viennent ensuite la pierre noble (marbre darkage), le bois teinté et
les portes ouvragées, puis la machine à façonner les façades. Tout se fait à petite échelle : aucune quête ne demande
une construction géante. Il y a deux branches indépendantes après l'échafaudage : la pierre (2 → 3 → 7 → 8) et les
portes (4 → 5, 4 → 6).

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch24.scaffolding` | « Plus haut, toujours plus haut » | craft ×4 | `scaffolding:scaffolding` | F | — | — | Viser le craft : la pose sur échafaudage passe par `set_node`. Variante serveur à confirmer |
| `ch24.marble_quarry` | « Carrière de marbre » | dig ×10 | `darkage:marble` | F | — | — | Strates naturelles, seulement dans les zones générées avec darkage ; les blocs posés ne comptent pas |
| `ch24.marble_tiles` | « Le dallage du palais » | craft ×4 | `darkage:marble_tile` | F | — | — | Prérequis : `marble_quarry`. 4 marbres → 2 |
| `ch24.stained_wood` | « Une touche de teinture » | craft ×3 | `my_door_wood:wood_red`, `_grey`, `_dark_grey`, `_brown`, `_white`, `_yellow`, `_black` | F | — | — | 1 bois + 1 colorant ; base des portes |
| `ch24.castle_gate` | « Une porte digne d'un château » | place ×1 | `my_castle_doors:door1_a` … `door13_a` et `…_b` (+ `door<N>_locked_a/_b`) | F | — | — | Pose MTG : `registered_on_placenodes` appelé par `doors` ; clé `_a`/`_b`. Acier + bois teinté |
| `ch24.secret_passage` | « Le passage secret de la bibliothèque » | craft ×1 | `my_hidden_doors:hidden_doorbookshelf` | F | — | — | Il faut d'abord `my_hidden_doors:hidden_door_grey` (6 bois gris foncé) + 1 `default:bookshelf` |
| `ch24.shaper` | « L'atelier du tailleur de pierre » | craft ×1 | `facade:shaper` | F | — | — | Coûteux : 1 diamant + 2 blocs d'acier + 2 lingots. Machine, les formes ne sont pas des crafts |
| `ch24.colonnade` | « Une colonnade pour la grand-place » | place ×4 | `facade:stone_column`, `facade:marble_column`, `facade:sandstone_column`, `facade:stone_columnia_mid`, `facade:marble_columnia_mid` | F | (option A : `facade:shape`, enveloppe `on_metadata_inventory_take` de `facade:shaper`, liste `dst`, préfixe `facade:`) | — | Prérequis : `shaper`. Les formes n'existent qu'en sortie de machine |

Écartées (I) :
- tour d'échafaudage montée au clic droit, renfort à la clé (`set_node`) ;
- portes coulissantes, grille et garage (pose par `set_node` ; seul leur craft est F) ;
- arches `pkarcs`, portes `c_doors`, décor `artdeco` / `church`, outils `symmetool` / `terraform` (non audités) ;
- découpe à la scie ou à l'établi sans adaptateur.
- Alternatives F : pose de `factory_bridges:b00` (passerelle de chantier) ; craft de `darkage:chalked_bricks`
  (façade à la craie).

## 4. Chapitre 25 — « Monsieur ou Madame le Maire »

La fondation suit des gestes simples : sceller la charte, protéger le terrain, tracer une rue, nommer la rue,
l'éclairer, puis ouvrir une boutique. « La Reine valide » n'est qu'une **couleur roleplay** : aucune quête ne dépend
d'une validation par l'administration (CLAUDE.md §6). Les textes rappellent de ne rien bâtir près du spawn, de rester
modeste et de protéger son terrain.

| slug | idée de titre | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque |
|---|---|---|---|---|---|---|---|
| `ch25.charter_write` | « Rédiger la charte » | craft ×1 | `minerland_quests:city_charter` | F | — | — | 7 papiers + 1 lingot d'or + le livre (rendu) |
| `ch25.charter_seal` | « Sceller la charte » | place ×1 | `minerland_quests:city_charter` | F | — | — | Prérequis : `charter_write`, pour ne pas valider une charte offerte |
| `ch25.protect_town` | « Borner la commune » | place ×1 | `protector:protect`, `protector:protect2` | F | (option A : `areas:new_area` via `areas:registerOnAdd`, avec `parent == nil` et propriétaire = joueur réel) | — (l'option areas exige `areas.self_protection` + `interact`, à confirmer) | « Tout protéger » : règle du serveur |
| `ch25.first_road` | « La grand-rue » | place ×16 | `streets:asphalt` | F | — | — | Asphalte = gravier cuit au four (craft I) ; petit compteur, pas de méga-route |
| `ch25.sidewalk` | « Des trottoirs pour les piétons » | craft ×4 | `streets:sidewalk` | F | — | — | Shapeless asphalte + `dye:white` ; aussi faisable à l'atelier (non compté) |
| `ch25.street_name` | « Baptiser la rue » | craft ×1 puis place ×1 | `street_signs:sign_basic` | F | — | — | Panneau d'acier + colorants vert et blanc + 2 aciers ; le texte n'est pas contrôlé |
| `ch25.street_lights` | « Que la lumière soit (sur la place) » | place ×3 | `streets:light_vertical_off`, `streets:light_horizontal_off`, `streets:light_hanging_off` | F | — | — | Recette avec `default:meselamp` (mese) |
| `ch25.market` | « Le premier commerce » | place ×1 (+ option custom) | `smartshop:shop`, `currency:shop` | F | (option A : `smartshop:sale`, émis pour le propriétaire par `register_on_purchase`, acheteur ≠ propriétaire) | — | `docs/audit/ch06_ch09.md` ; comptes complices possibles pour l'option A |

Branches et alternatives F :
- `streets:trafficlight_top_off` (feu, si digilines chargé) ;
- `streets:asphalt_manhole` (bouche d'égout) ;
- `streets:bigpole` + `street_signs:sign_highway_small_green` (panneau directionnel) ;
- `default:sign_wall_wood` (signs_lib) pour une enseigne ;
- `atm:atm` (distributeur, F).

Écartées (I) :
- panneaux routiers et marquages produits à l'atelier `streets` (`ts_workshop` non audité, marquage par `set_node`) ;
- écrire sur un panneau ;
- `/protect` tant que `areas.self_protection` n'est pas confirmé ;
- boîte aux lettres (`mailbox` sans source) ;
- `industrial_signs`, `letters`, `billboard`, `led_marquee` (sans source) ;
- échange en boutique `currency` ;
- toute quête de taille de ville, de population ou de coordonnées (interdit).

## 5. Points à confirmer par l'utilisatrice ou l'administratrice
1. Variante réelle de `scaffolding` sur le serveur. Le clone Infinatum contient une **duplication** par la clé.
2. `minerland_fix_darkage` : que modifie-t-il ? Recettes du marbre ou des briques ?
3. `areas.self_protection` est-il actif ? Avec quel privilège ? Sinon, `protector` seul.
4. Le nœud d'atelier `streets:workshop` existe-t-il bien ? Il dépend de `ts_workshop`, sans source : à vérifier dans
   `core.registered_items`.
5. Le brief renvoie à `ch10.md` pour smartshop et atm, mais ils sont audités dans `docs/audit/ch06_ch09.md`.

