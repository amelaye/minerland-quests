-- Intégration goops_rings (dossier serveur « rings ») + 3d_armor.
-- Événements émis :
--   rings:equip    — un anneau goops_rings est équipé (callback public armor:register_on_equip, 3d_armor/api.lua:271)
--   rings:activate — un anneau passe à l'état actif (rings.users[nom].flags.status == 1, rings/activation.lua:5-30)
--   rings:flight   — l'effet actif est « Flight Privilege » (rings/effects.lua:210)
--   rings:activate_other — un effet actif autre que le vol (Fire Resistance, Breath Hold, Shining, Iron Fist)
-- Méthode : callback public + lecture lente (toutes les 2 s, O(joueurs connectés)) de la table publique rings.users.
-- Aucune fonction du mod n'est remplacée. Le privilège fly reste entièrement géré par goops_rings.
local Q = minerland_quests
if not core.get_modpath("goops_rings") then return end

Q.compat.declare_integration("rings", {
	keys = { "rings:equip", "rings:activate", "rings:activate_other", "rings:flight" } })

if core.get_modpath("3d_armor") and armor and armor.register_on_equip then
	armor:register_on_equip(function(player, index, stack)
		if not stack or stack:is_empty() then return end
		if stack:get_name():sub(1, 12) ~= "goops_rings:" then return end
		local name = Q.events.real_player(player)
		if name then Q.events.emit(name, "custom", "rings:equip", 1) end
	end)
end

local last = {}   -- [nom] = nom de l'effet actif lors du dernier passage (évite les répétitions)
local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 2 then return end
	timer = 0
	if type(rings) ~= "table" or type(rings.users) ~= "table" then return end
	for _, player in ipairs(core.get_connected_players()) do
		local name = player:get_player_name()
		local p = rings.users[name]
		local fx = p and p.flags and p.flags.status == 1 and p.fx and p.fx.name or nil
		if fx and last[name] ~= fx then
			Q.events.emit(name, "custom", "rings:activate", 1)
			if fx == "Flight Privilege" then
				Q.events.emit(name, "custom", "rings:flight", 1)
			else
				Q.events.emit(name, "custom", "rings:activate_other", 1)
			end
		end
		last[name] = fx
	end
end)

core.register_on_leaveplayer(function(player)
	last[player:get_player_name()] = nil
end)
