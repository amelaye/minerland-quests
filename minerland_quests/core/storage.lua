-- Persistance de la progression (mod storage Luanti, JSON compact, une clé par joueur).
--
-- Format (version 1) :
--   p:<joueur> = {
--     v = 1,
--     done     = { [qid] = horodatage },          -- quêtes terminées
--     prog     = { [qid] = compteur },            -- avancement des quêtes en cours
--     spots    = { [qid] = { [pos] = true } },     -- positions déjà comptées (pose distincte)
--     rewarded = { [qid] = horodatage },          -- JOURNAL : récompense attribuée (jamais effacé en prod)
--     delivered= { [qid] = horodatage },          -- récompense effectivement livrée dans l'inventaire
--     pending  = { { q = qid, items = {...}, t = horodatage }, ... }  -- file de livraison
--     titles   = { [qid] = "titre" },             -- titres honorifiques obtenus
--   }
--   placed = liste FIFO de positions de nœuds-cibles posés par des joueurs (anti-triche « dig »)
local Q = minerland_quests
local U = Q.util
local S = {}
Q.storage = S

S.VERSION = 1
S.backend = nil          -- StorageRef (injecté ; voir S.init)
local cache = {}         -- [nom] = enregistrement
local dirty = {}         -- [nom] = true
local readonly = {}      -- [nom] = true si format plus récent que le mod (jamais écrasé)

-- Alias d'identifiants de quêtes renommées : ancien -> nouveau. Ne jamais retirer une entrée.
S.quest_aliases = {}

function S.init(backend)
	S.backend = backend or core.get_mod_storage()
	cache, dirty, readonly = {}, {}, {}
	S.placed_load()
end

local function empty_record()
	return { v = S.VERSION, done = {}, prog = {}, spots = {}, rewarded = {}, delivered = {}, pending = {}, titles = {} }
end

-- Migrations successives : migrations[n] transforme un enregistrement v=n en v=n+1.
S.migrations = {
	-- [0] : enregistrement sans champ v (préversion) -> v1
	[0] = function(rec)
		rec.done = rec.done or rec.completed or {}
		rec.completed = nil
		return rec
	end,
}

local function apply_aliases(rec)
	for old, new in pairs(S.quest_aliases) do
		for _, field in ipairs({"done", "prog", "spots", "rewarded", "delivered", "titles"}) do
			local t = rec[field]
			if t and t[old] ~= nil and t[new] == nil then
				t[new], t[old] = t[old], nil
			end
		end
		for _, p in ipairs(rec.pending or {}) do
			if p.q == old then p.q = new end
		end
	end
end

