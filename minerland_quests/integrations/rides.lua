-- Intégration générique « monter à bord » : véhicules, montures, cabines et sièges.
-- Événement émis : rides:<famille> quand un joueur est attaché (set_attach) à une entité connue :
--   horse, wyvern, dinosaur, bike, car, train, metro, ferry, aviation, boat, chairlift, elevator.
-- Méthode : API moteur seulement — lecture lente (toutes les 2 s, joueurs connectés) de player:get_attach() puis du nom
-- de l'entité parente. Aucune fonction d'un autre mod n'est remplacée ni appelée. Sources : docs/audit/ch06_ch09.md,
-- ch10.md, ch11_ch12_ch15.md, ch13_ch14.md, ch22_ch23.md (§ « monter à bord »).
-- Sièges intermédiaires (automobiles, avions airutils, bateau à moteur, chalutier) : le joueur est attaché à un siège
-- lui-même attaché au véhicule, on remonte donc d'un niveau, comme le font ces mods eux-mêmes.
-- Trains : seules les voitures de VOYAGEURS sont listées (le conducteur, privilégié, est attaché de la même façon).
-- Voitures : seul le conducteur compte quand le mod l'indique (automobiles : driver_name ; vehicles : driver).
-- Pour les autres familles, conducteur et passager ne sont pas distingués : « monter à bord » suffit.
local Q = minerland_quests

local FAMILY = {
	["mob_horse:horse"] = "horse",
	["draconis:jungle_wyvern"] = "wyvern",
	["paleotest:triceratops"] = "dinosaur",
	["paleotest:tyrannosaurus"] = "dinosaur",
	["paleotest:quetzalcoatlus"] = "dinosaur",
	["bike:bike"] = "bike",
	["advtrains:wagon_default"] = "train",
	["advtrains:wagon_japan"] = "train",
	["advtrains:wagon_zugspitzbahn"] = "train",
	["advtrains:wagon_compartment"] = "train",
	["advtrains:moretrains_silberling"] = "train",
	["advtrains:subway_wagon"] = "metro",
	["minitram_konstal_105:minitram_konstal_105_normal"] = "metro",
	["advtrains_train_jpntlr600:front_unit"] = "metro",
	["advtrains:bus"] = "metro",
	["advtrains:boat"] = "ferry",
	["ju52:ju52"] = "aviation",
	["pa28:pa28"] = "aviation",
	["supercub:supercub"] = "aviation",
	["hidroplane:hidro"] = "aviation",
	["motorboat:boat"] = "boat",
	["fishing_boat:boat"] = "boat",
	["nautilus:boat"] = "boat",
	["chair_lift:seat"] = "chairlift",
	["celevator:player_holder"] = "elevator",
	["elevator:box"] = "elevator",
}
for _, n in ipairs({ "automobiles_roadster:roadster", "automobiles_buggy:buggy", "automobiles_beetle:beetle",
	"automobiles_beetle:beetle_conv", "automobiles_catrelle:catrelle", "automobiles_catrelle:catrelle_4f",
	"automobiles_coupe:coupe", "automobiles_delorean:delorean", "automobiles_trans_am:trans_am",
	"automobiles_motorcycle:motorcycle", "automobiles_vespa:vespa" }) do
	FAMILY[n] = "car"
end
for _, v in ipairs({ "masda", "masda2", "ute", "ute2", "nizzan", "nizzan2", "astonmaaton", "pooshe", "pooshe2",
	"lambogoni", "lambogoni2", "fewawi", "fewawi2", "musting", "musting2", "tractor", "geep", "policecar", "ambulance",
	"firetruck" }) do
	FAMILY["vehicles:" .. v] = "car"
end

local SEATS = {
	["automobiles_lib:pivot_mesh"] = true,
	["airutils:seat_base"] = true,
	["motorboat:seat_base"] = true,
	["fishing_boat:stand_base"] = true,
}

local function is_driver(ent, name, player)
	if ent.driver_name ~= nil then return ent.driver_name == name end
	if ent.driver ~= nil then return ent.driver == player or ent.driver == name end
	return true   -- champ absent (autre version du mod) : impossible de distinguer, on accepte
end
local CHECK = { car = is_driver }

local keys, seen = {}, {}
for _, fam in pairs(FAMILY) do
	if not seen[fam] then
		seen[fam] = true
		keys[#keys + 1] = "rides:" .. fam
	end
end
table.sort(keys)
Q.compat.declare_integration("rides", { keys = keys })

-- Entité (luaentity) à bord de laquelle se trouve le joueur, siège intermédiaire franchi.
local function vehicle_of(player)
	local parent = player:get_attach()
	if not parent then return nil end
	local ent = parent:get_luaentity()
	if ent and SEATS[ent.name] then
		local up = parent:get_attach()
		ent = up and up:get_luaentity() or nil
	end
	return ent
end

local counted = {}   -- [joueur] = entité déjà comptée (pas de nouvelle émission tant qu'il reste à bord)

Q.compat.register_poll("rides", 2, function(player, name)
	local ent = vehicle_of(player)
	if not ent then
		counted[name] = nil
		return
	end
	if counted[name] == ent then return end
	local fam = type(ent.name) == "string" and FAMILY[ent.name] or nil
	if not fam then
		counted[name] = ent   -- entité inconnue : rien à émettre
		return
	end
	local check = CHECK[fam]
	if check and not check(ent, name, player) then return end   -- passager : nouvel essai au prochain passage
	counted[name] = ent
	Q.events.emit(name, "custom", "rides:" .. fam, 1)
end)

core.register_on_leaveplayer(function(player)
	counted[player:get_player_name()] = nil
end)

Q.compat.rides_family = FAMILY   -- lecture seule (tests, diagnostic)
