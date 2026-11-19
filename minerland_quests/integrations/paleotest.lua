-- Intégration paleotest.
-- Événement émis : paleotest:egg_placed — un joueur pose un œuf de dinosaure (issu du cultivateur d'ADN).
-- Méthode (docs/audit/ch22_ch23.md) : l'œuf est un objet dont le on_place ajoute une entité (paleotest/api/register.lua
-- :351-357), sans aucun callback de pose. On enveloppe ce on_place (Q.compat.wrap_callback : original d'abord, valeurs
-- de retour inchangées) : réussite = l'œuf a été consommé. Limite : un œuf reçu d'un autre joueur compte aussi ;
-- l'éclosion et l'imprégnation n'émettent rien.
local Q = minerland_quests
if not core.get_modpath("paleotest") then return end

Q.compat.declare_integration("paleotest", { keys = { "paleotest:egg_placed" } })

local hooks = {
	before = function(stack)
		return { count = stack and stack:get_count() or 0 }
	end,
	after = function(st, res, _, placer)
		local out = res[1]
		if not st or out == nil or type(out) == "string" or out.get_count == nil then return end
		if out:get_count() < st.count then
			local name = Q.events.real_player(placer)
			if name then Q.events.emit(name, "custom", "paleotest:egg_placed", 1) end
		end
	end,
}

core.register_on_mods_loaded(function()
	local eggs = {}
	for name in pairs(core.registered_items) do
		if name:find("^paleotest:egg_") then eggs[#eggs + 1] = name end
	end
	table.sort(eggs)
	for _, name in ipairs(eggs) do Q.compat.wrap_callback(name, "on_place", hooks) end
end)
