-- Chapitre 9 — Les affaires sont les affaires (currency, smartshop). Audit : docs/audit/ch06_ch09.md.
-- Le Minegeld arrive aussi sans commerce (revenu de base automatique, dons) : aucune quête ne valide sur la
-- possession d'argent. Les ventes Smartshop sont détectées par l'API publique smartshop.api.register_on_purchase
-- (integrations/smartshop.lua) ; l'achat dans sa propre boutique et les articles gratuits ne comptent pas.
-- Non détectables (pas d'API) : échange en boutique currency, troc, paiement farebox.
local Q = minerland_quests

Q.register_quest({
	id = "ch09.small_change", title = "Faire de la monnaie", difficulty = 1, icon = "currency:minegeld",
	description = "Un billet de 5, ça ne se coupe pas en deux… mais ça se change ! Apprends à faire ta monnaie.",
	hint = "Un billet de 5 Minegeld seul dans la grille donne cinq billets de 1.",
	trigger = { type = "craft", items = { "currency:minegeld" } },
	mods = { "currency" },
	reward = { items = { "currency:minegeld_5 2" } },
})
Q.register_quest({
	id = "ch09.safe_keeping", title = "Un coffre pour mes économies", difficulty = 2, icon = "currency:safe",
	description = "Les économies d'une vie méritent mieux qu'un coffre de bois : il leur faut un vrai coffre-fort.",
	hint = "Huit lingots d'acier et un cristal de Mese.",
	trigger = { type = "craft", items = { "currency:safe" } },
	requires = { "ch09.small_change" }, mods = { "currency" },
	reward = { items = { "currency:minegeld_10 1" } },
})
Q.register_quest({
	id = "ch09.safe_installed", title = "Le coffre est scellé", difficulty = 1, icon = "currency:safe",
	description = "Pose ton coffre-fort : il n'obéira qu'à toi.",
	trigger = { type = "place", items = { "currency:safe" } },
	requires = { "ch09.safe_keeping" }, mods = { "currency" },
	reward = { items = { "default:steel_ingot 2" } },
})
Q.register_quest({
	id = "ch09.market_stall", title = "Mon étal d'échange", difficulty = 2, icon = "currency:shop",
	description = "Un panneau, un coffre verrouillé : l'étal d'échange permet de troquer tes marchandises contre "
		.. "celles des passants.",
	hint = "Un panneau mural et un coffre verrouillé.",
	trigger = { type = "place", items = { "currency:shop" } },
	requires = { "ch09.small_change" }, mods = { "currency" },
	reward = { items = { "default:sign_wall_wood 2" } },
})
Q.register_quest({
	id = "ch09.smart_crafter", title = "La boutique intelligente", difficulty = 2, icon = "smartshop:shop",
	description = "Le Smartshop vend tout seul, même quand tu dors. Le rêve de tout marchand !",
	hint = "Quatre coffres verrouillés, quatre panneaux en bois et une torche.",
	trigger = { type = "craft", items = { "smartshop:shop" } },
	mods = { "smartshop" },
	reward = { items = { "default:chest_locked 1" } },
})
Q.register_quest({
	id = "ch09.shop_opening", title = "Ouverture officielle", difficulty = 2, icon = "smartshop:shop",
	description = "Pose ta boutique, remplis-la et fixe tes prix : le commerce est ouvert !",
	hint = "Clic droit sur la boutique pour choisir ce que tu vends et à quel prix.",
	trigger = { type = "place", items = { "smartshop:shop" } },
	requires = { "ch09.smart_crafter" }, mods = { "smartshop" },
	reward = { items = { "currency:minegeld_10 2" } },
})
Q.register_quest({
	id = "ch09.first_purchase", title = "Première affaire conclue", difficulty = 2, icon = "currency:minegeld_10",
	description = "Fais tes emplettes chez un autre marchand de Minerland : c'est ainsi que vit l'économie du royaume.",
	objective = "Acheter un article payant dans le Smartshop d'un autre joueur.",
	hint = "Les achats dans ta propre boutique ne comptent pas.",
	trigger = { type = "custom", key = "smartshop:purchase" },
	requires = { "ch09.small_change" }, mods = { "smartshop" },
	reward = { items = { "currency:minegeld_10 1" } },
})
Q.register_quest({
	id = "ch09.first_sale", title = "Le client est roi", difficulty = 3, icon = "smartshop:shop", final = true,
	description = "Un client a acheté dans ta boutique ! Ta réputation de marchand est lancée.",
	objective = "Vendre un article payant à un autre joueur dans ton Smartshop, pendant que tu es en ligne.",
	hint = "La vente n'est comptée que si tu es en ligne au moment de l'achat.",
	trigger = { type = "custom", key = "smartshop:sale" },
	requires = { "ch09.shop_opening" }, mods = { "smartshop" },
	reward = { items = { "currency:minegeld_50 1" }, title = "Sens des affaires" },
})
