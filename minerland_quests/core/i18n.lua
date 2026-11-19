-- Langues du Grand Livre.
--
-- Le FRANÇAIS est la langue source : les textes du code et des données de quêtes sont écrits en français.
-- Les autres langues viennent des fichiers locale/minerland_quests.<code>.tr (format Luanti), tenus à jour par
-- tools/i18n.py (extraction, fusion, contrôle des traductions manquantes).
--
-- Deux façons de traduire :
--   * I.S("texte", ...)       : balisage Luanti traduit par le CLIENT. Pour les textes enregistrés une fois pour
--                               tous les joueurs (descriptions d'objets, infotexts, commandes, privilèges) ;
--   * I.tr(nom, "texte", ...) : traduction CÔTÉ SERVEUR pour un joueur (core.get_translated_string). Pour l'interface
--                               du livre, le chat et le HUD : le texte obtenu peut être tronqué, mesuré et échappé.
-- I.N("texte") ne fait rien : il signale à l'outil d'extraction un libellé rangé dans une table.
-- Les paramètres s'écrivent @1 … @9 (dans l'ordre dans le texte source ; la traduction peut les réordonner).
local Q = minerland_quests
local I = {}
Q.i18n = I

I.DOMAIN = "minerland_quests"
I.SOURCE = "fr"
I.S = core.get_translator(I.DOMAIN)
Q.S = I.S

function I.N(s)
	return s
end

-- Langues disponibles : la langue source + chaque fichier locale/minerland_quests.<code>.tr présent.
I.available = { [I.SOURCE] = true }
for _, f in ipairs(core.get_dir_list(Q.modpath .. "/locale", false) or {}) do
	local code = f:match("^" .. I.DOMAIN .. "%.([%w_]+)%.tr$")
	if code then I.available[code] = true end
end

local function supported(code)
	code = tostring(code or ""):lower():gsub("%-", "_")
	if I.available[code] then return code end
	local base = code:match("^(%a+)_")
	if base and I.available[base] then return base end
	return nil
end

local chosen = {}   -- [joueur] = code de langue retenu (cache vidé à la déconnexion)

-- Langue d'un joueur : celle de son client si elle est traduite ; le français si le client n'en annonce aucune ;
-- sinon la langue de repli (réglage minerland_quests.fallback_language, « en » par défaut).
function I.lang(name)
	if not name then return I.SOURCE end
	local l = chosen[name]
	if l then return l end
	local info = core.get_player_information and core.get_player_information(name)
	local code = info and info.lang_code or ""
	l = supported(code)
	if not l then
		if code == "" then
			l = I.SOURCE
		else
			l = supported(core.settings:get("minerland_quests.fallback_language") or "en") or I.SOURCE
		end
	end
	if info then chosen[name] = l end   -- pas de cache pour un joueur hors ligne
	return l
end

core.register_on_leaveplayer(function(player)
	chosen[player:get_player_name()] = nil
end)

-- Texte traduit pour un joueur. Les paramètres sont convertis en chaînes. Une chaîne vide reste vide.
function I.tr(name, str, ...)
	if str == nil or str == "" then return "" end
	local n = select("#", ...)
	if n == 0 then
		return core.get_translated_string(I.lang(name), I.S(str))
	end
	local args = { ... }
	for i = 1, n do args[i] = tostring(args[i] == nil and "" or args[i]) end
	return core.get_translated_string(I.lang(name), I.S(str, unpack(args, 1, n)))
end

-- Nom affichable d'un objet dans la langue du joueur (première ligne de la description, sans couleurs).
function I.item_name(name, item)
	local def = core.registered_items[item]
	if not def then return item end
	local d = def.short_description
	if not d or d == "" then d = def.description end
	if not d or d == "" then return item end
	d = core.strip_colors(core.get_translated_string(I.lang(name), d))
	return d:match("^[^\n]*") or d
end

-- Date courte dans la convention de la langue du joueur (jj/mm/aaaa en français).
function I.date(name, t)
	if not t or t == 0 then return "" end
	return I.tr(name, "@1/@2/@3", os.date("%d", t), os.date("%m", t), os.date("%Y", t))
end

-- Texture propre à une langue quand elle existe (ex. couverture : mlq_cover.png, mlq_cover_en.png).
I.localized_textures = { mlq_cover = { en = true } }
function I.texture(name, base)
	local l = I.lang(name)
	local variants = I.localized_textures[base]
	if variants and variants[l] then return base .. "_" .. l .. ".png" end
	return base .. ".png"
end
