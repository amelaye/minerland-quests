# Minerland Questbook — commandes de développement (voir docs/TOOLING.md)
VERSION := $(shell sed -n 's/^version = //p' minerland_quests/mod.conf)

.PHONY: check lint test validate textures check-textures docs dist audit-index fetch-sources clean

check: lint validate check-textures test   ## tout vérifier

lint:            ## syntaxe Lua (luacheck si installé)
	@./tools/lint.sh

test:            ## tests simulés (LuaJIT + mock de l'API)
	@luajit tests/run.lua

validate:        ## cohérence du catalogue de quêtes
	@python3 tools/validate_quests.py

textures:        ## régénère les textures procédurales
	@python3 tools/gen_textures.py

check-textures:  ## contrôle des PNG
	@python3 tools/check_textures.py

docs:            ## régénère docs/QUESTS.md
	@python3 tools/gen_docs.py

audit-index:     ## reconstruit l'index des objets depuis .audit_src
	@python3 tools/audit_mods.py .audit_src --index docs/audit/item_index.json

fetch-sources:   ## clone les sources publiques des mods (lecture seule)
	@./tools/fetch_sources.sh

dist: check      ## archive distribuable du mod seul
	@mkdir -p dist
	@rm -f dist/minerland_quests-$(VERSION).zip
	@zip -qr dist/minerland_quests-$(VERSION).zip minerland_quests -x '*.DS_Store'
	@echo "dist/minerland_quests-$(VERSION).zip"

clean:           ## supprime les fichiers générés temporaires (jamais les sources)
	@rm -rf dist tests/_tmp
