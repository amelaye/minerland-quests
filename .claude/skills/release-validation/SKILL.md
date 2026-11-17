---
name: release-validation
description: Préparation d'une version distribuable de minerland_quests (vérifications finales, documentation, notes de version, installation, migration des données, dépendances, retour arrière). À utiliser avant toute livraison ou mise à jour sur le serveur.
---

# Validation de version

## Checklist (toutes les cases doivent être cochées)
- [ ] `make check` passe (syntaxe/lint, validate, textures, tests simulés).
- [ ] Tests d'intégration réels exécutés **ou** explicitement marqués « non exécutés » dans `docs/TEST_REPORT.md`.
- [ ] `docs/QUESTS.md` régénéré (`make docs`) et commité.
- [ ] `mod.conf` : version incrémentée, `optional_depends` à jour avec les noms `mod.conf` réels.
- [ ] `CHANGELOG.md` : ajouts, modifications, quêtes renommées (avec alias), migrations.
- [ ] Aucune quête publiée n'a changé d'`id` sans alias de migration.
- [ ] `STORAGE_VERSION` incrémentée si le format change + migration testée (`tests/test_storage.lua`).
- [ ] Licences : `LICENSE`, crédits des textures dans `minerland_quests/README.md`.
- [ ] `make dist` produit `dist/minerland_quests-<version>.zip` sans fichiers parasites (tests, .claude, .audit_src).

## Installation (procédure pour l'administratrice — un agent ne l'exécute pas)
1. Sauvegarder le monde (au minimum `mod_storage.sqlite` ou `mod_storage/`, selon le backend).
2. Copier `minerland_quests/` dans `/home/minetest/luanti5_15_1/mods/`.
3. Ajouter `load_mod_minerland_quests = true` dans `world.mt`.
4. Redémarrer le serveur ; vérifier `debug.txt` : ligne `[minerland_quests] chargé : N quêtes`.
5. En jeu : `/mlq_diag` (privilège `minerland_quests_admin`) affiche l'état des intégrations et des quêtes indisponibles.

## Mise à jour
- Les données joueurs sont indexées par id de quête : ajouter des quêtes ne perd rien.
- Une quête supprimée reste dans les données (ignorée) ; elle n'est jamais re-récompensée si elle revient.

## Retour arrière
1. Arrêter le serveur. 2. Restaurer le dossier précédent du mod. 3. Si `STORAGE_VERSION` a augmenté, restaurer
la sauvegarde du stockage (les anciennes versions refusent un format plus récent et le signalent dans le log
au lieu de l'écraser). 4. Redémarrer.

## Notes de version (gabarit)
```
## [x.y.z] — AAAA-MM-JJ
### Ajouté / Modifié / Corrigé
### Quêtes : +N (chapitres …), renommées : ancien → nouveau
### Migration : aucune | STORAGE_VERSION a → b (automatique)
```
