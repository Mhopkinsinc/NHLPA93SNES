# NHLPA Hockey '93 (SNES)

**AI agent: start with [START_HERE.md](START_HERE.md).**

Bitwise rebuild of NHLPA Hockey '93 for the Super Nintendo, assembled with asar. The full build is byte-identical to `lst/nhlpa93snes.bin` (sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`). Every bank is disassembled and named; the source is laid out like the NHLPA 93 Genesis source (one file per 93G module per bank).

## Lineage

The SNES port is a hybrid: it began as a port of NHL92 Genesis (likely while NHLPA93 Genesis was in development), then added what NHLPA93 needed. Some things look like 92G rather than 93G (in-game scoreboard layout, possibly title-screen credits colour). NHLPA93 Genesis is the naming source of truth; 92G names are used only where the SNES follows 92G with no 93G counterpart. See `docs/discovery93snes.md`. Related: [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis), [NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis), [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis), [NHL92Genesis](https://github.com/abdulahmad/NHL92Genesis); McMarkis's NHL 94 SNES decomp for SNES-only systems.

## Layout

- `src/nhlpa93snes.asm` top level. Module files named after the 93G source files: `main`, `video_bXX`, `logic_bXX`, `hockey_bXX`, `middle_bXX`, `penalty_bXX`, `stats_bXX`, `sound_bXX`, `frames`, `teamdata_bXX`; graphics data in `src/gfx/` (`graphics_bXX`, `sprites_bXX`). Each file holds that module's code of one bank as `org` blocks at their ROM addresses (FastROM mirror). `docs/file_map.md` lists every block and routine.
- `src/inc/snes_regs.asm` hardware registers and register values, `src/macros/snes93.mac` macros, `src/ram93snes.asm` RAM names and constants.
- `docs/name_map.csv` the quick-pass names (`CODE_xxxxxx`) of the named routines; `docs/segment_notes.md` the notes of the old ~4 KB slices.
- `tools/scan_cleanup.py` counts raw addresses, generic labels and noise comments left in `src/`.
- `lst/nhlpa93snes.bin` reference ROM (committed, as NHL94Genesis does).
- `tools/disasm65816.py` the quick-pass generator (recursive descent from the vectors, REP/SEP/PHP/PLP M/X tracking). Setup only; it wrote the old `bankXX_YYYY` slices.
- `data/` the incbin assets; `data/README.md` describes the file formats (`.map.pak`, `.chr.pak`, `.snesmap`, `.snespal`, ...).
- `tools/snesgfx.py` unpacks the packed streams (a port of `DecompressGraphics`) and renders tiles, maps and screens to PNG.
- `SEGMENT_AGENT.md` rules and the per-slice history, `PROMPT.md` the per-segment prompt (segment phase, finished), `docs/HANDOFF.md` setup notes and the cleanup progress.

## Build

Requires asar 1.91 on PATH:

```sh
git clone --depth 1 https://github.com/RPGHacker/asar.git && cd asar
cmake -S src -B build -DCMAKE_BUILD_TYPE=Release -DASAR_GEN_LIB=OFF && cmake --build build -j
cp build/asar/bin/asar ~/.local/bin/
```

Or run `sh tools/setup.sh` (Linux/macOS) or `tools\setup.ps1` (Windows), which install asar 1.91 into `tools/bin`. Then `./build.sh` (or `make`, or `build.ps1` on Windows). It writes `output/nhlpa93snes.sfc` and prints MATCH / MISMATCH.
