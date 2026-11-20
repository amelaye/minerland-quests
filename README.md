# Le Grand Livre des Quêtes de Minerland

Mod Luanti pour le serveur *Amelaye in Minerland* : un livre de quêtes illustré, intégré à Unified Inventory, avec
arbres de progression, validation automatique des quêtes et récompenses automatiques. Il compte 193 quêtes en
25 chapitres et 6 parties, en français et en anglais.

- **Installer et utiliser le mod** : [minerland_quests/README.md](minerland_quests/README.md)
- **Liste des quêtes** : [docs/QUESTS.md](docs/QUESTS.md)
- **Rapport de tests** : [docs/TEST_REPORT.md](docs/TEST_REPORT.md) — **Versions** : [CHANGELOG.md](CHANGELOG.md)

## Contenu du dépôt

| Dossier | Rôle |
|---|---|
| `minerland_quests/` | le mod : seul dossier à copier sur le serveur |
| `docs/` | architecture, audit des mods du serveur, quêtes, récompenses, outillage |
| `tools/` | validation des quêtes, textures, traductions, audit des mods |
| `tests/` | tests simulés et test d'intégration dans un vrai serveur Luanti |

## Développement

Il faut LuaJIT, Python 3 (bibliothèque standard seulement) et `zip` ; luacheck est facultatif.

```sh
make check      # tout vérifier : syntaxe, traductions, textures, quêtes, tests simulés
make test       # tests simulés seulement (mock de l'API Luanti)
make docs       # régénère docs/QUESTS.md
make textures   # régénère les textures
make dist       # archive du mod dans dist/
tests/integration/run.sh <serveur_luanti> <minetest_game> [dossier_mods]   # vrai serveur, monde jetable
```

Les tests simulés ne remplacent pas le test dans un vrai serveur : voir [docs/TOOLING.md](docs/TOOLING.md).

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) : conception, intégrations des mods, décisions, limites connues (§14)
- [docs/TEST_REPORT.md](docs/TEST_REPORT.md) : ce qui a été testé, résultats, vérifications à faire en jeu
- [docs/MOD_AUDIT.md](docs/MOD_AUDIT.md) : objets et mécaniques des mods du serveur, vérifiés dans leurs sources
- [docs/REWARDS.md](docs/REWARDS.md) : équilibrage des récompenses
- [docs/TOOLING.md](docs/TOOLING.md) : scripts, tests et outils
- [CLAUDE.md](CLAUDE.md) : règles du projet (sécurité, conventions, création des quêtes)

## Licence

- Textures : CC BY-SA 4.0 ([minerland_quests/LICENSE_TEXTURES.txt](minerland_quests/LICENSE_TEXTURES.txt)).
- Code : licence pas encore choisie.
