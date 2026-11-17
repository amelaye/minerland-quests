#!/usr/bin/env python3
"""Lecture/écriture PNG minimale en Python pur (zlib + struct), sans dépendance (Pillow n'est pas requis).

  write_png(path, pixels)  pixels = liste de lignes, chaque ligne = liste de (r, g, b, a) 0-255
  read_png_info(path)      -> dict(width, height, bit_depth, color_type) ou lève ValueError
"""
import struct, zlib

SIG = b"\x89PNG\r\n\x1a\n"


def _chunk(tag, data):
    c = struct.pack(">I", len(data)) + tag + data
    return c + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)


def write_png(path, pixels):
    h = len(pixels)
    w = len(pixels[0]) if h else 0
    raw = bytearray()
    for row in pixels:
        if len(row) != w:
            raise ValueError("lignes de largeurs différentes")
        raw.append(0)
        for (r, g, b, a) in row:
            raw += bytes((r & 255, g & 255, b & 255, a & 255))
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    with open(path, "wb") as f:
        f.write(SIG + _chunk(b"IHDR", ihdr) + _chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + _chunk(b"IEND", b""))


def read_png_info(path):
    with open(path, "rb") as f:
        head = f.read(33)
    if head[:8] != SIG:
        raise ValueError("signature PNG absente")
    if head[12:16] != b"IHDR":
        raise ValueError("bloc IHDR absent")
    w, h, depth, ctype = struct.unpack(">IIBB", head[16:26])
    return {"width": w, "height": h, "bit_depth": depth, "color_type": ctype}
