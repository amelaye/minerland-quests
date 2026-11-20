#!/bin/sh
# Test d'intégration RÉEL dans un serveur Luanti isolé (deux démarrages : vérifications puis persistance).
# Usage : tests/integration/run.sh <binaire_serveur> <dossier_minetest_game> [dossier_mods_optionnels]
#   binaire_serveur : luantiserver, ou « luanti » (lancé avec --server)
# Tout se passe dans tests/_tmp/itest/ : aucun monde ni réglage existant n'est touché.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
BIN=${1:?binaire serveur Luanti requis}
GAME=${2:?dossier du jeu minetest_game requis}
MODS=${3:-}
WORK="$ROOT/tests/_tmp/itest"
rm -rf "$WORK" && mkdir -p "$WORK/user/games" "$WORK/user/worlds/itest/worldmods"
ln -s "$(cd "$GAME" && pwd)" "$WORK/user/games/minetest"
W="$WORK/user/worlds/itest"
ln -s "$ROOT/minerland_quests" "$W/worldmods/minerland_quests"
ln -s "$ROOT/tests/integration/mlq_itest" "$W/worldmods/mlq_itest"
if [ -n "$MODS" ]; then
	for m in "$MODS"/*; do
		[ -d "$m" ] || continue
		n=$(basename "$m")
		[ -e "$W/worldmods/$n" ] || ln -s "$(cd "$m" && pwd)" "$W/worldmods/$n"
	done
fi
cat > "$W/world.mt" <<WMT
gameid = minetest
backend = sqlite3
player_backend = sqlite3
auth_backend = sqlite3
mod_storage_backend = sqlite3
WMT
cat > "$WORK/luanti.conf" <<CONF
minerland_quests.allow_reset = true
port = 30999
server_announce = false
CONF
case "$BIN" in *luantiserver*|*minetestserver*) SRV="$BIN";; *) SRV="$BIN --server";; esac
total=0
for phase in 1 2; do
	echo "== démarrage $phase"
	MINETEST_USER_PATH="$WORK/user" $SRV --world "$W" --config "$WORK/luanti.conf" \
		--logfile "$WORK/phase$phase.log" >/dev/null 2>&1
	grep -a "\[mlq_itest\]" "$WORK/phase$phase.log" | sed 's/^.*\[mlq_itest\]/  /'
	grep -aq "\[mlq_itest\] FIN phase $phase : 0 échec" "$WORK/phase$phase.log" || total=$((total + 1))
	grep -a "ERROR\[Main\]" "$WORK/phase$phase.log" | head -5
	# une erreur journalisée par le mod (ou une erreur Lua du serveur) fait échouer le test, même si les contrôles passent
	if grep -aq "ERROR\[.*\]: \(\[minerland_quests\]\|.*attempt to\|.*stack traceback\)" "$WORK/phase$phase.log"; then
		echo "  ERREUR journalisée par le mod ou le serveur (voir $WORK/phase$phase.log)"
		total=$((total + 1))
	fi
done
if [ "$total" -eq 0 ]; then echo "INTÉGRATION : OK (logs dans $WORK)"; else echo "INTÉGRATION : ÉCHEC (logs dans $WORK)"; fi
exit $total
