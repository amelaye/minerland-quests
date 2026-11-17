---
name: luanti-testing
description: Tests du mod minerland_quests (unitaires, simulés avec un mock de l'API Luanti, événements, sauvegarde, récompenses, compatibilité, interfaces) et procédure de test d'intégration dans un vrai serveur Luanti isolé. À utiliser pour écrire ou exécuter des tests.
---

# Tests

## Deux niveaux, jamais confondus
1. **Tests simulés** (`tests/`, LuaJIT + `tests/mock_core.lua`) : rapides, déterministes, lancés par `make test`.
   Ils prouvent la logique du mod, **pas** le comportement du moteur.
2. **Tests d'intégration réels** (`tests/integration/`) : un vrai serveur Luanti headless sur un monde jetable
   dans `tests/_tmp/`. Seuls ces tests autorisent à écrire « testé dans le moteur ». Ne jamais les déclarer
   réussis sans sortie de log à l'appui.

## Lancer
```sh
make test                         # tous les tests simulés
luajit tests/run.lua engine       # un seul fichier (tests/test_engine.lua)
make validate                     # cohérence des données de quêtes (Python, sans moteur)
tests/integration/run.sh /chemin/vers/luantiserver [dossier_mods]   # intégration réelle
```

## Écrire un test simulé
Un fichier `tests/test_<sujet>.lua` reçoit le harnais `T` (`tests/harness.lua`) en argument :
```lua
local T = ...
T.describe("rewards", function()
	T.it("met en attente si l'inventaire est plein", function()
		local env = T.env({ all_mods = true, all_items = true })   -- vrai mod chargé dans le mock
		env:join("alice")
		env:complete_with_requirements("alice", "ch01.planks")      -- passe par les vrais callbacks
		env:fill_inventory("alice", "default:dirt 99")
		env:complete("alice", "ch01.sticks")
		T.eq(env.Q.rewards.pending_count("alice"), 1)
		env:clear_inventory("alice"); env:step(11)                   -- relance périodique (10 s)
		T.eq(env.Q.rewards.pending_count("alice"), 0)
	end)
end)
```
Actions : `env:join(nom, privs)`, `env:leave(nom)`, `env:dig(qui, nœud, pos)`, `env:place(qui, nœud, pos)`,
`env:craft(qui, objet, n)`, `env:eat(qui, objet)`, `env:give(de, à, objet)` (aucun callback, comme en jeu),
`env:fake_player(nom)`, `env:fields(qui, formname, champs)`, `env:chat(nom, cmd, param)`, `env:step(sec)`,
`env:restart()` (arrêt propre), `env:crash_restart()` (sans callbacks d'arrêt), `env:complete(nom, qid)`,
`env:complete_with_requirements(nom, qid)`, `env:state(nom, qid)`.
Options de `T.env` : `mods`, `all_mods`, `all_items`, `items`, `ui`, `ui_lite`, `settings`, `before_finalize`.
Assertions : `T.eq`, `T.ok`, `T.contains`, `T.not_contains`, `T.raises`.
Le mock (`tests/mock_core.lua`) fournit : registre d'objets, joueurs et inventaires, mod storage en mémoire
(conservé entre redémarrages simulés), callbacks moteur, `formspec_escape`, JSON, `after`, globalsteps manuels.

## Couverture obligatoire
- Moteur : enregistrement, id, prérequis, déblocage, compteur, validation, double validation, cycles, quête absente.
- Récompenses : normale, unique, inventaire plein, attente, livraison ultérieure, reconnexion, redémarrage simulé,
  double attribution, objet inexistant.
- Progression : débutant, avancé, deux joueurs, données modifiées, nouvelle quête, migration, mod absent.
- Événements : dig, craft, place, eat, custom ; **objet reçu d'un autre joueur ne valide rien** ; faux joueur ;
  bloc posé puis recreusé.
- Interface : formspec du livre et de la page UI générés sans erreur, coches présentes, prérequis affichés,
  quêtes indisponibles, échappement des caractères spéciaux (`]`, `;`, `[`, `\`).

## Intégration réelle (procédure)
`tests/integration/run.sh <binaire_serveur> <dossier_jeu_minetest_game> [dossier_mods_optionnels]` :
1. Crée un espace isolé `tests/_tmp/itest/` (MINETEST_USER_PATH dédié, monde jetable) — rien hors de ce dossier.
2. Lie le jeu, `minerland_quests`, le mod de vérification `tests/integration/mlq_itest` et, si fourni,
   `unified_inventory` et les mods optionnels présents dans le dossier indiqué.
3. 1er démarrage : `mlq_itest` vérifie le chargement, les quêtes, le bouton/la page UI, la génération des
   formspecs, puis enregistre une progression et une récompense en attente ; arrêt via `core.request_shutdown()`.
4. 2e démarrage : vérifie que la progression et la file de livraison ont survécu.
5. Le script affiche le résultat de chaque vérification (`[mlq_itest] OK/ÉCHEC …`) et garde les logs dans
   `tests/_tmp/itest/*.log`. Copier les extraits dans `docs/TEST_REPORT.md`.
Ce test ne simule pas un client : les actions de jeu (creuser, poser) restent couvertes par les tests simulés,
et par un test manuel en jeu sur une instance de test.
