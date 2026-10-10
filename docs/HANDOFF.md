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
- Task 4 (file layout): in progress.
