# CLAUDE.md — Minerland Questbook (`minerland_quests`)

Référence permanente pour l'agent principal et les sous-agents. À lire avant toute modification.

## 1. Le projet

Mod Luanti **`minerland_quests`** pour le serveur pacifique et semi-roleplay *Amelaye in Minerland* :
un livre de quêtes illustré (« Le Grand Livre des Quêtes de Minerland »), intégré à Unified Inventory,
avec arbres de progression, validation **automatique** des quêtes et récompenses **automatiques**.

- 6 parties, 25 chapitres, 193 quêtes. Données dans `minerland_quests/quests/`.
- Le mod vit dans `minerland_quests/` (seul dossier à copier sur le serveur).
- Les outils, tests, docs et la configuration Claude sont **hors** du mod (à la racine du dépôt).

## 2. Environnement et compatibilité

- Cible : **Luanti 5.15.1**, serveur Linux, `/home/minetest/luanti5_15_1/mods/` (non accessible depuis le poste de dev).
- Liste réelle des mods installés : `docs/MOD_AUDIT.md` (le wiki `doku.php?id=mods` est obsolète).
- Sources publiques des mods clonées en lecture seule dans `.audit_src/` (ignoré par git) via `tools/fetch_sources.sh`.
  Les versions serveur peuvent différer : **toute référence d'objet est revérifiée à l'exécution** (`core.registered_items`).
- Attention aux noms : le **nom de mod** est celui de `mod.conf` (`name = …`), pas celui du dossier
  (ex. dossier `rings` → mod `goops_rings`, `luanti-smartshop` → `smartshop`, `Biofuel` → `biofuel`).
- API : utiliser `core.*` (alias moderne de `minetest.*`). Formspecs : `formspec_version[6]` pour le livre,
  la page Unified Inventory impose `formspec_version[4]` (elle préfixe son propre en-tête).
- Lua 5.1 / LuaJIT : pas de `goto` hors LuaJIT, pas d'opérateurs 5.3 (`//`, `&`), pas de `table.unpack` (utiliser `unpack`).

## 3. Règles de sécurité (impératives)

1. Ne jamais modifier un mod tiers. Aucune écriture dans `.audit_src/`.
2. Ne jamais toucher aux mondes, sauvegardes, ni à l'installation locale de l'utilisateur.
3. Aucune action sur le serveur de production sans autorisation explicite écrite.
4. Aucune commande destructive (`rm -rf` hors dossiers générés du projet, `git reset --hard`, etc.).
5. Ne jamais faire confiance aux champs de formulaire : ils ne servent qu'à **naviguer**. Aucune réussite
   ne peut être déclarée par le client. Tout identifiant reçu est revalidé contre le registre.
6. Pas de privilège en récompense (`fly`, `give`, `creative`, etc.). Pas de vol permanent.
7. Échapper tout texte injecté en formspec avec `core.formspec_escape` (via `ui/theme.lua` → `esc()`).
8. Commandes admin modifiant une progression : privilège `minerland_quests_admin`, journalisées (`core.log("action")`).

## 4. Architecture (séparation stricte)

```
minerland_quests/
  init.lua            -- chargement ordonné, rien d'autre
  core/registry.lua   -- parties, chapitres, quêtes : enregistrement + validation des définitions
  core/graph.lua      -- prérequis, cycles, profondeur, disposition de l'arbre
  core/storage.lua    -- persistance (mod storage), format versionné, migrations
  core/progress.lua   -- états, compteurs, complétion (logique pure, testable)
  core/events.lua     -- bus d'événements normalisés + callbacks moteur (dig/place/craft/eat)
  core/rewards.lua    -- attribution, file de livraison persistante, journal anti-doublon
  core/compat.lua     -- détection des mods/objets présents, statut « indisponible »
  ui/…                -- thème, vues partagées, livre, page Unified Inventory, notifications
  integrations/…      -- un fichier par mod tiers, chargé seulement si le mod est présent
  quests/<partie>/chNN_*.lua -- DONNÉES uniquement (register_chapter / register_quest)
```

- Ajouter une quête = ajouter des données. **Ne jamais** modifier le cœur pour une quête particulière.
- Une intégration émet des événements via `minerland_quests.events.emit(name, type, key, count, ctx)`.
- Pas de variable globale autre que `minerland_quests`. Tout le reste est `local`.

