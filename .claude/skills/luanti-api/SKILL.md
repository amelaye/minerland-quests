---
name: luanti-api
description: Expertise de l'API Lua de Luanti 5.15.1 (callbacks, enregistrement, joueurs, formspecs, inventaires, mod storage, dépendances). À utiliser avant d'écrire ou de relire du code Lua du mod minerland_quests, ou pour vérifier qu'une fonction moteur existe et se comporte comme supposé.
---

# Luanti API — aide-mémoire vérifié pour minerland_quests

## Règle d'or
Ne jamais supposer une API. Vérifier dans l'ordre :
1. `.audit_src/minetest_game/` pour les mods du jeu (`default`, `doors`, `beds`, `farming`…).
2. La documentation officielle `lua_api.md` (https://github.com/luanti-org/luanti/blob/5.15.1/doc/lua_api.md).
3. Si doute persistant : protéger l'appel (`if core.xxx then … end`) et le documenter.

## Callbacks moteur utilisés par le mod (signatures)
| Callback | Signature | Pièges |
|---|---|---|
| `core.register_on_dignode(f)` | `f(pos, oldnode, digger)` | `digger` peut être nil, une entité, ou un **faux joueur** (pipeworks/fakelib/techage). Les métadonnées du nœud sont déjà détruites. |
| `core.register_on_placenode(f)` | `f(pos, newnode, placer, oldnode, itemstack, pointed_thing)` | Seuls les `on_place` passant par `core.item_place_node` déclenchent ce callback. Portes, lits, nœuds multi-blocs : **vérifier** dans le source. Retourner `true` consomme l'objet en créatif : ne rien retourner. |
| `core.register_on_craft(f)` | `f(itemstack, player, old_craft_grid, craft_inv)` | Appelé une fois par craft (y compris shift-clic, une fois par résultat). Ne pas modifier `itemstack` : retourner `nil`. |
| `core.register_on_item_eat(f)` | `f(hp_change, replace_with_item, itemstack, user, pointed_thing)` | Uniquement pour les objets qui passent par `core.item_eat`. Retourner `nil`. |
| `core.register_on_joinplayer(f)` / `register_on_leaveplayer(f)` | `f(player, last_login)` / `f(player, timed_out)` | Sauvegarder à la sortie. |
| `core.register_on_shutdown(f)` | `f()` | Sauvegarde finale synchrone. |
| `core.register_on_mods_loaded(f)` | `f()` | Moment où **tous** les objets sont enregistrés : valider les références ici. |
| `core.register_on_player_receive_fields(f)` | `f(player, formname, fields)` | Page d'inventaire = `formname == ""`. Retourner `true` seulement si le formulaire nous appartient. |
| `core.register_globalstep(f)` | `f(dtime)` | Accumuler `dtime` et agir à intervalle (≥ 1 s). Jamais de travail lourd par pas. |

## Joueurs réels vs faux joueurs
```lua
local function real_player(obj)
	if not obj or not obj.is_player or not obj:is_player() then return nil end
	if obj.is_fake_player then return nil end            -- fakelib / pipeworks
	local name = obj:get_player_name()
	if name == "" then return nil end
	local live = core.get_player_by_name(name)
	if live ~= obj then return nil end                    -- faux joueur portant un nom réel
	return name
end
```

## Persistance
- `core.get_mod_storage()` → `StorageRef` (`get_string/set_string/get_keys/contains`). Une clé par joueur.
- Sérialiser avec `core.write_json`/`core.parse_json` (compact, sans exécution de code) plutôt que `core.serialize`.
- Le moteur écrit le stockage sur disque périodiquement et à l'arrêt ; un crash dur peut perdre les dernières secondes.

## Inventaires
- `player:get_inventory()` ; `inv:room_for_item("main", stack)` ne tient pas compte des autres piles à ajouter :
  pour plusieurs piles, simuler sur une copie de la liste (`inv:get_list` → `InvRef` détaché) ou ajouter puis
  vérifier le reste retourné par `add_item` et annuler.
- `ItemStack(str):is_known()` pour vérifier qu'un objet existe.

## Formspecs (voir aussi skill `formspec-ui`)
- `core.show_formspec(name, formname, fs)` ; `core.close_formspec(name, formname)`.
- Toujours `core.formspec_escape` sur le texte dynamique.
- `formspec_version[6]` : `scroll_container`, `style` avec états `:hovered/:pressed`, `image_button` sans bordure
  (`noclip`, `border=false`), `hypertext`, `box` coloré, `tooltip[x,y;w,h;…]`.

## Dépendances
- `mod.conf` : `optional_depends` garantit l'ordre de chargement sans rendre le mod obligatoire.
- Tester la présence : `core.get_modpath("nom")` (nom de `mod.conf`, pas du dossier).
- `core.get_modpath` d'un mod non activé dans `world.mt` renvoie `nil` → statut « indisponible ».

## Messages et HUD
- `core.chat_send_player(name, msg)` ; `core.colorize("#hex", txt)`.
- HUD : `player:hud_add({type="image"|"text", …})` (champ `type`, `hud_elem_type` est déprécié).
- `core.after(sec, f, …)` pour retirer un toast.
