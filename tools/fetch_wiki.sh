#!/bin/sh
# Télécharge (en lecture seule) les pages du wiki Minerland utiles aux quêtes, au format texte DokuWiki, dans .wiki_cache/.
# Le dossier est ignoré par git. Les pages « mods » du wiki sont obsolètes : la liste réelle est docs/audit/server_mods.txt.
set -u
cd "$(dirname "$0")/.." || exit 1
mkdir -p .wiki_cache
for p in start mods lore spawn_station regles:start regles:comportement regles:conseils regles:construction regles:trains \
	commencer:start commencer:animaux commencer:maison commencer:outils commencer:tuto_arrivee \
	tutoriels:start tutoriels:capture tutoriels:dinosaures tutoriels:fruits_legumes tutoriels:celevator \
	tutoriels:telesieges tutoriels:pipeworks tutoriels:armes_et_outils \
	biomes:start biomes:base biomes:nether biomes:caverealms biomes:geodes biomes:ethereal \
	train:start metro:start bus:start bateaux:start; do
	f=$(echo "$p" | tr ':' '_')
	curl -s -m 25 "https://www.amelaye-in-minerland.fr/doku.php?id=$p&do=export_raw" -o ".wiki_cache/$f.txt" \
		&& echo "ok   $p" || echo "ECHEC $p"
done
