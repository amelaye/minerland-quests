-- Notifications : bandeau HUD discret, message de chat et son, à la réussite d'une quête.
local Q = minerland_quests
local U = Q.util
local T = Q.theme
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

local function inventory_image(item)
	local def = core.registered_items[item]
	if not def then return nil end
	local img = def.inventory_image
	if img and img ~= "" then return img end
	return nil
end

function N.quest_completed(name, q, unlocked, chapter_done)
	local icon = q.icon_kind == "item" and inventory_image(q.icon_value) or "mlq_badge_done.png"
	N.toast(name, "Quête accomplie : " .. q.title,
		chapter_done and ("Chapitre terminé : " .. Q.chapters[q.chapter].title .. " !")
		or (#unlocked > 0 and ("Nouvelle quête : " .. unlocked[1].title) or "Ouvre le Grand Livre pour la suite."),
		icon)
	sound(name)
	if U.setting_bool("notify_chat", true) then
		local msg = T.colored(T.color.gold, "[Grand Livre] ") .. "Quête accomplie : "
			.. T.colored(T.color.gold, q.title)
		if #unlocked > 0 then
			local names = {}
			for _, u in ipairs(unlocked) do names[#names + 1] = u.title end
			msg = msg .. " — débloquée(s) : " .. table.concat(names, ", ")
		end
		core.chat_send_player(name, msg)
		if chapter_done then
			core.chat_send_player(name, T.colored(T.color.green, "[Grand Livre] Chapitre terminé : "
				.. Q.chapters[q.chapter].title .. " !"))
		end
	end
end

function N.inventory_full(name, qid)
	local q = Q.quests[qid]
	core.chat_send_player(name, T.colored(T.color.brick, "[Grand Livre] ")
		.. "Inventaire plein : la récompense de « " .. (q and q.title or qid)
		.. " » est conservée et sera livrée dès qu'il y aura de la place.")
end

function N.delivered(name, count)
	core.chat_send_player(name, T.colored(T.color.gold, "[Grand Livre] ")
		.. (count > 1 and (count .. " récompenses livrées dans ton inventaire.")
		or "Récompense livrée dans ton inventaire."))
end

core.register_on_leaveplayer(function(player)
	huds[player:get_player_name()] = nil
end)
