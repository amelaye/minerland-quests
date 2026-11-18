#!/usr/bin/env python3
"""Audit statique (lecture seule) d'un dossier de mods Luanti.

Usage :
  python3 tools/audit_mods.py <mods_dir> --summary              # nom réel, dépendances, nb d'objets
  python3 tools/audit_mods.py <mods_dir> --mod technic --items   # objets littéraux avec fichier:ligne
  python3 tools/audit_mods.py <mods_dir> --mod technic --crafts  # sorties de recettes littérales
  python3 tools/audit_mods.py <mods_dir> --index out.json        # index global objets -> source
  python3 tools/audit_mods.py <mods_dir> --grep on_place --mod x # recherche de callbacks

Sur le serveur : python3 tools/audit_mods.py /home/minetest/luanti5_15_1/mods --summary
Aucun fichier du dossier analysé n'est modifié.

Limite : seuls les identifiants écrits littéralement sont détectés. Les noms construits dans des boucles
doivent être vérifiés à la main et ajoutés à docs/audit/verified_items.txt avec leur source.
"""
import argparse
import json
import os
import re
import sys

REG_RE = re.compile(
    r"""(?:minetest|core)\.register_(node|craftitem|tool)\s*\(\s*["']:?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+)["']""")
ARMOR_RE = re.compile(r"""armor:register_armor\s*\(\s*["']:?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+)["']""")
ALIAS_RE = re.compile(
    r"""(?:minetest|core)\.register_alias(?:_force)?\s*\(\s*["']([a-zA-Z0-9_:]+)["']\s*,\s*["']([a-zA-Z0-9_:]+)["']""")
OUTPUT_RE = re.compile(r"""output\s*=\s*["']([a-zA-Z0-9_]+:[a-zA-Z0-9_]+)""")
CONF_RE = re.compile(r"^\s*([a-z_]+)\s*=\s*(.*)$")


def read_conf(path):
    conf = {}
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            for line in f:
                m = CONF_RE.match(line)
                if m:
                    conf[m.group(1)] = m.group(2).strip()
    except OSError:
        pass
    return conf


def find_mods(root):
    """Retourne [(dossier_relatif, chemin_absolu, conf)] pour chaque mod (y compris dans les modpacks)."""
    mods = []
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if not d.startswith(".")]
        if "init.lua" in filenames:
            conf = read_conf(os.path.join(dirpath, "mod.conf"))
            if not conf.get("name"):
                conf["name"] = os.path.basename(dirpath)
            mods.append((os.path.relpath(dirpath, root), dirpath, conf))
            dirnames[:] = []  # un mod ne contient pas d'autre mod
    return sorted(mods)


def lua_files(path):
    for dirpath, dirnames, filenames in os.walk(path):
        dirnames[:] = [d for d in dirnames if not d.startswith(".")]
        for fn in filenames:
            if fn.endswith(".lua"):
                yield os.path.join(dirpath, fn)


LONG_OPEN_RE = re.compile(r"\[(=*)\[")


def strip_lua_comments(text):
    """Remplace les commentaires Lua (--…, --[[…]], --[==[…]==]) par des espaces, en conservant les sauts de ligne
    (numéros de ligne inchangés) et le contenu des chaînes ('…', "…", [[…]]). Évite d'indexer du code désactivé."""
    out, i, n = [], 0, len(text)

    def blank(s):
        return "".join("\n" if c == "\n" else " " for c in s)

    while i < n:
        c = text[i]
        if c == "-" and text.startswith("--", i):
            m = LONG_OPEN_RE.match(text, i + 2)
            if m:
                close = "]" + m.group(1) + "]"
                j = text.find(close, m.end())
                j = n if j < 0 else j + len(close)
            else:
                j = text.find("\n", i)
                j = n if j < 0 else j
            out.append(blank(text[i:j]))
            i = j
        elif c in "'\"":
            j = i + 1
            while j < n and text[j] != c and text[j] != "\n":
                j += 2 if text[j] == "\\" else 1
            j = min(j + 1, n)
            out.append(text[i:j])
            i = j
        elif c == "[" and LONG_OPEN_RE.match(text, i):
            m = LONG_OPEN_RE.match(text, i)
            close = "]" + m.group(1) + "]"
            j = text.find(close, m.end())
            j = n if j < 0 else j + len(close)
            out.append(text[i:j])
            i = j
        else:
            out.append(c)
            i += 1
    return "".join(out)


