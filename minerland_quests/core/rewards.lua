-- Récompenses : attribution unique, file de livraison persistante, livraison automatique.
--
-- Ordre des opérations (garantie « au plus une fois ») :
--   1. grant()   : journal rewarded[qid] + entrée dans pending, puis écriture immédiate du stockage.
--   2. deliver() : si TOUTE la récompense tient dans l'inventaire, on retire l'entrée de pending,
--                  on note delivered[qid], on écrit le stockage, PUIS on ajoute les objets (même pas serveur).
--   Une quête dont rewarded[qid] existe n'est plus jamais récompensée, même si elle est réinitialisée.
--   Limite : l'inventaire du joueur et le mod storage sont persistés par le moteur à des moments différents ;
--   en cas de crash dur entre les deux sauvegardes, une récompense peut être perdue (jamais dupliquée).
local Q = minerland_quests
local U = Q.util
local R = {}
Q.rewards = R

local waiting = {}        -- [nom] = true si des livraisons sont en attente (joueur connecté)
local last_full_msg = {}  -- anti-spam du message « inventaire plein »

function R.pending(name)
	return Q.storage.get(name).pending
end

function R.pending_count(name)
	return #Q.storage.get(name).pending
end

-- État de livraison affichable : "none" | "pending" | "delivered" | "title"
function R.status(name, q)
	local rec = Q.storage.get(name)
	if not rec.rewarded[q.id] then return "none" end
	for _, p in ipairs(rec.pending) do
		if p.q == q.id then return "pending" end
	end
	if rec.delivered[q.id] or #(q.reward_items or {}) == 0 then return "delivered" end
	return "delivered"
end

function R.grant(name, q)
	local rec = Q.storage.get(name)
	if Q.storage.is_readonly(name) then return false end
	if rec.rewarded[q.id] then return false end       -- journal : jamais deux fois
	rec.rewarded[q.id] = os.time()
	if q.reward.title then rec.titles[q.id] = q.reward.title end
	local items = {}
	for _, s in ipairs(q.reward_items or q.reward.items) do items[#items + 1] = s end
	if #items > 0 then
		rec.pending[#rec.pending + 1] = { q = q.id, items = items, t = os.time() }
	else
		rec.delivered[q.id] = os.time()
	end
	Q.storage.mark_dirty(name)
	Q.storage.flush(name)
	U.log("action", ("récompense de %s attribuée à %s : %s"):format(q.id, name,
		#items > 0 and table.concat(items, ", ") or "(titre/aucun objet)"))
	R.deliver(name)
	return true
end

-- Simule l'ajout de toutes les piles sur une copie de la liste "main".
local function fits_all(inv, items)
	local list = inv:get_list("main")
	if not list then return false end
	local copy = {}
	for i, st in ipairs(list) do copy[i] = ItemStack(st) end
	for _, s in ipairs(items) do
		local left = ItemStack(s)
		for i = 1, #copy do
			if left:is_empty() then break end
			left = copy[i]:add_item(left)
		end
		if not left:is_empty() then return false end
	end
	return true
end

-- Tente de livrer les récompenses en attente, dans l'ordre. Retourne le nombre de livraisons.
function R.deliver(name)
	local player = core.get_player_by_name(name)
	local rec = Q.storage.get(name)
	if #rec.pending == 0 then waiting[name] = nil return 0 end
	if not player or Q.storage.is_readonly(name) then return 0 end
	local inv = player:get_inventory()
	local delivered = 0
	while #rec.pending > 0 do
		local entry = rec.pending[1]
		local valid = {}
		for _, s in ipairs(entry.items or {}) do
			local st = ItemStack(s)
			if U.resolve_item(st:get_name()) then valid[#valid + 1] = st:to_string() end
		end
		if not fits_all(inv, valid) then
			waiting[name] = true
			local now = os.time()
			if (last_full_msg[name] or 0) + 120 <= now then
				last_full_msg[name] = now
				if Q.notify then Q.notify.inventory_full(name, entry.q) end
			end
			break
		end
		-- 1) journal d'abord
		table.remove(rec.pending, 1)
		rec.delivered[entry.q] = os.time()
		Q.storage.mark_dirty(name)
		Q.storage.flush(name)
		-- 2) puis l'inventaire (tout tient : vérifié ci-dessus)
		for _, s in ipairs(valid) do
			local left = inv:add_item("main", s)
			if not left:is_empty() then
				-- ne devrait pas arriver (fits_all) ; on remet le reste en file plutôt que de le perdre
				table.insert(rec.pending, 1, { q = entry.q, items = { left:to_string() }, t = os.time() })
				Q.storage.mark_dirty(name)
				Q.storage.flush(name)
				U.log("warning", "livraison partielle inattendue pour " .. name .. " : reste remis en file")
			end
		end
		delivered = delivered + 1
		U.log("action", ("récompense de %s livrée à %s"):format(entry.q, name))
	end
	if #rec.pending == 0 then waiting[name] = nil end
	if delivered > 0 then
		if Q.notify then Q.notify.delivered(name, delivered) end
		if Q.ui and Q.ui.refresh then Q.ui.refresh(name) end
	end
	return delivered
end

-- Relance périodique, uniquement pour les joueurs ayant une file non vide (coût O(joueurs en attente)).
local timer = 0
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 10 then return end
	timer = 0
	for name in pairs(waiting) do
		if core.get_player_by_name(name) then R.deliver(name) else waiting[name] = nil end
	end
end)

core.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	core.after(3, function()
		if core.get_player_by_name(name) and #Q.storage.get(name).pending > 0 then
			waiting[name] = true
			R.deliver(name)
		end
	end)
end)

core.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	waiting[name] = nil
	last_full_msg[name] = nil
end)

-- Pour les tests
function R._reset_runtime()
	waiting, last_full_msg = {}, {}
end
