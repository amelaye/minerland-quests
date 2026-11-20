-- Mod de vérification exécuté dans un VRAI serveur Luanti isolé (tests/integration/run.sh).
-- Phase 1 (premier démarrage) : vérifications + écriture d'une progression. Phase 2 : relecture après redémarrage.
local storage = core.get_mod_storage()
local phase = storage:get_string("phase") == "1" and 2 or 1
local failures = 0

local function check(ok, label)
	if ok then
		core.log("action", "[mlq_itest] OK " .. label)
	else
		failures = failures + 1
		core.log("error", "[mlq_itest] ÉCHEC " .. label)
	end
end

core.register_on_mods_loaded(function()
	core.after(1, function()
		local Q = minerland_quests
		check(type(Q) == "table" and Q.finalized == true, "phase " .. phase .. " : mod chargé et finalisé")
		check(#Q.chapter_list == 25, "25 chapitres enregistrés (" .. #Q.chapter_list .. ")")
		check(#Q.part_list == 6, "6 parties enregistrées")
		check(#Q.quest_list > 0, #Q.quest_list .. " quêtes enregistrées")
		check(core.registered_items["minerland_quests:book"] ~= nil, "objet livre enregistré")
		if core.get_modpath("unified_inventory") then
			local found = false
			for _, b in ipairs(unified_inventory.buttons) do
				if b.name == "minerland_quests" then found = true end
			end
			check(found, "bouton Unified Inventory enregistré")
			check(unified_inventory.pages["minerland_quests"] ~= nil, "page Unified Inventory enregistrée")
		end
		local name = "mlq_itest_player"
		local ok, fs = pcall(Q.book.formspec, name)
		check(ok and type(fs) == "string" and fs:find("formspec_version%[6%]") ~= nil, "formspec du livre (accueil)")
		local st = Q.views.state(name)
		st.view, st.chapter, st.part = "chapter", "ch01", "fundamentals"
		ok, fs = pcall(Q.book.formspec, name)
		check(ok and fs:find("mlq_q_", 1, true) ~= nil, "formspec du livre (arbre du chapitre 1)")

		-- Traductions : le VRAI moteur charge locale/minerland_quests.en.tr (le mock ne fait que l'imiter)
		local en_title = core.get_translated_string("en", Q.i18n.S("Le Grand Livre des Quêtes de Minerland"))
		check(en_title == "The Great Book of Quests of Minerland", "traduction anglaise chargée par le moteur : " .. en_title)
		local changed, total = 0, 0
		for _, qq in ipairs(Q.quest_list) do
			total = total + 1
			if core.get_translated_string("en", Q.i18n.S(qq.title)) ~= qq.title then changed = changed + 1 end
		end
		check(changed >= total * 0.9, ("titres de quêtes traduits en anglais : %d/%d"):format(changed, total))
		check(core.get_translated_string("en", Q.i18n.S("@1/@2/@3", "19", "11", "2026")) == "11/19/2026",
			"paramètres réordonnés (date anglaise)")

		-- Rendu de TOUTES les vues dans les deux langues (fiche de chaque quête comprise), sans client
		local real_lang = Q.i18n.lang
		for _, lang in ipairs({ "fr", "en" }) do
			Q.i18n.lang = function() return lang end
			local errors, markup, count = 0, 0, 0
			for _, c in ipairs(Q.chapter_list) do
				for _, qq in ipairs(Q.get_chapter_quests(c.id)) do
					local sv = Q.views.state(name)
					sv.view, sv.chapter, sv.part, sv.quest, sv.detail = "chapter", c.id, c.part, qq.id, true
					local ok2, out = pcall(Q.book.formspec, name)
					count = count + 1
					if not ok2 or type(out) ~= "string" then errors = errors + 1
					elseif out:find("\27(T@", 1, true) then markup = markup + 1 end
				end
			end
			check(errors == 0 and count == #Q.quest_list, ("fiches de toutes les quêtes (%s) : %d, %d erreur(s)")
				:format(lang, count, errors))
			check(markup == 0, "aucun balisage de traduction dans les formspecs (" .. lang .. ")")
		end
		Q.i18n.lang = real_lang
		Q.views.state(name).view = "home"

		-- Intégrations déclarées dans le vrai moteur (rides ne dépend que de l'API moteur)
		check(Q.compat.integrations.rides ~= nil, "intégration rides déclarée")

		-- Avec les mods du serveur (tests/integration/build_allmods.py, plus de 100 mods chargés) : chaque intégration
		-- dont le mod est présent se branche sur sa vraie API, et aucune quête n'est indisponible alors que ses mods
		-- sont là (ce serait un identifiant d'objet faux pour cette version du mod).
		if phase == 1 then
			local full = #core.get_modnames() > 100
			local playable, no_mod, wrong = 0, 0, {}
			for _, qq in ipairs(Q.quest_list) do
				local why = qq.unavailable
				if not why then playable = playable + 1
				elseif why:find("n'est pas activé", 1, true) then no_mod = no_mod + 1
				else wrong[#wrong + 1] = qq.id .. " : " .. why end
			end
			core.log("action", ("[mlq_itest] INFO %d mods chargés ; %d quêtes jouables, %d sans leur mod, %d autres "
				.. "indisponibles"):format(#core.get_modnames(), playable, no_mod, #wrong))
			for _, w in ipairs(wrong) do core.log("action", "[mlq_itest] INFO indisponible " .. w) end
			if full then
				local by_mod = { areas = "areas", draconis = "draconis", farming = "farming", hangglider = "hangglider",
					mobs = "mobs", nether = "nether", paleotest = "paleotest", rings = "goops_rings",
					smartshop = "smartshop" }
				for _, integ in ipairs({ "areas", "draconis", "farming", "hangglider", "mobs", "nether", "paleotest",
					"rings", "smartshop" }) do
					if core.get_modpath(by_mod[integ]) then
						check(Q.compat.integrations[integ] ~= nil, "intégration " .. integ .. " branchée sur le vrai mod")
					end
				end
				check(#wrong == 0, ("aucune quête indisponible alors que ses mods sont présents (%d)"):format(#wrong))
			end
		end

		local q = Q.get_quest("ch01.first_log")
		if phase == 1 then
			check(Q.progress.state(name, q) == "available", "ch01.first_log disponible au départ")
			Q.progress.complete(name, q, "test d'intégration")
			check(Q.progress.state(name, q) == "done", "ch01.first_log terminée")
			check(Q.rewards.pending_count(name) == 1, "récompense en attente (joueur hors ligne)")
			local chain = { "ch01.planks", "ch01.sticks", "ch01.first_tool" }
			check(Q.progress.state(name, "ch01.planks") == "available", "quête suivante débloquée")
			check(Q.progress.state(name, "ch01.first_tool") == "locked", "quête lointaine encore verrouillée")
			for _, id in ipairs(chain) do Q.progress.complete(name, Q.get_quest(id), "test d'intégration") end
			check(Q.progress.state(name, "ch01.first_tool") == "done", "chaîne de quêtes liées terminée")
			check(Q.progress.state(name, "ch01.chest_craft") == "available", "embranchement débloqué")
			check(Q.rewards.pending_count(name) == 4, "quatre récompenses en file (joueur hors ligne)")
			storage:set_string("phase", "1")
		else
			check(Q.progress.state(name, q) == "done", "progression conservée après redémarrage")
			check(Q.rewards.pending_count(name) == 4, "file de livraison conservée après redémarrage")
			check(Q.progress.state(name, "ch01.first_tool") == "done", "chaîne de quêtes conservée après redémarrage")
			check(Q.progress.state(name, "ch01.chest_craft") == "available", "embranchement conservé après redémarrage")
			check(Q.rewards.grant(name, q) == false, "pas de seconde attribution après redémarrage")
			storage:set_string("phase", "")
		end

		-- Sauvegardes de plusieurs joueurs (hors ligne), dont deux enregistrements anormaux qui ne doivent jamais être
		-- écrasés ni perdus. Les noms « mlq_itest_attendu_* » marquent les erreurs journalisées volontairement :
		-- run.sh les tolère, et elles seules.
		local FUTURE = '{"v":99,"done":{"ch01.first_log":5},"futur":true}'
		local BROKEN = "{pas du json"
		local FUT, BAD = "mlq_itest_attendu_futur", "mlq_itest_attendu_illisible"
		local backend = Q.storage.backend
		local function done(who, id) return Q.progress.state(who, Q.get_quest(id)) == "done" end
		if phase == 1 then
			Q.progress.complete("mlq_itest_a", q, "test d'intégration")
			for _, id in ipairs({ "ch01.first_log", "ch01.planks" }) do
				Q.progress.complete("mlq_itest_b", Q.get_quest(id), "test d'intégration")
			end
			backend:set_string("p:" .. FUT, FUTURE)
			backend:set_string("p:" .. BAD, BROKEN)
			check(done(FUT, "ch01.first_log") and Q.storage.is_readonly(FUT), "format plus récent lu en lecture seule")
			local okf = pcall(Q.book.formspec, FUT)
			check(okf, "livre affiché pour une sauvegarde d'un format plus récent")
			check(Q.rewards.grant(FUT, Q.get_quest("ch01.planks")) == false, "aucune attribution en lecture seule")
			check(Q.progress.state(BAD, q) == "available", "sauvegarde illisible : nouveau départ sans erreur Lua")
			check(backend:get_string("p_corrupt:" .. BAD) == BROKEN, "sauvegarde illisible copiée sous p_corrupt")
			Q.progress.complete(BAD, q, "test d'intégration")   -- le nouvel enregistrement remplace l'illisible
		else
			check(done("mlq_itest_a", "ch01.first_log") and not done("mlq_itest_a", "ch01.planks")
				and Q.rewards.pending_count("mlq_itest_a") == 1, "joueur A : progression et file retrouvées")
			check(done("mlq_itest_b", "ch01.planks") and Q.rewards.pending_count("mlq_itest_b") == 2,
				"joueur B : progression et file retrouvées")
			check(backend:get_string("p:" .. FUT) == FUTURE, "format plus récent intact après arrêt et redémarrage")
			check(done(BAD, "ch01.first_log"), "joueur à sauvegarde illisible : nouvelle progression conservée")
			check(backend:get_string("p_corrupt:" .. BAD) == BROKEN, "données illisibles d'origine toujours conservées")
			local known = "," .. table.concat(Q.storage.known_players(), ",") .. ","
			check(known:find(",mlq_itest_a,", 1, true) ~= nil and known:find(",mlq_itest_b,", 1, true) ~= nil,
				"une clé de sauvegarde par joueur")
		end
		core.log("action", ("[mlq_itest] FIN phase %d : %d échec(s)"):format(phase, failures))
		core.request_shutdown("fin du test d'intégration", false, 0)
	end)
end)
