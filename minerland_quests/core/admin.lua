-- Commandes de chat : ouverture du livre (tous) et outils d'administration (privilège dédié).
local Q = minerland_quests
local U = Q.util
local A = {}
Q.admin = A

core.register_privilege("minerland_quests_admin", {
	description = "Consulter et diagnostiquer la progression des quêtes de Minerland",
	give_to_singleplayer = false,
	give_to_admin = true,
})

local ADMIN = { minerland_quests_admin = true }

local function quest_line(name, q)
	local st = Q.progress.state(name, q)
	return ("%s [%s] %d/%d — %s"):format(q.id, st, Q.progress.count(name, q), q.trigger.count, q.title)
end

local function known_player(name)
	if core.get_player_by_name(name) then return true end
	if core.player_exists and core.player_exists(name) then return true end
	for _, n in ipairs(Q.storage.known_players()) do
		if n == name then return true end
	end
	return false
end

function A.audit(actor, msg)
	U.log("action", ("[admin] %s : %s"):format(actor, msg))
end

local function open_book(name)
	if Q.book then Q.book.show(name) end
	return true
end

core.register_chatcommand("quetes", {
	description = "Ouvrir le Grand Livre des Quêtes",
	func = function(name) return open_book(name) end,
})
core.register_chatcommand("livre", {
	description = "Ouvrir le Grand Livre des Quêtes",
	func = function(name) return open_book(name) end,
})

