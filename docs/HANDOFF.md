## Current state (name review)

Name review pass, one file per push; checklist in `docs/name_review_93s.md`. Done: `src/middle_b80.asm`, `src/logic_b8B.asm`, `src/middle_b86.asm`, `src/sound_b82.asm`, `src/video_b8F.asm`, `src/sound_b84.asm`, `src/video_b8B.asm`, `src/sound_b81.asm`, `src/middle_b89.asm`, `src/stats_b8F.asm`, `src/sound_b8F.asm`, `src/middle_b84.asm`, `src/sound_b8D.asm`, `src/logic_b87.asm`, `src/middle_b82.asm`, `src/video_b82.asm`, `src/video_b88.asm`, `src/main.asm`, `src/video_b8D.asm`, `src/penalty_b88.asm`, `src/sound_b86.asm`, `src/logic_b83.asm`, `src/teamdata_b8A.asm`, `src/hockey_b85.asm`, `src/logic_b8A.asm`, `src/penalty_b82.asm`, `src/penalty_b84.asm`, `src/hockey_b82.asm`, `src/logic_b86.asm`, `src/middle_b8D.asm`, `src/sound_b89.asm`, `src/video_b8C.asm`, `src/video_b84.asm`, `src/logic_b82.asm`, `src/penalty_b8A.asm`, `src/hockey_b87.asm`, `src/penalty_b89.asm`, `src/hockey_b86.asm`, `src/logic_b8C.asm`, `src/middle_b8B.asm`, `src/middle_b88.asm`, `src/gfx/graphics_b8F.asm`, `src/gfx/sprites_b8D.asm`, `src/gfx/graphics_b89.asm`, `src/gfx/graphics_b83.asm`, `src/gfx/sprites_b84.asm`, `src/gfx/graphics_b88.asm`, `src/gfx/graphics_b80.asm`, `src/gfx/graphics_b82.asm`, `src/gfx/graphics_b84.asm`, `src/gfx/graphics_b85.asm`, `src/gfx/graphics_b87.asm`, `src/gfx/graphics_b8A.asm`, `src/gfx/graphics_b8C.asm`, `src/gfx/graphics_b8D.asm`, `src/gfx/sprites_b85.asm`, `src/gfx/sprites_b87.asm`, `src/gfx/sprites_b88.asm`. Next: the smaller files with generic locals (...), then `logic_b80`/`hockey_b80`/`penalty_b80`/`frames`. Rename history goes in `docs/name_map.csv` only.

# Setup handoff (2026-10-09)

- ROM: LoROM/FastROM ($30), 4 Mbit, header at ROM $7FC0 (`$80FFC0`), checksum $48A5 / complement $B75A.
- Vectors (bank $80): RESET $8000; NMI $80B4 (native and emulation, also COP/ABORT); BRK native $80B2; IRQ $8390.
  Note: NMI shares $80B4 with COP/ABORT; check whether $80B4 is a real NMI handler or an RTI stub with the real NMI elsewhere (e.g. jumped via RAM).
- Quick pass: `python3 tools/disasm65816.py lst/nhlpa93snes.bin src` (do not rerun after edits). 1962 entry labels; ~40 KB (7.6%) decoded as code, ~484 KB left as db. Most code is in $80 (55%) and $8F (27%), $88 (12%). Small decodes in other banks may be false (jsl into data).
- Biggest gap: indirect jumps/jump tables and code only reached through them; every bank except $80/$8F is mostly unresolved.
- asar notes: branch operands must be labels (a literal is not a target address in asar); all operand sizes written with .b/.w/.l; `check bankcross off`, `--fix-checksum=off`.
- Open decisions: whether to split banks into logical files (penalty, teamdata, ...) now or as segments are worked; asset extraction (graphics incbins) tooling. NHL92 Genesis reference: https://github.com/abdulahmad/NHL92Genesis.

## Cleanup progress (source cleanup pass, 2026-10-10)

Branch `cursor/source-cleanup-fbaa`. Every commit builds MATCH. Counts come from `python3 tools/scan_cleanup.py` (after `./build.sh`).

- Byte-dump comments: removed before this pass (d0c7a3d); none left.
- Task 1 (names for addresses): done. ROM pointer immediates and bank bytes use labels (`#label`, `#label>>16`, `#label&$FFFF`), `jml jmlvector`/`jml Restart`, `unpackbuf` ($7F0000), `mesarea` pointers, team record offsets (Playerdata..ScoreOdds), all 8 DMA channels and register value constants in `src/inc/snes_regs.asm`. HotList's last 428 bytes are a packed tile stream: `RinkLogoTiles`. `ScoutPicMap` is the 93G `FaceOffMap`.
- Task 2 (generic names): done. `;auto: CODE_xxxxxx` traces moved to `docs/name_map.csv`; the 442 `.lN` locals renamed by use; far trampolines named.
- Task 3 (Genesis comments): header comments of 290 routines with a 93G/92G counterpart brought over (93G text first, `SNES:` line after). Every routine has a header comment. Inline 93G comments are not copied (not done).
- Task 4 (file layout): done. The `bankXX_YYYY` slices are regrouped into 93G module files, one file per module per bank: `src/main.asm`, `src/frames.asm`, `src/{hockey,logic,middle,penalty,video,stats,sound,teamdata}_bXX.asm`, and graphics/sprite data in `src/gfx/{graphics,sprites}_bXX.asm`. Each file keeps the original `org` per block (247 blocks), so every byte stays at its address. `src/nhlpa93snes.asm` includes them all. The file-by-block list is in `docs/file_map.md`, the old slice header notes are in `docs/segment_notes.md`, and the `file` column of `docs/name_map.csv` gives the new file. Committed one bank per commit ($81 and $82 together because the GameSamples unit spans both).
- Task 5 (final scan, `tools/scan_cleanup.py`, 92 files):

  | count | before (main) | now |
  |---|---|---|
  | raw address operands | 15 | 4 |
  | raw pointer immediates | 9 | 0 |
  | raw bank-byte immediates | 30 | 0 |
  | noise / byte-dump comments | 0 | 0 |
  | generic `CODE_`/`DATA_` labels | 0 | 0 |
  | `;auto:` traces | 435 | 0 |
  | `.lN` auto locals (refs) | 971 | 0 |
  | globals without a header comment | - | 0 |

Per bank: banks $80-$8F all went through tasks 1-4. Code is mostly in $80, $88 and $8F; the other banks are mostly data in `src/gfx/` and `teamdata_*`.

Left as is (with reason):
- 4 operands `lda.w $0000,y` / `sta.w $0000,y` (in `penalty_b80`/the old bank80_D000/bank84_F000 code). The base really is zero (Y holds a full address), so no label applies.
- Bank-suffixed data/RAM names (`sfx8F`, `PixelRemap83`, `jdtab8F`, `dirtab8F`, `unusedFFxx`). No 93G counterpart is confirmed yet.

What's next:
- Copy the important 93G inline comments, matching them instruction by instruction.
- Rename the remaining generic locals (`.zero`, `.join`, `.skip`, `.lt`, ...) by reading the code.
- Split the larger `hockey_bXX`/`logic_bXX` files further once more routines are identified, and keep `docs/file_map.md` in step with them.
