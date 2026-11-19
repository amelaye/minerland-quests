-- Chapitre 10 — Sur les chapeaux de roues ! (bike, vehicles, automobiles_pck, biofuel). Audit : docs/audit/ch10.md.
-- Poser un véhicule crée une entité (aucun événement de pose) et faire le plein n'émet rien : la progression repose
-- sur la fabrication et, via integrations/rides.lua, sur le fait de monter à bord (conducteur seulement pour les
-- voitures). Véhicules armés de « vehicles » exclus.
local Q = minerland_quests

-- Voitures civiles de « vehicles » (objets <entité>_spawner, docs/audit/verified_ch10.txt)
local CITY_CARS = {}
for _, v in ipairs({ "masda", "masda2", "ute", "ute2", "nizzan", "nizzan2", "astonmaaton", "pooshe", "pooshe2",
	"lambogoni", "lambogoni2", "fewawi", "fewawi2", "musting", "musting2", "tractor", "geep" }) do
	CITY_CARS[#CITY_CARS + 1] = "vehicles:" .. v .. "_spawner"
end
-- Automobiles d'APercy (automobiles_pck), objet = entité
local AUTOMOBILES = { "automobiles_roadster:roadster", "automobiles_buggy:buggy", "automobiles_beetle:beetle",
	"automobiles_beetle:beetle_conv", "automobiles_catrelle:catrelle", "automobiles_coupe:coupe",
	"automobiles_delorean:delorean", "automobiles_trans_am:trans_am", "automobiles_motorcycle:motorcycle",
	"automobiles_vespa:vespa" }

Q.register_quest({
	id = "ch10.first_bike", title = "Deux roues et un guidon", difficulty = 1, icon = "bike:bike",
	description = "Le vélo : silencieux, écologique et toujours prêt. Le premier véhicule de tout bon citoyen.",
	trigger = { type = "craft", items = { "bike:bike" } },
	mods = { "bike" },
	reward = { items = { "default:tin_ingot 3" } },
})
Q.register_quest({
	id = "ch10.bike_ride", title = "En selle, Marcel !", difficulty = 1, icon = "bike:bike",
	description = "Pose ton vélo, enfourche-le et file sur les chemins. Le vent dans les cheveux, ça n'a pas de prix.",
	objective = "Monter sur un vélo.",
	hint = "Pose le vélo au sol puis clic droit pour monter.",
	trigger = { type = "custom", key = "rides:bike" },
	requires = { "ch10.first_bike" }, mods = { "bike" },
	reward = { items = { "biofuel:phial_fuel 2" } },
})
Q.register_quest({
	id = "ch10.city_car", title = "Ma première citadine", difficulty = 2, icon = "vehicles:masda_spawner",
	description = "Une petite voiture sans carburant, idéale pour apprendre à conduire en ville.",
	trigger = { type = "craft", items = CITY_CARS },
	requires = { "ch10.first_bike" }, mods = { "vehicles" },
	reward = { items = { "default:steel_ingot 4" } },
})
Q.register_quest({
	id = "ch10.engine", title = "Le cœur de la machine", difficulty = 3, icon = "automobiles_lib:engine",
	description = "Toute vraie automobile commence par un moteur. Celui-ci demande de l'acier… et un bloc de Mese.",
	hint = "Lingots et blocs d'acier, plus un bloc de Mese.",
	trigger = { type = "craft", items = { "automobiles_lib:engine" } },
	requires = { "ch10.city_car" }, mods = { "automobiles_lib" },
	reward = { items = { "default:steelblock 1" } },
})
Q.register_quest({
	id = "ch10.first_car", title = "La doyenne des routes", difficulty = 3, icon = "automobiles_roadster:roadster",
	description = "Roadster aux roues de bois, coccinelle, 4L, Vespa ou DeLorean : assemble ta première automobile.",
	hint = "Le roadster est le moins cher : roues en bois, carrosserie et moteur.",
	trigger = { type = "craft", items = AUTOMOBILES },
	requires = { "ch10.engine" }, mods = { "automobiles_lib" },
	reward = { items = { "biofuel:bottle_fuel 2" } },
})
Q.register_quest({
	id = "ch10.road_trip", title = "Plein phares sur la départementale", difficulty = 3, icon = "automobiles_vespa:vespa",
	description = "Pose ta voiture, prends le volant et en route ! Une automobile ne roule qu'avec du carburant.",
	objective = "Conduire une voiture.",
	hint = "Seul le propriétaire conduit. Pour faire le plein, frappe la voiture avec le carburant en main.",
	trigger = { type = "custom", key = "rides:car" },
	requires = { "ch10.first_car" },
	reward = { items = { "default:glass 4" } },
})
Q.register_quest({
	id = "ch10.refinery", title = "L'alambic vert", difficulty = 2, icon = "biofuel:refinery",
	description = "Feuilles, brindilles et récoltes deviennent biocarburant dans la raffinerie. Rouler vert, c'est "
		.. "possible !",
	hint = "Six lingots d'étain et trois blocs de verre.",
	trigger = { type = "place", items = { "biofuel:refinery" } },
	mods = { "biofuel" },
	reward = { items = { "default:sapling 10" } },
})
Q.register_quest({
	id = "ch10.fuel_can", title = "Un bidon pour la route", difficulty = 2, icon = "biofuel:fuel_can",
	description = "Un bidon plein, c'est un plein complet de voiture. Indispensable avant un long voyage.",
	hint = "Neuf bouteilles de biocarburant (ou d'autres carburants du même groupe).",
	trigger = { type = "craft", items = { "biofuel:fuel_can" } },
	requires = { "ch10.refinery" }, mods = { "biofuel" },
	reward = { items = { "biofuel:phial_fuel 4" } },
})
Q.register_quest({
	id = "ch10.delivery_van", title = "La 4L fourgonnette", difficulty = 4, icon = "automobiles_catrelle:catrelle_4f",
	final = true,
	description = "La légendaire fourgonnette, pour livrer tes voisins aux quatre coins du royaume.",
	hint = "Elle se fabrique à partir d'une 4L (Catrelle), de verre et d'un bloc d'acier.",
	trigger = { type = "craft", items = { "automobiles_catrelle:catrelle_4f" } },
	requires = { "ch10.road_trip", "ch10.fuel_can" }, mods = { "automobiles_catrelle" },
	reward = { items = { "default:steelblock 1" }, title = "As du volant" },
})
