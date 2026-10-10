#!/usr/bin/env python3
"""snesgfx.py - unpack and view the NHLPA Hockey '93 (SNES) graphics assets in data/.

Formats (see data/README.md):
  *.pak       packed stream for the game's decompressor at $86FA3E (DecompressGraphics)
  *.chr       SNES 4bpp planar tiles, 32 bytes per 8x8 tile
  *.snesmap   SNES BG map words: vflip 15, hflip 14, priority 13, palette 12-10, tile 9-0
  *.snespal   SNES palette, BGR555 words (16 colours per palette row); the team files hold 93G words (see team_colours)
  *.pieces    sprite frame pieces (data/Sprites/setNN, with setNN.chr; the frame tables are read from src/gfx/sprites_*.asm)

Commands:
  unpack IN [-o OUT]                  unpack a .pak file (or --rom ADDR: a packed stream in lst/nhlpa93snes.bin)
  tiles IN [-o PNG]                   tile sheet of a .chr / unpacked file (--offset, --count, --columns)
  map MAP --tiles CHR [-o PNG]        render a map with its tiles (--width in tiles, --map-offset, --tiles-offset)
  screen IN.map.pak [-o PNG]          unpack a packed screen and render it (--map-size, --pal-offset, --tiles-offset)
  sprites SET|all [-o PNG|GIF]        sprite frames of a frame set (0-14) as a labelled sheet, or a .gif animation
                                      (--frames 406-461 picks global frame numbers, --team BOS, --visitor, --rink)

Sprites use the game palette (Rink.snespal) with sprite rows 2/3 from the --team home/visitor colours.
Palettes for tiles/map/screen: --pal FILE[:OFFSET] (a .snespal or any file with BGR555 words), else grey levels.
Rendering needs Pillow (python3 -m pip install pillow); unpack does not.

Examples:
  python tools/snesgfx.py screen data/Title1.map.pak -o title.png
  python tools/snesgfx.py screen data/EASN.map.pak --width 32 --map-size 0x400 --no-pal -o easn.png
  python tools/snesgfx.py tiles data/BigFont.chr.pak --columns 16 -o bigfont.png
  python tools/snesgfx.py map data/IceRink.snesmap --tiles data/IceRink.chr.pak --width 48 --pal data/Pals/Rink.snespal -o rink.png
  python tools/snesgfx.py sprites 0 -o set00.png
  python tools/snesgfx.py sprites --frames 406-461 --team MTL --visitor -o goalie.png
  python tools/snesgfx.py sprites --frames 41-48 -o skate.gif
  python tools/snesgfx.py sprites --frames 659-689 --rink -o crowd.gif
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


SRC = os.path.join(ROOT, 'src')
SPRITES = os.path.join(ROOT, 'data', 'Sprites')
PALS = os.path.join(ROOT, 'data', 'Pals')


def snes_rgb(v):
    return ((v & 31) * 255 // 31, ((v >> 5) & 31) * 255 // 31, ((v >> 10) & 31) * 255 // 31)


def team_colours(path):
    """16 colours of a team .snespal: 93G words 0000 BBBB GGGG RRRR, high byte first (SetTeamColors $80B706 shifts each up 1 bit)."""
    data = open(path, 'rb').read()
    return [snes_rgb((v & 0xF) << 1 | (v >> 4 & 0xF) << 6 | (v >> 8 & 0xF) << 11)
            for v in (data[i] << 8 | data[i + 1] for i in range(0, 32, 2))]


def sprite_palette(team, visitor_team=None):
    """The 128 sprite colours: Rink.snespal with sprite rows 2 (home) and 3 (visitor) from the team colours (setplayercolors)."""
    cols = palette(os.path.join(PALS, 'Rink.snespal'))[:128]
    if team:
        cols[32:48] = team_colours(os.path.join(PALS, team + 'h.snespal'))
        cols[48:64] = team_colours(os.path.join(PALS, (visitor_team or team) + 'v.snespal'))
    return cols


def asm_words(line):
    """The numbers of a 'dw' line (comment stripped), or None."""
    code = line.split(';')[0].strip()
    if not code.startswith('dw '):
        return None
    try:
        return [int(w.strip().replace('$', '0x'), 0) for w in code[3:].split(',')]
    except ValueError:
        return None


def sprite_sets():
    """The 15 frame sets of FrameSetTable ($8FE67D), read from their src/gfx/sprites_*.asm headers: number, first global frame
    (sprframe; frame 0 is no frame), piece start of each frame (+1 for the end), piece and tile counts, piece size."""
    lines = {}
    for name in sorted(os.path.join('gfx', n) for n in os.listdir(os.path.join(SRC, 'gfx'))):
        if os.path.basename(name).startswith('sprites') and name.endswith('.asm'):
            for i, line in enumerate(open(os.path.join(SRC, name), encoding='latin-1')):
                if line.startswith('SpriteSet') and ':' in line:
                    label = line.split(':')[0]
                    if label[9:].isdigit():
                        lines[int(label[9:])] = (name, i)
    sets, base = [], 1
    for n in range(len(lines)):
        name, start = lines[n]
        src = open(os.path.join(SRC, name), encoding='latin-1').read().splitlines()[start:]
        frames, pieces, tiles = (asm_words(src[k])[0] for k in (1, 2, 3))
        starts = []
        k = next(i for i, l in enumerate(src) if l.startswith('.frames:')) + 1
        while len(starts) < frames + 1:
            starts += asm_words(src[k]) or []
            k += 1
        size = os.path.getsize(os.path.join(SPRITES, 'set%02d.pieces' % n)) // pieces
        sets.append(dict(n=n, base=base, frames=frames, starts=starts, pieces=pieces, tiles=tiles, size=size))
        base += frames
    return sets


def frame_names():
    """Global frame number -> SPF name (the frame equates in src/ram93snes.asm)."""
    names = {}
    for line in open(os.path.join(SRC, 'ram93snes.asm'), encoding='latin-1'):
        code = line.split(';')[0]
        if code.startswith('SPF') and '=' in code:
            name, val = (s.strip() for s in code.split('='))
            names.setdefault(int(val.replace('$', '0x'), 0), name)
    return names


def frame_pieces(st, pieces, i, side=0):
    """Pieces of frame i of a set: (x, y, tile, palette row, size, hflip, vflip) as DrawFrame ($87CE62) / DrawFrameHi
    ($85FBB9) read them. side $8000 (sprflag) moves palette 2 (home colours) to 3 (visitor colours)."""
    out = []
    for p in range(st['starts'][i], st['starts'][i + 1]):
        b = pieces[p * st['size']:(p + 1) * st['size']]
        if st['size'] == 6:
            x, y, t, at = int.from_bytes(b[0:2], 'little', signed=True), int.from_bytes(b[2:4], 'little', signed=True), b[4], b[5]
        else:
            x, y, t, at = b[0] - (b[0] & 0x80) * 2, b[1] - (b[1] & 0x80) * 2, b[2], b[3]
        pal = (at >> 2) & 7
        if pal == 2 and side:
            pal = 3
        out.append((x, y, t | (at & 3) << 8, pal, 16 if at & 0x20 else 8, at & 0x40, at & 0x80))
    return out


def draw_frame(img, ox, oy, pcs, tiles, cols):
    """Draw the pieces with the frame origin at ox, oy. The first OAM entry is on top, so draw the list backwards.
    A 16 x 16 piece is tiles t, t+1 over t+16, t+17 (the second DMA at +$200)."""
    px = img.load()
    for x0, y0, t, pal, size, hf, vf in reversed(pcs):
        for y in range(size):
            for x in range(size):
                c = tile_pixel(tiles, t + (y >> 3) * 16 + (x >> 3), x & 7, y & 7)
                if c:
                    px[ox + x0 + (size - 1 - x if hf else x), oy + y0 + (size - 1 - y if vf else y)] = cols[pal * 16 + c]


def parse_frames(spec):
    """'406-461,500' -> set of global frame numbers."""
    out = set()
    for part in spec.split(','):
        lo, _, hi = part.partition('-')
        out.update(range(int(lo, 0), int(hi or lo, 0) + 1))
    return out


def cmd_sprites(a):
    Image = need_pillow()
    from PIL import ImageDraw
    sets = sprite_sets()
    names = frame_names() if not a.no_labels else {}
    want = parse_frames(a.frames) if a.frames else None
    if a.set == 'all':      # one file per set: sprites.png -> sprites00.png .. sprites14.png
        stem, ext = os.path.splitext(a.output)
        for st in sets:
            if not want or want & set(range(st['base'], st['base'] + st['frames'])):
                cmd_sprites(argparse.Namespace(**dict(vars(a), set=str(st['n']), output='%s%02d%s' % (stem, st['n'], ext))))
        return
    elif a.set is not None:
        chosen = [sets[int(a.set, 0)]]
    elif want:
        chosen = [s for s in sets if want & set(range(s['base'], s['base'] + s['frames']))]
    else:
        sys.exit('snesgfx: sprites needs a set number (0-%d), all, or --frames' % (len(sets) - 1))
    cols = sprite_palette(None if a.team.lower() == 'none' else a.team.upper(), a.visitor_team and a.visitor_team.upper())
    if a.bg.lower() == 'transparent':
        bg = (0, 0, 0, 0)
    elif a.bg:
        bg = tuple(int(a.bg.lstrip('#')[i:i + 2], 16) for i in (0, 2, 4)) + (255,)
    else:
        bg = cols[0] + (255,)
    back = None
    if a.rink:      # the crowd frames (659-689) are pieces of the vertical rink map, with the frame origin at its top left
        back = render_map(open(os.path.join(ROOT, 'data', 'IceRink.snesmap'), 'rb').read(),
                          maybe_unpack(os.path.join(ROOT, 'data', 'IceRink.chr.pak')), cols, 48, 85, 1).convert('RGBA')
    cols = [c + (255,) for c in cols]
    frames = []     # (global frame, pieces, tiles)
    for st in chosen:
        tiles = open(os.path.join(SPRITES, 'set%02d.chr' % st['n']), 'rb').read()
        pieces = open(os.path.join(SPRITES, 'set%02d.pieces' % st['n']), 'rb').read()
        for i in range(st['frames']):
            g = st['base'] + i
            if want is None or g in want:
                frames.append((g, frame_pieces(st, pieces, i, a.visitor), tiles))
    if not frames:
        sys.exit('snesgfx: no frames selected')
    # one cell size for all the frames, so they share the origin (and an animation does not jump)
    boxes = [(x, y, x + s, y + s) for _, pcs, _ in frames for x, y, _, _, s, _, _ in pcs] or [(0, 0, 1, 1)]
    x0, y0 = min(b[0] for b in boxes) - a.pad, min(b[1] for b in boxes) - a.pad
    w, h = max(b[2] for b in boxes) + a.pad - x0, max(b[3] for b in boxes) + a.pad - y0
    if back:
        x0, y0, (w, h) = 0, 0, back.size
    scale = a.scale or (1 if back else 3)

    def cell(pcs, tiles):
        img = back.copy() if back else Image.new('RGBA', (w, h), bg)
        draw_frame(img, -x0, -y0, pcs, tiles, cols)
        if a.origin:
            px = img.load()
            for d in range(-2, 3):
                for x, y in ((-x0 + d, -y0), (-x0, -y0 + d)):
                    if 0 <= x < w and 0 <= y < h:
                        px[x, y] = (255, 0, 255, 255)
        return img.resize((w * scale, h * scale), Image.NEAREST)

    if a.output.lower().endswith('.gif'):
        imgs = [cell(pcs, tiles) for _, pcs, tiles in frames]
        imgs[0].save(a.output, save_all=True, append_images=imgs[1:], duration=a.delay, loop=0, disposal=2)
        print('%d frames (%d-%d) -> %s' % (len(frames), frames[0][0], frames[-1][0], a.output))
        return
    label = 0 if a.no_labels else 12
    cw, ch = max(w * scale, 8 if a.no_labels else 40), h * scale + label
    ncol = min(a.columns, len(frames))
    sheet = Image.new('RGBA', (ncol * (cw + 2) + 2, (len(frames) + ncol - 1) // ncol * (ch + 2) + 2), (40, 40, 40, 255))
    draw = ImageDraw.Draw(sheet)
    for k, (g, pcs, tiles) in enumerate(frames):
        cx, cy = 2 + (k % ncol) * (cw + 2), 2 + (k // ncol) * (ch + 2)
        sheet.paste(cell(pcs, tiles), (cx + (cw - w * scale) // 2, cy + label))
        if label:
            draw.text((cx + 1, cy), '%d %s' % (g, names.get(g, '')), fill=(255, 255, 255, 255) if g in names else (170, 170, 170, 255))
    sheet.save(a.output)
    print('%d frames (%d-%d) -> %s' % (len(frames), frames[0][0], frames[-1][0], a.output))


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

    p = sub.add_parser('sprites', help='render the sprite frames of a frame set (data/Sprites) to a sheet or GIF')
    p.add_argument('set', nargs='?', help='frame set 0-14, or all (default: the sets of --frames)')
    p.add_argument('-o', '--output', default='sprites.png', help='a .gif output is an animation of the frames')
    p.add_argument('--frames', help='global frame numbers (sprframe, the SPF names), e.g. 406-461,500')
    p.add_argument('--team', default='BOS', help='team colours for sprite palettes 2/3 (data/Pals/<team>h/v), or none')
    p.add_argument('--visitor', action='store_const', const=0x8000, default=0, help='draw palette 2 pieces in the visitor colours (sprflag $8000)')
    p.add_argument('--visitor-team', help='a different team for the visitor colours')
    p.add_argument('--bg', default='', help='background RRGGBB or transparent (default: palette colour 0, the ice)')
    p.add_argument('--columns', type=num, default=16)
    p.add_argument('--pad', type=num, default=1, help='pixels around the union of the frame boxes')
    p.add_argument('--origin', action='store_true', help='mark the frame origin (sprx, spry)')
    p.add_argument('--rink', action='store_true', help='draw the frames on the vertical rink map (the crowd frames 659-689)')
    p.add_argument('--no-labels', action='store_true')
    p.add_argument('--delay', type=num, default=100, help='GIF frame time in ms')
    p.add_argument('--scale', type=num, default=0, help='default 3, or 1 with --rink')
    p.set_defaults(func=cmd_sprites)

    a = ap.parse_args()
    if a.cmd == 'unpack' and a.input is None and a.rom is None:
        ap.error('unpack needs a file or --rom')
    a.func(a)


if __name__ == '__main__':
    main()
