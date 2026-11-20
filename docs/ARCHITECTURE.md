# Architecture du Grand Livre des Quêtes (`minerland_quests`)

Ce document décrit l'architecture du mod. Il est vérifié contre le code (`minerland_quests/`) et les tests simulés
(`tests/`). Toute décision technique non triviale ajoute une ligne à la section **Décisions** (§13).

## 1. Vue d'ensemble

```
 ACTION du joueur ──► DÉTECTION ─────────────► VALIDATION ─────────► RÉCOMPENSE ──────────► COCHE VERTE
 (creuser, poser,     callbacks moteur          progress.handle_event  rewards.grant (journal)  ui.refresh +
  fabriquer, manger,  (core/events.lua) ou      état « disponible » ?  rewards.deliver          notification
  action d'un mod)    adaptateur (integrations/) compteur, distinct    (file persistante)       (HUD, chat)
```

Principes :

- **Le serveur seul décide.** Aucun champ de formulaire ne peut valider une quête : l'interface ne sert qu'à naviguer.
- **Données ≠ moteur.** Une quête est une table de données (`quests/<partie>/chNN_*.lua`) ; ajouter une quête ne touche
  jamais au cœur.
- **Dégradation propre.** Une quête dont le mod, l'objet ou l'intégration manque devient « Indisponible » au lieu de
  casser le livre ; ses dépendants ignorent ce prérequis.
- **Au plus une fois.** Une récompense est journalisée avant d'être livrée : elle peut, au pire, être perdue lors d'un
  crash dur, jamais dupliquée.

## 2. Modules et ordre de chargement

`init.lua` ne contient aucune logique : il crée la seule variable globale `minerland_quests` puis charge, dans l'ordre :

| Couche | Fichier | Rôle |
|---|---|---|
| cœur | `core/util.lua` | journal, réglages, listes, alias d'objets, positions, dates |
| | `core/i18n.lua` | langue de chaque joueur, traduction côté serveur, marquage des textes (§10) |
| | `core/registry.lua` | enregistrement et validation des parties, chapitres, quêtes ; `finalize()` |
| | `core/graph.lua` | prérequis, cycles, accessibilité, disposition de l'arbre, enfants |
| | `core/storage.lua` | persistance versionnée (mod storage), migrations, ensemble « blocs posés » |
| | `core/compat.lua` | présence des mods/objets, statut « indisponible », **API des intégrations** |
| | `core/progress.lua` | états, compteurs, complétion (logique pure) |
| | `core/rewards.lua` | attribution, journal anti-doublon, file de livraison |
| | `core/events.lua` | index des déclencheurs, callbacks moteur, `emit` |
| | `core/admin.lua` | privilège, commandes joueur et administration |
| interface | `ui/theme.lua` | couleurs, primitives formspec échappées |
| | `ui/notifications.lua` | toast HUD, chat, son |
| | `ui/views.lua` | vues partagées (accueil, partie, chapitre/arbre, fiche) et navigation |
| | `ui/book.lua` | formulaire « livre » (objet et commande) |
| | `ui/inventory.lua` | bouton et page Unified Inventory |
| | `ui/items.lua` | objets du mod : livre, charte de ville |
| données | `quests/parts.lua` puis `quests/<partie>/*.lua` | 6 parties, 25 chapitres, quêtes |
| intégrations | `integrations/*.lua` | un fichier par mod tiers, quitte aussitôt si le mod est absent |

Puis `core.register_on_mods_loaded(Q.finalize)` : `graph.check_all()` → `compat.finalize()` → `events.build_index()`.
Avant la finalisation, aucun événement n'est traité (`Q.finalized`).

## 3. Données des quêtes

### 3.1 Parties et chapitres
```lua
Q.register_part{ id = "transport", order = 3, numeral = "III", title = "…", subtitle = "…", illustration = "…png" }
Q.register_chapter{ id = "ch11", part = "transport", title = "…", icon = "advtrains:…", intro = "…" }
```
La structure (6 parties, 25 chapitres) est fixe et déclarée dans `quests/parts.lua`. Emblème par défaut :
`mlq_emblem_<partie>.png`.

