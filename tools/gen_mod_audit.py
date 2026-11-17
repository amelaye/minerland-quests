#!/usr/bin/env python3
"""Génère docs/MOD_AUDIT.md à partir de :
  - docs/audit/server_mods.txt      (dossiers présents sur le serveur)
  - docs/audit/item_index.json      (mods trouvés dans .audit_src, nom mod.conf, dépendances, nb d'objets)
  - .audit_src/<dossier>            (commit audité)
  - docs/audit/ch*.md               (fiches détaillées et quêtes candidates, par chapitre)
  - docs/audit/verified_*.txt       (identifiants dynamiques vérifiés)
  - le catalogue de quêtes (luajit tools/dump_quests.lua) pour relier mods et chapitres.
Usage : python3 tools/gen_mod_audit.py   — NE PAS éditer docs/MOD_AUDIT.md à la main.
"""
import glob, json, os, re, subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AUDIT = os.path.join(ROOT, "docs/audit")
SRC = os.path.join(ROOT, ".audit_src")

# Dossier serveur -> dossier .audit_src quand les noms diffèrent (voir docs/audit/README.md §1)
ALIASES = {
    "BBQ": "bbq", "Biofuel": "biofuel", "luanti-smartshop": "smartshop", "luanti-futil": "futil",
    "minetest-futil": "futil", "luanti-fmod": "fmod", "minetest-fmod": "fmod",
    "luanti-tieless-tracks": "tieless_tracks", "minetest-hangglider": "hangglider",
    "minetest-moretrains": "moretrains", "minetest_tsm_railcorridors": "tsm_railcorridors",
    "tfl_s7stock_modpack": "tfl_s7_stock_modpack", "trainblocks_bc": "trainblocks", "mobs_redo": "mobs",
    "rings": "rings",
}
# Dossiers dont l'absence de source est attendue (mods locaux ou sans dépôt public trouvé)
LOCAL = {"friandises", "chester", "monitoring", "radar_atc", "minekart", "beowulf", "moredecorations",
         "mod-cleaner", "vps_blocker"}


def sha(d):
    try:
        r = subprocess.run(["git", "-C", os.path.join(SRC, d), "log", "-1", "--format=%h %ad", "--date=short"],
                           capture_output=True, text=True)
        return r.stdout.strip() if r.returncode == 0 else ""
    except OSError:
        return ""


def main():
    server = [l.strip() for l in open(os.path.join(AUDIT, "server_mods.txt"), encoding="utf-8")
              if l.strip() and not l.startswith("#")]
    idx = json.load(open(os.path.join(AUDIT, "item_index.json"), encoding="utf-8"))
    mods_by_dir = {}
    for name, m in idx["mods"].items():
        top = m["dir"].split("/")[0]
        mods_by_dir.setdefault(top, []).append((name, m))
    sources = set(os.listdir(SRC)) if os.path.isdir(SRC) else set()

    # mods utilisés par les quêtes -> chapitres
    chapters_by_mod = {}
    try:
        r = subprocess.run(["luajit", os.path.join(ROOT, "tools/dump_quests.lua")], capture_output=True, text=True)
        data = json.loads(r.stdout)
        for q in data["quests"]:
            for m in q.get("mods") or []:
                chapters_by_mod.setdefault(m, set()).add(q["chapter"])
    except Exception:
        data = None

    verified = 0
    for f in glob.glob(os.path.join(AUDIT, "verified_*.txt")):
        verified += sum(1 for l in open(f, encoding="utf-8") if l.strip() and not l.startswith("#"))

    out = ["# Audit des mods de Minerland", "",
           "> Fichier **généré** par `python3 tools/gen_mod_audit.py`. Sources : `docs/audit/`. Ne pas éditer à la main.", "",
           "## 1. Méthode", "",
           "- Liste des mods du serveur : relevé du dossier `/home/minetest/luanti5_15_1/mods` fourni par l'administration "
           "(17/11/2026) — `docs/audit/server_mods.txt`. La page « mods » du wiki est obsolète.",
           "- Le serveur n'est pas accessible depuis le poste de développement : les sources publiques des mods ont été "
           "clonées en lecture seule (`.audit_src/`, `make fetch-sources`). **Les versions installées peuvent différer** : "
           "tout identifiant est aussi revérifié à l'exécution (une quête dont l'objet n'existe pas devient « Indisponible »). "
           "Sur le serveur : `python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods --index index.json` puis "
           "`python3 tools/validate_quests.py --index index.json`.",
           "- Présence d'un dossier ≠ mod activé dans `world.mt` : chaque quête déclare ses mods requis.",
           f"- Index : {len(idx['mods'])} mods, {len(idx['items'])} objets littéraux, {len(idx['aliases'])} alias ; "
           f"{verified} identifiants dynamiques vérifiés à la main (`docs/audit/verified_*.txt`).",
           "- Sémantique des événements et classement de fiabilité : `docs/audit/README.md`.", "",
           "## 2. Inventaire du serveur", "",
           "| Dossier serveur | Source auditée | Mods (nom `mod.conf`) | Chapitres | État |",
           "|---|---|---|---|---|"]
    counts = {"audité": 0, "local": 0, "sans source": 0}
    for s in server:
        src = ALIASES.get(s, s)
        if src not in sources and s.lower() in sources:
            src = s.lower()
        mods = mods_by_dir.get(src, [])
        names = sorted(n for n, _ in mods)
        chs = sorted({c for n in names for c in chapters_by_mod.get(n, ())})
        if src in sources:
            state = "audité"
        elif s in LOCAL or s.startswith("minerland_fix_"):
            state = "local"
        else:
            state = "sans source"
        counts[state] += 1
        shown = ", ".join(f"`{n}`" for n in names[:6]) + (f" … (+{len(names) - 6})" if len(names) > 6 else "")
        out.append(f"| `{s}` | {('`' + src + '` @ ' + sha(src)) if src in sources else '—'} | {shown or '—'} | "
                   f"{', '.join(chs) or '—'} | {state} |")
    out += ["", f"Bilan : {counts['audité']} dossiers audités, {counts['local']} mods locaux sans source publique, "
            f"{counts['sans source']} hors périmètre des quêtes (sources non récupérées).", "",
            "Décision : le mod `awards` sera **supprimé** du serveur ; le livre n'en dépend pas et n'y fait pas appel.", "",
            "## 3. Fiches détaillées par chapitre", ""]
    for f in sorted(glob.glob(os.path.join(AUDIT, "ch*.md"))):
        text = open(f, encoding="utf-8").read()
        text = re.sub(r"^# ", "### ", text, flags=re.M) if text.startswith("# ") else text
        out += [f"<!-- source : docs/audit/{os.path.basename(f)} -->", text.strip(), ""]
    path = os.path.join(ROOT, "docs/MOD_AUDIT.md")
    open(path, "w", encoding="utf-8").write("\n".join(out) + "\n")
    print(f"{path} : {len(server)} dossiers, {counts}")


if __name__ == "__main__":
    main()
