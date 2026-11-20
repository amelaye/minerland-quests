---
name: reward-balancing
description: Équilibrage économique des récompenses de quêtes (rareté, utilité, progression, inflation, abus, cohérence avec la difficulté). À utiliser pour choisir ou revoir le champ reward d'une quête et tenir docs/REWARDS.md à jour.
---

# Équilibrage des récompenses

## Contexte Minerland
Serveur pacifique, faim désactivée, équipement de départ fourni, économie basée sur `currency`
(billets `currency:minegeld`, `currency:minegeld_5`, `_10`, …) et les boutiques `smartshop`/`atm`.
Certains bâtisseurs ont le privilège `give` : les objets courants ont peu de valeur pour eux, mais les
récompenses doivent rester justes pour les joueurs ordinaires.

## Barème par difficulté (valeur indicative en Minegeld équivalents)
Barème de départ. Le barème **appliqué**, plus modeste, et la règle des deux niveaux contrôlée par `make validate` sont
dans `docs/REWARDS.md` §2 : s'y conformer. Pas de prix officiel sur Minerland (on s'enrichit en minant, les prix se
fixent entre joueurs) : ne pas demander de cours de référence ni relever le barème.

| Difficulté | Valeur cible | Exemples |
|---|---|---|
| 1 | 1–3 | torches, pain, planches, 1 Minegeld |
| 2 | 3–8 | outils en fer, nourriture élaborée, 5 Minegeld |
| 3 | 8–20 | lingots de cuivre/étain, composants basiques du chapitre, 10 Minegeld |
| 4 | 20–50 | composants avancés (pas de machine complète), 20–25 Minegeld |
| 5 / finale | 50–100 + titre | titre honorifique + objet décoratif rare ou composants |

## Règles
1. Unicité : une récompense par quête et par joueur (journal persistant) — jamais renouvelable.
2. Pas de minerais précieux en masse : diamant ≤ 1, mese ≤ 2 cristaux, mithril ≤ 1 lingot, sur l'ensemble du livre
   chaque catégorie rare est comptée (`tools/validate_quests.py --economy`).
3. Pas d'objet très puissant en début de parcours (pas d'outil en diamant avant la difficulté 4).
4. Aucun privilège, jamais de `fly` permanent, pas d'objet créatif/admin.
5. Ne pas récompenser une machine par la même machine ; préférer les **composants du palier suivant**
   ou des consommables utiles au chapitre (carburant, rails, câbles).
6. Pas d'incitation à fabriquer en masse des machines coûteuses : quantité de pose ≤ 1 pour les machines.
7. Récompenses thématiques : un chapitre de cuisine donne des ingrédients, le ferroviaire des éléments de voie, etc.
8. Chaque objet de récompense doit exister (validé au chargement et par `make validate`) ; objet absent → retiré
   de la récompense avec avertissement, la quête reste jouable, l'interface l'indique.
9. Titres honorifiques : propres au mod, affichés dans le livre (`reward.title`) ; aucune mécanique de jeu.
10. Documenter toute récompense de difficulté ≥ 4 dans `docs/REWARDS.md` (justification).

## Monnaie
Les billets `currency:minegeld*` ne sont distribués que si `currency` est présent ; montant total du livre
plafonné (indicatif ≤ 500 Mg). Le validateur additionne et alerte au-delà.

## Anti-abus
- Comptage `place` sur positions distinctes ; `dig` ignore les nœuds posés par un joueur.
- File de livraison : inventaire plein → récompense mise en attente persistante, jamais jetée au sol.
- Le journal `rewarded[qid]` est écrit **avant** la livraison ; une livraison partielle est impossible
  (tout ou rien par récompense).
