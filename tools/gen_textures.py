#!/usr/bin/env python3
"""Génère les textures du Grand Livre des Quêtes (minerland_quests/textures/mlq_*.png).

Textures ORIGINALES, procédurales et déterministes : aucune image externe, aucune dépendance (Python 3 + pngkit).
Licence des images produites : CC-BY-SA-4.0 (minerland_quests/textures/LICENSE.txt, écrit par ce script).

Contraintes du moteur prises en compte (docs/ARCHITECTURE.md §9) :
  - 9-slice (background9[...;middle] et style bgimg_middle) : Luanti copie les COINS pixel pour pixel et ÉTIRE les
    bords et le centre. Les détails vont donc dans les coins ; bords et centre restent lisses dans le sens de
    l'étirement (pas de coutures ni de rivets répétés, qui deviendraient des traits allongés) ;
  - images simples : étirées à la taille demandée par le formspec → motifs uniformes, proportions proches de
    l'affichage réel ;
  - pixel art d'environ 32 texels par unité de formspec, cohérent avec les objets 16 px du jeu ;
  - exception : le bouton Unified Inventory est lisse (anticrénelé, 128 px) comme les icônes d'Unified Inventory.

Usage :
  python3 tools/gen_textures.py                    # écrit toutes les textures
  python3 tools/gen_textures.py --only mlq_star    # une ou plusieurs textures (nom avec ou sans .png)
  python3 tools/gen_textures.py --list             # liste des textures générées
  python3 tools/gen_textures.py --preview f.png    # planche d'aperçu agrandie (ne modifie pas le mod)
"""
import argparse
import math
import os
import sys
from collections import deque

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pngkit import write_png  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "minerland_quests", "textures")

###########################################################################
# Couleurs
###########################################################################
CLEAR = (0, 0, 0, 0)


def C(h, a=255):
    h = h.lstrip("#")
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), a)


def mix(c1, c2, t):
    t = 0.0 if t < 0 else 1.0 if t > 1 else t
    return tuple(int(round(c1[i] + (c2[i] - c1[i]) * t)) for i in range(4))


def with_alpha(c, a):
    return (c[0], c[1], c[2], max(0, min(255, int(round(a)))))


def lighten(c, t):
    return mix(c, (255, 255, 255, c[3]), t)


def darken(c, t):
    return mix(c, (0, 0, 0, c[3]), t)


def smoothstep(e0, e1, x):
    t = 0.0 if x <= e0 else 1.0 if x >= e1 else (x - e0) / (e1 - e0)
    return t * t * (3 - 2 * t)


# Palette commune (cohérente avec ui/theme.lua)
INK = C("3b2412")
INK_SOFT = C("6b4a2b")
PARCH = C("f3e6c4")
PARCH_LIGHT = C("fbf3dc")
PARCH_DARK = C("e2cd9a")
PARCH_SHADOW = C("c9a96e")
OUTLINE = C("24140a")
GOLD = [C("5e3f0e"), C("8a5a1c"), C("a0702a"), C("c99a3a"), C("e8b84a"), C("f7dc8a"), C("fff3c4")]
LEATHER = [C("1e0e07"), C("3e1c10"), C("5a2a17"), C("6e3220"), C("7a3a22"), C("8f4a2c"), C("a8653d")]
WOOD = [C("3a2410"), C("5a3a1c"), C("6e4524"), C("94622f"), C("b8843f"), C("d4a35a")]
STONE = [C("3e3e46"), C("5e5e66"), C("7e7e86"), C("9a9aa4"), C("b8b8c2"), C("d8d8e0")]
LEAF = [C("1f3d1a"), C("2f5e24"), C("457f30"), C("67a83c"), C("93cc52")]
WHITE = C("fbf8f0")

###########################################################################
# Toile de dessin
###########################################################################


