-- Compatibilité : détermine, une fois tous les mods chargés, quelles quêtes sont jouables sur ce serveur,
-- résout les objets cibles (alias, groupes) et filtre les récompenses inexistantes.
local Q = minerland_quests
local U = Q.util
local C = {}
Q.compat = C

C.integrations = {}   -- [nom] = { keys = {...}, active = true }
C.reward_problems = {}

function C.declare_integration(name, info)
	info = info or {}
	info.active = true
	C.integrations[name] = info
end

function C.mod_present(modname)
	return core.get_modpath(modname) ~= nil
end

-- Liste des objets enregistrés appartenant à un groupe (calculée une seule fois par groupe).
local group_cache = {}
function C.items_in_group(group)
	if group_cache[group] then return group_cache[group] end
	local out = {}
	for name, def in pairs(core.registered_items) do
		if def.groups and (def.groups[group] or 0) > 0 then
			out[#out + 1] = name
		end
	end
	table.sort(out)
	group_cache[group] = out
	return out
end

local function resolve_targets(q)
	local t = q.trigger
	if t.type == "custom" then return {}, {} end
	local targets, missing = {}, {}
	for _, name in ipairs(t.items) do
		local r = U.resolve_item(name)
		if r then targets[r] = true else missing[#missing + 1] = name end
	end
	for _, g in ipairs(t.groups) do
		local members = C.items_in_group(g)
		if #members == 0 then missing[#missing + 1] = "group:" .. g end
		for _, name in ipairs(members) do targets[name] = true end
	end
	return targets, missing
end

local function check_quest(q)
	-- 1) mods requis
	for _, m in ipairs(q.mods) do
		if not C.mod_present(m) then
			return ("Le mod « %s » n'est pas activé sur ce serveur."):format(m)
		end
	end
	-- 2) objets cibles
	local targets, missing = resolve_targets(q)
	q.targets = targets
	q.targets_missing = missing
	if q.trigger.type ~= "custom" and next(targets) == nil then
		return "Objet introuvable sur ce serveur : " .. table.concat(missing, ", ")
	end
	-- 3) déclencheur custom : l'intégration doit être active
	if q.trigger.type == "custom" then
		local prefix = q.trigger.key:match("^([^:]+):")
		if prefix and not C.integrations[prefix] then
			return ("L'intégration « %s » n'est pas active sur ce serveur."):format(prefix)
		end
	end
	return nil
end

local function check_reward(q)
	local ok, bad = {}, {}
	for _, s in ipairs(q.reward.items) do
		local stack = ItemStack(s)
		local r = U.resolve_item(stack:get_name())
		if r then
			stack:set_name(r)
			ok[#ok + 1] = stack:to_string()
		else
			bad[#bad + 1] = s
		end
	end
	q.reward_items, q.reward_missing = ok, bad
	if #bad > 0 then
		local msg = ("quête %s : récompense(s) introuvable(s) retirée(s) : %s"):format(q.id, table.concat(bad, ", "))
		C.reward_problems[#C.reward_problems + 1] = msg
		U.log("warning", msg)
	end
end

local function resolve_icon(q)
	if q.icon and q.icon:match("%.png") then
		q.icon_kind, q.icon_value = "image", q.icon
		return
	end
	local r = q.icon and U.resolve_item(q.icon)
	if not r and q.targets then
		local first = next(q.targets)
		local names = {}
		for n in pairs(q.targets) do names[#names + 1] = n end
		table.sort(names)
		r = names[1] or first
	end
	if r then
		q.icon_kind, q.icon_value = "item", r
	else
		q.icon_kind, q.icon_value = "image", "mlq_icon_quest.png"
	end
end

function C.finalize()
	group_cache = {}
	C.reward_problems = {}
	for _, q in ipairs(Q.quest_list) do
		if not q.unavailable then
			q.unavailable = check_quest(q)
		else
			q.targets = q.targets or {}
		end
		check_reward(q)
		resolve_icon(q)
	end
	for _, c in ipairs(Q.chapter_list) do
		local r = c.icon and U.resolve_item(c.icon)
		c.icon_item = r
	end
end
