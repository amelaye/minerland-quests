-- Intégration farming (redo, TenPlus1).
-- Événements émis :
--   farming:till — une houe a transformé un nœud en terre labourée (farming/hoes.lua:48-78, via core.set_node)
--   farming:sow  — une graine a été semée (farming/init.lua farming.place_seed, via core.set_node)
-- Ces actions n'appellent pas core.register_on_placenode : on enveloppe le on_use des houes et le on_place des
-- graines avec Q.compat.wrap_callback (original appelé en premier, valeurs de retour inchangées) et on compare
-- seulement le nœud visé avant/après. Aucun autre comportement modifié.
local Q = minerland_quests
if not core.get_modpath("farming") then return end

Q.compat.declare_integration("farming", { keys = { "farming:till", "farming:sow" } })

local function node_name(pos)
	return pos and core.get_node(pos).name or ""
end

local function is_soil(name)
	return (core.get_item_group(name, "soil") or 0) >= 2 or name:find("^farming:soil") ~= nil
end

local function target(pointed_thing, side)
	return pointed_thing and pointed_thing.type == "node" and pointed_thing[side] or nil
end

local hoe_hooks = {
	before = function(_, _, pointed_thing)
		local pos = target(pointed_thing, "under")
		return pos and { pos = pos, name = node_name(pos) }
	end,
	after = function(st, _, _, user)
		if not st then return end
		local now = node_name(st.pos)
		if now ~= st.name and is_soil(now) then
			local name = Q.events.real_player(user)
			if name then Q.events.emit(name, "custom", "farming:till", 1, { pos = st.pos }) end
		end
	end,
}

local seed_hooks = {
	before = function(_, _, pointed_thing)
		local pos = target(pointed_thing, "above")
		return pos and { pos = pos, name = node_name(pos) }
	end,
	after = function(st, _, _, placer)
		if not st then return end
		local now = node_name(st.pos)
		if now ~= st.name and now ~= "air" and now:find("^farming:") then
			local name = Q.events.real_player(placer)
			if name then Q.events.emit(name, "custom", "farming:sow", 1, { pos = st.pos }) end
		end
	end,
}

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
	for _, n in ipairs(hoes) do Q.compat.wrap_callback(n, "on_use", hoe_hooks) end
	for _, n in ipairs(seeds) do Q.compat.wrap_callback(n, "on_place", seed_hooks) end
end)
