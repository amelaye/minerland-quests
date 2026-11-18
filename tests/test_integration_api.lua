-- Tests de l'API des intégrations (core/compat.lua) et du correctif « une action = quêtes déjà disponibles ».
local T = ...

T.describe("progression", function()
	T.it("une action ne compte pas pour la quête qu'elle vient de débloquer", function()
		local env = T.env({ mods = { "default" }, all_items = true,
			items = { { "test:ore", "node" } },
			before_finalize = function(Q)
				Q.register_quest({ id = "ch06.first", title = "Premier", trigger = { type = "dig", items = "test:ore" } })
				Q.register_quest({ id = "ch06.second", title = "Second", requires = "ch06.first",
					trigger = { type = "dig", items = "test:ore" } })
			end })
		env:join("alice")
		env:dig("alice", "test:ore")
		T.eq(env:state("alice", "ch06.first"), "done")
		T.eq(env:state("alice", "ch06.second"), "available", "débloquée mais pas encore faite")
		T.eq(env.Q.progress.count("alice", env.Q.quests["ch06.second"]), 0)
		env:dig("alice", "test:ore")
		T.eq(env:state("alice", "ch06.second"), "done")
	end)
end)

T.describe("compat.wrap_callback", function()
	local function make_env(on_use)
		return T.env({ mods = { "default" }, items = { { "test:tool", "tool", { on_use = on_use } } } })
	end

	T.it("appelle l'original d'abord et renvoie toutes ses valeurs (nil compris)", function()
		local order = {}
		local env = make_env(function(a, b) order[#order + 1] = "orig" return a, nil, b end)
		local C = env.Q.compat
		T.ok(C.wrap_callback("test:tool", "on_use", {
			before = function() order[#order + 1] = "before" return 42 end,
			after = function(st, res) order[#order + 1] = "after:" .. st .. ":" .. res.n end,
		}))
		local r1, r2, r3 = env.core.registered_items["test:tool"].on_use("x", "y")
		T.eq(table.concat(order, ","), "before,orig,after:42:3")
		T.eq(r1, "x") T.eq(r2, nil) T.eq(r3, "y")
	end)

	T.it("une erreur de l'intégration ne casse pas le callback du mod tiers", function()
		local env = make_env(function() return "ok" end)
		env.Q.compat.wrap_callback("test:tool", "on_use", { after = function() error("boum") end })
		T.eq(env.core.registered_items["test:tool"].on_use(), "ok")
		local logged = false
		for _, l in ipairs(env.mock.log) do if l.level == "error" and l.msg:find("boum") then logged = true end end
		T.ok(logged, "erreur journalisée")
	end)

	T.it("n'enveloppe qu'une fois, et seulement un objet existant", function()
		local calls = 0
		local env = make_env(function() return true end)
		local C = env.Q.compat
		local hooks = { after = function() calls = calls + 1 end }
		T.ok(C.wrap_callback("test:tool", "on_use", hooks))
		T.ok(not C.wrap_callback("test:tool", "on_use", hooks), "second habillage refusé")
		T.ok(not C.wrap_callback("test:absent", "on_use", hooks))
		T.ok(not C.wrap_callback("test:tool", "on_place", hooks), "pas de callback ni de repli")
		env.core.registered_items["test:tool"].on_use()
		T.eq(calls, 1)
	end)
end)

T.describe("compat.register_poll", function()
	T.it("passe sur chaque joueur connecté à l'intervalle demandé et isole les erreurs", function()
		local env = T.env({ mods = { "default" } })
		local seen = {}
		env.Q.compat.register_poll("test", 2, function(_, name) seen[#seen + 1] = name end)
		env.Q.compat.register_poll("bad", 1, function() error("sonde cassée") end)
		env:join("alice") env:join("bob")
		env:step(1)
		T.eq(#seen, 0, "pas avant 2 s")
		env:step(1)
		T.eq(#seen, 2)
	end)
end)

T.describe("intégration farming", function()
	local function farming_env()
		return T.env({ mods = { "default", "farming" }, all_items = true,
			items = {
				{ "default:dirt", "node", { groups = { soil = 1 } } },
				{ "farming:soil", "node", { groups = { soil = 2 } } },
				{ "farming:wheat_1", "node", {} },
				{ "farming:hoe_wood", "tool", { on_use = function(stack, user, pt)
					if pt and pt.type == "node" then core.set_node(pt.under, { name = "farming:soil" }) end
					return stack
				end } },
				{ "farming:seed_wheat", "craft", { groups = { seed = 1 }, on_place = function(stack, placer, pt)
					core.set_node(pt.above, { name = "farming:wheat_1" })
					return stack
				end } },
			} })
	end

	T.it("labourer avec une houe émet farming:till pour un vrai joueur seulement", function()
		local env = farming_env()
		local Q = env.Q
		local p = env:join("alice")
		local fake = env:fake_player("alice")
		env:complete_with_requirements("alice", "ch03.hoe")
		T.eq(env:state("alice", "ch03.till"), "available")
		local pos = { x = 50, y = 0, z = 0 }
		env.core.set_node(pos, { name = "default:dirt" })
		local hoe = env.core.registered_items["farming:hoe_wood"]
		hoe.on_use("farming:hoe_wood", fake, { type = "node", under = pos, above = pos })
		T.eq(env:state("alice", "ch03.till"), "available", "faux joueur ignoré")
		env.core.set_node(pos, { name = "default:dirt" })
		local ret = hoe.on_use("farming:hoe_wood", p, { type = "node", under = pos, above = pos })
		T.eq(ret, "farming:hoe_wood", "valeur de retour de l'original conservée")
		T.eq(env:state("alice", "ch03.till"), "done")
		T.ok(Q.compat.integrations.farming, "intégration déclarée")
	end)

	T.it("semer émet farming:sow ; un clic sans effet n'émet rien", function()
		local env = farming_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch03.till")
		T.eq(env:state("alice", "ch03.sow"), "available")
		local seed = env.core.registered_items["farming:seed_wheat"]
		local pos = { x = 60, y = 1, z = 0 }
		env.core.set_node(pos, { name = "farming:wheat_1" })   -- déjà semé : aucun changement
		seed.on_place("farming:seed_wheat", p, { type = "node", under = { x = 60, y = 0, z = 0 }, above = pos })
		T.eq(env:state("alice", "ch03.sow"), "available")
		env.core.set_node(pos, { name = "air" })
		seed.on_place("farming:seed_wheat", p, { type = "node", under = { x = 60, y = 0, z = 0 }, above = pos })
		T.eq(env:state("alice", "ch03.sow"), "done")
	end)
end)

T.describe("intégration rings", function()
	T.it("activation, vol puis autre pouvoir, détectés par lecture lente de rings.users", function()
		local env = T.env({ mods = { "default", "goops_rings", "moreores", "glooptest", "3d_armor" }, all_items = true })
		_G.rings = { users = {} }
		env:join("alice")
		for _, qid in ipairs({ "ch05.first_ring", "ch05.activation", "ch05.celestial" }) do
			env:complete_with_requirements("alice", qid)
		end
		env.Q.events.emit("alice", "custom", "rings:equip", 1)
		T.eq(env:state("alice", "ch05.equip"), "done")
		T.eq(env:state("alice", "ch05.activate"), "available")
		-- 1) un pouvoir quelconque : « activer » validé ; le vol n'est pas encore disponible au moment de l'action
		rings.users.alice = { flags = { status = 1 }, fx = { name = "Fire Resistance" } }
		env:step(2)
		T.eq(env:state("alice", "ch05.activate"), "done")
		T.eq(env:state("alice", "ch05.flight"), "available", "débloquée, pas validée par la même action")
		-- 2) même effet au passage suivant : aucune répétition
		env:step(2)
		T.eq(env:state("alice", "ch05.flight"), "available")
		-- 3) l'anneau céleste donne le vol
		rings.users.alice = { flags = { status = 1 }, fx = { name = "Flight Privilege" } }
		env:step(2)
		T.eq(env:state("alice", "ch05.flight"), "done")
		T.eq(env:state("alice", "ch05.other_power"), "available")
		-- 4) un autre pouvoir après le vol
		rings.users.alice = { flags = { status = 1 }, fx = { name = "Breath Hold" } }
		env:step(2)
		T.eq(env:state("alice", "ch05.other_power"), "done")
		_G.rings = nil
	end)

	T.it("aucune émission sans la table publique rings", function()
		local env = T.env({ mods = { "default", "goops_rings", "moreores", "glooptest", "3d_armor" }, all_items = true })
		_G.rings = nil
		env:join("alice")
		env:step(4)
		T.eq(env:state("alice", "ch05.activate"), "locked")
	end)
end)
