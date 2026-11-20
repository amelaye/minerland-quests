# Journal des versions

## [1.0.0] — 2026-11-20

Première version.

### Ajouté
- **Le Grand Livre des Quêtes de Minerland** : 193 quêtes en 25 chapitres et 6 parties, avec arbres de progression
  (prérequis dessinés, coche verte, cadenas, quêtes indisponibles en rouge brique). Les fondamentaux forment un tronc
  commun léger ; les autres chapitres sont indépendants.
- **Ouverture** : objet livre (offert à la première connexion, fabricable avec un livre et un morceau de charbon),
  commandes `/quetes`, `/livre` et `/quests`, page Unified Inventory (modes complet et allégé).
- **Validation automatique** : miner, fabriquer, poser, manger, et actions propres aux mods (monter à bord, apprivoiser
  ou capturer un animal, acheter et vendre, planer, allumer le portail du Nether, poser un œuf de dinosaure, protéger
  une zone, ramasser le butin d'un dragon abattu, labourer et semer, équiper et activer un anneau, voler). Un objet
  donné par un autre joueur, un bloc posé puis recreusé et les machines ne valident rien.
- **Récompenses automatiques**, une seule fois par joueur, avec file de livraison persistante si l'inventaire est
  plein, et titres honorifiques. Aucune quête ne donne de privilège.
- Notifications à l'écran et dans le chat ; le livre ouvert se met à jour en direct.
- **Français et anglais** : langue du client, langue de repli réglable.
- **Administration** : privilège `minerland_quests_admin`, `/mlq_progress`, `/mlq_quest`, `/mlq_reward`, `/mlq_diag` ;
  `/mlq_reset` et `/mlq_simulate` réservées aux instances de test (`minerland_quests.allow_reset`).
- Textures originales en pixel art (CC BY-SA 4.0).

### Quêtes renommées
- Aucune.

### Migration
- Aucune : format de sauvegarde v1. Une sauvegarde d'un format plus récent est lue sans jamais être écrasée.
