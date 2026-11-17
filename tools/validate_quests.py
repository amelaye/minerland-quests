#!/usr/bin/env python3
"""Validation statique du catalogue de quêtes (sans moteur Luanti).

Contrôles :
  - identifiants uniques, préfixe = chapitre, chapitres et parties existants, 25 chapitres / 6 parties ;
  - prérequis existants, absence de cycles, quêtes inaccessibles ;
  - chaque objet référencé (cible, récompense, icône) existe dans l'audit des sources
    (docs/audit/item_index.json : objets littéraux et alias ; docs/audit/verified_*.txt : objets dynamiques vérifiés) ;
  - cible « place »/« dig » = un nœud (pas un objet d'inventaire seul) quand l'index le sait ;
  - économie : plafonds de ressources rares et de monnaie sur l'ensemble du livre ;
  - lisibilité : taille des arbres, longueur des titres, présence d'une quête finale par chapitre.

Usage : python3 tools/validate_quests.py [--json dump.json] [--strict]
Code de sortie 1 s'il y a des ERREURS (les AVERTISSEMENTS ne bloquent pas, sauf --strict).
"""
import argparse, glob, json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Plafonds économiques sur l'ensemble du livre (voir docs/REWARDS.md)
RARE_CAPS = {
    "default:diamond": 4, "default:diamondblock": 0, "default:mese_crystal": 6, "default:mese": 0,
    "moreores:mithril_ingot": 2, "moreores:mithril_lump": 2, "default:goldblock": 1,
}
CURRENCY_PREFIX = "currency:minegeld"
CURRENCY_VALUE = {"currency:minegeld": 1, "currency:minegeld_5": 5, "currency:minegeld_10": 10,
                  "currency:minegeld_50": 50, "currency:minegeld_100": 100}
CURRENCY_CAP = 600
MAX_COLS, MAX_ROWS = 6, 4


def load_dump(path):
    if path:
        return json.load(open(path, encoding="utf-8"))
    r = subprocess.run(["luajit", os.path.join(ROOT, "tools/dump_quests.lua")], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stderr or r.stdout, file=sys.stderr)
        sys.exit("échec du chargement du mod dans le mock (luajit tools/dump_quests.lua)")
    return json.loads(r.stdout)


