#!/usr/bin/env python3
"""snesgfx.py - unpack and view the NHLPA Hockey '93 (SNES) graphics assets in data/.

Formats (see data/README.md):
  *.pak       packed stream for the game's decompressor at $86FA3E (DecompressGraphics)
  *.chr       SNES 4bpp planar tiles, 32 bytes per 8x8 tile
  *.snesmap   SNES BG map words: vflip 15, hflip 14, priority 13, palette 12-10, tile 9-0
  *.snespal   SNES palette, BGR555 words (16 colours per palette row)

Commands:
  unpack IN [-o OUT]                  unpack a .pak file (or --rom ADDR: a packed stream in lst/nhlpa93snes.bin)
  tiles IN [-o PNG]                   tile sheet of a .chr / unpacked file (--offset, --count, --columns)
  map MAP --tiles CHR [-o PNG]        render a map with its tiles (--width in tiles, --map-offset, --tiles-offset)
  screen IN.map.pak [-o PNG]          unpack a packed screen and render it (--map-size, --pal-offset, --tiles-offset)

Palettes for tiles/map/screen: --pal FILE[:OFFSET] (a .snespal or any file with BGR555 words), else grey levels.
Rendering needs Pillow (python3 -m pip install pillow); unpack does not.

Examples:
  python tools/snesgfx.py screen data/Title1.map.pak -o title.png
  python tools/snesgfx.py screen data/EASN.map.pak --width 32 --map-size 0x400 --no-pal -o easn.png
  python tools/snesgfx.py tiles data/BigFont.chr.pak --columns 16 -o bigfont.png
  python tools/snesgfx.py map data/IceRink.snesmap --tiles data/IceRink.chr.pak --width 48 --pal data/Pals/Rink.snespal -o rink.png
"""
import argparse
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, 'lst', 'nhlpa93snes.bin')


def lorom_offset(addr):
    """ROM file offset of a LoROM bank:address ($80-$8F mirror)."""
    return ((addr >> 16) & 0x7F) * 0x8000 + (addr & 0x7FFF)


def unpack(data, start=0):
    """Emulate DecompressGraphics ($86FA3E). Return (output bytes, packed length).

    Control byte c:
      $00-$1F  copy the next (c & $1F) + 1 bytes
      $2x      (c & $F) + 1 zero bytes
      $3x      (c & $F) + 3 copies of the next byte
      $40-$7F  copy (c & 7) + 2 bytes from distance ((c >> 3) & 7) + 1, going up
      $8x      copy (c & $F) + 3 bytes from distance = next byte, going up
      $9x/$Ax/$Bx  next byte x: distance and length split over c and x (7/5, 6/6, 5/7 bits), length + 3, going up
      $C0-$DF  copy (c & 3) + 2 bytes from distance ((c >> 2) & 7) + 1, going down
      $Ex      copy (c & $F) + 3 bytes from distance = next byte (0 = end of stream), going down
      $Fx      next byte x: distance (x & $7F) + 1, length ((c << 1 | x >> 7) & $1F) + 3, going down
    The copies read the output already written (overlap repeats bytes).
    """
    p = start
    out = bytearray()

    def nx():
        nonlocal p
        v = data[p]
        p += 1
        return v

    while True:
        c = nx()
        if c & 0xE0 == 0x00:
            n = (c & 0x1F) + 1
            out += data[p:p + n]
            p += n
            continue
        if c & 0xF0 == 0x20:
            out += bytes((c & 0x0F) + 1)
            continue
        if c & 0xF0 == 0x30:
            v = nx()
            out += bytes([v]) * ((c & 0x0F) + 3)
            continue
        if c & 0xC0 == 0x40:
            dist, n, up = ((c >> 3) & 7) + 1, (c & 7) + 2, True
        elif c & 0xF0 == 0x80:
            n, dist, up = (c & 0x0F) + 3, nx(), True
        elif c & 0xF0 == 0x90:
            x = nx(); dist, n, up = (x & 0x7F) + 1, (((c << 1) | (x >> 7)) & 0x1F) + 3, True
        elif c & 0xF0 == 0xA0:
            x = nx(); dist, n, up = (x & 0x3F) + 1, (((c << 2) | (x >> 6)) & 0x3F) + 3, True
        elif c & 0xF0 == 0xB0:
            x = nx(); dist, n, up = (x & 0x1F) + 1, (((c << 3) | (x >> 5)) & 0x7F) + 3, True
        elif c & 0xE0 == 0xC0:
            dist, n, up = ((c >> 2) & 7) + 1, (c & 3) + 2, False
        elif c & 0xF0 == 0xE0:
            n, dist, up = (c & 0x0F) + 3, nx(), False
            if dist == 0:
                return bytes(out), p - start
        else:
            x = nx(); dist, n, up = (x & 0x7F) + 1, (((c << 1) | (x >> 7)) & 0x1F) + 3, False
        src = len(out) - dist
        for _ in range(n):
            out.append(out[src])
            src += 1 if up else -1


