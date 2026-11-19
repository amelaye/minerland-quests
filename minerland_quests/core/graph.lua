-- Graphe des prérequis : validation (inconnus, cycles), accessibilité et disposition des arbres.
-- Module pur : ne dépend que du registre.
local Q = minerland_quests
local N = Q.i18n.N
local U = Q.util
local G = {}
Q.graph = G

G.problems = {}   -- liste de messages (diagnostic /mlq_diag et outil de validation)

local function problem(msg)
	G.problems[#G.problems + 1] = msg
	U.log("warning", msg)
end

-- Détecte les cycles (DFS itératif-récursif, profondeur faible) ; retourne l'ensemble des quêtes impliquées.
function G.find_cycles(quests_by_id)
	local WHITE, GREY, BLACK = 0, 1, 2
	local color, in_cycle, stack = {}, {}, {}
	local function visit(id)
		color[id] = GREY
		stack[#stack + 1] = id
		local q = quests_by_id[id]
		for _, r in ipairs(q and q.requires or {}) do
			if quests_by_id[r] then
				if color[r] == GREY then
					-- remonte la pile jusqu'à r : tous ces nœuds sont dans le cycle
					for i = #stack, 1, -1 do
						in_cycle[stack[i]] = true
						if stack[i] == r then break end
					end
				elseif (color[r] or WHITE) == WHITE then
					visit(r)
				end
			end
		end
		stack[#stack] = nil
		color[id] = BLACK
	end
	local ids = {}
	for id in pairs(quests_by_id) do ids[#ids + 1] = id end
	table.sort(ids)
	for _, id in ipairs(ids) do
		if (color[id] or WHITE) == WHITE then visit(id) end
	end
	return in_cycle
end

function G.check_all()
	G.problems = {}
	for _, q in ipairs(Q.quest_list) do
		for _, r in ipairs(q.requires) do
			if not Q.quests[r] then
				problem(("quête %s : prérequis inconnu %s"):format(q.id, r))
				Q.mark_unavailable(q, N("Prérequis inconnu : @1"), r)
			elseif r == q.id then
				problem(("quête %s : se requiert elle-même"):format(q.id))
			end
		end
	end
	local cyc = G.find_cycles(Q.quests)
	for id in pairs(cyc) do
		problem(("quête %s : dépendance circulaire"):format(id))
		Q.mark_unavailable(Q.quests[id], N("Dépendance circulaire (erreur de données)"))
	end
	G.layouts = {}
end

-- Une quête est atteignable si elle n'est pas indisponible et si tous ses prérequis disponibles le sont.
-- (Un prérequis indisponible — mod absent — est ignoré pour ne pas bloquer la suite.)
function G.reachable(q, memo)
	memo = memo or {}
	if memo[q.id] ~= nil then return memo[q.id] end
	memo[q.id] = false
	if q.unavailable then return false end
	for _, r in ipairs(q.requires) do
		local p = Q.quests[r]
		if p and not p.unavailable and not G.reachable(p, memo) then return false end
	end
	memo[q.id] = true
	return true
end

-- Disposition d'un chapitre : colonne = plus long chemin intra-chapitre depuis une racine,
-- ligne = au plus près de la ligne du premier parent, sans collision. pos explicite prioritaire (base 1).
function G.layout(chapter_id)
	if G.layouts and G.layouts[chapter_id] then return G.layouts[chapter_id] end
	local quests = Q.get_chapter_quests(chapter_id)
	local in_ch = {}
	for _, q in ipairs(quests) do in_ch[q.id] = q end

	local depth = {}
	local function d(q, guard)
		if depth[q.id] then return depth[q.id] end
		guard = guard or {}
		if guard[q.id] then return 0 end
		guard[q.id] = true
		local best = -1
		for _, r in ipairs(q.requires) do
			if in_ch[r] then best = math.max(best, d(in_ch[r], guard)) end
		end
		depth[q.id] = best + 1
		return depth[q.id]
	end

	local pos, used = {}, {}
	local function take(col, row)
		used[col] = used[col] or {}
		used[col][row] = true
		return { col = col, row = row }
	end
	-- 1) positions explicites
	for _, q in ipairs(quests) do
		if q.pos then pos[q.id] = take(math.floor(q.pos[1]) - 1, math.floor(q.pos[2]) - 1) end
	end
	-- 2) positions automatiques, colonne par colonne
	local by_col, max_col = {}, 0
	for _, q in ipairs(quests) do
		if not pos[q.id] then
			local c = d(q)
			by_col[c] = by_col[c] or {}
			table.insert(by_col[c], q)
			if c > max_col then max_col = c end
		end
	end
	for col = 0, max_col do
		for _, q in ipairs(by_col[col] or {}) do
			local want = 0
			for _, r in ipairs(q.requires) do
				if in_ch[r] and pos[r] then want = pos[r].row break end
			end
			local row = want
			used[col] = used[col] or {}
			while used[col][row] do row = row + 1 end
			pos[q.id] = take(col, row)
		end
	end
	local cols, rows = 0, 0
	for _, p in pairs(pos) do
		cols = math.max(cols, p.col + 1)
		rows = math.max(rows, p.row + 1)
	end
	-- arêtes intra-chapitre (parent -> enfant) et prérequis externes
	local edges, external = {}, {}
	for _, q in ipairs(quests) do
		for _, r in ipairs(q.requires) do
			if in_ch[r] then
				edges[#edges + 1] = { from = r, to = q.id }
			elseif Q.quests[r] then
				external[q.id] = external[q.id] or {}
				table.insert(external[q.id], r)
			end
		end
	end
	local L = { pos = pos, cols = cols, rows = rows, edges = edges, external = external }
	G.layouts = G.layouts or {}
	G.layouts[chapter_id] = L
	return L
end

-- Liste des quêtes qui dépendent directement de q (pour les notifications de déblocage).
function G.children(qid)
	local out = {}
	for _, q in ipairs(Q.quest_list) do
		for _, r in ipairs(q.requires) do
			if r == qid then out[#out + 1] = q break end
		end
	end
	return out
end
