-- Progression : états des quêtes, compteurs et complétion.
-- Toute réussite passe par P.handle_event (événement serveur) ; aucune entrée client n'y mène.
local Q = minerland_quests
local U = Q.util
local P = {}
Q.progress = P

P.STATES = { "locked", "available", "done", "unavailable" }

function P.is_done(name, qid)
	return Q.storage.get(name).done[qid] ~= nil
end

-- Prérequis manquants (en ignorant les prérequis indisponibles sur ce serveur).
function P.missing_requirements(name, q)
	local rec = Q.storage.get(name)
	local out = {}
	for _, r in ipairs(q.requires) do
		local p = Q.quests[r]
		if p and not p.unavailable and not rec.done[r] then
			out[#out + 1] = p
		end
	end
	return out
end

function P.state(name, q)
	if type(q) == "string" then q = Q.quests[q] end
	if not q then return "unavailable" end
	local rec = Q.storage.get(name)
	if rec.done[q.id] then return "done" end
	if q.unavailable then return "unavailable" end
	if #P.missing_requirements(name, q) > 0 then return "locked" end
	return "available"
end

function P.count(name, q)
	local rec = Q.storage.get(name)
	if rec.done[q.id] then return q.trigger.count end
	return math.min(rec.prog[q.id] or 0, q.trigger.count)
end

-- Statistiques d'un chapitre (les quêtes indisponibles ne comptent pas dans le total).
function P.chapter_stats(name, chapter_id)
	local done, total = 0, 0
	for _, q in ipairs(Q.get_chapter_quests(chapter_id)) do
		local st = P.state(name, q)
		if st ~= "unavailable" then
			total = total + 1
			if st == "done" then done = done + 1 end
		end
	end
	return done, total
end

function P.part_stats(name, part_id)
	local done, total = 0, 0
	for _, c in ipairs(Q.parts[part_id].chapters) do
		local d, t = P.chapter_stats(name, c.id)
		done, total = done + d, total + t
	end
	return done, total
end

function P.global_stats(name)
	local done, total = 0, 0
	for _, p in ipairs(Q.part_list) do
		local d, t = P.part_stats(name, p.id)
		done, total = done + d, total + t
	end
	return done, total
end

local function chapter_completed(name, chapter_id)
	local d, t = P.chapter_stats(name, chapter_id)
	return t > 0 and d == t
end

-- Marque la quête terminée, enregistre immédiatement, puis récompense et notifie.
function P.complete(name, q, source)
	local rec = Q.storage.get(name)
	if rec.done[q.id] then return false end
	if Q.storage.is_readonly(name) then return false end
	local was_available = {}
	for _, child in ipairs(Q.graph.children(q.id)) do
		was_available[child.id] = P.state(name, child) == "available"
	end
	rec.done[q.id] = os.time()
	rec.prog[q.id] = nil
	rec.spots[q.id] = nil
	Q.storage.mark_dirty(name)
	Q.storage.flush(name)
	U.log("action", ("%s a terminé la quête %s (%s)"):format(name, q.id, source or "événement"))

	Q.rewards.grant(name, q)

	local unlocked = {}
	for _, child in ipairs(Q.graph.children(q.id)) do
		if not was_available[child.id] and P.state(name, child) == "available" then
			unlocked[#unlocked + 1] = child
		end
	end
	local chapter_done = chapter_completed(name, q.chapter)
	if Q.notify then Q.notify.quest_completed(name, q, unlocked, chapter_done) end
	for _, f in ipairs(Q.registered_on_complete) do
		local ok, err = pcall(f, name, q, chapter_done)
		if not ok then U.log("error", "rappel on_complete : " .. tostring(err)) end
	end
	if Q.ui and Q.ui.refresh then Q.ui.refresh(name) end
	return true
end

-- Point d'entrée unique des événements normalisés.
--   name : joueur réel (déjà vérifié par core/events.lua)
--   etype : dig | place | craft | eat | custom
--   key   : nom d'objet résolu, ou clé custom
--   count : quantité (>= 1)
--   ctx   : { pos = {x,y,z} } facultatif
-- Retourne le nombre de quêtes dont l'avancement a changé.
function P.handle_event(name, etype, key, count, ctx)
	if not Q.finalized then return 0 end
	local candidates = Q.events.candidates(etype, key)
	if not candidates then return 0 end
	count = math.max(1, math.floor(tonumber(count) or 1))
	local rec = Q.storage.get(name)
	local changed = 0
	-- États figés AVANT l'événement : une action ne compte pas pour une quête qu'elle vient de débloquer
	-- (ex. creuser un tronc termine « premier tronc » sans avancer aussitôt la quête suivante du même type).
	local eligible = {}
	for _, q in ipairs(candidates) do
		eligible[q] = P.state(name, q) == "available"
	end
	for _, q in ipairs(candidates) do
		if eligible[q] and not rec.done[q.id] then
			local t = q.trigger
			local inc = count
			if t.type == "place" and t.distinct then
				local pk = ctx and ctx.pos and U.pos_key(ctx.pos)
				local spots = rec.spots[q.id] or {}
				if not pk or spots[pk] then
					inc = 0
				else
					spots[pk] = true
					rec.spots[q.id] = spots
					inc = 1
				end
			end
			if inc > 0 then
				local n = (rec.prog[q.id] or 0) + inc
				changed = changed + 1
				if n >= t.count then
					P.complete(name, q)
				else
					rec.prog[q.id] = n
					Q.storage.mark_dirty(name)
					if Q.ui and Q.ui.refresh then Q.ui.refresh(name) end
				end
			end
		end
	end
	return changed
end