core.register_chatcommand("mlq_progress", {
	params = "<joueur>",
	description = "Progression d'un joueur par chapitre",
	privs = ADMIN,
	func = function(name, param)
		local target = param:match("^%s*(%S+)%s*$")
		if not target or not known_player(target) then return false, "Joueur inconnu." end
		local lines = {}
		local d, t = Q.progress.global_stats(target)
		lines[#lines + 1] = ("%s : %d/%d quêtes, %d récompense(s) en attente"):format(
			target, d, t, Q.rewards.pending_count(target))
		for _, c in ipairs(Q.chapter_list) do
			local cd, ct = Q.progress.chapter_stats(target, c.id)
			lines[#lines + 1] = ("  %s %-34s %d/%d"):format(c.id, c.title, cd, ct)
		end
		return true, table.concat(lines, "\n")
	end,
})

core.register_chatcommand("mlq_quest", {
	params = "<joueur> <id_quête>",
	description = "État détaillé d'une quête pour un joueur",
	privs = ADMIN,
	func = function(name, param)
		local target, qid = param:match("^%s*(%S+)%s+(%S+)%s*$")
		local q = Q.get_quest(qid)
		if not target or not q then return false, "Usage : /mlq_quest <joueur> <id_quête>" end
		if not known_player(target) then return false, "Joueur inconnu." end
		local rec = Q.storage.get(target)
		local miss = {}
		for _, p in ipairs(Q.progress.missing_requirements(target, q)) do miss[#miss + 1] = p.id end
		return true, table.concat({
			quest_line(target, q),
			"  déclencheur : " .. q.trigger.type .. " " .. (q.trigger.key or table.concat(q.trigger.items, ",")),
			"  indisponible : " .. tostring(q.unavailable or "non"),
			"  prérequis manquants : " .. (#miss > 0 and table.concat(miss, ", ") or "aucun"),
			"  terminée le : " .. (rec.done[q.id] and U.format_date(rec.done[q.id]) or "-"),
			"  récompense : " .. Q.rewards.status(target, q),
		}, "\n")
	end,
})

core.register_chatcommand("mlq_reward", {
	params = "<joueur>",
	description = "Diagnostic des récompenses d'un joueur (journal et file d'attente) ; relance la livraison",
	privs = ADMIN,
	func = function(name, param)
		local target = param:match("^%s*(%S+)%s*$")
		if not target or not known_player(target) then return false, "Joueur inconnu." end
		local rec = Q.storage.get(target)
		local lines, n = {}, 0
		for _ in pairs(rec.rewarded) do n = n + 1 end
		lines[#lines + 1] = ("%s : %d récompense(s) attribuée(s), %d en attente"):format(target, n, #rec.pending)
		for i, p in ipairs(rec.pending) do
			lines[#lines + 1] = ("  #%d %s : %s (depuis %s)"):format(i, p.q, table.concat(p.items or {}, ", "),
				U.format_date(p.t))
		end
		local delivered = Q.rewards.deliver(target)
		if delivered > 0 then lines[#lines + 1] = ("  -> %d livraison(s) effectuée(s) maintenant"):format(delivered) end
		A.audit(name, "diagnostic récompenses de " .. target)
		return true, table.concat(lines, "\n")
	end,
})

core.register_chatcommand("mlq_diag", {
	description = "Diagnostic du livre de quêtes (intégrations, quêtes indisponibles, problèmes de données)",
	privs = ADMIN,
	func = function()
		local lines = { ("Grand Livre v%s : %d quêtes, %d chapitres"):format(Q.version, #Q.quest_list, #Q.chapter_list) }
		local integ = {}
		for k in pairs(Q.compat.integrations) do integ[#integ + 1] = k end
		table.sort(integ)
		lines[#lines + 1] = "Intégrations actives : " .. (#integ > 0 and table.concat(integ, ", ") or "aucune")
		local unav = 0
		for _, q in ipairs(Q.quest_list) do
			if q.unavailable then
				unav = unav + 1
				if unav <= 25 then lines[#lines + 1] = "  indisponible " .. q.id .. " : " .. q.unavailable end
			end
		end
		lines[#lines + 1] = ("%d quête(s) indisponible(s)"):format(unav)
		for _, m in ipairs(Q.compat.reward_problems) do lines[#lines + 1] = "  " .. m end
		for _, m in ipairs(Q.graph.problems) do lines[#lines + 1] = "  " .. m end
		return true, table.concat(lines, "\n")
	end,
})

-- Commandes de TEST : refusées si minerland_quests.allow_reset n'est pas activé (production).
local function test_only()
	if not U.setting_bool("allow_reset", false) then
		return false, "Commande désactivée : réservée aux instances de test (minerland_quests.allow_reset = true)."
	end
	return true
end

core.register_chatcommand("mlq_reset", {
	params = "<joueur> <id_quête>",
	description = "[TEST] Réinitialise une quête (la récompense reste journalisée : pas de seconde récompense)",
	privs = ADMIN,
	func = function(name, param)
		local ok, err = test_only()
		if not ok then return false, err end
		local target, qid = param:match("^%s*(%S+)%s+(%S+)%s*$")
		local q = Q.get_quest(qid)
		if not target or not q then return false, "Usage : /mlq_reset <joueur> <id_quête>" end
		if not known_player(target) then return false, "Joueur inconnu." end
		local rec = Q.storage.get(target)
		rec.done[q.id], rec.prog[q.id], rec.spots[q.id] = nil, nil, nil
		Q.storage.mark_dirty(target)
		Q.storage.flush(target)
		A.audit(name, ("réinitialisation de %s pour %s"):format(q.id, target))
		if Q.ui then Q.ui.refresh(target) end
		return true, ("Quête %s réinitialisée pour %s (journal des récompenses conservé)."):format(q.id, target)
	end,
})

core.register_chatcommand("mlq_simulate", {
	params = "<id_quête>",
	description = "[TEST] Émet l'événement déclencheur d'une quête pour soi-même (passe par le circuit normal)",
	privs = ADMIN,
	func = function(name, param)
		local ok, err = test_only()
		if not ok then return false, err end
		local q = Q.get_quest(param:match("^%s*(%S+)%s*$"))
		if not q then return false, "Quête inconnue." end
		local key = q.trigger.key
		if not key then
			for n in pairs(q.targets or {}) do key = n break end
		end
		if not key then return false, "Quête sans cible résolue (indisponible ?)." end
		local n = Q.events.emit(name, q.trigger.type, key, q.trigger.count,
			{ pos = { x = math.random(-30000, 30000), y = 0, z = math.random(-30000, 30000) } })
		A.audit(name, ("simulation de %s (%s %s)"):format(q.id, q.trigger.type, key))
		return true, ("Événement %s %s émis : %d quête(s) affectée(s). État : %s"):format(
			q.trigger.type, key, n, Q.progress.state(name, q))
	end,
})