def scan(path, root):
    items, crafts, aliases = {}, {}, {}
    for fp in lua_files(path):
        rel = os.path.relpath(fp, root)
        try:
            with open(fp, encoding="utf-8", errors="replace") as f:
                lines = strip_lua_comments(f.read()).split("\n")
        except OSError:
            continue
        for no, line in enumerate(lines, 1):
            for m in REG_RE.finditer(line):
                items.setdefault(m.group(2), f"{rel}:{no} ({m.group(1)})")
            for m in ARMOR_RE.finditer(line):
                items.setdefault(m.group(1), f"{rel}:{no} (armor)")
            for m in ALIAS_RE.finditer(line):
                aliases.setdefault(m.group(1), (m.group(2), f"{rel}:{no}"))
            for m in OUTPUT_RE.finditer(line):
                crafts.setdefault(m.group(1), f"{rel}:{no}")
    return items, crafts, aliases


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("mods_dir")
    ap.add_argument("--mod", help="dossier (ou préfixe) du mod à analyser")
    ap.add_argument("--summary", action="store_true")
    ap.add_argument("--items", action="store_true")
    ap.add_argument("--crafts", action="store_true")
    ap.add_argument("--aliases", action="store_true")
    ap.add_argument("--grep", help="regex à chercher dans les .lua")
    ap.add_argument("--index", help="écrit un index JSON global {objet: source}")
    args = ap.parse_args()

    root = os.path.abspath(args.mods_dir)
    mods = find_mods(root)
    if args.mod:
        mods = [m for m in mods if m[0] == args.mod or m[0].startswith(args.mod + os.sep)
                or m[2].get("name") == args.mod]
        if not mods:
            print(f"aucun mod correspondant à {args.mod}", file=sys.stderr)
            return 1

    if args.index:
        index = {"items": {}, "aliases": {}, "crafts": {}, "mods": {}}
        for rel, path, conf in mods:
            items, crafts, aliases = scan(path, root)
            index["mods"][conf["name"]] = {"dir": rel, "depends": conf.get("depends", ""),
                                          "optional_depends": conf.get("optional_depends", ""),
                                          "items": len(items)}
            for k, v in items.items():
                index["items"].setdefault(k, v)
            for k, v in crafts.items():
                index["crafts"].setdefault(k, v)
            for k, (target, src) in aliases.items():
                index["aliases"].setdefault(k, {"target": target, "source": src})
        with open(args.index, "w", encoding="utf-8") as f:
            json.dump(index, f, indent=1, sort_keys=True, ensure_ascii=False)
        print(f"index : {len(index['mods'])} mods, {len(index['items'])} objets, "
              f"{len(index['aliases'])} alias -> {args.index}")
        return 0

    for rel, path, conf in mods:
        if args.summary:
            items, crafts, _ = scan(path, root)
            print(f"{rel:45s} name={conf['name']:28s} items={len(items):4d} crafts={len(crafts):4d} "
                  f"depends=[{conf.get('depends', '')}]")
            continue
        print(f"== {rel} (mod `{conf['name']}`)")
        items, crafts, aliases = scan(path, root)
        if args.items:
            for k in sorted(items):
                print(f"  {k:55s} {items[k]}")
        if args.crafts:
            for k in sorted(crafts):
                print(f"  craft -> {k:46s} {crafts[k]}")
        if args.aliases:
            for k in sorted(aliases):
                print(f"  alias {k} -> {aliases[k][0]}  {aliases[k][1]}")
        if args.grep:
            rx = re.compile(args.grep)
            for fp in lua_files(path):
                with open(fp, encoding="utf-8", errors="replace") as f:
                    for no, line in enumerate(f, 1):
                        if rx.search(line):
                            print(f"  {os.path.relpath(fp, root)}:{no}: {line.strip()[:140]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
