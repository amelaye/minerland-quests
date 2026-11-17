-- Harnais des tests SIMULÉS : charge le vrai mod minerland_quests dans le mock de l'API (tests/mock_core.lua)
-- et fournit des actions de haut niveau (rejoindre, creuser, poser, fabriquer, manger, redémarrer…).
-- Ce harnais ne remplace pas un test dans le moteur Luanti réel (voir tests/integration/).
local M = {}

local ROOT = (debug.getinfo(1, "S").source:sub(2):match("^(.*)/tests/harness%.lua$")) or "."
M.ROOT = ROOT
M.MODPATH = ROOT .. "/minerland_quests"
package.path = ROOT .. "/?.lua;" .. package.path
local Mock = require("tests.mock_core")
M.Mock = Mock

---------------------------------------------------------------------------
-- Mini-framework de test
---------------------------------------------------------------------------
M.results = { passed = 0, failed = 0, failures = {} }
local current = ""

function M.describe(name, f)
	local prev = current
	current = (prev ~= "" and (prev .. " › ") or "") .. name
	f()
	current = prev
end

function M.it(name, f)
	local ok, err = xpcall(f, debug.traceback)
	if ok then
		M.results.passed = M.results.passed + 1
		io.write("  ok  ", current, " › ", name, "\n")
	else
		M.results.failed = M.results.failed + 1
		table.insert(M.results.failures, current .. " › " .. name .. "\n" .. tostring(err))
		io.write("  ÉCHEC ", current, " › ", name, "\n")
	end
end

local function fmt(v)
	if type(v) == "string" then return string.format("%q", v) end
	return tostring(v)
end

function M.eq(actual, expected, msg)
	if actual ~= expected then
		error((msg and (msg .. " : ") or "") .. "attendu " .. fmt(expected) .. ", obtenu " .. fmt(actual), 2)
	end
end

function M.ok(v, msg)
	if not v then error(msg or "condition fausse", 2) end
end

function M.contains(haystack, needle, msg)
	if not tostring(haystack):find(needle, 1, true) then
		error((msg or "texte absent") .. " : " .. fmt(needle), 2)
	end
end

function M.not_contains(haystack, needle, msg)
	if tostring(haystack):find(needle, 1, true) then
		error((msg or "texte inattendu") .. " : " .. fmt(needle), 2)
	end
end

function M.raises(f, pattern, msg)
	local ok, err = pcall(f)
	if ok then error((msg or "erreur attendue") .. " (aucune erreur levée)", 2) end
	if pattern and not tostring(err):find(pattern) then
		error((msg or "message d'erreur inattendu") .. " : " .. tostring(err), 2)
	end
end

---------------------------------------------------------------------------
-- Environnement simulé
---------------------------------------------------------------------------
local Env = {}
Env.__index = Env

-- Enregistre des objets « bouchons » pour toutes les références des quêtes (simule « tous les mods présents »).
local function register_referenced_items(core, Q)
	local function ensure(name, kind, groups)
		if not name or name == "" or name:find("%.png") then return end
		local n = name:match("^(%S+)")
		if not core.registered_items[n] and not core.registered_aliases[n] then
			if kind == "node" then core.register_node(n, { groups = groups or {} })
			else core.register_craftitem(n, { groups = groups or {} }) end
		end
	end
	for _, q in ipairs(Q.quest_list) do
		local t = q.trigger
		local kind = (t.type == "dig" or t.type == "place") and "node" or "craft"
		for _, it in ipairs(t.items) do ensure(it, kind) end
		for _, g in ipairs(t.groups) do ensure("test:group_" .. g, kind, { [g] = 1 }) end
		for _, s in ipairs(q.reward.items) do ensure(s, "craft") end
		if q.icon then ensure(q.icon, "craft") end
	end
	for _, c in ipairs(Q.chapter_list) do
		if c.icon then ensure(c.icon, "craft") end
	end
end

