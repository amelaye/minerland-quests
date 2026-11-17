-- Objets du mod : le Grand Livre et la Charte de fondation de ville.
local Q = minerland_quests
local U = Q.util

local function open_book(itemstack, user)
	local name = Q.events.real_player(user)
	if name then Q.book.show(name) end
	return itemstack
end

core.register_craftitem("minerland_quests:book", {
	description = "Le Grand Livre des Quêtes de Minerland\n"
		.. core.colorize("#e8b84a", "Clic pour l'ouvrir. Aussi accessible depuis l'inventaire (bouton Quêtes) ou /quetes."),
	short_description = "Le Grand Livre des Quêtes de Minerland",
	inventory_image = "mlq_book.png",
	wield_image = "mlq_book.png",
	stack_max = 1,
	groups = { book = 1, flammable = 3 },
	on_use = open_book,
	on_secondary_use = open_book,
	on_place = function(itemstack, placer, pointed_thing)
		-- Respecte le clic droit des nœuds interactifs (coffres, portes…) avant d'ouvrir le livre.
		if pointed_thing and pointed_thing.type == "node" then
			local node = core.get_node(pointed_thing.under)
			local def = core.registered_nodes[node.name]
			if def and def.on_rightclick and placer and not placer:get_player_control().sneak then
				return def.on_rightclick(pointed_thing.under, node, placer, itemstack, pointed_thing) or itemstack
			end
		end
		return open_book(itemstack, placer)
	end,
})

-- Recette : un livre et un morceau de charbon (« l'encre »). Peu coûteuse : le livre est un guide, pas un trésor.
if core.get_modpath("default") then
	core.register_craft({
		type = "shapeless",
		output = "minerland_quests:book",
		recipe = { "default:book", "default:coal_lump" },
	})
end

-- Le livre pour les nouveaux venus (une seule fois, à la toute première connexion).
core.register_on_newplayer(function(player)
	if not U.setting_bool("give_book_on_join", true) then return end
	local inv = player:get_inventory()
	local stack = ItemStack("minerland_quests:book")
	if inv:room_for_item("main", stack) then inv:add_item("main", stack) end
end)

-- Charte de fondation (chapitre 25) : bloc décoratif symbolique. Sa pose est détectée par le moteur (« place »).
-- Il ne prétend pas prouver qu'une ville existe : il marque l'intention et la cérémonie de fondation.
core.register_node("minerland_quests:city_charter", {
	description = "Charte de fondation de ville\n"
		.. core.colorize("#e8b84a", "Un parchemin scellé à exposer dans votre future mairie."),
	short_description = "Charte de fondation de ville",
	drawtype = "signlike",
	tiles = { "mlq_charter.png" },
	inventory_image = "mlq_charter.png",
	wield_image = "mlq_charter.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = { type = "wallmounted" },
	groups = { choppy = 3, oddly_breakable_by_hand = 3, attached_node = 1, flammable = 2 },
	stack_max = 1,
	after_place_node = function(pos, placer)
		local name = placer and placer:is_player() and placer:get_player_name() or ""
		local meta = core.get_meta(pos)
		meta:set_string("owner", name)
		meta:set_string("infotext", ("Charte de fondation — signée par %s le %s"):format(
			name ~= "" and name or "?", os.date("%d/%m/%Y")))
	end,
	sounds = core.get_modpath("default") and default.node_sound_wood_defaults() or nil,
})

if core.get_modpath("default") then
	core.register_craft({
		output = "minerland_quests:city_charter",
		recipe = {
			{ "default:paper", "default:gold_ingot", "default:paper" },
			{ "default:paper", "minerland_quests:book", "default:paper" },
			{ "default:paper", "default:paper", "default:paper" },
		},
		replacements = { { "minerland_quests:book", "minerland_quests:book" } },
	})
end
