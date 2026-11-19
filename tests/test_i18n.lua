-- Tests du multilingue : langue source française, traduction anglaise (locale/minerland_quests.en.tr),
-- choix de la langue d'un joueur, traduction côté serveur des vues, du chat et des raisons d'indisponibilité.
local T = ...

local function book_env(extra)
	local opts = { mods = { "default", "farming", "unified_inventory" }, all_items = true, ui = true }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

local function open_chapter(env, name, ch, qid)
	env:fields(name, "minerland_quests:book", { ["mlq_ch_" .. ch] = "x" })
	if qid then
		env:fields(name, "minerland_quests:book", { ["mlq_q_" .. env.Q.quests[qid].index] = "x" })
	end
	return env.Q.book.formspec(name)
end

T.describe("langue d'un joueur", function()
	T.it("client français ou sans langue : français ; client anglais : anglais", function()
		local env = book_env()
		env:join("fr_player", nil, "fr")
		env:join("en_player", nil, "en")
		env:join("no_lang", nil, "")
		T.eq(env.Q.i18n.lang("fr_player"), "fr")
		T.eq(env.Q.i18n.lang("en_player"), "en")
		T.eq(env.Q.i18n.lang("no_lang"), "fr")
		T.ok(env.Q.i18n.available.en, "anglais détecté dans locale/")
	end)

	T.it("langue non traduite : langue de repli (anglais par défaut, réglable)", function()
		local env = book_env()
		env:join("de_player", nil, "de")
		env:join("en_gb", nil, "en_GB")
		T.eq(env.Q.i18n.lang("de_player"), "en")
		T.eq(env.Q.i18n.lang("en_gb"), "en", "variante régionale ramenée à la langue de base")
		local env2 = book_env({ settings = { ["minerland_quests.fallback_language"] = "fr" } })
		env2:join("de_player", nil, "de")
		T.eq(env2.Q.i18n.lang("de_player"), "fr")
	end)
end)

T.describe("vues traduites", function()
	T.it("accueil du livre : titre, couverture et parties dans la langue du joueur", function()
		local env = book_env()
		env:join("fr_player", nil, "fr")
		env:join("en_player", nil, "en")
		local fr = env.Q.book.formspec("fr_player")
		local en = env.Q.book.formspec("en_player")
		T.contains(fr, "Le Grand Livre des Quêtes de Minerland")
		T.contains(fr, "mlq_cover.png")
		T.contains(en, "The Great Book of Quests of Minerland")
		T.contains(en, "mlq_cover_en.png")
		T.contains(en, "The Fundamentals")
		T.not_contains(en, "Le Grand Livre des Quêtes")
		T.contains(en, "Close the book")
	end)

	T.it("aucun balisage de traduction ne reste dans les formspecs (traduction côté serveur)", function()
		local env = book_env()
		env:join("en_player", nil, "en")
		for _, fs in ipairs({ env.Q.book.formspec("en_player"), open_chapter(env, "en_player", "ch01", "ch01.first_log") }) do
			T.not_contains(fs, "\27(T@", "balisage de traduction")
			T.not_contains(fs, "\27F", "paramètre de traduction")
		end
	end)

	T.it("chapitre et fiche de quête en anglais, objectif et légende compris", function()
		local env = book_env()
		env:join("en_player", nil, "en")
		local fs = open_chapter(env, "en_player", "ch01", "ch01.first_log")
		T.contains(fs, "Chapter 1 — Welcome to Minerland")
		T.contains(fs, "Weekend Lumberjack")
		T.contains(fs, "Objective — Dig: ", "objectif généré dans la langue du joueur")
		T.contains(fs, "Tip: Dig a tree trunk (by hand or with an axe).")
		T.contains(fs, "Difficulty:")
		T.contains(fs, "Available")
		T.contains(fs, "Reward to earn")
		T.not_contains(fs, "Bûcheron du dimanche")
	end)

	T.it("page Unified Inventory traduite elle aussi", function()
		local env = book_env()
		local p = env:join("en_player", nil, "en")
		unified_inventory.set_inventory_formspec(p, "minerland_quests")
		local fs = env.mock.inventory_formspecs.en_player
		T.contains(fs, "Open full size")
		T.contains(fs, "The Great Book of Quests of Minerland")
	end)

	T.it("le titre tronqué sous un nœud reste un texte valide (troncature après traduction)", function()
		local env = book_env()
		env:join("en_player", nil, "en")
		local fs = open_chapter(env, "en_player", "ch01")
		T.contains(fs, "A Chest for My …", "titre anglais tronqué à 15 caractères")
	end)
end)

T.describe("messages et raisons traduits", function()
	T.it("message de chat et bandeau de réussite dans la langue du joueur", function()
		local env = book_env()
		env:join("en_player", nil, "en")
		env:complete("en_player", "ch01.first_log")
		local chat = env:chat_log("en_player")
		T.contains(chat, "[Great Book]")
		T.contains(chat, "Quest complete: ")
		T.contains(chat, "Weekend Lumberjack")
		local texts = {}
		for _, h in pairs(env:player("en_player").huds) do texts[#texts + 1] = h.text or "" end
		T.contains(table.concat(texts, "\n"), "Quest complete: Weekend Lumberjack")
	end)

	T.it("raison d'indisponibilité : français dans les journaux, traduite pour le joueur", function()
		local env = book_env()   -- moreores absent : ch04.silver indisponible
		env:join("en_player", nil, "en")
		local q = env.Q.quests["ch04.silver"]
		T.contains(q.unavailable, "n'est pas activé sur ce serveur")
		local fs = (function()
			env:complete_with_requirements("en_player", "ch04.iron")
			return open_chapter(env, "en_player", "ch04", "ch04.silver")
		end)()
		T.contains(fs, "Unavailable: The mod “moreores” is not enabled on this server.")
	end)

	T.it("date au format de la langue", function()
		local env = book_env()
		env:join("fr_player", nil, "fr")
		env:join("en_player", nil, "en")
		local t = os.time({ year = 2026, month = 11, day = 19, hour = 12 })
		T.eq(env.Q.i18n.date("fr_player", t), "19/11/2026")
		T.eq(env.Q.i18n.date("en_player", t), "11/19/2026")
	end)

	T.it("descriptions d'objets balisées pour une traduction par le client", function()
		local env = book_env()
		local desc = env.core.registered_items["minerland_quests:book"].description
		T.contains(env.core.get_translated_string("en", desc), "The Great Book of Quests of Minerland")
		T.contains(env.core.get_translated_string("fr", desc), "Le Grand Livre des Quêtes de Minerland")
	end)

	T.it("commande anglaise /quests en plus de /quetes et /livre", function()
		local env = book_env()
		T.ok(env.core.registered_chatcommands.quests)
		T.ok(env.core.registered_chatcommands.quetes)
		T.ok(env.core.registered_chatcommands.livre)
	end)
end)

T.describe("données de quêtes", function()
	T.it("« @ » est refusé dans un texte de quête (réservé aux paramètres de traduction)", function()
		T.raises(function()
			book_env({ before_finalize = function(Q)
				Q.register_quest({ id = "ch06.at", title = "Écris à moi@exemple", trigger = { type = "dig", items = "x:y" } })
			end })
		end, "réservé aux traductions")
	end)
end)
