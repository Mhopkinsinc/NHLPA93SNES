# Setup handoff (2026-10-09)

- ROM: LoROM/FastROM ($30), 4 Mbit, header at ROM $7FC0 (`$80FFC0`), checksum $48A5 / complement $B75A.
- Vectors (bank $80): RESET $8000; NMI $80B4 (native and emulation, also COP/ABORT); BRK native $80B2; IRQ $8390.
  Note: NMI shares $80B4 with COP/ABORT; check whether $80B4 is a real NMI handler or an RTI stub with the real NMI elsewhere (e.g. jumped via RAM).
- Quick pass: `python3 tools/disasm65816.py lst/nhlpa93snes.bin src` (do not rerun after edits). 1962 entry labels; ~40 KB (7.6%) decoded as code, ~484 KB left as db. Most code is in $80 (55%) and $8F (27%), $88 (12%). Small decodes in other banks may be false (jsl into data).
- Biggest gap: indirect jumps/jump tables and code only reached through them; every bank except $80/$8F is mostly unresolved.
- asar notes: branch operands must be labels (a literal is not a target address in asar); all operand sizes written with .b/.w/.l; `check bankcross off`, `--fix-checksum=off`.
- Open decisions: whether to split banks into logical files (penalty, teamdata, ...) now or as segments are worked; asset extraction (graphics incbins) tooling; NHL92 Genesis reference repo location.
