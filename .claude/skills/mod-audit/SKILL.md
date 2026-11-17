---
name: mod-audit
description: Méthode d'audit des mods Luanti installés sur Minerland (objets enregistrés, recettes, callbacks, API publiques, dépendances, incompatibilités). À utiliser pour vérifier un identifiant d'objet, comprendre la mécanique d'un mod ou alimenter docs/MOD_AUDIT.md.
---

# Audit des mods

## Sources
- Liste réelle des mods du serveur : section « Inventaire serveur » de `docs/MOD_AUDIT.md`.
- Sources publiques clonées : `.audit_src/<mod>/` (manifeste `tools/audit_sources.txt`, récupération
  `tools/fetch_sources.sh`). **Lecture seule.**
- Sur le serveur réel, l'administratrice peut lancer `python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods`
  (lecture seule) pour régénérer l'inventaire depuis les sources réellement installées.

## Procédure pour un mod
1. `mod.conf` : **nom réel du mod** (`name =`), `depends`, `optional_depends`. Le dossier peut avoir un autre nom.
2. Objets : `python3 tools/audit_mods.py .audit_src --mod <dossier> --items` liste les appels
   `register_node/craftitem/tool/armor/register_*` avec fichier:ligne. Les noms construits dynamiquement
   (boucles, concaténations) doivent être **reconstitués à la main** en lisant la boucle.
3. Recettes : `--crafts` liste les `register_craft`. Vérifier qu'un joueur **peut** fabriquer la cible
   (ingrédients existants, pas de recette réservée à l'admin).
4. Événements détectables : chercher `on_place`, `after_place_node`, `on_construct`, `on_use`, `on_rightclick`,
   `register_on_*`, et les callbacks publics (`*.register_on_*`, tables `callbacks`).
   - Un `on_place` personnalisé qui n'appelle pas `core.item_place_node` **ne déclenche pas** `register_on_placenode`.
   - Les entités (véhicules, wagons, mobs) ne sont pas des nœuds : leur pose n'est pas un événement `place`.
5. Privilèges : chercher `check_player_privs`, `privs =` ; une action réservée (ex. `train_operator`,
   `track_builder` d'advtrains) ne peut pas être une quête pour joueur ordinaire.
6. Fiabilité : classer chaque action en **fiable** (callback moteur direct), **adaptateur** (API publique du mod),
   **impossible** (aucun événement côté serveur). Les impossibles sont remplacées par une action fiable.

## Format de sortie (par mod, dans docs/audit/*.md puis docs/MOD_AUDIT.md)
```
### <dossier> (mod `<nom mod.conf>`)
- Rôle : …
- Présence : installé (liste serveur) / source auditée : oui (commit <sha court>) / non joignable
- Dépendances : …
- Objets utiles : `mod:item` — description — source `fichier.lua:ligne`
- Événements détectables : craft de X (fiable), pose de Y (fiable, item_place_node), …
- Mécanismes particuliers / limitations : …
- Quêtes possibles : …
```

## Pièges connus
- `goops_rings` (dossier `rings`) : gemmes aliasées vers `glooptest:*_gem` si glooptest est présent.
- Variantes de mods homonymes (nether, smartshop, scaffolding, xdecor) : identifier la variante par `mod.conf`.
- Objets enregistrés seulement si un mod optionnel est présent : le noter.
- Ne jamais déduire un identifiant d'une texture ou d'une description.
