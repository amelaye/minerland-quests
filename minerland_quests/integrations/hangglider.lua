-- Intégration deltaplane (mod « hangglider », dossier serveur minetest-hangglider).
-- Événement émis : hangglider:glide — le joueur commence à planer.
-- Méthode : lecture lente (toutes les secondes, joueurs connectés) de l'API publique hangglider.is_gliding(player)
-- (hangglider/init.lua:47). Le deltaplane est une entité attachée AU joueur : get_attach() ne sert à rien ici.
local Q = minerland_quests
if not core.get_modpath("hangglider") then return end
if type(hangglider) ~= "table" or type(hangglider.is_gliding) ~= "function" then
	Q.util.log("warning", "hangglider : API is_gliding absente, vols non détectés")
	return
end

Q.compat.declare_integration("hangglider", { keys = { "hangglider:glide" } })

local gliding = {}   -- [joueur] = état lors de la lecture précédente (une émission par envol)

Q.compat.register_poll("hangglider", 1, function(player, name)
	local now = hangglider.is_gliding(player) and true or false
	if now and not gliding[name] then
		Q.events.emit(name, "custom", "hangglider:glide", 1)
	end
	gliding[name] = now
end)

core.register_on_leaveplayer(function(player)
	gliding[player:get_player_name()] = nil
end)
