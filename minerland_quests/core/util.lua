-- Petites fonctions utilitaires partagées (sans état).
local Q = minerland_quests
local U = {}
Q.util = U

function U.log(level, msg)
	core.log(level, "[minerland_quests] " .. msg)
end

function U.setting_bool(key, default)
	local v = core.settings:get_bool("minerland_quests." .. key)
	if v == nil then return default end
	return v
end

function U.setting_int(key, default)
	local v = tonumber(core.settings:get("minerland_quests." .. key))
	return v and math.floor(v) or default
end

-- Copie un tableau-liste en ne gardant que les chaînes non vides.
function U.string_list(v)
	local out = {}
	if type(v) == "string" then v = {v} end
	if type(v) ~= "table" then return out end
	for _, s in ipairs(v) do
		if type(s) == "string" and s ~= "" then
			out[#out + 1] = s
		end
	end
	return out
end

function U.set_of(list)
	local s = {}
	for _, v in ipairs(list) do s[v] = true end
	return s
end

-- Résout un alias d'objet (une seule fois, comme le moteur).
function U.resolve_item(name)
	if core.registered_items[name] then return name end
	local alias = core.registered_aliases and core.registered_aliases[name]
	if alias and core.registered_items[alias] then return alias end
	return nil
end

function U.item_description(name)
	local def = core.registered_items[name]
	if not def then return name end
	local d = def.short_description or def.description or name
	if d == "" then d = name end
	d = d:match("^[^\n]*") or d
	-- retire les séquences d'échappement de couleur/traduction pour l'affichage brut
	return core.strip_colors and core.strip_colors(d) or d
end

-- Hash compact d'une position (entiers bornés à ±32768).
function U.pos_key(pos)
	return string.format("%d,%d,%d", math.floor(pos.x + 0.5), math.floor(pos.y + 0.5), math.floor(pos.z + 0.5))
end

function U.format_date(t)
	if not t or t == 0 then return "" end
	return os.date("%d/%m/%Y", t)
end
