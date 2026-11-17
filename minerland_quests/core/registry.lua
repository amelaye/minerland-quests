-- Registre des parties, chapitres et quêtes.
-- Les définitions sont validées à l'enregistrement (erreur de développeur => erreur claire au chargement).
-- Les références à des objets d'autres mods sont vérifiées plus tard (core/compat.lua, à on_mods_loaded).
local Q = minerland_quests
local U = Q.util

Q.parts, Q.part_list = {}, {}
Q.chapters, Q.chapter_list = {}, {}
Q.quests, Q.quest_list = {}, {}
Q.registered_on_complete = {}

local TRIGGER_TYPES = { dig = true, place = true, craft = true, eat = true, custom = true }
Q.TRIGGER_TYPES = TRIGGER_TYPES

local function fail(what, id, msg)
	error(("[minerland_quests] %s « %s » : %s"):format(what, tostring(id), msg), 3)
end

local function check_id(what, id, pattern)
	if type(id) ~= "string" or not id:match(pattern) then
		fail(what, id, "identifiant invalide (attendu : " .. pattern .. ")")
	end
end

function Q.register_part(def)
	check_id("partie", def.id, "^[a-z_]+$")
	if Q.parts[def.id] then fail("partie", def.id, "déjà enregistrée") end
	local p = {
		id = def.id,
		order = tonumber(def.order) or (#Q.part_list + 1),
		numeral = def.numeral or tostring(#Q.part_list + 1),
		title = assert(def.title, "title requis"),
		subtitle = def.subtitle or "",
		illustration = def.illustration or "mlq_part_default.png",
		color = def.color or "#8a5a2b",
		chapters = {},
	}
	Q.parts[p.id] = p
	Q.part_list[#Q.part_list + 1] = p
	table.sort(Q.part_list, function(a, b) return a.order < b.order end)
	return p
end

function Q.register_chapter(def)
	check_id("chapitre", def.id, "^ch%d%d$")
	if Q.chapters[def.id] then fail("chapitre", def.id, "déjà enregistré") end
	local part = Q.parts[def.part]
	if not part then fail("chapitre", def.id, "partie inconnue : " .. tostring(def.part)) end
	local c = {
		id = def.id,
		part = def.part,
		number = tonumber(def.id:sub(3)),
		title = assert(def.title, "title requis"),
		intro = def.intro or "",
		icon = def.icon,                 -- objet (item_image) ; repli : emblem
		emblem = def.emblem or "mlq_emblem_" .. def.part .. ".png",
		mods = U.string_list(def.mods),  -- mods principaux (affichage, diagnostic)
		quests = {},
	}
	Q.chapters[c.id] = c
	Q.chapter_list[#Q.chapter_list + 1] = c
	table.sort(Q.chapter_list, function(a, b) return a.number < b.number end)
	part.chapters[#part.chapters + 1] = c
	table.sort(part.chapters, function(a, b) return a.number < b.number end)
	return c
end

local function normalize_trigger(id, t)
	if type(t) ~= "table" then fail("quête", id, "trigger manquant") end
	if not TRIGGER_TYPES[t.type] then fail("quête", id, "type de trigger inconnu : " .. tostring(t.type)) end
	local n = {
		type = t.type,
		items = U.string_list(t.items or t.item),
		groups = U.string_list(t.groups or t.group),
		key = t.key,
		count = math.max(1, math.floor(tonumber(t.count) or 1)),
	}
	if n.type == "custom" then
		if type(n.key) ~= "string" or n.key == "" then fail("quête", id, "trigger custom sans key") end
	elseif #n.items == 0 and #n.groups == 0 then
		fail("quête", id, "trigger sans items ni groups")
	end
	-- Pose : par défaut, des positions distinctes sont exigées dès que count > 1 (anti pose/reprise).
	if n.type == "place" then
		if t.distinct == nil then n.distinct = n.count > 1 else n.distinct = t.distinct and true or false end
	end
	return n
end

local function normalize_reward(id, r)
	r = r or {}
	local items = {}
	for _, s in ipairs(U.string_list(r.items)) do
		local stack = ItemStack(s)
		if stack:get_count() < 1 or stack:get_count() > 999 then
			fail("quête", id, "quantité de récompense invalide : " .. s)
		end
		items[#items + 1] = s
	end
	if r.title ~= nil and type(r.title) ~= "string" then fail("quête", id, "reward.title doit être une chaîne") end
	return { items = items, title = r.title }
end

function Q.register_quest(def)
	check_id("quête", def.id, "^ch%d%d%.[a-z0-9_]+$")
	if Q.quests[def.id] then fail("quête", def.id, "déjà enregistrée") end
	local chapter = Q.chapters[def.chapter or def.id:sub(1, 4)]
	if not chapter then fail("quête", def.id, "chapitre inconnu : " .. tostring(def.chapter)) end
	if def.id:sub(1, 4) ~= chapter.id then fail("quête", def.id, "le préfixe doit être celui du chapitre") end
	if type(def.title) ~= "string" or def.title == "" then fail("quête", def.id, "title requis") end
	local difficulty = math.floor(tonumber(def.difficulty) or 1)
	if difficulty < 1 or difficulty > 5 then fail("quête", def.id, "difficulty doit être entre 1 et 5") end
	if def.pos ~= nil and (type(def.pos) ~= "table" or not tonumber(def.pos[1]) or not tonumber(def.pos[2])) then
		fail("quête", def.id, "pos doit être {col, ligne}")
	end

	local q = {
		id = def.id,
		index = #Q.quest_list + 1,           -- identifiant court pour les champs formspec (non persistant)
		chapter = chapter.id,
		title = def.title,
		description = def.description or "",
		objective = def.objective,           -- texte d'objectif facultatif (sinon généré)
		hint = def.hint,
		icon = def.icon,
		difficulty = difficulty,
		trigger = normalize_trigger(def.id, def.trigger),
		requires = U.string_list(def.requires),
		mods = U.string_list(def.mods),
		reward = normalize_reward(def.id, def.reward),
		final = def.final and true or false,
		pos = def.pos,
		-- remplis par compat.finalize :
		unavailable = nil,                   -- raison (chaîne) si la quête ne peut pas être jouée
		targets = nil,                       -- ensemble des objets cibles résolus
		reward_items = nil,                  -- récompenses existantes
		reward_missing = nil,                -- récompenses introuvables
	}
	Q.quests[q.id] = q
	Q.quest_list[#Q.quest_list + 1] = q
	chapter.quests[#chapter.quests + 1] = q
	return q
end

function Q.get_quest(id)
	if type(id) ~= "string" then return nil end
	return Q.quests[id]
end

function Q.get_quest_by_index(i)
	return Q.quest_list[tonumber(i) or -1]
end

function Q.get_chapter_quests(chapter_id)
	local c = Q.chapters[chapter_id]
	return c and c.quests or {}
end

-- Rappel appelé à chaque complétion : f(player_name, quest)
function Q.register_on_complete(f)
	assert(type(f) == "function")
	Q.registered_on_complete[#Q.registered_on_complete + 1] = f
end

-- Finalisation : appelée une fois tous les mods chargés.
function Q.finalize()
	Q.graph.check_all()
	Q.compat.finalize()
	Q.events.build_index()
	Q.finalized = true
	local n, unavailable = #Q.quest_list, 0
	for _, q in ipairs(Q.quest_list) do
		if q.unavailable then unavailable = unavailable + 1 end
	end
	U.log("action", ("chargé : %d quêtes dans %d chapitres (%d indisponibles sur ce serveur)")
		:format(n, #Q.chapter_list, unavailable))
end