def read_input(path, rom_addr=None):
    if rom_addr is not None:
        return open(ROM, 'rb').read(), lorom_offset(rom_addr)
    return open(path, 'rb').read(), 0


def maybe_unpack(path):
    """The bytes of a file, unpacked first when it is a .pak."""
    data = open(path, 'rb').read()
    if path.lower().endswith('.pak'):
        data, _ = unpack(data)
    return data


def palette(spec, default_grey=True):
    """List of 128+ RGB colours from FILE[:OFFSET] (BGR555 words), or grey levels."""
    if not spec:
        return [(i * 17, i * 17, i * 17) for i in range(16)] * 16
    path, ofs = spec, ''
    head, sep, tail = spec.rpartition(':')
    if sep and head and '/' not in tail and '\\' not in tail:
        path, ofs = head, tail          # FILE:OFFSET (not the drive letter of C:/...)
    data = maybe_unpack(path)
    ofs = int(ofs, 0) if ofs else 0
    cols = []
    for i in range(ofs, len(data) - 1, 2):
        v = data[i] | data[i + 1] << 8
        cols.append(((v & 31) * 255 // 31, ((v >> 5) & 31) * 255 // 31, ((v >> 10) & 31) * 255 // 31))
    while len(cols) < 256:
        cols += cols or [(0, 0, 0)]
    return cols


def tile_pixel(tiles, t, x, y):
    """Colour index (0-15) of pixel x, y in 4bpp planar tile t."""
    b = t * 32
    if b + 32 > len(tiles):
        return 0
    bit = 7 - x
    p0, p1 = tiles[b + 2 * y], tiles[b + 2 * y + 1]
    p2, p3 = tiles[b + 16 + 2 * y], tiles[b + 16 + 2 * y + 1]
    return ((p0 >> bit) & 1) | ((p1 >> bit) & 1) << 1 | ((p2 >> bit) & 1) << 2 | ((p3 >> bit) & 1) << 3


def need_pillow():
    try:
        from PIL import Image
        return Image
    except ImportError:
        sys.exit('snesgfx: rendering needs Pillow (python3 -m pip install pillow)')


def render_map(mp, tiles, cols, width, height, scale):
    Image = need_pillow()
    img = Image.new('RGB', (width * 8, height * 8))
    px = img.load()
    for ty in range(height):
        for tx in range(width):
            i = 2 * (ty * width + tx)
            if i + 1 >= len(mp):
                continue
            e = mp[i] | mp[i + 1] << 8
            t, pal, hf, vf = e & 0x3FF, (e >> 10) & 7, e & 0x4000, e & 0x8000
            for y in range(8):
                for x in range(8):
                    c = tile_pixel(tiles, t, x, y)
                    px[tx * 8 + (7 - x if hf else x), ty * 8 + (7 - y if vf else y)] = cols[pal * 16 + c] if c else cols[0]
    return img.resize((img.width * scale, img.height * scale), Image.NEAREST)


def cmd_unpack(a):
    data, start = read_input(a.input, a.rom)
    out, n = unpack(data, start)
    where = '$%06X' % a.rom if a.rom is not None else a.input
    print('%s: packed %d bytes ($%X), unpacked %d bytes ($%X)' % (where, n, n, len(out), len(out)))
    if a.output:
        open(a.output, 'wb').write(out)


def cmd_tiles(a):
    Image = need_pillow()
    data = maybe_unpack(a.input)[a.offset:]
    n = a.count or len(data) // 32
    cols = palette(a.pal)
    row = a.palrow * 16
    w = a.columns
    h = (n + w - 1) // w
    img = Image.new('RGB', (w * 8, h * 8))
    px = img.load()
    for t in range(n):
        for y in range(8):
            for x in range(8):
                px[(t % w) * 8 + x, (t // w) * 8 + y] = cols[row + tile_pixel(data, t, x, y)]
    img = img.resize((img.width * a.scale, img.height * a.scale), Image.NEAREST)
    img.save(a.output)
    print('%d tiles -> %s' % (n, a.output))


def cmd_map(a):
    mp = maybe_unpack(a.input)[a.map_offset:]
    tiles = maybe_unpack(a.tiles)[a.tiles_offset:]
    height = a.height or (len(mp) // 2 + a.width - 1) // a.width
    render_map(mp, tiles, palette(a.pal), a.width, height, a.scale).save(a.output)
    print('%d x %d tiles -> %s' % (a.width, height, a.output))


def cmd_screen(a):
    data = maybe_unpack(a.input)
    mp = data[:a.map_size]
    tiles = data[a.tiles_offset:]
    if a.no_pal:
        cols = palette(None)
    elif a.pal:
        cols = palette(a.pal)
    else:
        cols = []
        for i in range(a.pal_offset, a.pal_offset + 512, 2):
            v = data[i] | data[i + 1] << 8 if i + 1 < len(data) else 0
            cols.append(((v & 31) * 255 // 31, ((v >> 5) & 31) * 255 // 31, ((v >> 10) & 31) * 255 // 31))
    height = a.height or a.map_size // 2 // a.width
    render_map(mp, tiles, cols, a.width, height, a.scale).save(a.output)
    print('%d x %d tiles -> %s' % (a.width, height, a.output))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    num = lambda s: int(s, 0)

    p = sub.add_parser('unpack', help='unpack a .pak file or a packed stream in the ROM')
    p.add_argument('input', nargs='?')
    p.add_argument('--rom', type=lambda s: int(s.lstrip('$'), 16), help='bank address of a packed stream in the ROM (hex)')
    p.add_argument('-o', '--output')
    p.set_defaults(func=cmd_unpack)

    p = sub.add_parser('tiles', help='tile sheet PNG')
    p.add_argument('input')
    p.add_argument('-o', '--output', default='tiles.png')
    p.add_argument('--offset', type=num, default=0, help='byte offset of the first tile')
    p.add_argument('--count', type=num, default=0)
    p.add_argument('--columns', type=num, default=16)
    p.add_argument('--pal')
    p.add_argument('--palrow', type=num, default=0, help='palette row (16 colours) for the sheet')
    p.add_argument('--scale', type=num, default=3)
    p.set_defaults(func=cmd_tiles)

    p = sub.add_parser('map', help='render a map with its tiles')
    p.add_argument('input')
    p.add_argument('--tiles', required=True)
    p.add_argument('-o', '--output', default='map.png')
    p.add_argument('--width', type=num, default=32, help='map width in tiles')
    p.add_argument('--height', type=num, default=0)
    p.add_argument('--map-offset', type=num, default=0)
    p.add_argument('--tiles-offset', type=num, default=0)
    p.add_argument('--pal')
    p.add_argument('--scale', type=num, default=2)
    p.set_defaults(func=cmd_map)

    p = sub.add_parser('screen', help='unpack and render a packed screen (map, palette, tiles)')
    p.add_argument('input')
    p.add_argument('-o', '--output', default='screen.png')
    p.add_argument('--width', type=num, default=32)
    p.add_argument('--height', type=num, default=0)
    p.add_argument('--map-size', type=num, default=0x700, help='bytes of map at the start (Title1: $700)')
    p.add_argument('--pal-offset', type=num, default=0x700, help='palette offset in the unpacked data (Title1: $700)')
    p.add_argument('--tiles-offset', type=num, default=0x800, help='tiles offset in the unpacked data (Title1: $800)')
    p.add_argument('--pal', help='palette file instead of the one in the screen')
    p.add_argument('--no-pal', action='store_true', help='grey levels')
    p.add_argument('--scale', type=num, default=2)
    p.set_defaults(func=cmd_screen)

    a = ap.parse_args()
    if a.cmd == 'unpack' and a.input is None and a.rom is None:
        ap.error('unpack needs a file or --rom')
    a.func(a)


if __name__ == '__main__':
    main()