class Canvas:
    def __init__(self, w, h, fill=CLEAR):
        self.w, self.h = w, h
        self.px = [[fill] * w for _ in range(h)]

    def copy(self):
        c = Canvas(self.w, self.h)
        c.px = [row[:] for row in self.px]
        return c

    def inside(self, x, y):
        return 0 <= x < self.w and 0 <= y < self.h

    def get(self, x, y):
        return self.px[y][x] if 0 <= x < self.w and 0 <= y < self.h else CLEAR

    def set(self, x, y, c):
        if 0 <= x < self.w and 0 <= y < self.h:
            self.px[y][x] = c

    def put(self, x, y, c):
        """Composition « par-dessus » (alpha)."""
        if c[3] == 0 or not (0 <= x < self.w and 0 <= y < self.h):
            return
        if c[3] == 255:
            self.px[y][x] = c
            return
        b = self.px[y][x]
        a, ba = c[3] / 255.0, b[3] / 255.0
        oa = a + ba * (1 - a)
        if oa <= 0:
            return
        self.px[y][x] = (int(round((c[0] * a + b[0] * ba * (1 - a)) / oa)),
                         int(round((c[1] * a + b[1] * ba * (1 - a)) / oa)),
                         int(round((c[2] * a + b[2] * ba * (1 - a)) / oa)), int(round(oa * 255)))

    def rect(self, x0, y0, x1, y1, c):
        """Rectangle plein, bornes incluses."""
        for y in range(max(0, int(y0)), min(self.h - 1, int(y1)) + 1):
            for x in range(max(0, int(x0)), min(self.w - 1, int(x1)) + 1):
                self.put(x, y, c)

    def hline(self, x0, x1, y, c):
        self.rect(min(x0, x1), y, max(x0, x1), y, c)

    def vline(self, x, y0, y1, c):
        self.rect(x, min(y0, y1), x, max(y0, y1), c)

    def line(self, x0, y0, x1, y1, c, width=1):
        x0, y0, x1, y1 = int(round(x0)), int(round(y0)), int(round(x1)), int(round(y1))
        dx, dy = abs(x1 - x0), -abs(y1 - y0)
        sx, sy = (1 if x0 < x1 else -1), (1 if y0 < y1 else -1)
        err = dx + dy
        while True:
            if width == 1:
                self.put(x0, y0, c)
            else:
                self.rect(x0 - (width - 1) // 2, y0 - (width - 1) // 2, x0 + width // 2, y0 + width // 2, c)
            if x0 == x1 and y0 == y1:
                break
            e2 = 2 * err
            if e2 >= dy:
                err += dy
                x0 += sx
            if e2 <= dx:
                err += dx
                y0 += sy

    def disc(self, cx, cy, r, c):
        for y in range(int(cy - r) - 1, int(cy + r) + 2):
            for x in range(int(cx - r) - 1, int(cx + r) + 2):
                if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r:
                    self.put(x, y, c)

    def ellipse(self, cx, cy, rx, ry, c):
        for y in range(int(cy - ry) - 1, int(cy + ry) + 2):
            for x in range(int(cx - rx) - 1, int(cx + rx) + 2):
                if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 <= 1:
                    self.put(x, y, c)

    def erase_disc(self, cx, cy, r):
        for y in range(int(cy - r) - 1, int(cy + r) + 2):
            for x in range(int(cx - r) - 1, int(cx + r) + 2):
                if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r:
                    self.set(x, y, CLEAR)

    def poly(self, pts, c):
        """Polygone plein (règle pair-impair, centres de pixels). `c` : couleur ou fonction (x, y) -> couleur."""
        ys = [p[1] for p in pts]
        n = len(pts)
        for y in range(max(0, int(min(ys)) - 1), min(self.h, int(max(ys)) + 2)):
            yc = y + 0.5
            xs = []
            for i in range(n):
                (x1, y1), (x2, y2) = pts[i], pts[(i + 1) % n]
                if (y1 <= yc < y2) or (y2 <= yc < y1):
                    xs.append(x1 + (yc - y1) * (x2 - x1) / (y2 - y1))
            xs.sort()
            for i in range(0, len(xs) - 1, 2):
                for x in range(max(0, int(math.ceil(xs[i] - 0.5))), min(self.w, int(math.floor(xs[i + 1] - 0.5)) + 1)):
                    self.put(x, y, c(x, y) if callable(c) else c)

    def blit(self, other, ox, oy):
        for y in range(other.h):
            row = other.px[y]
            for x in range(other.w):
                if row[x][3]:
                    self.put(x + ox, y + oy, row[x])

    def mask(self, threshold=1):
        return {(x, y) for y in range(self.h) for x in range(self.w) if self.px[y][x][3] >= threshold}

    def outlined(self, color, diagonal=False):
        """Copie avec un contour d'un pixel autour des pixels opaques."""
        m = self.mask(96)
        out = self.copy()
        nb = [(1, 0), (-1, 0), (0, 1), (0, -1)] + ([(1, 1), (1, -1), (-1, 1), (-1, -1)] if diagonal else [])
        for y in range(self.h):
            for x in range(self.w):
                if (x, y) not in m and any((x + dx, y + dy) in m for dx, dy in nb):
                    out.set(x, y, color)
        return out

    def map(self, fn):
        for y in range(self.h):
            for x in range(self.w):
                self.px[y][x] = fn(x, y, self.px[y][x])

    def flipped_h(self):
        c = Canvas(self.w, self.h)
        c.px = [row[::-1] for row in self.px]
        return c

    def scaled(self, k):
        c = Canvas(self.w * k, self.h * k)
        for y in range(c.h):
            src = self.px[y // k]
            c.px[y] = [src[x // k] for x in range(c.w)]
        return c

    def downsampled(self, k):
        """Réduction par moyenne k×k en alpha prémultiplié (anticrénelage du rendu suréchantillonné)."""
        w, h = self.w // k, self.h // k
        c = Canvas(w, h)
        n = k * k
        for y in range(h):
            for x in range(w):
                r = g = b = a = 0
                for j in range(k):
                    row = self.px[y * k + j]
                    for i in range(k):
                        p = row[x * k + i]
                        pa = p[3]
                        r += p[0] * pa
                        g += p[1] * pa
                        b += p[2] * pa
                        a += pa
                if a:
                    c.px[y][x] = (int(round(r / a)), int(round(g / a)), int(round(b / a)), int(round(a / n)))
        return c

    def save(self, path):
        write_png(path, self.px)


###########################################################################
# Bruit, tramage, masques
###########################################################################


def _hash(ix, iy, seed):
    n = (ix * 374761393 + iy * 668265263 + seed * 1442695041) & 0xFFFFFFFF
    n = ((n ^ (n >> 13)) * 1274126177) & 0xFFFFFFFF
    return ((n ^ (n >> 16)) & 0xFFFF) / 65535.0


def noise2(x, y, seed=0):
    ix, iy = math.floor(x), math.floor(y)
    fx, fy = x - ix, y - iy
    sx, sy = fx * fx * (3 - 2 * fx), fy * fy * (3 - 2 * fy)
    a, b = _hash(ix, iy, seed), _hash(ix + 1, iy, seed)
    c, d = _hash(ix, iy + 1, seed), _hash(ix + 1, iy + 1, seed)
    top = a + (b - a) * sx
    return top + ((c + (d - c) * sx) - top) * sy


def fbm2(x, y, seed=0, octaves=4):
    v, amp, tot = 0.0, 1.0, 0.0
    for o in range(octaves):
        v += noise2(x, y, seed + o * 101) * amp
        tot += amp
        amp *= 0.5
        x, y = x * 2.03, y * 2.03
    return v / tot


BAYER4 = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]


def bayer(x, y):
    return (BAYER4[y & 3][x & 3] + 0.5) / 16.0


def ramp(colors, t, x=None, y=None):
    """Couleur d'une rampe en t ∈ [0, 1] ; avec (x, y), tramage ordonné entre deux teintes voisines."""
    t = (0.0 if t < 0 else 1.0 if t > 1 else t) * (len(colors) - 1)
    i = int(t)
    if i >= len(colors) - 1:
        return colors[-1]
    f = t - i
    if x is None:
        return mix(colors[i], colors[i + 1], f)
    return colors[i + 1] if f > bayer(x, y) else colors[i]


def bands(colors, t, x, y, soft=0.35):
    """Rampe en aplats séparés par une courte transition tramée (plus net qu'un tramage continu)."""
    t = (0.0 if t < 0 else 1.0 if t > 1 else t) * (len(colors) - 1)
    i = int(t)
    if i >= len(colors) - 1:
        return colors[-1]
    f = t - i
    if f < 1 - soft:
        return colors[i]
    return colors[i + 1] if (f - (1 - soft)) / soft > bayer(x, y) else colors[i]


def inner_distance(mask, diagonal=False):
    """Distance de chaque pixel du masque à l'extérieur (1 = pixel de bord)."""
    nb = [(1, 0), (-1, 0), (0, 1), (0, -1)] + ([(1, 1), (1, -1), (-1, 1), (-1, -1)] if diagonal else [])
    dist, q = {}, deque()
    for (x, y) in mask:
        if any((x + dx, y + dy) not in mask for dx, dy in nb):
            dist[(x, y)] = 1
            q.append((x, y))
    while q:
        x, y = q.popleft()
        for dx, dy in nb:
            p = (x + dx, y + dy)
            if p in mask and p not in dist:
                dist[p] = dist[(x, y)] + 1
                q.append(p)
    return dist


def round_rect_mask(x0, y0, x1, y1, r):
    """Pixels d'un rectangle [x0, x1] × [y0, y1] (bornes incluses) aux coins arrondis de rayon r."""
    m = set()
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            cx = x0 + r if x < x0 + r else (x1 + 1 - r if x > x1 - r else None)
            cy = y0 + r if y < y0 + r else (y1 + 1 - r if y > y1 - r else None)
            if cx is not None and cy is not None and (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 > r * r:
                continue
            m.add((x, y))
    return m


def sd_round_rect(px, py, x0, y0, x1, y1, r):
    """Distance signée d'un point au bord d'un rectangle arrondi continu (négative à l'intérieur)."""
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    qx, qy = abs(px - cx) - ((x1 - x0) / 2 - r), abs(py - cy) - ((y1 - y0) / 2 - r)
    return math.hypot(max(qx, 0), max(qy, 0)) + min(max(qx, qy), 0) - r


def sprite(rows, pal):
    """Sprite dessiné au pixel : une chaîne par ligne, « . » = transparent."""
    w = len(rows[0])
    cv = Canvas(w, len(rows))
    for y, row in enumerate(rows):
        if len(row) != w:
            raise ValueError(f"sprite : ligne {y} de longueur {len(row)} au lieu de {w} : {row!r}")
        for x, ch in enumerate(row):
            if ch not in ". ":
                cv.set(x, y, pal[ch])
    return cv


def stamp(cv, rows, x, y, color, shadow=None, off=(1, 1)):
    """Applique un glyphe (« # » ou toute lettre = plein) avec ombre portée facultative."""
    pal = color if isinstance(color, dict) else None
    for pass_shadow in ((True, False) if shadow else (False,)):
        for j, row in enumerate(rows):
            for i, ch in enumerate(row):
                if ch in ". ":
                    continue
                if pass_shadow:
                    cv.put(x + i + off[0], y + j + off[1], shadow)
                else:
                    cv.put(x + i, y + j, pal[ch] if pal else color)


def emboss(cv, mask, base, light, dark, shadow=None):
    """Relief « dorure » : arêtes éclairées en haut à gauche, ombrées en bas à droite, ombre portée facultative."""
    if shadow:
        for (x, y) in mask:
            if (x + 1, y + 1) not in mask:
                cv.put(x + 1, y + 1, shadow)
    for (x, y) in mask:
        lit = (x - 1, y) not in mask or (x, y - 1) not in mask
        dim = (x + 1, y) not in mask or (x, y + 1) not in mask
        cv.set(x, y, light if lit and not dim else dark if dim and not lit else base)


###########################################################################
# Police 5×7 (capitales) pour les titres gravés et la planche d'aperçu
###########################################################################
FONT = {
    "A": [".###.", "#...#", "#...#", "#####", "#...#", "#...#", "#...#"],
    "B": ["####.", "#...#", "#...#", "####.", "#...#", "#...#", "####."],
    "C": [".###.", "#...#", "#....", "#....", "#....", "#...#", ".###."],
    "D": ["####.", "#...#", "#...#", "#...#", "#...#", "#...#", "####."],
    "E": ["#####", "#....", "#....", "####.", "#....", "#....", "#####"],
    "F": ["#####", "#....", "#....", "####.", "#....", "#....", "#...."],
    "G": [".###.", "#...#", "#....", "#.###", "#...#", "#...#", ".####"],
    "H": ["#...#", "#...#", "#...#", "#####", "#...#", "#...#", "#...#"],
    "I": [".###.", "..#..", "..#..", "..#..", "..#..", "..#..", ".###."],
    "J": ["..###", "...#.", "...#.", "...#.", "...#.", "#..#.", ".##.."],
    "K": ["#...#", "#..#.", "#.#..", "##...", "#.#..", "#..#.", "#...#"],
    "L": ["#....", "#....", "#....", "#....", "#....", "#....", "#####"],
    "M": ["#...#", "##.##", "#.#.#", "#.#.#", "#...#", "#...#", "#...#"],
    "N": ["#...#", "##..#", "#.#.#", "#.#.#", "#..##", "#...#", "#...#"],
    "O": [".###.", "#...#", "#...#", "#...#", "#...#", "#...#", ".###."],
    "P": ["####.", "#...#", "#...#", "####.", "#....", "#....", "#...."],
    "Q": [".###.", "#...#", "#...#", "#...#", "#.#.#", "#..#.", ".##.#"],
    "R": ["####.", "#...#", "#...#", "####.", "#.#..", "#..#.", "#...#"],
    "S": [".####", "#....", "#....", ".###.", "....#", "....#", "####."],
    "T": ["#####", "..#..", "..#..", "..#..", "..#..", "..#..", "..#.."],
    "U": ["#...#", "#...#", "#...#", "#...#", "#...#", "#...#", ".###."],
    "V": ["#...#", "#...#", "#...#", "#...#", "#...#", ".#.#.", "..#.."],
    "W": ["#...#", "#...#", "#...#", "#.#.#", "#.#.#", "##.##", "#...#"],
    "X": ["#...#", "#...#", ".#.#.", "..#..", ".#.#.", "#...#", "#...#"],
    "Y": ["#...#", "#...#", ".#.#.", "..#..", "..#..", "..#..", "..#.."],
    "Z": ["#####", "....#", "...#.", "..#..", ".#...", "#....", "#####"],
    "0": [".###.", "#...#", "#..##", "#.#.#", "##..#", "#...#", ".###."],
    "1": ["..#..", ".##..", "..#..", "..#..", "..#..", "..#..", ".###."],
    "2": [".###.", "#...#", "....#", "...#.", "..#..", ".#...", "#####"],
    "3": ["####.", "....#", "....#", ".###.", "....#", "....#", "####."],
    "4": ["...#.", "..##.", ".#.#.", "#..#.", "#####", "...#.", "...#."],
    "5": ["#####", "#....", "####.", "....#", "....#", "#...#", ".###."],
    "6": [".###.", "#....", "#....", "####.", "#...#", "#...#", ".###."],
    "7": ["#####", "....#", "...#.", "..#..", ".#...", ".#...", ".#..."],
    "8": [".###.", "#...#", "#...#", ".###.", "#...#", "#...#", ".###."],
    "9": [".###.", "#...#", "#...#", ".####", "....#", "....#", ".###."],
    "_": [".....", ".....", ".....", ".....", ".....", ".....", "#####"],
    ".": [".....", ".....", ".....", ".....", ".....", ".##..", ".##.."],
    "-": [".....", ".....", ".....", ".###.", ".....", ".....", "....."],
    " ": ["...", "...", "...", "...", "...", "...", "..."],
}
ACCENTS = {"Ê": ("E", ["..#..", ".#.#."]), "É": ("E", ["...#.", "..#.."]), "È": ("E", [".#...", "..#.."])}


def text_mask(s, x, y, scale=1, spacing=1):
    """Masque de pixels d'un texte en capitales (accents Ê/É/È dessinés au-dessus de la ligne)."""
    m = set()
    cx = x
    for ch in s.upper():
        accent = None
        if ch in ACCENTS:
            ch, accent = ACCENTS[ch]
        g = FONT.get(ch, FONT[" "])
        rows = (accent + ["....."] + g) if accent else g
        oy = y - (3 * scale if accent else 0)
        for j, row in enumerate(rows):
            for i, c in enumerate(row):
                if c == "#":
                    for sy in range(scale):
                        for sx in range(scale):
                            m.add((cx + i * scale + sx, oy + j * scale + sy))
        cx += (len(g[0]) + spacing) * scale
    return m


def text_width(s, scale=1, spacing=1):
    w = 0
    for ch in s.upper():
        base = ACCENTS[ch][0] if ch in ACCENTS else ch
        w += (len(FONT.get(base, FONT[" "])[0]) + spacing) * scale
    return w - spacing * scale


###########################################################################
# Briques graphiques réutilisables
###########################################################################


def medallion(size, r, outline, rim_light, rim_dark, face_top, face_bottom, spec=None):
    """Pièce ronde en pixel art : contour, biseau (clair en haut à gauche), face en trois bandes, reflet."""
    cv = Canvas(size, size)
    cx = cy = size / 2
    m = {(x, y) for y in range(size) for x in range(size) if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r}
    face_mid = mix(face_top, face_bottom, 0.5)
    for (x, y), d in inner_distance(m).items():
        dx, dy = x + 0.5 - cx, y + 0.5 - cy
        if d == 1:
            c = outline
        elif d == 2:
            c = rim_light if dx + dy < -0.5 else rim_dark if dx + dy > 0.5 else mix(rim_light, rim_dark, 0.5)
        else:
            t = (dy + r) / (2 * r)
            c = face_top if t < 0.42 else face_mid if t < 0.68 else face_bottom
        cv.set(x, y, c)
    if spec:
        sx, sy = int(cx - r * 0.5), int(cy - r * 0.55)
        cv.set(sx, sy, spec)
        cv.set(sx + 1, sy, with_alpha(spec, 170))
        cv.set(sx, sy + 1, with_alpha(spec, 170))
    return cv


def vintage(cv, tint=0.10, desat=0.12, vignette=0.22, border=INK):
    """Patine « gravure de livre ancien » : légère désaturation, teinte parchemin, vignettage, filet sombre."""
    w, h = cv.w, cv.h

    def f(x, y, p):
        if p[3] == 0:
            return p
        g = (p[0] * 0.3 + p[1] * 0.59 + p[2] * 0.11)
        q = (p[0] + (g - p[0]) * desat, p[1] + (g - p[1]) * desat, p[2] + (g - p[2]) * desat)
        q = (q[0] + (PARCH[0] - q[0]) * tint, q[1] + (PARCH[1] - q[1]) * tint, q[2] + (PARCH[2] - q[2]) * tint)
        nx, ny = (x + 0.5) / w * 2 - 1, (y + 0.5) / h * 2 - 1
        v = 1 - vignette * smoothstep(0.55, 1.45, math.sqrt(nx * nx * 0.8 + ny * ny))
        return (int(q[0] * v), int(q[1] * v), int(q[2] * v), p[3])
    cv.map(f)
    if border:
        for x in range(w):
            cv.set(x, 0, border)
            cv.set(x, h - 1, border)
        for y in range(h):
            cv.set(0, y, border)
            cv.set(w - 1, y, border)


def sky(cv, stops, y0=0, y1=None):
    y1 = cv.h - 1 if y1 is None else y1
    for y in range(max(0, y0), min(cv.h - 1, y1) + 1):
        t = (y - y0) / max(1, y1 - y0)
        for x in range(cv.w):
            cv.set(x, y, bands(stops, t, x, y, 0.4))


def glow(cv, cx, cy, r0, r1, color, strength=180):
    """Halo en anneaux tramés (pas de flou : reste « pixel art »)."""
    for y in range(int(cy - r1) - 1, int(cy + r1) + 2):
        for x in range(int(cx - r1) - 1, int(cx + r1) + 2):
            d = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
            if r0 < d <= r1:
                t = 1 - (d - r0) / (r1 - r0)
                if t * t > bayer(x, y) * 0.9:
                    cv.put(x, y, with_alpha(color, strength * t))


def cloud(cv, x, y, s, light=WHITE, shade=C("d6dce8")):
    lay = Canvas(int(s * 7) + 4, int(s * 3) + 4)
    bumps = [(0.22, 0.62, 0.18), (0.42, 0.42, 0.26), (0.62, 0.5, 0.2), (0.8, 0.66, 0.15), (0.5, 0.7, 0.2)]
    for bx, by, br in bumps:
        lay.disc(bx * lay.w, by * lay.h, br * lay.w, shade)
    for bx, by, br in bumps:
        lay.disc(bx * lay.w - 1, by * lay.h - 1.2, br * lay.w * 0.92, light)
    cv.blit(lay, int(x - lay.w / 2), int(y - lay.h / 2))


def ridge(w, base, amp, freq, seed, octaves=4):
    return [base - amp * fbm2(x * freq, 0.37, seed, octaves) for x in range(w)]


def fill_ridge(cv, ys, lit, shade, body, light_from_left=True, band=4, snow=None, snow_line=-1, haze=None,
               haze_from=None, bottom=None):
    bottom = cv.h - 1 if bottom is None else bottom
    n = len(ys)
    for x, yt in enumerate(ys):
        top = int(round(yt))
        slope = ys[min(x + 1, n - 1)] - ys[max(x - 1, 0)]
        facing_light = (slope < -0.15) if light_from_left else (slope > 0.15)
        for y in range(max(0, top), bottom + 1):
            depth = y - top
            if snow and y < snow_line and depth < 5 + (snow_line - y) // 2:
                c = snow[0] if facing_light else snow[1]
            elif depth < band:
                c = lit if facing_light else shade
            else:
                c = body
            if haze is not None and haze_from is not None and y > haze_from:
                c = mix(c, haze, min(0.6, (y - haze_from) / 30.0))
            cv.set(x, y, c)


def make_tree_round(h, seed, leaf=LEAF, trunk=WOOD):
    import random
    rng = random.Random(seed)
    w = int(h * 0.9) + 4
    t = Canvas(w, h + 2)
    cx = w / 2
    base = h + 1
    tw = max(2, h // 9)
    th = int(h * 0.42)
    t.rect(int(cx - tw / 2), base - th, int(cx - tw / 2) + tw - 1, base - 1, trunk[2])
    t.vline(int(cx - tw / 2) + tw - 1, base - th, base - 1, trunk[1])
    cy = base - th - h * 0.22
    r = h * 0.3
    blobs = [(cx + rng.uniform(-r * 0.75, r * 0.75), cy + rng.uniform(-r * 0.55, r * 0.35), r * rng.uniform(0.6, 0.8))
             for _ in range(6)]
    blobs.append((cx, cy - r * 0.2, r * 0.85))
    for bx, by, br in blobs:
        t.disc(bx, by, br, leaf[1])
    for bx, by, br in blobs:
        t.disc(bx - br * 0.22, by - br * 0.28, br * 0.62, leaf[2])
    for bx, by, br in blobs[:4]:
        t.disc(bx - br * 0.42, by - br * 0.45, br * 0.28, leaf[3])
    for _ in range(int(h * 0.6)):
        px, py = rng.randint(1, w - 2), rng.randint(1, base - th)
        if t.get(px, py)[3] and t.get(px, py) == leaf[2]:
            t.set(px, py, leaf[3])
    return t.outlined(C("16240f"))


def make_pine(h, seed, leaf=(C("1c3a24"), C("2a5434"), C("3c7046"))):
    t = Canvas(int(h * 0.62) + 3, h + 1)
    cx = t.w / 2
    t.rect(int(cx) - 1, h - 3, int(cx), h, WOOD[1])
    tiers = 4
    for i in range(tiers):
        top = h * 0.05 + i * h * 0.2
        bot = top + h * 0.38
        half = (i + 1.6) * t.w / (2 * (tiers + 1.6))
        t.poly([(cx, top), (cx + half, bot), (cx - half, bot)], leaf[1])
        t.poly([(cx, top), (cx - 0.2, bot), (cx - half, bot)], leaf[2])
    return t.outlined(C("12221a"))


def make_house(w, h, wall, wall_dark, roof, roof_dark, seed=0, chimney=True, lit=True, door=WOOD[1],
               timber=None):
    """Maison vue de face : murs, toit débordant, porte, fenêtres (allumées ou non), cheminée."""
    roof_h = int(w * 0.48)
    cv = Canvas(w + 6, h + roof_h + 8)
    x0, base = 3, cv.h - 1
    top = base - h + 1
    cv.rect(x0, top, x0 + w - 1, base, wall)
    cv.rect(x0 + w - 2, top, x0 + w - 1, base, wall_dark)
    if timber:
        for x in range(x0, x0 + w, 5):
            cv.vline(x, top, base, timber)
        cv.hline(x0, x0 + w - 1, top + h // 2, timber)
    if chimney:
        cxm = x0 + int(w * 0.72)
        cv.rect(cxm, top - roof_h + 2, cxm + 2, top - roof_h // 3, STONE[2])
        cv.vline(cxm + 2, top - roof_h + 2, top - roof_h // 3, STONE[1])
    peak = (x0 + w / 2, top - roof_h)
    cv.poly([(x0 - 2.5, top + 0.5), peak, (x0 + w + 1.5, top + 0.5)], roof)
    cv.poly([(x0 + w / 2, top - roof_h + 1), (x0 + w + 1.5, top + 0.5), (x0 + w / 2, top + 0.5)], roof_dark)
    cv.hline(x0 - 2, x0 + w + 1, top, darken(roof_dark, 0.25))
    dw = max(3, w // 6)
    dx = x0 + w // 2 - dw // 2
    cv.rect(dx, base - max(4, h * 6 // 10) + 1, dx + dw - 1, base, door)
    cv.set(dx + dw - 2, base - 2, GOLD[4])
    win = C("ffd76a") if lit else C("4a5a72")
    for wx in (x0 + 2, x0 + w - 6):
        if wx + 3 < dx or wx > dx + dw:
            cv.rect(wx, top + 3, wx + 2, top + 5, win)
            cv.set(wx + 1, top + 4, darken(win, 0.25))
    return cv.outlined(C("20140c"))


def gear_points(cx, cy, r_out, r_in, teeth, phase=0.0):
    pts = []
    for k in range(teeth * 4):
        ang = phase + k * (2 * math.pi / (teeth * 4))
        rr = r_out if (k % 4) in (1, 2) else r_in
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    return pts


def draw_gear(cv, cx, cy, r, teeth, colors, phase=0.0, hole=None):
    """Engrenage : dents, biseau éclairé en haut à gauche, moyeu percé."""
    lay = Canvas(cv.w, cv.h)
    lay.poly(gear_points(cx, cy, r, r * 0.78, teeth, phase), colors[2])
    m = lay.mask()
    for (x, y) in m:
        dx, dy = x + 0.5 - cx, y + 0.5 - cy
        d = math.hypot(dx, dy)
        if d < r * 0.62:
            c = colors[3] if (dx + dy) < 0 else colors[1]
            if d < r * 0.5:
                c = colors[2]
        else:
            c = colors[3] if (dx + dy) < -r * 0.3 else colors[1] if (dx + dy) > r * 0.3 else colors[2]
        lay.set(x, y, c)
    lay.disc(cx, cy, r * 0.22, colors[0])
    if hole is not None:
        lay.disc(cx, cy, r * 0.14, hole)
    cv.blit(lay.outlined(colors[0]), 0, 0)


###########################################################################
# Registre des textures
###########################################################################
TEXTURES = {}


def texture(name):
    def deco(fn):
        TEXTURES[name] = fn
        return fn
    return deco


###########################################################################
# Icônes 16 px dessinées au pixel
###########################################################################


@texture("mlq_book.png")
def tex_book():
    pal = {"O": C("2a140c"), "S": C("3e1c10"), "H": C("9a5030"), "L": C("7a3a22"), "l": C("5a2a17"),
           "G": GOLD[4], "g": GOLD[2], "W": GOLD[6], "P": PARCH, "p": C("d8c49a"), "R": C("c0392b"), "r": C("7a2418")}
    return sprite([
        "................",
        ".OOOOOOOOOOOOO..",
        ".OSHHHHHHHHGWOO.",
        ".OSHLLLLLLLLGOPO",
        ".OSHLLLLWLLLLOPO",
        ".OSHLLLWGgLLLOPO",
        ".OSHLLWGGGgLLOPO",
        ".OSHLLLgGgLLLOPO",
        ".OSHLLLLgLLLLOPO",
        ".OSHLLLLLLLLLOPO",
        ".OSHLLLLLLLLLOPO",
        ".OSHLLLLLLLLGOPO",
        ".OSlllllllRrWOPO",
        ".OOOOOOOOORrOOPO",
        "..OpPpPpPpRrPpPO",
        "..OOOOOOOORrOOOO",
    ], pal)


@texture("mlq_charter.png")
def tex_charter():
    pal = {"O": C("4e3119"), "h": PARCH_LIGHT, "P": PARCH, "p": C("dcc38d"), "d": C("c9a96e"),
           "t": C("a08058"), "R": C("b83a2a"), "r": C("7a2418"), "s": C("e06a50"), "G": GOLD[4], "g": GOLD[2]}
    return sprite([
        "................",
        "..OOOOOOOOOOOO..",
        "..OhhhhhhhhhhO..",
        "..OPPPPPPPPPPO..",
        "..OddddddddddO..",
        "...OPPPPPPPPO...",
        "...OPttttttpO...",
        "...OPPPPPPPpO...",
        "...OPttttPPpO...",
        "...OPPPPPPPpO...",
        "...OPPPRRPPpO...",
        "...OPPRsRRPpO...",
        "..OOOORRRrOOOO..",
        "..OhhhgrrGhhhO..",
        "..OdddGddGdddO..",
        "..OOOOgOOgOOOO..",
    ], pal)


@texture("mlq_reward.png")
def tex_reward():
    pal = {"O": C("2a1608"), "W": WOOD[4], "w": WOOD[3], "d": WOOD[2], "G": GOLD[4], "g": GOLD[2],
           "Y": GOLD[6], "K": C("2a1608"), "s": C("ffffff"), "y": GOLD[5]}
    return sprite([
        "..............s.",
        ".............sYs",
        "..............s.",
        "..OOOOOOOOOOO...",
        ".OWWWWWWWWWWWO..",
        ".OwGwwwwwwwGwO..",
        ".OdgdddddddgdO..",
        ".OOOOOGYGOOOOO..",
        ".OWGWWGYGWWGWO..",
        ".OwGwwgKgwwGwO..",
        ".OwGwwwgwwwGwO..",
        ".OwGwwwwwwwGwO..",
        ".OwGwwwwwwwGwO..",
        ".OdgdddddddgdO..",
        ".OOOOOOOOOOOOO..",
        "................",
    ], pal)


@texture("mlq_title.png")
def tex_title():
    cv = Canvas(16, 16)
    rib = Canvas(16, 16)
    rib.poly([(3, 0), (6.5, 0), (9.5, 7.5), (6, 7.5)], C("c0392b"))
    rib.poly([(9.5, 0), (13, 0), (10, 7.5), (6.5, 7.5)], C("3d6fa3"))
    rib.poly([(4.6, 0), (5.4, 0), (8.2, 7.5), (7.4, 7.5)], C("f2cc66"))
    rib.poly([(10.6, 0), (11.4, 0), (8.6, 7.5), (7.8, 7.5)], C("f2cc66"))
    cv.blit(rib.outlined(OUTLINE), 0, 0)
    medal = medallion(12, 5.5, GOLD[0], GOLD[6], GOLD[2], GOLD[5], GOLD[3], spec=WHITE)
    stamp(medal, ["..#..", ".###.", "#####", ".###.", ".#.#."], 4, 3, GOLD[1])
    cv.blit(medal, 2, 4)
    return cv


@texture("mlq_icon_quest.png")
def tex_icon_quest():
    cv = Canvas(16, 16)
    sheet = Canvas(16, 16)
    sheet.rect(2, 4, 10, 13, PARCH)
    sheet.rect(9, 5, 10, 13, PARCH_DARK)
    for y in (6, 8, 10):
        sheet.hline(4, 8 if y != 10 else 6, y, C("a08058"))
    sheet.rect(1, 2, 11, 3, PARCH_LIGHT)
    sheet.hline(1, 11, 4, PARCH_SHADOW)
    sheet.rect(1, 13, 11, 14, PARCH_DARK)
    sheet.hline(1, 11, 13, PARCH_LIGHT)
    cv.blit(sheet.outlined(C("4e3119")), 0, 0)
    quill = sprite([
        "............OO..",
        "...........OWWO.",
        "..........OWWWO.",
        ".........OWWWgO.",
        "........OWWWgO..",
        ".......OWWWgO...",
        "......OWWWgO....",
        "......OWWgO.....",
        ".....OWggO......",
        ".....OWgO.......",
        "....OsOO........",
        "....On..........",
        "...On...........",
        "................",
        "................",
        "................",
    ], {"O": C("3a2c20"), "W": WHITE, "g": C("c9bfae"), "s": C("8a7a64"), "n": INK})
    cv.blit(quill, 1, 0)
    return cv


###########################################################################
# Badges d'état, étoile, pastilles, flèche, bouton de fermeture
###########################################################################
GLYPH_CHECK = ["........##", ".......###", "......###.", "##...###..", "###.###...", ".#####....",
               "..###.....", "...#......"]
GLYPH_EXCLAM = ["####", "####", "####", ".##.", ".##.", ".##.", "....", ".##.", ".##."]
GLYPH_LOCK = ["..SSSS..", ".SS..SS.", ".S....S.", ".S....S.", "BBBBBBBB", "BBBBBBBB", "BBBkkBBB", "BBBkkBBB",
              "BBBBkBBB", "BBBBBBBB"]
GLYPH_CROSS = ["##....##", "###..###", ".######.", "..####..", "..####..", ".######.", "###..###", "##....##"]
GLYPH_CROSS_SMALL = ["#....#", "##..##", ".####.", ".####.", "##..##", "#....#"]

STATE_RAMPS = {
    # contour, sombre, moyen, clair, reflet, fond haut, fond bas, ombre interne
    "available": ("5e3f0e", "a0702a", "d9a23a", "f2cc66", "fff0b0", "f8edd2", "e8d3a2", "cfb684"),
    "done": ("1a4a1d", "2e7a32", "43a047", "66c06a", "b5ecb0", "f0f2d6", "dbe4b6", "bcc895"),
    "locked": ("3a3a3a", "606060", "8a8a8a", "ababab", "d6d6d6", "e6e1d6", "cec8ba", "b3ac9e"),
    "unavailable": ("4a1f15", "7a3624", "a0523d", "c0705a", "e8a890", "efdcd0", "d9c2b3", "c0a495"),
}


def badge(state):
    o, dk, md, lt, hl = (C(h) for h in STATE_RAMPS[state][:5])
    cv = medallion(16, 7.9, o, hl, dk, lt, md, spec=None)
    if state == "done":
        stamp(cv, GLYPH_CHECK, 3, 4, C("fbfbe8"), shadow=C("1a4a1d"))
    elif state == "available":
        stamp(cv, GLYPH_EXCLAM, 6, 3, INK, shadow=with_alpha(C("fff0b0"), 200))
    elif state == "locked":
        stamp(cv, GLYPH_LOCK, 4, 3, {"S": C("cfcfcf"), "B": C("ececec"), "k": C("3a3a3a")}, shadow=C("3a3a3a"))
    else:
        stamp(cv, GLYPH_CROSS, 4, 4, C("fbeee0"), shadow=C("4a1f15"))
    return cv


for _state in STATE_RAMPS:
    texture(f"mlq_badge_{_state}.png")(lambda s=_state: badge(s))


@texture("mlq_close.png")
def tex_close():
    cv = medallion(16, 7.9, C("2a140c"), GOLD[5], GOLD[2], LEATHER[5], LEATHER[3])
    stamp(cv, GLYPH_CROSS_SMALL, 5, 5, GOLD[4], shadow=C("2a140c"))
    return cv


@texture("mlq_close_press.png")
def tex_close_press():
    cv = medallion(16, 7.9, C("2a140c"), GOLD[2], GOLD[5], LEATHER[3], LEATHER[4])
    stamp(cv, GLYPH_CROSS_SMALL, 5, 6, GOLD[5], shadow=None)
    return cv


@texture("mlq_slot.png")
def tex_slot():
    """Case encastrée des objets de récompense (9-slice, coins de 3 px) : ombre en haut à gauche."""
    S = 12

    def profile(d, side, x, y):
        lit = side in "tl"                                        # creux : le haut et la gauche sont à l'ombre
        if d == 0:
            return C("8a6a44") if lit else C("fbf6e8")
        if d == 1:
            return C("c4a878") if lit else C("efe2c2")
        if d == 2:
            return C("dbc797") if lit else C("e9dab6")
        return C("e4d3aa")

    def corners(cv):
        for (x, y) in ((0, 0), (S - 1, 0), (0, S - 1), (S - 1, S - 1)):
            cv.set(x, y, CLEAR)
    return framed(S, S, profile, corners)


@texture("mlq_star.png")
def tex_star():
    cv = Canvas(16, 16)
    cx, cy, ro, ri = 8.0, 8.6, 7.7, 3.2
    pts = []
    for k in range(10):
        ang = math.radians(-90 + k * 36)
        rr = ro if k % 2 == 0 else ri
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    lay = Canvas(16, 16)
    lay.poly(pts, GOLD[4])
    for (x, y) in lay.mask():
        ang = math.degrees(math.atan2(y + 0.5 - cy, x + 0.5 - cx)) + 90
        rel = (ang % 72) - 36          # position dans la branche : < 0 côté gauche, > 0 côté droit
        arm = int(((ang + 36) % 360) // 72)
        lit_arm = arm in (0, 4)       # branches haute et gauche plus éclairées
        if rel < 0:
            c = GOLD[6] if lit_arm else GOLD[5]
        else:
            c = GOLD[4] if lit_arm else GOLD[3]
        lay.set(x, y, c)
    cv.blit(lay.outlined(GOLD[0]), 0, 0)
    cv.set(8, 8, WHITE)
    return cv


@texture("mlq_pip_on.png")
def tex_pip_on():
    pal = {"O": GOLD[0], "W": WHITE, "H": GOLD[5], "G": GOLD[4], "S": GOLD[2]}
    return sprite([
        "....O....",
        "...OWO...",
        "..OHHGO..",
        ".OHHGGSO.",
        "OHGGGGGSO",
        ".OGGGGSO.",
        "..OGGSO..",
        "...OSO...",
        "....O....",
    ], pal)


@texture("mlq_pip_off.png")
def tex_pip_off():
    pal = {"O": C("8a6a44"), "d": C("c4ac80"), "m": C("d9c59c"), "l": C("eadcbc")}
    return sprite([
        "....O....",
        "...OdO...",
        "..OddmO..",
        ".OddmmlO.",
        "OdmmmmmlO",
        ".OmmmmlO.",
        "..OmmlO..",
        "...OlO...",
        "....O....",
    ], pal)


@texture("mlq_arrow.png")
def tex_arrow():
    pal = {"O": C("2a1a10"), "A": C("8a6238"), "a": C("5e4024")}
    return sprite([
        "OO......",
        "OAOO....",
        "OAAAOO..",
        "OAAAAAOO",
        "OAAAAAAO",
        "OaaaaaaO",
        "OaaaaaOO",
        "OaaaOO..",
        "OaOO....",
        "OO......",
    ], pal)


###########################################################################
# Cadres de nœuds, sélection, voile, survol
###########################################################################


def node_frame(state):
    o, dk, md, lt, hl, ft, fb, fs = (C(h) for h in STATE_RAMPS[state])
    S = 32
    cv = Canvas(S, S)
    m = round_rect_mask(0, 0, S - 1, S - 1, 3.2)
    fm = mix(ft, fb, 0.5)
    for (x, y), d in inner_distance(m).items():
        lit_side = min(x, y) < min(S - 1 - x, S - 1 - y)      # bord le plus proche : haut/gauche = éclairé
        if d == 1:
            c = o
        elif d == 2:
            c = hl if lit_side else dk
        elif d == 3:
            c = lt if lit_side else md
        elif d == 4:
            c = md if lit_side else dk
        elif d == 5:
            c = mix(o, dk, 0.35)                                  # filet intérieur
        elif d == 6 and lit_side:
            c = fs                                                # ombre portée interne (haut, gauche)
        else:
            t = (y - 5) / (S - 11)
            c = ft if t < 0.45 else fm if t < 0.78 else fb
        cv.set(x, y, c)
    for (rx, ry) in ((3, 3), (S - 5, 3), (3, S - 5), (S - 5, S - 5)):   # rivets
        cv.set(rx, ry, hl)
        cv.set(rx + 1, ry, lt)
        cv.set(rx, ry + 1, lt)
        cv.set(rx + 1, ry + 1, o)
    return cv


for _state in STATE_RAMPS:
    texture(f"mlq_frame_{_state}.png")(lambda s=_state: node_frame(s))


@texture("mlq_select.png")
def tex_select():
    """Halo de sélection : dessiné sous le cadre (1,1 unité) avec 0,12 unité de débord de chaque côté."""
    S = 44
    cv = Canvas(S, S)
    inset = 0.12 / 1.34 * S
    for y in range(S):
        for x in range(S):
            d = sd_round_rect(x + 0.5, y + 0.5, inset, inset, S - inset, S - inset, 3.4)
            if d <= -2.5 or d > 4.0:
                continue                                         # intérieur (caché par le cadre) et au-delà
            if d <= 1.2:
                c = with_alpha(GOLD[6], 255)
            elif d <= 2.4:
                c = with_alpha(GOLD[5], 225)
            else:
                c = with_alpha(GOLD[4], 150) if bayer(x, y) < 0.6 else with_alpha(GOLD[4], 70)
            cv.set(x, y, c)
    for (bx, by, sx, sy) in ((0, 0, 1, 1), (S - 1, 0, -1, 1), (0, S - 1, 1, -1), (S - 1, S - 1, -1, -1)):
        for i in range(10):                                      # équerres d'angle (repère de visée)
            for t in range(3):
                col = GOLD[0] if t in (0, 2) else GOLD[5]
                if t == 2 and i >= 9:
                    continue
                cv.set(bx + sx * i, by + sy * t, col)
                cv.set(bx + sx * t, by + sy * i, col)
            cv.set(bx + sx * 9, by + sy * 1, GOLD[0])
            cv.set(bx + sx * 1, by + sy * 9, GOLD[0])
    return cv


@texture("mlq_veil.png")
def tex_veil():
    S = 24
    cv = Canvas(S, S)
    m = round_rect_mask(0, 0, S - 1, S - 1, 2.2)
    for (x, y) in m:
        a = 168
        if (x + y) % 4 == 0:
            a = 205
        cv.set(x, y, with_alpha(C("ebe2cf"), a))
    return cv


@texture("mlq_hover.png")
def tex_hover():
    """Survol des zones cliquables (9-slice, coins de 2 px)."""
    S = 8
    cv = Canvas(S, S)
    for y in range(S):
        for x in range(S):
            d = min(x, y, S - 1 - x, S - 1 - y)
            if d == 0:
                c = with_alpha(GOLD[5], 235)
            elif d == 1:
                c = with_alpha(GOLD[4], 120)
            else:
                c = with_alpha(GOLD[6], 46)
            cv.set(x, y, c)
    for (x, y) in ((0, 0), (S - 1, 0), (0, S - 1), (S - 1, S - 1)):
        cv.set(x, y, with_alpha(GOLD[5], 120))
    return cv


###########################################################################
# Panneaux, boutons, barre de progression, ornement (9-slice ou étirés)
###########################################################################


def framed(w, h, profile, corner=None, face=None):
    """Texture 9-slice : couleur selon la distance au bord (profile(d, côté) avec côté ∈ t/l/b/r)."""
    cv = Canvas(w, h)
    for y in range(h):
        for x in range(w):
            ds = {"t": y, "l": x, "b": h - 1 - y, "r": w - 1 - x}
            side = min(ds, key=lambda k: (ds[k], "tlbr".index(k)))
            c = profile(ds[side], side, x, y)
            if c is None and face:
                c = face(x, y)
            if c is not None:
                cv.set(x, y, c)
    if corner:
        corner(cv)
    return cv


def parchment_face(w, h, m, seed, vignette=0.07, mottle=0.035):
    """Centre parchemin : vignettage et grandes taches DOUCES (le centre d'un 9-slice est étiré)."""
    def f(x, y):
        nx = (x - m) / max(1, (w - 2 * m)) * 2 - 1
        ny = (y - m) / max(1, (h - 2 * m)) * 2 - 1
        v = smoothstep(0.35, 1.25, math.sqrt(nx * nx * 0.7 + ny * ny * 0.9))
        n = fbm2(x / 46.0, y / 38.0, seed, 3) - 0.5
        k = -vignette * v + mottle * n * 2
        base = PARCH
        return mix(base, darken(C("b08850"), 0.0), -k * 4) if k < 0 else mix(base, PARCH_LIGHT, k * 6)
    return f


def corner_plate(cv, cx0, cy0, size, flip_x, flip_y, light_on_hyp):
    """Coin de livre en laiton : triangle riveté, gravure parallèle à l'hypoténuse."""
    for j in range(size):
        for i in range(size):
            if i + j > size - 2:
                continue
            x = cx0 + (size - 1 - i if flip_x else i)
            y = cy0 + (size - 1 - j if flip_y else j)
            s = i + j
            if i == 0 or j == 0:
                c = GOLD[0]
            elif s == size - 2:
                c = GOLD[5] if light_on_hyp > 0 else GOLD[1] if light_on_hyp < 0 else GOLD[3]
            elif s == size - 3:
                c = GOLD[4] if light_on_hyp >= 0 else GOLD[2]
            elif s in (size - 8, size - 7):
                c = GOLD[2] if s == size - 8 else GOLD[5]
            elif i == 1 or j == 1:
                c = GOLD[5] if (not flip_x and i == 1) or (not flip_y and j == 1) else GOLD[2]
            else:
                c = GOLD[4] if (i + j) < size * 0.45 else GOLD[3]
            cv.set(x, y, c)
    for (ri, rj) in ((3, size // 2 - 3), (size // 2 - 3, 3)):
        x = cx0 + (size - 1 - ri if flip_x else ri)
        y = cy0 + (size - 1 - rj if flip_y else rj)
        cv.set(x, y, GOLD[6])
        cv.set(x + (-1 if flip_x else 1), y, GOLD[4])
        cv.set(x, y + (-1 if flip_y else 1), GOLD[4])
        cv.set(x + (-1 if flip_x else 1), y + (-1 if flip_y else 1), GOLD[0])


@texture("mlq_book_bg.png")
def tex_book_bg():
    """Fond du livre (9-slice, coins de 24 px) : cuir, filet doré, tranche des pages, parchemin."""
    W, H, M = 256, 176, 24
    leather = [C("1a0c06"), C("5a2814"), C("6e3220"), C("7a3a22"), C("7a3a22"), C("7a3a22"), C("72361f"),
               C("6a3120"), C("4a2214")]
    pages = [C("efe1bc"), C("d9c49b"), C("f3e6c4"), C("d2bb8c"), C("e9d7ad")]

    def profile(d, side, x, y):
        lit = side in "tl"
        if d <= 8:
            return leather[d]
        if d == 9:
            return GOLD[1]
        if d == 10:
            return GOLD[4] if lit else GOLD[3]
        if d == 11:
            return GOLD[2] if lit else GOLD[1]
        if d == 12:
            return C("3a1a0e")
        if d == 13:
            return C("2a140c")
        if d <= 18:
            return pages[d - 14]
        if d == 19:
            return C("b39663")
        if d < M:
            return mix(C("d7c095"), PARCH, (d - 19) / 5.0)
        return None
    face = parchment_face(W, H, M, seed=7)

    def corners(cv):
        corner_plate(cv, 0, 0, 22, False, False, -1)
        corner_plate(cv, W - 22, 0, 22, True, False, 0)
        corner_plate(cv, 0, H - 22, 22, False, True, 0)
        corner_plate(cv, W - 22, H - 22, 22, True, True, 1)
    return framed(W, H, profile, corners, face)


@texture("mlq_page_bg.png")
def tex_page_bg():
    """Page Unified Inventory (9-slice, coins de 12 px) : cadre bronze fin, tranche, parchemin."""
    W, H, M = 192, 128, 12
    pages = [C("efe1bc"), C("d8c49a"), C("f3e6c4")]

    def profile(d, side, x, y):
        lit = side in "tl"
        if d == 0:
            return C("2a1a0e")
        if d == 1:
            return GOLD[3] if lit else GOLD[1]
        if d == 2:
            return GOLD[4] if lit else GOLD[2]
        if d == 3:
            return GOLD[2] if lit else GOLD[1]
        if d == 4:
            return C("4e3119")
        if d <= 7:
            return pages[d - 5]
        if d == 8:
            return C("c2a774")
        if d < M:
            return mix(C("dcc69c"), PARCH, (d - 8) / 4.0)
        return None
    face = parchment_face(W, H, M, seed=11)

    def corners(cv):
        for (x0, y0, fx, fy, lh) in ((0, 0, False, False, -1), (W - 10, 0, True, False, 0),
                                     (0, H - 10, False, True, 0), (W - 10, H - 10, True, True, 1)):
            corner_plate(cv, x0, y0, 10, fx, fy, lh)
    return framed(W, H, profile, corners, face)


@texture("mlq_panel.png")
def tex_panel():
    """Encadré des cartes et fiches (9-slice, coins de 6 px) : filet bronze, ombre interne, papier clair."""
    S = 32
    face_c = C("f9f1dd")

    def profile(d, side, x, y):
        lit = side in "tl"
        if d == 0:
            return C("5a3a1c")
        if d == 1:
            return C("e0b25a") if lit else C("8a5a1c")
        if d == 2:
            return C("b5822f")
        if d == 3:
            return C("6b4a2b")
        if d == 4:
            return C("e3d2a8") if lit else C("fbf6e8")
        if d == 5:
            return C("f1e5c8") if lit else face_c
        return face_c

    def corners(cv):
        for (x, y) in ((0, 0), (S - 1, 0), (0, S - 1), (S - 1, S - 1)):
            cv.set(x, y, CLEAR)
        for (x, y, dx, dy) in ((1, 1, 1, 1), (S - 2, 1, -1, 1), (1, S - 2, 1, -1), (S - 2, S - 2, -1, -1)):
            cv.set(x, y, GOLD[6])
            cv.set(x + dx, y, GOLD[4])
            cv.set(x, y + dy, GOLD[4])
            cv.set(x + dx, y + dy, GOLD[1])
    return framed(S, S, profile, corners)


def button_tex(face_top, face_bottom, outline, top_line, bottom_line, side_line):
    S = 16
    cv = Canvas(S, S)
    m = round_rect_mask(0, 0, S - 1, S - 1, 2.0)
    for (x, y), d in inner_distance(m).items():
        if d == 1:
            c = outline
        elif y == 1:
            c = top_line
        elif y == S - 2:
            c = bottom_line
        elif x in (1, S - 2):
            c = side_line
        else:
            t = (y - 2) / (S - 5)
            c = mix(face_top, face_bottom, t)
        cv.set(x, y, c)
    return cv


@texture("mlq_btn.png")
def tex_btn():
    return button_tex(C("8f4a2c"), C("5e2c18"), C("1e0e07"), C("b8714a"), C("3a1a0e"), C("7a3d24"))


@texture("mlq_btn_hover.png")
def tex_btn_hover():
    return button_tex(C("a2593a"), C("6e3520"), C("2a140c"), GOLD[4], C("3a1a0e"), C("8a4a2c"))


@texture("mlq_btn_press.png")
def tex_btn_press():
    return button_tex(C("5a2a17"), C("6e3420"), C("1e0e07"), C("2a120a"), C("8f4a2c"), C("4e2414"))


@texture("mlq_btn_gold.png")
def tex_btn_gold():
    return button_tex(C("f7d985"), C("d3a03c"), GOLD[0], GOLD[6], GOLD[1], C("e8bf5a"))


@texture("mlq_btn_gold_hover.png")
def tex_btn_gold_hover():
    return button_tex(C("ffe7a0"), C("e2b24c"), GOLD[0], C("ffffff"), GOLD[1], C("f2cd6a"))


@texture("mlq_btn_gold_press.png")
def tex_btn_gold_press():
    return button_tex(C("c99a3a"), C("e0b252"), GOLD[0], GOLD[1], GOLD[6], C("b98a30"))


@texture("mlq_progress_bg.png")
def tex_progress_bg():
    W, H = 128, 8
    cv = Canvas(W, H)
    for y in range(H):
        for x in range(W):
            d = min(x, y, W - 1 - x, H - 1 - y)
            if d == 0:
                c = C("7a5a36")
            elif y == 1:
                c = C("b39b6c")
            elif y == H - 2:
                c = C("ecdcb6")
            elif x == 1:
                c = C("c4ad7c")
            else:
                c = C("d8c497")
            cv.set(x, y, c)
    for (x, y) in ((0, 0), (W - 1, 0), (0, H - 1), (W - 1, H - 1)):
        cv.set(x, y, CLEAR)
    return cv


@texture("mlq_ornament.png")
def tex_ornament():
    """Filet horizontal (étiré sur toute la largeur) : uniforme, extrémités effilées."""
    W, H = 256, 6
    cv = Canvas(W, H)
    rows = {1: (GOLD[2], 150), 2: (GOLD[4], 255), 3: (GOLD[1], 235), 4: (INK_SOFT, 70)}
    for x in range(W):
        e = min(x, W - 1 - x)
        t = smoothstep(0, 46, e)
        for y, (c, a) in rows.items():
            if a * t > 8:
                cv.set(x, y, with_alpha(c, a * t))
    return cv


@texture("mlq_ornament_center.png")
def tex_ornament_center():
    """Fleuron central posé sur le filet (proportions fixes : non étiré)."""
    pal = {"O": GOLD[0], "G": GOLD[4], "H": GOLD[6], "g": GOLD[2], "d": GOLD[1]}
    return sprite([
        "...........O...........",
        "..........OHO..........",
        "...OO....OHGgO....OO...",
        "..OHgO..OHGGgdO..OHgO..",
        "OOHGgdOOHGGGGgdOOHGgdOO",
        "..OgdO..OgGGgdO..OgdO..",
        "...OO....OgGdO....OO...",
        "..........OdO..........",
        "...........O...........",
    ], pal)


###########################################################################
# Notification (HUD, affichée ×3)
###########################################################################


@texture("mlq_toast.png")
def tex_toast():
    W, H = 136, 22
    cv = Canvas(W, H)
    for side in (0, 1):                                        # queues de ruban à chaque extrémité
        tail = Canvas(12, H)
        tail.poly([(0, 5), (11.5, 5), (11.5, 18), (0, 18), (4, 11.5)], C("d9c08e"))
        tail.poly([(0, 5), (11.5, 5), (11.5, 7), (2, 7)], C("eedcb4"))
        tail.hline(0, 11, 17, C("b99c68"))
        tail = tail.outlined(INK)
        cv.blit(tail.flipped_h() if side else tail, W - 12 if side else 0, 0)
    body = round_rect_mask(6, 1, W - 7, H - 2, 2.5)
    for (x, y), d in inner_distance(body).items():
        if d == 1:
            c = INK
        elif d == 2:
            c = GOLD[5] if y < 4 or x < 9 else GOLD[2]
        elif d == 3:
            c = GOLD[3]
        else:
            c = ramp([PARCH_LIGHT, PARCH, C("ead9b2")], (y - 3) / (H - 7), x, y)
        cv.set(x, y, c)
    slot = medallion(17, 8.2, INK, GOLD[5], GOLD[2], C("e9d6a8"), C("dcc390"))
    cv.blit(slot, 18 - 8, 3)
    for x in (31, W - 10):
        cv.set(x, 4, GOLD[4])
        cv.set(x, H - 5, GOLD[4])
    return cv


###########################################################################
# Emblèmes des parties (médaillons 32 px)
###########################################################################


def emblem_base():
    return medallion(32, 15.6, C("3e2408"), GOLD[6], GOLD[1], C("fbf3df"), C("eadbb8"))


def finish_emblem(cv, lay, outline=C("2a1a0e")):
    cv.blit(lay.outlined(outline), 0, 0)
    ring = medallion(32, 15.6, C("3e2408"), GOLD[6], GOLD[1], C("fbf3df"), C("eadbb8"))
    for (x, y) in ring.mask():                                 # le cercle doré repasse par-dessus
        d = math.hypot(x + 0.5 - 16, y + 0.5 - 16)
        if d > 13.4:
            p = ring.get(x, y)
            cv.set(x, y, p if d > 14.6 else (GOLD[4] if (x + y) < 32 else GOLD[2]))
    return cv


@texture("mlq_emblem_fundamentals.png")
def tex_emblem_fundamentals():
    cv = emblem_base()
    lay = Canvas(32, 32)
    lay.line(9, 24, 22, 9, WOOD[3], 2)                               # manche de la pioche
    lay.line(23, 24, 10, 9, WOOD[2], 2)                              # manche de la hache
    lay.poly([(13.5, 6.5), (24, 5), (28.5, 10), (24.5, 9.2), (20, 10.8)], STONE[4])   # fer de pioche
    lay.poly([(14, 7), (24, 5.5), (25.5, 7.5), (20, 9.6)], STONE[5])
    lay.poly([(6, 7.5), (11, 4.5), (13.5, 10.5), (9, 13.5)], STONE[3])             # lame de hache
    lay.poly([(6.5, 8), (10.5, 5.5), (11.5, 8.5), (8, 11)], STONE[5])
    return finish_emblem(cv, lay)


@texture("mlq_emblem_daily_life.png")
def tex_emblem_daily_life():
    cv = emblem_base()
    lay = Canvas(32, 32)
    lay.rect(9, 15, 22, 24, C("f2e2bc"))
    lay.rect(20, 15, 22, 24, C("d8c49a"))
    lay.poly([(6.5, 15.5), (16, 6.5), (25.5, 15.5)], C("b8442a"))
    lay.poly([(16, 7.5), (25.5, 15.5), (16, 15.5)], C("8a2e1a"))
    lay.rect(20, 8, 21, 11, STONE[2])
    lay.rect(14, 18, 17, 24, WOOD[2])
    lay.set(16, 21, GOLD[4])
    lay.rect(10, 17, 12, 19, C("ffd76a"))
    lay.set(11, 18, C("e0a83a"))
    for (x, y) in ((22, 6), (23, 4), (21, 3)):
        lay.disc(x, y, 1.3, with_alpha(C("e8e4dc"), 220))
    return finish_emblem(cv, lay)


@texture("mlq_emblem_transport.png")
def tex_emblem_transport():
    cv = emblem_base()
    lay = Canvas(32, 32)
    cx, cy = 16, 16
    lay.disc(cx, cy, 10.5, WOOD[2])
    lay.erase_disc(cx, cy, 8.0)
    for k in range(8):
        a = k * math.pi / 4 + math.pi / 8
        lay.line(cx + 2.5 * math.cos(a) - 0.5, cy + 2.5 * math.sin(a) - 0.5,
                 cx + 8.2 * math.cos(a) - 0.5, cy + 8.2 * math.sin(a) - 0.5, WOOD[3])
    lay.disc(cx, cy, 3.2, STONE[3])
    lay.disc(cx - 0.6, cy - 0.6, 1.4, STONE[5])
    for (x, y) in lay.mask():
        d = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
        if 8.0 < d <= 10.5:
            lay.set(x, y, WOOD[4] if (x - cx + y - cy) < -3 else WOOD[1] if (x - cx + y - cy) > 3 else WOOD[2])
            if d > 9.6:
                lay.set(x, y, STONE[3] if (x - cx + y - cy) < 0 else STONE[1])
    return finish_emblem(cv, lay)


@texture("mlq_emblem_technology.png")
def tex_emblem_technology():
    cv = emblem_base()
    lay = Canvas(32, 32)
    draw_gear(lay, 15.5, 16.5, 10.5, 9, [C("3a2a14"), GOLD[1], GOLD[3], GOLD[5]], phase=0.15)
    lay.erase_disc(15.5, 16.5, 2.2)
    bolt = ["...##", "..##.", ".####", "..##.", ".##..", "##...", "#...."]
    for j, row in enumerate(bolt):
        for i, ch in enumerate(row):
            if ch == "#":
                lay.set(19 + i, 3 + j, C("fff06a"))
    return finish_emblem(cv, lay)


@texture("mlq_emblem_exploration.png")
def tex_emblem_exploration():
    cv = emblem_base()
    lay = Canvas(32, 32)
    cx, cy = 16, 16
    lay.disc(cx, cy, 10.2, C("eadbb8"))
    lay.erase_disc(cx, cy, 8.8)
    for k in range(4):
        a = k * math.pi / 2 + math.pi / 4
        lay.poly([(cx + 7 * math.cos(a), cy + 7 * math.sin(a)), (cx + 1.6 * math.cos(a + 1.57), cy + 1.6 * math.sin(a + 1.57)),
                  (cx, cy), (cx + 1.6 * math.cos(a - 1.57), cy + 1.6 * math.sin(a - 1.57))], STONE[2])
    for k in range(4):
        a = k * math.pi / 2 - math.pi / 2
        col = C("c0392b") if k == 0 else STONE[1]
        lit = C("e8604a") if k == 0 else STONE[3]
        tip = (cx + 11.5 * math.cos(a), cy + 11.5 * math.sin(a))
        lay.poly([tip, (cx + 2.6 * math.cos(a + 1.57), cy + 2.6 * math.sin(a + 1.57)), (cx, cy)], lit)
        lay.poly([tip, (cx, cy), (cx + 2.6 * math.cos(a - 1.57), cy + 2.6 * math.sin(a - 1.57))], col)
    lay.disc(cx, cy, 1.6, GOLD[4])
    return finish_emblem(cv, lay)


@texture("mlq_emblem_building.png")
def tex_emblem_building():
    """Façade de temple : fronton, colonnes, degrés (l'architecture des grands bâtisseurs)."""
    cv = emblem_base()
    lay = Canvas(32, 32)
    sl, sm, sd = C("f0e6cc"), C("d2c09a"), C("a08a62")
    lay.poly([(6.5, 13.5), (16, 6.5), (25.5, 13.5)], sl)                # fronton
    lay.poly([(16, 7.5), (25.5, 13.5), (16, 13.5)], sm)
    lay.disc(16, 11.2, 1.3, GOLD[4])
    lay.rect(7, 13, 25, 14, sd)                                          # entablement
    for cx0 in (8, 12, 18, 22):                                          # colonnes
        lay.rect(cx0, 15, cx0 + 1, 22, sl)
        lay.vline(cx0 + 1, 15, 22, sm)
    lay.rect(6, 23, 26, 24, sm)                                          # degrés
    lay.hline(6, 26, 23, sl)
    lay.rect(5, 25, 27, 26, sd)
    lay.hline(5, 27, 25, sm)
    return finish_emblem(cv, lay)


###########################################################################
# Illustrations des six parties (176 × 80)
###########################################################################
IW, IH = 176, 80


def new_scene():
    return Canvas(IW, IH)


def smoke(cv, x, y, n, drift, seed, color=C("e8e4dc")):
    import random
    rng = random.Random(seed)
    for i in range(n):
        r = 1.6 + i * 0.55
        cv.disc(x + drift * i * 2.2 + rng.uniform(-0.6, 0.6), y - i * 3.0, r, with_alpha(color, max(60, 220 - i * 26)))


@texture("mlq_part_fundamentals.png")
def tex_part_fundamentals():
    import random
    rng = random.Random(1)
    cv = new_scene()
    sky(cv, [C("5f9fd2"), C("8fbfe2"), C("c9dfe6"), C("f2d9b0"), C("f7c48c")], 0, 52)
    glow(cv, 140, 36, 6, 18, C("ffe08a"), 170)
    cv.disc(140, 36, 6.5, C("fff3c4"))
    cv.disc(140, 36, 5, C("fffaf0"))
    cloud(cv, 34, 12, 3.2)
    cloud(cv, 98, 8, 4.0)
    cloud(cv, 160, 18, 2.6)
    far = ridge(IW, 54, 26, 0.03, 11)
    fill_ridge(cv, far, C("c4cde2"), C("94a2c2"), C("a7b3cf"), light_from_left=False, band=5,
               snow=(C("ffffff"), C("dfe6f2")), snow_line=36, haze=C("e9d9c4"), haze_from=40)
    mid = ridge(IW, 62, 11, 0.045, 23, 3)
    fill_ridge(cv, mid, C("86bf55"), C("5a8f3a"), C("6ea546"), light_from_left=False, band=2)
    for x in range(IW):                                          # sol herbeux tramé
        for y in range(64, IH):
            n = fbm2(x / 9.0, y / 5.0, 5, 3)
            cv.set(x, y, bands([C("4f8a32"), C("5e9a3a"), C("71ad44")], n, x, y))
    for i in range(70):                                          # chemin vers la cabane
        t = i / 69.0
        px = 74 + math.sin(t * 2.6) * 10 - t * 6
        py = 66 + t * 14
        w = 2 + t * 4
        cv.rect(int(px - w), int(py), int(px + w), int(py), C("b99b66") if i % 5 else C("a3854f"))
    cliff = Canvas(IW, IH)                                       # falaise et entrée de mine
    top = ridge(IW, 46, 14, 0.06, 31, 3)
    for x in range(110, IW):
        t = (x - 110) / (IW - 110.0)
        yt = int(top[x] - t * 10 + (1 - t) * 18)
        for y in range(yt, IH):
            n = fbm2(x / 6.0, y / 6.0, 9, 3)
            c = bands([STONE[1], STONE[2], STONE[3]], n, x, y)
            if y - yt < 2:
                c = C("7fb850") if y == yt else C("5a8f3a")
            cliff.set(x, y, c)
    for _ in range(60):
        x, y = rng.randint(114, IW - 2), rng.randint(46, IH - 3)
        if cliff.get(x, y)[3] and cliff.get(x, y + 1)[3]:
            col = rng.choice([C("f2cc66"), C("d8a888"), C("2a2a2a"), C("f2cc66")])
            cliff.set(x, y, col)
            cliff.set(x + 1, y, darken(col, 0.3))
    cv.blit(cliff, 0, 0)
    cv.rect(139, 52, 156, 70, C("16100c"))
    cv.ellipse(147.5, 53, 8.5, 4, C("16100c"))
    for (x0, x1) in ((136, 138), (157, 159)):
        cv.rect(x0, 50, x1, 70, WOOD[3])
        cv.vline(x0, 50, 70, WOOD[4])
        cv.vline(x1, 50, 70, WOOD[1])
    cv.rect(135, 47, 160, 49, WOOD[3])
    cv.hline(135, 160, 47, WOOD[4])
    cv.hline(135, 160, 49, WOOD[1])
    for i in range(10):                                          # rails sortant de la mine
        y = 70 + i
        x = 147 - i * 2
        cv.hline(x - 6 - i, x + 6 + i, y, C("6e4524") if i % 2 == 0 else CLEAR)
        cv.set(x - 4 - i, y, STONE[1])
        cv.set(x + 4 + i, y, STONE[1])
    cart = Canvas(16, 10)
    cart.poly([(0, 1), (15, 1), (13, 7), (2, 7)], STONE[2])
    cart.hline(0, 15, 1, STONE[4])
    cart.rect(3, 0, 12, 1, C("2a2a2a"))
    cart.set(5, 0, GOLD[4])
    cart.set(9, 0, C("d8a888"))
    cart.disc(4, 8, 1.6, C("2a2a2a"))
    cart.disc(11, 8, 1.6, C("2a2a2a"))
    cv.blit(cart.outlined(OUTLINE), 112, 64)
    house = make_house(26, 13, WOOD[3], WOOD[2], C("8f3a22"), C("6a2a18"), timber=WOOD[2])
    cv.blit(house, 60, 66 - house.h + 1)
    smoke(cv, 82, 41, 6, 0.9, 3)
    tree = make_tree_round(42, 4)
    cv.blit(tree, 2, 72 - tree.h + 1)
    small = make_tree_round(20, 8)
    cv.blit(small, 96, 66 - small.h + 1)
    for x in range(40, 58):                                      # blé
        h = 4 + (x * 7) % 3
        cv.vline(x, 76 - h, 76, C("c9a03a"))
        cv.set(x, 76 - h, C("f2d36a"))
        cv.set(x, 76 - h + 1, C("e8c45a"))
    for _ in range(26):
        x, y = rng.randint(2, IW - 3), rng.randint(70, IH - 2)
        if x < 110 or x > 165:
            cv.set(x, y, rng.choice([C("e05a4a"), C("f2d36a"), C("fbf8f0"), C("b07ae0")]))
    vintage(cv)
    return cv


def make_cow(spots=True):
    pal = {"O": OUTLINE, "W": C("f4f0e6"), "B": C("2a2422"), "p": C("e8a0a0"), "h": C("d8d0c0")}
    return sprite([
        ".OO.......OO",
        "OWBOOOOOOOWO",
        "OWWWBBWWWWWO" if spots else "OWWWWWWWWWWO",
        "OWWWBBWWWBWp",
        ".OWWWWWWWWOp",
        ".OhO.OO.OhO.",
        ".OO..OO..OO.",
    ], pal)


def make_sheep():
    pal = {"O": OUTLINE, "W": C("f6f2ea"), "w": C("ddd6c8"), "F": C("3a302a")}
    return sprite([
        "..OOOOOO..",
        ".OWWWWWWOO",
        "OWWWWWWWFF",
        "OwWWWWWWFO",
        ".OwwwwwwO.",
        "..OFO.OFO.",
    ], pal)


@texture("mlq_part_daily_life.png")
def tex_part_daily_life():
    import random
    rng = random.Random(2)
    cv = new_scene()
    sky(cv, [C("6aaee0"), C("94c6ea"), C("c4e0f2"), C("e6f0ee")], 0, 50)
    cloud(cv, 26, 10, 3.6)
    cloud(cv, 82, 15, 2.8)
    cloud(cv, 140, 9, 4.2)
    hills = ridge(IW, 52, 14, 0.035, 41, 3)
    fill_ridge(cv, hills, C("a6cf86"), C("80ad68"), C("92c078"), light_from_left=True, band=3)
    near = ridge(IW, 60, 6, 0.05, 43, 3)
    fill_ridge(cv, near, C("8cc25a"), C("6ea546"), C("7cb450"), band=2)
    mill = Canvas(30, 36)                                         # moulin à vent
    mill.poly([(11, 34.5), (19, 34.5), (17.5, 12), (12.5, 12)], C("efe6d6"))
    mill.poly([(16, 34.5), (19, 34.5), (17.5, 12), (16, 12)], C("d6cab4"))
    mill.poly([(11, 12.5), (15, 7), (19, 12.5)], C("8a4a2c"))
    mill.rect(14, 28, 16, 34, WOOD[2])
    hub = (15, 13)
    for k in range(4):
        a = math.radians(20 + 90 * k)
        ex, ey = hub[0] + 13 * math.cos(a), hub[1] + 13 * math.sin(a)
        mill.line(hub[0], hub[1], ex, ey, WOOD[1])
        px, py = -math.sin(a), math.cos(a)
        mill.poly([(hub[0] + 4 * math.cos(a), hub[1] + 4 * math.sin(a)), (ex, ey),
                   (ex + px * 3.5, ey + py * 3.5), (hub[0] + 4 * math.cos(a) + px * 3.5, hub[1] + 4 * math.sin(a) + py * 3.5)],
                  C("f6f0e2"))
    mill.disc(hub[0], hub[1], 1.4, WOOD[1])
    cv.blit(mill.outlined(OUTLINE), 22, 56 - 35)
    farm = make_house(26, 14, C("f0e2c0"), C("d8c49a"), C("b8442a"), C("8a2e1a"))
    cv.blit(farm, 64, 60 - farm.h + 1)
    barn = make_house(20, 14, C("a8341a"), C("86281a"), C("5a2014"), C("461810"), chimney=False, lit=False,
                      door=C("f0e2c0"))
    cv.blit(barn, 94, 60 - barn.h + 1)
    for y in range(60, IH):                                       # champs en bandes
        for x in range(IW):
            band = int((x + (y - 60) * 1.6) / 7) % 2
            if y >= 72:
                c = bands([C("5e9a3a"), C("6ea546")], fbm2(x / 6.0, y / 4.0, 3, 2), x, y)
            elif band:
                c = C("e8c45a") if (x + y) % 3 else C("c9a03a")
            else:
                c = C("7ab048") if (x + y) % 3 else C("5a8a34")
            cv.set(x, y, c)
    for x in range(0, 132, 6):                                    # clôture
        cv.rect(x, 66, x + 1, 71, WOOD[3])
        cv.vline(x + 1, 66, 71, WOOD[1])
    for y in (67, 69):
        cv.hline(0, 131, y, WOOD[4])
    cow = make_cow()
    cv.blit(cow, 44, 73 - cow.h)
    sheep = make_sheep()
    cv.blit(sheep, 60, 75 - sheep.h)
    cv.blit(sheep, 116, 74 - sheep.h)
    stall = Canvas(42, 34)                                        # étal du marché
    stall.rect(3, 12, 4, 33, WOOD[2])
    stall.rect(37, 12, 38, 33, WOOD[2])
    for x in range(0, 42):
        red = (x // 4) % 2 == 0
        for y in range(4, 12):
            stall.set(x, y, C("c0392b") if red else C("f6ecd2"))
        if x % 4 in (1, 2):
            stall.set(x, 12, C("c0392b") if red else C("f6ecd2"))
    stall.poly([(0, 4.5), (21, 0), (42, 4.5)], C("8a2e1a"))
    stall.rect(2, 24, 39, 27, WOOD[3])
    stall.hline(2, 39, 24, WOOD[4])
    stall.rect(2, 28, 39, 33, WOOD[2])
    for i, x in enumerate(range(6, 36, 4)):
        kind = i % 3
        if kind == 0:
            stall.disc(x, 22.5, 1.8, C("d8322a"))
            stall.set(x - 1, 21, C("ff8a7a"))
        elif kind == 1:
            stall.ellipse(x, 22.6, 2.4, 1.6, C("c9893a"))
            stall.set(x - 1, 22, C("e8b060"))
        else:
            stall.disc(x, 22.5, 2.0, C("e07a1f"))
            stall.set(x, 20, C("4a7a2a"))
    cv.blit(stall.outlined(OUTLINE), 130, IH - 35)
    for _ in range(20):
        x, y = rng.randint(2, 128), rng.randint(73, IH - 2)
        cv.set(x, y, rng.choice([C("e05a4a"), C("f2d36a"), C("fbf8f0")]))
    vintage(cv)
    return cv


@texture("mlq_part_transport.png")
def tex_part_transport():
    cv = new_scene()
    sky(cv, [C("5a9bd4"), C("86b8e2"), C("b8d8ee"), C("e2eef0")], 0, 48)
    cloud(cv, 104, 12, 3.4)
    cloud(cv, 30, 6, 2.6)
    far = ridge(IW, 48, 24, 0.028, 5)
    fill_ridge(cv, far, C("bccbe0"), C("8c9cbc"), C("a2b0cc"), band=5, snow=(C("ffffff"), C("dde4f0")),
               snow_line=32, haze=C("dfe8ee"), haze_from=36)
    hills = ridge(IW, 60, 9, 0.04, 7, 3)
    fill_ridge(cv, hills, C("8cc25a"), C("5e9a3a"), C("74ad48"), band=2)
    pylon = Canvas(14, 30)                                        # pylône en treillis du téléphérique
    pc = C("4a4a54")
    pylon.line(1, 29, 6, 3, pc)
    pylon.line(12, 29, 7, 3, pc)
    for y in range(7, 29, 5):
        off = (y - 3) * 5 / 26.0
        pylon.hline(int(6 - off), int(7 + off), y, pc)
        pylon.line(6 - off, y, 7 + off + 1, y + 5, C("6a6a74"))
    pylon.rect(2, 1, 11, 2, pc)
    cv.blit(pylon, 38, 22)
    cv.line(0, 6, 70, 29, C("2a2a2a"))                             # câble
    gx, gy = 22, 13
    cv.vline(gx + 3, gy - 2, gy + 1, C("2a2a2a"))
    gond = Canvas(9, 8)
    gond.rect(0, 0, 8, 6, C("c0392b"))
    gond.rect(1, 1, 7, 3, C("bfe0f0"))
    gond.hline(0, 8, 6, C("7a2418"))
    cv.blit(gond.outlined(OUTLINE), gx - 1, gy + 1)
    for y in range(64, IH):                                       # rivière
        for x in range(IW):
            n = fbm2(x / 14.0, y / 2.5, 13, 2)
            c = bands([C("3a76aa"), C("4a86b8"), C("6aa2d0")], n, x, y)
            if (x * 3 + y * 7) % 23 == 0:
                c = C("cfe6f5")
            cv.set(x, y, c)
    for x in range(IW):
        cv.set(x, 63, C("4f8a32"))
        cv.set(x, 64, C("3e6e2a"))
    via = Canvas(IW, IH)                                          # viaduc
    via.rect(14, 46, 162, 50, C("b8a888"))
    via.hline(14, 162, 46, C("d8ccb0"))
    via.hline(14, 162, 50, C("8e7e64"))
    for px in range(18, 160, 24):
        via.rect(px, 50, px + 6, IH - 1, C("a89878"))
        via.vline(px, 50, IH - 1, C("c8bc9c"))
        via.vline(px + 6, 50, IH - 1, C("7e6e54"))
    for ax in range(24, 160, 24):
        via.poly([(ax, 51), (ax + 12, 51), (ax + 12, 56), (ax, 56)], C("a89878"))
        for y in range(51, 58):
            for x in range(ax, ax + 13):
                if ((x + 0.5 - (ax + 6)) / 6.5) ** 2 + ((y + 0.5 - 58) / 6.0) ** 2 <= 1:
                    via.set(x, y, CLEAR)
    for y in range(47, 50):
        for x in range(14, 163):
            if (x + (y % 2) * 3) % 6 == 0:
                via.set(x, y, C("9a8a6c"))
    cv.blit(via.outlined(C("3a3024")), 0, 0)
    cv.hline(10, 166, 45, C("4a4a52"))                             # rails
    train = Canvas(66, 16)
    train.rect(2, 4, 17, 11, C("2e5e3e"))                          # chaudière
    train.hline(2, 17, 5, C("4a8a5e"))
    train.rect(0, 6, 2, 11, C("1e3e2a"))
    train.rect(14, 1, 22, 11, C("7a2418"))                         # cabine
    train.rect(16, 3, 19, 6, C("ffe9a0"))
    train.rect(4, 0, 6, 4, C("2a2a2a"))                            # cheminée
    train.rect(0, 11, 22, 12, C("2a2a2a"))
    for cx0 in (24, 45):
        train.rect(cx0, 3, cx0 + 19, 11, C("3d6fa3"))
        train.hline(cx0, cx0 + 19, 3, C("6a9ccc"))
        train.hline(cx0, cx0 + 19, 11, C("2b4a6b"))
        for wx in range(cx0 + 2, cx0 + 18, 4):
            train.rect(wx, 5, wx + 2, 7, C("ffe9a0"))
        train.rect(cx0 - 1, 9, cx0, 10, C("2a2a2a"))
    for wx in (4, 10, 17, 27, 40, 48, 61):
        train.disc(wx, 13, 2.2, C("2a2a2a"))
        train.set(wx, 13, STONE[4])
    cv.blit(train.outlined(OUTLINE), 92, 45 - 15)
    smoke(cv, 98, 24, 7, 1.6, 5, C("f2f0ea"))
    boat = Canvas(20, 16)
    boat.poly([(0, 11), (19, 11), (16, 15), (3, 15)], WOOD[2])
    boat.hline(0, 19, 11, WOOD[4])
    boat.vline(9, 0, 11, WOOD[1])
    boat.poly([(10, 1), (10, 10), (18, 10)], WHITE)
    boat.poly([(8, 3), (8, 10), (2, 10)], C("e8e0cc"))
    boat.rect(10, 0, 12, 1, C("c0392b"))
    cv.blit(boat.outlined(OUTLINE), 34, 60)
    plane = sprite([
        "....OOOOOOOOOOO...",
        "....OwwwwwwwwwO...",
        "OO...OOOOOOOOO....",
        "OrO.OOrrrrrrrrrOOO",
        "OrrOrrrrrrrrrrrrHO",
        ".OOOOOOOOOOOOOOOOO",
        "....OwwwwwwwwwO...",
        "....OOOOOOOOOOO...",
    ], {"O": OUTLINE, "w": C("e8e0cc"), "r": C("c0392b"), "H": C("bfe0f0")})
    cv.blit(plane.flipped_h(), 136, 6)
    vintage(cv)
    return cv


@texture("mlq_part_technology.png")
def tex_part_technology():
    import random
    rng = random.Random(4)
    cv = new_scene()
    sky(cv, [C("26244e"), C("3e2f62"), C("6a3a6e"), C("b8565c"), C("ec9a52")], 0, 56)
    for _ in range(18):
        x, y = rng.randint(2, IW - 3), rng.randint(2, 20)
        cv.set(x, y, with_alpha(C("fff8e0"), rng.randint(120, 230)))
    far = ridge(IW, 58, 12, 0.04, 17, 3)
    fill_ridge(cv, far, C("4a3458"), C("3a2a48"), C("402e4e"), band=2)
    for y in range(64, IH):
        for x in range(IW):
            cv.set(x, y, bands([C("2e2632"), C("3a3040"), C("463a4a")], fbm2(x / 10.0, y / 4.0, 8, 2), x, y))
    fac = Canvas(IW, IH)                                          # usine à toit en sheds
    fx0, fx1, base, wall_top = 22, 110, 66, 46
    for y in range(wall_top, base + 1):
        for x in range(fx0, fx1 + 1):
            c = C("7a3524")
            if (y - wall_top) % 4 == 0 or (x + ((y - wall_top) // 4) * 3) % 7 == 0:
                c = C("5e281a")
            fac.set(x, y, c)
    for i in range(5):
        x0 = fx0 + i * 18
        fac.poly([(x0, wall_top + 0.5), (x0 + 13, wall_top - 9), (x0 + 18, wall_top - 9), (x0 + 18, wall_top + 0.5)],
                 C("4a4a56"))
        fac.poly([(x0 + 13.5, wall_top - 8.5), (x0 + 17.5, wall_top - 8.5), (x0 + 17.5, wall_top + 0.5),
                  (x0 + 13.5, wall_top + 0.5)], C("f0c060"))
        fac.vline(x0 + 13, wall_top - 9, wall_top, C("2e2e36"))
    for wy in (50, 57):
        for wx in range(fx0 + 4, fx1 - 4, 8):
            lit = rng.random() < 0.8
            fac.rect(wx, wy, wx + 4, wy + 3, C("ffd76a") if lit else C("3a2a3a"))
            if lit:
                fac.hline(wx, wx + 4, wy, C("fff0b0"))
    fac.rect(60, 58, 66, 66, C("2a1e22"))
    fac.rect(92, 16, 98, 46, C("7a3524"))                          # cheminée
    fac.rect(92, 22, 98, 24, C("e8e0cc"))
    fac.vline(98, 16, 46, C("5e281a"))
    cv.blit(fac.outlined(C("1a1014")), 0, 0)
    for i in range(9):
        r = 2.0 + i * 0.7
        cv.disc(97 + i * 3.4, 13 - i * 1.4, r, with_alpha(C("9a8ea4"), 200 - i * 18))
    for (px, top) in ((130, 24), (164, 30)):                       # pylônes
        cv.line(px - 5, 70, px, top, C("1e1a24"))
        cv.line(px + 5, 70, px, top, C("1e1a24"))
        for y in range(top + 6, 70, 7):
            off = (y - top) * 5 / (70 - top)
            cv.hline(int(px - off), int(px + off), y, C("1e1a24"))
            cv.line(px - off, y, px + off, y + 7, C("2a2430"))
        cv.hline(px - 6, px + 6, top + 3, C("1e1a24"))
    for (x0, y0, x1, y1) in ((112, 30, 124, 27), (136, 27, 158, 33), (170, 33, 176, 35)):
        for x in range(x0, x1 + 1):
            t = (x - x0) / max(1, x1 - x0)
            cv.set(x, int(y0 + (y1 - y0) * t + 3 * math.sin(t * math.pi)), C("2a2430"))
    box = Canvas(26, 20)                                          # générateur luminescent
    box.rect(0, 2, 25, 19, STONE[2])
    box.hline(0, 25, 2, STONE[4])
    box.rect(4, 6, 21, 14, C("2a2a36"))
    box.rect(5, 7, 20, 13, C("e8b84a"))
    for (x, y) in ((12, 7), (13, 8), (11, 9), (12, 10), (13, 10), (12, 11), (11, 12)):
        box.set(x, y, C("fff6c0"))
    box.rect(2, 0, 6, 2, STONE[1])
    cv.blit(box.outlined(C("1a1014")), 120, 50)
    glow(cv, 132, 60, 8, 16, C("ffd76a"), 120)
    for y in range(71, 75):                                       # tuyau de cuivre
        c = [C("f0a070"), C("d0784a"), C("a85a34"), C("7a3e22")][y - 71]
        cv.hline(36, IW - 1, y, c)
    for x in range(44, IW, 22):
        cv.rect(x, 70, x + 2, 75, C("8a4a2a"))
        cv.vline(x, 70, 75, C("f0a070"))
    draw_gear(cv, 14, 70, 15, 11, [C("2a1a0e"), GOLD[1], GOLD[3], GOLD[5]], phase=0.1, hole=C("2e2632"))
    draw_gear(cv, 37, 76, 9, 8, [C("2a1a0e"), C("5e5e66"), C("8e8e98"), C("c0c0ca")], phase=0.3,
              hole=C("2e2632"))
    vintage(cv)
    return cv


@texture("mlq_part_exploration.png")
def tex_part_exploration():
    import random
    rng = random.Random(5)
    cv = new_scene()
    for y in range(IH):                                           # fond de caverne
        for x in range(IW):
            d = math.hypot((x - 70) / 90.0, (y - 44) / 50.0)
            n = fbm2(x / 12.0, y / 9.0, 21, 3)
            cv.set(x, y, bands([C("140e1e"), C("221832"), C("33244a"), C("41305a")],
                              max(0, 0.95 - d) * 0.9 + (n - 0.5) * 0.35, x, y))
    for y in range(4, 40):                                        # ouverture sur la nuit
        for x in range(118, 172):
            if ((x - 145) / 27.0) ** 2 + ((y - 24) / 19.0) ** 2 <= 1 + (fbm2(x / 5.0, y / 5.0, 3) - 0.5) * 0.5:
                cv.set(x, y, bands([C("1c2a52"), C("2c4478"), C("44609a")], (y - 4) / 36.0, x, y))
    cv.disc(156, 14, 4.5, C("f4f0dc"))
    cv.disc(154.5, 13, 3.6, C("2c4478"))
    for _ in range(14):
        x, y = rng.randint(122, 168), rng.randint(8, 34)
        if cv.get(x, y)[2] > 70:
            cv.set(x, y, C("fff8e0"))
    dragon = Canvas(46, 24)                                       # silhouette de dragon en vol (vers la droite)
    sil = C("0e0a14")
    dragon.ellipse(21, 14, 8.5, 2.8, sil)                         # corps
    dragon.poly([(27, 13), (31, 9), (34, 6.5), (36.5, 7.5), (33, 11), (29, 15.5)], sil)   # cou
    dragon.poly([(34, 6), (40, 6.2), (43.5, 7.6), (40, 9.2), (35.5, 9)], sil)              # tête
    dragon.poly([(35, 6.6), (33, 3.5), (36.5, 6)], sil)                                    # corne
    dragon.poly([(13.5, 13.5), (8, 15), (3, 18.5), (0.5, 21.5), (4, 19), (9, 17), (14, 15.5)], sil)  # queue
    dragon.poly([(0, 20), (3.5, 21.5), (0.5, 23.5)], sil)                                   # pointe de la queue
    dragon.poly([(18, 12), (13, 6), (6, 1), (8, 5), (6, 6.5), (10, 8), (9, 10), (14, 11.5)], sil)   # aile arrière
    dragon.poly([(22, 12), (25, 4), (31, 0), (29.5, 4), (32, 4.5), (28.5, 8), (29.5, 9.5), (25, 12.5)], sil)  # aile avant
    dragon.line(19, 16, 17, 19, sil)
    dragon.line(24, 16, 23, 19, sil)
    dragon.set(40, 7, C("ff9a3a"))
    cv.blit(dragon, 122, 12)
    rock = Canvas(IW, IH)                                         # plafond, sol, stalactites
    ceil = ridge(IW, 9, 8, 0.07, 51, 3)
    floor_ = ridge(IW, 70, -6, 0.06, 53, 3)
    for x in range(IW):
        for y in range(0, int(ceil[x])):
            rock.set(x, y, bands([C("2a2238"), C("3a3048"), C("4a3e5c")], fbm2(x / 5.0, y / 5.0, 2), x, y))
        for y in range(int(floor_[x]), IH):
            rock.set(x, y, bands([C("2e2640"), C("3e344e"), C("524462")], fbm2(x / 5.0, y / 4.0, 4), x, y))
    x = 2
    while x < IW:                                                 # stalactites irrégulières
        L = rng.randint(3, 13)
        w0 = rng.choice((1, 2, 2, 3))
        if 116 < x < 174:
            L = min(L, 4)
        for k in range(L):
            w = max(0, round(w0 * (1 - k / L)))
            rock.hline(x - w, x + w, int(ceil[x]) + k, C("3a3048") if k < L - 1 else C("524462"))
            rock.set(x - w, int(ceil[x]) + k, C("4a3e5c"))
        x += rng.randint(4, 12)
    x = 6
    while x < IW - 40:                                            # stalagmites
        L = rng.randint(2, 8)
        w0 = rng.choice((1, 2, 3))
        for k in range(L):
            w = max(0, round(w0 * (1 - k / L)))
            rock.hline(x - w, x + w, int(floor_[x]) - k, C("3e344e"))
            rock.set(x - w, int(floor_[x]) - k, C("524462"))
        x += rng.randint(7, 18)
    cv.blit(rock.outlined(C("0c0814")), 0, 0)
    portal = Canvas(30, 44)                                       # portail du Nether
    for by in range(0, 44, 5):
        for bx in range(0, 30, 5):
            if bx in (0, 25) or by in (0, 40):
                portal.rect(bx, by, bx + 4, by + 4, C("1a1024"))
                portal.hline(bx, bx + 4, by, C("3e2a5a"))
                portal.vline(bx, by, by + 4, C("2e2046"))
                portal.set(bx + 1, by + 1, C("6a4a9a"))
    for y in range(5, 40):
        for x in range(5, 25):
            a = math.atan2(y - 22, x - 15)
            r = math.hypot(x - 15, (y - 22) * 0.6)
            n = fbm2(math.cos(a + r * 0.35) * 2 + 3, math.sin(a + r * 0.35) * 2 + 3, 77, 3)
            portal.set(x, y, bands([C("3a1670"), C("6a2ec0"), C("9a5af0"), C("d8b0ff")], n * 1.2 - 0.1, x, y))
    glow(cv, 38, 46, 15, 26, C("9a5af0"), 110)
    cv.blit(portal.outlined(C("07040c")), 23, 24)
    for _ in range(12):
        cv.set(rng.randint(18, 58), rng.randint(20, 64), C("d8b0ff"))

    def crystal(x, base, h, col, lit, dark, tilt=0.0):
        lay = Canvas(IW, IH)
        w = max(2, h // 3)
        lay.poly([(x - w, base), (x - w + tilt, base - h * 0.75), (x + tilt, base - h), (x + w + tilt, base - h * 0.75),
                  (x + w, base)], col)
        lay.poly([(x - w, base), (x - w + tilt, base - h * 0.75), (x + tilt, base - h), (x + tilt * 0.5, base)], lit)
        lay.poly([(x + w * 0.5, base), (x + w + tilt, base - h * 0.75), (x + w, base)], dark)
        cv.blit(lay.outlined(darken(dark, 0.5)), 0, 0)
    glow(cv, 84, 64, 6, 20, C("5ae0e0"), 120)
    crystal(80, 70, 18, C("3ab8c8"), C("bff8ff"), C("1e7a90"), -1.5)
    crystal(87, 70, 13, C("3ab8c8"), C("bff8ff"), C("1e7a90"), 1.5)
    crystal(74, 71, 9, C("3ab8c8"), C("bff8ff"), C("1e7a90"), -2)
    glow(cv, 108, 68, 5, 14, C("c08aff"), 110)
    crystal(106, 72, 12, C("9a62e0"), C("e0c8ff"), C("5e2ea8"), 1)
    crystal(112, 72, 8, C("9a62e0"), C("e0c8ff"), C("5e2ea8"), 2)
    for y in range(72, IH):                                       # lave
        for x in range(128, IW):
            if y - 72 > (fbm2(x / 6.0, 1, 9) - 0.5) * 6 - 1:
                n = fbm2(x / 7.0, y / 3.0, 31, 3)
                cv.set(x, y, bands([C("a8341a"), C("e0661f"), C("ffb347"), C("ffe08a")], n, x, y))
    glow(cv, 152, 78, 0, 24, C("ff8a3a"), 70)
    bones = sprite([                                              # fossile pris dans la roche
        "..OOO.........................",
        ".OWWWO..O.O.O.O.O.O...........",
        "OWOWWWOOWOWOWOWOWOWOOOO.......",
        "OWWWWWWWWWWWWWWWWWWWWWWOO.....",
        ".OWWWOOWOWOWOWOWOWOWOOOOWO....",
        "..OOO..O.O.O.O.O.O.O....OWO...",
        "........................OO....",
    ], {"O": C("6a5a48"), "W": C("e8dcc0")})
    cv.blit(bones, 4, 72)
    vintage(cv)
    return cv


@texture("mlq_part_building.png")
def tex_part_building():
    import random
    rng = random.Random(6)
    cv = new_scene()
    sky(cv, [C("62a2d8"), C("94c2e6"), C("c6dcea"), C("f2dcb6")], 0, 56)
    cloud(cv, 30, 10, 3.0, light=C("fff8ec"))
    cloud(cv, 120, 7, 3.6, light=C("fff8ec"))
    for i in range(16):                                           # silhouettes lointaines
        x0 = i * 11 + rng.randint(-2, 2)
        h = rng.randint(10, 22)
        cv.rect(x0, 60 - h, x0 + 9, 60, C("a9b6c9"))
        if rng.random() < 0.5:
            cv.poly([(x0 - 0.5, 60.5 - h), (x0 + 5, 54.5 - h), (x0 + 10.5, 60.5 - h)], C("98a6bc"))
    hall = Canvas(56, 62)                                         # hôtel de ville et beffroi
    hl, hm, hd = C("ece2c8"), C("d6c6a2"), C("b4a07a")
    hall.rect(2, 40, 53, 61, hm)
    hall.rect(2, 40, 53, 41, hl)
    for x in range(6, 52, 7):
        hall.rect(x, 43, x + 2, 59, hl)
        hall.vline(x + 2, 43, 59, hd)
    hall.poly([(0, 40.5), (28, 30), (56, 40.5)], hl)
    hall.poly([(28, 31), (56, 40.5), (28, 40.5)], hm)
    hall.rect(23, 48, 32, 61, WOOD[1])
    hall.disc(27.5, 48.5, 4.6, WOOD[1])
    hall.rect(21, 8, 34, 31, hm)
    hall.rect(21, 8, 23, 31, hl)
    hall.disc(27.5, 18, 4.2, C("fbf6e6"))
    hall.line(27, 18, 27, 15, INK)
    hall.line(27, 18, 30, 18, INK)
    hall.poly([(19.5, 8.5), (27.5, -2), (35.5, 8.5)], C("4a5a6e"))
    hall.poly([(27.5, -1), (35.5, 8.5), (27.5, 8.5)], C("38465a"))
    cv.blit(hall.outlined(C("2a2014")), 60, 68 - 61)
    cv.vline(87, 0, 6, C("2a2a2a"))
    cv.rect(88, 0, 93, 3, C("c0392b"))
    for (x, w, h, wall, roof) in ((6, 22, 16, C("f0dcc0"), C("b8442a")), (32, 22, 20, C("e6d2e0"), C("3d6fa3")),
                                  (120, 20, 18, C("e8d8b8"), C("6e4524"))):
        house = make_house(w, h, wall, darken(wall, 0.15), roof, darken(roof, 0.25), seed=x)
        cv.blit(house, x, 68 - house.h + 1)
    site = Canvas(IW, IH)                                         # chantier et grue
    site.rect(144, 50, 166, 68, C("c8b48c"))
    for y in range(50, 69):
        if y % 3 == 0:
            site.hline(144, 166, y, C("a8946c"))
    for x in (142, 156, 168):
        site.vline(x, 40, 68, WOOD[3])
    for y in (46, 56):
        site.hline(141, 169, y, WOOD[4])
    site.rect(170, 8, 172, 68, GOLD[3])
    for y in range(10, 68, 4):
        site.line(170, y, 172, y + 4, GOLD[1])
    site.rect(128, 8, 175, 10, GOLD[3])
    for x in range(130, 174, 4):
        site.line(x, 8, x + 4, 10, GOLD[1])
    site.vline(136, 11, 30, C("2a2a2a"))
    site.rect(133, 30, 139, 34, C("b8a888"))
    cv.blit(site.outlined(C("2a2014")), 0, 0)
    for y in range(68, IH):                                       # rue pavée
        for x in range(IW):
            row = (y - 68) // 3
            gap = (x + row * 3) % 6 == 0 or (y - 68) % 3 == 0
            n = fbm2(x / 3.0, y / 3.0, 4, 2)
            cv.set(x, y, C("5e5a54") if gap else bands([C("8a847c"), C("a29c92"), C("b8b2a6")], n, x, y))
    cv.rect(50, 46, 51, 72, C("2a2a2a"))                           # réverbère
    cv.rect(47, 41, 54, 46, C("2a2a2a"))
    cv.rect(48, 42, 53, 45, C("ffd76a"))
    glow(cv, 50.5, 43.5, 4, 11, C("ffd76a"), 110)
    cv.rect(114, 56, 115, 72, C("3a3a3a"))                         # panneau
    sign = Canvas(14, 8)
    sign.rect(0, 0, 13, 7, C("3d6fa3"))
    sign.rect(3, 3, 9, 4, WHITE)
    sign.poly([(9, 1), (12.5, 3.5), (9, 6)], WHITE)
    cv.blit(sign.outlined(OUTLINE), 108, 49)
    tree = make_tree_round(16, 9)
    cv.blit(tree, 98, 68 - tree.h + 1)
    vintage(cv)
    return cv


@texture("mlq_part_default.png")
def tex_part_default():
    """Illustration de repli (partie sans image propre) : chemin, collines et poteau indicateur."""
    cv = new_scene()
    sky(cv, [C("6aa8dc"), C("98c6e8"), C("cfe2ec"), C("f2e2c0")], 0, 52)
    cloud(cv, 40, 12, 3.2)
    cloud(cv, 132, 9, 3.8)
    far = ridge(IW, 54, 16, 0.03, 71, 3)
    fill_ridge(cv, far, C("b4c8d8"), C("90a6bc"), C("a2b6ca"), band=4, haze=C("e6e0d0"), haze_from=44)
    near = ridge(IW, 64, 10, 0.045, 73, 3)
    fill_ridge(cv, near, C("8cc25a"), C("5e9a3a"), C("74ad48"), band=2)
    for i in range(80):                                           # chemin qui serpente vers l'horizon
        t = i / 79.0
        x = 88 + math.sin(t * 5.0) * 14 * (1 - t)
        y = IH - 1 - t * 22
        w = 1 + (1 - t) * 9
        cv.rect(int(x - w), int(y), int(x + w), int(y), C("c4a46a") if i % 6 else C("a88a54"))
    post = Canvas(30, 34)
    post.rect(13, 6, 15, 33, WOOD[3])
    post.vline(15, 6, 33, WOOD[1])
    post.poly([(2, 7), (24, 7), (28, 10.5), (24, 14), (2, 14)], WOOD[4])
    post.hline(2, 24, 7, WOOD[5])
    post.poly([(28, 17), (6, 17), (2, 20.5), (6, 24), (28, 24)], WOOD[4])
    post.hline(6, 28, 17, WOOD[5])
    cv.blit(post.outlined(OUTLINE), 50, IH - 38)
    for (x, h, s) in ((14, 30, 21), (128, 24, 22), (150, 18, 23)):
        t = make_tree_round(h, s)
        cv.blit(t, x, IH - 6 - t.h)
    vintage(cv)
    return cv


###########################################################################
# Couverture du livre (page d'accueil) — 128 × 160
###########################################################################


@texture("mlq_cover.png")
def tex_cover():
    W, H = 128, 160
    cv = Canvas(W, H)
    m = round_rect_mask(0, 0, W - 1, H - 1, 4)
    for (x, y), d in inner_distance(m).items():
        n = fbm2(x / 3.0, y / 3.0, 61, 3)
        nx, ny = x / (W - 1) * 2 - 1, y / (H - 1) * 2 - 1
        v = smoothstep(0.5, 1.4, math.sqrt(nx * nx + ny * ny))
        c = ramp([LEATHER[2], LEATHER[3], LEATHER[4], LEATHER[5]], 0.62 - v * 0.45 + (n - 0.5) * 0.45, x, y)
        if d == 1:
            c = LEATHER[0]
        elif d == 2:
            c = LEATHER[6] if (x < 4 or y < 4) else LEATHER[1]
        elif x in (11, 12):
            c = LEATHER[1] if x == 11 else LEATHER[5]                 # charnière
        cv.set(x, y, c)
    gold_mask = set()
    for (x0, y0, x1, y1) in ((17, 8, W - 9, H - 9), (21, 12, W - 13, H - 13)):
        for x in range(x0, x1 + 1):
            gold_mask.add((x, y0))
            gold_mask.add((x, y1))
        for y in range(y0, y1 + 1):
            gold_mask.add((x0, y))
            gold_mask.add((x1, y))
    fleuron = ["..#..", ".#.#.", "#.#.#", ".#.#.", "..#.."]
    for (fx, fy) in ((24, 15), (W - 20, 15), (24, H - 20), (W - 20, H - 20)):
        for j, row in enumerate(fleuron):
            for i, ch in enumerate(row):
                if ch == "#":
                    gold_mask.add((fx + i, fy + j))
    emboss(cv, gold_mask, GOLD[3], GOLD[5], GOLD[1], shadow=LEATHER[0])
    for (s, y, scale) in (("LE GRAND LIVRE", 22, 1), ("DES QUÊTES", 35, 1)):
        x = (W + 8 - text_width(s, scale)) // 2
        emboss(cv, text_mask(s, x, y, scale), GOLD[4], GOLD[6], GOLD[2], shadow=LEATHER[0])
    deco = set()
    for x in range(44, 92):
        if abs(x - 68) > 4:
            deco.add((x, 47))
    for (dx, dy) in ((0, -2), (-1, -1), (0, -1), (1, -1), (-2, 0), (-1, 0), (0, 0), (1, 0), (2, 0), (-1, 1), (0, 1),
                     (1, 1), (0, 2)):
        deco.add((68 + dx, 47 + dy))
    emboss(cv, deco, GOLD[3], GOLD[5], GOLD[1], shadow=LEATHER[0])
    cx, cy, R = 68, 86, 25                                        # blason central
    crest = Canvas(W, H)
    for y in range(cy - R - 1, cy + R + 2):
        for x in range(cx - R - 1, cx + R + 2):
            d = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
            if d <= R:
                if d > R - 1:
                    crest.set(x, y, GOLD[0])
                elif d > R - 4:
                    crest.set(x, y, GOLD[5] if (x - cx + y - cy) < -6 else GOLD[2] if (x - cx + y - cy) > 6 else GOLD[4])
                elif d > R - 5:
                    crest.set(x, y, GOLD[1])
                else:
                    crest.set(x, y, ramp([C("3a1a10"), C("4a2214"), C("5a2a17")], 1 - (y - cy + R) / (2.0 * R), x, y))
    cv.blit(crest, 0, 0)
    lay = Canvas(W, H)                                            # pioche et plume croisées
    lay.line(cx - 11, cy + 12, cx + 8, cy - 8, GOLD[4], 3)        # manche de la pioche
    lay.poly([(cx + 1, cy - 17), (cx + 8, cy - 15.5), (cx + 14, cy - 11), (cx + 17.5, cy - 2.5), (cx + 15, cy - 3.5),
              (cx + 11, cy - 9), (cx + 7, cy - 12), (cx + 1.5, cy - 14.5)], GOLD[4])   # fer en croissant
    ax, ay = -0.68, -0.73                                         # axe de la plume (bas droite → haut gauche)
    px, py = 0.73, -0.68
    bx, by, L = cx + 12, cy + 13, 36.0

    def P(t, w):
        return (bx + ax * L * t + px * w, by + ay * L * t + py * w)
    vane = [P(0.22, 0)] + [P(t, 4.6 * math.sin(math.pi * (t - 0.22) / 0.78) ** 0.7) for t in
                           (0.3, 0.42, 0.55, 0.68, 0.8, 0.9)] + [P(1.0, 0)]
    vane += [P(t, -3.2 * math.sin(math.pi * (t - 0.22) / 0.78) ** 0.8) for t in (0.9, 0.78, 0.62, 0.46, 0.32)]
    lay.poly(vane, GOLD[4])
    lay.line(*P(0.0, 0), *P(0.24, 0), GOLD[4], 2)                 # tuyau et bec
    emblem = lay.mask()
    for (x, y) in list(emblem):
        if math.hypot(x + 0.5 - cx, y + 0.5 - cy) > R - 5.5:
            emblem.discard((x, y))
    emboss(cv, emblem, GOLD[4], GOLD[6], GOLD[2], shadow=C("1e0e07"))
    for t in (0.36, 0.5, 0.64, 0.78):                             # barbes de la plume (incisions)
        x0, y0 = P(t, 0)
        x1, y1 = P(t + 0.07, 3.0)
        cv.line(x0, y0, x1, y1, GOLD[2])
    s = "MINERLAND"
    x = (W + 8 - text_width(s, 2, 1)) // 2
    emboss(cv, text_mask(s, x, 124, 2, 1), GOLD[4], GOLD[6], GOLD[2], shadow=LEATHER[0])
    return cv


###########################################################################
# Bouton Unified Inventory (lisse, 128 px, rendu ×4 puis réduit)
###########################################################################


@texture("mlq_ui_button.png")
def tex_ui_button():
    K = 4
    S = 128 * K
    cv = Canvas(S, S)

    def P(*pts):
        return [(x * K, y * K) for x, y in pts]
    for i in range(10):                                           # ombre au sol
        cv.ellipse(66 * K, 116 * K, (52 - i * 2.5) * K, (7 - i * 0.4) * K, (0, 0, 0, 14))
    cv.poly(P((30, 22), (104, 18), (110, 24), (112, 106), (36, 112), (30, 106)), C("2a120a"))   # dos du livre
    cv.poly(P((34, 26), (104, 22), (108, 26), (109, 102), (38, 106)), lambda x, y: mix(C("fbf3dc"), C("d9c49b"),
                                                                                       ((x / K) - 34) / 80))
    for k in range(6):                                            # tranche des pages
        yy = 98 + k * 1.4
        cv.line(40 * K, yy * K, 108 * K, (yy - 4) * K, C("c9b085"), 2)
    cover = P((18, 14), (92, 10), (98, 16), (100, 98), (24, 104), (18, 98))

    def cover_fill(x, y):
        u, v = x / S, y / S
        t = u * 0.6 + v * 0.7
        return ramp([C("b0603a"), C("8f4428"), C("6e3018"), C("4e2010")], t)
    cv.poly(cover, cover_fill)
    cv.poly(P((18, 14), (30, 13.3), (36, 103), (24, 104), (18, 98)), lambda x, y: mix(C("6e3018"), C("3e180c"), y / S))
    for yy in (26, 52, 78):                                       # nervures dorées du dos
        cv.poly(P((19, yy), (31, yy - 0.6), (31.6, yy + 4), (19.6, yy + 4.6)), C("e8b84a"))
        cv.poly(P((19, yy), (31, yy - 0.6), (31.2, yy + 1.2), (19.2, yy + 1.8)), C("fff0b0"))
    for (a, b, c_) in (((92, 10), (98, 16), (80, 11)), ((100, 98), (86, 99), (100, 84))):  # coins en laiton
        cv.poly(P(a, b, c_), lambda x, y: mix(C("fff0b0"), C("a0702a"), (y / S - 0.05) * 1.2))
    cx, cy, R = 62 * K, 56 * K, 25 * K
    for y in range(int(cy - R) - 2, int(cy + R) + 3):
        for x in range(int(cx - R) - 2, int(cx + R) + 3):
            d = math.hypot(x - cx, y - cy)
            if d <= R:
                if d > R - 2.5 * K:
                    col = C("5e3f0e")
                elif d > R - 7 * K:
                    t = ((x - cx) + (y - cy)) / (2 * R) + 0.5
                    col = ramp([C("fff0b0"), C("e8b84a"), C("a0702a")], t)
                else:
                    t = ((y - cy) / R + 1) / 2
                    col = ramp([C("f7dc8a"), C("e8b84a"), C("c99a3a")], t)
                cv.set(x, y, col)
    cv.poly(P((57, 39), (67, 39), (65.5, 63), (58.5, 63)), C("4a2a10"))   # point d'exclamation
    cv.disc(62 * K, 69.5 * K, 4.2 * K, C("4a2a10"))
    cv.poly(P((58.5, 40), (61, 40), (60.5, 61), (59.5, 61)), C("8a5a2a"))
    cv.poly(P((76, 101), (84, 100.5), (85, 120), (80.5, 115.5), (77, 121)), C("c0392b"))  # signet
    cv.poly(P((76, 101), (79, 100.8), (79.5, 118), (77, 121)), C("e05a48"))
    out = cv.downsampled(K)
    hl = Canvas(128, 128)                                         # reflet doux en haut à gauche
    hl.poly([(19, 15), (91, 11), (60, 30), (21, 44)], (255, 255, 255, 34))
    out.blit(hl, 0, 0)
    return out


###########################################################################
# Planche d'aperçu (développement)
###########################################################################


def preview(canvases, path, width=816):
    """Planche : petites textures agrandies dans une grille, grandes textures agrandies sur leur propre ligne."""
    cell, pad = 136, 6
    small = [n for n in sorted(canvases) if max(canvases[n].w, canvases[n].h) <= 64]
    large = [n for n in sorted(canvases) if n not in small]
    cols = width // cell
    grid_rows = (len(small) + cols - 1) // cols
    blocks = []
    for n in large:
        cvx = canvases[n]
        k = max(1, min(4, (width - 12) // cvx.w))
        blocks.append((n, cvx.scaled(k) if k > 1 else cvx))
    height = grid_rows * (cell + 14) + sum(b.h + 20 for _, b in blocks) + 8
    sheet = Canvas(width, height, C("cfc3a6"))

    def checker(x0, y0, x1, y1):
        for y in range(y0, y1):
            for x in range(x0, x1):
                sheet.set(x, y, C("e8e0cc") if ((x // 8) + (y // 8)) % 2 else C("d6ccb4"))

    def label(s, x, y):
        for (px, py) in text_mask(s.replace("mlq_", "").replace(".png", "")[:40], x, y):
            sheet.set(px, py, INK)
    for i, name in enumerate(small):
        cvx = canvases[name]
        k = max(1, min(8, (cell - 2 * pad) // max(cvx.w, cvx.h)))
        img = cvx.scaled(k)
        gx, gy = (i % cols) * cell, (i // cols) * (cell + 14)
        checker(gx + 2, gy + 2, gx + cell - 2, gy + cell - 2)
        sheet.blit(img, gx + (cell - img.w) // 2, gy + (cell - img.h) // 2)
        label(name, gx + 4, gy + cell + 3)
    y = grid_rows * (cell + 14) + 4
    for name, img in blocks:
        checker(4, y, 4 + img.w, y + img.h)
        sheet.blit(img, 4, y)
        label(name, 6, y + img.h + 4)
        y += img.h + 20
    sheet.save(path)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--only", nargs="*", help="noms des textures à générer")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--preview", help="écrit une planche d'aperçu agrandie (n'écrit pas les textures)")
    ap.add_argument("--out", default=OUT_DIR)
    args = ap.parse_args()
    if args.list:
        print("\n".join(sorted(TEXTURES)))
        return 0
    names = sorted(TEXTURES)
    if args.only:
        wanted = {n if n.endswith(".png") else n + ".png" for n in args.only}
        unknown = wanted - set(TEXTURES)
        if unknown:
            print("textures inconnues : " + ", ".join(sorted(unknown)), file=sys.stderr)
            return 1
        names = sorted(wanted)
    canvases = {n: TEXTURES[n]() for n in names}
    if args.preview:
        preview(canvases, args.preview)
        print(f"aperçu : {args.preview} ({len(canvases)} textures)")
        return 0
    os.makedirs(args.out, exist_ok=True)
    total = 0
    for n, cvx in canvases.items():
        p = os.path.join(args.out, n)
        cvx.save(p)
        total += os.path.getsize(p)
    if os.path.abspath(args.out) == os.path.abspath(OUT_DIR):
        # Licence des images à la racine du mod (le dossier textures/ ne contient que des PNG).
        lic = os.path.join(os.path.dirname(OUT_DIR), "LICENSE_TEXTURES.txt")
        with open(lic, "w", encoding="utf-8") as f:
            f.write("Textures du mod minerland_quests (fichiers textures/mlq_*.png)\n"
                    "Créées pour le Grand Livre des Quêtes de Minerland et générées par tools/gen_textures.py\n"
                    "(procédural, original, sans image externe).\n\n"
                    "Licence : Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)\n"
                    "https://creativecommons.org/licenses/by-sa/4.0/\n")
    print(f"{len(canvases)} texture(s) écrite(s) dans {os.path.relpath(args.out, ROOT)} ({total // 1024} Kio)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
