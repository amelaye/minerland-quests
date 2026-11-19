#!/usr/bin/env python3
"""Traductions du Grand Livre : extraction des textes source (français) et mise à jour des fichiers .tr.

Textes extraits :
  - code Lua du mod : appels S("…"), N("…") et tr(<joueur>, "…") — littéraux, concaténations "a" .. "b" comprises ;
    un appel dont le texte n'est pas littéral (ex. tr(nom, q.title)) est une donnée, extraite ci-dessous ;
  - données (luajit tools/dump_quests.lua) : titres et sous-titres des parties, titres et intros des chapitres,
    titres, descriptions, objectifs, astuces et titres honorifiques des quêtes.
Fichiers (minerland_quests/locale/) :
  - template.txt : modèle de toutes les chaînes (non chargé par Luanti) ;
  - minerland_quests.<code>.tr : traductions. Les entrées existantes sont conservées, les nouvelles ajoutées vides,
    les obsolètes gardées en commentaire en fin de fichier.
Format Luanti : « source=traduction » ; dans les deux, « = » s'écrit « @= » et un saut de ligne « @n » ;
@1…@9 sont les paramètres (la traduction peut les réordonner).

Usage :
  python3 tools/i18n.py              # met à jour template.txt et tous les .tr
  python3 tools/i18n.py --add de     # crée minerland_quests.de.tr
  python3 tools/i18n.py --check      # ne modifie rien ; code 1 si le modèle n'est pas à jour ou s'il manque
                                     # une traduction
"""
import argparse
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MOD = os.path.join(ROOT, "minerland_quests")
LOCALE = os.path.join(MOD, "locale")
DOMAIN = "minerland_quests"
HEADER = f"# textdomain: {DOMAIN}"

CALL_RE = re.compile(r"(?<![A-Za-z0-9_])(S|N|tr)\(")


def lua_tokens_without_comments(text):
    """Remplace les commentaires Lua par des espaces (positions conservées), chaînes intactes."""
    out, i, n = [], 0, len(text)
    while i < n:
        c = text[i]
        if text.startswith("--", i):
            m = re.match(r"\[(=*)\[", text[i + 2:])
            if m:
                close = "]" + m.group(1) + "]"
                j = text.find(close, i + 2 + m.end())
                j = n if j < 0 else j + len(close)
            else:
                j = text.find("\n", i)
                j = n if j < 0 else j
            out.append(re.sub(r"[^\n]", " ", text[i:j]))
            i = j
        elif c in "'\"":
            j = i + 1
            while j < n and text[j] != c and text[j] != "\n":
                j += 2 if text[j] == "\\" else 1
            out.append(text[i:j + 1])
            i = j + 1
        else:
            out.append(c)
            i += 1
    return "".join(out)


ESCAPES = {"n": "\n", "t": "\t", "\\": "\\", '"': '"', "'": "'"}


def read_literal(text, i):
    """Lit un littéral Lua à la position i (après les blancs) ; retourne (valeur, fin) ou (None, i)."""
    while i < len(text) and text[i] in " \t\r\n":
        i += 1
    if i >= len(text) or text[i] not in "'\"":
        return None, i
    q = text[i]
    j, buf = i + 1, []
    while j < len(text) and text[j] != q:
        if text[j] == "\\" and j + 1 < len(text):
            buf.append(ESCAPES.get(text[j + 1], text[j + 1]))
            j += 2
        else:
            buf.append(text[j])
            j += 1
    return "".join(buf), j + 1


def read_literal_expr(text, i):
    """Littéral ou concaténation de littéraux ("a" .. "b"). Retourne (valeur, fin) ou (None, i)."""
    val, j = read_literal(text, i)
    if val is None:
        return None, i
    parts = [val]
    while True:
        k = j
        while k < len(text) and text[k] in " \t\r\n":
            k += 1
        if not text.startswith("..", k):
            break
        nxt, k2 = read_literal(text, k + 2)
        if nxt is None:
            return None, i          # concaténation avec une variable : texte dynamique, ignoré
        parts.append(nxt)
        j = k2
    k = j
    while k < len(text) and text[k] in " \t\r\n":
        k += 1
    if k < len(text) and text[k] not in ",)":
        return None, i              # expression plus complexe (ex. "a" .. x) : ignorée
    return "".join(parts), j


def skip_first_argument(text, i):
    depth = 0
    while i < len(text):
        c = text[i]
        if c in "([{":
            depth += 1
        elif c in ")]}":
            if depth == 0:
                return None
            depth -= 1
        elif c == "," and depth == 0:
            return i + 1
        elif c in "'\"":
            _, i = read_literal(text, i)
            continue
        i += 1
    return None


def code_strings():
    """[(fichier, chaîne)] dans l'ordre d'apparition."""
    found = []
    for dirpath, _, files in os.walk(MOD):
        for fn in sorted(files):
            if not fn.endswith(".lua"):
                continue
            path = os.path.join(dirpath, fn)
            rel = os.path.relpath(path, MOD)
            text = lua_tokens_without_comments(open(path, encoding="utf-8").read())
            for m in CALL_RE.finditer(text):
                start = m.end()
                if m.group(1) == "tr":
                    start = skip_first_argument(text, start)
                    if start is None:
                        continue
                val, _ = read_literal_expr(text, start)
                if val:
                    found.append((rel, val))
    return sorted(found, key=lambda p: (0 if p[0].startswith("ui/") else 1 if p[0].startswith("core/") else 2, p[0]))


