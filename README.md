# NHLPA Hockey '93 (SNES)

Bitwise rebuild of NHLPA Hockey '93 for the Super Nintendo, assembled with asar. The full build is byte-identical to `lst/nhlpa93snes.bin` (sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`). No segment is named yet: `src/bankXX_YYYY.asm` (128 ~4 KB segments) are a quick auto-generated pass.

## Lineage

The SNES port is a hybrid: it began as a port of NHL92 Genesis (likely while NHLPA93 Genesis was in development), then added what NHLPA93 needed. Some things look like 92G rather than 93G (in-game scoreboard layout, possibly title-screen credits colour). NHLPA93 Genesis is the naming source of truth; 92G names are used only where the SNES follows 92G with no 93G counterpart. See `docs/discovery93snes.md`. Related: [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis), [NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis), [NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis), [NHL92Genesis](https://github.com/abdulahmad/NHL92Genesis); McMarkis's NHL 94 SNES decomp for SNES-only systems.

## Layout

- `src/nhlpa93snes.asm` top level, `src/bankXX_YYYY.asm` one file per ~4 KB segment (FastROM mirror addresses), `src/inc/snes_regs.asm` hardware registers, `src/ram93snes.asm` RAM names.
- `lst/nhlpa93snes.bin` reference ROM (committed, as NHL94Genesis does).
- `tools/disasm65816.py` the quick-pass generator (recursive descent from the vectors, REP/SEP/PHP/PLP M/X tracking). Setup only.
- `SEGMENT_AGENT.md` queue and rules, `PROMPT.md` per-session prompt, `docs/HANDOFF.md` setup notes.

## Build

Requires asar 1.91 on PATH:

```sh
git clone --depth 1 https://github.com/RPGHacker/asar.git && cd asar
cmake -S src -B build -DCMAKE_BUILD_TYPE=Release -DASAR_GEN_LIB=OFF && cmake --build build -j
cp build/asar/bin/asar ~/.local/bin/
```

Then `./build.sh` (or `make`). It writes `output/nhlpa93snes.sfc` and prints MATCH / MISMATCH.
