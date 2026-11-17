#!/usr/bin/env python3
"""Hook PostToolUse (Edit|Write) : contrôle rapide et non destructif du fichier modifié.

- .lua  : compilation LuaJIT (`luajit -bl`, syntaxe seulement) ; luacheck en plus s'il est installé.
- .py   : compilation Python (py_compile).
- .json : JSON valide.
- .claude/agents/*.md, .claude/skills/*/SKILL.md : frontmatter présent avec name et description.
- Toute écriture dans .audit_src/ est signalée (sources tierces en lecture seule).
Code de sortie 2 = erreur renvoyée à Claude (le fichier est déjà écrit : il doit le corriger).
Aucun fichier n'est modifié par ce hook.
"""
import json, os, re, shutil, subprocess, sys

def fail(msg):
    print(msg, file=sys.stderr)
    sys.exit(2)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
path = (data.get("tool_input") or {}).get("file_path") or ""
if not path or not os.path.isfile(path):
    sys.exit(0)
root = os.environ.get("CLAUDE_PROJECT_DIR") or os.getcwd()
rel = os.path.relpath(path, root)

if rel.startswith(".audit_src" + os.sep):
    fail(f"{rel} : .audit_src/ contient des sources tierces en LECTURE SEULE (CLAUDE.md §3). Annule cette modification.")

if path.endswith(".lua"):
    luajit = shutil.which("luajit")
    if luajit:
        r = subprocess.run([luajit, "-bl", path, os.devnull], capture_output=True, text=True)
        if r.returncode != 0:
            fail(f"Erreur de syntaxe Lua dans {rel} :\n{(r.stderr or r.stdout).strip()}")
    luacheck = shutil.which("luacheck")
    if luacheck:
        r = subprocess.run([luacheck, "--no-color", "-q", path], capture_output=True, text=True, cwd=root)
        if r.returncode not in (0, 1):  # 1 = avertissements seulement
            fail(f"luacheck signale des erreurs dans {rel} :\n{r.stdout.strip()}")
elif path.endswith(".py"):
    r = subprocess.run([sys.executable, "-m", "py_compile", path], capture_output=True, text=True)
    if r.returncode != 0:
        fail(f"Erreur de syntaxe Python dans {rel} :\n{r.stderr.strip()}")
elif path.endswith(".json"):
    try:
        json.load(open(path, encoding="utf-8"))
    except Exception as e:
        fail(f"JSON invalide dans {rel} : {e}")
elif re.search(r"\.claude/(agents/[^/]+\.md|skills/[^/]+/SKILL\.md)$", path):
    text = open(path, encoding="utf-8").read()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        fail(f"{rel} : le frontmatter YAML doit commencer à la première ligne (---).")
    fm = m.group(1)
    for field in ("name", "description"):
        if not re.search(rf"^{field}:\s*\S", fm, re.M):
            fail(f"{rel} : champ « {field} » manquant dans le frontmatter.")
sys.exit(0)
