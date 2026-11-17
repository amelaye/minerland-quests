# Audit des mods de Minerland

> Fichier **généré** par `python3 tools/gen_mod_audit.py`. Sources : `docs/audit/`. Ne pas éditer à la main.

## 1. Méthode

- Liste des mods du serveur : relevé du dossier `/home/minetest/luanti5_15_1/mods` fourni par l'administration (17/11/2026) — `docs/audit/server_mods.txt`. La page « mods » du wiki est obsolète.
- Le serveur n'est pas accessible depuis le poste de développement : les sources publiques des mods ont été clonées en lecture seule (`.audit_src/`, `make fetch-sources`). **Les versions installées peuvent différer** : tout identifiant est aussi revérifié à l'exécution (une quête dont l'objet n'existe pas devient « Indisponible »). Sur le serveur : `python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods --index index.json` puis `python3 tools/validate_quests.py --index index.json`.
- Présence d'un dossier ≠ mod activé dans `world.mt` : chaque quête déclare ses mods requis.
- Index : 286 mods, 3141 objets littéraux, 731 alias ; 58 identifiants dynamiques vérifiés à la main (`docs/audit/verified_*.txt`).
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