function S.migrate(rec, name)
	if type(rec) ~= "table" then return empty_record() end
	local v = tonumber(rec.v) or 0
	if v > S.VERSION then
		readonly[name] = true
		U.log("error", ("données de %s au format v%d plus récent que ce mod (v%d) : lecture seule, rien ne sera écrasé")
			:format(name, v, S.VERSION))
		-- champs manquants complétés EN MÉMOIRE seulement (un enregistrement en lecture seule n'est jamais réécrit)
		for k, def in pairs(empty_record()) do
			if type(rec[k]) ~= type(def) then rec[k] = def end
		end
		return rec
	end
	while v < S.VERSION do
		local m = S.migrations[v]
		if m then rec = m(rec) end
		v = v + 1
	end
	rec.v = S.VERSION
	local base = empty_record()
	for k, def in pairs(base) do
		if type(rec[k]) ~= type(def) then rec[k] = def end
	end
	apply_aliases(rec)
	return rec
end

function S.get(name)
	local rec = cache[name]
	if rec then return rec end
	local raw = S.backend:get_string("p:" .. name)
	if raw ~= "" then
		local parsed = core.parse_json(raw)
		if parsed == nil then
			U.log("error", "données illisibles pour " .. name .. " : sauvegardées sous p_corrupt:" .. name)
			S.backend:set_string("p_corrupt:" .. name, raw)
		end
		rec = S.migrate(parsed, name)
	else
		rec = empty_record()
	end
	cache[name] = rec
	return rec
end

function S.is_readonly(name)
	return readonly[name] == true
end

function S.mark_dirty(name)
	dirty[name] = true
end

-- Les tables vides sont sérialisées en objets JSON (write_json produirait [] ou null sinon).
local function prepare(rec)
	local out = {}
	for k, v in pairs(rec) do
		if k ~= "pending" and type(v) == "table" and next(v) == nil then
			out[k] = nil -- reconstruit à la lecture par migrate()
		else
			out[k] = v
		end
	end
	return out
end

function S.flush(name)
	local rec = cache[name]
	if not rec or readonly[name] then
		dirty[name] = nil
		return false
	end
	local json, err = core.write_json(prepare(rec))
	if not json then
		U.log("error", "échec de sérialisation pour " .. name .. " : " .. tostring(err))
		return false
	end
	S.backend:set_string("p:" .. name, json)
	dirty[name] = nil
	return true
end

function S.flush_all()
	for name in pairs(dirty) do S.flush(name) end
	S.placed_flush()
end

function S.unload(name)
	S.flush(name)
	cache[name] = nil
end

-- Pour les tests : oublie le cache (simule un redémarrage, les données restent dans le backend).
function S.drop_cache()
	cache, dirty, readonly = {}, {}, {}
end

function S.known_players()
	local out = {}
	for _, key in ipairs(S.backend:get_keys()) do
		local n = key:match("^p:(.+)$")
		if n then out[#out + 1] = n end
	end
	table.sort(out)
	return out
end

---------------------------------------------------------------------------
-- Mémoire des nœuds-cibles posés par des joueurs (FIFO bornée).
-- Sert à ignorer, pour les quêtes « dig », un bloc qu'un joueur a lui-même posé (ou reçu puis posé).
---------------------------------------------------------------------------
local placed_set, placed_fifo, placed_head, placed_dirty = {}, {}, 1, false

function S.placed_load()
	placed_set, placed_fifo, placed_head, placed_dirty = {}, {}, 1, false
	local raw = S.backend:get_string("placed")
	local list = raw ~= "" and core.parse_json(raw) or nil
	if type(list) == "table" then
		for _, k in ipairs(list) do
			if type(k) == "string" and not placed_set[k] then
				placed_set[k] = true
				placed_fifo[#placed_fifo + 1] = k
			end
		end
	end
end

function S.placed_add(key)
	if placed_set[key] then return end
	placed_set[key] = true
	placed_fifo[#placed_fifo + 1] = key
	local cap = U.setting_int("placed_cap", 20000)
	while (#placed_fifo - placed_head + 1) > cap do
		placed_set[placed_fifo[placed_head]] = nil
		placed_fifo[placed_head] = false
		placed_head = placed_head + 1
	end
	placed_dirty = true
end

-- Retourne true si la position était marquée (et l'oublie : le bloc vient d'être creusé).
function S.placed_take(key)
	if not placed_set[key] then return false end
	placed_set[key] = nil
	placed_dirty = true
	return true
end

function S.placed_flush()
	if not placed_dirty then return end
	local list = {}
	for i = placed_head, #placed_fifo do
		local k = placed_fifo[i]
		if k and placed_set[k] then list[#list + 1] = k end
	end
	-- compactage
	placed_fifo, placed_head = list, 1
	S.backend:set_string("placed", core.write_json(list) or "[]")
	placed_dirty = false
end

---------------------------------------------------------------------------
-- Cycle de vie
---------------------------------------------------------------------------
local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 10 then return end
	timer = 0
	S.flush_all()
end)

core.register_on_leaveplayer(function(player)
	S.unload(player:get_player_name())
end)

core.register_on_shutdown(function()
	S.flush_all()
end)

-- get_mod_storage() n'est autorisé qu'au chargement du mod.
S.init()
