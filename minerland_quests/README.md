# Le Grand Livre des Quêtes de Minerland

Mod Luanti `minerland_quests` pour le serveur *Amelaye in Minerland* : un livre de quêtes illustré de 193 quêtes,
réparties en 25 chapitres et 6 parties, avec arbres de progression. Les quêtes se valident toutes seules et les
récompenses arrivent dans l'inventaire. Le livre s'ouvre aussi dans Unified Inventory. Textes en français et en anglais.

## Prérequis

- Luanti 5.15.1 (version testée) et le jeu Minetest Game.
- Aucune dépendance obligatoire. Unified Inventory est recommandé (page du livre dans l'inventaire).
- Une quête qui demande un autre mod (trains, Techage, dragons…) n'est jouable que si ce mod est installé. Sinon elle
  est marquée « indisponible » et ne bloque pas les quêtes suivantes.

## Installation

1. Sauvegarder le monde, au minimum le stockage des mods : `mod_storage.sqlite`, ou le dossier `mod_storage/` selon
   le réglage `mod_storage_backend` du `world.mt`.
2. Copier le dossier `minerland_quests/` dans le dossier `mods/` du serveur.
3. Activer le mod dans le fichier `world.mt` du monde : `load_mod_minerland_quests = true`.
4. Redémarrer le serveur. Le journal (`debug.txt`) doit contenir la ligne
   `[minerland_quests] chargé : 193 quêtes dans 25 chapitres (N indisponibles sur ce serveur)`.
5. En jeu, `/mlq_diag` liste les intégrations actives et les quêtes indisponibles, avec leur raison.

Conseillé : faire d'abord ces étapes sur une instance de test, avec la liste de contrôle en jeu du rapport de tests
(`docs/TEST_REPORT.md` §6, dans le dépôt).

**Mise à jour** : sauvegarder, remplacer le dossier, redémarrer. La progression des joueurs est conservée (format de
sauvegarde versionné, migrations automatiques).
**Retour arrière** : arrêter le serveur, remettre l'ancien dossier du mod, redémarrer. Si le format de sauvegarde a
changé entre-temps, restaurer aussi la sauvegarde : une version plus ancienne lit un format plus récent sans jamais
l'écraser, et le signale dans le journal.
**Désinstallation** : retirer le mod. La progression reste enregistrée dans le monde, rien n'est effacé.
**Son de réussite** (facultatif, aucun fourni) : déposer un fichier `sounds/mlq_complete.ogg` dans le dossier du mod.

## Pour les joueurs

- Le livre est offert à la première connexion. Il se fabrique aussi : un livre et un morceau de charbon.
- Pour l'ouvrir : cliquer avec le livre en main, taper `/quetes`, `/livre` ou `/quests`, ou passer par Unified
  Inventory.
- Une quête se valide dès que l'action est faite : miner, fabriquer, poser, manger, monter à bord, etc.
- Si l'inventaire est plein, la récompense attend et arrive dès qu'il y a de la place. Le bouton « recevoir mes
  récompenses » relance aussi la livraison.
- Ne comptent pas : un objet donné par un autre joueur, un bloc posé puis recreusé, le travail des machines.

## Administration

Toutes les commandes `/mlq_*` demandent le privilège `minerland_quests_admin`. Aucune quête ne donne de privilège.

| Commande | Rôle |
|---|---|
| `/mlq_progress <joueur>` | progression d'un joueur, chapitre par chapitre |
| `/mlq_quest <joueur> <id_quête>` | état détaillé d'une quête pour un joueur |
| `/mlq_reward <joueur>` | journal et file d'attente des récompenses ; relance la livraison |
| `/mlq_diag` | intégrations actives, langues, quêtes indisponibles, problèmes de données |
| `/mlq_reset <joueur> <id_quête>` | **test seulement** : remet une quête à zéro, sans seconde récompense |
| `/mlq_simulate <id_quête>` | **test seulement** : déclenche une quête pour soi-même |

`/mlq_reward`, `/mlq_reset` et `/mlq_simulate` sont inscrites dans le journal du serveur. Les deux commandes de test
sont refusées tant que `minerland_quests.allow_reset` n'est pas activé : laisser ce réglage à `false` en production.

## Réglages

À placer dans le fichier de configuration du serveur (`minetest.conf`).

| Réglage | Défaut | Rôle |
|---|---|---|
| `minerland_quests.give_book_on_join` | `true` | offrir le livre aux nouveaux joueurs |
| `minerland_quests.notify_chat` | `true` | message dans le chat à la réussite d'une quête |
| `minerland_quests.count_creative` | `true` | compter les actions des joueurs en mode créatif |
| `minerland_quests.fallback_language` | `en` | langue du livre (`en` ou `fr`) pour un client dans une langue non traduite |
| `minerland_quests.placed_cap` | `20000` | nombre de blocs posés mémorisés (contre la triche aux quêtes de minage) |
| `minerland_quests.allow_reset` | `false` | **instance de test seulement** : autorise `/mlq_reset` et `/mlq_simulate` |

## Langues

Le français est la langue d'origine du livre. Chaque joueur le lit dans la langue de son client si elle est traduite
(l'anglais est fourni dans `locale/`), sinon dans la langue de repli. Un client qui n'annonce aucune langue voit le
français.

## Licence

- Textures (`textures/mlq_*.png`) : CC BY-SA 4.0, voir `LICENSE_TEXTURES.txt`.
- Code : licence pas encore choisie.

Liste des quêtes et documentation complète : <https://github.com/amelaye/minerland-quests>