### 3.2 Quête
```lua
Q.register_quest{
	id = "ch04.gold_rush",            -- chNN.slug, IMMUABLE (la progression y est attachée)
	title = "La ruée vers l'or",      -- ≤ 34 caractères conseillés
	description = "…", objective = "…" (facultatif, sinon généré), hint = "…" (facultatif),
	icon = "default:gold_lump",       -- objet (item_image) ou texture .png ; sinon 1re cible
	difficulty = 1..5,
	trigger = { type = "dig"|"place"|"craft"|"eat"|"custom",
	            items = {…}, groups = {…},        -- cibles (dig/place/craft/eat), alias résolus
	            key = "mod:événement",            -- custom uniquement
	            count = n, distinct = bool },     -- place : distinct par défaut si count > 1
	requires = { "ch04.iron", … },    -- prérequis (même chapitre de préférence)
	mods = { "moreores" },            -- noms mod.conf requis
	reward = { items = { "default:gold_ingot 3" }, title = "Titre honorifique" },
	final = true,                     -- quête de clôture du chapitre
	pos = { col, ligne },             -- facultatif : force la position dans l'arbre
}
```
Validation à l'enregistrement (`registry.lua`) : format d'identifiant, chapitre existant, type de déclencheur,
cibles non vides, quantités de récompense 1–999, difficulté 1–5. Une erreur de données = erreur claire au chargement.

