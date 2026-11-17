-- Mock minimal de l'API Luanti pour les tests SIMULÉS (LuaJIT). Il ne reproduit pas le moteur :
-- il fournit ce que minerland_quests utilise, avec un comportement documenté et déterministe.
local M = {}

---------------------------------------------------------------------------
-- JSON (sous-ensemble : objets, tableaux, chaînes, nombres, booléens, null)
---------------------------------------------------------------------------
local function is_array(t)
	local n = 0
	for k in pairs(t) do
		if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then return false end
		n = n + 1
	end
	for i = 1, n do if t[i] == nil then return false end end
	return true, n
end

local function enc_str(s)
	return '"' .. s:gsub('[%c"\\]', function(c)
		local map = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t' }
		return map[c] or string.format("\\u%04x", c:byte())
	end) .. '"'
end

function M.write_json(v)
	local t = type(v)
	if v == nil then return "null"
	elseif t == "boolean" then return tostring(v)
	elseif t == "number" then
		if v ~= v or v == math.huge or v == -math.huge then return nil, "nombre invalide" end
		if v % 1 == 0 then return string.format("%d", v) end
		return string.format("%.14g", v)
	elseif t == "string" then return enc_str(v)
	elseif t == "table" then
		local arr, n = is_array(v)
		local parts = {}
		if arr and n > 0 then
			for i = 1, n do
				local s, err = M.write_json(v[i])
				if not s then return nil, err end
				parts[i] = s
			end
			return "[" .. table.concat(parts, ",") .. "]"
		end
		if next(v) == nil then return "null" end
		local keys = {}
		for k in pairs(v) do
			if type(k) ~= "string" and type(k) ~= "number" then return nil, "clé invalide" end
			keys[#keys + 1] = k
		end
		table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
		for _, k in ipairs(keys) do
			local s, err = M.write_json(v[k])
			if not s then return nil, err end
			parts[#parts + 1] = enc_str(tostring(k)) .. ":" .. s
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return nil, "type non sérialisable : " .. t
end

function M.parse_json(s)
	local pos = 1
	local function ws() pos = s:find("[^ \t\r\n]", pos) or #s + 1 end
	local value
	local function str()
		local out = {}
		pos = pos + 1
		while true do
			local c = s:sub(pos, pos)
			if c == "" then error("chaîne non terminée") end
			if c == '"' then pos = pos + 1 break end
			if c == "\\" then
				local e = s:sub(pos + 1, pos + 1)
				local map = { n = "\n", r = "\r", t = "\t", ['"'] = '"', ["\\"] = "\\", ["/"] = "/" }
				if e == "u" then
					out[#out + 1] = string.char(tonumber(s:sub(pos + 2, pos + 5), 16) % 256)
					pos = pos + 6
				else
					out[#out + 1] = map[e] or e
					pos = pos + 2
				end
			else
				out[#out + 1] = c
				pos = pos + 1
			end
		end
		return table.concat(out)
	end
	function value()
		ws()
		local c = s:sub(pos, pos)
		if c == "{" then
			local t = {}
			pos = pos + 1
			ws()
			if s:sub(pos, pos) == "}" then pos = pos + 1 return t end
			while true do
				ws()
				local k = str()
				ws()
				assert(s:sub(pos, pos) == ":", "':' attendu")
				pos = pos + 1
				t[k] = value()
				ws()
				local d = s:sub(pos, pos)
				pos = pos + 1
				if d == "}" then return t end
				assert(d == ",", "',' attendu")
			end
		elseif c == "[" then
			local t = {}
			pos = pos + 1
			ws()
			if s:sub(pos, pos) == "]" then pos = pos + 1 return t end
			while true do
				t[#t + 1] = value()
				ws()
				local d = s:sub(pos, pos)
				pos = pos + 1
				if d == "]" then return t end
				assert(d == ",", "',' attendu")
			end
		elseif c == '"' then return str()
		elseif s:sub(pos, pos + 3) == "true" then pos = pos + 4 return true
		elseif s:sub(pos, pos + 4) == "false" then pos = pos + 5 return false
		elseif s:sub(pos, pos + 3) == "null" then pos = pos + 4 return nil
		else
			local num = s:match("^-?%d+%.?%d*[eE]?[-+]?%d*", pos)
			assert(num and #num > 0, "valeur JSON invalide à " .. pos)
			pos = pos + #num
			return tonumber(num)
		end
	end
	local ok, res = pcall(value)
	if not ok then return nil end
	return res
end

function M.key(pos)
	return string.format("%d,%d,%d", pos.x, pos.y, pos.z)
end

---------------------------------------------------------------------------
-- Environnement simulé
---------------------------------------------------------------------------
function M.new(opts)
	opts = opts or {}
	local core = {}
	local env = { core = core, chat = {}, formspecs = {}, inventory_formspecs = {}, log = {}, after_queue = {},
		time = 0, nodes = {}, metas = {}, players = {}, privs = {}, settings = opts.settings or {} }
	core.registered_items, core.registered_nodes, core.registered_aliases = {}, {}, {}
	core.registered_chatcommands, core.registered_privileges = {}, {}
	core.registered_on_placenodes, core.registered_on_dignodes = {}, {}
	local cb = { craft = {}, eat = {}, join = {}, leave = {}, newplayer = {}, shutdown = {}, mods_loaded = {},
		fields = {}, globalstep = {}, dieplayer = {} }
	env.cb = cb

	-- ItemStack -------------------------------------------------------------
	local ItemStack = {}
	ItemStack.__index = ItemStack
	local function new_stack(v)
		local self = setmetatable({ name = "", count = 0, wear = 0 }, ItemStack)
		if type(v) == "table" and getmetatable(v) == ItemStack then
			self.name, self.count, self.wear = v.name, v.count, v.wear
		elseif type(v) == "string" and v ~= "" then
			local name, count = v:match("^(%S+)%s*(%d*)")
			self.name = name or ""
			self.count = tonumber(count) or 1
		end
		if self.name == "" then self.count = 0 end
		return self
	end
	function ItemStack:get_name() return self.name end
	function ItemStack:set_name(n) self.name = n return true end
	function ItemStack:get_count() return self.count end
	function ItemStack:set_count(c)
		self.count = c
		if c <= 0 then self.name, self.count = "", 0 end
		return true
	end
	function ItemStack:is_empty() return self.name == "" or self.count <= 0 end
	function ItemStack:get_wear() return self.wear end
	function ItemStack:set_wear(w) self.wear = w end
	function ItemStack:get_definition() return core.registered_items[self.name] or {} end
	function ItemStack:is_known() return core.registered_items[self.name] ~= nil end
	function ItemStack:get_stack_max()
		local d = core.registered_items[self.name]
		return d and d.stack_max or 99
	end
	function ItemStack:get_free_space() return self:get_stack_max() - self.count end
	function ItemStack:to_string()
		if self:is_empty() then return "" end
		return self.count > 1 and (self.name .. " " .. self.count) or self.name
	end
	function ItemStack:take_item(n)
		n = math.min(n or 1, self.count)
		local taken = new_stack(self.name .. " " .. n)
		self:set_count(self.count - n)
		return taken
	end
	function ItemStack:add_item(item)
		item = new_stack(item)
		if item:is_empty() then return new_stack("") end
		if self:is_empty() then
			local put = math.min(item:get_stack_max(), item.count)
			self.name, self.count = item.name, put
			item:set_count(item.count - put)
			return item
		end
		if self.name ~= item.name then return item end
		local put = math.min(self:get_free_space(), item.count)
		self.count = self.count + put
		item:set_count(item.count - put)
		return item
	end
	function ItemStack:item_fits(item)
		return new_stack(self):add_item(item):is_empty()
	end
	env.ItemStack = new_stack

	-- Inventaires et joueurs ----------------------------------------------
	local function new_inv(size)
		local inv = { lists = { main = {} } }
		for i = 1, size or 32 do inv.lists.main[i] = new_stack("") end
		function inv:get_list(l)
			if not self.lists[l] then return nil end
			local out = {}
			for i, st in ipairs(self.lists[l]) do out[i] = new_stack(st) end
			return out
		end
		function inv:get_stack(l, i) return new_stack(self.lists[l][i]) end
		function inv:set_stack(l, i, st) self.lists[l][i] = new_stack(st) end
		function inv:add_item(l, st)
			local left = new_stack(st)
			for _, slot in ipairs(self.lists[l]) do
				if left:is_empty() then break end
				if slot.name == left.name then left = slot:add_item(left) end
			end
			for _, slot in ipairs(self.lists[l]) do
				if left:is_empty() then break end
				if slot:is_empty() then left = slot:add_item(left) end
			end
			return left
		end
		function inv:room_for_item(l, st)
			local left = new_stack(st)
			for _, slot in ipairs(self.lists[l]) do
				if left:is_empty() then break end
				left = new_stack(slot):add_item(left)
			end
			return left:is_empty()
		end
		function inv:count(name)
			local total = 0
			for _, s in ipairs(self.lists.main) do if s.name == name then total = total + s.count end end
			return total
		end
		return inv
	end

	local function new_player(name, fake)
		local p = { name = name, inv = new_inv(32), huds = {}, hud_next = 1, control = {}, pos = { x = 0, y = 0, z = 0 } }
		if fake then p.is_fake_player = true end
		function p:is_player() return true end
		function p:get_player_name() return self.name end
		function p:get_inventory() return self.inv end
		function p:get_player_control() return self.control end
		function p:get_pos() return self.pos end
		function p:hud_add(def) local id = self.hud_next self.hud_next = id + 1 self.huds[id] = def return id end
		function p:hud_remove(id) self.huds[id] = nil end
		function p:hud_change(id, k, v) if self.huds[id] then self.huds[id][k] = v end end
		function p:set_inventory_formspec(fs) env.inventory_formspecs[self.name] = fs end
		return p
	end
	env.new_player = new_player

	-- core ----------------------------------------------------------------
	local mods = {}
	for _, m in ipairs(opts.mods or {}) do mods[m] = true end
	env.mods = mods
	core.get_current_modname = function() return "minerland_quests" end
	core.get_modpath = function(m)
		if m == "minerland_quests" then return opts.modpath end
		if opts.all_mods or mods[m] then return "/mock/" .. m end
		return nil
	end
	core.get_translator = function() return function(s) return s end end
	core.log = function(level, msg) env.log[#env.log + 1] = { level = level, msg = msg } end
	core.settings = {
		get = function(_, k) local v = env.settings[k] return v ~= nil and tostring(v) or nil end,
		get_bool = function(_, k)
			local v = env.settings[k]
			if v == nil then return nil end
			return v == true or v == "true"
		end,
	}
	core.formspec_escape = function(s)
		return (tostring(s):gsub("\\", "\\\\"):gsub("%[", "\\["):gsub("%]", "\\]"):gsub(";", "\\;"):gsub(",", "\\,"))
	end
	core.colorize = function(color, text) return "\27(c@" .. color .. ")" .. text .. "\27(c@#ffffff)" end
	core.strip_colors = function(s) return (s:gsub("\27%(c@[^)]*%)", "")) end
	core.write_json = M.write_json
	core.parse_json = M.parse_json
	core.get_dir_list = function(path)
		local out = {}
		local p = io.popen('ls -1 "' .. path .. '" 2>/dev/null')
		if p then
			for line in p:lines() do out[#out + 1] = line end
			p:close()
		end
		return out
	end
	core.after = function(t, f, ...)
		env.after_queue[#env.after_queue + 1] = { at = env.time + t, f = f, args = { ... } }
	end
	core.sound_play = function() return 1 end
	core.chat_send_player = function(name, msg) env.chat[#env.chat + 1] = { to = name, msg = msg } end
	core.show_formspec = function(name, formname, fs) env.formspecs[name] = { formname = formname, fs = fs } end
	core.close_formspec = function(name) env.formspecs[name] = nil end
	core.explode_scrollbar_event = function(s)
		local typ, v = tostring(s):match("^(%u+):(%-?%d+)")
		return { type = typ or "INV", value = tonumber(v) or 0 }
	end
	core.get_player_by_name = function(name) return env.players[name] end
	core.get_connected_players = function()
		local out = {}
		for _, p in pairs(env.players) do out[#out + 1] = p end
		return out
	end
	core.player_exists = function(name) return env.players[name] ~= nil end
	core.get_player_privs = function(name) return env.privs[name] or {} end
	core.check_player_privs = function(name, req)
		local have = env.privs[name] or {}
		for k in pairs(req) do if not have[k] then return false end end
		return true
	end
	core.get_item_group = function(name, g)
		local d = core.registered_items[name]
		return d and d.groups and d.groups[g] or 0
	end
	core.get_node = function(pos)
		return env.nodes[M.key(pos)] or { name = "air", param2 = 0 }
	end
	core.set_node = function(pos, node) env.nodes[M.key(pos)] = { name = node.name, param2 = node.param2 or 0 } end
	core.get_meta = function(pos)
		local k = M.key(pos)
		local m = env.metas[k]
		if not m then
			m = { data = {} }
			function m:set_string(a, b) self.data[a] = b end
			function m:get_string(a) return self.data[a] or "" end
			env.metas[k] = m
		end
		return m
	end

	local function reg(kind, name, def)
		name = name:gsub("^:", "")
		def = def or {}
		def.name, def.type = name, kind
		def.groups = def.groups or {}
		def.description = def.description or name
		core.registered_items[name] = def
		if kind == "node" then core.registered_nodes[name] = def end
		return def
	end
	core.register_node = function(n, d) return reg("node", n, d) end
	core.register_craftitem = function(n, d) return reg("craft", n, d) end
	core.register_tool = function(n, d) return reg("tool", n, d) end
	core.register_alias = function(a, b) core.registered_aliases[a] = b end
	core.override_item = function(name, fields)
		local d = core.registered_items[name]
		assert(d, "override_item : objet inconnu " .. name)
		for k, v in pairs(fields) do d[k] = v end
	end
	core.register_craft = function() end
	core.register_privilege = function(n, d) core.registered_privileges[n] = d end
	core.register_chatcommand = function(n, d) core.registered_chatcommands[n] = d end
	core.register_on_placenode = function(f) table.insert(core.registered_on_placenodes, f) end
	core.register_on_dignode = function(f) table.insert(core.registered_on_dignodes, f) end
	core.register_on_craft = function(f) table.insert(cb.craft, f) end
	core.register_on_item_eat = function(f) table.insert(cb.eat, f) end
	core.register_on_joinplayer = function(f) table.insert(cb.join, f) end
	core.register_on_leaveplayer = function(f) table.insert(cb.leave, f) end
	core.register_on_newplayer = function(f) table.insert(cb.newplayer, f) end
	core.register_on_dieplayer = function(f) table.insert(cb.dieplayer, f) end
	core.register_on_shutdown = function(f) table.insert(cb.shutdown, f) end
	core.register_on_mods_loaded = function(f) table.insert(cb.mods_loaded, f) end
	core.register_on_player_receive_fields = function(f) table.insert(cb.fields, f) end
	core.register_globalstep = function(f) table.insert(cb.globalstep, f) end

	-- Mod storage en mémoire, partageable entre « redémarrages » simulés
	local data = opts.storage_data or {}
	env.storage_data = data
	core.get_mod_storage = function()
		return {
			get_string = function(_, k) return data[k] or "" end,
			set_string = function(_, k, v) if v == "" then data[k] = nil else data[k] = v end end,
			get_keys = function()
				local out = {}
				for k in pairs(data) do out[#out + 1] = k end
				table.sort(out)
				return out
			end,
		}
	end
	return env
end

return M
