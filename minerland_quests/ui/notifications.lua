-- Notifications : bandeau HUD discret, message de chat et son, à la réussite d'une quête.
-- Textes traduits pour le joueur (core/i18n.lua).
local Q = minerland_quests
local U = Q.util
local T = Q.theme
local tr = Q.i18n.tr
local N = {}
Q.notify = N

local huds = {}   -- [nom] = { ids = {...}, token = n }

local function sound(name)
	-- Son facultatif : sounds/mlq_complete.ogg (aucun fichier fourni par défaut ; un son absent est ignoré
	-- silencieusement par le client). Le mod ne dépend d'aucun son d'un autre mod.
	core.sound_play("mlq_complete", { to_player = name, gain = 0.6 }, true)
end

local function clear(name)
	local h = huds[name]
	local player = core.get_player_by_name(name)
	if h and player then
		for _, id in ipairs(h.ids) do player:hud_remove(id) end
	end
	if h then h.ids = {} end
end

function N.toast(name, title, subtitle, icon)
	local player = core.get_player_by_name(name)
	if not player then return end
	clear(name)
	huds[name] = huds[name] or { ids = {}, token = 0 }
	local h = huds[name]
	h.token = h.token + 1
	local token = h.token
	local base = { x = 0.5, y = 0 }
	h.ids[#h.ids + 1] = player:hud_add({
		type = "image", position = base, offset = { x = 0, y = 52 },
		text = "mlq_toast.png", scale = { x = 3, y = 3 }, alignment = { x = 0, y = 0 }, z_index = 100,
	})
	if icon then
		h.ids[#h.ids + 1] = player:hud_add({
			type = "image", position = base, offset = { x = -150, y = 52 },
			text = icon, scale = { x = 2.5, y = 2.5 }, alignment = { x = 0, y = 0 }, z_index = 101,
		})
	end
	h.ids[#h.ids + 1] = player:hud_add({
		type = "text", position = base, offset = { x = 16, y = 40 }, text = title,
		number = 0x3b2412, alignment = { x = 0, y = 0 }, z_index = 102, style = 1,
	})
	h.ids[#h.ids + 1] = player:hud_add({
		type = "text", position = base, offset = { x = 16, y = 64 }, text = subtitle or "",
		number = 0x6b4a2b, alignment = { x = 0, y = 0 }, z_index = 102,
	})
	core.after(5, function()
		if huds[name] and huds[name].token == token then clear(name) end
	end)
end

local function tile_name(tile)
	if type(tile) == "table" then tile = tile.name or tile.image end
	if type(tile) ~= "string" or tile == "" then return nil end
	return (tile:gsub("%^", "&"))   -- « ^ » doit devenir « & » à l'intérieur de [inventorycube
end

-- Image d'un objet pour le HUD : son image d'inventaire, sinon un cube dessiné à partir des faces du nœud.
local function inventory_image(item)
	local def = core.registered_items[item]
	if not def then return nil end
	local img = def.inventory_image
	if img and img ~= "" then return img end
	local tiles = def.tiles
	if type(tiles) == "table" and #tiles > 0 then
		local top = tile_name(tiles[1])
		local side = tile_name(tiles[3] or tiles[#tiles]) or top
		local front = tile_name(tiles[6] or tiles[3] or tiles[#tiles]) or side
		if top and side then return ("[inventorycube{%s{%s{%s"):format(top, front, side) end
	end
	return nil
end

function N.quest_completed(name, q, unlocked, chapter_done)
	local icon = q.icon_kind == "item" and inventory_image(q.icon_value) or "mlq_badge_done.png"
	local title = tr(name, q.title)
	local subtitle
	if chapter_done then
		subtitle = tr(name, "Chapitre terminé : @1 !", tr(name, Q.chapters[q.chapter].title))
	elseif #unlocked > 0 then
		subtitle = tr(name, "Nouvelle quête : @1", tr(name, unlocked[1].title))
	else
		subtitle = tr(name, "Ouvre le Grand Livre pour la suite.")
	end
	N.toast(name, tr(name, "Quête accomplie : @1", title), subtitle, icon)
	sound(name)
	if U.setting_bool("notify_chat", true) then
		local msg = T.colored(T.color.gold, tr(name, "[Grand Livre]")) .. " "
			.. tr(name, "Quête accomplie : @1", T.colored(T.color.gold, title))
		if #unlocked > 0 then
			local names = {}
			for _, u in ipairs(unlocked) do names[#names + 1] = tr(name, u.title) end
			msg = msg .. " — " .. tr(name, "débloquée(s) : @1", table.concat(names, ", "))
		end
		core.chat_send_player(name, msg)
		if chapter_done then
			core.chat_send_player(name, T.colored(T.color.green, tr(name, "[Grand Livre]") .. " "
				.. tr(name, "Chapitre terminé : @1 !", tr(name, Q.chapters[q.chapter].title))))
		end
	end
end

function N.inventory_full(name, qid)
	local q = Q.quests[qid]
	core.chat_send_player(name, T.colored(T.color.brick, tr(name, "[Grand Livre]")) .. " "
		.. tr(name, "Inventaire plein : la récompense de « @1 » est conservée et sera livrée dès qu'il y aura de la place.",
			q and tr(name, q.title) or qid))
end

function N.delivered(name, count)
	core.chat_send_player(name, T.colored(T.color.gold, tr(name, "[Grand Livre]")) .. " "
		.. (count > 1 and tr(name, "@1 récompenses livrées dans ton inventaire.", count)
		or tr(name, "Récompense livrée dans ton inventaire.")))
end

core.register_on_leaveplayer(function(player)
	huds[player:get_player_name()] = nil
end)