Validation statique hors moteur : `tools/validate_quests.py` (ids, prérequis, cycles, accessibilité, chaque objet
présent dans l'audit des sources, plafonds économiques, taille des arbres ≤ 6×4, quête finale par chapitre).

### 3.3 Résolution à la finalisation (`compat.finalize`)
Pour chaque quête : mods requis présents ? cibles résolues (alias, groupes → objets enregistrés) ? intégration active
pour une clé custom (préfixe de la clé = nom déclaré) ? Sinon `q.unavailable = "raison lisible"`.
Les récompenses inexistantes sont retirées (`q.reward_items` / `q.reward_missing`, journalisées). L'icône est résolue.

## 4. Moteur événementiel

### 4.1 Détection (`core/events.lua`)
| Type | Callback moteur | Règles |
|---|---|---|
| `dig` | `register_on_dignode` | vrai joueur ; un nœud-cible **posé** (par quiconque, machine comprise) puis recreusé ne compte pas |
| `place` | `register_on_placenode` | vrai joueur ; positions distinctes si `count > 1` (anti pose/reprise) |
| `craft` | `register_on_craft` | grille standard seulement ; quantité = taille de la pile produite ; alias résolus |
| `eat` | `register_on_item_eat` | objets passant par `core.item_eat` |
| `custom` | `events.emit` appelé par un adaptateur | clé `<intégration>:<événement>` |

`events.real_player(obj)` rejette : `nil`, non-joueurs, faux joueurs (`is_fake_player` : fakelib, pipeworks, techage,
digtron), et tout objet qui n'est pas **le** joueur connecté de ce nom. Le réglage `count_creative` permet d'ignorer
les joueurs en mode créatif.

Coût : chaque callback commence par une recherche O(1) dans l'index `index[type][clé]` construit à la finalisation ;
un événement sans quête associée s'arrête là. Les blocs posés ne sont mémorisés que s'ils sont cibles d'une quête `dig`
(file FIFO plafonnée par `placed_cap`, 20 000 par défaut).

### 4.2 Validation (`progress.handle_event`)
1. Les quêtes candidates de `(type, clé)` sont lues dans l'index.
2. Leur état est **figé avant** l'événement : seule une quête déjà « disponible » progresse. Une action ne compte donc
   jamais pour la quête qu'elle vient de débloquer (testé : `tests/test_integration_api.lua`).
3. Compteur (`prog`), positions distinctes (`spots`) pour la pose, puis `complete()` quand `count` est atteint.

États : `locked` (prérequis manquants), `available`, `done`, `unavailable` (mod/objet/intégration absent).
Un prérequis indisponible sur le serveur est ignoré.

### 4.3 Complétion (`progress.complete`)
`done[qid] = horodatage` → écriture immédiate → `rewards.grant` → calcul des quêtes nouvellement débloquées et de la
fin de chapitre → notification → rappels `Q.register_on_complete(f(name, quest, chapter_done))` (protégés par `pcall`)
→ rafraîchissement de l'interface.

## 5. Récompenses (`core/rewards.lua`)

- `grant(name, q)` : si `rewarded[qid]` existe, rien. Sinon `rewarded[qid]`, titre éventuel, entrée dans `pending`,
  **écriture immédiate**, puis tentative de livraison.
- `deliver(name)` : traite la file dans l'ordre ; une entrée n'est livrée que si **toute** la récompense tient dans
  l'inventaire (simulation sur une copie de `main`). Journal d'abord (`pending` retiré, `delivered[qid]`, écriture),
  objets ensuite. Un reste inattendu est remis en file.
- Relances : à la connexion (+3 s) et toutes les 10 s pour les seuls joueurs ayant une file non vide.
  Message « inventaire plein » au plus toutes les 2 minutes. Bouton du livre et `/mlq_reward` : relance manuelle.
- `reset` (test seulement) n'efface jamais le journal : une quête refaite n'est pas récompensée deux fois.
- Plafonds économiques sur l'ensemble du livre (validateur) : diamant ≤ 4, cristal de mese ≤ 6, mithril ≤ 2,
  bloc d'or ≤ 1, Minegeld ≤ 600, aucun bloc de diamant ou de mese. Aucun privilège en récompense.
- Limite connue : inventaire et mod storage sont sauvegardés par le moteur à des instants différents ; un crash dur entre
  les deux peut perdre une livraison (jamais la dupliquer).

## 6. Intégrations (adaptateurs de mods tiers)

### 6.1 API (`core/compat.lua`, `core/events.lua`)
| Fonction | Usage |
|---|---|
| `Q.compat.declare_integration(nom, { keys = {…} })` | active les quêtes `custom` dont la clé commence par `nom:` |
| `Q.events.emit(joueur, "custom", "nom:événement", n, ctx)` | émet un événement (joueur réel déjà vérifié) |
| `Q.events.real_player(obj)` | nom du joueur réel, ou `nil` (faux joueur, machine, entité) |
| `Q.compat.wrap_callback(objet, champ, { before, after }, repli)` | enveloppe un callback de **définition** : original appelé en premier, toutes ses valeurs de retour renvoyées, `before`/`after` protégés par `pcall`, un seul habillage par champ |
| `Q.compat.register_poll(id, intervalle, fn(player, name))` | lecture lente d'un **état public** ; un seul globalstep partagé ; intervalle ≥ 1 s |

Préférence, du moins invasif au plus invasif : callback/API publique du mod > lecture lente d'un état public >
enveloppe d'un callback de définition (justifiée en tête du fichier, avec `fichier:ligne` de la source auditée).
Interdits : remplacer une fonction globale d'un autre mod, scanner la carte, parcourir des inventaires.

Chaque intégration : un fichier `integrations/<nom>.lua`, sortie immédiate si le mod est absent, en-tête listant les
clés émises et la méthode, test simulé dans `tests/`.

### 6.2 Intégrations en service
| Fichier | Clés | Méthode |
|---|---|---|
| `farming.lua` | `farming:till`, `farming:sow` | enveloppe `on_use` des houes / `on_place` des graines |
| `rings.lua` | `rings:equip`, `rings:activate`, `rings:flight`, `rings:activate_other` | `armor:register_on_equip` + sonde `rings.users` |
| `rides.lua` | `rides:horse`, `wyvern`, `dinosaur`, `bike`, `car`, `train`, `metro`, `ferry`, `aviation`, `boat`, `chairlift`, `elevator` | sonde (2 s) `player:get_attach()` → nom d'entité du parent, siège intermédiaire franchi (automobiles, avions airutils, bateau à moteur, chalutier) ; trains : voitures de voyageurs seulement ; voitures : conducteur seulement quand le mod l'indique. Toujours déclarée (API moteur seule) |
| `mobs.lua` | `mobs:tame`, `mobs:capture` (+ `:<entité>`) | enveloppe du `on_rightclick` des entités de mobs (`_cmi_is_mob`, PNJ exclus), comparaison avant/après |
| `smartshop.lua` | `smartshop:purchase`, `smartshop:sale` | API publique `smartshop.api.register_on_purchase` ; hors achat chez soi et article gratuit ; vente comptée si le vendeur est connecté |
| `hangglider.lua` | `hangglider:glide` | sonde (1 s) de l'API publique `hangglider.is_gliding` |
| `nether.lua` | `nether:portal_lit` | enveloppe `on_place` du fragment de cristal de Mese : fragment consommé, ou portail apparu à côté du cadre |
| `paleotest.lua` | `paleotest:egg_placed` | enveloppe `on_place` des œufs (`paleotest:egg_*`) : œuf consommé |
| `draconis.lua` | `draconis:scales_pickup`, `draconis:egg_pickup` | callback moteur `core.register_on_item_pickup` : butin d'un dragon abattu (écailles, œuf) ramassé à la main par un vrai joueur, quelle que soit l'origine de l'objet au sol ; seuls un objet jeté par un joueur (`dropped_by`), un faux joueur et un inventaire plein sont exclus |
| `areas.lua` | `areas:protect` | API publique `areas:registerOnAdd` ; zones principales seulement (`parent == nil`), propriétaire connecté |

Non retenues (coût ou fiabilité insuffisants, documentées dans les fichiers de quêtes et `docs/audit/`) : programmation
du contrôleur Lua (mesecons), cycle Digtron, mise en service de l'ascenseur celevator, réseau Technic alimenté, retrait
d'ADN de l'analyseur paleotest, apprivoisement de la wyverne, dépôt au distributeur atm.

## 7. Sauvegarde (`core/storage.lua`)

- Mod storage Luanti, une clé JSON par joueur `p:<nom>` :
  `{ v, done, prog, spots, rewarded, delivered, pending, titles }`.
- `STORAGE_VERSION = 1`. `S.migrations[n]` transforme une version n en n+1 ; les champs manquants sont recréés.
- **Données plus récentes que le mod** : lecture seule, jamais écrasées (retour arrière sûr).
- **Données illisibles** : copiées sous `p_corrupt:<nom>` avant de repartir d'un enregistrement vide (rien n'est perdu).
- Renommer une quête : ajouter `S.quest_aliases[ancien] = nouveau` (jamais retirer une entrée).
- Écritures : immédiates pour une complétion ou une récompense ; sinon par lot toutes les 10 s, à la déconnexion et à
  l'arrêt du serveur. Les joueurs déconnectés sont déchargés du cache.