def load_known_items(index_path=None):
    idx = json.load(open(index_path or os.path.join(ROOT, "docs/audit/item_index.json"), encoding="utf-8"))
    items = dict(idx["items"])
    aliases = {k: v["target"] for k, v in idx["aliases"].items()}
    verified = {}
    for f in glob.glob(os.path.join(ROOT, "docs/audit/verified_*.txt")):
        for line in open(f, encoding="utf-8"):
            line = line.rstrip("\n")
            if line and not line.startswith("#"):
                parts = line.split("\t")
                verified[parts[0]] = parts[1] if len(parts) > 1 else os.path.basename(f)
    # objets du mod lui-même
    own = {"minerland_quests:book": "ui/items.lua", "minerland_quests:city_charter": "ui/items.lua"}
    return items, aliases, verified, own, set(idx["mods"])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--json")
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--index", help="index JSON produit par tools/audit_mods.py (ex. sur le serveur réel)")
    args = ap.parse_args()
    data = load_dump(args.json)
    items, aliases, verified, own, known_mods = load_known_items(args.index)
    errors, warnings = [], []
    E = errors.append
    W = warnings.append

    parts = {p["id"]: p for p in data["parts"]}
    chapters = {c["id"]: c for c in data["chapters"]}
    quests = {}
    if len(parts) != 6:
        E(f"{len(parts)} parties enregistrées (6 attendues)")
    if len(chapters) != 25:
        E(f"{len(chapters)} chapitres enregistrés (25 attendus)")
    for q in data["quests"]:
        if q["id"] in quests:
            E(f"{q['id']} : identifiant en double")
        quests[q["id"]] = q

    def known(name, role, qid, want_node=False):
        name = name.split(" ")[0]
        if name.endswith(".png"):
            return
        if name in own or name in verified:
            return
        if name in aliases:
            target = aliases[name]
            if target in items or target in verified:
                return
        if name in items:
            if want_node and "(node)" not in items[name] and "(armor)" not in items[name]:
                W(f"{qid} : {role} « {name} » est enregistré comme {items[name].split('(')[-1].rstrip(')')} "
                  f"et non comme nœud ({items[name]})")
            return
        E(f"{qid} : {role} « {name} » introuvable dans l'audit (ni littéral, ni alias, ni vérifié)")

    for qid, q in quests.items():
        ch = q["chapter"]
        if ch not in chapters:
            E(f"{qid} : chapitre inconnu {ch}")
        if not qid.startswith(ch + "."):
            E(f"{qid} : le préfixe doit être {ch}.")
        if len(q["title"]) > 34:
            W(f"{qid} : titre long ({len(q['title'])} caractères) — risque de troncature")
        if not q.get("description"):
            W(f"{qid} : description vide")
        for r in q.get("requires") or []:
            if r not in quests:
                E(f"{qid} : prérequis inconnu {r}")
        t = q["trigger"]
        want_node = t["type"] in ("dig", "place")
        for it in t.get("items") or []:
            known(it, "cible", qid, want_node)
        if t["type"] == "custom" and not q.get("objective"):
            W(f"{qid} : déclencheur custom sans texte d'objectif")
        for s in q.get("reward_items") or []:
            known(s, "récompense", qid)
        if q.get("icon"):
            known(q["icon"], "icône", qid)
        for m in q.get("mods") or []:
            if m not in known_mods:
                E(f"{qid} : mod requis « {m} » inconnu (nom mod.conf attendu, pas le nom du dossier)")
        if not q.get("reward_items") and not q.get("reward_title"):
            W(f"{qid} : aucune récompense")
        # ne pas récompenser par l'objet exact visé
        targets = set(t.get("items") or [])
        for s in q.get("reward_items") or []:
            if s.split(" ")[0] in targets and t["type"] in ("craft", "place"):
                W(f"{qid} : la récompense {s} est l'objet même de la quête")

    # cycles (DFS)
    color = {}
    def visit(qid, stack):
        color[qid] = 1
        for r in quests[qid].get("requires") or []:
            if r not in quests:
                continue
            if color.get(r) == 1:
                E("dépendance circulaire : " + " -> ".join(stack + [r]))
            elif color.get(r) is None:
                visit(r, stack + [r])
        color[qid] = 2
    for qid in sorted(quests):
        if qid not in color:
            visit(qid, [qid])

    # accessibilité (tous mods présents)
    reach = {}
    def reachable(qid, guard=()):
        if qid in reach:
            return reach[qid]
        if qid in guard:
            return False
        ok = all(r in quests and reachable(r, guard + (qid,)) for r in quests[qid].get("requires") or [])
        reach[qid] = ok
        return ok
    for qid in quests:
        if not reachable(qid):
            E(f"{qid} : inaccessible (prérequis manquants ou circulaires)")

    # chapitres : contenu, finale, taille de l'arbre, indépendance
    for cid, c in chapters.items():
        qs = [q for q in quests.values() if q["chapter"] == cid]
        if len(qs) == 0:
            E(f"{cid} : chapitre vide")
        elif len(qs) < 3:
            W(f"{cid} : seulement {len(qs)} quête(s)")
        if qs and not any(q.get("final") for q in qs):
            W(f"{cid} : aucune quête finale (final = true)")
        if c["cols"] > MAX_COLS or c["rows"] > MAX_ROWS:
            W(f"{cid} : arbre de {c['cols']}×{c['rows']} (max conseillé {MAX_COLS}×{MAX_ROWS})")
        if c["number"] > 2:
            for q in qs:
                for r in q.get("requires") or []:
                    if r in quests and quests[r]["chapter"] != cid and int(quests[r]["chapter"][2:]) > 4:
                        W(f"{q['id']} : dépend d'un autre chapitre hors tronc commun ({r})")

    # économie
    totals, money = {}, 0
    for q in quests.values():
        for s in q.get("reward_items") or []:
            name, _, cnt = s.partition(" ")
            n = int(cnt) if cnt.strip().isdigit() else 1
            totals[name] = totals.get(name, 0) + n
            if name.startswith(CURRENCY_PREFIX):
                money += CURRENCY_VALUE.get(name, 1) * n
    for name, cap in RARE_CAPS.items():
        if totals.get(name, 0) > cap:
            E(f"économie : {totals[name]} × {name} distribués (plafond {cap})")
    if money > CURRENCY_CAP:
        E(f"économie : {money} Minegeld distribués au total (plafond {CURRENCY_CAP})")

    # optional_depends du mod.conf : noms réels attendus
    conf = open(os.path.join(ROOT, "minerland_quests/mod.conf"), encoding="utf-8").read()
    m = re.search(r"^optional_depends\s*=\s*(.*)$", conf, re.M)
    for dep in [d.strip() for d in (m.group(1).split(",") if m else []) if d.strip()]:
        if dep not in known_mods:
            W(f"mod.conf : optional_depends « {dep} » ne correspond à aucun mod audité")

    for p in data.get("graph_problems") or []:
        E("graphe : " + p)

    per_ch = {}
    for q in quests.values():
        per_ch[q["chapter"]] = per_ch.get(q["chapter"], 0) + 1
    print(f"{len(quests)} quêtes, {len(chapters)} chapitres, {len(parts)} parties ; Minegeld total : {money}")
    print("quêtes par chapitre : " + ", ".join(f"{k}={per_ch.get(k, 0)}" for k in sorted(chapters)))
    for w in warnings:
        print("AVERTISSEMENT " + w)
    for e in errors:
        print("ERREUR " + e)
    print(f"{len(errors)} erreur(s), {len(warnings)} avertissement(s)")
    if errors or (args.strict and warnings):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