def data_strings():
    """[(section, chaîne)] des données de quêtes, dans l'ordre du livre."""
    r = subprocess.run(["luajit", os.path.join(ROOT, "tools/dump_quests.lua")], capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit("échec du chargement du mod dans le mock : " + (r.stderr or r.stdout))
    data = json.loads(r.stdout)
    out = []
    for p in data["parts"]:
        sec = f"Partie {p['numeral']} — {p['title']}"
        out += [(sec, p.get("title")), (sec, p.get("subtitle"))]
    chapters = {c["id"]: c for c in data["chapters"]}
    for c in data["chapters"]:
        sec = f"Chapitre {c['number']} — {c['title']}"
        out += [(sec, c.get("title")), (sec, c.get("intro"))]
        for q in data["quests"]:
            if q["chapter"] == c["id"]:
                for field in ("title", "description", "objective", "hint", "reward_title"):
                    out.append((sec, q.get(field)))
    del chapters
    return [(s, v) for s, v in out if isinstance(v, str) and v]


def escape(s):
    return s.replace("=", "@=").replace("\n", "@n")


def unescape(s):
    out, i = [], 0
    while i < len(s):
        if s[i] == "@" and i + 1 < len(s) and s[i + 1] in "=n@":
            out.append({"=": "=", "n": "\n", "@": "@"}[s[i + 1]])
            i += 2
        else:
            out.append(s[i])
            i += 1
    return "".join(out)


def split_line(line):
    """Sépare « source=traduction » au premier « = » non échappé."""
    i = 0
    while i < len(line):
        if line[i] == "@":
            i += 2
            continue
        if line[i] == "=":
            return line[:i], line[i + 1:]
        i += 1
    return None


def collect():
    sections, seen = [], set()

    def add(section, s):
        if s in seen:
            return
        seen.add(s)
        if not sections or sections[-1][0] != section:
            sections.append((section, []))
        sections[-1][1].append(s)
    for f, s in code_strings():
        add(f"Interface et messages ({f})", s)
    for sec, s in data_strings():
        add(sec, s)
    return sections


def render(sections, translations=None, obsolete=None):
    lines = [HEADER]
    if translations is None:
        lines.append("# Modèle généré par tools/i18n.py — langue source : français. Ne pas éditer à la main.")
    else:
        lines.append("# Fichier tenu à jour par tools/i18n.py : traduire la partie à droite du « = ».")
    for sec, strings in sections:
        lines.append("")
        lines.append(f"##### {sec}")
        for s in strings:
            value = "" if translations is None else translations.get(s, "")
            lines.append(f"{escape(s)}={value}")
    if obsolete:
        lines.append("")
        lines.append("##### Obsolète (textes source disparus) — à supprimer après vérification")
        for k, v in obsolete:
            lines.append(f"# {escape(k)}={v}")
    return "\n".join(lines) + "\n"


def read_tr(path):
    tr = {}
    if not os.path.exists(path):
        return tr
    for line in open(path, encoding="utf-8"):
        line = line.rstrip("\n")
        if not line or line.startswith("#"):
            continue
        parts = split_line(line)
        if parts:
            tr[unescape(parts[0])] = parts[1]
    return tr


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--add", metavar="CODE")
    args = ap.parse_args()
    sections = collect()
    keys = [s for _, ss in sections for s in ss]
    template_path = os.path.join(LOCALE, "template.txt")
    template = render(sections)
    problems = []
    if args.check:
        current = open(template_path, encoding="utf-8").read() if os.path.exists(template_path) else ""
        if current != template:
            problems.append("template.txt n'est pas à jour (lancer : python3 tools/i18n.py)")
    else:
        os.makedirs(LOCALE, exist_ok=True)
        open(template_path, "w", encoding="utf-8").write(template)
    langs = sorted(f[len(DOMAIN) + 1:-3] for f in os.listdir(LOCALE) if f.startswith(DOMAIN + ".") and f.endswith(".tr")) \
        if os.path.isdir(LOCALE) else []
    if args.add and args.add not in langs:
        langs.append(args.add)
    print(f"{len(keys)} texte(s) source")
    for lang in langs:
        path = os.path.join(LOCALE, f"{DOMAIN}.{lang}.tr")
        tr = read_tr(path)
        missing = [k for k in keys if not tr.get(k)]
        obsolete = [(k, v) for k, v in tr.items() if k not in set(keys)]
        for k in keys:                                   # contrôle des paramètres @1…@9
            v = tr.get(k)
            if v and sorted(re.findall(r"@\d", k)) != sorted(re.findall(r"@\d", unescape(v))):
                problems.append(f"{lang} : paramètres différents pour « {k[:60]} »")
        if args.check:
            if missing:
                problems.append(f"{lang} : {len(missing)} traduction(s) manquante(s), ex. « {missing[0][:60]} »")
            if obsolete:
                problems.append(f"{lang} : {len(obsolete)} entrée(s) obsolète(s)")
        else:
            open(path, "w", encoding="utf-8").write(render(sections, tr, obsolete))
        print(f"  {lang} : {len(keys) - len(missing)}/{len(keys)} traduit(s)"
              + (f", {len(obsolete)} obsolète(s)" if obsolete else ""))
    for p in problems:
        print("ERREUR " + p)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
