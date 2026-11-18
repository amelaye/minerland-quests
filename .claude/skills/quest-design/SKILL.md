---
name: quest-design
description: Conception des quêtes du Grand Livre (objectifs détectables, progression pédagogique, prérequis, difficulté, récompenses, cohérence, détection des objectifs impossibles). À utiliser pour créer, revoir ou réorganiser des quêtes dans minerland_quests/quests/.
---

# Conception des quêtes

## Format d'une quête (données uniquement)
```lua
local Q = minerland_quests
Q.register_quest({
	id = "ch04.gold_rush",             -- immuable, préfixe = chapitre
	chapter = "ch04",
	title = "La ruée vers l'or",
	description = "Certaines richesses ne demandent qu'à être découvertes. À toi de creuser !",
	hint = "L'or se trouve en profondeur, sous -64.",  -- facultatif : aide d'utilisation du mod
	icon = "default:gold_lump",        -- objet réel (item_image) ; sinon texture "mlq_*.png"
	difficulty = 2,                    -- 1 facile … 5 expert
	trigger = { type = "dig", items = {"default:stone_with_gold"}, count = 1 },
	requires = {"ch04.iron_age"},      -- prérequis (ET logique)
	mods = {"default"},                -- mods requis (nom mod.conf) ; absents → « indisponible »
	reward = { items = {"default:torch 16"}, title = nil },
	pos = nil,                         -- {col,row} facultatif ; sinon disposition automatique
})
```
Types de déclencheurs :
- `dig` : nœuds creusés par un vrai joueur (`items` ou `groups`), hors nœuds posés par un joueur.
- `place` : nœuds posés par un vrai joueur ; `distinct = true` (défaut si count>1) compte des positions distinctes.
- `craft` : objets fabriqués dans la grille de craft ; compte le nombre d'objets produits.
- `eat` : objets mangés/bus via `core.item_eat`.
- `custom` : clé émise par une intégration (`key = "rings:flight"`).
Plusieurs objets possibles : `items = {...}` (OU). Groupes : `groups = {"wood"}`.

## Règles
1. **Détectable** : la quête doit avoir un trigger d'un type ci-dessus, et l'objet doit exister (audit).
2. **Personnelle** : jamais « posséder X ». Recevoir un objet ne doit rien valider.
3. **Élémentaire** : un objectif multiple est découpé en quêtes simples, une récompense chacune.
4. **Pédagogique** : chaque chapitre va du geste le plus simple à l'usage avancé du mod ; le `hint`
   explique comment faire (recette, outil, emplacement).
5. **Accessible** : pas d'action exigeant un privilège non accordé aux joueurs (ex. pose de rails advtrains si
   le serveur la restreint → préférer la fabrication des éléments). Pas de coordonnée, pas de zone balisée.
6. **Indépendance** : seuls les chapitres 1-2 forment le tronc commun. Les autres chapitres commencent par
   une quête racine sans prérequis hors chapitre (sauf justification).
7. **Fin de chapitre** : une quête « finale » (`final = true`) dépend des branches principales ; elle peut porter un titre honorifique.
8. **Taille** : 4 à 10 quêtes par chapitre (cible : 80–120 au total), arbre ≤ 6 colonnes × 4 lignes (seuil `MAX_COLS`/`MAX_ROWS` de `tools/validate_quests.py`).
9. **Ton** : français vivant, léger, clin d'œil roleplay ; 1 à 2 phrases de description ; titre ≤ 32 caractères.

## Détection des objectifs impossibles
Rejeter (ou remplacer) une quête si :
- l'objet n'apparaît pas dans `.audit_src` (ou seulement via alias douteux) ;
- la pose se fait par un `on_place` qui n'appelle pas `item_place_node` (pour `place`) ;
- la cible est une entité (véhicule, mob) pour `place`/`dig` ;
- l'objet n'a pas de recette accessible (pour `craft`) ou n'est pas comestible via `item_eat` (pour `eat`) ;
- le minerai ne génère pas dans le monde (pour `dig`).
`make validate` contrôle les identifiants, les prérequis, les cycles et les quêtes inaccessibles.

## Difficulté indicative
1 : geste de base (quelques minutes). 2 : recette simple. 3 : ressources de profondeur ou chaîne de crafts.
4 : machine / matériau rare. 5 : projet long (techage âge 3+, ligne complète).
