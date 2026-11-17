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

		local q = Q.get_quest("ch01.first_log")
		if phase == 1 then
			check(Q.progress.state(name, q) == "available", "ch01.first_log disponible au départ")
			Q.progress.complete(name, q, "test d'intégration")
			check(Q.progress.state(name, q) == "done", "ch01.first_log terminée")
			check(Q.rewards.pending_count(name) == 1, "récompense en attente (joueur hors ligne)")
			storage:set_string("phase", "1")
		else
			check(Q.progress.state(name, q) == "done", "progression conservée après redémarrage")
			check(Q.rewards.pending_count(name) == 1, "file de livraison conservée après redémarrage")
			check(Q.rewards.grant(name, q) == false, "pas de seconde attribution après redémarrage")
			storage:set_string("phase", "")
		end
		core.log("action", ("[mlq_itest] FIN phase %d : %d échec(s)"):format(phase, failures))
		core.request_shutdown("fin du test d'intégration", false, 0)
	end)
end)
