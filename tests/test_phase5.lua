-- Tests de la phase 5 : catalogue des 25 chapitres et adaptateurs des mods tiers (monter à bord, animaux, boutiques,
-- deltaplane, portail du Nether, œufs de dinosaure, zones protégées). Les API des mods tiers sont simulées au plus
-- près de leur code audité (docs/audit/*.md).
local T = ...

-- API publiques simulées (smartshop, hangglider, areas) : à poser AVANT le chargement du mod.
local function stub_apis()
	local h = { gliding = {}, adds = {} }
	_G.smartshop = { api = { register_on_purchase = function(cb) h.purchase = cb end } }
	_G.hangglider = { is_gliding = function(player) return h.gliding[player:get_player_name()] end }
	_G.areas = { registerOnAdd = function(_, f) h.adds[#h.adds + 1] = f end }
	return h
end
local function clear_apis()
	_G.smartshop, _G.hangglider, _G.areas = nil, nil, nil
end

local function all_env(extra)
	local opts = { all_mods = true, all_items = true }
	for k, v in pairs(extra or {}) do opts[k] = v end
	return T.env(opts)
end

-- Objet simulé auquel un joueur est attaché (get_luaentity, get_attach), avec sa table d'entité.
local function object(entity_name, parent, fields)
	local ent = { name = entity_name }
	for k, v in pairs(fields or {}) do ent[k] = v end
	return { ent = ent, get_luaentity = function() return ent end, get_attach = function() return parent end }
end

T.describe("catalogue des 25 chapitres", function()
	T.it("chaque chapitre a une introduction, au moins cinq quêtes et une quête finale", function()
		local env = all_env()
		local Q = env.Q
		T.eq(#Q.chapter_list, 25)
		local total = 0
		for _, c in ipairs(Q.chapter_list) do
			local qs = Q.get_chapter_quests(c.id)
			T.ok(#qs >= 5, c.id .. " : au moins 5 quêtes (" .. #qs .. ")")
			local final = false
			for _, q in ipairs(qs) do final = final or q.final end
			T.ok(final, c.id .. " : quête finale")
			T.ok(type(c.intro) == "string" and c.intro ~= "", c.id .. " : introduction")
			total = total + #qs
		end
		T.ok(total >= 100, "au moins 100 quêtes (" .. total .. ")")
	end)

	T.it("toute clé custom appartient à une intégration déclarée ; tout est jouable si les mods sont là", function()
		stub_apis()
		local env = all_env()
		local Q = env.Q
		for _, q in ipairs(Q.quest_list) do
			if q.trigger.type == "custom" then
				local prefix = q.trigger.key:match("^([^:]+):")
				local info = Q.compat.integrations[prefix]
				T.ok(info, q.id .. " : intégration « " .. tostring(prefix) .. " » déclarée")
				local listed = false
				for _, k in ipairs(info and info.keys or {}) do listed = listed or k == q.trigger.key end
				T.ok(listed, q.id .. " : clé " .. q.trigger.key .. " annoncée par l'intégration")
			end
			T.ok(not q.unavailable, q.id .. " : jouable (" .. tostring(q.unavailable) .. ")")
			T.ok(#q.reward.items > 0, q.id .. " : récompense en objets")
		end
		clear_apis()
	end)
end)

T.describe("intégration rides (monter à bord)", function()
	T.it("cheval : rides:horse valide « En selle ! », une seule émission tant qu'on reste en selle", function()
		local env = all_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch06.saddle_up")
		T.eq(env:state("alice", "ch06.horse_ride"), "available")
		p.attached = object("mob_horse:horse")
		env:step(2)
		T.eq(env:state("alice", "ch06.horse_ride"), "done")
	end)

	T.it("avion : on remonte du siège airutils à l'appareil ; un siège seul ne compte pas", function()
		stub_apis()
		local env = all_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch13.first_plane")
		env:complete_with_requirements("alice", "ch13.first_glide")
		T.eq(env:state("alice", "ch13.board_plane"), "available")
		p.attached = object("airutils:seat_base")
		env:step(2)
		T.eq(env:state("alice", "ch13.board_plane"), "available", "siège non relié à un avion")
		p.attached = object("airutils:seat_base", object("ju52:ju52"))
		env:step(2)
		T.eq(env:state("alice", "ch13.board_plane"), "done")
		clear_apis()
	end)

	T.it("voiture : seul le conducteur compte (passager puis volant)", function()
		local env = all_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch10.first_car")
		T.eq(env:state("alice", "ch10.road_trip"), "available")
		local car = object("automobiles_roadster:roadster", nil, { driver_name = "bob" })
		p.attached = object("automobiles_lib:pivot_mesh", car)
		env:step(2)
		T.eq(env:state("alice", "ch10.road_trip"), "available", "passager")
		car.ent.driver_name = "alice"
		env:step(2)
		T.eq(env:state("alice", "ch10.road_trip"), "done")
	end)

	T.it("entité inconnue, faux joueur ou joueur à pied : aucune émission", function()
		local env = all_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch10.first_bike")
		p.attached = object("homedecor_seating:seat")
		env:step(2)
		p.attached = nil
		env:step(2)
		T.eq(env:state("alice", "ch10.bike_ride"), "available")
		local fake = env:fake_player("alice")
		fake.attached = object("bike:bike")
		T.eq(env.Q.events.real_player(fake), nil, "faux joueur jamais compté")
		p.attached = object("bike:bike")
		env:step(2)
		T.eq(env:state("alice", "ch10.bike_ride"), "done")
	end)
end)

T.describe("intégration mobs (apprivoiser, capturer)", function()
	local function mob_env()
		return all_env({ before_finalize = function(_, core)
			core.register_entity("mobs_animal:cow", { _cmi_is_mob = true, on_rightclick = function(self, clicker)
				local item = clicker:get_wielded_item():get_name()
				if item == "farming:wheat" then
					self.food = (self.food or 0) + 1
					if self.food >= 2 then
						self.tamed, self.owner = true, clicker:get_player_name()
					end
					return "nourrie"
				elseif item == "mobs:net" and self.tamed and self.owner == clicker:get_player_name() then
					self.object.removed = true
					return "capturée"
				end
				return "rien"
			end })
			core.register_entity("mobs_npc:npc", { _cmi_is_mob = true, on_rightclick = function(self, clicker)
				self.tamed, self.owner = true, clicker:get_player_name()
			end })
		end })
	end
	local function spawn(env, name)
		local obj = { removed = false }
		function obj:get_pos() if self.removed then return nil end return { x = 0, y = 0, z = 0 } end
		return setmetatable({ object = obj }, { __index = env.core.registered_entities[name] })
	end

	T.it("apprivoiser émet mobs:tame au bon repas ; la valeur de retour du mod est conservée", function()
		local env = mob_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch03.wheat")
		T.eq(env:state("alice", "ch06.trusted_friend"), "available")
		local cow = spawn(env, "mobs_animal:cow")
		p.wielded = "farming:wheat"
		T.eq(cow:on_rightclick(p), "nourrie")
		T.eq(env:state("alice", "ch06.trusted_friend"), "available", "un repas ne suffit pas")
		cow:on_rightclick(p)
		T.eq(env:state("alice", "ch06.trusted_friend"), "done")
	end)

	T.it("capturer au filet un animal à soi émet mobs:capture", function()
		local env = mob_env()
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch03.wheat")
		env:complete_with_requirements("alice", "ch06.net_maker")
		local cow = spawn(env, "mobs_animal:cow")
		p.wielded = "farming:wheat"
		cow:on_rightclick(p) cow:on_rightclick(p)
		T.eq(env:state("alice", "ch06.in_the_net"), "available")
		p.wielded = "mobs:net"
		T.eq(cow:on_rightclick(p), "capturée")
		T.eq(env:state("alice", "ch06.in_the_net"), "done")
	end)

	T.it("PNJ exclus ; l'animal d'un autre joueur ne s'apprivoise pas pour soi", function()
		local env = mob_env()
		local p = env:join("alice")
		local bob = env:join("bob")
		env:complete_with_requirements("alice", "ch03.wheat")
		spawn(env, "mobs_npc:npc"):on_rightclick(p)
		T.eq(env:state("alice", "ch06.trusted_friend"), "available", "PNJ ignoré")
		local cow = spawn(env, "mobs_animal:cow")
		bob.wielded, p.wielded = "farming:wheat", "farming:wheat"
		cow:on_rightclick(bob) cow:on_rightclick(bob)
		cow:on_rightclick(p)
		T.eq(env:state("alice", "ch06.trusted_friend"), "available", "déjà apprivoisée par bob")
	end)
end)

T.describe("intégration smartshop (ventes)", function()
	T.it("un achat chez un autre joueur valide l'achat, et la vente pour le propriétaire connecté", function()
		local h = stub_apis()
		local env = all_env()
		local alice, bob = env:join("alice"), env:join("bob")
		env:complete_with_requirements("alice", "ch09.small_change")
		env:complete_with_requirements("bob", "ch09.shop_opening")
		T.ok(h.purchase, "callback enregistré auprès de smartshop.api")
		local shop = { get_owner = function() return "bob" end,
			get_pay_stack = function() return ItemStack("currency:minegeld_5") end }
		h.purchase(alice, shop, 1)
		T.eq(env:state("alice", "ch09.first_purchase"), "done")
		T.eq(env:state("bob", "ch09.first_sale"), "done")
		local _ = bob
		clear_apis()
	end)

	T.it("acheter dans sa propre boutique ou un article gratuit ne compte pas", function()
		local h = stub_apis()
		local env = all_env()
		local alice = env:join("alice")
		env:complete_with_requirements("alice", "ch09.small_change")
		h.purchase(alice, { get_owner = function() return "alice" end,
			get_pay_stack = function() return ItemStack("currency:minegeld_5") end }, 1)
		h.purchase(alice, { get_owner = function() return "bob" end,
			get_pay_stack = function() return ItemStack("") end }, 2)
		T.eq(env:state("alice", "ch09.first_purchase"), "available")
		clear_apis()
	end)
end)

T.describe("intégrations deltaplane, Nether, paleotest et areas", function()
	T.it("deltaplane : un envol lu par hangglider.is_gliding valide « Le grand saut »", function()
		local h = stub_apis()
		local env = all_env()
		env:join("alice")
		env:complete_with_requirements("alice", "ch13.glider_craft")
		env:step(1)
		T.eq(env:state("alice", "ch13.first_glide"), "available")
		h.gliding.alice = true
		env:step(1)
		T.eq(env:state("alice", "ch13.first_glide"), "done")
		clear_apis()
	end)

	T.it("Nether : fragment consommé sur le cadre = portail allumé ; portail déjà allumé ignoré", function()
		local env = all_env({ items = { { "default:mese_crystal_fragment", "craft", {
			on_place = function(stack, _, pt)   -- simule nether/portal_api.lua:2167-2186
				local above = { x = pt.under.x, y = pt.under.y + 1, z = pt.under.z }
				if core.get_node(pt.under).name == "default:obsidian" and core.get_node(above).name ~= "nether:portal" then
					core.set_node(above, { name = "nether:portal" })
					stack:take_item()
				end
				return stack
			end } } } })
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch20.frame")
		env:complete_with_requirements("alice", "ch20.mese_fragments")
		T.eq(env:state("alice", "ch20.light_portal"), "available")
		local frag = env.core.registered_items["default:mese_crystal_fragment"]
		local lit = { x = 200, y = 0, z = 0 }
		env.core.set_node(lit, { name = "default:obsidian" })
		env.core.set_node({ x = 200, y = 1, z = 0 }, { name = "nether:portal" })
		local st = ItemStack("default:mese_crystal_fragment 3")
		frag.on_place(st, p, { type = "node", under = lit, above = lit })
		T.eq(st:get_count(), 3, "rien de consommé")
		T.eq(env:state("alice", "ch20.light_portal"), "available", "portail déjà allumé")
		local pos = { x = 300, y = 0, z = 0 }
		env.core.set_node(pos, { name = "default:obsidian" })
		local ret = frag.on_place(st, p, { type = "node", under = pos, above = pos })
		T.eq(ret:get_count(), 2, "valeur de retour du mod conservée")
		T.eq(env:state("alice", "ch20.light_portal"), "done")
	end)

	T.it("paleotest : poser un œuf (consommé) émet paleotest:egg_placed", function()
		local env = all_env({ items = { { "paleotest:egg_triceratops", "craft", {
			on_place = function(stack) stack:take_item() return stack end } } } })
		local p = env:join("alice")
		env:complete_with_requirements("alice", "ch23.dna_cultivator")
		T.eq(env:state("alice", "ch23.dino_egg"), "available")
		local egg = env.core.registered_items["paleotest:egg_triceratops"]
		local ret = egg.on_place(ItemStack("paleotest:egg_triceratops 2"), p, { type = "node",
			under = { x = 0, y = 0, z = 0 }, above = { x = 0, y = 1, z = 0 } })
		T.eq(ret:get_count(), 1)
		T.eq(env:state("alice", "ch23.dino_egg"), "done")
	end)

	T.it("areas : /protect au nom du joueur valide « Borner la commune » ; une sous-zone ne compte pas", function()
		local h = stub_apis()
		local env = all_env()
		env:join("alice")
		env:complete_with_requirements("alice", "ch25.charter_seal")
		T.eq(env:state("alice", "ch25.protect_town"), "available")
		T.eq(#h.adds, 1, "callback enregistré par areas:registerOnAdd")
		h.adds[1](7, { owner = "alice", parent = 3, name = "jardin" })
		T.eq(env:state("alice", "ch25.protect_town"), "available", "sous-zone")
		h.adds[1](8, { owner = "alice", name = "Ma commune" })
		T.eq(env:state("alice", "ch25.protect_town"), "done")
		clear_apis()
	end)
end)

T.describe("affichage du catalogue complet", function()
	T.it("les 25 chapitres et les fiches de toutes les quêtes s'affichent en français et en anglais", function()
		local env = all_env({ ui = true })
		env:join("fr_player", nil, "fr")
		env:join("en_player", nil, "en")
		local shown = 0
		for _, name in ipairs({ "fr_player", "en_player" }) do
			for _, c in ipairs(env.Q.chapter_list) do
				env:fields(name, "minerland_quests:book", { ["mlq_ch_" .. c.id] = "x" })
				local fs = env.Q.book.formspec(name)
				T.ok(#fs > 200, c.id .. " : vue du chapitre")
				for _, q in ipairs(env.Q.get_chapter_quests(c.id)) do
					env:fields(name, "minerland_quests:book", { ["mlq_q_" .. q.index] = "x" })
					local detail = env.Q.book.formspec(name)
					T.not_contains(detail, "\27(T@", q.id .. " : aucun balisage de traduction")
					local desc = env.core.formspec_escape(env.Q.i18n.tr(name, q.description))
					T.contains(detail, desc:sub(1, 20), q.id .. " : description affichée (texte échappé)")
					shown = shown + 1
				end
			end
		end
		T.eq(shown, 2 * #env.Q.quest_list)
	end)
end)
