-- Tests SIMULÉS à plusieurs joueurs (Phase 6) : progression, compteurs et récompenses séparés, validations
-- simultanées, rafraîchissement et notifications chez le seul joueur concerné, navigation indépendante, déconnexion
-- en cours de partie, commandes d'administration ciblées, charge de 40 joueurs, sauvegardes à plusieurs joueurs.
local T = ...
local BOOK = "minerland_quests:book"
local ADMIN = { interact = true, minerland_quests_admin = true }

local ITEMS = { { "test:ore", "node" }, { "test:gem", "node" }, { "default:cobble", "node" } }

local function quests(Q)
	Q.register_quest({ id = "ch06.t_count", title = "Trois minerais", reward = { items = { "default:torch 5" } },
		trigger = { type = "dig", items = "test:ore", count = 3 } })
	Q.register_quest({ id = "ch06.t_one", title = "Une gemme", reward = { items = { "default:apple 2" },
		title = "Titre test" }, trigger = { type = "dig", items = "test:gem" } })
end

local function game(extra)
	local opts = { mods = { "default", "farming", "unified_inventory" }, all_items = true, ui = true, items = ITEMS,
		before_finalize = quests }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function huds(env, name)
	local n = 0
	for _ in pairs(env:player(name).huds) do n = n + 1 end
	return n
end

