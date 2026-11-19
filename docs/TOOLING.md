# Outillage du projet

Environnement de développement de `minerland_quests` : configuration Claude Code, scripts de vérification et
tests. Tout s'exécute depuis la racine du dépôt. Aucun outil n'écrit hors du dépôt (sauf `tests/_tmp/`).

## 1. Configuration Claude Code (`.claude/`)

| Élément | Rôle |
|---|---|
| `CLAUDE.md` | Référence permanente : contraintes, conventions, sécurité, architecture, commandes. |
| `.claude/skills/*/SKILL.md` | 8 skills : `luanti-api`, `mod-audit`, `quest-design`, `formspec-ui`, `quest-integration`, `reward-balancing`, `luanti-testing`, `release-validation`. |
| `.claude/agents/*.md` | 7 sous-agents : `mod-researcher`, `quest-architect`, `ui-designer`, `luanti-developer`, `integration-specialist`, `qa-tester`, `security-reviewer`. Chacun précharge ses skills (champ `skills:`). |
| `.claude/settings.json` | Permissions du projet et hook de contrôle. |
| `.claude/hooks/check_edit.py` | Hook `PostToolUse` (Edit/Write) : syntaxe Lua (LuaJIT, + luacheck si présent), Python, JSON, frontmatter des agents/skills ; signale toute écriture dans `.audit_src/`. Renvoie l'erreur à Claude (code 2). Ne modifie rien. |

Permissions (`.claude/settings.json`) :
- **autorisé sans demande** : `make`, `luajit`, `python3 tools/*`, `git status/diff/log`, lecture de `.audit_src/` ;
- **demande confirmation** : `ssh`, `scp`, `rsync` (accès serveur), `git commit`, `git push` ;
- **interdit** : écrire dans `.audit_src/`, `rm -rf`, `git reset --hard`, `git clean`.

Répartition des agents par phase :

| Phase | Agents |
|---|---|
| Audit | `mod-researcher` |
| Conception des quêtes | `quest-architect` |
| Moteur | `luanti-developer` |
| Interface et textures | `ui-designer` |
| Adaptateurs de mods | `integration-specialist` |
| Tests et chasse aux abus | `qa-tester` |
| Revue avant livraison | `security-reviewer` |

L'agent principal coordonne : il découpe le travail, relit les résultats et garde la cohérence d'ensemble.

## 2. Commandes (`Makefile`)

| Commande | Effet |
|---|---|
| `make check` | lint + contrôle des traductions + contrôle des textures + validation des quêtes + tests simulés |
| `make lint` | `tools/lint.sh` : luacheck (`.luacheckrc`) s'il est installé, sinon syntaxe LuaJIT + détection des globales accidentelles |
| `make test` | `luajit tests/run.lua` : tests simulés (`luajit tests/run.lua engine` pour un seul fichier) |
| `make validate` | `tools/validate_quests.py` : ids, prérequis, cycles, accessibilité, objets audités, économie, taille des arbres |
| `make textures` | `tools/gen_textures.py` : génération procédurale et déterministe des 56 PNG (`--only NOM`, `--list`, `--preview planche.png` pour une planche agrandie sans toucher au mod) |
| `make check-textures` | `tools/check_textures.py` : présence, validité PNG, dimensions, textures orphelines |
| `make i18n` | `tools/i18n.py` : extrait les textes source (français) dans `locale/template.txt` et met à jour les `.tr` |
| `make check-i18n` | `tools/i18n.py --check` : modèle à jour, aucune traduction manquante, paramètres `@1`…`@9` cohérents |
| `make docs` | `tools/gen_docs.py` : génère `docs/QUESTS.md` |
| `make audit-index` | reconstruit `docs/audit/item_index.json` depuis `.audit_src/` |
| `make fetch-sources` | `tools/fetch_sources.sh` : clone en lecture seule les sources listées dans `tools/audit_sources.txt` |
| `make dist` | lance `make check` puis crée `dist/minerland_quests-<version>.zip` (le mod seul) |

## 3. Scripts (`tools/`)

