# Récompenses du Grand Livre — choix d'équilibrage

Ce document justifie les récompenses des 193 quêtes (état du 20/11/2026). Le détail quête par quête est dans
`docs/QUESTS.md` (généré par `make docs`). Les plafonds sont contrôlés automatiquement par `make validate`.

## 1. Principes

- **Une seule fois par joueur.** Le journal persistant est écrit avant la livraison : une récompense peut au pire être
  perdue lors d'un arrêt brutal, jamais dupliquée. Inventaire plein : file de livraison persistante, jamais au sol.
- **Aucun privilège**, jamais de vol permanent, aucun objet créatif ou d'administration.
- **Récompenses thématiques et utiles à l'étape suivante** : ingrédients en cuisine, bois et verre pour la
  décoration, carburant pour les véhicules, cuivre et acier pour les machines, torches pour l'exploration.
- **Jamais la machine qu'on vient de fabriquer** : on donne les composants ou consommables du palier suivant.
- **Pas d'incitation à fabriquer en série** : toute quête de pose de machine se valide avec une seule machine.
- **Pas de minerais précieux en masse**, pas d'outil en diamant ; la valeur suit la difficulté.
- **Monnaie modérée** : le Minegeld n'apparaît qu'au chapitre du commerce, à la gare (guichet) et à la mairie
  (distributeur), pour ne pas concurrencer le revenu de base du serveur.
- **Titres honorifiques** : chaque quête finale de chapitre donne un titre propre au mod. Ceux des chapitres 6 à 25
  sont épicènes (« Maire » l'est aussi) ; ceux des chapitres 1 à 5 sont au masculin (« Maître mineur », « Seigneur
  des anneaux »…). Ils n'ont aucun effet de jeu.
- **Objet absent du serveur** : il est retiré de la récompense au démarrage (avertissement dans le journal, visible
  par `/mlq_diag`) ; la quête reste jouable.

## 2. Barème indicatif par difficulté

| Difficulté | Nombre de quêtes | Valeur visée | Exemples du livre |
|---|---|---|---|
| 1 | 46 | petite | torches, planches, 2 à 4 lingots courants, flacons |
| 2 | 81 | modérée | 3 à 6 lingots d'acier ou de cuivre, bloc de nourriture, fragments de Mese |
| 3 | 47 | notable | lingot d'or, carburant, composants du chapitre |
| 4 | 17 | forte | bloc d'acier, bidon de carburant, 2 lingots d'or |
| 5 | 2 | exceptionnelle | 1 diamant + titre (mithril au chapitre 4, œuf de dragon au chapitre 22) |

## 3. Plafonds sur l'ensemble du livre (contrôlés par `tools/validate_quests.py`)

| Objet | Plafond | Distribué |
|---|---|---|
| `default:diamond` | 4 | 3 (chapitres 4, 5 et 22) |
| `default:mese_crystal` | 6 | 2 (chapitre 4) — plus 25 fragments, soit moins de 3 cristaux |
| `default:mese`, `default:diamondblock` | 0 | 0 |
| `default:goldblock` | 1 | 0 |
| `moreores:mithril_*` | 2 | 0 |
| Minegeld (valeur totale) | 600 | 130 |

Autres totaux notables : 91 lingots d'acier et 2 blocs d'acier, 43 lingots d'or (1 à 2 par quête finale), 26 lingots
de cuivre, 8 d'étain, 4 de bronze, 90 torches.

## 4. Récompenses de difficulté 4 et 5 (justification)

| Quête | Récompense | Pourquoi |
|---|---|---|
| `ch04.diamond` | 1 cristal de Mese | premier contact avec la Mese, nécessaire aux machines |
| `ch04.mithril` (5) | 1 diamant + « Maître mineur » | le minerai le plus profond du jeu ; un seul diamant |
| `ch05.other_power` | 1 diamant + « Seigneur des anneaux » | fin d'un chapitre coûteux en gemmes |
| `ch10.delivery_van` | 1 bloc d'acier + « As du volant » | rembourse en partie la fourgonnette (bloc d'acier dans la recette) |
| `ch11.steam_engine` | 2 lingots d'or + « Âme du rail » | locomotive très coûteuse, objet confié à un conducteur agréé |
| `ch13.first_plane` | 1 bidon de carburant | de quoi faire le premier plein de l'avion |
| `ch14.motorboat` | 1 bidon de carburant | idem pour le bateau |
| `ch14.nautilus` | 6 blocs de verre | matériau du hublot, sans valeur rare |
| `ch17.mv_machine`, `ch17.workshop` | 2 lingots d'or (+ titre) | moyenne tension et atelier : inox, diamant, profondeur |
| `ch18.ta3_oil`, `ch18.ta3_robot`, `ch18.ta4_solar` | 1 à 2 lingots d'or, 4 d'acier (+ titre) | paliers avancés de Techage |
| `ch22.dragon_hoard` | 12 torches | le magot du dragon est déjà une récompense en soi |
| `ch22.wyvern_ride` | 1 lingot d'or | wyverne rare et dangereuse |
| `ch22.dragon_scales` | 2 lingots d'or | affronter un dragon est dangereux ; or courant, rien de rare |
| `ch22.dragon_egg` (5) | 1 diamant + « Fléau des dragons » | œuf d'un dragon sauvage adulte, une chance sur six ; un seul diamant |
| `ch23.dino_ride` | 2 lingots d'or + titre | fin d'une longue chaîne fossile → ADN → œuf → adulte |
| `ch24.shaper` | 4 lingots d'acier | la machine demande un diamant et deux blocs d'acier |

## 5. Titres honorifiques (quêtes finales)

Apprenti de Minerland, Propriétaire terrien, Main verte, Maître mineur, Seigneur des anneaux (chapitres 1 à 5,
existants) ; Légende de l'écurie, Toque d'or, Âme d'artiste, Sens des affaires, As du volant, Âme du rail,
Ticket gagnant, Ailes de Minerland, Pied marin, Tête dans les nuages, Fée électricité, Capitaine d'industrie,
Visionnaire, Esprit logique, Cœur de braise, Cœur de cristal, Souffle de dragon, Mémoire du Jurassique,
Pierre angulaire, Maire de Minerland, Fléau des dragons (chapitre 22, quête de l'œuf ; « Souffle de dragon » reste la
récompense de la forge).
