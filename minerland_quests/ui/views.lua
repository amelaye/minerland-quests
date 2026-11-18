-- Vues du Grand Livre, partagées par le livre autonome et la page Unified Inventory.
-- Chaque vue dessine dans un rectangle {x, y, w, h}. Les champs ne servent qu'à naviguer.
local Q = minerland_quests
local U = Q.util
local T = Q.theme
local esc, n = T.esc, T.n
local V = {}
Q.ui = Q.ui or {}
Q.views = V

-- État de navigation par joueur, partagé entre le livre et l'inventaire.
local states = {}
function V.state(name)
	local s = states[name]
	if not s then
		s = { view = "home", part = nil, chapter = nil, quest = nil, scroll = 0, detail = false }
		states[name] = s
	end
	return s
end

core.register_on_leaveplayer(function(player)
	states[player:get_player_name()] = nil
end)

---------------------------------------------------------------------------
-- Textes dérivés des données
---------------------------------------------------------------------------
local VERB = { dig = "Extraire", place = "Poser", craft = "Fabriquer", eat = "Déguster" }

function V.objective_text(q)
	if q.objective then return q.objective end
	local t = q.trigger
	if t.type == "custom" then return q.description end
	local names = {}
	local list = {}
	for item in pairs(q.targets or {}) do list[#list + 1] = item end
	table.sort(list)
	for i, item in ipairs(list) do
		if i > 3 then names[#names + 1] = "…" break end
		names[#names + 1] = U.item_description(item)
	end
	if #names == 0 then
		for _, it in ipairs(t.items) do names[#names + 1] = it end
		for _, g in ipairs(t.groups) do names[#names + 1] = "groupe " .. g end
	end
	local what = table.concat(names, " ou ")
	local qty = t.count > 1 and (" ×" .. t.count) or ""
	local extra = (t.type == "place" and t.distinct) and " (à des endroits différents)" or ""
	return ("%s : %s%s%s"):format(VERB[t.type] or t.type, what, qty, extra)
end

local function quest_icon(x, y, s, q)
	if q.icon_kind == "item" then
		return T.item_image(x, y, s, s, q.icon_value)
	end
	return T.image(x, y, s, s, q.icon_value or "mlq_icon_quest.png")
end

local function chapter_icon(x, y, s, c)
	if c.icon_item then return T.item_image(x, y, s, s, c.icon_item) end
	return T.image(x, y, s, s, c.emblem)
end

---------------------------------------------------------------------------
-- En-tête commun (fil d'Ariane + boutons)
---------------------------------------------------------------------------
local function header(fs, name, r, title, subtitle, opts)
	local s = V.state(name)
	local bx = r.x + r.w
	if s.view ~= "home" then
		bx = bx - 1.6
		fs[#fs + 1] = T.button(bx, r.y, 1.5, 0.6, "mlq_home", "Accueil")
		bx = bx - 1.6
		fs[#fs + 1] = T.button(bx, r.y, 1.5, 0.6, "mlq_back", "Retour")
	end
	if opts.inventory then
		bx = bx - 2.3
		fs[#fs + 1] = T.button(bx, r.y, 2.2, 0.6, "mlq_open_book", "Ouvrir en grand", "gold")
	end
	fs[#fs + 1] = T.label(r.x + 0.1, r.y + 0.2, title, T.color.ink)
	if subtitle and subtitle ~= "" then
		fs[#fs + 1] = T.label(r.x + 0.1, r.y + 0.6, subtitle, T.color.ink_soft)
	end
	fs[#fs + 1] = T.ornament(r.x, r.y + 0.9, r.w)
end

---------------------------------------------------------------------------
-- Accueil
---------------------------------------------------------------------------
local function view_home(fs, name, r, opts)
	header(fs, name, r, "Le Grand Livre des Quêtes de Minerland",
		"Carnet d'aventure de " .. name, opts)
	local top = r.y + 1.2
	local narrow = r.w < 14
	local left_w = narrow and 0 or math.min(5.6, r.w * 0.34)
	if not narrow then
		-- page de gauche : couverture et progression
		local cx = r.x + 0.1
		fs[#fs + 1] = T.image(cx + (left_w - 4.2) / 2, top, 4.2, 5.25, "mlq_cover.png")
		local d, t = Q.progress.global_stats(name)
		local y = top + 5.45
		fs[#fs + 1] = T.label(cx, y, ("Progression : %d / %d quêtes"):format(d, t))
		fs[#fs + 1] = T.progress_bar(cx, y + 0.3, left_w - 0.2, 0.35, d, t)
		local rec = Q.storage.get(name)
		local titles = {}
		for qid, title in pairs(rec.titles) do titles[#titles + 1] = { qid = qid, title = title } end
		table.sort(titles, function(a, b) return a.qid < b.qid end)
		y = y + 0.95
		if #titles > 0 then
			fs[#fs + 1] = T.image(cx, y - 0.2, 0.4, 0.4, "mlq_title.png")
			fs[#fs + 1] = T.label(cx + 0.5, y, ("Titres : %s"):format(T.truncate(titles[#titles].title, 30)))
			if #titles > 1 then
				local all = {}
				for _, t2 in ipairs(titles) do all[#all + 1] = t2.title end
				fs[#fs + 1] = T.tooltip_area(cx, y - 0.25, left_w, 0.5, table.concat(all, "\n"))
			end
			y = y + 0.5
		end
		local pending = Q.rewards.pending_count(name)
		if pending > 0 then
			fs[#fs + 1] = T.image(cx, y - 0.2, 0.4, 0.4, "mlq_reward.png")
			fs[#fs + 1] = T.label(cx + 0.5, y, ("%d récompense(s) en attente de place"):format(pending), T.color.brick)
			fs[#fs + 1] = T.button(cx, y + 0.3, left_w - 0.2, 0.6, "mlq_deliver", "Recevoir mes récompenses", "gold")
		end
	end
	-- page de droite : les six parties
	local gx = r.x + left_w + (narrow and 0 or 0.4)
	local gw = r.w - (gx - r.x)
	local cols = 2
	local cw = (gw - 0.3 * (cols - 1)) / cols
	local rows = math.ceil(#Q.part_list / cols)
	local ch = math.min(2.9, (r.y + r.h - top - 0.2 * (rows - 1)) / rows)
	for i, p in ipairs(Q.part_list) do
		local col, row = (i - 1) % cols, math.floor((i - 1) / cols)
		local x, y = gx + col * (cw + 0.3), top + row * (ch + 0.2)
		local ih = ch - 0.75
		fs[#fs + 1] = T.panel(x, y, cw, ch)
		fs[#fs + 1] = T.image(x + 0.1, y + 0.1, cw - 0.2, ih, p.illustration)
		local d, t = Q.progress.part_stats(name, p.id)
		fs[#fs + 1] = T.label(x + 0.2, y + ih + 0.3, T.truncate(p.numeral .. ". " .. p.title, narrow and 24 or 34))
		fs[#fs + 1] = T.progress_bar(x + 0.2, y + ih + 0.5, cw - 1.6, 0.2, d, t)
		fs[#fs + 1] = T.label(x + cw - 1.25, y + ih + 0.58, ("%d/%d"):format(d, t), T.color.ink_soft)
		if t > 0 and d == t then
			fs[#fs + 1] = T.image(x + cw - 0.6, y + 0.15, 0.45, 0.45, "mlq_badge_done.png")
		end
		local field = "mlq_part_" .. p.id
		fs[#fs + 1] = T.hotspot(x, y, cw, ch, field)
		fs[#fs + 1] = T.tooltip(field, p.title .. "\n" .. p.subtitle)
	end
end

---------------------------------------------------------------------------
-- Partie : cartes de chapitres
---------------------------------------------------------------------------
local function view_part(fs, name, r, opts)
	local s = V.state(name)
	local p = Q.parts[s.part]
	if not p then s.view = "home" return view_home(fs, name, r, opts) end
	local d, t = Q.progress.part_stats(name, p.id)
	header(fs, name, r, ("Partie %s — %s"):format(p.numeral, p.title), ("%s  (%d/%d)"):format(p.subtitle, d, t), opts)
	local top = r.y + 1.2
	local narrow = r.w < 14
	local banner_w = narrow and 0 or math.min(5.6, r.w * 0.34)
	if not narrow then
		fs[#fs + 1] = T.panel(r.x, top, banner_w, banner_w / 2 + 0.2)
		fs[#fs + 1] = T.image(r.x + 0.1, top + 0.1, banner_w - 0.2, banner_w / 2, p.illustration)
		fs[#fs + 1] = T.progress_bar(r.x, top + banner_w / 2 + 0.4, banner_w, 0.3, d, t)
	end
	local gx = r.x + banner_w + (narrow and 0 or 0.4)
	local gw = r.w - (gx - r.x)
	local cols = (gw >= 10) and 2 or 1
	local cw = (gw - 0.3 * (cols - 1)) / cols
	local ch = 1.35
	for i, c in ipairs(p.chapters) do
		local col, row = (i - 1) % cols, math.floor((i - 1) / cols)
		local x, y = gx + col * (cw + 0.3), top + row * (ch + 0.2)
		local cd, ct = Q.progress.chapter_stats(name, c.id)
		fs[#fs + 1] = T.panel(x, y, cw, ch)
		fs[#fs + 1] = T.image(x + 0.12, y + 0.12, 1.1, 1.1, "mlq_frame_" .. (ct > 0 and cd == ct and "done"
			or ct == 0 and "unavailable" or "available") .. ".png")
		fs[#fs + 1] = chapter_icon(x + 0.27, y + 0.27, 0.8, c)
		fs[#fs + 1] = T.label(x + 1.4, y + 0.35, T.truncate(("Chapitre %d — %s"):format(c.number, c.title), 40))
		fs[#fs + 1] = T.progress_bar(x + 1.4, y + 0.7, cw - 2.6, 0.25, cd, ct)
		fs[#fs + 1] = T.label(x + cw - 1.1, y + 0.83, ct > 0 and ("%d/%d"):format(cd, ct) or "—", T.color.ink_soft)
		if ct > 0 and cd == ct then
			fs[#fs + 1] = T.image(x + cw - 0.55, y + 0.1, 0.4, 0.4, "mlq_badge_done.png")
		end
		local field = "mlq_ch_" .. c.id
		fs[#fs + 1] = T.hotspot(x, y, cw, ch, field)
		fs[#fs + 1] = T.tooltip(field, c.title .. (ct == 0 and "\n(mods absents sur ce serveur)" or ""))
	end
end

---------------------------------------------------------------------------
-- Arbre d'un chapitre
---------------------------------------------------------------------------
V.NODE = 1.1     -- taille d'un nœud
V.COL = 1.95     -- pas horizontal
V.ROW = 1.7      -- pas vertical (place pour le titre sous le nœud)
V.MARGIN = 0.35

function V.tree_size(chapter_id)
	local L = Q.graph.layout(chapter_id)
	return V.MARGIN * 2 + (L.cols - 1) * V.COL + V.NODE, V.MARGIN * 2 + (L.rows - 1) * V.ROW + V.NODE + 0.35, L
end

local function edge_color(name, from, to)
	local sf = Q.progress.state(name, from)
	local st = Q.progress.state(name, to)
	if sf == "done" and st == "done" then return T.color.green end
	if sf == "done" then return T.color.gold end
	return "#9c8b70"
end

local function draw_tree(fs, name, chapter_id, ox, oy)
	local s = V.state(name)
	local L = Q.graph.layout(chapter_id)
	local S, th = V.NODE, 0.08
	local function origin(qid)
		local p = L.pos[qid]
		return ox + V.MARGIN + p.col * V.COL, oy + V.MARGIN + p.row * V.ROW
	end
	-- 1) connexions (sous les nœuds)
	for _, e in ipairs(L.edges) do
		local px, py = origin(e.from)
		local cx, cy = origin(e.to)
		local color = edge_color(name, Q.quests[e.from], Q.quests[e.to])
		local x1, y1 = px + S, py + S / 2
		local x2, y2 = cx, cy + S / 2
		if x2 > x1 then
			local mx = x1 + (x2 - x1) / 2
			fs[#fs + 1] = T.box(x1, y1 - th / 2, mx - x1, th, color)
			fs[#fs + 1] = T.box(mx - th / 2, math.min(y1, y2) - th / 2, th, math.abs(y2 - y1) + th, color)
			fs[#fs + 1] = T.box(mx, y2 - th / 2, x2 - mx, th, color)
			fs[#fs + 1] = T.image(x2 - 0.22, y2 - 0.13, 0.22, 0.26, "mlq_arrow.png")
		else
			-- même colonne (position forcée) : liaison verticale
			local x = px + S / 2
			fs[#fs + 1] = T.box(x - th / 2, math.min(py, cy) + S, th, math.abs(cy - py) - S, color)
		end
	end
	-- 2) nœuds
	for _, q in ipairs(Q.get_chapter_quests(chapter_id)) do
		local x, y = origin(q.id)
		local st = Q.progress.state(name, q)
		if s.quest == q.id then
			fs[#fs + 1] = T.image(x - 0.12, y - 0.12, S + 0.24, S + 0.24, "mlq_select.png")
		end
		fs[#fs + 1] = T.image(x, y, S, S, "mlq_frame_" .. st .. ".png")
		fs[#fs + 1] = quest_icon(x + 0.2, y + 0.2, S - 0.4, q)
		if st == "locked" or st == "unavailable" then
			fs[#fs + 1] = T.image(x + 0.12, y + 0.12, S - 0.24, S - 0.24, "mlq_veil.png")
		end
		fs[#fs + 1] = T.image(x + S - 0.38, y - 0.12, 0.5, 0.5, "mlq_badge_" .. st .. ".png")
		if q.final then
			fs[#fs + 1] = T.image(x - 0.12, y - 0.12, 0.42, 0.42, "mlq_star.png")
		end
		fs[#fs + 1] = T.label(x - 0.25, y + S + 0.2, T.truncate(q.title, 15),
			st == "locked" and T.color.ink_soft or T.color.ink)
		local field = "mlq_q_" .. q.index
		fs[#fs + 1] = T.hotspot(x, y, S, S, field)
		local tip = q.title .. "\n" .. T.state_label[st]
		if st == "available" then tip = tip .. "\n" .. V.objective_text(q) end
		fs[#fs + 1] = T.tooltip(field, tip)
	end
end

---------------------------------------------------------------------------
-- Fiche détaillée d'une quête
---------------------------------------------------------------------------
local function view_detail(fs, name, q, r)
	local st = Q.progress.state(name, q)
	local rec = Q.storage.get(name)
	local x, y, w = r.x, r.y, r.w
	fs[#fs + 1] = T.panel(x, y, w, r.h)
	x, w = x + 0.25, w - 0.5
	y = y + 0.25
	fs[#fs + 1] = T.image(x, y, 1.4, 1.4, "mlq_frame_" .. st .. ".png")
	fs[#fs + 1] = quest_icon(x + 0.25, y + 0.25, 0.9, q)
	if st == "done" then fs[#fs + 1] = T.image(x + 0.95, y - 0.1, 0.55, 0.55, "mlq_badge_done.png") end
	fs[#fs + 1] = T.label(x + 1.6, y + 0.25, T.truncate(q.title, 34))
	fs[#fs + 1] = T.label(x + 1.6, y + 0.65, T.state_label[st], T.state_text_color[st])
	fs[#fs + 1] = T.label(x + 1.6, y + 1.05, "Difficulté :", T.color.ink_soft)
	for i = 1, 5 do
		fs[#fs + 1] = T.image(x + 3.0 + (i - 1) * 0.32, y + 0.92, 0.28, 0.28,
			i <= q.difficulty and "mlq_pip_on.png" or "mlq_pip_off.png")
	end
	fs[#fs + 1] = T.label(x + 4.7, y + 1.05, T.difficulty_label[q.difficulty], T.color.ink_soft)
	y = y + 1.6
	fs[#fs + 1] = T.ornament(x, y, w)
	y = y + 0.25

	local lines = {}
	lines[#lines + 1] = "« " .. q.description .. " »"
	lines[#lines + 1] = ""
	if st == "unavailable" then
		lines[#lines + 1] = "Indisponible : " .. (q.unavailable or "?")
	else
		lines[#lines + 1] = "Objectif — " .. V.objective_text(q)
	end
	local miss = Q.progress.missing_requirements(name, q)
	if #q.requires > 0 then
		local parts = {}
		for _, rid in ipairs(q.requires) do
			local p = Q.quests[rid]
			if p then
				local mark = rec.done[rid] and "(fait) " or (p.unavailable and "(ignoré) " or "(à faire) ")
				local where = p.chapter ~= q.chapter and (" (" .. Q.chapters[p.chapter].title .. ")") or ""
				parts[#parts + 1] = mark .. p.title .. where
			end
		end
		lines[#lines + 1] = "Prérequis : " .. table.concat(parts, ", ")
	end
	if q.hint and st ~= "done" then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "Astuce : " .. q.hint
	end
	if st == "done" then
		lines[#lines + 1] = ""
		lines[#lines + 1] = "Accomplie le " .. U.format_date(rec.done[q.id]) .. "."
	end
	-- place réservée sous le texte : progression, récompense, cases d'objets et marge basse du panneau
	local text_h = math.max(1.6, r.h - (y - r.y) - 2.85)
	fs[#fs + 1] = T.textarea(x, y, w, text_h, table.concat(lines, "\n"))
	y = y + text_h + 0.1

	-- progression
	local c, total = Q.progress.count(name, q), q.trigger.count
	fs[#fs + 1] = T.label(x, y + 0.15, ("Progression : %d / %d"):format(c, total))
	fs[#fs + 1] = T.progress_bar(x + 3.2, y, w - 3.2, 0.3, c, total,
		st == "done" and T.color.green or T.color.gold)
	if #miss > 0 and st == "locked" then
		fs[#fs + 1] = T.label(x, y + 0.55, ("Encore %d prérequis à accomplir."):format(#miss), T.color.ink_soft)
	end
	y = y + 0.85

	-- récompense
	fs[#fs + 1] = T.ornament(x, y, w)
	y = y + 0.25
	fs[#fs + 1] = T.image(x, y, 0.5, 0.5, "mlq_reward.png")
	local status = Q.rewards.status(name, q)
	local status_txt = ({ none = "Récompense prévue", pending = "Récompense en attente (inventaire plein)",
		delivered = "Récompense reçue" })[status]
	fs[#fs + 1] = T.label(x + 0.6, y + 0.25, status_txt, status == "pending" and T.color.brick
		or status == "delivered" and T.color.green or T.color.ink)
	local ix = x + 0.1
	y = y + 0.6
	fs[#fs + 1] = T.slot_style("mlq_noop")
	for _, s in ipairs(q.reward_items or {}) do
		local stack = ItemStack(s)
		if ix + 0.8 > x + w then break end
		fs[#fs + 1] = ("item_image_button[%s,%s;0.8,0.8;%s;mlq_noop;%s]"):format(n(ix), n(y), esc(stack:get_name()),
			stack:get_count() > 1 and esc(tostring(stack:get_count())) or "")
		fs[#fs + 1] = T.tooltip_area(ix, y, 0.8, 0.8, U.item_description(stack:get_name()) .. " ×" .. stack:get_count())
		ix = ix + 0.9
	end
	if q.reward.title then
		fs[#fs + 1] = T.image(ix, y + 0.15, 0.5, 0.5, "mlq_title.png")
		fs[#fs + 1] = T.label(ix + 0.55, y + 0.4, "Titre : « " .. T.truncate(q.reward.title, 26) .. " »", T.color.bronze)
	end
	if #(q.reward_items or {}) == 0 and not q.reward.title then
		fs[#fs + 1] = T.label(x, y + 0.4, "La satisfaction du devoir accompli.", T.color.ink_soft)
	end
	if status == "pending" then
		fs[#fs + 1] = T.button(x + w - 2.6, r.y + r.h - 0.85, 2.5, 0.6, "mlq_deliver", "Réessayer la livraison", "gold")
	end
end

---------------------------------------------------------------------------
-- Chapitre : arbre + fiche
---------------------------------------------------------------------------
local function view_chapter(fs, name, r, opts)
	local s = V.state(name)
	local c = Q.chapters[s.chapter]
	if not c then s.view = "home" return view_home(fs, name, r, opts) end
	local d, t = Q.progress.chapter_stats(name, c.id)
	header(fs, name, r, ("Chapitre %d — %s"):format(c.number, c.title),
		("Partie %s · %d/%d quêtes"):format(Q.parts[c.part].numeral, d, t), opts)
	local top = r.y + 1.15
	local narrow = r.w < 14
	local q = s.quest and Q.quests[s.quest]
	if q and q.chapter ~= c.id then q, s.quest = nil, nil end

	-- navigation chapitre précédent / suivant
	local prev, nxt
	for i, ch in ipairs(Q.chapter_list) do
		if ch.id == c.id then prev, nxt = Q.chapter_list[i - 1], Q.chapter_list[i + 1] end
	end

	if narrow and s.detail and q then
		fs[#fs + 1] = T.button(r.x, top, 2.6, 0.6, "mlq_tree", "« Retour à l'arbre")
		view_detail(fs, name, q, { x = r.x, y = top + 0.75, w = r.w, h = r.h - (top - r.y) - 0.75 })
		return
	end

	local detail_w = narrow and 0 or math.max(6.2, math.min(7.4, r.w * 0.40))
	local tw = r.w - detail_w - (narrow and 0 or 0.3)
	-- introduction
	fs[#fs + 1] = T.image(r.x, top, 0.9, 0.9, c.emblem)
	fs[#fs + 1] = T.textarea(r.x + 1.0, top - 0.05, tw - 1.0, 1.0, c.intro)
	local ty = top + 1.05
	local th = r.y + r.h - ty - 0.65
	-- arbre
	fs[#fs + 1] = T.panel(r.x, ty, tw, th)
	local cw, chh = V.tree_size(c.id)
	local vx, vy, vw, vh = r.x + 0.1, ty + 0.1, tw - 0.2, th - 0.2
	local horizontal = cw > vw
	local vertical = not horizontal and chh > vh
	if horizontal or vertical then
		local over = horizontal and (cw - vw) or (chh - vh)
		local steps = math.ceil(over / 0.1)
		s.scroll = math.max(0, math.min(s.scroll or 0, steps))
		local sb_h = 0.3
		if horizontal then vh = vh - sb_h end
		if vertical then vw = vw - sb_h end
		fs[#fs + 1] = ("scroll_container[%s,%s;%s,%s;mlq_tree_sb;%s;0.1]"):format(n(vx), n(vy), n(vw), n(vh),
			horizontal and "horizontal" or "vertical")
		draw_tree(fs, name, c.id, 0, 0)
		fs[#fs + 1] = "scroll_container_end[]"
		fs[#fs + 1] = ("scrollbaroptions[min=0;max=%d;smallstep=10;largestep=%d;thumbsize=%d]"):format(
			steps, math.max(10, math.floor(steps / 3)), math.max(5, math.floor(steps * vw / cw)))
		if horizontal then
			fs[#fs + 1] = ("scrollbar[%s,%s;%s,%s;horizontal;mlq_tree_sb;%d]"):format(n(vx), n(vy + vh + 0.02),
				n(vw), n(sb_h - 0.04), s.scroll)
		else
			fs[#fs + 1] = ("scrollbar[%s,%s;%s,%s;vertical;mlq_tree_sb;%d]"):format(n(vx + vw + 0.02), n(vy),
				n(sb_h - 0.04), n(vh), s.scroll)
		end
	else
		-- centré
		draw_tree(fs, name, c.id, vx + (vw - cw) / 2, vy + (vh - chh) / 2)
	end
	-- légende + navigation
	local ly = ty + th + 0.1
	local lx = r.x
	for _, st in ipairs({ "available", "done", "locked", "unavailable" }) do
		fs[#fs + 1] = T.image(lx, ly, 0.45, 0.45, "mlq_badge_" .. st .. ".png")
		fs[#fs + 1] = T.label(lx + 0.5, ly + 0.22, T.state_label[st], T.color.ink_soft)
		lx = lx + (narrow and 2.3 or 2.15)
		-- la légende s'arrête avant les boutons « / » (largeur réservée : 1,8)
		if lx > r.x + tw - 1.8 - 2.15 then break end
	end
	if prev then fs[#fs + 1] = T.button(r.x + tw - 1.7, ly - 0.02, 0.8, 0.5, "mlq_prev", "«") end
	if nxt then fs[#fs + 1] = T.button(r.x + tw - 0.85, ly - 0.02, 0.8, 0.5, "mlq_next", "»") end
	if prev then fs[#fs + 1] = T.tooltip("mlq_prev", "Chapitre précédent : " .. prev.title) end
	if nxt then fs[#fs + 1] = T.tooltip("mlq_next", "Chapitre suivant : " .. nxt.title) end

	if not narrow then
		local dx = r.x + tw + 0.3
		if q then
			view_detail(fs, name, q, { x = dx, y = top, w = detail_w, h = r.h - (top - r.y) })
		else
			fs[#fs + 1] = T.panel(dx, top, detail_w, r.h - (top - r.y))
			fs[#fs + 1] = T.image(dx + (detail_w - 3) / 2, top + 0.6, 3, 1.5, Q.parts[c.part].illustration)
			fs[#fs + 1] = T.textarea(dx + 0.3, top + 2.4, detail_w - 0.6, 4,
				"Clique sur une quête de l'arbre pour lire sa fiche : objectif, prérequis, avancement et récompense.\n\n"
				.. "Les quêtes se valident toutes seules quand tu accomplis l'action demandée. "
				.. "Les récompenses arrivent directement dans ton inventaire.")
		end
	end
end

---------------------------------------------------------------------------
-- Entrée publique
---------------------------------------------------------------------------
-- opts : { inventory = bool }
function V.build(name, r, opts)
	opts = opts or {}
	local fs = {}
	local s = V.state(name)
	if s.view == "part" then
		view_part(fs, name, r, opts)
	elseif s.view == "chapter" then
		view_chapter(fs, name, r, opts)
	else
		view_home(fs, name, r, opts)
	end
	return table.concat(fs)
end

-- Navigation. Retourne "redraw", "open_book" ou nil. Ne valide JAMAIS une quête.
function V.handle_fields(name, fields)
	local s = V.state(name)
	local action = nil
	if fields.mlq_tree_sb then
		local ev = core.explode_scrollbar_event(fields.mlq_tree_sb)
		if ev and ev.value then s.scroll = math.max(0, math.floor(ev.value)) end
	end
	for key in pairs(fields) do
		if type(key) == "string" and key:sub(1, 4) == "mlq_" then
			local part = key:match("^mlq_part_([a-z_]+)$")
			local ch = key:match("^mlq_ch_(ch%d%d)$")
			local qi = key:match("^mlq_q_(%d+)$")
			if key == "mlq_home" then
				s.view, s.quest, s.detail = "home", nil, false
				action = "redraw"
			elseif key == "mlq_back" then
				if s.view == "chapter" then s.view, s.quest, s.detail = "part", nil, false
				else s.view = "home" end
				action = "redraw"
			elseif key == "mlq_tree" then
				s.detail = false
				action = "redraw"
			elseif part and Q.parts[part] then
				s.view, s.part = "part", part
				action = "redraw"
			elseif ch and Q.chapters[ch] then
				s.view, s.chapter, s.part, s.quest, s.scroll, s.detail = "chapter", ch, Q.chapters[ch].part, nil, 0, false
				action = "redraw"
			elseif qi then
				local q = Q.get_quest_by_index(qi)
				if q and q.chapter == s.chapter then
					s.quest, s.detail = q.id, true
					action = "redraw"
				end
			elseif key == "mlq_prev" or key == "mlq_next" then
				for i, c in ipairs(Q.chapter_list) do
					if c.id == s.chapter then
						local target = Q.chapter_list[i + (key == "mlq_next" and 1 or -1)]
						if target then
							s.chapter, s.part, s.quest, s.scroll, s.detail = target.id, target.part, nil, 0, false
						end
						break
					end
				end
				action = "redraw"
			elseif key == "mlq_deliver" then
				Q.rewards.deliver(name)   -- relance une livraison déjà attribuée ; n'attribue rien
				action = "redraw"
			elseif key == "mlq_open_book" then
				action = "open_book"
			end
		end
	end
	return action
end
