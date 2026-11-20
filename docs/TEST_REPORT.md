# Rapport de tests — minerland_quests 1.0.0

Rapport du 20/11/2026. Il dit ce qui a été réellement exécuté, avec quel résultat, et ce qui reste à vérifier en jeu.
Aucun monde, aucune sauvegarde, aucune configuration existante ni le serveur de production n'ont été touchés : tous les
essais ont eu lieu sur le poste de développement, dans des dossiers jetables (`tests/_tmp/`).

## 1. Environnement

- Poste de développement : macOS 14.8, LuaJIT 2.0.5, Python 3.14.
- Moteur : Luanti 5.15.1 officiel (archive macOS x86_64, somme SHA-256 vérifiée), lancé en serveur sans client sur un
  monde jetable, avec Minetest Game.
- Mods tiers : sources publiques des mods du serveur (`tools/audit_sources.txt`, clonées dans `.audit_src/`). Les
  versions installées sur le serveur peuvent différer ; le mod revérifie chaque identifiant à son démarrage.

## 2. Résumé

| Contrôle | Résultat |
|---|---|
| `make check` : syntaxe, traductions, textures, validation des quêtes, tests simulés | **réussi** : traductions 749/749, textures 56/56, validateur sans erreur ni avertissement, 130 tests simulés réussis |
| Test réel, Minetest Game seul | **réussi** : 0 échec sur deux démarrages |
| Test réel avec les mods du serveur (319 mods chargés) | **réussi** : 193 quêtes jouables sur 193, 9 intégrations branchées, aucun avertissement du mod |
| Actions d'un vrai joueur, rendu à l'écran, plusieurs joueurs connectés | **non exécutés** (pas de client) : à vérifier en jeu, liste au §6 |

## 3. Tests simulés (130)

Le vrai mod est chargé dans une imitation de l'API Luanti (`tests/mock_core.lua`) ; les actions passent par les mêmes
fonctions que dans le jeu. Ces tests prouvent la logique du mod, pas le comportement du moteur.

| Fichier | Tests | Couvre |
|---|---|---|
| `test_engine.lua` | 14 | définitions, prérequis simples, multiples et parallèles, déblocage, compteurs, validation unique, cycles, quête ou objet absent |
| `test_rewards.lua` | 12 | attribution unique, inventaire plein, file d'attente, reconnexion, redémarrage, arrêt brutal, objet disparu |
| `test_events.lua` | 13 | miner, fabriquer, poser, récolter, manger ; objet reçu d'un autre joueur, bloc posé puis recreusé, faux joueur, créatif |
| `test_storage.lua` | 12 | persistance, migration, alias, format plus récent, données illisibles, catalogue qui évolue, mod absent puis revenu |
| `test_ui.lua` | 18 | ouverture, navigation, champs de formulaire forgés, coches, prérequis, quête indisponible, grand arbre, échappement |
| `test_admin.lua` | 10 | commandes joueur, privilège dédié, commandes de test bloquées en production, journal, aucun privilège accordé |
| `test_multiplayer.lua` | 9 | joueurs simultanés, validation au même instant, notifications et livre du seul joueur concerné, 40 joueurs, sauvegardes à plusieurs |
| `test_journey.lua` | 2 | chapitre 1 de bout en bout avec redémarrage ; les 193 quêtes jouées, sauvegarde de 17,5 Ko pour un joueur ayant tout fini |
| `test_phase5.lua` | 18 | chaque intégration (montures, animaux, boutiques, deltaplane, Nether, paléontologie, zones, dragons) et ses faux positifs |
| `test_i18n.lua` | 13 | français et anglais, langue du client, langue de repli, dates, raisons d'indisponibilité traduites |
| `test_integration_api.lua` | 9 | API des intégrations : enveloppes de callbacks et sondes, erreurs isolées |

