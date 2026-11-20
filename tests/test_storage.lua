-- Tests SIMULÉS de la sauvegarde et de l'évolution des données : persistance, migration, alias, version trop récente,
-- données illisibles, ajout ou retrait de quêtes, mod tiers absent puis revenu, mémoire des blocs posés.
local T = ...

local ITEMS = { { "test:ore", "node" }, { "test:wire", "node" } }

local function game(extra)
	local opts = { mods = { "default" }, all_items = true, items = ITEMS }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function base(Q)
	Q.register_quest({ id = "ch06.t_a", title = "A", trigger = { type = "dig", items = "test:ore" } })
	Q.register_quest({ id = "ch06.t_b", title = "B", requires = "ch06.t_a",
		trigger = { type = "place", items = "test:wire", count = 4 } })
end

T.describe("persistance", function()
	T.it("quêtes faites, compteurs et positions déjà comptées survivent à un redémarrage", function()
		local env = game({ before_finalize = base })
		env:join("alice")
		env:dig("alice", "test:ore")
		local p1, p2 = env:place("alice", "test:wire"), env:place("alice", "test:wire")
		T.eq(env.Q.progress.count("alice", env.Q.get_quest("ch06.t_b")), 2)
		local env2 = env:restart()
		env2:join("alice")
		T.eq(env2:state("alice", "ch06.t_a"), "done")
		T.eq(env2.Q.progress.count("alice", env2.Q.get_quest("ch06.t_b")), 2, "compteur conservé")
		env2:place("alice", "test:wire", p1)   -- case déjà comptée avant l'arrêt
		T.eq(env2.Q.progress.count("alice", env2.Q.get_quest("ch06.t_b")), 2, "ne recompte pas")
		env2:place("alice", "test:wire") env2:place("alice", "test:wire")
		T.eq(env2:state("alice", "ch06.t_b"), "done")
		local _ = p2
	end)

	T.it("le format est versionné et deux joueurs ont chacun leur clé", function()
		local env = game({ before_finalize = base })
		env:join("alice") env:join("bob")
		env:dig("alice", "test:ore")
		env.Q.storage.flush_all()
		local data = env.mock.storage_data
		local rec = env.core.parse_json(data["p:alice"])
		T.eq(rec.v, env.Q.storage.VERSION)
		T.ok(rec.done["ch06.t_a"])
		T.eq(env:state("bob", "ch06.t_a"), "available", "bob indépendant")
		T.eq(table.concat(env.Q.storage.known_players(), ","), "alice")
	end)

	T.it("les écritures groupées sont vidées à l'arrêt propre et périodiquement", function()
		local env = game({ before_finalize = base })
		env:join("alice")
		env:dig("alice", "test:ore")      -- quête terminée : écriture immédiate
		env:place("alice", "test:wire")   -- compteur en cours : écriture différée
		T.eq(env.core.parse_json(env.mock.storage_data["p:alice"]).prog, nil, "pas encore écrit")
		env:step(11)                      -- vidage périodique (10 s)
		T.eq(env.core.parse_json(env.mock.storage_data["p:alice"]).prog["ch06.t_b"], 1, "écrit au vidage périodique")
	end)
end)

