-- Tests SIMULÉS des événements : minage, fabrication, pose, récolte, manger, et surtout les FAUSSES VALIDATIONS
-- (objet reçu d'un autre joueur, bloc posé puis recreusé, faux joueur, joueur hors ligne, créatif réglable).
local T = ...

local function game(extra)
	local opts = { mods = { "default", "farming" }, all_items = true }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

-- Une quête de chaque type, sur des cibles dédiées, toutes sans prérequis.
local function trio(Q)
	Q.register_quest({ id = "ch06.t_dig", title = "Miner", trigger = { type = "dig", items = "test:ore" } })
	Q.register_quest({ id = "ch06.t_craft", title = "Fabriquer", trigger = { type = "craft", items = "test:tool" } })
	Q.register_quest({ id = "ch06.t_place", title = "Poser", trigger = { type = "place", items = "test:block" } })
	Q.register_quest({ id = "ch06.t_eat", title = "Manger", trigger = { type = "eat", items = "test:snack" } })
end
local ITEMS = { { "test:ore", "node" }, { "test:tool", "craft" }, { "test:block", "node" }, { "test:snack", "craft" } }

local function trio_env(extra)
	local opts = { items = ITEMS, before_finalize = trio }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return game(opts)
end

T.describe("actions personnelles", function()
	T.it("miner, fabriquer, poser et manger valident leur quête respective", function()
		local env = trio_env()
		env:join("alice")
		env:dig("alice", "test:ore") T.eq(env:state("alice", "ch06.t_dig"), "done")
		env:craft("alice", "test:tool") T.eq(env:state("alice", "ch06.t_craft"), "done")
		env:place("alice", "test:block") T.eq(env:state("alice", "ch06.t_place"), "done")
		env:eat("alice", "test:snack") T.eq(env:state("alice", "ch06.t_eat"), "done")
	end)

	T.it("un événement ne valide pas une quête d'un autre type (miner ≠ fabriquer ≠ poser)", function()
		local env = trio_env()
		env:join("alice")
		env:craft("alice", "test:ore")
		env:place("alice", "test:ore")
		env:eat("alice", "test:ore")
		T.eq(env:state("alice", "ch06.t_dig"), "available", "fabriquer/poser/manger du minerai ≠ le miner")
		env:dig("alice", "test:tool") env:place("alice", "test:tool") env:eat("alice", "test:tool")
		T.eq(env:state("alice", "ch06.t_craft"), "available")
	end)

	T.it("récolter une plante : creuser le stade mûr compte, les stades jeunes non", function()
		local env = game()
		env:join("alice")
		env:complete_with_requirements("alice", "ch03.sow")
		local q = env.Q.get_quest("ch03.wheat")
		T.eq(env:state("alice", "ch03.wheat"), "available")
		env:dig("alice", "farming:wheat_3")
		T.eq(env.Q.progress.count("alice", q), 0, "blé encore vert")
		for _ = 1, 5 do env:dig("alice", "farming:wheat_8") end
		T.eq(env:state("alice", "ch03.wheat"), "done")
	end)
end)

T.describe("fausses validations", function()
	T.it("recevoir un objet d'un autre joueur ne valide ni fabrication, ni minage, ni pose", function()
		local env = trio_env()
		env:join("alice") env:join("bob")
		env:give("alice", "bob", "test:tool")
		env:give("alice", "bob", "test:ore 5")
		env:give("alice", "bob", "test:block")
		for _, id in ipairs({ "ch06.t_dig", "ch06.t_craft", "ch06.t_place" }) do
			T.eq(env:state("bob", id), "available", id .. " non validée par un cadeau")
			T.eq(env.Q.progress.count("bob", env.Q.get_quest(id)), 0)
		end
	end)

	T.it("un bloc-cible posé par un joueur puis recreusé ne valide pas la quête de minage", function()
		local env = trio_env()
		env:join("alice") env:join("bob")
		local pos = env:place("alice", "test:ore")
		env:dig("bob", "test:ore", pos)
		T.eq(env:state("bob", "ch06.t_dig"), "available", "bloc posé par alice")
		T.eq(env:state("alice", "ch06.t_dig"), "available", "alice non plus")
		env:dig("bob", "test:ore")   -- un bloc naturel (autre position)
		T.eq(env:state("bob", "ch06.t_dig"), "done")
	end)

	T.it("un bloc posé par une machine (faux joueur) n'est pas « naturel » non plus", function()
		local env = trio_env()
		env:join("alice")
		local machine = env:fake_player("alice")
		local pos = env:place(machine, "test:ore")
		env:dig("alice", "test:ore", pos)
		T.eq(env:state("alice", "ch06.t_dig"), "available")
	end)

	T.it("faux joueur (pipeworks, digtron, techage) : aucune action ne compte, même au nom d'un joueur réel", function()
		local env = trio_env()
		env:join("alice")
		local fake = env:fake_player("alice")
		env:dig(fake, "test:ore") env:craft(fake, "test:tool") env:place(fake, "test:block") env:eat(fake, "test:snack")
		for _, id in ipairs({ "ch06.t_dig", "ch06.t_craft", "ch06.t_place", "ch06.t_eat" }) do
			T.eq(env:state("alice", id), "available", id)
		end
		T.eq(env.Q.events.real_player(fake), nil)
		T.eq(env.Q.events.real_player(nil), nil)
		T.eq(env.Q.events.real_player("alice"), nil, "un nom n'est pas un joueur")
		T.eq(env.Q.events.real_player({}), nil)
	end)

	T.it("joueur hors ligne ou déconnecté : l'événement est ignoré", function()
		local env = trio_env()
		local p = env:join("alice")
		env:leave("alice")
		T.eq(env.Q.events.emit("alice", "dig", "test:ore", 1), 0)
		env:dig(p, "test:ore")
		env:join("alice")
		T.eq(env:state("alice", "ch06.t_dig"), "available")
	end)

	T.it("poser plusieurs fois au même endroit ne compte qu'une fois (positions distinctes)", function()
		local env = game({ items = { { "test:wire", "node" } }, before_finalize = function(Q)
			Q.register_quest({ id = "ch06.t_wire", title = "Fils",
				trigger = { type = "place", items = "test:wire", count = 3 } })
		end })
		env:join("alice")
		local pos = { x = 500, y = 0, z = 0 }
		for _ = 1, 4 do env:place("alice", "test:wire", pos) end
		T.eq(env.Q.progress.count("alice", env.Q.get_quest("ch06.t_wire")), 1, "même case répétée")
		env:place("alice", "test:wire") env:place("alice", "test:wire")
		T.eq(env:state("alice", "ch06.t_wire"), "done")
	end)

	T.it("le réglage count_creative=false ignore les joueurs en créatif", function()
		local env = trio_env({ settings = { ["minerland_quests.count_creative"] = false } })
		env:join("alice", { interact = true, creative = true })
		env:join("bob")
		env:dig("alice", "test:ore") env:dig("bob", "test:ore")
		T.eq(env:state("alice", "ch06.t_dig"), "available", "créatif non compté")
		T.eq(env:state("bob", "ch06.t_dig"), "done")
	end)

	T.it("une quête indisponible (mod absent) ne se valide jamais, même si l'objet est fabriqué", function()
		local env = game({ items = ITEMS, before_finalize = function(Q)
			Q.register_quest({ id = "ch06.t_mod", title = "Mod", trigger = { type = "craft", items = "test:tool" },
				mods = { "mod_absent" } })
		end })
		env:join("alice")
		env:craft("alice", "test:tool")
		T.eq(env:state("alice", "ch06.t_mod"), "unavailable")
		T.eq(env.Q.storage.get("alice").done["ch06.t_mod"], nil)
	end)
end)

T.describe("actions propres aux mods pris en charge", function()
	T.it("un événement custom n'existe que si l'intégration est déclarée", function()
		local env = game()   -- ni smartshop, ni hangglider, ni areas
		local q = env.Q.get_quest("ch09.first_purchase")
		T.ok(q.unavailable, "intégration smartshop absente")
		T.contains(q.unavailable, "smartshop")
		env:join("alice")
		T.eq(env.Q.events.emit("alice", "custom", "smartshop:purchase", 1), 0)
	end)

	T.it("émettre la clé custom d'une quête verrouillée ne la valide pas", function()
		local env = game({ mods = { "default", "farming", "goops_rings", "3d_armor", "moreores", "glooptest" } })
		env:join("alice")
		T.eq(env:state("alice", "ch05.activate"), "locked")
		env.Q.events.emit("alice", "custom", "rings:activate", 1)
		T.eq(env:state("alice", "ch05.activate"), "locked")
	end)
end)