Mesures (imitation de l'API, à titre indicatif) : environ 0,03 ms par action de minage avec 40 joueurs connectés.

## 4. Tests dans le vrai moteur

Procédure : `tests/integration/run.sh <serveur> <jeu> [mods]` démarre deux fois le serveur. Le mod de contrôle
`tests/integration/mlq_itest` vérifie au premier démarrage, enregistre une progression, puis relit tout au second.
Le script échoue si un contrôle échoue ou si le mod journalise une erreur. Seules les erreurs provoquées exprès par
le test (joueurs `mlq_itest_attendu_*`) sont tolérées.

### 4.1 Minetest Game seul

Commande : `tests/integration/run.sh <luanti> .audit_src/minetest_game`. Résultat : 0 échec sur les deux démarrages.

- Chargement du mod, 25 chapitres, 6 parties, 193 quêtes, objet livre.
- Traductions anglaises chargées par le moteur, y compris les paramètres réordonnés (date anglaise).
- Rendu des 193 fiches de quêtes, en français et en anglais, sans erreur ni balisage de traduction visible.
- Chaîne de quêtes liées, embranchement débloqué, quatre récompenses en file d'attente pour un joueur hors ligne.
- Après redémarrage : progression, file de livraison et chaîne conservées ; aucune seconde attribution.
- Plusieurs joueurs : chacun retrouve sa progression et sa file ; une clé de sauvegarde par joueur.
- Sauvegarde d'un format plus récent : lue en lecture seule, livre affiché, aucune attribution, fichier intact après
  arrêt et redémarrage.
- Sauvegarde illisible : nouveau départ sans erreur Lua, données d'origine copiées sous `p_corrupt:` et toujours
  présentes après redémarrage.

Dans cette configuration, 144 quêtes sont signalées « mod absent » et 10 « objet introuvable ». C'est attendu : les
objets de ces 10 quêtes viennent de mods absents ici (farming redo, boissons, décoration, ascenseurs) sans qu'un mod
unique soit exigé, ou d'un farming redo remplacé par le farming de Minetest Game, qui porte le même nom.

### 4.2 Avec les mods du serveur

Commandes : `python3 tests/integration/build_allmods.py`, puis
`tests/integration/run.sh <luanti> .audit_src/minetest_game tests/_tmp/itest_allmods`.
Résultat : **319 mods chargés, 0 échec sur les deux démarrages**, tous les contrôles du §4.1 compris.

```
[mlq_itest] INFO 319 mods chargés ; 193 quêtes jouables, 0 sans leur mod, 0 autres indisponibles
[mlq_itest] OK intégration areas branchée sur le vrai mod
[mlq_itest] OK intégration draconis branchée sur le vrai mod
[mlq_itest] OK intégration farming branchée sur le vrai mod
[mlq_itest] OK intégration hangglider branchée sur le vrai mod
[mlq_itest] OK intégration mobs branchée sur le vrai mod
[mlq_itest] OK intégration nether branchée sur le vrai mod
[mlq_itest] OK intégration paleotest branchée sur le vrai mod
[mlq_itest] OK intégration rings branchée sur le vrai mod
[mlq_itest] OK intégration smartshop branchée sur le vrai mod
[mlq_itest] OK aucune quête indisponible alors que ses mods sont présents (0)
[mlq_itest] FIN phase 1 : 0 échec(s)
[mlq_itest] FIN phase 2 : 0 échec(s)
INTÉGRATION : OK
```

Le mod `minerland_quests` n'a émis aucun avertissement ni aucune erreur pendant ce chargement complet. L'intégration
`rides` (montures et véhicules) ne dépend que du moteur et est active dans les deux configurations.

Mods écartés de ce test, avec leur raison :

| Mod | Raison |
|---|---|
| `shipwrecks` | la version publique s'arrête au chargement dans Luanti 5.15.1 (`core.settings:get_int` n'existe pas) ; le serveur en a sans doute une version corrigée |
| `lootchests_magic_materials` | dépend de `magic_materials`, absent des sources |
| `moremachines` | dépend de `homedecor` (ancien nom) ; mod déjà écarté par l'audit |
| `visual_line_number_displays` | dépend de `font_api` et `font_metro`, absents du serveur |
| `nether` (variante HybridDog) | variante comparée pendant l'audit, absente du serveur |

Erreur journalisée par un mod tiers, sans effet sur le test : `[adaptation_lib]: Key valve is already registered
(name is techage:ta3_valve_open)`.

## 5. Quêtes jouables par chapitre

Avec les mods du serveur chargés, toutes les quêtes sont jouables. Déclencheurs : 74 fabrications, 60 poses,
28 minages, 28 actions propres aux mods (intégrations), 3 consommations.

