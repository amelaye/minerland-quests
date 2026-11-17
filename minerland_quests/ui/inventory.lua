-- Intégration Unified Inventory : bouton « Quêtes » et page dédiée utilisant les mêmes vues et le même état.
-- API vérifiée dans unified_inventory/api.lua (register_page, register_button) et internal.lua (get_formspec :
-- formspec_version[4], la page reçoit (player, perplayer_style) et retourne { formspec, draw_inventory, draw_item_list }).
local Q = minerland_quests
local V = Q.views
local P = {}
Q.inventory_page = P

P.PAGE = "minerland_quests"

if not core.get_modpath("unified_inventory") or not unified_inventory then
	function P.is_current() return false end
	function P.refresh() end
	return
end

local ui = unified_inventory

function P.is_current(name)
	return ui.current_page and ui.current_page[name] == P.PAGE
end

function P.refresh(name)
	local player = core.get_player_by_name(name)
	if player then ui.set_inventory_formspec(player, P.PAGE) end
end

-- Zone utile selon le mode d'affichage d'UI (boutons d'onglets en bas en mode complet, à droite en lite).
local function area(style)
	if style.is_lite_mode then
		return { x = 0.2, y = 0.25, w = (style.main_button_x or 10.5) - 0.4, h = (style.formh or 9.75) - 0.5 }
	end
	return { x = 0.35, y = 0.3, w = (style.formw or 17.75) - 0.7, h = (style.main_button_y or 11.0) - 0.45 }
end

ui.register_button(P.PAGE, {
	type = "image",
	image = "mlq_ui_button.png",
	tooltip = "Grand Livre des Quêtes",
})

ui.register_page(P.PAGE, {
	get_formspec = function(player, style)
		local name = player:get_player_name()
		local fs = table.concat({
			"style_type[textarea;textcolor=" .. Q.theme.color.ink .. "]",
			("background9[0.1,0.1;%s,%s;mlq_page_bg.png;false;12]"):format(
				Q.theme.n((style.is_lite_mode and (style.main_button_x or 10.5) - 0.1) or (style.formw - 0.2)),
				Q.theme.n((style.is_lite_mode and style.formh - 0.2) or (style.main_button_y - 0.15))),
			V.build(name, area(style), { inventory = true }),
		})
		return { formspec = fs, draw_inventory = false, draw_item_list = false }
	end,
})

-- Champs de la page d'inventaire : formname == "". On ne traite que nos champs « mlq_ », sans bloquer UI.
core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then return false end
	local name = player:get_player_name()
	if not P.is_current(name) then return false end
	local mine = false
	for k in pairs(fields) do
		if type(k) == "string" and k:sub(1, 4) == "mlq_" then mine = true break end
	end
	if not mine then return false end
	local action = V.handle_fields(name, fields)
	if action == "open_book" then
		Q.book.show(name)
	elseif action == "redraw" then
		P.refresh(name)
	end
	return false
end)