-- opts :
--   mods       = { "default", ... }   mods déclarés présents (core.get_modpath)
--   all_mods   = true                 tous les mods présents
--   all_items  = true                 objets bouchons pour toutes les références des quêtes
--   items      = { {name, kind, def} } objets supplémentaires enregistrés avant le chargement du mod
--   ui         = true                 simule unified_inventory
--   settings   = { ["minerland_quests.x"] = v }
--   before_finalize = function(Q, core) appelé après le chargement, avant on_mods_loaded
--   storage_data = table              backend de mod storage (pour simuler un redémarrage)
function M.env(opts)
	opts = opts or {}
	local mock = Mock.new({ modpath = M.MODPATH, mods = opts.mods, all_mods = opts.all_mods,
		settings = opts.settings, storage_data = opts.storage_data })
	local core = mock.core
	_G.core, _G.minetest = core, core
	_G.ItemStack = mock.ItemStack
	_G.minerland_quests = nil
	_G.default = { node_sound_wood_defaults = function() return {} end }
	_G.unified_inventory = nil
	if opts.ui then
		mock.mods.unified_inventory = true
		local ui = { pages = {}, buttons = {}, current_page = {} }
		function ui.register_page(name, def) ui.pages[name] = def end
		function ui.register_button(name, def) def.name = name table.insert(ui.buttons, def) end
		function ui.set_inventory_formspec(player, page)
			ui.current_page[player:get_player_name()] = page
			local style = { formw = 17.75, formh = 12.25, main_button_y = 11.0, main_button_x = 0.4, is_lite_mode = false }
			if opts.ui_lite then
				style = { formw = 14, formh = 9.75, main_button_y = 8.15, main_button_x = 10.5, is_lite_mode = true }
			end
			local data = ui.pages[page].get_formspec(player, style)
			player:set_inventory_formspec(data.formspec)
			ui.last = data
		end
		_G.unified_inventory = ui
	end
	for _, it in ipairs(opts.items or {}) do
		local name, kind, def = it[1], it[2] or "node", it[3] or {}
		if kind == "node" then core.register_node(name, def)
		elseif kind == "tool" then core.register_tool(name, def)
		elseif kind == "alias" then core.register_alias(name, def)
		else core.register_craftitem(name, def) end
	end

	dofile(M.MODPATH .. "/init.lua")
	local Q = _G.minerland_quests
	if opts.all_items then register_referenced_items(core, Q) end
	if opts.before_finalize then opts.before_finalize(Q, core) end
	for _, f in ipairs(mock.cb.mods_loaded) do f() end

	local self = setmetatable({ mock = mock, core = core, Q = Q, opts = opts, known = {} }, Env)
	return self
end

function Env:player(p)
	if type(p) == "table" then return p end
	return self.mock.players[p]
end

function Env:join(name, privs)
	local p = self.mock.new_player(name)
	self.mock.players[name] = p
	self.mock.privs[name] = privs or { interact = true }
	if not self.known[name] and not self.mock.storage_data["p:" .. name] then
		for _, f in ipairs(self.mock.cb.newplayer) do f(p) end
	end
	self.known[name] = true
	for _, f in ipairs(self.mock.cb.join) do f(p, nil) end
	return p
end

function Env:leave(name)
	local p = self.mock.players[name]
	for _, f in ipairs(self.mock.cb.leave) do f(p, false) end
	self.mock.players[name] = nil
end

function Env:fake_player(name)
	return self.mock.new_player(name, true)
end

local auto = 0
local function next_pos()
	auto = auto + 1
	return { x = auto, y = 0, z = 0 }
end

function Env:dig(who, nodename, pos)
	pos = pos or next_pos()
	local digger = type(who) == "string" and self:player(who) or who
	self.core.set_node(pos, { name = "air" })
	for _, f in ipairs(self.core.registered_on_dignodes) do f(pos, { name = nodename }, digger) end
	return pos
end

function Env:place(who, nodename, pos)
	pos = pos or next_pos()
	local placer = type(who) == "string" and self:player(who) or who
	local old = self.core.get_node(pos)
	self.core.set_node(pos, { name = nodename })
	for _, f in ipairs(self.core.registered_on_placenodes) do
		f(pos, { name = nodename }, placer, old, self.mock.ItemStack(nodename), { type = "node", above = pos, under = pos })
	end
	return pos
end

function Env:craft(who, item, count)
	local player = type(who) == "string" and self:player(who) or who
	local stack = self.mock.ItemStack(item .. " " .. (count or 1))
	for _, f in ipairs(self.mock.cb.craft) do f(stack, player, {}, nil) end
end

