---
name: formspec-ui
description: Conception d'interfaces Formspec Luanti pour le Grand Livre (mise en page, arbre interactif, icônes, panneaux, couleurs d'état, défilement, clics, intégration Unified Inventory). À utiliser pour toute modification de minerland_quests/ui/.
---

# Formspec UI — Grand Livre

## Deux conteneurs, un seul rendu
- `ui/views.lua` produit les éléments d'une vue dans un **rectangle** `{x, y, w, h}` donné, avec `opts.compact`.
- `ui/book.lua` : formspec autonome `formspec_version[6]`, taille 20×12.5, fond parchemin.
- `ui/inventory.lua` : page Unified Inventory. UI impose `formspec_version[4]`, `size[17.75,12.25]` (mode complet)
  ou `size[14,9.75]` (mode lite) ; boutons d'onglets en bas (y ≈ 11.0 complet, colonne droite en lite).
  Utiliser `draw_inventory = false, draw_item_list = false`. Zone utile : complet `0.3,0.3 → 17.4×10.5` ;
  lite `0.2,0.2 → 10.1×9.3`.
- L'état de navigation (partie, chapitre, quête sélectionnée, défilement) est **par joueur et partagé** :
  ouvrir le livre depuis UI conserve la vue, et inversement.

## Éléments autorisés (v4 minimum)
`image`, `image_button`, `item_image`, `item_image_button`, `box`, `label`, `textarea` (lecture seule si nom vide),
`scroll_container`, `scrollbar`, `scrollbaroptions`, `style`, `style_type`, `tooltip`, `background9`.
`hypertext` seulement dans le livre (v6). Pas d'`animated_image` dans UI.

## Arbre de quêtes
- Disposition calculée par `core/graph.lua` : colonne = profondeur (plus long chemin depuis une racine),
  ligne = ordre stable dans la colonne ; `pos` explicite prioritaire.
- Nœud = `image` cadre d'état (`mlq_frame_<state>.png`) + `item_image` de l'icône + `image_button` transparent
  par-dessus (`mlq_q_<id>`) + badge d'état (coche, cadenas, croix) + `tooltip`.
- Connexions : segments orthogonaux en `box[]` (parent → milieu horizontal → enfant), couleur selon l'état :
  vert si parent terminé, or si enfant disponible, gris sinon. Dessinées **avant** les nœuds.
- Défilement : si la largeur dépasse la zone → `scroll_container` horizontal + `scrollbar` ; si la hauteur dépasse
  → vertical. Le validateur signale les chapitres qui dépasseraient dans les deux axes.
- Pas de faux zoom, pas de glisser-déposer.

## États visuels
| État | Cadre | Icône | Badge | Texte |
|---|---|---|---|---|
| locked | gris | désaturée (`^[colorize:#888:160`) via image de fond, item_image assombri par voile | cadenas | prérequis listés |
| available | or lumineux | couleurs | point d'exclamation | objectif clair |
| done | vert | couleurs | coche verte | date + état de livraison |
| unavailable | rouge brique | voile | croix | « mod X absent » |

## Clics et sécurité
- Tous les champs commencent par `mlq_`. Le gestionnaire **ignore** tout id inconnu.
- Un clic ne peut que naviguer ou relancer une livraison en attente ; jamais valider une quête.
- `fields.quit` → marquer le livre fermé (arrête les rafraîchissements en direct).

## Rafraîchissement en direct
À la complétion d'une quête : si le livre est ouvert → `core.show_formspec` avec la même vue ;
si la page UI courante est la nôtre → `unified_inventory.set_inventory_formspec(player, "minerland_quests")`.
Débouncer (≤ 1 rafraîchissement/0,5 s).

## Accessibilité
- Texte ≥ taille normale, contraste brun foncé sur crème (`#3b2412` sur `#f3e6c4`).
- Chaque nœud a un `tooltip` (titre + état), utile aussi au clavier/manette.
- Tester en mode lite d'UI (`unified_inventory_lite = true`) et petite fenêtre (≈ 1024×600).
