-- API publiques simulées des mods tiers que le mod consulte au chargement (smartshop, hangglider, areas).
-- install() AVANT T.env(...) ; clear() après. Les adaptateurs s'y branchent comme sur le serveur.
local M = {}

function M.install()
	local h = { gliding = {}, adds = {} }
	_G.smartshop = { api = { register_on_purchase = function(cb) h.purchase = cb end } }
	_G.hangglider = { is_gliding = function(player) return h.gliding[player:get_player_name()] end }
	_G.areas = { registerOnAdd = function(_, f) h.adds[#h.adds + 1] = f end }
	return h
end

function M.clear()
	_G.smartshop, _G.hangglider, _G.areas = nil, nil, nil
end

-- Exécute f(h) avec les API installées, puis les retire même si f échoue (aucune fuite vers les tests suivants).
function M.with(f)
	local h = M.install()
	local ok, err = pcall(f, h)
	M.clear()
	if not ok then error(err, 0) end
end

return M
