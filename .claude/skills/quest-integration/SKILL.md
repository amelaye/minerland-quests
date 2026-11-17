---
name: quest-integration
description: Intégration des événements des mods tiers (agriculture, minage, technic, techage, transports, rings, nether, commerce, animaux…) dans le moteur de quêtes via des adaptateurs. À utiliser pour écrire ou revoir minerland_quests/integrations/*.lua.
---

# Intégrations des mods tiers

## Principe
Le moteur gère nativement `dig`, `place`, `craft`, `eat`. Une intégration n'existe que si un événement
**n'est pas** couvert par ces callbacks. Elle émet un événement normalisé :
```lua
minerland_quests.events.emit(player_name, "custom", "rings:flight", 1, { source = "goops_rings" })
```
Le moteur se charge du reste (prérequis, compteurs, récompenses). Une intégration ne touche jamais
directement au stockage ni aux récompenses.

## Squelette d'un fichier `integrations/<mod>.lua`
```lua
-- Intégration <mod> : <ce qui est détecté>, <pourquoi les callbacks natifs ne suffisent pas>.
local Q = minerland_quests
if not core.get_modpath("<nom mod.conf>") then return end
Q.compat.declare_integration("<nom>", { keys = {"<mod>:<event>"} })
-- … observation non invasive …
```
Chargement : `init.lua` charge tous les fichiers d'`integrations/` ; chacun sort immédiatement si son mod est absent.

## Ordre de préférence (du moins au plus invasif)
1. **Callback public du mod** (ex. `armor:register_on_equip`, `mobs` callbacks, API smartshop).
2. **Lecture d'un état public** à intervalle lent (≥ 1 s, seulement joueurs connectés, O(joueurs)) — ex. `rings.users`.
3. **Enveloppe d'un callback de définition** (`core.override_item(name, {on_use = wrapper})`) :
   - appeler l'original **en premier**, avec les mêmes arguments, et retourner **exactement** sa valeur ;
   - ne s'appliquer qu'aux objets listés ; `pcall` autour de notre code seulement ;
   - justifier dans l'en-tête du fichier et dans `docs/COMPATIBILITY.md` ; tester dans `tests/`.
Interdit : remplacer une fonction globale d'un autre mod, modifier ses tables internes, scanner des zones.

## Faux joueurs et machines
Utiliser `Q.events.real_player(obj)` : rejette nil, entités, `is_fake_player`, et objets dont le nom ne
correspond pas au joueur connecté. Les nœuds posés par pipeworks/techage/digtron ne comptent pas.

## Notes par domaine (à compléter par l'audit)
- **Farming** : récolte = `dig` du stade final (`farming:wheat_8`) ; semis = `place` des graines si le mod
  passe par `item_place_node` (vérifier `farming.place_seed`) ; terre labourée = `place`? Non : la houe
  transforme le nœud via `set_node` → pas d'événement `place` ; utiliser le craft de la houe ou une intégration.
- **Rings** : vol = état `rings.users[name].fx.name == "Flight Privilege"` (lecture lente) ; équipement =
  `armor:register_on_equip`.
- **Technic / Techage / Pipeworks** : pose des machines = `place` (vérifier `after_place_node`), fabrication = `craft`.
  La production d'énergie n'est pas attribuable de façon fiable à un joueur → ne pas en faire une quête.
- **Véhicules (APercy, vehicles, bike)** : ce sont des entités ; la fabrication (`craft`) est fiable,
  la pose/la conduite ne le sont pas sans adaptateur.
- **Advtrains** : pose de rails soumise à privilèges sur Minerland → quêtes de fabrication.
- **Smartshop** : ne déclarer une transaction que si l'API expose un callback d'achat fiable.
- **Mobs** : vérifier les callbacks de `mobs_redo` (capture, apprivoisement, nourrissage) avant d'en faire des quêtes.
