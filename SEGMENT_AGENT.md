# NHLPA 93 SNES segment agent

This file is the queue and the history. Do not rewrite it as a whole file. Edit it in place.
(Adapted from the NHL94Genesis SEGMENT_AGENT.md for 65816 / asar.)

## Current segment

`bank80` (ROM $00000-$07FFF, org `$808000`). <- CURRENT

`ram93snes` is not a queue segment. It has no ROM bytes, so there is nothing to byte-verify, and the queue moves past its row. That does not put RAM off limits. RAM names come from the code segments as they are transcribed, not from a separate first pass: add each one to `src/ram93snes.asm` whenever it fits. Define each name in one place only.

## Lineage (read first)

NHLPA Hockey 93 SNES is a hybrid. The SNES port started from NHL92 Genesis (likely while NHLPA93 Genesis was still in development), then took what it needed from NHLPA93 Genesis. Some things look more like 92G than 93G (in-game scoreboard layout, possibly the title-screen credits text colour). `docs/discovery93snes.md` maps SNES addresses to 92G and 93G addresses (penalty.asm strings, Teamdata.asm, scouting report, pause menu, setoptions, GameLabels, title credits).

**NHLPA93 Genesis is the source of truth for function, variable and label names.** Use an NHL92 Genesis name only where the SNES code follows 92G and 93G has no counterpart. Otherwise name it from what it does. McMarkis's NHL 94 SNES decomp is a later naming reference for SNES-only systems (PPU/DMA/SPC700 driver), not a source that beats 93G.

## Sources