## 5. Conventions Lua et nommage

- Indentation tabulations, lignes ≤ 120 colonnes, `local` partout, fonctions courtes.
- Identifiants de quête : `chapitre.slug` en snake_case ASCII (ex. `ch04.gold_rush`). **Immuables** une fois publiés
  (la progression des joueurs y est attachée). Renommer = ajouter un alias dans `core/storage.lua` (migration).
- Champs formspec : préfixe `mlq_` (ex. `mlq_q_ch04.gold_rush`).
- Textures : préfixe `mlq_` (ex. `mlq_frame_done.png`). Sons : `mlq_`.
- Messages joueur en **français**, via `core.get_translator("minerland_quests")`.

## 6. Règles de création des quêtes (résumé, détail : skill `quest-design`)

- ACTION → DÉTECTION → VALIDATION → RÉCOMPENSE → COCHE. Chaque quête a un `trigger` détectable par le serveur.
- Types de déclencheurs : `dig`, `place`, `craft`, `eat`, `custom` (émis par une intégration).
- Interdits : coordonnées à atteindre, zones balisées, validation admin systématique, auto-déclaration,
  possession d'un objet (un objet donné par un autre joueur ne doit rien valider).
- Distinguer miner / fabriquer / poser. Les blocs posés par un joueur puis recreusés ne comptent pas (`dig`).
- Machines et faux joueurs (pipeworks, digtron, techage) ne valident jamais une action personnelle.
- Chaque objet référencé (cible, récompense, icône) doit exister dans les sources auditées : citer le fichier source
  dans `docs/MOD_AUDIT.md`. Aucun identifiant inventé.
- Les fondamentaux forment un tronc commun léger ; transports, technologie, commerce et exploration sont indépendants.

## 7. Interface et illustrations

- Style : livre ancien, parchemin crème, texte brun foncé, bronze, pixel art. Pas de boutons gris standards.
- Couleurs d'état : disponible = or `#e8b84a`, terminée = vert `#4caf50`, verrouillée = gris `#8a8a8a`,
  indisponible = rouge brique `#a0523d`. Constantes dans `ui/theme.lua` uniquement.
- Textures générées par `tools/gen_textures.py` (procédural, original, licence CC-BY-SA-4.0). Ne jamais copier
  de textures Minecraft. Les icônes de quêtes utilisent `item_image` des objets réels des mods.
- Pas de faux zoom ni de glisser-déposer : défilement via `scroll_container` + `scrollbar`.

## 8. Commandes

```sh
make check          # tout : syntaxe, lint, validation quêtes, textures, tests
make test           # tests unitaires/simulés (LuaJIT + mock de l'API)
make lint           # luacheck si installé, sinon contrôle syntaxique luajit
make validate       # tools/validate_quests.py (ids, prérequis, cycles, références d'objets)
make textures       # régénère les PNG ; make check-textures pour contrôler
make docs           # régénère docs/QUESTS.md
make dist           # archive distribuable dans dist/
python3 tools/check_ids.py <id>...           # vérifier un identifiant d'objet contre l'audit
tests/integration/run.sh <serveur> <jeu> [mods]   # test réel dans un serveur Luanti isolé
```
Détail de tout l'outillage (scripts, hooks, permissions, outils absents) : `docs/TOOLING.md`.

## 9. Critères de validation d'un changement

- `make check` passe. Aucun avertissement nouveau du validateur.
- Toute nouvelle quête : trigger vérifié, récompense existante, prérequis acycliques, texte FR relu.
- Toute nouvelle intégration : test simulé dans `tests/`, justification écrite si un callback tiers est enveloppé.
- Ne jamais annoncer un test d'intégration réussi s'il n'a pas été exécuté dans un vrai moteur Luanti.

## 10. Documentation et livraison

- Docs en français dans `docs/`. `docs/QUESTS.md` est **généré** (ne pas éditer à la main).
- Toute décision technique non triviale : une ligne dans `docs/ARCHITECTURE.md` (section Décisions).
- Livraison : `make dist` → `dist/minerland_quests-<version>.zip` ; notes dans `CHANGELOG.md`.
- Installation serveur : copier `minerland_quests/` dans `mods/`, ajouter `load_mod_minerland_quests = true`
  dans `world.mt` — **à faire par l'administratrice**, jamais par un agent.
