-- Thème graphique : couleurs, textures et petites briques formspec réutilisables.
local Q = minerland_quests
local N = Q.i18n.N
local T = {}
Q.theme = T

T.color = {
	parchment = "#f3e6c4",
	ink = "#3b2412",
	ink_soft = "#6b4a2b",
	bronze = "#a0702a",
	gold = "#e8b84a",
	green = "#3f9a43",
	grey = "#8a8a8a",
	brick = "#a0523d",
	blue = "#3d6fa3",
}

T.state_color = {
	available = T.color.gold,
	done = T.color.green,
	locked = T.color.grey,
	unavailable = T.color.brick,
}

-- Teintes de TEXTE lisibles sur le papier clair (contraste ≥ 4,5:1) ; les couleurs d'état servent aux cadres.
T.state_text_color = {
	available = "#94640f",
	done = "#2e7a32",
	locked = "#6b6b6b",
	unavailable = "#a0523d",
}

-- Libellés SOURCE (français) : les vues les traduisent pour le joueur avec Q.i18n.tr.
T.state_label = {
	available = N("Disponible"),
	done = N("Terminée"),
	locked = N("Verrouillée"),
	unavailable = N("Indisponible"),
}

T.difficulty_label = { N("Facile"), N("Accessible"), N("Intermédiaire"), N("Avancée"), N("Expert") }

-- Échappement obligatoire de tout texte dynamique.
function T.esc(s)
	return core.formspec_escape(tostring(s or ""))
end
local esc = T.esc

function T.n(v)
	-- nombres compacts et stables pour les formspecs
	return string.format("%.3f", v):gsub("0+$", ""):gsub("%.$", "")
end
local n = T.n

function T.colored(color, text)
	return core.colorize(color, text)
end

function T.label(x, y, text, color)
	return ("label[%s,%s;%s]"):format(n(x), n(y), esc(core.colorize(color or T.color.ink, text)))
end

-- Titre de vue : police grasse et agrandie, puis retour au style normal pour les libellés suivants.
function T.title(x, y, text)
	return "style_type[label;font=bold;font_size=*1.3]" .. T.label(x, y, text, T.color.ink)
		.. "style_type[label;font=normal;font_size=*1]"
end

function T.image(x, y, w, h, tex)
	return ("image[%s,%s;%s,%s;%s]"):format(n(x), n(y), n(w), n(h), esc(tex))
end

function T.box(x, y, w, h, color)
	return ("box[%s,%s;%s,%s;%s]"):format(n(x), n(y), n(w), n(h), color)
end

function T.item_image(x, y, w, h, item)
	return ("item_image[%s,%s;%s,%s;%s]"):format(n(x), n(y), n(w), n(h), esc(item))
end

function T.textarea(x, y, w, h, text)
	-- nom vide => texte en lecture seule, avec défilement si nécessaire
	return ("textarea[%s,%s;%s,%s;;;%s]"):format(n(x), n(y), n(w), n(h), esc(text))
end

function T.tooltip(field, text)
	return ("tooltip[%s;%s;#f3e6c4;#3b2412]"):format(field, esc(text))
end

function T.tooltip_area(x, y, w, h, text)
	return ("tooltip[%s,%s;%s,%s;%s;#f3e6c4;#3b2412]"):format(n(x), n(y), n(w), n(h), esc(text))
end

-- Bouton de style « cuir et bronze ».
function T.button(x, y, w, h, name, text, variant)
	local bg = variant == "gold" and "mlq_btn_gold" or "mlq_btn"
	return table.concat({
		("style[%s;bgimg=%s.png;bgimg_hovered=%s_hover.png;bgimg_pressed=%s_press.png;"
			.. "bgimg_middle=4;border=false;textcolor=%s]"):format(name, bg, bg, bg,
			variant == "gold" and T.color.ink or "#f3e6c4"),
		("button[%s,%s;%s,%s;%s;%s]"):format(n(x), n(y), n(w), n(h), name, esc(text)),
	})
end

-- Zone cliquable transparente (posée par-dessus un dessin).
function T.hotspot(x, y, w, h, name)
	return table.concat({
		("style[%s;border=false;bgimg=blank.png;bgimg_hovered=mlq_hover.png;bgimg_pressed=mlq_hover.png;"
			.. "bgimg_middle=2]"):format(name),
		("image_button[%s,%s;%s,%s;blank.png;%s;;false;false]"):format(n(x), n(y), n(w), n(h), name),
	})
end

-- Remplissage texturé (dégradé vertical + reflet, étirable en largeur) ; autre couleur : aplat.
local BAR_TEXTURE = { [T.color.green] = "mlq_bar_green.png", [T.color.gold] = "mlq_bar_gold.png" }

function T.progress_bar(x, y, w, h, done, total, color)
	local ratio = total > 0 and math.min(1, done / total) or 0
	local out = {
		T.image(x, y, w, h, "mlq_progress_bg.png"),
	}
	if ratio > 0 then
		color = color or T.color.green
		local fill = math.max(0.06, (w - 0.08) * ratio)
		local tex = BAR_TEXTURE[color]
		out[#out + 1] = tex and T.image(x + 0.04, y + 0.04, fill, h - 0.08, tex)
			or T.box(x + 0.04, y + 0.04, fill, h - 0.08, color)
	end
	return table.concat(out)
end

-- Filet étiré sur toute la largeur + fleuron central aux proportions fixes (jamais déformé).
function T.ornament(x, y, w)
	local out = T.image(x, y, w, 0.18, "mlq_ornament.png")
	if w >= 2 then
		out = out .. T.image(x + w / 2 - 0.36, y - 0.05, 0.72, 0.28, "mlq_ornament_center.png")
	end
	return out
end

-- Case encastrée pour les item_image_button (au lieu du bouton gris par défaut).
function T.slot_style(name)
	return ("style[%s;border=false;bgimg=mlq_slot.png;bgimg_hovered=mlq_slot.png;bgimg_pressed=mlq_slot.png;"
		.. "bgimg_middle=3]"):format(name)
end

-- Panneau parchemin à bordure bronze (9-slice).
function T.panel(x, y, w, h)
	return ("background9[%s,%s;%s,%s;mlq_panel.png;false;6]"):format(n(x), n(y), n(w), n(h))
end

function T.truncate(s, max)
	s = tostring(s or "")
	-- découpe sûre en UTF-8
	local count, i = 0, 1
	while i <= #s do
		local c = s:byte(i)
		local len = c < 0x80 and 1 or c < 0xE0 and 2 or c < 0xF0 and 3 or 4
		count = count + 1
		if count > max then return s:sub(1, i - 1) .. "…" end
		i = i + len
	end
	return s
end