- `placed` : file FIFO des positions de blocs-cibles posés (anti-triche `dig`), plafonnée par `placed_cap`.

## 8. Graphe (`core/graph.lua`)

- `check_all()` : prérequis inconnus et cycles → quêtes concernées indisponibles (journalisé).
- `layout(chapitre)` : colonne = plus long chemin de prérequis **dans le chapitre**, ligne = première place libre, `pos`
  explicite prioritaire. Retourne `{ pos, cols, rows, edges, external }` (prérequis d'autres chapitres signalés à part).
- `children(qid)` : quêtes qui dépendent de `qid` (notifications de déblocage).
- Règles de conception : fondamentaux = tronc commun léger ; transports, technologie, commerce et exploration
  indépendants ; arbres ≤ 6 colonnes × 4 lignes.

## 9. Architecture graphique

- **Une seule implémentation des vues** (`ui/views.lua`) partagée par le livre et la page Unified Inventory ; seule la
  surface disponible change (`views.build(name, rect, opts)`).
  - Livre : formulaire `minerland_quests:book`, `formspec_version[6]`, 20 × 12,6, fond `mlq_book_bg.png` (9-slice).
  - Unified Inventory : page `minerland_quests`, bouton `mlq_ui_button.png`. UI impose `formspec_version[4]` et
    coordonnées réelles ; mode complet 17,75 × 12,25 ou « lite » 14 × 9,75 ; sous 14 de large, la fiche remplace l'arbre.
- Vues : accueil (couverture, progression globale, titres, livraisons en attente, 6 cartes de parties) → partie (cartes
  de chapitres) → chapitre (intro, arbre dans un `scroll_container` horizontal ou vertical, légende, chapitres
  précédent/suivant, fiche de quête).
- Arbre : nœuds `item_image` des objets réels dans un cadre coloré par état (or disponible, vert terminé + coche,
  gris verrouillé, brique indisponible) ; liens orthogonaux colorés selon l'état ; tooltips.
- État de navigation par joueur `{ view, part, chapter, quest, scroll }`, commun aux deux surfaces.
- Champs `mlq_*` uniquement, **navigation seulement** ; tout identifiant reçu est revalidé contre le registre.
  Le seul bouton d'action (`mlq_deliver`) relance la livraison de récompenses déjà acquises.
- Texte injecté échappé (`theme.esc` = `core.formspec_escape`), troncature UTF-8 sûre.
- Rafraîchissement : `Q.ui.refresh(name)` regroupé (0,3 s) ; ne redessine que la surface ouverte.
- Thème : parchemin `#f3e6c4`, encre `#3b2412`, bronze ; couleurs d'état dans `ui/theme.lua` seulement. Textures
  procédurales originales `mlq_*.png` (`tools/gen_textures.py`, CC-BY-SA-4.0, 56 fichiers, ~119 Kio) ;
  textures 9-slice (fond du livre 24 px, page UI 12 px, panneaux 6 px, cases 3 px, boutons 4 px, survol 2 px) :
  détails dans les coins, bords et centre lisses ; ornement = filet étiré + fleuron central non déformé.
- Couverture (`mlq_cover.png`, variante anglaise `mlq_cover_en.png`) : armoiries originales de Minerland, écartelé
  d'azur et d'or (pioches en sautoir, chêne, tour, roue dentée), couronne murale à cinq tours, branches de chêne et de
  laurier, listel « DOUCE HARMONIE » ; blasonnement complet dans `draw_arms` (`tools/gen_textures.py`). « MINERLAND » est
  dessiné en capitales à empattements de 83 px de large, contenues dans le cadre doré intérieur.

## 10. Multilingue (`core/i18n.lua`)

- **Langue source : le français.** Le code et les données de quêtes sont écrits en français ; les autres langues
  viennent de `locale/minerland_quests.<code>.tr` (format Luanti). Anglais complet (`en`).
- **Langue d'un joueur** (`I.lang`) : celle du client si elle est traduite (variante régionale ramenée à la langue de
  base, `en_GB` → `en`) ; le français si le client n'annonce aucune langue ; sinon le réglage
  `minerland_quests.fallback_language` (`en` par défaut). Mise en cache par joueur, vidée à la déconnexion.
