#!/usr/bin/env python3
"""Prépare tests/_tmp/itest_allmods/ : les mods du serveur (sources auditées de .audit_src/) pour le test réel.

Un lien par mod, nommé d'après son vrai nom (mod.conf). On ne garde que les dossiers présents sur le serveur
(docs/audit/server_mods.txt), les variantes retenues pour l'audit en cas de doublon, et seulement les mods dont toutes
les dépendances obligatoires sont disponibles (sinon Luanti refuse de démarrer). Les mods de Minetest Game restent dans
le jeu, sauf ceux remplacés par une version du serveur (farming redo).

Usage :
  python3 tests/integration/build_allmods.py
  tests/integration/run.sh <serveur_luanti> .audit_src/minetest_game tests/_tmp/itest_allmods
N'écrit que dans tests/_tmp/itest_allmods/ (dossier généré).
"""
import os, re, shutil, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(ROOT, ".audit_src")
OUT = os.path.join(ROOT, "tests/_tmp/itest_allmods")
GAME = os.path.join(SRC, "minetest_game")
# doublons : variante présente sur le serveur (voir docs/audit/)
PREFER = {
    "unified_inventory": "unified_inventory", "basic_materials": "basic_materials", "nether": "nether",
    "farming": "farming",
}
# mods publics qui ne se chargent pas dans Luanti 5.15.1 (le serveur en a sans doute une version corrigée)
EXCLUDE = {
    "shipwrecks": "init.lua:24 appelle core.settings:get_int, qui n'existe pas (le chargement s'arrête)",
}
# dossier de .audit_src -> nom du dossier sur le serveur, quand ils diffèrent (nether_hybriddog : variante absente)
SERVER_FOLDER = {
    "bbq": "BBQ", "biofuel": "Biofuel", "fmod": "luanti-fmod", "futil": "luanti-futil",
    "hangglider": "minetest-hangglider", "mobs": "mobs_redo", "moretrains": "minetest-moretrains",
    "smartshop": "luanti-smartshop", "tfl_s7_stock_modpack": "tfl_s7stock_modpack",
    "tieless_tracks": "luanti-tieless-tracks", "trainblocks": "trainblocks_bc",
    "tsm_railcorridors": "minetest_tsm_railcorridors",
}


def read_conf(path):
    conf = {}
    if os.path.exists(path):
        for line in open(path, encoding="utf-8", errors="ignore"):
            m = re.match(r"\s*([a-z_]+)\s*=\s*(.*)", line)
            if m:
                conf[m.group(1)] = m.group(2).strip()
    return conf


def hard_deps(folder):
    # comme Luanti : mod.conf s'il déclare des dépendances, sinon l'ancien depends.txt (« ? » = facultative)
    conf = read_conf(os.path.join(folder, "mod.conf"))
    if "depends" in conf or "optional_depends" in conf:
        return [d.strip() for d in conf.get("depends", "").split(",") if d.strip()]
    txt = os.path.join(folder, "depends.txt")
    if os.path.exists(txt):
        return [l.strip() for l in open(txt, encoding="utf-8", errors="ignore") if l.strip() and "?" not in l]
    return []


def scan(folder):
    """Mods d'un dossier, selon la règle de Luanti : un dossier avec init.lua est un mod (on n'y descend pas) ;
    on ne descend que dans les modpacks (modpack.conf ou modpack.txt)."""
    for child in sorted(os.listdir(folder)):
        path = os.path.join(folder, child)
        if child.startswith(".") or not os.path.isdir(path):
            continue
        if os.path.exists(os.path.join(path, "init.lua")):
            yield path
        elif os.path.exists(os.path.join(path, "modpack.conf")) or os.path.exists(os.path.join(path, "modpack.txt")):
            yield from scan(path)


def mod_name(path):
    return read_conf(os.path.join(path, "mod.conf")).get("name") or os.path.basename(path)


def main():
    server = {l.strip() for l in open(os.path.join(ROOT, "docs/audit/server_mods.txt"), encoding="utf-8")
              if l.strip() and not l.startswith("#")}
    game = {mod_name(p) for p in scan(os.path.join(GAME, "mods"))}
    mods, skipped_top, not_mods = {}, set(), []
    for top in sorted(os.listdir(SRC)):
        top_path = os.path.join(SRC, top)
        if top.startswith(".") or not os.path.isdir(top_path) or top_path == GAME:
            continue
        if SERVER_FOLDER.get(top, top) not in server:
            skipped_top.add(top)
            continue
        found = [top_path] if os.path.exists(os.path.join(top_path, "init.lua")) else list(scan(top_path))
        if not found:
            not_mods.append(top)
        for path in found:
            name = mod_name(path)
            if name in EXCLUDE or (name in mods and PREFER.get(name) != top):
                continue
            mods[name] = path
    game -= set(mods)   # remplacés par la version du serveur
    available = set(mods) | game
    excluded = {}
    changed = True
    while changed:
        changed = False
        for name, folder in list(mods.items()):
            missing = [d for d in hard_deps(folder) if d not in available]
            if missing:
                excluded[name] = missing
                del mods[name]
                available.discard(name)
                changed = True
    if os.path.isdir(OUT):
        shutil.rmtree(OUT)
    os.makedirs(OUT)
    for name, folder in sorted(mods.items()):
        os.symlink(folder, os.path.join(OUT, name))
    print(f"{len(mods)} mods liés dans {os.path.relpath(OUT, ROOT)} (jeu : {len(game)} mods de Minetest Game)")
    if skipped_top:
        print("dossiers absents de la liste du serveur, ignorés : " + ", ".join(sorted(skipped_top)))
    if not_mods:
        print("dossiers sans mod reconnu (ni init.lua, ni modpack) : " + ", ".join(not_mods))
    for name, why in sorted(EXCLUDE.items()):
        print(f"exclu {name} : {why}")
    for name, missing in sorted(excluded.items()):
        print(f"écarté {name} : dépendance absente {', '.join(missing)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
