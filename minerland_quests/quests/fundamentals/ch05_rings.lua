-- Chapitre 5 — Les anneaux du ciel (mod goops_rings, dossier serveur « rings », + 3d_armor).
-- Fonctionnement vérifié dans rings/{items,activation,effects}.lua :
--  * un anneau se porte comme une armure (élément « ring » de 3d_armor, clic droit en main pour l'équiper) ;
--  * l'Anneau d'activation, tenu en main, l'active (clic gauche) pour une durée limitée (15 s × 2^(niveau-1),
--    puis 15 s de recharge) ; en mode automatique il peut aussi rester dans l'inventaire ;
--  * l'Anneau céleste donne TEMPORAIREMENT le privilège fly (retiré à la désactivation) : le livre ne donne jamais fly.
--  * recette niveau 1 : 5 gemmes du même type (améthyste = céleste, rubis = infernal, saphir = abyssal,
--    topaze = lumineux, émeraude = durci) + 2 pépites d'argent + 2 pépites d'or. Les niveaux 2 à 4 exigent 5, 25 puis
--    125 anneaux de niveau 1 : ils ne sont PAS proposés comme quêtes.
-- Détection : integrations/rings.lua (rings:equip, rings:activate, rings:activate_other, rings:flight).
local Q = minerland_quests
local LVL1 = { "goops_rings:celestial_ring1", "goops_rings:infernal_ring1", "goops_rings:abyssal_ring1",
	"goops_rings:enlightning_ring1", "goops_rings:hardening_ring1" }

Q.register_quest({
	id = "ch05.gems", title = "Des pierres pour un anneau", difficulty = 3, icon = "glooptest:amethyst_gem",
	description = "Rubis, saphirs, émeraudes, topazes, améthystes : les gemmes dormant dans les profondeurs sont "
		.. "la matière première de tous les anneaux. Sois-en sûr, il t'en faudra beaucoup !",
	hint = "Cinq gemmes quelconques dans la grille donnent cinq gemmes dépareillées, utilisables pour un Anneau aléatoire.",
	trigger = { type = "craft", items = { "goops_rings:mismatched_gems" } },
	requires = { "ch04.gems" }, mods = { "goops_rings", "glooptest" },
	reward = { items = { "moreores:silver_lump 2" } },
})
Q.register_quest({
	id = "ch05.activation", title = "L'anneau qui les commande", difficulty = 3, icon = "goops_rings:activation_ring",
	description = "Avant tout autre anneau, il te faut l'Anneau d'activation : c'est lui qui réveille la magie.",
	hint = "Recette : 4 pépites d'or aux coins, et une émeraude, un saphir, un rubis, une améthyste et une topaze.",
	trigger = { type = "craft", items = { "goops_rings:activation_ring" } },
	requires = { "ch04.gems" }, mods = { "goops_rings" },
	reward = { items = { "default:gold_lump 2" } },
})
Q.register_quest({
	id = "ch05.first_ring", title = "Bague au doigt", difficulty = 3, icon = "goops_rings:infernal_ring1",
	description = "Céleste, infernal, abyssal, lumineux ou durci : forge ton premier anneau magique.",
	hint = "5 gemmes du même type (améthyste = céleste, rubis = infernal, saphir = abyssal, topaze = lumineux, "
		.. "émeraude = durci), 2 pépites d'argent et 2 pépites d'or.",
	trigger = { type = "craft", items = LVL1 },
	requires = { "ch04.gems" }, mods = { "goops_rings" },
	reward = { items = { "default:gold_lump 2" } },
})
Q.register_quest({
	id = "ch05.equip", title = "Comme une armure", difficulty = 2, icon = "goops_rings:abyssal_ring1",
	description = "Un anneau ne fait rien dans ta poche : il se porte, comme une pièce d'armure.",
	objective = "Équiper un anneau dans l'inventaire d'armure.",
	hint = "Clic droit avec l'anneau en main, ou place-le dans l'emplacement d'anneau de l'onglet Armure.",
	trigger = { type = "custom", key = "rings:equip" },
	requires = { "ch05.first_ring" }, mods = { "goops_rings", "3d_armor" },
	reward = { items = { "default:mese_crystal_fragment 4" } },
})
Q.register_quest({
	id = "ch05.activate", title = "Que la magie opère", difficulty = 2, icon = "goops_rings:activation_ring",
	description = "Anneau au doigt, Anneau d'activation en main : un clic, et la magie s'éveille pour un temps.",
	objective = "Activer un anneau porté avec l'Anneau d'activation.",
	hint = "Tiens l'Anneau d'activation et fais un clic gauche. Clic droit pour désactiver. Accroupi + clic gauche : "
		.. "mode automatique.",
	trigger = { type = "custom", key = "rings:activate" },
	requires = { "ch05.equip", "ch05.activation" }, mods = { "goops_rings" },
	reward = { items = { "default:gold_ingot 1" } },
})
Q.register_quest({
	id = "ch05.celestial", title = "Un éclat du ciel", difficulty = 3, icon = "goops_rings:celestial_ring1",
	description = "L'Anneau céleste, serti d'améthystes, renferme le secret du vol.",
	hint = "Cinq améthystes, deux pépites d'argent et deux pépites d'or.",
	trigger = { type = "craft", items = { "goops_rings:celestial_ring1" } },
	requires = { "ch05.first_ring" }, mods = { "goops_rings" },
	reward = { items = { "glooptest:amethyst_gem 1" } },
})
Q.register_quest({
	id = "ch05.flight", title = "Les ailes du ciel", difficulty = 3, icon = "goops_rings:celestial_ring1",
	description = "Porte l'Anneau céleste, active-le… et envole-toi ! Attention, le pouvoir ne dure qu'un temps.",
	objective = "Voler grâce à l'Anneau céleste activé.",
	hint = "Une fois l'anneau activé, appuie sur la touche de vol (K par défaut). Repose-toi avant la fin du compte "
		.. "à rebours : il retire le vol à la désactivation !",
	trigger = { type = "custom", key = "rings:flight" },
	requires = { "ch05.celestial", "ch05.activate" }, mods = { "goops_rings" },
	reward = { items = { "default:mese_crystal 1" } },
})
Q.register_quest({
	id = "ch05.other_power", title = "Un pouvoir de plus", difficulty = 4, icon = "goops_rings:enlightning_ring1",
	final = true,
	description = "Résister au feu, respirer sous l'eau, briller dans la nuit, frapper comme le fer : un second "
		.. "anneau, un second pouvoir. Les vrais maîtres des anneaux en portent plusieurs.",
	objective = "Activer un anneau qui n'est pas l'Anneau céleste (infernal, abyssal, lumineux ou durci).",
	hint = "Fabrique un anneau d'un autre type puis active-le avec l'Anneau d'activation.",
	trigger = { type = "custom", key = "rings:activate_other" },
	requires = { "ch05.flight" }, mods = { "goops_rings" },
	reward = { items = { "default:diamond 1" }, title = "Seigneur des anneaux" },
})