T.describe("plusieurs joueurs en même temps", function()
	T.it("compteurs, états et récompenses restent propres à chaque joueur", function()
		local env = game()
		for _, n in ipairs({ "alice", "bob", "carol" }) do env:join(n) end
		local q = env.Q.get_quest("ch06.t_count")
		env:dig("alice", "test:ore") env:dig("bob", "test:ore") env:dig("alice", "test:ore")
		T.eq(env.Q.progress.count("alice", q), 2)
		T.eq(env.Q.progress.count("bob", q), 1)
		T.eq(env.Q.progress.count("carol", q), 0)
		env:dig("alice", "test:ore")
		T.eq(env:state("alice", "ch06.t_count"), "done")
		T.eq(env:state("bob", "ch06.t_count"), "available")
		T.eq(env:count("alice", "default:torch"), 5)
		T.eq(env:count("bob", "default:torch"), 0)
		T.eq(env:count("carol", "default:torch"), 0)
	end)

	T.it("deux joueurs valident la même quête au même instant : une récompense chacun, jamais deux", function()
		local env = game()
		env:join("alice") env:join("bob")
		env:dig("alice", "test:gem") env:dig("bob", "test:gem")   -- même pas de temps serveur
		for _, n in ipairs({ "alice", "bob" }) do
			T.eq(env:state(n, "ch06.t_one"), "done", n)
			T.eq(env:count(n, "default:apple"), 2, n)
			T.eq(env.Q.storage.get(n).titles["ch06.t_one"], "Titre test", n)
		end
		for _ = 1, 3 do env:dig("alice", "test:gem") env:dig("bob", "test:gem") end
		env:step(20)
		T.eq(env:count("alice", "default:apple"), 2, "pas de seconde récompense")
		T.eq(env:count("bob", "default:apple"), 2)
	end)

	T.it("le livre ouvert ne se rafraîchit, et la notification n'apparaît, que chez le joueur concerné", function()
		local env = game()
		env:join("alice") env:join("bob")
		for _, n in ipairs({ "alice", "bob" }) do
			env:chat(n, "quetes")
			env:fields(n, BOOK, { mlq_ch_ch06 = "x" })
		end
		local alice_before = env.mock.formspecs.alice.fs
		env.mock.formspecs.bob = { sentinel = true }   -- remplacé si le livre de bob était réaffiché
		env:dig("alice", "test:gem")
		env:step(1)
		T.ok(env.mock.formspecs.alice.fs ~= alice_before, "livre d'alice rafraîchi")
		T.ok(env.mock.formspecs.bob.sentinel, "livre de bob non réaffiché")
		T.contains(env:chat_log("alice"), "Une gemme")
		T.not_contains(env:chat_log("bob"), "Une gemme")
		T.ok(huds(env, "alice") > 0, "bandeau chez alice")
		T.eq(huds(env, "bob"), 0, "rien chez bob")
	end)

	T.it("chaque joueur garde sa propre navigation, dans le livre comme dans Unified Inventory", function()
		local env = game()
		env:join("alice")
		local pb = env:join("bob")
		env:fields("alice", BOOK, { mlq_ch_ch04 = "x" })
		env:fields("bob", BOOK, { mlq_ch_ch01 = "x" })
		T.eq(env.Q.views.state("alice").chapter, "ch04")
		T.eq(env.Q.views.state("bob").chapter, "ch01")
		T.contains(env.mock.formspecs.bob.fs, "Bûcheron du dimanche")
		unified_inventory.set_inventory_formspec(pb, "minerland_quests")
		T.contains(env.mock.inventory_formspecs.bob, "Bûcheron du dimanche", "la page UI de bob suit sa propre vue")
		T.eq(env.Q.views.state("alice").chapter, "ch04", "la vue d'alice n'a pas bougé")
	end)

	T.it("un joueur se déconnecte avec une récompense en attente pendant que les autres jouent", function()
		local env = game()
		env:join("alice") env:join("bob")
		env:fill_inventory("alice", "default:cobble")
		env:dig("alice", "test:gem")
		T.eq(env.Q.rewards.pending_count("alice"), 1)
		env:leave("alice")
		env:dig("bob", "test:gem")
		for _ = 1, 3 do env:dig("bob", "test:ore") end
		env:step(20)
		T.eq(env:count("bob", "default:apple"), 2)
		T.eq(env:count("bob", "default:torch"), 5)
		T.eq(env.Q.rewards.pending_count("alice"), 1, "file d'alice intacte hors ligne")
		env:join("alice")   -- inventaire neuf dans le mock
		env:step(5)
		T.eq(env.Q.rewards.pending_count("alice"), 0)
		T.eq(env:count("alice", "default:apple"), 2)
		T.eq(env:count("bob", "default:apple"), 2, "bob n'a rien reçu de plus")
	end)

	T.it("les commandes d'administration n'agissent que sur le joueur visé", function()
		local env = game({ settings = { ["minerland_quests.allow_reset"] = true } })
		env:join("alice") env:join("bob") env:join("root", ADMIN)
		env:dig("alice", "test:gem") env:dig("bob", "test:gem")
		env:chat("root", "mlq_reset", "alice ch06.t_one")
		T.eq(env:state("alice", "ch06.t_one"), "available")
		T.eq(env:state("bob", "ch06.t_one"), "done", "bob intact")
		T.ok(env.Q.storage.get("bob").rewarded["ch06.t_one"])
		local ok, out = env:chat("root", "mlq_quest", "bob ch06.t_one")
		T.ok(ok)
		T.contains(out, "ch06.t_one [done]")
	end)

	T.it("quarante joueurs actifs à la fois : progression exacte et traitement rapide", function()
		local env = game()
		local names = {}
		for i = 1, 40 do
			names[i] = ("joueur%02d"):format(i)
			env:join(names[i])
		end
		local t0 = os.clock()
		for _ = 1, 3 do
			for _, n in ipairs(names) do env:dig(n, "test:ore") end
		end
		for i, n in ipairs(names) do
			if i % 2 == 0 then env:dig(n, "test:gem") end
		end
		env:step(11)
		local elapsed = os.clock() - t0
		for i, n in ipairs(names) do
			T.eq(env:state(n, "ch06.t_count"), "done", n)
			T.eq(env:state(n, "ch06.t_one"), i % 2 == 0 and "done" or "available", n)
			T.eq(env:count(n, "default:torch"), 5, n)
		end
		T.eq(#env.Q.storage.known_players(), 40, "une sauvegarde par joueur")
		T.ok(elapsed < 2, ("140 actions de 40 joueurs traitées en %.3f s"):format(elapsed))
	end)
end)

T.describe("sauvegardes à plusieurs joueurs", function()
	T.it("arrêt propre puis reprise : chacun retrouve exactement son état", function()
		local env = game()
		env:join("alice") env:join("bob") env:join("carol")
		env:dig("alice", "test:gem")                                   -- terminée, avec titre
		env:dig("bob", "test:ore") env:dig("bob", "test:ore")          -- compteur 2/3
		env:fill_inventory("carol", "default:cobble")
		env:dig("carol", "test:gem")                                   -- terminée, récompense en attente
		local env2 = env:restart()
		local Q2 = env2.Q
		T.eq(env2:state("alice", "ch06.t_one"), "done")
		T.eq(Q2.storage.get("alice").titles["ch06.t_one"], "Titre test")
		T.eq(Q2.rewards.pending_count("alice"), 0)
		T.eq(Q2.progress.count("bob", Q2.get_quest("ch06.t_count")), 2)
		T.eq(env2:state("bob", "ch06.t_one"), "available")
		T.eq(env2:state("carol", "ch06.t_one"), "done")
		T.eq(Q2.rewards.pending_count("carol"), 1)
		T.eq(table.concat(Q2.storage.known_players(), ","), "alice,bob,carol")
		env2:join("carol")
		env2:step(5)
		T.eq(env2:count("carol", "default:apple"), 2, "livrée après la reprise")
	end)

	T.it("arrêt brutal : quêtes terminées et journaux conservés ; seul un compteur non vidé recule", function()
		local env = game()
		env:join("alice") env:join("bob")
		env:dig("alice", "test:gem")   -- terminée : écrite tout de suite
		env:dig("bob", "test:ore")
		env:step(11)                   -- vidage périodique : compteur de bob = 1 écrit
		env:dig("bob", "test:ore")     -- 2, pas encore écrit
		local env2 = env:crash_restart()
		T.eq(env2:state("alice", "ch06.t_one"), "done")
		T.ok(env2.Q.storage.get("alice").rewarded["ch06.t_one"], "journal de récompense conservé")
		T.eq(env2.Q.progress.count("bob", env2.Q.get_quest("ch06.t_count")), 1, "dernier pas perdu, rien d'autre")
	end)
end)
