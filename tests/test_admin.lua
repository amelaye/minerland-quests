-- Tests SIMULÉS des commandes : ouverture pour tous, outils d'administration réservés au privilège dédié, commandes de
-- test désactivées en production, journalisation des actions d'administration, aucun privilège en récompense.
local T = ...
local APIS = require("tests.third_party_apis")

local ADMIN = { interact = true, minerland_quests_admin = true }

local function game(extra)
	local opts = { mods = { "default", "farming" }, all_items = true }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function logged(env, needle)
	for _, l in ipairs(env.mock.log) do
		if l.level == "action" and l.msg:find(needle, 1, true) then return true end
	end
	return false
end

T.describe("commandes joueur", function()
	T.it("/quetes, /livre et /quests existent et n'exigent aucun privilège", function()
		local env = game({ ui = true })
		env:join("alice")
		for _, cmd in ipairs({ "quetes", "livre", "quests" }) do
			local def = env.core.registered_chatcommands[cmd]
			T.ok(def, cmd)
			T.eq(def.privs, nil, cmd .. " sans privilège")
		end
	end)

	T.it("une commande déjà prise par un autre mod n'est pas écrasée (les autres noms restent disponibles)", function()
		local theirs = function() return true, "commande de l'autre mod" end
		local env = game({ before_load = function(core)
			core.register_chatcommand("livre", { description = "autre mod", func = theirs })
		end })
		T.eq(env.core.registered_chatcommands.livre.func, theirs, "« livre » reste à l'autre mod")
		T.ok(env.core.registered_chatcommands.quetes, "« quetes » disponible")
		T.ok(env.core.registered_chatcommands.quests, "« quests » disponible")
	end)
end)

T.describe("administration", function()
	T.it("les commandes mlq_* exigent le privilège minerland_quests_admin", function()
		local env = game()
		env:join("alice") env:join("root", ADMIN)
		for _, cmd in ipairs({ "mlq_progress", "mlq_quest", "mlq_reward", "mlq_diag", "mlq_reset", "mlq_simulate" }) do
			local ok, msg = env:chat("alice", cmd, "alice ch01.first_log")
			T.eq(ok, false, cmd .. " refusée à un joueur ordinaire")
			T.eq(msg, "privilèges insuffisants")
		end
		local ok = env:chat("root", "mlq_diag")
		T.eq(ok, true)
	end)

	T.it("/mlq_progress, /mlq_quest et /mlq_reward renseignent l'administratrice sans rien modifier", function()
		local env = game()
		env:join("alice") env:join("root", ADMIN)
		env:complete("alice", "ch01.first_log")
		local ok, out = env:chat("root", "mlq_progress", "alice")
		T.ok(ok)
		T.contains(out, "1/")
		T.contains(out, "ch01")
		ok, out = env:chat("root", "mlq_quest", "alice ch01.first_log")
		T.ok(ok)
		T.contains(out, "ch01.first_log [done]")
		T.contains(out, "delivered")
		ok, out = env:chat("root", "mlq_reward", "alice")
		T.ok(ok)
		T.contains(out, "1 récompense(s) attribuée(s)")
		T.eq(env:count("alice", "default:apple"), 3, "diagnostic sans effet de bord")
	end)

	T.it("joueur, quête ou paramètres inconnus : message d'erreur, aucune exception", function()
		local env = game()
		env:join("root", ADMIN)
		for _, c in ipairs({ { "mlq_progress", "fantome" }, { "mlq_progress", "" }, { "mlq_quest", "root ch99.x" },
			{ "mlq_quest", "fantome ch01.first_log" }, { "mlq_quest", "" }, { "mlq_reward", "fantome" } }) do
			local ok, msg = env:chat("root", c[1], c[2])
			T.eq(ok, false, c[1] .. " " .. c[2])
			T.ok(type(msg) == "string" and msg ~= "")
		end
	end)

	T.it("/mlq_reset et /mlq_simulate sont refusées tant que allow_reset n'est pas activé (production)", function()
		local env = game()
		env:join("alice", ADMIN)
		local ok, msg = env:chat("alice", "mlq_simulate", "ch01.first_log")
		T.eq(ok, false)
		T.contains(msg, "allow_reset")
		T.eq(env:state("alice", "ch01.first_log"), "available")
		ok = env:chat("alice", "mlq_reset", "alice ch01.first_log")
		T.eq(ok, false)
	end)

	T.it("en instance de test : /mlq_simulate passe par le circuit normal et les actions sont journalisées", function()
		local env = game({ settings = { ["minerland_quests.allow_reset"] = true } })
		env:join("alice", ADMIN)
		local ok = env:chat("alice", "mlq_simulate", "ch01.first_log")
		T.ok(ok)
		T.eq(env:state("alice", "ch01.first_log"), "done")
		T.eq(env:count("alice", "default:apple"), 3, "récompense livrée par le circuit normal")
		T.ok(logged(env, "[admin] alice : simulation de ch01.first_log"), "journal d'administration")
		env:chat("alice", "mlq_reset", "alice ch01.first_log")
		T.ok(logged(env, "réinitialisation de ch01.first_log pour alice"))
		env:chat("alice", "mlq_reward", "alice")
		T.ok(logged(env, "diagnostic récompenses de alice"))
	end)

	T.it("/mlq_diag liste intégrations, langues et quêtes indisponibles", function()
		local env = game()
		env:join("root", ADMIN)
		local _, out = env:chat("root", "mlq_diag")
		T.contains(out, "193 quêtes")
		T.contains(out, "Intégrations actives")
		T.contains(out, "rides")
		T.contains(out, "Langues : en, fr")
		T.contains(out, "indisponible")
	end)

	T.it("réponses des commandes dans la langue du joueur", function()
		local env = game()
		env:join("root", ADMIN, "en")
		local _, out = env:chat("root", "mlq_diag")
		T.contains(out, "quests")
		T.contains(out, "Active integrations")
	end)
end)

T.describe("aucun privilège en récompense", function()
	T.it("terminer toutes les quêtes ne modifie jamais les privilèges d'un joueur", function()
		APIS.with(function()
			local env = T.env({ all_mods = true, all_items = true })
			env:join("alice")
			local before = {}
			for k, v in pairs(env.core.get_player_privs("alice")) do before[k] = v end
			for _, q in ipairs(env.Q.quest_list) do
				env:complete_with_requirements("alice", q.id)
				env:clear_inventory("alice")
			end
			local after = env.core.get_player_privs("alice")
			for k in pairs(after) do T.ok(before[k], "privilège apparu : " .. k) end
			for k in pairs(before) do T.ok(after[k], "privilège perdu : " .. k) end
			T.eq(env.core.set_player_privs, nil, "le mod n'utilise jamais set_player_privs")
		end)
	end)
end)