function Env:eat(who, item)
	local player = type(who) == "string" and self:player(who) or who
	for _, f in ipairs(self.mock.cb.eat) do f(2, nil, self.mock.ItemStack(item), player, nil) end
end

function Env:give(from, to, item)
	-- Transfert direct d'inventaire à inventaire : aucun callback moteur n'est appelé (comme dans le jeu).
	local a, b = self:player(from), self:player(to)
	local st = self.mock.ItemStack(item)
	if a then a:get_inventory():add_item("main", st) end
	b:get_inventory():add_item("main", st)
end

function Env:step(seconds, dt)
	dt = dt or 1
	local t = 0
	while t < seconds do
		self.mock.time = self.mock.time + dt
		t = t + dt
		for _, f in ipairs(self.mock.cb.globalstep) do f(dt) end
		local due, rest = {}, {}
		for _, a in ipairs(self.mock.after_queue) do
			if a.at <= self.mock.time then due[#due + 1] = a else rest[#rest + 1] = a end
		end
		self.mock.after_queue = rest
		for _, a in ipairs(due) do a.f(unpack(a.args)) end
	end
end

function Env:fields(who, formname, fields)
	local player = self:player(who)
	for _, f in ipairs(self.mock.cb.fields) do
		if f(player, formname, fields) then return true end
	end
	return false
end

function Env:chat(name, cmd, param)
	local def = self.core.registered_chatcommands[cmd]
	assert(def, "commande inconnue " .. cmd)
	if def.privs and not self.core.check_player_privs(name, def.privs) then return false, "privilèges insuffisants" end
	return def.func(name, param or "")
end

function Env:shutdown()
	for _, f in ipairs(self.mock.cb.shutdown) do f() end
end

-- Simule un arrêt propre puis un redémarrage : seules les données du mod storage survivent.
function Env:restart(new_opts)
	self:shutdown()
	local o = {}
	for k, v in pairs(self.opts) do o[k] = v end
	for k, v in pairs(new_opts or {}) do o[k] = v end
	o.storage_data = self.mock.storage_data
	local e = M.env(o)
	return e
end

-- Arrêt BRUTAL : on ne lance pas les callbacks d'arrêt (les écritures non vidées sont perdues).
function Env:crash_restart()
	local o = {}
	for k, v in pairs(self.opts) do o[k] = v end
	o.storage_data = self.mock.storage_data
	return M.env(o)
end

function Env:count(name, item)
	return self:player(name):get_inventory():count(item)
end

function Env:fill_inventory(name, item)
	local inv = self:player(name):get_inventory()
	for i = 1, #inv.lists.main do inv.lists.main[i] = self.mock.ItemStack(item) end
end

function Env:clear_inventory(name)
	local inv = self:player(name):get_inventory()
	for i = 1, #inv.lists.main do inv.lists.main[i] = self.mock.ItemStack("") end
end

function Env:state(name, qid)
	return self.Q.progress.state(name, qid)
end

function Env:chat_log(name)
	local out = {}
	for _, c in ipairs(self.mock.chat) do if c.to == name then out[#out + 1] = c.msg end end
	return table.concat(out, "\n")
end

-- Complète une quête par son propre déclencheur (circuit normal), quel que soit son type.
function Env:complete(name, qid)
	local q = self.Q.quests[qid]
	assert(q, "quête inconnue " .. qid)
	local t = q.trigger
	for _ = 1, t.count do
		if t.type == "custom" then
			self.Q.events.emit(name, "custom", t.key, 1)
		else
			local item
			for n in pairs(q.targets) do item = n break end
			if t.type == "dig" then self:dig(name, item)
			elseif t.type == "place" then self:place(name, item)
			elseif t.type == "craft" then self:craft(name, item, 1)
			elseif t.type == "eat" then self:eat(name, item) end
		end
	end
end

-- Complète une quête et tous ses prérequis (ordre topologique).
function Env:complete_with_requirements(name, qid, seen)
	seen = seen or {}
	if seen[qid] then return end
	seen[qid] = true
	local q = self.Q.quests[qid]
	for _, r in ipairs(q.requires) do
		if self.Q.quests[r] and not self.Q.quests[r].unavailable then self:complete_with_requirements(name, r, seen) end
	end
	if self:state(name, qid) == "available" then self:complete(name, qid) end
end

M.Env = Env
return M