| Chapitre | Titre | Quêtes |
|---|---|---|
| **Les Fondamentaux** | | |
| ch01 | Bienvenue à Minerland | 7 |
| ch02 | Mon premier chez-moi | 7 |
| ch03 | Les joies de l'agriculture | 8 |
| ch04 | Les trésors de la terre | 10 |
| ch05 | Les anneaux du ciel | 8 |
| **La Vie quotidienne** | | |
| ch06 | La ferme aux animaux | 8 |
| ch07 | Les petits plats dans les grands | 8 |
| ch08 | L'art de la décoration | 9 |
| ch09 | Les affaires sont les affaires | 8 |
| **Les Transports** | | |
| ch10 | Sur les chapeaux de roues ! | 9 |
| ch11 | Le monde ferroviaire | 8 |
| ch12 | Métros et tramways | 7 |
| ch13 | Les fous volants | 8 |
| ch14 | Larguez les amarres ! | 7 |
| ch15 | Prenons de la hauteur ! | 7 |
| **Sciences et Technologies** | | |
| ch16 | L'électricité pour les nuls | 7 |
| ch17 | La révolution industrielle | 8 |
| ch18 | L'ère de Techage | 9 |
| ch19 | Les machines intelligentes | 7 |
| **L'Aventure** | | |
| ch20 | Les portes de l'Enfer | 5 |
| ch21 | Au plus profond de Minerland | 7 |
| ch22 | Dragons et autres bestioles | 8 |
| ch23 | Les mystères du passé | 8 |
| **Les Grands Projets** | | |
| ch24 | Les grands bâtisseurs | 7 |
| ch25 | Monsieur ou Madame le Maire | 8 |
| | **Total** | **193** |

## 6. À vérifier en jeu, sur une instance de test

Sans client, ces points n'ont pas pu être exécutés dans le moteur. Ils sont couverts par les tests simulés et
doivent être vérifiés une fois en jeu avant la mise en production :

1. Un nouveau joueur reçoit le livre ; un clic avec le livre l'ouvre ; la page Unified Inventory s'affiche (essayer
   aussi `unified_inventory_lite = true`).
2. Couper un tronc valide « Bûcheron du dimanche » : 3 pommes, bandeau, message, coche verte dans le livre ouvert.
3. Poser un tronc puis le recreuser ne compte pas ; des planches jetées par un autre joueur ne valident rien.
4. Inventaire plein : la récompense attend, puis arrive ; le bouton « recevoir mes récompenses » la relance.
5. Monter sur un cheval, dans une voiture, un train ou un bateau ; planer en deltaplane.
6. Acheter dans la boutique smartshop d'un autre joueur ; protéger une zone avec `/protect`.
7. Abattre un dragon, faire des clics droits sur son corps, ramasser écailles et œuf.
8. Redémarrer le serveur : la progression est conservée et rien n'est redonné.
9. Un client en anglais voit le livre en anglais.
10. `/mlq_diag` avec le privilège `minerland_quests_admin` ; `/mlq_reset` refusé tant que `allow_reset` vaut `false`.
11. Petite fenêtre (environ 1024 × 600) : le livre reste lisible et l'arbre défile.

## 7. Limites qui touchent les tests

- Les essais réels ont utilisé les sources publiques des mods ; le serveur a ses propres versions et des correctifs
  locaux (`minerland_fix_*`). Au premier démarrage sur le serveur, `/mlq_diag` liste les quêtes indisponibles.
- Une quinzaine de mods de décoration du serveur n'ont pas de source publique : ils n'ont été ni audités ni chargés,
  et aucune quête ne s'appuie sur eux.
- Seule la version 5.15.1 de Luanti a été testée (`mod.conf` déclare 5.10 au minimum).

Les autres limites du mod sont décrites dans `docs/ARCHITECTURE.md` §14.

## 8. Reproduire

```sh
make check
tests/integration/run.sh <luanti> .audit_src/minetest_game
python3 tests/integration/build_allmods.py
tests/integration/run.sh <luanti> .audit_src/minetest_game tests/_tmp/itest_allmods
```

`<luanti>` : binaire du serveur (`luantiserver`, ou `luanti`, lancé avec `--server`). Sur le poste de développement :
`tests/_tmp/luanti/luanti.app/Contents/MacOS/luanti`. Les journaux restent dans `tests/_tmp/itest/`.
