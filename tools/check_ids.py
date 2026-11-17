#!/usr/bin/env python3
"""Vérifie des identifiants d'objets contre l'index d'audit (littéraux, alias) et les listes vérifiées.
Usage : python3 tools/check_ids.py id1 id2 ...   (ou sur stdin, un par ligne)"""
import json, os, sys, glob
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
idx = json.load(open(os.path.join(ROOT, "docs/audit/item_index.json"), encoding="utf-8"))
verified = {}
for f in glob.glob(os.path.join(ROOT, "docs/audit/verified_*.txt")):
    for line in open(f, encoding="utf-8"):
        line = line.strip()
        if line and not line.startswith("#"):
            parts = line.split("\t")
            verified[parts[0]] = parts[1] if len(parts) > 1 else f
ids = sys.argv[1:] or [l.strip() for l in sys.stdin if l.strip()]
bad = 0
for i in ids:
    if i in idx["items"]:
        print(f"OK      {i:50s} {idx['items'][i]}")
    elif i in verified:
        print(f"VERIF   {i:50s} {verified[i]}")
    elif i in idx["aliases"]:
        print(f"ALIAS   {i:50s} -> {idx['aliases'][i]['target']} {idx['aliases'][i]['source']}")
    else:
        print(f"ABSENT  {i}"); bad += 1
sys.exit(1 if bad else 0)
