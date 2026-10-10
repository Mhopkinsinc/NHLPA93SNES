# data/

Binary assets that the `src/bank*.asm` files `incbin`. Each file holds the exact ROM bytes, so the build stays byte-identical.
The file extension gives the format. The SNES formats are not the same as the Genesis (93G/94G) `.map.jim` / `.pal` / `.tiles` files of the
same names, so the SNES files get their own extensions.

| Extension | Format | Files |
|-----------|--------|-------|
| `.map.pak` | Packed screen: map words, then palette, then tiles in one stream (see Screens below) | `Title1`, `EASN`, `RonBarr`, `GameSetup` |
| `.chr.pak` | Packed SNES 4bpp tiles | `IceRink`, `BigFont`, `RinkSideTiles1`, `RinkSideTiles2`, `MenuTiles88`, `TeamBlocks` |
| `.chr` | SNES 4bpp planar tiles, 32 bytes per 8x8 tile, not packed | `Sprites/setNN.chr`, `Framer` |
| `.pieces` | Sprite frame set header and piece table (see `DrawFrame`, `bank87_C000`) | `Sprites/setNN.pieces` |
| `.snesmap` | SNES BG map words, not packed: vflip 15, hflip 14, priority 13, palette 12-10, tile 9-0 | `IceRink` (48 x 85), `IceRinkHor`, `Refs` |
| `.snespal` | SNES palette, BGR555 words, 16 colours per row | `Pals/<team>h`, `Pals/<team>v`, `Pals/Rink` |
| `.brr` | SPC700 BRR sound samples (the sample block of an SPC upload stream) | `bootsamples`, `gamesamples` |
| `.spc700` | SPC700 sound driver code, uploaded to APU $0400 | `spc/driver` |
| `.bin` | Tables or text with their own format, described where they are included | `HotList`, `Text/ScoutingReportText` |

Genesis vs SNES, for comparison:

| | Genesis | SNES |
|-|---------|------|
| Palette word | 9-bit `0000 BBB0 GGG0 RRR0` | BGR555 `0BBBBBGGGGGRRRRR` |
| Tiles | 4bpp packed, 4 bits per pixel | 4bpp planar, bitplanes 0/1 then 2/3 |
| Map word | priority 15, palette 14-13, vflip 12, hflip 11, tile 10-0 | vflip 15, hflip 14, priority 13, palette 12-10, tile 9-0 |
| Packing | `.jim` / `.anim` containers | the `DecompressGraphics` stream below |

## Packed streams (`.pak`)

`DecompressGraphics` (`$86FA3E`, `bank86_F000`) unpacks a stream to `$7F0000`. Control bytes:

- `$00-$1F`: copy the next n+1 bytes
- `$2x`: write n+1 zero bytes
- `$3x`: write the next byte n+3 times
- `$40-$7F`, `$8x`, `$9x`, `$Ax`, `$Bx`: copy from earlier output, going up
- `$C0-$DF`, `$Ex`, `$Fx`: copy from earlier output, going down
- `$E0 $00`: end of stream

## Screens (`.map.pak`)

The unpacked data holds the map words, then the palette, then the tiles. Offsets:

| File | Map | Palette | Tiles | Notes |
|------|-----|---------|-------|-------|
| `Title1.map.pak` | 32 x 28 at 0 | at $700 | at $800 | title screen (93G `Title1.map.jim`) |
| `RonBarr.map.pak` | 8 x 9 at 0 | 64 colours at $90 | at $190 | Ron Barr picture (93G `RonBarrMap`) |
| `GameSetup.map.pak` | 32 x 32 at 0 | 128 colours at $800 | at $900 | game setup backdrop; `--map-size 0x800 --pal-offset 0x800 --tiles-offset 0x900` |
| `EASN.map.pak` | 32 x 16 at 0 | none | at $400 | EASN logo backdrop (93G `EASN.map.jim`); `--map-size 0x400 --no-pal` |

## tools/snesgfx.py

This script unpacks and renders the assets above, for checking a guess about what a block holds. Rendering needs Pillow
(`python -m pip install pillow`); `unpack` does not.

```
python tools/snesgfx.py unpack data/EASN.map.pak -o easn.bin
python tools/snesgfx.py unpack --rom 0x80ED38 -o block.bin       # a packed stream still in lst/nhlpa93snes.bin
python tools/snesgfx.py screen data/Title1.map.pak -o title.png
python tools/snesgfx.py screen data/RonBarr.map.pak --width 8 --map-size 0x90 --pal-offset 0x90 --tiles-offset 0x190 -o ronbarr.png
python tools/snesgfx.py tiles data/BigFont.chr.pak --columns 16 -o bigfont.png
python tools/snesgfx.py map data/IceRink.snesmap --tiles data/IceRink.chr.pak --width 48 --pal data/Pals/Rink.snespal -o rink.png
```

A `.pak` input is unpacked automatically. `--pal FILE[:OFFSET]` takes any file that holds BGR555 words. Without it, colours are grey levels.
