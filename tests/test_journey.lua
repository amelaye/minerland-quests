-- Parcours COMPLET de bout en bout (Phase 4), en simulation : arrivée d'un joueur, livre, Unified Inventory, arbre,
-- quêtes liées, validation par de vraies actions, récompenses, notifications, sauvegarde et reprise après redémarrage,
-- puis le catalogue entier joué du début à la fin. Le même parcours dans un VRAI serveur Luanti est couvert (en plus
-- réduit) par tests/integration/run.sh ; ce fichier-ci ne le remplace pas.
local T = ...
local APIS = require("tests.third_party_apis")
local BOOK = "minerland_quests:book"

local function first_target(env, qid)
	for n in pairs(env.Q.quests[qid].targets) do return n end
end

T.describe("premier chapitre, de l'arrivée au dernier titre", function()
	T.it("un joueur arrive, ouvre le livre, joue le chapitre 1 et garde tout après un redémarrage", function()
		local env = T.env({ mods = { "default", "farming", "doors", "unified_inventory" }, all_items = true, ui = true })
		local Q = env.Q
		local p = env:join("alice")
		env:join("bob")

		-- 1) arrivée : le livre est dans le sac, la page Unified Inventory est disponible
		T.eq(env:count("alice", "minerland_quests:book"), 1)
		unified_inventory.set_inventory_formspec(p, "minerland_quests")
		T.contains(env.mock.inventory_formspecs.alice, "Le Grand Livre des Quêtes de Minerland")

		-- 2) navigation jusqu'à l'arbre du chapitre 1 depuis le livre
		env:chat("alice", "quetes")
		env:fields("alice", BOOK, { mlq_part_fundamentals = "x" })
		env:fields("alice", BOOK, { mlq_ch_ch01 = "x" })
		local tree = env.mock.formspecs.alice.fs
		T.contains(tree, "Bûcheron du dimanche")
		T.contains(tree, "mlq_frame_available.png", "première quête disponible (or)")
		T.contains(tree, "mlq_frame_locked.png", "les suivantes verrouillées (gris)")

		-- 3) la chaîne du chapitre, par de vraies actions de jeu
		local log = first_target(env, "ch01.first_log")
		T.eq(env:state("alice", "ch01.planks"), "locked", "verrouillée tant que le tronc n'est pas coupé")
		local wood = "test:group_wood"   -- objet bouchon du groupe « wood » (les quêtes visent le groupe)
		env:craft("alice", wood, 4)
		T.eq(env:state("alice", "ch01.planks"), "locked", "fabriquer des planches avant le tronc ne valide pas")
		env:dig("alice", log)
		T.eq(env:state("alice", "ch01.first_log"), "done")
		T.eq(env:count("alice", "default:apple"), 3, "récompense livrée automatiquement")
		T.contains(env:chat_log("alice"), "Quête accomplie")
		T.eq(env:state("alice", "ch01.planks"), "available", "la suivante se débloque")
		env:step(1)
		T.contains(env.mock.formspecs.alice.fs, "mlq_badge_done.png", "coche verte, livre rafraîchi en direct")

		env:craft("alice", wood, 4)
		env:craft("alice", "default:stick")
		T.eq(env:state("alice", "ch01.first_tool"), "available")
		env:craft("alice", "default:pick_stone")
		env:craft("alice", "default:chest")
		env:place("alice", "default:chest")
		T.eq(env:state("alice", "ch01.furnace"), "available", "prérequis multiples réunis")
		T.eq(env:state("bob", "ch01.planks"), "locked", "bob n'a rien fait : progression indépendante")
		env:place("alice", "default:furnace")
		T.eq(env:state("alice", "ch01.furnace"), "done")
		T.eq(Q.storage.get("alice").titles["ch01.furnace"], "Apprenti de Minerland")
		T.contains(env:chat_log("alice"), "Chapitre terminé")
		T.eq(env:count("alice", "default:steel_ingot"), 2)
		local done, total = Q.progress.chapter_stats("alice", "ch01")
		T.eq(done, total)

		-- 4) redémarrage : tout est retrouvé, rien n'est redonné
		local env2 = env:restart()
		env2:join("alice")
		env2:step(10)
		T.eq(select(1, env2.Q.progress.chapter_stats("alice", "ch01")), total)
		T.eq(env2.Q.storage.get("alice").titles["ch01.furnace"], "Apprenti de Minerland")
		T.eq(env2.Q.rewards.pending_count("alice"), 0)
		T.eq(env2:state("alice", "ch02.door_craft"), "available", "le chapitre suivant reste jouable")
		env2:chat("alice", "quetes")
		env2:fields("alice", BOOK, { mlq_ch_ch01 = "x" })
		T.contains(env2.mock.formspecs.alice.fs, "mlq_badge_done.png")
		T.eq(env2:state("bob", "ch01.first_log"), "available")
	end)
end)

T.describe("le catalogue entier, du premier au dernier chapitre", function()
	-- Quêtes custom : l'événement est émis directement (les adaptateurs sont testés un par un dans test_phase5.lua).
	T.it("toutes les quêtes se valident par leur déclencheur, avec sauvegarde, notifications et reprise", function()
		APIS.with(function()
			local env = T.env({ all_mods = true, all_items = true })
			local Q = env.Q
			env:join("alice")
			local titles = 0
			for _, q in ipairs(Q.quest_list) do
				T.ok(not q.unavailable, q.id .. " jouable")
				if q.reward.title then titles = titles + 1 end
			end
			for _, q in ipairs(Q.quest_list) do
				env:complete_with_requirements("alice", q.id)
				env:clear_inventory("alice")   -- le joueur range ses récompenses
				env:step(1)
			end
			local done, total = Q.progress.global_stats("alice")
			T.eq(done, total, "toutes les quêtes terminées")
			T.eq(total, #Q.quest_list)
			local rec = Q.storage.get("alice")
			local n_titles = 0
			for _ in pairs(rec.titles) do n_titles = n_titles + 1 end
			T.eq(n_titles, titles, "tous les titres honorifiques obtenus")
			T.eq(#rec.pending, 0, "aucune récompense bloquée")
			local finished = select(2, env:chat_log("alice"):gsub("Chapitre terminé", ""))
			T.eq(finished, #Q.chapter_list, "un message de fin pour chacun des chapitres")
			for _, l in ipairs(env.mock.log) do T.ok(l.level ~= "error", "erreur journalisée : " .. l.msg) end
			Q.storage.flush_all()
			local size = #env.mock.storage_data["p:alice"]
			T.ok(size < 32768, ("sauvegarde d'un joueur ayant tout terminé : %d octets (borne 32 Kio)"):format(size))

			-- reprise après redémarrage propre : rien n'est perdu, rien n'est redonné
			local env2 = env:restart()
			env2:join("alice")
			env2:step(10)
			T.eq((env2.Q.progress.global_stats("alice")), done)
			T.eq(env2.Q.rewards.pending_count("alice"), 0)
			for _, q in ipairs(env2.Q.quest_list) do T.eq(env2:state("alice", q.id), "done", q.id) end
			T.eq(env2:count("alice", "default:gold_ingot"), 0, "aucune récompense redonnée")
		end)
	end)
end)
