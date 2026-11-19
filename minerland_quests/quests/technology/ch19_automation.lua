-- Chapitre 19 — Les machines intelligentes (mesecons, digilines, pipeworks, digtron). Audit : docs/audit/ch19.md.
-- Circuits, cerveau programmable, tri pneumatique et foreuse : la pose des pièces est détectable ; leur
-- fonctionnement (propagation des signaux, messages digiline, tri, creusement par Digtron) se fait sans joueur et
-- n'émet rien. Règle serveur : quantité 1, une seule petite foreuse (tunnel de 10 × 10 au plus).
local Q = minerland_quests

Q.register_quest({
	id = "ch19.first_wire", title = "Le fil d'Ariane du mese", difficulty = 1, icon = "mesecons:wire_00000000_off",
	description = "Le fil de Mese transporte les signaux d'une machine à l'autre. Pose ton premier circuit.",
	hint = "Le fil s'obtient en cuisant un cristal de Mese au four.",
	trigger = { type = "place", items = { "mesecons:wire_00000000_off" } },
	mods = { "mesecons" },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch19.first_lamp", title = "Et la lumière fut (presque)", difficulty = 1, icon = "mesecons_lamp:lamp_off",
	description = "Une lampe reliée à un interrupteur : ton premier circuit commandé !",
	trigger = { type = "place", items = { "mesecons_lamp:lamp_off" } },
	requires = { "ch19.first_wire" }, mods = { "mesecons_lamp" },
	reward = { items = { "default:glass 4" } },
})
Q.register_quest({
	id = "ch19.piston", title = "Pousse-toi de là !", difficulty = 2, icon = "mesecons_pistons:piston_normal_off",
	description = "Le piston pousse les blocs sur commande : portes secrètes et mécanismes en tous genres t'attendent.",
	trigger = { type = "place", items = { "mesecons_pistons:piston_normal_off" } },
	requires = { "ch19.first_wire" }, mods = { "mesecons_pistons" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch19.sorting_tube", title = "Le grand tri", difficulty = 3, icon = "pipeworks:mese_tube_000000",
	description = "Le tube trieur oriente chaque objet vers la bonne sortie. Fini le rangement à la main !",
	trigger = { type = "place", items = { "pipeworks:mese_tube_000000" } },
	requires = { "ch19.first_wire" }, mods = { "pipeworks" },
	reward = { items = { "default:steel_ingot 3" } },
})
Q.register_quest({
	id = "ch19.digtron", title = "Le cœur de la foreuse", difficulty = 3, icon = "digtron:controller",
	description = "Le contrôleur pilote la foreuse Digtron. Une petite foreuse, un tunnel raisonnable : la Reine veille !",
	hint = "Quatre cristaux de Mese. Les tunnels ne doivent pas dépasser 10 blocs sur 10.",
	trigger = { type = "place", items = { "digtron:controller" } },
	requires = { "ch19.first_wire" }, mods = { "digtron" },
	reward = { items = { "default:torch 12" } },
})
Q.register_quest({
	id = "ch19.silicon_brain", title = "Un cerveau de sable et de mese", difficulty = 3,
	icon = "mesecons_luacontroller:luacontroller0000",
	description = "Le contrôleur programmable exécute ton propre programme : tes machines savent enfin réfléchir.",
	hint = "Quatre plaquettes de silicium et des conducteurs de Mese.",
	trigger = { type = "craft", items = { "mesecons_luacontroller:luacontroller0000" } },
	requires = { "ch19.first_lamp" }, mods = { "mesecons_luacontroller" },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch19.digiline_screen", title = "Le tableau d'affichage", difficulty = 3, icon = "digilines:lcd", final = true,
	description = "Un écran digiline affiche les messages de tes machines. Ton installation a désormais la parole !",
	trigger = { type = "place", items = { "digilines:lcd" } },
	requires = { "ch19.silicon_brain", "ch19.piston" }, mods = { "digilines" },
	reward = { items = { "default:gold_ingot 2" }, title = "Esprit logique" },
})
