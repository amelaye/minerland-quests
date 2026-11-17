#!/bin/sh
# Analyse statique du Lua : luacheck s'il est installé (config .luacheckrc), sinon contrôle de syntaxe LuaJIT.
cd "$(dirname "$0")/.." || exit 1
status=0
if command -v luacheck >/dev/null 2>&1; then
	luacheck minerland_quests tests tools || status=$?
	# luacheck : 1 = avertissements seulement (non bloquant), >1 = erreurs
	[ "$status" -le 1 ] && status=0
else
	echo "luacheck absent : contrôle de syntaxe LuaJIT uniquement (installer : luarocks install luacheck)"
	for f in $(find minerland_quests tests tools -name '*.lua'); do
		luajit -bl "$f" /dev/null >/dev/null 2>/tmp/mlq_lint_err.$$ || { cat /tmp/mlq_lint_err.$$; status=1; }
	done
	rm -f /tmp/mlq_lint_err.$$
	# globales accidentelles dans le mod : affectation au niveau supérieur sans « local » (hors table du mod)
	if grep -nE '^[A-Za-z_][A-Za-z0-9_]* *= ' $(find minerland_quests -name '*.lua') | grep -v '^[^:]*:[0-9]*:minerland_quests *='; then
		echo "ERREUR : affectation globale ci-dessus (utiliser local)"; status=1
	fi
fi
[ "$status" -eq 0 ] && echo "lint : OK"
exit $status
