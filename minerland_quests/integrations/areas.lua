-- Intégration areas (zones protégées par commande).
-- Événement émis : areas:protect — une zone principale (sans zone parente) vient d'être créée au nom d'un joueur
-- connecté, typiquement par /protect (auto-protection active sur Minerland : areas.self_protection).
-- Méthode : API publique areas:registerOnAdd(func(id, area)), appelée par areas:add (areas/api.lua:59,
-- internal.lua:111-123). Exclu : les sous-zones (/add_owner crée une zone fille pour un autre joueur, parent ≠ nil).
-- Limite : une zone principale attribuée par l'administration (/set_owner) au nom d'un joueur connecté compte aussi.
local Q = minerland_quests
if not core.get_modpath("areas") then return end
if type(areas) ~= "table" or type(areas.registerOnAdd) ~= "function" then
	Q.util.log("warning", "areas : API registerOnAdd absente, protections non détectées")
	return
end

Q.compat.declare_integration("areas", { keys = { "areas:protect" } })

areas:registerOnAdd(function(_, area)
	local ok, err = pcall(function()
		if type(area) ~= "table" or area.parent ~= nil then return end
		local owner = area.owner
		if type(owner) ~= "string" or owner == "" or not core.get_player_by_name(owner) then return end
		Q.events.emit(owner, "custom", "areas:protect", 1)
	end)
	if not ok then Q.util.log("error", "intégration areas : " .. tostring(err)) end
end)
