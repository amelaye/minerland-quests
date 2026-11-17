-- Le Grand Livre des Quêtes de Minerland — point d'entrée.
-- Ce fichier ne fait que charger les modules dans l'ordre ; aucune logique ici.

local modpath = core.get_modpath(core.get_current_modname())

minerland_quests = {
	version = "1.0.0",
	modpath = modpath,
	S = core.get_translator("minerland_quests"),
}

local function load(rel)
	dofile(modpath .. "/" .. rel .. ".lua")
end

-- Cœur (ordre significatif)
load("core/util")
load("core/registry")
load("core/graph")
load("core/storage")
load("core/compat")
load("core/progress")
load("core/rewards")
load("core/events")
load("core/admin")

-- Interface
load("ui/theme")
load("ui/notifications")
load("ui/views")
load("ui/book")
load("ui/inventory")
load("ui/items")

-- Données : parties, chapitres puis quêtes
load("quests/parts")
for _, part in ipairs({"fundamentals", "daily_life", "transport", "technology", "exploration", "building"}) do
	local dir = modpath .. "/quests/" .. part
	local files = core.get_dir_list(dir, false)
	table.sort(files)
	for _, file in ipairs(files) do
		if file:match("%.lua$") then
			dofile(dir .. "/" .. file)
		end
	end
end

-- Intégrations : chaque fichier sort immédiatement si son mod est absent
do
	local dir = modpath .. "/integrations"
	local files = core.get_dir_list(dir, false)
	table.sort(files)
	for _, file in ipairs(files) do
		if file:match("%.lua$") then
			dofile(dir .. "/" .. file)
		end
	end
end

-- Finalisation (validation des références, index des déclencheurs) une fois tous les mods chargés
core.register_on_mods_loaded(function()
	minerland_quests.finalize()
end)
