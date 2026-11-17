# Audit des mods — consignes communes

Ce document est la **référence commune** de tous les audits (agent `mod-researcher`). Les résultats alimentent
`docs/MOD_AUDIT.md` (généré par `tools/gen_mod_audit.py`) puis la conception des quêtes.

## 1. Sources et correspondances

- Sources publiques en **lecture seule** : `.audit_src/<dossier>/` (manifeste : `tools/audit_sources.txt`).
- Liste officielle des mods du serveur : `docs/audit/server_mods.txt` (la page « mods » du wiki est obsolète).
  Le serveur est inaccessible depuis le poste de développement : **les versions installées peuvent différer** des sources
  clonées (branche principale, novembre 2026). Il faut le rappeler chaque fois qu'un point dépend d'une version.
- Correspondance dossier serveur → dossier source quand les noms diffèrent :

| Dossier serveur | Dossier `.audit_src/` |
|---|---|
| `BBQ` | `bbq` |
| `Biofuel` | `biofuel` |
| `luanti-smartshop` | `smartshop` (dépend de `futil`/`fmod`) |
| `luanti-futil`, `minetest-futil` | `futil` |
| `luanti-fmod`, `minetest-fmod` | `fmod` |
| `luanti-tieless-tracks` | `tieless_tracks` |
| `minetest-hangglider` | `hangglider` |
| `minetest-moretrains` | `moretrains` |
| `minetest_tsm_railcorridors` | `tsm_railcorridors` |
| `tfl_s7stock_modpack` | `tfl_s7_stock_modpack` |
| `trainblocks_bc` | `trainblocks` (fork probable) |
| `mobs_redo` | `mobs` |
| `mob_horse`, `mobs_animal`, `mobs_npc` | idem |
| `lootchests_modpack`, `homedecor_modpack`, `techage_modpack`, `technic`, `mesecons`, `advtrains`, `automobiles_pck`… | **modpacks** : plusieurs mods par dossier |

- Le **nom d'un mod** est celui de `mod.conf` (`name =`), pas celui du dossier. `python3 tools/audit_mods.py .audit_src --mod <dossier> --summary`
  liste les mods d'un dossier avec leur nom réel et leurs dépendances.
- Outils : `python3 tools/audit_mods.py .audit_src --mod <dossier> --items|--crafts|--aliases|--grep <regex>`,
  `python3 tools/check_ids.py <id>...` (index des objets littéraux + alias + identifiants déjà vérifiés).
- Dossiers sans source (locaux ou introuvables) : `minerland_fix_*`, `friandises`, `chester`, `monitoring`,
  `radar_atc`, `minekart`, `beowulf`, `moredecorations`, `mod-cleaner`, `vps_blocker`, `everness`… → à signaler « non audité », jamais à deviner.

## 2. Sémantique exacte des événements du moteur de quêtes (à respecter pour classer la fiabilité)

