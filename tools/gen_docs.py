#!/usr/bin/env python3
"""Génère docs/QUESTS.md (catalogue des quêtes) à partir du mod chargé dans le mock.
Colonnes : chapitre, identifiant, titre, objectif, prérequis, récompense, détection, compatibilité.
Usage : python3 tools/gen_docs.py [--json dump.json]   — NE PAS éditer docs/QUESTS.md à la main.
"""
import argparse, json, os, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TYPE_LABEL = {"dig": "Minage (creuser)", "place": "Pose de bloc", "craft": "Fabrication", "eat": "Dégustation",
              "custom": "Intégration"}


def esc(s):
    return str(s or "").replace("|", "\\|").replace("\n", " ")


def objective(q):
    if q.get("objective"):
        return q["objective"]
    t = q["trigger"]
    what = ", ".join([f"`{i}`" for i in t.get("items") or []] + [f"groupe `{g}`" for g in t.get("groups") or []])
    qty = f" ×{t['count']}" if t["count"] > 1 else ""
    return f"{TYPE_LABEL[t['type']]} : {what}{qty}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--json")
    ap.add_argument("--out", default=os.path.join(ROOT, "docs/QUESTS.md"))
    args = ap.parse_args()
    if args.json:
        data = json.load(open(args.json, encoding="utf-8"))
    else:
        r = subprocess.run(["luajit", os.path.join(ROOT, "tools/dump_quests.lua")], capture_output=True, text=True)
        if r.returncode != 0:
            sys.exit(r.stderr or r.stdout)
        data = json.loads(r.stdout)
    titles = {q["id"]: q["title"] for q in data["quests"]}
    lines = ["# Catalogue des quêtes", "",
             "> Fichier **généré** par `python3 tools/gen_docs.py` (ou `make docs`). Ne pas modifier à la main.", "",
             f"Version du mod : {data['version']} — {len(data['quests'])} quêtes, {len(data['chapters'])} chapitres.", ""]
    for p in data["parts"]:
        lines += [f"## Partie {p['numeral']} — {p['title']}", "", f"*{p['subtitle']}*", ""]
        for c in [c for c in data["chapters"] if c["part"] == p["id"]]:
            qs = [q for q in data["quests"] if q["chapter"] == c["id"]]
            lines += [f"### Chapitre {c['number']} — {c['title']} ({len(qs)} quêtes)", "", c["intro"], ""]
            if not qs:
                lines += ["*Aucune quête pour l'instant.*", ""]
                continue
            lines += ["| Identifiant | Titre | Objectif | Prérequis | Récompense | Détection | Mods requis |",
                      "|---|---|---|---|---|---|---|"]
            for q in qs:
                req = ", ".join(f"{titles.get(r, r)} (`{r}`)" for r in q.get("requires") or []) or "—"
                rew = ", ".join(f"`{s}`" for s in q.get("reward_items") or [])
                if q.get("reward_title"):
                    rew = (rew + ", " if rew else "") + f"titre « {q['reward_title']} »"
                det = TYPE_LABEL[q["trigger"]["type"]]
                if q["trigger"]["type"] == "custom":
                    det += f" `{q['trigger']['key']}`"
                mods = ", ".join(q.get("mods") or []) or "—"
                star = " ★" if q.get("final") else ""
                lines.append(f"| `{q['id']}` | {esc(q['title'])}{star} | {esc(objective(q))} | {esc(req)} | "
                             f"{esc(rew) or '—'} | {det} | {mods} |")
            lines.append("")
    lines += ["---", "★ = quête finale du chapitre. « Mods requis » : si l'un manque sur le serveur, la quête est "
              "affichée comme *Indisponible* et ne bloque pas les suivantes.", ""]
    with open(args.out, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"{args.out} : {len(data['quests'])} quêtes")


if __name__ == "__main__":
    main()
