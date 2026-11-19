-- Compatibilité : détermine, une fois tous les mods chargés, quelles quêtes sont jouables sur ce serveur,
-- résout les objets cibles (alias, groupes) et filtre les récompenses inexistantes.
local Q = minerland_quests
local N = Q.i18n.N
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

---------------------------------------------------------------------------
-- API des intégrations (voir docs/ARCHITECTURE.md §6)
---------------------------------------------------------------------------

-- Enveloppe un callback de DÉFINITION d'un objet (on_use, on_place, on_rightclick, on_punch,
-- on_metadata_inventory_take, on_receive_fields…) sans en changer le comportement :
--   * l'original est appelé EN PREMIER, avec les mêmes arguments ; toutes ses valeurs de retour sont renvoyées ;
--   * before(...) (facultatif) capture un état avant l'appel ; after(state, res, ...) observe le résultat
--     (res = valeurs de retour de l'original, res.n = leur nombre ; ne pas modifier) ;
--   * before/after sont protégés par pcall : une erreur de l'intégration ne casse jamais le mod tiers.
-- Si l'objet n'a pas de callback pour ce champ, `fallback` (ex. core.item_place) est utilisé s'il est fourni,
-- sinon rien n'est enveloppé. Retourne true si l'enveloppe est posée. Un même champ n'est enveloppé qu'une fois.
local wrapped = {}
local function pack(...)
	return { n = select("#", ...), ... }
end

function C.wrap_callback(itemname, field, hooks, fallback)
	local def = core.registered_items[itemname]
	if not def then return false end
	local key = itemname .. "\0" .. field
	if wrapped[key] then return false end
	local orig = def[field]
	if type(orig) ~= "function" then
		if type(fallback) ~= "function" then return false end
		orig = fallback
	end
	local label = ("intégration %s/%s"):format(itemname, field)
	core.override_item(itemname, {
		[field] = function(...)
			local state
			if hooks.before then
				local ok, s = pcall(hooks.before, ...)
				if ok then state = s else U.log("error", label .. " (avant) : " .. tostring(s)) end
			end
			local res = pack(orig(...))
			if hooks.after then
				local ok, err = pcall(hooks.after, state, res, ...)
				if not ok then U.log("error", label .. " (après) : " .. tostring(err)) end
			end
			return unpack(res, 1, res.n)
		end,
	})
	wrapped[key] = true
	return true
end

-- Lecture lente d'un état public : un seul globalstep partagé, une passe sur les joueurs connectés par intervalle.
--   fn(player, name) est appelée pour chaque joueur connecté toutes les `interval` secondes (≥ 1).
-- Coût : O(joueurs connectés × sondes) par intervalle ; aucune sonde ne doit scanner la carte ni les inventaires.
local polls = {}
function C.register_poll(id, interval, fn)
	assert(type(id) == "string" and type(fn) == "function")
	polls[#polls + 1] = { id = id, interval = math.max(1, tonumber(interval) or 2), fn = fn, timer = 0 }
end

core.register_globalstep(function(dtime)
	if #polls == 0 then return end
	local players
	for _, p in ipairs(polls) do
		p.timer = p.timer + dtime
		if p.timer >= p.interval then
			p.timer = 0
			players = players or core.get_connected_players()
			for _, player in ipairs(players) do
				local ok, err = pcall(p.fn, player, player:get_player_name())
				if not ok then U.log("error", ("sonde %s : %s"):format(p.id, tostring(err))) end
			end
		end
	end
end)

-- Pour les tests : force un passage de toutes les sondes.
function C._run_polls()
	for _, p in ipairs(polls) do
		for _, player in ipairs(core.get_connected_players()) do p.fn(player, player:get_player_name()) end
	end
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

-- Vérifie qu'une quête est jouable ici ; sinon la marque indisponible avec une raison traduisible.
local function check_quest(q)
	-- 1) mods requis
	for _, m in ipairs(q.mods) do
		if not C.mod_present(m) then
			return Q.mark_unavailable(q, N("Le mod « @1 » n'est pas activé sur ce serveur."), m)
		end
	end
	-- 2) objets cibles
	local targets, missing = resolve_targets(q)
	q.targets = targets
	q.targets_missing = missing
	if q.trigger.type ~= "custom" and next(targets) == nil then
		return Q.mark_unavailable(q, N("Objet introuvable sur ce serveur : @1"), table.concat(missing, ", "))
	end
	-- 3) déclencheur custom : l'intégration doit être active
	if q.trigger.type == "custom" then
		local prefix = q.trigger.key:match("^([^:]+):")
		if prefix and not C.integrations[prefix] then
			return Q.mark_unavailable(q, N("L'intégration « @1 » n'est pas active sur ce serveur."), prefix)
		end
	end
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
			check_quest(q)
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