- Reference ROM: `lst/nhlpa93snes.bin` (524288 bytes, sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`). Bytes and branch targets come from it. Do not substitute another ROM.
- There is no IDA listing. The starting point is the auto-generated `src/bankXX.asm` (quick recursive-descent pass from the vectors, `tools/disasm65816.py`). Each instruction line carries `; $address: bytes`. Unreached bytes are `db` lines: they are unresolved, not proven data. Do not re-run the generator over a bank once it has been edited.
- Style / naming source: https://github.com/abdulahmad/NHLPA93Genesis (first), then https://github.com/abdulahmad/NHL92Genesis where 93 lacks the routine.
- `src/nhlpa93snes.asm` is the full build top level: `inc/snes_regs.asm`, `ram93snes.asm`, then the bank files in ROM order. Keep includes in ROM order.

## Mapping

LoROM + FastROM (header map mode `$30`), 4 Mbit, 16 banks of 32 KB. Code runs in banks `$80-$8F` (FastROM mirror); ROM offset = (bank&$7F)*$8000 + (addr-$8000). Header at `$80FFC0` (title `NHLPA Hockey '93`, ROM type `$00`, size `$09`, SRAM `$00`, region `$01` NA, maker `$69`, version `$00`, complement/checksum `$B75A`/`$48A5`).
Vectors: native COP `$80B4`, BRK `$80B2`, ABORT `$80B4`, NMI `$80B4`, IRQ `$8390`; emulation RESET `$8000`, NMI/COP/ABORT `$80B4`, IRQ/BRK `$8390` (all bank `$80`).

## Build

`./build.sh` assembles `src/nhlpa93snes.asm` with asar 1.91 into `output/nhlpa93snes.sfc` and compares sha1 with `lst/nhlpa93snes.bin`. It prints MATCH or MISMATCH plus the first differing offsets. The whole ROM builds in under a second, so the full build is the segment verify. Only a MATCH run this session counts.

## Rules (65816 / asar)

- Never change a byte. Every session ends with `./build.sh` printing MATCH.
- Width is explicit. Immediates: `lda.b #$12` (M=8) / `lda.w #$1234` (M=16); same for X/Y with the X flag. Track M and X through `rep`/`sep`/`php`/`plp`/`rti` and across `jsr`/`jsl` callers. A wrong width shifts every following byte. The generator's `; M= X=` note on a label is a guess from one path.
- Addressing size is explicit: `.b` direct page, `.w` absolute (uses DB), `.l` long. Do not drop the suffix: asar would choose its own size. `jsr` is 2-byte, `jsl` is long; `rts` vs `rtl` must match the caller.
- Direct page (D) and data bank (DB) matter for what an operand means. Note `pld`/`tcd`/`plb`/`phk : plb` changes. A `.w` operand is a RAM name only when DB is `$00-$3F/$80-$BF` (or `$7E` and the address is WRAM).
- Branches use labels (`bne CODE_80803D` or a real name). Never a bare number: asar reads `bne $xxxx` differently. A branch whose target is not a decoded instruction stays as `db` with the comment.
- Replace `db` with instructions only after you have traced the entry and M/X. Jump tables (`jmp (abs,x)`, `jsr (abs,x)`, pushed-address `rts` tricks) are the main source of unreached code: write the table as `dw label` entries.
- Hardware registers use the names in `src/inc/snes_regs.asm` (`sta.w INIDISP`). Add DMA channel names there as needed.
- Data goes in the segment of the code that owns it. Graphics (4bpp planar composite, from about ROM `$709A7`) become `incbin` files under `data/` named for the asset (93G / 92G file name when it is the same asset), never an address. Pointers inside data are written with labels.
- A 93G name is the field even when the SNES value differs. The equate gets the SNES value; the comment records the 93G value.
- A global label ends local-label scope (asar `.local` labels belong to the previous global). Keep comment lines under 200 characters.
- Do not delete an asm file. Edit it in place. Split a bank into logical files (e.g. `penalty93s.asm`, `teamdata93s.asm`) only by cutting the text at an instruction/data boundary and adding the include in ROM order in the same session; add the new row to the ROM map.
- RAM names go in `src/ram93snes.asm` as you transcribe. Do not wait for a RAM pass.

## Practical notes (from the sample session)

- A bank is 32 KB; one session will not finish it. Work in ROM order from the last named address, mark the row `in progress` with the named ranges, and leave Current segment on that bank until all of it is named or proven data.
- Code reached only through a RAM vector (`vbint` $14, `hbint` $16, the `lda #addr-1 : pha : rts` dispatch) or a jump table is `db` in the quick pass. To decode it, run the generator into a scratch dir with extra entries and paste only that region: `python3 tools/disasm65816.py lst/nhlpa93snes.bin /tmp/dis --entry 8080CE:16:16` (M:X widths at entry, 8 or 16). Never write its output into `src/` for a bank already edited.
- asar locals are `.name:` and belong to the last global label; a branch from one global into another's local fails, so a shared tail gets its own global (`vb2_main`).
- Labels work as 16-bit immediates (`lda.w #vb2`) and DP equates work with `.b` (`sta.b vbint`); asar truncates to the written size. Equates go in `ram93snes.asm` as `name = $xx`.
- The vector table and header ($80FFC0-$80FFFF) are still `db`; when you reach them write `dw VBjsr` etc. and keep MATCH.

## Naming rules

- Match a routine to the 93G routine when the body does the same thing. Keep the 93G name. If only 92G has it (and the SNES follows 92G), use the 92G name and note `;92G` on the definition.
- If the name is already used for a different routine, do not steal it. Name the new routine from what it does.
- Put the generator name in one `;auto: CODE_xxxxxx` comment on the definition, not on every line.
- Do not leave `CODE_` names in a matched segment.
- Bring over the 93G/92G comment when the routine matches. If there is none, add one that says what it does.

## ROM map

The first row that is not matched is the current segment. Code% is the share of the bank the quick pass decoded as instructions (some decodes outside bank $80/$8F may be false positives from `jsl` into data: check them).

| File | Status | Org | ROM range | Code% | Note |
|---|---|---|---|---|---|
| bank80 | in progress <- CURRENT (named so far: $8000-$81C4, $8390-$83AA) | $808000 | $00000-$07FFF | 55% | Reset $8000, NMI/COP $80B4, IRQ $8390. Penalty strings $BF9C-$C16B (92G penalty.asm $966C). Header $FFC0-$FFFF stays data |
| ram93snes | skipped | no org (equates only) | - | - | RAM map, not a queue segment |
| bank81 | not matched | $818000 | $08000-$0FFFF | 0% | Nothing reached |
| bank82 | not matched | $828000 | $10000-$17FFF | 3% | |
| bank83 | not matched | $838000 | $18000-$1FFFF | 0% | Teamdata $80F8-$C4A9 (92G Teamdata.asm $116C-$32DA); scouting report intro text $D630 (93G $2CEC8) |
| bank84 | not matched | $848000 | $20000-$27FFF | 4% | penalty.asm DisplayStats $FAEC (92G $A784); title credits $FAAA-$FCF4 (93G $4B3C); 'Ice','Bench' $FDC8 (93G $78E8) |
| bank85 | not matched | $858000 | $28000-$2FFFF | 3% | |
| bank86 | not matched | $868000 | $30000-$37FFF | 2% | |
| bank87 | not matched | $878000 | $38000-$3FFFF | 3% | |
| bank88 | not matched | $888000 | $40000-$47FFF | 12% | |
| bank89 | not matched | $898000 | $48000-$4FFFF | 1% | |
| bank8A | not matched | $8A8000 | $50000-$57FFF | 2% | |
| bank8B | not matched | $8B8000 | $58000-$5FFFF | 3% | |
| bank8C | not matched | $8C8000 | $60000-$67FFF | 1% | |
| bank8D | not matched | $8D8000 | $68000-$6FFFF | 5% | StartHL2 'Highlight from game:' $F8D7 (92G $AC98) |
| bank8E | not matched | $8E8000 | $70000-$77FFF | 2% | Tile data (4bpp planar composite) from about ROM $709A7 |
| bank8F | not matched | $8F8000 | $78000-$7FFFF | 27% | PerLabels $8248 (92G $A34E), GameLabels $89A5, 'Status ]' $D7A3, Scouting labels $DF68, PauseMode $EDC8, setoptions cpo $F395, 'GOAL'/'HAT TRICK!' $FFE1 |

## History

- Setup: quick pass, 16 bank files, full build MATCH (sha1 76a01492...).
- Sample (branch sample-bank80): bank80 Start, BRKHalt, VBjsr, vb2_blank, vb2, vb2_main, VBlank, HBjsr, HBdefault named; $80CE-$81C4 decoded from db (vbint targets reached only through `vbint`). RAM $00-$18 named in ram93snes.asm. MATCH.
