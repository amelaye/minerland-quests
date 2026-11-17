-- Bus d'événements : normalise les actions des joueurs et les transmet à la progression.
-- Callbacks moteur utilisés : dignode, placenode, craft, item_eat. Aucun scan, aucune boucle.
local Q = minerland_quests
local U = Q.util
local E = {}
Q.events = E

-- index[type][clé] = { quête, ... }  (construit à la finalisation)
local index = { dig = {}, place = {}, craft = {}, eat = {}, custom = {} }
local dig_targets = {}   -- ensemble des nœuds cibles de quêtes « dig » (pour l'anti-triche des blocs posés)

function E.build_index()
	index = { dig = {}, place = {}, craft = {}, eat = {}, custom = {} }
	dig_targets = {}
	for _, q in ipairs(Q.quest_list) do
		if not q.unavailable then
			local t = q.trigger
			if t.type == "custom" then
				index.custom[t.key] = index.custom[t.key] or {}
				table.insert(index.custom[t.key], q)
			else
				for name in pairs(q.targets or {}) do
					index[t.type][name] = index[t.type][name] or {}
					table.insert(index[t.type][name], q)
					if t.type == "dig" then dig_targets[name] = true end
				end
			end
		end
	end
end

function E.candidates(etype, key)
	local by = index[etype]
	return by and by[key]
end

function E.is_dig_target(name)
	return dig_targets[name] == true
end

-- Un « vrai » joueur : connecté, pas un faux joueur (fakelib/pipeworks/techage/digtron), pas une entité.
function E.real_player(obj)
	if obj == nil or type(obj) ~= "userdata" and type(obj) ~= "table" then return nil end
	if not obj.is_player or not obj:is_player() then return nil end
	if obj.is_fake_player then return nil end
	local name = obj:get_player_name()
	if type(name) ~= "string" or name == "" then return nil end
	if core.get_player_by_name(name) ~= obj then return nil end
	return name
end

local function counts_for(name)
	if U.setting_bool("count_creative", true) then return true end
	return not core.check_player_privs(name, { creative = true })
end

-- API publique pour les intégrations : émet un événement normalisé pour un joueur (nom déjà vérifié).
function E.emit(name, etype, key, count, ctx)
	if type(name) ~= "string" or not Q.TRIGGER_TYPES[etype] or type(key) ~= "string" then return 0 end
	if not core.get_player_by_name(name) then return 0 end
	if not counts_for(name) then return 0 end
	local ok, res = pcall(Q.progress.handle_event, name, etype, key, count or 1, ctx)
	if not ok then
		U.log("error", ("erreur en traitant %s/%s pour %s : %s"):format(etype, key, name, tostring(res)))
		return 0
	end
	return res
end

---------------------------------------------------------------------------
-- Callbacks moteur
---------------------------------------------------------------------------
core.register_on_dignode(function(pos, oldnode, digger)
	if not oldnode or not dig_targets[oldnode.name] then return end
	-- Un bloc-cible posé par un joueur (même reçu d'un autre) ne compte pas comme « miné ».
	if Q.storage.placed_take(U.pos_key(pos)) then return end
	local name = E.real_player(digger)
	if not name then return end
	E.emit(name, "dig", oldnode.name, 1, { pos = pos })
end)

core.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if not newnode then return end
	local name = E.real_player(placer)
	if dig_targets[newnode.name] then
		-- mémorisé quel que soit l'auteur (machine comprise) : ce bloc n'est pas « naturel »
		Q.storage.placed_add(U.pos_key(pos))
	end
	if name and index.place[newnode.name] then
		E.emit(name, "place", newnode.name, 1, { pos = pos })
	end
end)

core.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not itemstack or itemstack:is_empty() then return end
	local item = U.resolve_item(itemstack:get_name()) or itemstack:get_name()
	if not index.craft[item] then return end
	local name = E.real_player(player)
	if not name then return end
	E.emit(name, "craft", item, itemstack:get_count())
end)

core.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	if not itemstack or itemstack:is_empty() then return end
	local item = U.resolve_item(itemstack:get_name()) or itemstack:get_name()
	if not index.eat[item] then return end
	local name = E.real_player(user)
	if not name then return end
	E.emit(name, "eat", item, 1)
end)
