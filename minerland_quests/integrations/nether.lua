-- Intégration Nether (mod « nether » ; variante minetest-mods, compatible HybridDog pour l'allumage).
-- Événement émis : nether:portal_lit — un joueur allume un portail.
-- Méthode (docs/audit/ch20_ch21.md) : le portail s'allume en posant un fragment de cristal de Mese sur le cadre ; les
-- deux variantes surchargent le on_place de default:mese_crystal_fragment et ne consomment le fragment qu'en cas de
-- réussite (nether/portal_api.lua:2167-2186). On enveloppe ce on_place avec Q.compat.wrap_callback (original d'abord,
-- valeurs de retour inchangées) : réussite = fragment consommé, ou nœud de portail apparu à côté du cadre alors
-- qu'il n'y en avait pas avant (mode créatif, où rien n'est consommé). Cliquer un portail déjà allumé ne compte pas.
local Q = minerland_quests
if not core.get_modpath("nether") then return end

Q.compat.declare_integration("nether", { keys = { "nether:portal_lit" } })

local FRAGMENT = "default:mese_crystal_fragment"
local SIDES = { { x = 1, y = 0, z = 0 }, { x = -1, y = 0, z = 0 }, { x = 0, y = 1, z = 0 }, { x = 0, y = -1, z = 0 },
	{ x = 0, y = 0, z = 1 }, { x = 0, y = 0, z = -1 } }

local function is_frame(nodename)
	if type(nether) == "table" and type(nether.is_frame_node) == "table" and nether.is_frame_node[nodename] then
		return true
	end
	return nodename == "default:obsidian"
end

local function portal_next_to(pos)
	for _, d in ipairs(SIDES) do
		local n = core.get_node({ x = pos.x + d.x, y = pos.y + d.y, z = pos.z + d.z }).name
		if n:find("^nether:portal") then return true end
	end
	return false
end

local hooks = {
	before = function(stack, _, pointed_thing)
		local pos = pointed_thing and pointed_thing.type == "node" and pointed_thing.under
		if not pos or not is_frame(core.get_node(pos).name) then return nil end
		return { pos = pos, count = stack and stack:get_count() or 0, portal = portal_next_to(pos) }
	end,
	after = function(st, res, _, placer)
		if not st then return end
		local out = res[1]
		local consumed = out ~= nil and type(out) ~= "string" and out.get_count ~= nil and out:get_count() < st.count
		local appeared = not st.portal and portal_next_to(st.pos)
		if consumed or appeared then
			local name = Q.events.real_player(placer)
			if name then Q.events.emit(name, "custom", "nether:portal_lit", 1, { pos = st.pos }) end
		end
	end,
}

core.register_on_mods_loaded(function()
	Q.compat.wrap_callback(FRAGMENT, "on_place", hooks)
end)
