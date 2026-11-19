-- Intégration mobs_redo (mod « mobs ») et mods d'animaux qui s'appuient dessus (mobs_animal, mob_horse, animalworld).
-- Événements émis (et la même clé suivie de « :<entité> » pour des quêtes plus précises) :
--   mobs:tame    — un animal devient apprivoisé avec ce joueur pour propriétaire (mobs:feed_tame, mobs/api.lua:4417)
--   mobs:capture — un animal disparaît pendant le clic droit d'un joueur tenant main vide, filet ou lasso
--                  (mobs:capture_mob, mobs/api.lua:4208 : l'animal devient un objet d'inventaire)
-- Méthode (docs/audit/ch06_ch09.md §3) : mobs_redo n'a aucun callback global. On enveloppe le on_rightclick des
-- définitions d'entités de mobs (_cmi_is_mob) : original appelé en premier, valeurs de retour rendues telles quelles,
-- comparaison de l'état avant/après protégée par pcall. Les définitions servent de métatable aux instances :
-- l'enveloppe vaut aussi pour les animaux déjà actifs. Les PNJ (mobs_npc) sont exclus.
-- Limites : relâcher un animal (entité ajoutée sans pose) et la naissance ne sont pas détectés ; une boucle
-- capture/relâche est possible, d'où aucun compteur supérieur à 1 sur la capture.
local Q = minerland_quests
if not core.get_modpath("mobs") then return end

Q.compat.declare_integration("mobs", { keys = { "mobs:tame", "mobs:capture" } })

local CAPTURE_TOOLS = { [""] = true, ["mobs:net"] = true, ["mobs:lasso"] = true }

local function pack(...)
	return { n = select("#", ...), ... }
end

local function wrap(entity_name, def)
	local orig = def.on_rightclick
	def.on_rightclick = function(self, clicker, ...)
		local ok_b, before = pcall(function()
			local tool = clicker and clicker.get_wielded_item and clicker:get_wielded_item():get_name() or nil
			return { tamed = self.tamed and true or false, tool = tool }
		end)
		local res = pack(orig(self, clicker, ...))
		if ok_b and before then
			local ok, err = pcall(function()
				local name = Q.events.real_player(clicker)
				if not name then return end
				if not before.tamed and self.tamed and self.owner == name then
					Q.events.emit(name, "custom", "mobs:tame", 1)
					Q.events.emit(name, "custom", "mobs:tame:" .. entity_name, 1)
				end
				if before.tool and CAPTURE_TOOLS[before.tool] and self.object and self.object:get_pos() == nil then
					Q.events.emit(name, "custom", "mobs:capture", 1)
					Q.events.emit(name, "custom", "mobs:capture:" .. entity_name, 1)
				end
			end)
			if not ok then Q.util.log("error", "intégration mobs (" .. entity_name .. ") : " .. tostring(err)) end
		end
		return unpack(res, 1, res.n)
	end
end

core.register_on_mods_loaded(function()
	local names = {}
	for name, def in pairs(core.registered_entities or {}) do
		if type(def) == "table" and def._cmi_is_mob and type(def.on_rightclick) == "function"
				and not name:find("^mobs_npc:") then
			names[#names + 1] = name
		end
	end
	for _, name in ipairs(names) do wrap(name, core.registered_entities[name]) end
end)