| Script | Rôle |
|---|---|
| `audit_mods.py` | Audit statique **en lecture seule** d'un dossier de mods : nom réel (`mod.conf`), dépendances, objets littéraux avec `fichier:ligne`, recettes, alias, recherche de callbacks, index JSON. Utilisable sur le serveur : `python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods --summary`. |
| `check_ids.py` | Vérifie une liste d'identifiants contre l'index et les listes vérifiées (`docs/audit/verified_*.txt`). |
| `dump_quests.lua` | Charge le vrai mod dans le mock et exporte le catalogue en JSON (base de `validate_quests.py` et `gen_docs.py`). |
| `validate_quests.py` | Voir `make validate`. Code 1 en cas d'erreur ; `--strict` rend les avertissements bloquants. |
| `check_textures.py`, `pngkit.py` | Contrôle des PNG ; lecture et écriture PNG en Python pur (Pillow n'est pas requis). |
| `gen_textures.py` | Textures originales (CC-BY-SA-4.0, `minerland_quests/LICENSE_TEXTURES.txt`) : petite bibliothèque de dessin (formes, polygones, bruit, tramage ordonné, sprites au pixel, police 5×7, capitales à empattements, dorure en relief, arbres feuillus, héraldique) et une fonction par texture. Règles 9-slice : détails dans les coins, bords et centre lisses (Luanti étire bords et centre). |
| `i18n.py` | Traductions : extraction des appels `S("…")`, `N("…")`, `tr(joueur, "…")` du code Lua (concaténations de littéraux comprises) et des textes de quêtes (via `dump_quests.lua`) ; `locale/template.txt` régénéré ; fusion dans chaque `minerland_quests.<code>.tr` (traductions conservées, nouvelles entrées vides, entrées obsolètes en commentaire) ; `--check` (code 1 si incomplet) ; `--add CODE` pour une nouvelle langue. |
| `gen_docs.py` | Catalogue Markdown des quêtes. |
| `lint.sh` | Voir `make lint`. |
| `fetch_sources.sh`, `audit_sources.txt` | Récupération des sources publiques des mods. |

Les objets construits dynamiquement par les mods (boucles, concaténations) n'apparaissent pas dans l'index littéral :
ils sont vérifiés à la lecture du code et consignés avec leur source dans `docs/audit/verified_*.txt`.

## 4. Tests

- **Simulés** (`tests/`) : `mock_core.lua` (mock de l'API Luanti), `harness.lua` (charge le vrai mod, actions de
  jeu de haut niveau, redémarrages simulés, mini-framework d'assertions), `run.lua` (lanceur), `test_*.lua`.
- **Intégration réelle** (`tests/integration/`) : `run.sh <binaire_serveur> <minetest_game> [mods]` démarre deux fois un vrai
  serveur Luanti sur un monde jetable dans `tests/_tmp/itest/`. Le mod `mlq_itest` vérifie le chargement, Unified Inventory,
  les formspecs puis la persistance après redémarrage.

## 5. Disponibilité des outils sur le poste de développement (relevé du 17/11/2026)

| Outil | État | Usage / remplacement |
|---|---|---|
| LuaJIT 2.0.5 | ✅ installé | tests, syntaxe, dump du catalogue |
| Python 3.14 | ✅ installé | scripts `tools/` |
| git, make, zip | ✅ installés | dépôt, commandes, archive |
| luacheck | ❌ absent | facultatif (`luarocks install luacheck`). `lint.sh` le détecte automatiquement. |
| StyLua (formateur Lua) | ❌ absent | facultatif ; le style est imposé par `CLAUDE.md` (tabulations, 120 colonnes). |
| busted | ❌ absent | inutile : le harnais `tests/harness.lua` suffit et n'a aucune dépendance. |
| Pillow, pngcheck, optipng | ❌ absents | remplacés par `tools/pngkit.py` (Python pur). |
| jq | ❌ absent | le hook est écrit en Python. |
| ffmpeg | ❌ absent | aucun son n'est généré ; `sounds/mlq_complete.ogg` reste facultatif. |
| Serveur Luanti 5.15.1 | ❌ absent | requis seulement pour `tests/integration/run.sh` (à lancer sur une machine de test qui en dispose). |

Aucun serveur MCP n'est utilisé ni requis par le projet.
