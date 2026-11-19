-- Intégration Smartshop (mod « smartshop », dossier serveur luanti-smartshop).
-- Événements émis :
--   smartshop:purchase — un joueur achète un article PAYANT dans la boutique d'un AUTRE joueur
--   smartshop:sale     — le propriétaire de cette boutique vient de vendre (seulement s'il est connecté)
-- Méthode : API publique smartshop.api.register_on_purchase(callback(player, shop, i)), appelée après un achat
-- réussi (smartshop/api/purchase_mechanics.lua:23,65-70). Exclus : achat dans sa propre boutique (« vue client »,
-- shop_class.lua:530-533) et article gratuit (get_pay_stack vide). Limite : comptes complices.
local Q = minerland_quests
if not core.get_modpath("smartshop") then return end
if type(smartshop) ~= "table" or type(smartshop.api) ~= "table"
		or type(smartshop.api.register_on_purchase) ~= "function" then
	Q.util.log("warning", "smartshop : API register_on_purchase absente, ventes non détectées")
	return
end

Q.compat.declare_integration("smartshop", { keys = { "smartshop:purchase", "smartshop:sale" } })

smartshop.api.register_on_purchase(function(player, shop, i)
	local ok, err = pcall(function()
		local buyer = Q.events.real_player(player)
		if not buyer or type(shop) ~= "table" then return end
		local owner = shop.get_owner and shop:get_owner() or nil
		if type(owner) ~= "string" or owner == "" or owner == buyer then return end
		local pay = shop.get_pay_stack and shop:get_pay_stack(i) or nil
		if not pay or pay:is_empty() then return end
		Q.events.emit(buyer, "custom", "smartshop:purchase", 1)
		if core.get_player_by_name(owner) then
			Q.events.emit(owner, "custom", "smartshop:sale", 1)
		end
	end)
	if not ok then Q.util.log("error", "intégration smartshop : " .. tostring(err)) end
end)
