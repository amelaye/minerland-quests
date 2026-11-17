-- Chapitre 5 — Les anneaux du ciel (mod goops_rings, dossier « rings », + 3d_armor).
-- Fonctionnement vérifié (rings/activation.lua, items.lua, effects.lua) : un anneau se porte comme une armure
-- (élément « ring » de 3d_armor) ; l'Anneau d'activation, gardé dans l'inventaire, l'active (clic gauche) pour une
-- durée limitée ; l'Anneau céleste accorde alors temporairement le privilège fly, retiré à la désactivation.
-- Le livre ne donne JAMAIS le privilège fly. Détection : integrations/rings.lua (rings:equip, rings:activate,
-- rings:flight).
local Q = minerland_quests
local LVL1 = { "goops_rings:celestial_ring1", "goops_rings:infernal_ring1", "goops_rings:abyssal_ring1",
	"goops_rings:enlightning_ring1", "goops_rings:hardening_ring1" }
local LVL3 = { "goops_rings:celestial_ring3", "goops_rings:infernal_ring3", "goops_rings:abyssal_ring3",
	"goops_rings:enlightning_ring3", "goops_rings:hardening_ring3" }

Q.register_quest({
	id = "ch05.activation", title = "L'anneau qui les commande", difficulty = 3, icon = "goops_rings:activation_ring",
	description = "Avant tout autre anneau, il te faut l'Anneau d'activation : c'est lui qui réveille la magie.",
	hint = "Recette : 4 pépites d'or aux coins, émeraude, saphir, rubis, améthyste et topaze (gemmes du chapitre 4).",
	trigger = { type = "craft", items = { "goops_rings:activation_ring" } },
	mods = { "goops_rings" },
	reward = { items = { "default:gold_lump 2" } },
})
Q.register_quest({
	id = "ch05.first_ring", title = "Bague au doigt", difficulty = 3, icon = "goops_rings:infernal_ring1",
	description = "Céleste, infernal, abyssal, lumineux ou durci : forge ton premier anneau magique.",
	hint = "Anneau inférieur : argent et or autour de la gemme du modèle choisi (améthyste = céleste, rubis = infernal…).",
	trigger = { type = "craft", items = LVL1 },
	requires = { "ch05.activation" }, mods = { "goops_rings" },
	reward = { items = { "moreores:silver_lump 2" } },
})
Q.register_quest({
	id = "ch05.equip", title = "Comme une armure", difficulty = 2, icon = "goops_rings:abyssal_ring1",
	description = "Un anneau ne fait rien dans ta poche : il se porte, comme une pièce d'armure.",
	objective = "Équiper un anneau dans l'inventaire d'armure.",
	hint = "Ouvre l'onglet Armure de l'inventaire et place l'anneau dans l'emplacement prévu (ou clic droit avec l'anneau en main).",
	trigger = { type = "custom", key = "rings:equip" },
	requires = { "ch05.first_ring" }, mods = { "goops_rings", "3d_armor" },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch05.activate", title = "Que la magie opère", difficulty = 2, icon = "goops_rings:activation_ring",
	description = "Anneau au doigt, Anneau d'activation en main : un clic, et la magie s'éveille pour un temps.",
	objective = "Activer un anneau porté avec l'Anneau d'activation.",
	hint = "Clic gauche avec l'Anneau d'activation. Clic droit pour désactiver. Accroupi : mode automatique / affichage.",
	trigger = { type = "custom", key = "rings:activate" },
	requires = { "ch05.equip" }, mods = { "goops_rings" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch05.celestial", title = "Un éclat du ciel", difficulty = 3, icon = "goops_rings:celestial_ring1",
	description = "L'Anneau céleste, serti d'améthyste, renferme le secret du vol.",
	hint = "Améthystes au centre, argent et or autour. Il existe quatre qualités, de plus en plus durables.",
	trigger = { type = "craft", items = { "goops_rings:celestial_ring1", "goops_rings:celestial_ring2",
		"goops_rings:celestial_ring3", "goops_rings:celestial_ring4" } },
	requires = { "ch05.first_ring" }, mods = { "goops_rings" },
	reward = { items = { "glooptest:amethyst_gem 1" } },
})
Q.register_quest({
	id = "ch05.flight", title = "Les ailes du ciel", difficulty = 3, icon = "goops_rings:celestial_ring2",
	description = "Porte l'Anneau céleste, active-le… et envole-toi ! Attention, le pouvoir ne dure qu'un temps.",
	objective = "Voler grâce à l'Anneau céleste activé.",
	hint = "Une fois activé, appuie sur la touche de vol (K par défaut). Pose-toi avant la fin du compte à rebours !",
	trigger = { type = "custom", key = "rings:flight" },
	requires = { "ch05.celestial", "ch05.activate" }, mods = { "goops_rings" },
	reward = { items = { "default:mese_crystal 1" } },
})
Q.register_quest({
	id = "ch05.superior", title = "Seigneur des anneaux", difficulty = 5, icon = "goops_rings:celestial_ring3", final = true,
	description = "Les anneaux supérieurs, forgés au mithril, durent bien plus longtemps. Un seul pour les gouverner tous ?",
	hint = "Anneau supérieur : mithril autour d'anneaux de qualité normale.",
	trigger = { type = "craft", items = LVL3 },
	requires = { "ch05.flight" }, mods = { "goops_rings" },
	reward = { items = { "default:diamond 1" }, title = "Seigneur des anneaux" },
})