| Type | Détecté par | Ne se déclenche PAS pour |
|---|---|---|
| `dig` | `core.register_on_dignode` : nœud creusé par un **vrai joueur** (faux joueurs, machines, entités exclus) ; un nœud-cible **posé** par quelqu'un puis recreusé est ignoré | nœuds détruits sans `node_dig` (explosions, `remove_node`, remplacements par `set_node`) |
| `place` | `core.register_on_placenode` : nœud posé via `core.item_place_node` / `core.place_node` (comportement par défaut d'un nœud) ou si le mod appelle lui-même `core.registered_on_placenodes` (cas des portes MTG) | `on_place` personnalisé qui utilise `core.set_node` sans rappeler les callbacks (lits MTG, entités/véhicules, graines farming…) |
| `craft` | `core.register_on_craft` : objet pris dans la **grille de fabrication standard** (recette `shaped`/`shapeless` enregistrée par `core.register_craft`) | cuisson/combustible (`cooking`, `fuel`), tables de craft personnalisées (xdecor workbench, moreblocks scie circulaire, technic CNC, workshops de `streets`/`ts_workshop`, machines technic/techage) |
| `eat` | `core.register_on_item_eat` : objets dont `on_use` appelle `core.item_eat`/`core.do_item_eat` | actions de boire sans item_eat |
| `custom` | un **adaptateur** (`integrations/<mod>.lua`) qui émet `minerland_quests.events.emit(joueur, "custom", "<mod>:<événement>")` | — |

Préférence pour l'adaptateur (du moins invasif au plus invasif) : callback/API **publique** du mod > lecture lente (≥ 1 s)
d'un **état public** > enveloppe justifiée d'un callback de définition (`core.override_item`, l'original est appelé en premier et sa valeur retournée telle quelle).
Jamais : remplacer une fonction globale d'un autre mod, scanner des zones, boucler sur les inventaires.

### 2 bis. Détection générique « monter à bord » (véhicules, montures, cabines, sièges)

Un adaptateur unique `integrations/rides.lua` lira lentement (toutes les 1-2 s, joueurs connectés seulement) l'API moteur
`player:get_attach()` → objet parent → `parent:get_luaentity().name` (nom d'entité enregistré) et émettra
`rides:<famille>` d'après une table « nom d'entité → famille ». Cela évite un hook par mod. Pour **chaque** véhicule,
monture, cabine ou siège de ton périmètre, vérifier et noter :
(a) le conducteur/passager est-il bien attaché par `set_attach` (fichier:ligne) — sinon l'action n'est **pas** détectable ainsi ;
(b) le **nom exact de l'entité** (`core.register_entity("…")` ou `<mod>.register_vehicle…` qui l'enregistre) ;
(c) les attachements parasites (PNJ, objets décoratifs, sièges de décor) qui provoqueraient de faux positifs.
Ne retenir « monter à bord » comme quête que si (a) est établi.

## 3. Classement de fiabilité d'une action (colonne « Fiab. »)

- **F** — fiable avec les callbacks moteur seuls (`dig`/`place`/`craft`/`eat`), après avoir **vérifié dans le code** que le chemin réel de l'action les déclenche.
- **A** — fiable avec un adaptateur : préciser lequel (callback public / état public / enveloppe), avec `fichier:ligne`, et les cas de faux positifs/négatifs.
- **I** — impossible ou non fiable (aucun événement côté serveur, action réservée aux privilèges, dépend d'un mob, etc.) : à ne pas retenir, mais à **expliquer** pour la documentation des limites.

## 4. Format des livrables

### 4.1 `docs/audit/<fichier>.md` (un fichier par agent, ≤ 350 lignes, en français)
Pour chaque **mod** (nom réel `mod.conf`) :
```
### <dossier serveur> (mod `<nom mod.conf>`) — sources auditées : <dossier .audit_src> @ <sha court>
- Rôle : …
- Dépendances : … (obligatoires / optionnelles)
- Objets utiles : `mod:item` — description courte — `fichier.lua:ligne`
- Événements détectables : action → F/A/I + justification courte
- Mécanismes particuliers / limites / privilèges requis : …
- Réglages `settingtypes` qui changent les recettes ou la disponibilité : …
```
Puis, pour **chaque chapitre** de ton périmètre : intro de 2-3 lignes et un tableau de **6 à 8 quêtes candidates**
(au moins 4 de fiabilité F), colonnes :
`slug | idée de titre (ton léger, roleplay) | type | identifiants exacts | Fiab. | clé custom + méthode | privilège | remarque`.
Ordonner du geste le plus simple au plus avancé ; signaler les branches possibles (prérequis suggérés).

### 4.2 `docs/audit/verified_<fichier>.txt`
Une ligne par identifiant **non littéral** (construit dans une boucle/concaténation) ou par id utile absent de l'index,
vérifié en lisant le code : `identifiant<TAB>fichier:ligne<TAB>remarque`. Lignes de commentaire : `#`.
Tout identifiant cité dans les tableaux doit être soit dans l'index (`check_ids.py` → OK/ALIAS), soit dans ce fichier.

## 5. Règles

- **Aucun identifiant inventé.** Reconstituer les noms construits dynamiquement en lisant la boucle.
- Vérifier la **recette** : ingrédients existants, recette non réservée à l'admin, non désactivée par un réglage ; noter les
  matériaux rares (le moteur plafonne la distribution de minerais précieux).
- Noter les objets enregistrés **conditionnellement** (`if minetest.get_modpath(...)`, réglages).
- Un chapitre ne doit pas dépendre d'une action nécessitant un privilège que les joueurs ordinaires n'ont pas.
- Le mod `awards` sera **supprimé** du serveur : ne pas l'utiliser, ne pas le mentionner comme dépendance.
- Écrire uniquement dans les fichiers de ton périmètre. Ne jamais modifier `.audit_src/`. Ne pas lancer d'autres agents.
- Rendre une réponse finale de **12 lignes maximum** : mods couverts, nombre de candidats F/A/I par chapitre, points bloquants.
