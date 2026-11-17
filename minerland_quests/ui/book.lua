-- Le livre autonome (formspec v6) et le rafraîchissement en direct des deux interfaces.
local Q = minerland_quests
local T = Q.theme
local V = Q.views
local B = {}
Q.book = B

B.FORMNAME = "minerland_quests:book"
B.W, B.H = 20, 12.6

local open = {}   -- [nom] = true tant que le livre est affiché

function B.formspec(name)
	return table.concat({
		"formspec_version[6]",
		("size[%s,%s]"):format(B.W, B.H),
		"no_prepend[]",
		"bgcolor[#00000088;true]",
		("background9[0,0;%s,%s;mlq_book_bg.png;false;24]"):format(B.W, B.H),
		"style_type[textarea;textcolor=" .. T.color.ink .. "]",
		"listcolors[#00000000;#00000000]",
		V.build(name, { x = 0.9, y = 0.65, w = B.W - 1.8, h = B.H - 1.3 }, { book = true }),
		("image_button_exit[%s,0.15;0.5,0.5;mlq_close.png;mlq_close;]"):format(T.n(B.W - 0.7)),
		T.tooltip("mlq_close", "Fermer le livre"),
	})
end

function B.show(name)
	if not core.get_player_by_name(name) then return end
	open[name] = true
	core.show_formspec(name, B.FORMNAME, B.formspec(name))
end

function B.is_open(name)
	return open[name] == true
end

core.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= B.FORMNAME then return false end
	local name = player:get_player_name()
	if fields.quit or fields.mlq_close then
		open[name] = nil
		return true
	end
	local action = V.handle_fields(name, fields)
	if action == "redraw" or action == "open_book" then
		B.show(name)
	end
	return true
end)

core.register_on_leaveplayer(function(player)
	open[player:get_player_name()] = nil
end)

-- Rafraîchissement débouncé des interfaces ouvertes après un changement de progression.
local scheduled = {}
function Q.ui.refresh(name)
	if scheduled[name] then return end
	scheduled[name] = true
	core.after(0.3, function()
		scheduled[name] = nil
		if not core.get_player_by_name(name) then return end
		if open[name] then B.show(name) end
		if Q.inventory_page and Q.inventory_page.is_current(name) then
			Q.inventory_page.refresh(name)
		end
	end)
end
