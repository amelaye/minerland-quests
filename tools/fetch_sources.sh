#!/bin/sh
# Clone (superficiel, lecture seule) les sources publiques des mods listés dans tools/audit_sources.txt
# vers .audit_src/ (ignoré par git). N'écrit nulle part ailleurs.
set -u
cd "$(dirname "$0")/.." || exit 1
mkdir -p .audit_src
while read -r name url; do
	case "$name" in ''|'#'*) continue;; esac
	if [ -d ".audit_src/$name/.git" ]; then echo "présent  $name"; continue; fi
	if GIT_TERMINAL_PROMPT=0 git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=60 \
		clone -q --depth 1 "$url" ".audit_src/$name" 2>/dev/null; then
		echo "cloné    $name"
	else
		echo "ÉCHEC    $name ($url)"
	fi
done < tools/audit_sources.txt
