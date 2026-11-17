-- Intégration farming (redo, TenPlus1).
-- Événements émis :
--   farming:till — une houe a transformé un nœud en terre labourée (farming/hoes.lua:48-78, via core.set_node)
--   farming:sow  — une graine a été semée (farming/init.lua farming.place_seed, via core.set_node)
-- Ces actions n'appellent pas core.register_on_placenode : on enveloppe le on_use des houes et le on_place des
-- graines (core.override_item). L'original est appelé EN PREMIER avec les mêmes arguments et sa valeur de retour
-- est renvoyée telle quelle ; on compare seulement le nœud visé avant/après. Aucun autre comportement modifié.
local Q = minerland_quests
if not core.get_modpath("farming") then return end

Q.compat.declare_integration("farming", { keys = { "farming:till", "farming:sow" } })

local function node_name(pos)
	return pos and core.get_node(pos).name or ""
end

local function is_soil(name)
	return (core.get_item_group(name, "soil") or 0) >= 2 or name:find("^farming:soil") ~= nil
end

local function wrap_hoe(itemname, def)
	local orig = def.on_use
	if type(orig) ~= "function" then return end
	core.override_item(itemname, {
		on_use = function(itemstack, user, pointed_thing)
			local pos = pointed_thing and pointed_thing.type == "node" and pointed_thing.under or nil
			local before = node_name(pos)
			local res = orig(itemstack, user, pointed_thing)
			if pos then
				local ok, err = pcall(function()
					local after = node_name(pos)
					if after ~= before and is_soil(after) then
						local name = Q.events.real_player(user)
						if name then Q.events.emit(name, "custom", "farming:till", 1, { pos = pos }) end
					end
				end)
				if not ok then Q.util.log("error", "intégration farming (houe) : " .. tostring(err)) end
			end
			return res
		end,
	})
end

local function wrap_seed(itemname, def)
	local orig = def.on_place
	if type(orig) ~= "function" then return end
	core.override_item(itemname, {
		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing and pointed_thing.type == "node" and pointed_thing.above or nil
			local before = node_name(pos)
			local res = orig(itemstack, placer, pointed_thing)
			if pos then
				local ok, err = pcall(function()
					local after = node_name(pos)
					if after ~= before and after:find("^farming:") and after ~= "air" then
						local name = Q.events.real_player(placer)
						if name then Q.events.emit(name, "custom", "farming:sow", 1, { pos = pos }) end
					end
				end)
				if not ok then Q.util.log("error", "intégration farming (graine) : " .. tostring(err)) end
			end
			return res
		end,
	})
end

-- Une fois tous les objets connus : houes (préfixe farming:hoe_) et graines (groupe « seed »).
core.register_on_mods_loaded(function()
	local hoes, seeds = {}, {}
	for name, def in pairs(core.registered_items) do
		if name:find("^farming:hoe_") then
			hoes[#hoes + 1] = name
		elseif name:find("^farming:seed_") or (def.groups and (def.groups.seed or 0) > 0 and name:find("^farming:")) then
			seeds[#seeds + 1] = name
		end
	end
	for _, n in ipairs(hoes) do wrap_hoe(n, core.registered_items[n]) end
	for _, n in ipairs(seeds) do wrap_seed(n, core.registered_items[n]) end
end)