T.describe("migration et compatibilité des données", function()
	T.it("sauvegarde d'une préversion (sans numéro, ancien champ « completed ») migrée en version 1", function()
		local env = game({ before_finalize = base, storage_data = {
			["p:vieux"] = '{"completed":{"ch06.t_a":1700000000}}' } })
		local rec = env.Q.storage.get("vieux")
		T.eq(rec.v, env.Q.storage.VERSION)
		T.eq(rec.done["ch06.t_a"], 1700000000)
		T.eq(rec.completed, nil)
		T.ok(rec.pending and rec.titles and rec.rewarded, "champs manquants reconstruits")
		env:join("vieux")
		T.eq(env:state("vieux", "ch06.t_b"), "available", "la suite est débloquée")
	end)

	T.it("renommage d'une quête : l'alias reporte la progression sur le nouvel identifiant", function()
		local env = game({ before_finalize = base, storage_data = {
			["p:alice"] = '{"v":1,"done":{"ch06.ancien":1700000000},"rewarded":{"ch06.ancien":1700000000}}' } })
		env.Q.storage.quest_aliases["ch06.ancien"] = "ch06.t_a"
		env.Q.storage.drop_cache()
		local rec = env.Q.storage.get("alice")
		T.ok(rec.done["ch06.t_a"], "faite sous le nouveau nom")
		T.eq(rec.done["ch06.ancien"], nil)
		T.ok(rec.rewarded["ch06.t_a"], "journal de récompense suivi aussi")
	end)

	T.it("données d'un format plus récent : lecture seule, rien n'est écrasé", function()
		local raw = '{"v":99,"done":{"ch06.t_a":5},"futur":true}'
		local env = game({ before_finalize = base, storage_data = { ["p:alice"] = raw } })
		env:join("alice")
		env.Q.storage.get("alice")
		T.ok(env.Q.storage.is_readonly("alice"))
		T.eq(env:state("alice", "ch06.t_a"), "done", "l'état lu reste celui du fichier")
		for _ = 1, 4 do env:place("alice", "test:wire") end
		T.ok(not env.Q.storage.get("alice").done["ch06.t_b"], "aucune quête validée en lecture seule")
		env.Q.storage.flush_all()
		env:leave("alice")
		T.eq(env.mock.storage_data["p:alice"], raw, "fichier intact")
		T.eq(env.Q.rewards.grant("alice", env.Q.get_quest("ch06.t_b")), false)
	end)

	T.it("format plus récent AVEC champs absents : l'interface et les statistiques ne plantent pas", function()
		local env = game({ before_finalize = base, storage_data = { ["p:alice"] = '{"v":99}' } })
		env:join("alice")
		T.eq(env:state("alice", "ch06.t_a"), "available")
		T.ok(#env.Q.book.formspec("alice") > 200)
		T.eq(env.Q.rewards.grant("alice", env.Q.get_quest("ch06.t_a")), false)
		env.Q.storage.flush_all()
		env:leave("alice")
		T.eq(env.mock.storage_data["p:alice"], '{"v":99}', "fichier intact")
	end)

	T.it("données illisibles : copie de secours, nouveau départ, aucune erreur", function()
		local env = game({ before_finalize = base, storage_data = { ["p:alice"] = "{pas du json" } })
		env:join("alice")
		T.eq(env:state("alice", "ch06.t_a"), "available")
		T.eq(env.mock.storage_data["p_corrupt:alice"], "{pas du json", "original sauvegardé")
	end)
end)

T.describe("évolution du catalogue", function()
	T.it("ajouter une quête plus tard conserve la progression et la place dans le graphe", function()
		local env = game({ before_finalize = base })
		env:join("alice")
		env:dig("alice", "test:ore")
		local env2 = env:restart({ before_finalize = function(Q)
			base(Q)
			Q.register_quest({ id = "ch06.t_new", title = "Nouvelle", requires = "ch06.t_a",
				trigger = { type = "dig", items = "test:ore" } })
		end })
		env2:join("alice")
		T.eq(env2:state("alice", "ch06.t_a"), "done")
		T.eq(env2:state("alice", "ch06.t_new"), "available", "débloquée par un prérequis déjà fait")
	end)

	T.it("retirer une quête du catalogue ne casse ni les statistiques ni l'affichage", function()
		local env = game({ before_finalize = base })
		env:join("alice")
		env:dig("alice", "test:ore")
		local env2 = env:restart({ before_finalize = function() end })   -- plus aucune quête de test
		env2:join("alice")
		T.eq(env2.Q.get_quest("ch06.t_a"), nil)
		local d, t = env2.Q.progress.global_stats("alice")
		T.ok(t > 0 and d >= 0)
		T.ok(#env2.Q.book.formspec("alice") > 200)
	end)

	T.it("un mod tiers absent puis revenu : quêtes indisponibles, progression intacte, puis rétablies", function()
		local with_mod = function(Q)
			Q.register_quest({ id = "ch06.t_m", title = "M", trigger = { type = "dig", items = "test:ore" },
				mods = { "mod_tiers" } })
		end
		local env = game({ before_finalize = with_mod, mods = { "default", "mod_tiers" } })
		env:join("alice")
		env:dig("alice", "test:ore")
		T.eq(env:state("alice", "ch06.t_m"), "done")
		local env2 = env:restart({ mods = { "default" } })
		env2:join("alice")
		T.eq(env2:state("alice", "ch06.t_m"), "done", "terminée reste terminée même si le mod est parti")
		local env3 = env2:restart({ mods = { "default", "mod_tiers" } })
		env3:join("alice")
		T.eq(env3:state("alice", "ch06.t_m"), "done")
	end)
end)

T.describe("mémoire des blocs posés", function()
	T.it("elle survit au redémarrage et reste bornée (les plus anciennes positions sont oubliées)", function()
		local env = game({ before_finalize = base, settings = { ["minerland_quests.placed_cap"] = 3 } })
		env:join("alice")
		local first = env:place("alice", "test:ore")
		for _ = 1, 3 do env:place("alice", "test:ore") end
		env:dig("alice", "test:ore", first)
		T.eq(env:state("alice", "ch06.t_a"), "done", "la plus ancienne position a été oubliée (borne 3)")
		local env2 = game({ before_finalize = base, settings = { ["minerland_quests.placed_cap"] = 3 } })
		env2:join("bob")
		local pos = env2:place("bob", "test:ore")
		env2.Q.storage.flush_all()
		local env3 = game({ before_finalize = base, storage_data = env2.mock.storage_data })
		env3:join("bob")
		env3:dig("bob", "test:ore", pos)
		T.eq(env3:state("bob", "ch06.t_a"), "available", "position posée avant l'arrêt toujours connue")
	end)
end)
