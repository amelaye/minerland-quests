-- Tests SIMULÉS du moteur : enregistrement, identification, prérequis, déblocage, compteurs, validation unique,
-- dépendances circulaires, quête ou objet absent. Les quêtes de test ont des ids « chNN.t_* » (ajoutées au catalogue).
local T = ...
local APIS = require("tests.third_party_apis")

local ITEMS = { { "test:ore", "node" }, { "test:gem", "node" }, { "test:rock", "node" }, { "test:sand", "node" } }

local function env_with(register, extra)
	local opts = { mods = { "default" }, all_items = true, items = ITEMS, before_finalize = register }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function dig_quest(Q, id, extra)
	local def = { id = id, title = "Quête " .. id, trigger = { type = "dig", items = "test:ore" } }
	for k, v in pairs(extra or {}) do def[k] = v end
	return Q.register_quest(def)
end

T.describe("enregistrement et identification", function()
	T.it("une quête enregistrée reçoit ses valeurs par défaut et se retrouve par id et par index", function()
		local env = env_with(function(Q) dig_quest(Q, "ch06.t_a") end)
		local q = env.Q.get_quest("ch06.t_a")
		T.ok(q, "retrouvée par identifiant")
		T.eq(q.chapter, "ch06")
		T.eq(q.difficulty, 1)
		T.eq(q.trigger.count, 1)
		T.eq(#q.requires, 0)
		T.eq(env.Q.get_quest_by_index(q.index).id, "ch06.t_a")
		T.eq(env.Q.get_quest_by_index(0), nil)
		T.eq(env.Q.get_quest_by_index("abc"), nil)
	end)

	T.it("les définitions invalides sont refusées avec un message clair", function()
		env_with(function(Q)
			T.raises(function() dig_quest(Q, "ch06.t_a") dig_quest(Q, "ch06.t_a") end, "déjà enregistrée")
			T.raises(function() dig_quest(Q, "ch99.t_x") end, "chapitre inconnu")
			T.raises(function() dig_quest(Q, "Mauvais Id") end)
			T.raises(function() dig_quest(Q, "ch06.t_b", { trigger = { type = "dig" } }) end, "sans items")
			T.raises(function() dig_quest(Q, "ch06.t_c", { trigger = { type = "custom" } }) end, "sans key")
			T.raises(function() dig_quest(Q, "ch06.t_d", { trigger = { type = "voler", items = "x:y" } }) end,
				"type de trigger inconnu")
			T.raises(function() dig_quest(Q, "ch06.t_e", { difficulty = 9 }) end, "difficulty")
			T.raises(function() dig_quest(Q, "ch06.t_f", { reward = { items = { "default:apple 0" } } }) end,
				"quantité de récompense")
			T.raises(function() dig_quest(Q, "ch06.t_g", { title = "" }) end, "title requis")
			T.raises(function() dig_quest(Q, "ch07.t_h", { chapter = "ch06" }) end, "préfixe")
		end)
	end)

	T.it("une quête ou un chapitre absent n'a pas d'état et ne casse rien", function()
		local env = env_with()
		T.eq(env.Q.get_quest("ch99.nope"), nil)
		T.eq(env.Q.get_quest(nil), nil)
		T.eq(#env.Q.get_chapter_quests("ch99"), 0)
		env:join("alice")
		T.eq(env.Q.progress.state("alice", "ch99.nope"), "unavailable")
		T.eq(env.Q.events.emit("alice", "dig", "x:inconnu", 1), 0)
		T.eq(env.Q.events.emit("alice", "voler", "x", 1), 0, "type d'événement inconnu")
		T.eq(env.Q.events.emit("ghost", "dig", "test:ore", 1), 0, "joueur absent")
	end)
end)

T.describe("prérequis et déblocage", function()
	local function chain(Q)
		local function on(item) return { type = "dig", items = item } end
		dig_quest(Q, "ch06.t_a", { trigger = on("test:ore") })
		dig_quest(Q, "ch06.t_b", { requires = "ch06.t_a", trigger = on("test:gem") })
		dig_quest(Q, "ch06.t_c", { requires = "ch06.t_a", trigger = on("test:rock") })        -- branche parallèle
		dig_quest(Q, "ch06.t_d", { requires = { "ch06.t_b", "ch06.t_c" }, trigger = on("test:sand") })  -- multiples
	end

	T.it("une quête verrouillée se débloque quand ses prérequis sont faits (un à la fois, puis tous)", function()
		local env = env_with(chain)
		env:join("alice")
		T.eq(env:state("alice", "ch06.t_a"), "available")
		T.eq(env:state("alice", "ch06.t_b"), "locked")
		T.eq(env:state("alice", "ch06.t_d"), "locked")
		env:complete("alice", "ch06.t_a")
		T.eq(env:state("alice", "ch06.t_b"), "available")
		T.eq(env:state("alice", "ch06.t_c"), "available", "branches parallèles débloquées ensemble")
		env:complete("alice", "ch06.t_b")
		T.eq(env:state("alice", "ch06.t_d"), "locked", "il faut aussi la seconde branche")
		env:complete("alice", "ch06.t_c")
		T.eq(env:state("alice", "ch06.t_d"), "available")
	end)

	T.it("la complétion appelle les rappels une fois, avec l'indication « chapitre terminé »", function()
		local seen = {}
		local env = env_with(function(Q)
			chain(Q)
			Q.register_on_complete(function(name, q, chapter_done) seen[#seen + 1] = name .. ":" .. q.id .. ":" ..
				tostring(chapter_done) end)
		end)
		env:join("alice")
		env:complete("alice", "ch06.t_a")
		T.eq(#seen, 1)
		T.eq(seen[1], "alice:ch06.t_a:false")
	end)

	T.it("une quête inaccessible faute de mod est ignorée comme prérequis (elle ne bloque pas la suite)", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_m", { mods = { "mod_absent" } })
			dig_quest(Q, "ch06.t_n", { requires = "ch06.t_m" })
		end)
		env:join("alice")
		T.eq(env:state("alice", "ch06.t_m"), "unavailable")
		T.contains(env.Q.get_quest("ch06.t_m").unavailable, "mod_absent")
		T.eq(env:state("alice", "ch06.t_n"), "available")
		T.eq(env.Q.events.emit("alice", "dig", "test:ore", 1) > 0, true)
		T.eq(env:state("alice", "ch06.t_m"), "unavailable", "jamais validée")
	end)
end)

T.describe("dépendances circulaires et références cassées", function()
	T.it("un cycle rend les quêtes concernées indisponibles et est signalé", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_x", { requires = "ch06.t_z" })
			dig_quest(Q, "ch06.t_y", { requires = "ch06.t_x" })
			dig_quest(Q, "ch06.t_z", { requires = "ch06.t_y" })
			dig_quest(Q, "ch06.t_ok")
		end)
		for _, id in ipairs({ "ch06.t_x", "ch06.t_y", "ch06.t_z" }) do
			T.ok(env.Q.get_quest(id).unavailable, id .. " indisponible")
		end
		T.eq(env.Q.get_quest("ch06.t_ok").unavailable, nil, "quête voisine intacte")
		local found = false
		for _, p in ipairs(env.Q.graph.problems) do found = found or p:find("circulaire") ~= nil end
		T.ok(found, "problème enregistré pour /mlq_diag")
	end)

	T.it("auto-prérequis et prérequis inconnu sont détectés", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_s", { requires = "ch06.t_s" })
			dig_quest(Q, "ch06.t_u", { requires = "ch06.fantome" })
		end)
		T.ok(env.Q.get_quest("ch06.t_u").unavailable, "prérequis inconnu")
		T.contains(env.Q.get_quest("ch06.t_u").unavailable, "ch06.fantome")
		T.ok(env.Q.get_quest("ch06.t_s").unavailable, "boucle sur elle-même")
	end)

	T.it("le catalogue réel ne contient aucun problème de graphe (tous mods et API présents)", function()
		APIS.with(function()
			local env = T.env({ all_mods = true, all_items = true })
			T.eq(#env.Q.graph.problems, 0)
			for _, q in ipairs(env.Q.quest_list) do T.ok(env.Q.graph.reachable(q), q.id .. " atteignable") end
		end)
	end)

	T.it("un objet cible introuvable rend la quête indisponible ; une récompense introuvable est retirée", function()
		local env = env_with(function(Q)
			Q.register_quest({ id = "ch06.t_v", title = "V", trigger = { type = "dig", items = "absent:objet" } })
			Q.register_quest({ id = "ch06.t_w", title = "W", trigger = { type = "dig", items = "test:ore" },
				reward = { items = { "absent:cadeau 2", "default:apple 1" } } })
		end)
		T.ok(env.Q.get_quest("ch06.t_v").unavailable, "cible absente")
		local w = env.Q.get_quest("ch06.t_w")
		T.eq(w.unavailable, nil)
		T.eq(#w.reward_items, 1)
		T.eq(w.reward_items[1], "default:apple")
		T.eq(#w.reward_missing, 1)
	end)
end)

T.describe("compteurs et validation", function()
	T.it("un compteur progresse événement après événement jusqu'à la validation", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_n3", { trigger = { type = "dig", items = "test:ore", count = 3 } })
		end)
		env:join("alice")
		local q = env.Q.get_quest("ch06.t_n3")
		T.eq(env.Q.progress.count("alice", q), 0)
		env:dig("alice", "test:ore")
		T.eq(env.Q.progress.count("alice", q), 1)
		T.eq(env:state("alice", "ch06.t_n3"), "available")
		env:dig("alice", "test:ore") env:dig("alice", "test:ore")
		T.eq(env:state("alice", "ch06.t_n3"), "done")
		T.eq(env.Q.progress.count("alice", q), 3)
	end)

	T.it("une quête terminée ne se valide ni ne se récompense une seconde fois", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_r", { reward = { items = { "default:apple 2" } } })
		end)
		env:join("alice")
		env:dig("alice", "test:ore")
		T.eq(env:count("alice", "default:apple"), 2)
		for _ = 1, 5 do env:dig("alice", "test:ore") end
		T.eq(env:count("alice", "default:apple"), 2, "pas de seconde récompense")
		T.eq(env.Q.progress.complete("alice", env.Q.get_quest("ch06.t_r")), false, "complete() refuse une quête faite")
	end)

	T.it("un événement ne compte pas pour une quête encore verrouillée", function()
		local env = env_with(function(Q)
			dig_quest(Q, "ch06.t_a")
			dig_quest(Q, "ch06.t_b", { requires = "ch06.t_a" })
		end)
		env:join("alice")
		env:dig("alice", "test:ore")
		T.eq(env.Q.progress.count("alice", env.Q.get_quest("ch06.t_b")), 0)
	end)

	T.it("les statistiques de chapitre, de partie et globales suivent la progression", function()
		APIS.with(function()   -- API simulées présentes pendant tout le test (sondes comprises)
			local env = T.env({ all_mods = true, all_items = true })
			env:join("alice")
			local d0, t0 = env.Q.progress.chapter_stats("alice", "ch01")
			T.eq(d0, 0)
			T.eq(t0, #env.Q.get_chapter_quests("ch01"))
			env:complete("alice", "ch01.first_log")
			T.eq((env.Q.progress.chapter_stats("alice", "ch01")), 1)
			T.eq((env.Q.progress.part_stats("alice", "fundamentals")), 1)
			T.eq((env.Q.progress.global_stats("alice")), 1)
			local _, total = env.Q.progress.global_stats("alice")
			T.eq(total, #env.Q.quest_list)
		end)
	end)
end)
