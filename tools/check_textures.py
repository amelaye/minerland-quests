#!/usr/bin/env python3
"""Contrôle des textures du mod.

- chaque texture « mlq_*.png » citée dans le code Lua existe dans minerland_quests/textures/ ;
- chaque PNG est valide (signature, IHDR), aux dimensions attendues (EXPECTED ci-dessous ou multiple de 16 conseillé) ;
- les textures présentes mais jamais citées sont signalées (avertissement) ;
- aucun fichier non-PNG ni nom hors convention (préfixe mlq_) dans textures/.
Usage : python3 tools/check_textures.py      (code 1 en cas d'erreur)
"""
import os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pngkit import read_png_info

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MOD = os.path.join(ROOT, "minerland_quests")
TEX = os.path.join(MOD, "textures")

# Dimensions imposées (largeur, hauteur) pour les textures dont l'interface dépend.
EXPECTED = {
    # bouton Unified Inventory : 128 px lisse, comme les icônes d'Unified Inventory (ui_*_icon.png)
    "mlq_book.png": (16, 16), "mlq_charter.png": (16, 16), "mlq_ui_button.png": (128, 128),
    "mlq_badge_done.png": (16, 16), "mlq_badge_locked.png": (16, 16), "mlq_badge_available.png": (16, 16),
    "mlq_badge_unavailable.png": (16, 16),
    "mlq_frame_done.png": (32, 32), "mlq_frame_locked.png": (32, 32), "mlq_frame_available.png": (32, 32),
    "mlq_frame_unavailable.png": (32, 32),
}
REF_RE = re.compile(r"mlq_[a-z0-9_]+\.png")


def referenced():
    refs = {}
    for dirpath, _, files in os.walk(MOD):
        for fn in files:
            if fn.endswith(".lua"):
                p = os.path.join(dirpath, fn)
                for no, line in enumerate(open(p, encoding="utf-8"), 1):
                    for m in REF_RE.finditer(line):
                        refs.setdefault(m.group(0), f"{os.path.relpath(p, ROOT)}:{no}")
    # textures construites dynamiquement ("mlq_frame_" .. state .. ".png", etc.)
    for state in ("done", "locked", "available", "unavailable"):
        for base in ("mlq_frame_", "mlq_badge_"):
            refs.setdefault(f"{base}{state}.png", "ui/views.lua (dynamique)")
    for part in ("fundamentals", "daily_life", "transport", "technology", "exploration", "building"):
        refs.setdefault(f"mlq_emblem_{part}.png", "core/registry.lua (dynamique)")
        refs.setdefault(f"mlq_part_{part}.png", "quests/parts.lua")
    for v in ("mlq_btn", "mlq_btn_gold"):
        for suffix in ("", "_hover", "_press"):
            refs.setdefault(f"{v}{suffix}.png", "ui/theme.lua (dynamique)")
    return refs


def main():
    errors, warnings = [], []
    refs = referenced()
    present = set()
    if os.path.isdir(TEX):
        for fn in sorted(os.listdir(TEX)):
            p = os.path.join(TEX, fn)
            if not fn.endswith(".png"):
                errors.append(f"textures/{fn} : fichier non PNG")
                continue
            if not fn.startswith("mlq_"):
                errors.append(f"textures/{fn} : nom hors convention (préfixe mlq_)")
            present.add(fn)
            try:
                info = read_png_info(p)
            except ValueError as e:
                errors.append(f"textures/{fn} : PNG invalide ({e})")
                continue
            exp = EXPECTED.get(fn)
            if exp and (info["width"], info["height"]) != exp:
                errors.append(f"textures/{fn} : {info['width']}×{info['height']} au lieu de {exp[0]}×{exp[1]}")
            elif info["width"] > 512 or info["height"] > 512:
                warnings.append(f"textures/{fn} : grande texture {info['width']}×{info['height']}")
    for name, where in sorted(refs.items()):
        if name not in present:
            errors.append(f"{name} manquante (citée dans {where})")
    for name in sorted(present - set(refs)):
        warnings.append(f"textures/{name} présente mais jamais citée")
    for w in warnings:
        print("AVERTISSEMENT " + w)
    for e in errors:
        print("ERREUR " + e)
    print(f"{len(present)} texture(s), {len(refs)} référence(s) ; {len(errors)} erreur(s), {len(warnings)} avertissement(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
