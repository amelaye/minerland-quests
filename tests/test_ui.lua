-- Tests SIMULÉS de l'interface : ouverture (commande, objet, Unified Inventory), navigation, SÉCURITÉ des champs de
-- formulaire, prérequis, coches, récompenses, quêtes indisponibles, grand arbre, échappement, rafraîchissement.
-- Aucun rendu réel : les formspecs sont des chaînes inspectées ; le rendu dans le moteur n'est pas couvert ici.
local T = ...
local BOOK = "minerland_quests:book"

local function game(extra)
	local opts = { mods = { "default", "farming", "unified_inventory" }, all_items = true, ui = true }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function click(env, name, field)
	return env:fields(name, BOOK, { [field] = "x" })
end

T.describe("ouverture", function()
	T.it("depuis la commande, l'objet livre et un clic droit dans le vide", function()
		local env = game()
		local p = env:join("alice")
		env:chat("alice", "quetes")
		T.eq(env.mock.formspecs.alice.formname, BOOK)
		T.contains(env.mock.formspecs.alice.fs, "Le Grand Livre des Quêtes de Minerland")
		env.mock.formspecs.alice = nil
		local def = env.core.registered_items["minerland_quests:book"]
		def.on_use(ItemStack("minerland_quests:book"), p, { type = "nothing" })
		T.eq(env.mock.formspecs.alice.formname, BOOK)
		env.mock.formspecs.alice = nil
		def.on_secondary_use(ItemStack("minerland_quests:book"), p, { type = "nothing" })
		T.eq(env.mock.formspecs.alice.formname, BOOK)
	end)

	T.it("un nouveau joueur reçoit le livre une seule fois, à sa première connexion", function()
		local env = game()
		env:join("alice")
		T.eq(env:count("alice", "minerland_quests:book"), 1)
		env:leave("alice")
		env:join("alice")   -- inventaire neuf dans le mock : seul un second don ferait remonter le compte
		T.eq(env:count("alice", "minerland_quests:book"), 0, "pas redonné à la reconnexion")
	end)

	T.it("depuis Unified Inventory : bouton, page, et basculement vers le livre complet", function()
		local env = game()
		local p = env:join("alice")
		local found = false
		for _, b in ipairs(unified_inventory.buttons) do found = found or b.name == "minerland_quests" end
		T.ok(found, "bouton enregistré")
		unified_inventory.set_inventory_formspec(p, "minerland_quests")
		local fs = env.mock.inventory_formspecs.alice
		T.contains(fs, "Le Grand Livre des Quêtes de Minerland")
		T.contains(fs, "mlq_open_book", "bouton « ouvrir en grand »")
		env:fields("alice", "", { mlq_open_book = "x" })
		T.eq(env.mock.formspecs.alice.formname, BOOK, "le livre s'ouvre depuis la page")
	end)

	T.it("mode lite d'Unified Inventory : la page reste valide et plus petite", function()
		local env = game({ ui_lite = true })
		local p = env:join("alice")
		unified_inventory.set_inventory_formspec(p, "minerland_quests")
		local fs = env.mock.inventory_formspecs.alice
		T.ok(#fs > 200)
		T.eq(env.mock.formspecs.alice, nil)
	end)
end)

T.describe("navigation", function()
	T.it("accueil → partie → chapitre → fiche → retour, sans jamais valider de quête", function()
		local env = game()
		env:join("alice")
		local q = env.Q.quests["ch01.first_log"]
		env:chat("alice", "quetes")
		click(env, "alice", "mlq_part_fundamentals")
		T.contains(env.mock.formspecs.alice.fs, "Bienvenue à Minerland")
		click(env, "alice", "mlq_ch_ch01")
		T.contains(env.mock.formspecs.alice.fs, "Bûcheron du dimanche")
		click(env, "alice", "mlq_q_" .. q.index)
		T.contains(env.mock.formspecs.alice.fs, "Objectif")
		click(env, "alice", "mlq_q_" .. env.Q.quests["ch01.planks"].index)
		T.contains(env.mock.formspecs.alice.fs, "Prérequis", "fiche d'une quête à prérequis")
		click(env, "alice", "mlq_tree")
		click(env, "alice", "mlq_back")
		click(env, "alice", "mlq_home")
		T.contains(env.mock.formspecs.alice.fs, "Progression", "retour à l'accueil")
		T.eq(env:state("alice", "ch01.first_log"), "available", "naviguer ne valide rien")
	end)

	T.it("chapitre précédent et suivant, bornes comprises", function()
		local env = game()
		env:join("alice")
		click(env, "alice", "mlq_ch_ch01")
		click(env, "alice", "mlq_prev")
		T.contains(env.mock.formspecs.alice.fs, "Bienvenue à Minerland", "pas de chapitre avant le premier")
		click(env, "alice", "mlq_next")
		T.contains(env.mock.formspecs.alice.fs, "Mon premier chez-moi")
		click(env, "alice", "mlq_ch_ch25")
		click(env, "alice", "mlq_next")
		T.contains(env.mock.formspecs.alice.fs, "Monsieur ou Madame le Maire", "pas de chapitre après le dernier")
	end)

	T.it("la vue est conservée entre le livre et la page Unified Inventory", function()
		local env = game()
		local p = env:join("alice")
		click(env, "alice", "mlq_ch_ch04")
		unified_inventory.set_inventory_formspec(p, "minerland_quests")
		T.contains(env.mock.inventory_formspecs.alice, "Les trésors de la terre")
	end)
end)

T.describe("sécurité des champs de formulaire", function()
	T.it("aucun champ forgé ne valide une quête, n'attribue une récompense ni ne plante le serveur", function()
		local env = game()
		env:join("alice")
		click(env, "alice", "mlq_ch_ch01")
		local forged = {
			"mlq_q_999999", "mlq_q_-1", "mlq_q_0", "mlq_q_1e9", "mlq_q_abc", "mlq_complete_ch01.first_log",
			"mlq_done_ch01.first_log", "mlq_grant", "mlq_reward_ch01.first_log", "mlq_ch_ch99", "mlq_ch_../../x",
			"mlq_part_../x", "mlq_part_nope", "mlq_prev_9", "mlq_admin", "mlq_deliver_all", "mlq_",
			"mlq_q_" .. string.rep("9", 400), "mlq_ch_ch01\n", "\0mlq_home",
		}
		for _, f in ipairs(forged) do
			T.ok(pcall(env.fields, env, "alice", BOOK, { [f] = "x" }), "champ forgé toléré : " .. f:sub(1, 30))
		end
		local d = env.Q.progress.global_stats("alice")
		T.eq(d, 0, "aucune quête validée par des champs forgés")
		T.eq(env.Q.rewards.pending_count("alice"), 0)
		for _, v in ipairs({ true, 42, {}, "x" }) do   -- valeurs de champ de types inattendus
			T.ok(pcall(env.fields, env, "alice", BOOK, { mlq_home = v, mlq_scroll = v, mlq_tree_sb = v }))
		end
	end)

	T.it("une fiche ne s'ouvre que pour une quête du chapitre affiché (index d'un autre chapitre refusé)", function()
		local env = game()
		env:join("alice")
		click(env, "alice", "mlq_ch_ch01")
		local other = env.Q.quests["ch04.coal"]
		click(env, "alice", "mlq_q_" .. other.index)
		T.not_contains(env.mock.formspecs.alice.fs, "Gueules noires", "fiche d'un autre chapitre refusée")
	end)

	T.it("les formulaires d'un autre mod sont ignorés (retour faux pour laisser la main aux autres)", function()
		local env = game()
		env:join("alice")
		T.eq(env:fields("alice", "autre_mod:form", { mlq_home = "x", quit = "true" }), false)
	end)

	T.it("la fermeture du livre arrête les rafraîchissements en direct", function()
		local env = game()
		env:join("alice")
		env:chat("alice", "quetes")
		T.ok(env.Q.book.is_open("alice"))
		env:fields("alice", BOOK, { quit = "true" })
		T.ok(not env.Q.book.is_open("alice"))
		env.mock.formspecs.alice = nil
		env:complete("alice", "ch01.first_log")
		env:step(2)
		T.eq(env.mock.formspecs.alice, nil, "plus de formulaire rouvert tout seul")
	end)
end)

T.describe("contenu affiché", function()
	T.it("prérequis (fait / à faire), coches vertes et état de la récompense", function()
		local env = game()
		env:join("alice")
		click(env, "alice", "mlq_ch_ch01")
		local planks = env.Q.quests["ch01.planks"]
		click(env, "alice", "mlq_q_" .. planks.index)
		local fs = env.mock.formspecs.alice.fs
		T.contains(fs, "(à faire)", "prérequis non fait")
		T.contains(fs, "mlq_frame_locked.png")
		local function badges(text) return select(2, text:gsub("mlq_badge_done%.png", "")) end
		local before = badges(env.Q.book.formspec("alice"))
		env:complete("alice", "ch01.first_log")
		env:step(1)
		click(env, "alice", "mlq_ch_ch01")
		T.ok(badges(env.Q.book.formspec("alice")) > before, "une coche verte de plus sur l'arbre")
		click(env, "alice", "mlq_q_" .. planks.index)
		fs = env.mock.formspecs.alice.fs
		T.contains(fs, "(fait)", "prérequis fait")
		T.contains(fs, "mlq_frame_available.png")
		T.contains(fs, "default:torch", "récompense affichée en objets")
	end)

	T.it("récompense en attente (inventaire plein) clairement indiquée sur la fiche", function()
		local env = game()
		env:join("alice")
		env:fill_inventory("alice", "default:cobble")
		env:complete("alice", "ch01.first_log")
		click(env, "alice", "mlq_ch_ch01")
		click(env, "alice", "mlq_q_" .. env.Q.quests["ch01.first_log"].index)
		local fs = env.mock.formspecs.alice.fs
		T.contains(fs, "en attente", "état réel de livraison")
		T.contains(fs, "mlq_deliver", "bouton pour relancer la livraison")
	end)

	T.it("quête indisponible : cadre rouge, raison affichée, quêtes suivantes non bloquées", function()
		local env = game({ mods = { "default", "farming", "unified_inventory" } })   -- moreores absent
		env:join("alice")
		click(env, "alice", "mlq_ch_ch04")
		local fs = env.mock.formspecs.alice.fs
		T.contains(fs, "mlq_frame_unavailable.png")
		click(env, "alice", "mlq_q_" .. env.Q.quests["ch04.silver"].index)
		T.contains(env.mock.formspecs.alice.fs, "moreores", "raison : mod absent")
		T.eq(env:state("alice", "ch04.silver"), "unavailable")
	end)

	T.it("grand arbre : défilement horizontal, barre de défilement, position bornée et mémorisée", function()
		local env = game({ before_finalize = function(Q)
			Q.register_chapter({ id = "ch26", part = "building", title = "Chapitre de test", intro = "Un très grand arbre." })
			local prev
			for i = 1, 14 do
				local id = ("ch26.t_%02d"):format(i)
				Q.register_quest({ id = id, title = "Étape " .. i, requires = prev,
					trigger = { type = "dig", items = "default:stone" } })
				prev = id
			end
		end, items = { { "default:stone", "node" } } })
		env:join("alice")
		local w, _, L = env.Q.views.tree_size("ch26")
		T.eq(L.cols, 14)
		T.ok(w > 20, "plus large que le livre")
		click(env, "alice", "mlq_ch_ch26")
		local fs = env.mock.formspecs.alice.fs
		T.contains(fs, "scroll_container[", "conteneur défilant")
		T.contains(fs, "scrollbar[", "barre de défilement")
		T.contains(fs, "Étape 14", "dernier nœud présent dans le conteneur")
		env:fields("alice", BOOK, { mlq_tree_sb = "CHG:12" })
		T.eq(env.Q.views.state("alice").scroll, 12)
		env:fields("alice", BOOK, { mlq_tree_sb = "CHG:-50" })
		T.eq(env.Q.views.state("alice").scroll, 0, "jamais négatif")
	end)

	T.it("échappement : crochets, points-virgules, virgules, barres obliques et couleurs restent inertes", function()
		local nasty = "Clé ];[a,b] \\ ^ #ff0000 $ test"
		local env = game({ before_finalize = function(Q)
			Q.register_quest({ id = "ch06.t_nasty", title = nasty, description = nasty, hint = nasty,
				trigger = { type = "dig", items = "default:stone" }, reward = { title = nasty } })
		end, items = { { "default:stone", "node" } } })
		env:join("alice")
		click(env, "alice", "mlq_ch_ch06")
		click(env, "alice", "mlq_q_" .. env.Q.quests["ch06.t_nasty"].index)
		local fs = env.mock.formspecs.alice.fs
		T.contains(fs, env.core.formspec_escape(nasty), "texte injecté échappé en entier")
		T.not_contains(fs, "Clé ];[a,b]", "séquence brute interdite")
		T.not_contains(fs, "b] \\ ^", "barre oblique non échappée")
	end)
end)

T.describe("rafraîchissement en direct", function()
	T.it("une quête terminée met à jour le livre ouvert", function()
		local env = game()
		env:join("alice")
		click(env, "alice", "mlq_ch_ch01")
		env:chat("alice", "quetes")
		local before = env.mock.formspecs.alice.fs
		env:complete("alice", "ch01.first_log")
		env:step(1)
		T.ok(env.mock.formspecs.alice.fs ~= before, "formulaire réaffiché")
		T.contains(env.mock.formspecs.alice.fs, "mlq_badge_done.png")
	end)

	T.it("notification de réussite : bandeau, message de chat et fin de chapitre", function()
		local env = game()
		env:join("alice")
		env:complete("alice", "ch01.first_log")
		T.contains(env:chat_log("alice"), "Bûcheron du dimanche")
		local hud = 0
		for _ in pairs(env:player("alice").huds) do hud = hud + 1 end
		T.ok(hud >= 3, "bandeau affiché")
		env:step(6)
		hud = 0
		for _ in pairs(env:player("alice").huds) do hud = hud + 1 end
		T.eq(hud, 0, "bandeau retiré au bout de 5 s")
		for _, q in ipairs(env.Q.get_chapter_quests("ch01")) do
			if env:state("alice", q.id) ~= "done" then env:complete_with_requirements("alice", q.id) end
		end
		T.contains(env:chat_log("alice"), "Chapitre terminé")
	end)
end)