- **Deux mécanismes** :
  - `tr(nom, "texte", …)` traduit **côté serveur** (`core.get_translated_string`) : interface du livre et de la page
    Unified Inventory, chat, HUD, réponses des commandes. Le texte traduit peut être mesuré, tronqué et échappé ;
    le client ne reçoit aucun balisage de traduction ;
  - `S("texte", …)` produit le balisage Luanti traduit **par le client** : textes enregistrés une fois pour tous
    (descriptions d'objets, infotexts, privilège, commandes) ;
  - `N("texte")` ne fait rien : il signale à l'extraction un libellé rangé dans une table (verbes d'objectifs, états,
    difficultés, raisons d'indisponibilité).
- **Données de quêtes** : titres, intros, descriptions, objectifs, astuces et titres honorifiques sont des clés de
  traduction ; « @ » y est refusé (réservé aux paramètres `@1`…`@9`). Les raisons d'indisponibilité gardent leur
  format et leurs paramètres (`q.unavailable_tr`) : français dans les journaux, langue du joueur à l'écran.
- **Textures par langue** : `I.texture(nom, base)` choisit `base_<langue>.png` si la variante est déclarée dans
  `I.localized_textures` (couverture), sinon `base.png`.
- **Outillage** : `tools/i18n.py` extrait les textes (`S`, `N`, `tr` dans le code ; données via
  `tools/dump_quests.lua`), régénère `locale/template.txt` et fusionne les `.tr` ; `make check-i18n` échoue si le
  modèle n'est pas à jour, s'il manque une traduction ou si les paramètres diffèrent. Ajouter une langue :
  `python3 tools/i18n.py --add de`, traduire le fichier créé.

## 11. Administration et sécurité

- Joueurs : `/quetes`, `/livre`, `/quests` (ouvrir le livre ; chaque commande n'est créée que si le nom est libre), objet `minerland_quests:book` (donné à l'arrivée, recette simple).
- Privilège `minerland_quests_admin` : `/mlq_progress <joueur>`, `/mlq_quest <id>`, `/mlq_reward <joueur>`
  (diagnostic et relance), `/mlq_diag` (quêtes indisponibles, récompenses retirées, intégrations actives).
- Test seulement (`minerland_quests.allow_reset = true`) : `/mlq_reset` (garde le journal de récompenses) et
  `/mlq_simulate`. Toutes les actions d'administration sont journalisées (`core.log("action")`).

## 12. Performances

- Callbacks moteur : O(1) quand l'objet n'est cible d'aucune quête (cas général).
- Sondes : un globalstep partagé, intervalle ≥ 1 s, O(joueurs connectés × sondes).
- Livraisons : relance seulement pour les joueurs ayant une file non vide.
- Stockage : écritures groupées ; JSON compact par joueur ; aucune lecture du disque dans les callbacks chauds (cache).
- Interface : rafraîchissement regroupé ; arbre limité par chapitre (≤ 24 nœuds).

## 13. Décisions

| Date | Décision | Raison |
|---|---|---|
| 2026-11-17 | Mod storage JSON, une clé par joueur, versionné | API native, pas de fichier hors monde, migration simple |
| 2026-11-17 | Récompense « au plus une fois » (journal avant inventaire) | pas de duplication même en cas de crash |
| 2026-11-17 | Lits MTG → quête de fabrication ; labour/semis farming → adaptateur | `set_node` sans callback de pose |
| 2026-11-17 | Faux joueurs et machines ne valident rien | une quête récompense une action personnelle |
| 2026-11-17 | Aucune intégration avec `awards` | mod retiré du serveur |
| 2026-11-17 | Anneaux goops_rings : niveau 1 seulement | niveaux supérieurs = 5/25/125 anneaux |
| 2026-11-18 | État des quêtes figé avant chaque événement | une action ne valide pas la quête qu'elle débloque |
| 2026-11-18 | `wrap_callback` et `register_poll` dans le cœur | une seule façon sûre d'envelopper et de sonder, testée |
| 2026-11-18 | « Monter à bord » détecté par un adaptateur générique `rides.lua` | un seul mécanisme moteur (`get_attach`) pour tous les véhicules |
| 2026-11-18 | Nether (ch20) centré sur la construction et l'allumage du portail | choix de l'administratrice |
| 2026-11-18 | Dragons (ch22) : cavernes (réglage `cavern_spawning`), nids non générés | on vise les cavernes, pas les nids |
| 2026-11-18 | Dinosaures (ch23) : fossiles → ADN → œuf, pas de capture | fonctionnement réel du serveur |
| 2026-11-18 | Textures procédurales en pixel art (~32 texels/unité), 9-slice à détails dans les coins | Luanti copie les coins 1:1 et étire bords et centre |
| 2026-11-18 | Bouton Unified Inventory lisse en 128 px | cohérent avec les icônes d'Unified Inventory |
| 2026-11-18 | Couleurs de TEXTE d'état distinctes des couleurs de cadre (`T.state_text_color`) | l'or des cadres est illisible en texte sur papier clair |
| 2026-11-18 | Cases d'objets texturées (`T.slot_style`) et bouton de fermeture sans bordure | pas de boutons gris standards |
| 2026-11-19 | Français langue source ; traduction de l'interface, du chat et du HUD côté serveur (`tr`) | la mise en page mesure et tronque le texte réellement affiché |
| 2026-11-19 | Langue : client si traduite, français si non annoncée, sinon réglage de repli (anglais) | un client dans une langue non traduite lit l'anglais plutôt que le français |
| 2026-11-19 | « @ » interdit dans les textes de quêtes | caractère réservé aux paramètres de traduction Luanti |
| 2026-11-19 | Couverture déclinée par langue (`I.localized_textures`) | le titre est dessiné dans l'image |
| 2026-11-19 | Catalogue complet : 193 quêtes vérifiées (5 à 10 par chapitre) | toutes ont une détection réelle ; au-delà de la cible indicative de 80 à 120 |
| 2026-11-19 | Aucune dépendance entre chapitres hors tronc commun (chapitres 1 à 4) | carrières indépendantes ; Technic 17 jouable sans le 16 |
| 2026-11-19 | Adaptateur générique `rides.lua` pour toute montée à bord | une seule sonde `get_attach()` pour chevaux, véhicules, cabines et dinosaures |
| 2026-11-19 | Ferroviaire sans pose de rail ni de wagon | `track_builder`, `train_operator`, `railway_operator` réservés |
| 2026-11-19 | Dragons : cavernes (tas d'os, pierre calcinée, magot), échafaudage écarté | réglage `cavern_spawning` du serveur ; choix de l'administratrice |
| 2026-11-19 | Protection de commune par `/protect` (areas) | auto-protection active sur Minerland |
| 2026-11-20 | Abattre un dragon et ramasser son butin valide les quêtes d'écailles et d'œuf (ch22), sans prérequis | choix de l'administratrice : ramasser à la main valide, quelle que soit l'origine de l'objet (tuyau, mort d'un joueur…), sans traçage ; sans prérequis pour qu'un œuf, rare, ramassé tôt ne soit pas perdu |

## 14. Limites connues

- Actions sans événement serveur (cuisson au four, tables de craft personnalisées, machines technic/techage,
  `set_node` sans callback, ouverture d'un coffre au trésor) : non détectables, remplacées par une étape voisine
  (pose, fabrication, consommation) ou écartées. Détail par mod : `docs/MOD_AUDIT.md`.
- Les versions des mods installés peuvent différer des sources auditées : tout identifiant est revérifié au démarrage.
- Les tests simulés (`make test`) ne remplacent pas un test dans un vrai moteur Luanti (`tests/integration/`).
