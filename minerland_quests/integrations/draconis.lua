-- Intégration draconis : butin d'un dragon vaincu.
-- Événements émis :
--   draconis:scales_pickup — un joueur ramasse des écailles de dragon (draconis:scales_<feu|glace>_dragon_<couleur>)
--   draconis:egg_pickup    — un joueur ramasse un œuf de dragon (draconis:egg_<feu|glace>_<couleur>)
-- Méthode : callback public du moteur core.register_on_item_pickup (builtin/game/item.lua:383, appelé au
-- clic gauche sur l'objet au sol). Le dragon mort reste au sol ; chaque clic droit sur lui fait tomber une
-- part du butin (draconis.dragon_rightclick et drop_items, api/api.lua:315,2197) : écailles chez l'adulte,
-- œuf une fois sur six chez l'adulte sauvage (set_drops, :1096-1127). Aucune fonction du mod n'est touchée.
-- Choix de l'administratrice (20/11/2026) : ramasser à la main valide la quête, quelle que soit l'origine
-- de l'objet au sol (tuyau, mort d'un joueur, mécanique de draconis…). Seuls cas écartés : objet jeté par
-- un joueur (`dropped_by`, builtin/game/item.lua:375), faux joueur, inventaire plein (rien n'est ramassé).
local Q = minerland_quests
if not core.get_modpath("draconis") then return end
if type(core.register_on_item_pickup) ~= "function" then
	Q.util.log("warning", "draconis : core.register_on_item_pickup absent, butin des dragons non détecté")
	return
end

Q.compat.declare_integration("draconis", { keys = { "draconis:scales_pickup", "draconis:egg_pickup" } })

-- Les anciens noms draconis:egg_<type>_dragon_<couleur> sont des alias des œufs (init.lua:171-176) : résolus ici.
local function kind_of(itemname)
	local n = Q.util.resolve_item(itemname)
	if not n then return nil end
	if n:find("^draconis:scales_") then return "draconis:scales_pickup" end
	if n:find("^draconis:egg_[a-z]+_[a-z_]+$") then return "draconis:egg_pickup" end
	return nil
end

core.register_on_item_pickup(function(itemstack, picker, pointed_thing)
	local ok, err = pcall(function()
		local key = itemstack and kind_of(itemstack:get_name())
		if not key then return end
		local name = Q.events.real_player(picker)
		if not name then return end
		local ref = pointed_thing and pointed_thing.ref
		local ent = ref and ref.get_luaentity and ref:get_luaentity() or nil
		if ent and ent.dropped_by ~= nil then return end   -- jeté par un joueur
		-- un seul objet suffit : le moteur ramasse ce qui rentre (inventaire plein : l'objet reste au sol)
		local inv = picker:get_inventory()
		if not inv or not inv:room_for_item("main", itemstack:get_name()) then return end
		Q.events.emit(name, "custom", key, 1)
	end)
	if not ok then Q.util.log("error", "intégration draconis : " .. tostring(err)) end
	return nil   -- ne jamais court-circuiter le ramassage normal
end)
