# NHLPA 93 SNES segment agent

This file is the queue and the history. Do not rewrite it as a whole file. Edit it in place.
(Adapted from the NHL94Genesis SEGMENT_AGENT.md for 65816 / asar.)

## Current segment

`bank86_B000` ($86B000-$86BFFF). <- CURRENT

`ram93snes` is not a queue segment. It has no ROM bytes, so there is nothing to byte-verify, and the queue moves past its row. That does not put RAM off limits. RAM names come from the code segments as they are transcribed, not from a separate first pass: add each one to `src/ram93snes.asm` whenever it fits. Define each name in one place only.

## Lineage (read first)

NHLPA Hockey 93 SNES is a hybrid. The SNES port started from NHL92 Genesis (likely while NHLPA93 Genesis was still in development), then took what it needed from NHLPA93 Genesis. Some things look more like 92G than 93G (in-game scoreboard layout, possibly the title-screen credits text colour). `docs/discovery93snes.md` maps SNES addresses to 92G and 93G addresses (penalty.asm strings, Teamdata.asm, scouting report, pause menu, setoptions, GameLabels, title credits).

**NHLPA93 Genesis is the source of truth for function, variable and label names.** Use an NHL92 Genesis name only where the SNES code follows 92G and 93G has no counterpart. Otherwise name it from what it does. McMarkis's NHL 94 SNES decomp is a later naming reference for SNES-only systems (PPU/DMA/SPC700 driver), not a source that beats 93G.

## Sources

- Reference ROM: `lst/nhlpa93snes.bin` (524288 bytes, sha1 `76a01492cfb656e9fce0094bca356c312adfea0e`). Bytes and branch targets come from it. Do not substitute another ROM.
- There is no IDA listing. The starting point is the auto-generated `src/bankXX_YYYY.asm` slices (quick recursive-descent pass from the vectors, `tools/disasm65816.py`). Each instruction line carries `; $address: bytes`. Unreached bytes are `db` lines: they are unresolved, not proven data. Do not re-run the generator over a bank once it has been edited.
- Style / naming source: https://github.com/abdulahmad/NHLPA93Genesis (first), then https://github.com/abdulahmad/NHL92Genesis where 93 lacks the routine.
- `src/nhlpa93snes.asm` is the full build top level: `inc/snes_regs.asm`, `ram93snes.asm`, then the segment files in ROM order. Keep includes in ROM order.

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

- Segments are ~4 KB slices of a bank (`src/bankXX_YYYY.asm`, org = first line address; a slice starts at the first line at or after $YYYY). If one session does not finish a slice, mark it `in progress` with the named ranges and leave Current segment on it. You may move a boundary to a function/region edge: move the lines between the two adjacent files, fix both orgs and both rows. Each file keeps its own `org`.
- asar label scope continues across `incsrc`: a `.local` at the top of a slice belongs to the last global in the previous slice. Give it a global name when you work that slice.
- Code reached only through a RAM vector (`vbint` $14, `hbint` $16, the `lda #addr-1 : pha : rts` dispatch) or a jump table is `db` in the quick pass. To decode it, run the generator into a scratch dir with extra entries and paste only that region: `python3 tools/disasm65816.py lst/nhlpa93snes.bin /tmp/dis --entry 8080CE:16:16` (M:X widths at entry, 8 or 16). Never write its output into `src/` for a bank already edited.
- asar locals are `.name:` and belong to the last global label; a branch from one global into another's local fails, so a shared tail gets its own global (`vb2_main`).
- Labels work as 16-bit immediates (`lda.w #vb2`) and DP equates work with `.b` (`sta.b vbint`); asar truncates to the written size. Equates go in `ram93snes.asm` as `name = $xx`.
- The vector table and header ($80FFC0-$80FFFF) are still `db`; when you reach them write `dw VBjsr` etc. and keep MATCH.

## Naming rules

- A segment is matched only when it is fully named: routines, local labels, RAM variables, parameters, constants / bit values, data tables, hardware registers, and comments. Routine names alone are not enough.
- Runs are one bank (8 segments) at a time; see START_HERE.md. After the bank, stop and report to the user.

- Match a routine to the 93G routine when the body does the same thing. Keep the 93G name. If only 92G has it (and the SNES follows 92G), use the 92G name and note `;92G` on the definition.
- If the name is already used for a different routine, do not steal it. Name the new routine from what it does.
- Put the generator name in one `;auto: CODE_xxxxxx` comment on the definition, not on every line.
- Do not leave `CODE_` names in a matched segment.
- Bring over the 93G/92G comment when the routine matches. If there is none, add one that says what it does.

## ROM map

The first row that is not matched is the current segment. Code% is the share of the bank the quick pass decoded as instructions (some decodes outside bank $80/$8F may be false positives from `jsl` into data: check them).

| File | Status | Org | End | Code% | Note |
|---|---|---|---|---|---|
| bank80_8000 | matched | $808000 | $80910E | 100% | 4367 bytes $808000-$80910E (end moved from $808FFF to the doshot table). Start, VBjsr, vb2*, VBlank* handlers, HBjsr; 93G goalieacc, dostop, StopNA, muls16, getpde, rtss, MaxSpeed, check4bench, checkob, chk4lc, chk4shot, CompShoot, assnearest, check4check, burst, skatetopuck, Sweepcheck, chkpk, chkpk2, assshoot, SetShotMode, ShotMode, doshot, shotsets |
| ram93snes | skipped | no org (equates only) | - | - | RAM map, not a queue segment |
| bank80_9000 | matched | $80910F | $80A120 | 100% | 4114 bytes $80910F-$80A120 (end moved to the end of puckglue). 93G asspassrec, assfight (.al), chkhit, CwdFight, FightFall, assfwatch, assfaceoff, assexit, assfaceoffp1, randomd0, pucknorm, findpc, findpc_calc, divs, a2touchpuck, a2offsides, GetHot, puckIChk, ChkOffsides, ClearOffsidesIfAllPlayers, checkpuckcoll, checkpuckcoll_ccx, puckstick, puckglue |
| bank80_A000 | matched | $80A121 | $80B005 | 100% | 3813 bytes $80A121-$80B005 (start moved by bank80_9000). 93G deflect, setc1player, setc2player, restorepl, makepde, puckbody, puckgoalie, pucknothing, puckfaceoff, SetLCmode, SetLCmode2, ClrHor, puckfaceoff2 (.apl/.ptab), updatefaceoff, Endfaceoff (.ftab), dirtab, random, randoma, changeplayer, vtoa (.dt) |
| bank80_B000 | matched | $80B006 | $80C18E | 100% | 4489 bytes $80B006-$80C18E (end moved to the end of PenaltyList). 93G SetSPA, ResetBench, forcepldata, Setplass, setplayer, ClampNibble, resetplstuff, assinsert, assreplace, setupice, setplayercolors, SprSort, DoGameFrame, periodicevents, AvgCline, printz, print, updatepwrplay, ChkGoalies, setpersonel, SetPlList, TryAddPlayerToList, ReturnGoalies, CPgoalie, updatecrowdf, PenaltyList; SNES SetTeamColors, divu16, printteamname |
| bank80_C000 | matched | $80C18F | $80CEE6 | 100% | 3416 bytes $80C18F-$80CEE6 (start moved by bank80_B000, end moved to puckflip). 93G AddPenalty, AddPenalty2, freezewindow, sfx, updatereplay, demoread, Readjoy1, Readjoy2, ReadJoy, jdtab, updateplayers, checkcoll, checkwallcoll, sroot, divu, wallcollb, wallcoll, puckflip |
| bank80_D000 | matched | $80CEE7 | $80E0E0 | 100% | 4602 bytes $80CEE7-$80E0E0 (start moved by bank80_C000, end moved to the end of holdplayer). 93G checkgoal, ChkShotStat (+addteamstat), Goal (.setass), PenGoalStuff, checkgoalp, CheckBump, checkplcoll, checkcx, newcheck, checkint (.ci), FallDown, checkcheck (.cc/.list), checkfight (.sf), SetInst, doinput (.setpassmode), faceoffinput, holdplayer |
| bank80_E000 | matched | $80E0E1 | $80ED37 | 100% | 3159 bytes $80E0E1-$80ED37 (start moved by bank80_D000, end moved before the compressed block). 93G setpads, updateanim, checkwindow, setvideo, show_rink, checkfo, setsortcords, setffo, ButtonLabelCharTable, uppads, PenaltyManager, chkatop, checkfornewpen, Stop4Pen, limitfo (.lf), chkprogress, InProgress, coinsearch, UpdatePA, SetPA; SNES projxy |
| bank80_F000 | matched | $80ED38 | $80FFFF | 100% | 4808 bytes $80ED38-$80FFFF (start moved by bank80_E000). PackedScreenData (1590 bytes for the decompressor $86FA3E); 93G adda43, setlccords, startpause, asspuckc (.chkdir), randomd0s, assgoalie, ClampYPosition, AdjustFacingDirection, GoalieSaveList, checkgoalp_CalcGoalShotDir, CalcAngleOffset, reenergizeteam; SNES ReadPads, divbig, far8B817A, far8B8172; $FF fill, internal header and vectors as dw labels |
| bank81_8000 | matched | $818000 | $818FFF | data | 4096 bytes $818000-$818FFF. GameSoundUpload: SPC700 upload stream of the in-game sample set (setupice via $82FA7A): block headers, GameSampleDir (19 DSP directory entries, start/loop as SPCSAMPLES+offset), GameSamples incbin data/gamesamples.brr 0..$FAC |
| bank81_9000 | matched | $819000 | $819FFF | data | 4096 bytes $819000-$819FFF. GameSamples continued: incbin data/gamesamples.brr $FAC..$1FAC |
| bank81_A000 | matched | $81A000 | $81AFFF | data | 4096 bytes $81A000-$81AFFF. GameSamples continued: incbin data/gamesamples.brr $1FAC..$2FAC |
| bank81_B000 | matched | $81B000 | $81BFFF | data | 4096 bytes $81B000-$81BFFF. GameSamples continued: incbin data/gamesamples.brr $2FAC..$3FAC |
| bank81_C000 | matched | $81C000 | $81CFFF | data | 4096 bytes $81C000-$81CFFF. GameSamples continued: incbin data/gamesamples.brr $3FAC..$4FAC |
| bank81_D000 | matched | $81D000 | $81DFFF | data | 4096 bytes $81D000-$81DFFF. GameSamples continued: incbin data/gamesamples.brr $4FAC..$5FAC |
| bank81_E000 | matched | $81E000 | $81EFFF | data | 4096 bytes $81E000-$81EFFF. GameSamples continued: incbin data/gamesamples.brr $5FAC..$6FAC |
| bank81_F000 | matched | $81F000 | $81FFFF | data | 4096 bytes $81F000-$81FFFF. GameSamples continued: incbin data/gamesamples.brr $6FAC..$7FAC |
| bank82_8000 | matched | $828000 | $828FFF | data | 4096 bytes $828000-$828FFF. GameSamples continued: incbin data/gamesamples.brr $7FAC..$8FAC |
| bank82_9000 | matched | $829000 | $829FFF | data | 4096 bytes $829000-$829FFF. GameSamples continued: incbin data/gamesamples.brr $8FAC..$9FAC |
| bank82_A000 | matched | $82A000 | $82AFFF | data | 4096 bytes $82A000-$82AFFF. GameSamples continued: incbin data/gamesamples.brr $9FAC..$AFAC |
| bank82_B000 | matched | $82B000 | $82B86B | data | 2156 bytes $82B000-$82B86B (end moved from $82BFFF to the end of the sound stream). GameSamples end: incbin data/gamesamples.brr $AFAC..$B814, GameSamplesEnd, end block (length 0, SPCRESUME) |
| bank82_C000 | matched | $82B86C | $82CD9F | data | 5428 bytes $82B86C-$82CD9F (start moved by bank82_B000, end moved before the packed rink tiles). SPAList: 59 SPA tables in 93G frames93.asm form (SPAxxx_table, direction offsets, attributes, frame/delay lists as SPF+n), each asserted against its SPA constant |
| bank82_D000 | matched | $82CDA0 | $82DFFF | data | 4704 bytes $82CDA0-$82DFFF (start moved by bank82_C000). IceRinkTiles: packed rink tiles (decompressor $86FA3E), incbin data/IceRinkTiles.pak 0..$1260 |
| bank82_E000 | matched | $82E000 | $82F93B | data | 6460 bytes $82E000-$82F93B (end moved to the end of the packed stream). IceRinkTiles continued: incbin data/IceRinkTiles.pak $1260..$2B9C, IceRinkTilesEnd (size asserted) |
| bank82_F000 | matched | $82F93C | $82FFFF | 100% | 1732 bytes $82F93C-$82FFFF (start moved by bank82_E000). 93G SetPA2, UpdateScores, PushBits, asscentero (.dedata), PrintPenaltyMessagesString, startpause2; 92G BitstoPW, PasstoText, PWtoBits, ClrPassBits; SNES sndqreset, SPCBootUpload, SPCGameUpload, SPCUpload, QueueSound, BitMaskTable, ContinuePlayoffs, far8DF888, PixelRemap8D/83, marktextlo/hi, muls32, addframe_hi, revplayeracc, ClearTeamStats, printz8B, appendz; $FF fill |
| bank83_8000 | matched | $838000 | $838D82 | data | 3459 bytes $838000-$838D82 (end moved to the end of Calgary). TeamList (26 long pointers), team records AllStarsEast, AllStarsWest, Boston, Buffalo, Calgary in 93G teamdata93.asm form (macros Player, String, hex2); palettes data/Pals/*.pal |
| bank83_9000 | matched | $838D83 | $839D7C | data | 4090 bytes $838D83-$839D7C (boundaries moved to the team records). Team records Chicago .. LongIsland in 93G teamdata93.asm form |
| bank83_A000 | matched | $839D7D | $83AD01 | data | 3973 bytes $839D7D-$83AD01 (boundaries moved to the team records). Team records Minnesota .. Philadelphia in 93G teamdata93.asm form |
| bank83_B000 | matched | $83AD02 | $83BCA7 | data | 4006 bytes $83AD02-$83BCA7 (boundaries moved to the team records). Team records Pittsburgh .. Toronto in 93G teamdata93.asm form |
| bank83_C000 | matched | $83BCA8 | $83CC0B | data | 3940 bytes $83BCA8-$83CC0B (boundaries moved to the team record and the end of the packed tiles). Team records Vancouver, Winnipeg, Washington; playoffseats (34 trees, = 93G); BigFontTiles incbin data/BigFont.pak (packed, $86FA3E) |
| bank83_D000 | matched | $83CC0C | $83DFFF | 100% | 4084 bytes $83CC0C-$83DFFF (start moved by bank83_C000). SNES PlayerNumName; IceRinkMap (48x85 words, incbin data/IceRink.map 0..$1335) |
| bank83_E000 | matched | $83E000 | $83F72A | data | 5931 bytes $83E000-$83F72A (end moved before the rink palette). IceRinkMap end (incbin $1335..$1FE0, size asserted), HorRinkMap 48x28 (incbin data/IceRinkHor.map, size asserted) |
| bank83_F000 | matched | $83F72B | $83FFFF | 100% | 2261 bytes $83F72B-$83FFFF (start moved by bank83_E000). RinkPalette (data/Pals/Rink.pal); 92G Pausemode, PauseMenu (.gj/.rm/.sr/.go/.jump), PauseReadJoy (.rjoy); SNES Team Roster item (.ros), PauseResume, PauseLeave, Restart; 93G RefsMap (data/Refs.map, 7 frames), assgoalietopuck; $FF fill |
| bank84_8000 | matched | $848000 | $848FFF | data | 4096 bytes $848000-$848FFF. SpriteSet9 (frame set 9, frames 406-461 = SPFGoalie..+55): header, frame index table, pieces (data/Sprites/set09.pieces), tiles (data/Sprites/set09.chr 0..$9D0) |
| bank84_9000 | matched | $849000 | $849FFF | data | 4096 bytes $849000-$849FFF. SpriteSet9 tiles: incbin data/Sprites/set09.chr $9D0..$19D0 |
| bank84_A000 | matched | $84A000 | $84AFFF | data | 4096 bytes $84A000-$84AFFF. SpriteSet9 tiles: incbin data/Sprites/set09.chr $19D0..$29D0 |
| bank84_B000 | matched | $84B000 | $84BFFF | data | 4096 bytes $84B000-$84BFFF. SpriteSet9 tiles: incbin data/Sprites/set09.chr $29D0..$39D0 |
| bank84_C000 | matched | $84C000 | $84CFFF | data | 4096 bytes $84C000-$84CFFF. SpriteSet9 tiles: incbin data/Sprites/set09.chr $39D0..$49D0 |
| bank84_D000 | matched | $84D000 | $84E948 | data | 6473 bytes $84D000-$84E948 (end moved to the end of the text). SpriteSet9 tiles end (size asserted); ScoutingReportText incbin data/Text/ScoutingReportText.bin (93G ScoutingReportText) |
| bank84_E000 | matched | $84E949 | $84EF3B | 100% | 1523 bytes $84E949-$84EF3B (boundaries moved: after ScoutingReportText, before HotList). ScoutPicMap; SNES scouting report showcase: PutDigits2, ScoutPlayersRun, ScoutTeamStep, ScoutPlayerExit, ScoutNextPlayer, ScoutPickScript, GetRosterEntry, DrawScoutPlayers/DrawScoutPlayer; tables ScoutScriptPick(G), ScoutScripts (SPA steps), ScoutLineOrder |
| bank84_F000 | matched | $84EF3C | $84FFFF | 100% | 4292 bytes $84EF3C-$84FFFF (start moved by bank84_E000). 93G HotList (data/HotList.bin), UpdateScoutingDisplay, ScrollDisplayUp, GetNameandAttrib, attribjmp, AttribStatus/Energy/Fighting/Rating/PrintPct/Handed/Weight, StatusTextTbl, HandedTextTbl; 92G DisplayStats (.ss, .atz, .sslist); SNES MenuTiles88 (packed), InitSortObjects with SsoInitTable/FfoInitTable/SortObjInitTable, Readjoy12; $FF fill |
| bank85_8000 | matched | $858000 | $858FFF | data | 4096 bytes $858000-$858FFF. SpriteSet4 (frame set 4, frames 225-272: hip/shoulder/sweep checks): header, frame table, pieces (data/Sprites/set04.pieces), tiles (set04.chr) |
| bank85_9000 | matched | $859000 | $859FFF | data | 4096 bytes $859000-$859FFF. SpriteSet4 tiles (incbin data/Sprites/set04.chr slice) |
| bank85_A000 | matched | $85A000 | $85AFFF | data | 4096 bytes $85A000-$85AFFF. SpriteSet4 tiles (incbin data/Sprites/set04.chr slice) |
| bank85_B000 | matched | $85B000 | $85BFFF | data | 4096 bytes $85B000-$85BFFF. SpriteSet4 tiles (incbin data/Sprites/set04.chr slice) |
| bank85_C000 | matched | $85C000 | $85CFFF | data | 4096 bytes $85C000-$85CFFF. SpriteSet4 tiles (incbin data/Sprites/set04.chr slice) |
| bank85_D000 | matched | $85D000 | $85DFFF | 100% | 4096 bytes $85D000-$85DFFF. SpriteSet4 tiles end (size asserted); 93G/92G GetShifter; Title1Map start (93G Title1Map: packed title screen, data/Title1.pak) |
| bank85_E000 | matched | $85E000 | $85EFFF | data | 4096 bytes $85E000-$85EFFF. Title1Map continued (incbin $A40..$1A40) |
| bank85_F000 | matched | $85F000 | $85FFFF | 100% | 4096 bytes $85F000-$85FFFF. Title1Map end (size asserted); SNES DrawFrameSet (sprite emitter with the VRAM tile cache); 93G getpzjoy, ResetClock; SNES PrintTeamNames, nullrtl85; $FF fill |
| bank86_8000 | matched | $868000 | $868FFF | data | 4096 bytes $868000-$868FFF. BootSoundUpload (boot SPC upload stream), block 1 header, SPCDriver (SPC700 driver code, data/spc/driver.bin 0..$FFC) |
| bank86_9000 | matched | $869000 | $869FFF | data | 4096 bytes $869000-$869FFF. SPCDriver continued (incbin $FFC..$1FFC) |
| bank86_A000 | matched | $86A000 | $86AFFF | data | 4096 bytes $86A000-$86AFFF. SPCDriver end (size asserted), BootInstruments (29 x 6 bytes to APU $2B00), BootSampleDir (9 entries), BootSamples start (data/bootsamples.brr) |
| bank86_B000 | not matched <- CURRENT | $86B000 | $86BFFF | 0% |  |
| bank86_C000 | not matched | $86C000 | $86CFFF | 0% |  |
| bank86_D000 | not matched | $86D000 | $86DFFF | 0% |  |
| bank86_E000 | not matched | $86E000 | $86EFFF | 0% |  |
| bank86_F000 | not matched | $86F000 | $86FFFF | 19% |  |
| bank87_8000 | not matched | $878000 | $878FFF | 0% |  |
| bank87_9000 | not matched | $879000 | $879FFF | 0% |  |
| bank87_A000 | not matched | $87A000 | $87AFFF | 0% |  |
| bank87_B000 | not matched | $87B000 | $87BFFF | 0% |  |
| bank87_C000 | not matched | $87C000 | $87CFFF | 10% |  |
| bank87_D000 | not matched | $87D000 | $87DFFF | 13% |  |
| bank87_E000 | not matched | $87E005 | $87EFFF | 0% |  |
| bank87_F000 | not matched | $87F005 | $86FFFF | -0% |  |
| bank88_8000 | not matched | $888000 | $888FFF | 28% |  |
| bank88_9000 | not matched | $88900F | $889FFF | 0% |  |
| bank88_A000 | not matched | $88A00F | $88AFFF | 0% |  |
| bank88_B000 | not matched | $88B00F | $88BFFF | 0% |  |
| bank88_C000 | not matched | $88C00F | $88CFFF | 0% |  |
| bank88_D000 | not matched | $88D00F | $88DFFF | 0% |  |
| bank88_E000 | not matched | $88E00F | $88EFFF | 2% |  |
| bank88_F000 | not matched | $88F002 | $88FFFF | 61% |  |
| bank89_8000 | not matched | $898000 | $898FFF | 0% |  |
| bank89_9000 | not matched | $899000 | $899FFF | 0% |  |
| bank89_A000 | not matched | $89A000 | $89AFFF | 0% |  |
| bank89_B000 | not matched | $89B000 | $89BFFF | 0% |  |
| bank89_C000 | not matched | $89C000 | $89CFFF | 0% |  |
| bank89_D000 | not matched | $89D000 | $89DFFF | 0% |  |
| bank89_E000 | not matched | $89E000 | $89EFFF | 5% |  |
| bank89_F000 | not matched | $89F00A | $88FFFF | -0% |  |
| bank8A_8000 | not matched | $8A8000 | $8A8FFF | 0% |  |
| bank8A_9000 | not matched | $8A9000 | $8A9FFF | 0% |  |
| bank8A_A000 | not matched | $8AA000 | $8AAFFF | 0% |  |
| bank8A_B000 | not matched | $8AB000 | $8ABFFF | 0% |  |
| bank8A_C000 | not matched | $8AC000 | $8ACFFF | 0% |  |
| bank8A_D000 | not matched | $8AD000 | $8ADFFF | 0% |  |
| bank8A_E000 | not matched | $8AE000 | $8AEFFF | 0% |  |
| bank8A_F000 | not matched | $8AF000 | $8AFFFF | 14% |  |
| bank8B_8000 | not matched | $8B8000 | $8B8FFF | 13% |  |
| bank8B_9000 | not matched | $8B9003 | $8B9FFF | 0% |  |
| bank8B_A000 | not matched | $8BA003 | $8BAFFF | 0% |  |
| bank8B_B000 | not matched | $8BB003 | $8BBFFF | 0% |  |
| bank8B_C000 | not matched | $8BC003 | $8BCFFF | 0% |  |
| bank8B_D000 | not matched | $8BD003 | $8BDFFF | 0% |  |
| bank8B_E000 | not matched | $8BE003 | $8BEFFF | 0% |  |
| bank8B_F000 | not matched | $8BF003 | $8AFFFF | -1% |  |
| bank8C_8000 | not matched | $8C8000 | $8C8FFF | 0% |  |
| bank8C_9000 | not matched | $8C9000 | $8C9FFF | 0% |  |
| bank8C_A000 | not matched | $8CA000 | $8CAFFF | 0% |  |
| bank8C_B000 | not matched | $8CB000 | $8CBFFF | 0% |  |
| bank8C_C000 | not matched | $8CC000 | $8CCFFF | 0% |  |
| bank8C_D000 | not matched | $8CD000 | $8CDFFF | 0% |  |
| bank8C_E000 | not matched | $8CE000 | $8CEFFF | 0% |  |
| bank8C_F000 | not matched | $8CF000 | $8CFFFF | 7% |  |
| bank8D_8000 | not matched | $8D8000 | $8D8FFF | 38% |  |
| bank8D_9000 | not matched | $8D900C | $8D9FFF | 0% |  |
| bank8D_A000 | not matched | $8DA00C | $8DAFFF | 0% |  |
| bank8D_B000 | not matched | $8DB00C | $8DBFFF | 0% |  |
| bank8D_C000 | not matched | $8DC00C | $8DCFFF | 0% |  |
| bank8D_D000 | not matched | $8DD00C | $8DDFFF | 0% |  |
| bank8D_E000 | not matched | $8DE00C | $8DEFFF | 0% |  |
| bank8D_F000 | not matched | $8DF00C | $8CFFFF | -0% | penalty StartHL2 "Highlight from game:" $F8D7 (92G $AC98) |
| bank8E_8000 | not matched | $8E8000 | $8E8FFF | 14% | Tile data (4bpp planar composite) from about $8E89A7 (ROM $709A7) |
| bank8E_9000 | not matched | $8E900B | $8E9FFF | 0% |  |
| bank8E_A000 | not matched | $8EA00B | $8EAFFF | 0% |  |
| bank8E_B000 | not matched | $8EB00B | $8EBFFF | 0% |  |
| bank8E_C000 | not matched | $8EC00B | $8ECFFF | 0% |  |
| bank8E_D000 | not matched | $8ED00B | $8EDFFF | 0% |  |
| bank8E_E000 | not matched | $8EE00B | $8EEFFF | 0% |  |
| bank8E_F000 | not matched | $8EF00B | $8EFFFF | 0% |  |
| bank8F_8000 | not matched | $8F8000 | $8F8FFF | 58% | PerLabels "Final" $8248 (92G $A34E); GameLabels $89A5 (92G $AB16, 93G $F6CC) |
| bank8F_9000 | not matched | $8F9000 | $8F9FFF | 3% |  |
| bank8F_A000 | not matched | $8FA005 | $8FAFFF | 0% |  |
| bank8F_B000 | not matched | $8FB005 | $8FBFFF | 0% |  |
| bank8F_C000 | not matched | $8FC005 | $8FCFFF | 0% |  |
| bank8F_D000 | not matched | $8FD005 | $8FDFFF | 31% | "Status ]" $D7A3 (93G $156AF); Scouting labels $DF68 (93G $13050, 92G $E00E) |
| bank8F_E000 | not matched | $8FE00E | $8FEFFF | 49% | PauseMode .mlist $EDC8 (92G $4D60, 93G $15937); checksum pointer table $E67D (read by Start) |
| bank8F_F000 | not matched | $8FF003 | $8EFFFF | -5% | setoptions cpo $F395 (92G $E878, 93G $13D49); GOAL/HAT TRICK $FFE1 (93G $14E59) |

## History

- Setup: quick pass, 16 bank files, full build MATCH (sha1 76a01492...).
- Queue split into 128 ~4 KB segments (one file per slice). MATCH.
- Sample (branch sample-bank80): bank80 Start, BRKHalt, VBjsr, vb2_blank, vb2, vb2_main, VBlank, HBjsr, HBdefault named; $80CE-$81C4 decoded from db (vbint targets reached only through `vbint`). RAM $00-$18 named in ram93snes.asm. MATCH.
- bank80_8000: matched $808000-$80910E (4367 bytes; boundary moved to $80910F so doshot and its shotsets table stay in one file). Decoded the vbint handlers ($81C5-$838F, entries from lda #addr : sta vbint) and the player logic reached through asstab ($8D86A8, 29 long pointers in 93G asstab order). RAM: DP 68k pseudo registers d0-d7/a0-a3, sort-object field arrays (SoA, $20 per field), game/team/option globals, constants section (bit masks, SPA, assignments, sfx) in ram93snes.asm. Calls into later segments and other banks keep their address with the 93G name in the line comment. MATCH.
- bank80_9000: matched $80910F-$80A120 (4114 bytes; start moved from $809000 by bank80_8000, end moved to $80A120 so puckstick/puckglue stay whole). The fight, faceoff and puck logic and the puck/player collision, all decoded from db (entries from asstab). New RAM: object fields frame, Zpos, attribute, oldframe, OldXpos/OldYpos, impactp, temp4/5, SCnum, stickhand, fightagg, handed, Ylist/OOlistpos/OOlist; fight/icing/touch/clock globals; team words; sound queue DP; music cue flags. Locals reached from another global are written Global_local (asar sublabel reference). bank80_8000 regenerated to call the new names (assexit, GetHot, randomd0, divs). MATCH.
- bank80_A000: matched $80A121-$80B005 (3813 bytes). Puck deflect/body/goalie collisions, controller switching, the faceoff and line change box code, ClrHor, dirtab, random, changeplayer, vtoa. printz ($80B90C) takes an inline string after the jsl (length word counting itself, then control bytes and text): written as dw/db, the quick pass had decoded it as code. Renamed $0154/$0156 Hpos/Hscroll, $08DF/$08E1 Vpos/Vscroll, $049B Oldrow, $049D vramrow (bank80_8000 comments updated). MATCH.
- bank80_B000: matched $80B006-$80C18E (4489 bytes; PenaltyList moved in from bank80_C000, which now starts at AddPenalty $80C18F). Personnel, setupice, SprSort, game frame, print/printz, power play box, goalie pulls, crowd. PenaltyList written as 93G-style entries (offset table, $ttmm, length-prefixed name, frame/delay words). Inline-string callers found: printz $80B90C, $82FDBF, appendz $82FDD3. New RAM: print state (printm/printa/printfont/printfontset), text vram tile bases, bonuses, crowd, team stats, sndbank. Earlier bank80 slices regenerated to call the new names. MATCH.
- bank80_C000: matched $80C18F-$80CEE6 (3416 bytes; bank80_D000 now starts at checkgoal $80CEE7). Penalties, sfx, replay recording, joypads, updateplayers (fractional positions: Xfrac/Yfrac/Zfrac, per-frame velstep/gravstep/impactstep computed by the game loop), collisions with the boards. $0178 renamed jmlvector (also the asstab call trampoline). MATCH.
- bank80_D000: matched $80CEE7-$80E0E0 (4602 bytes; bank80_E000 now starts at setpads $80E0E1). Goal/net collisions and the goal itself (ScoreSum log, goal counts, PenGoalStuff), player collisions with momentum transfer, checks, falls and injuries, fights and instigators, controller input. New RAM: evalue, ChkCnt, ScoreSum/ScoreSumbytes, tmshots/tmPwrGoals/tmchecks, per player tmgoals/pchecks, tmboxlist; constants for the penalty numbers, fall/check/hold SPAs, sfx and B/Y buttons. Earlier bank80 slices regenerated to call the new names. MATCH.
- bank80_E000: matched $80E0E1-$80ED37 (3159 bytes; bank80_F000 now starts at $80ED38: a compressed block of 1590 bytes, read by $8FDD22/$8FE913 through the decompressor $86FA3E). Animation frames, screen following, the sprite table (face off, sort objects, pads with their labels, gloves), and the penalty manager (new penalties, delayed calls, face off spots, the ref, penalty box entries). New RAM: addframe parameters (sprframe/sprx/spry/sprhflip/sprvflip/sprflag), the ffo arrays at $0100-$0131 ($0106 was colorflag0: it is ffoframe+6), ref state (RefStep/RefPen/penmsgtimer), TempPlOffset, tmPenalties/tmPenmin/tmATOP; constants SPAList, OFFSCREEN, gmpen, PenDelay, SFXwhistle. Earlier bank80 slices regenerated. MATCH.
- bank80_F000: matched $80ED38-$80FFFF (4808 bytes). The packed block $80ED38-$80F36D is labeled data (its stream format is described in the label comment). Code found through asstab, which has 4-byte entries: $E assgoalie $80F6AD, $10 asspuckc $80F45B; the asspuckc skateto callback $80F51A; adda43 called from bank $8F. Internal header (title, map mode $30, checksums) and the native/emulation vectors written as dw labels (VBjsr, BRKHalt, Start, HBjsr). New RAM: joypad3/4, padlast1-4, padnew1-4, padvcount, bignum; constants replaysize, ReplayBufferStart/End, goalie save SPAs, agoalietopuck. Bank $80 complete. MATCH.
- bank81_8000: matched $818000-$818FFF (4096 bytes). Bank $81 is not code: $818000-$82B86B is one SPC700 upload stream (format from the uploader $82FAB9: length, APU address, data; length 0 ends and jumps), sent by $82FA7A from setupice. Blocks: 76-byte sample directory to APU $2C00, $B814 bytes of BRR samples to $2C50 (extracted to data/gamesamples.brr, incbin in slices, one per segment file), end block jumping to $0800 (in bank82_B000). Constants SPCSAMPLEDIR, SPCSAMPLES, SPCRESUME, GAMESAMPLESIZE. MATCH.
- bank81_9000: matched $819000-$819FFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $FAC..$1FAC. MATCH.
- bank81_A000: matched $81A000-$81AFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $1FAC..$2FAC. MATCH.
- bank81_B000: matched $81B000-$81BFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $2FAC..$3FAC. MATCH.
- bank81_C000: matched $81C000-$81CFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $3FAC..$4FAC. MATCH.
- bank81_D000: matched $81D000-$81DFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $4FAC..$5FAC. MATCH.
- bank81_E000: matched $81E000-$81EFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $5FAC..$6FAC. MATCH.
- bank81_F000: matched $81F000-$81FFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $6FAC..$7FAC. MATCH.
- bank82_8000: matched $828000-$828FFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $7FAC..$8FAC. MATCH.
- bank82_9000: matched $829000-$829FFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $8FAC..$9FAC. MATCH.
- bank82_A000: matched $82A000-$82AFFF (4096 bytes): BRR samples of the in-game sample set, incbin data/gamesamples.brr $9FAC..$AFAC. MATCH.
- bank82_B000: matched $82B000-$82B86B (2156 bytes; bank82_C000 now starts at SPAList $82B86C): the last BRR samples and the end block of the in-game upload stream. MATCH.
- bank82_C000: matched $82B86C-$82CD9F (5428 bytes; bank82_D000 now starts at $82CDA0). SPAList written from the data in 93G frames93.asm style: tables matched to 93G by structure (direction lists, delays, frame groups); 93G-only: SPAgglovel2, SPAgstackr's 93 delays differ, SPAgdive moved to $1490, no SPAfake; SPAstanley and SPAfinjury sit after SPAsiren. SPAwallright/SPAwallleft direction 7 points at the next table header as in 93G. Renamed SPA constants to the frames93.asm names (gglove/gstick/gstack sides swapped, SPAbfall->SPAffall, SPAffall->SPAfinjury, SPAfall3->SPAflip, SPAhold->SPAHold, SPAhold2->SPAhook, SPAslowhit->SPAcatch, SPAglass->SPAbglass, SPAg314->SPAgdive, SPAnomove->SPAinjury1, SPFgoalie->SPFgdive) and added all 59 SPA and the SPF frame bases (SNES numbering). SPAList is now a label. bank80 slices regenerated. MATCH.
- bank82_D000: matched $82CDA0-$82DFFF (4704 bytes). IceRinkTiles, the packed rink background tiles setupice unpacks to vram $1000 (93G IceRink.map.jim tiles), extracted to data/IceRinkTiles.pak ($2B9C bytes, ends $82F93B); setupice now loads it by label. MATCH.
- bank82_E000: matched $82E000-$82F93B (6460 bytes; bank82_F000 now starts at the code $82F93C): the rest of the packed rink tiles. MATCH.
- bank82_F000: matched $82F93C-$82FFFF (1732 bytes). Entries from every jsl/jml into the bank and asstab 6 (asscentero). The SNES password code is 92G (PassWord $1610, passbits $1624 = 8 words, PasstoText, SuperDiv/SuperMult/SuperAdd): bank80 divbig/bignum/far8B817A renamed SuperDiv/passbits/DecodePW. New RAM: options OptPlayMode..OptPerlen, gamenum, TickerNum, the playoff game arrays gst1..gsflags (word per game), sndptr, cursong, sndsettle, mulneg, farptr, sprsetofs; constants gsfhl, gsfso, PWrange, pwlength, sf3alttree. Bank $82 complete. MATCH.
- bank83_8000: matched $838000-$838D82 (3459 bytes; bank83_9000 now starts at Chicago). Bank $83 starts with the team data, identical in every value to 93G teamdata93.asm (same 26 teams, ratings, line sets, odds, names, ROM order; only the palettes are SNES BGR555 and words little-endian). TeamList, macros Player/String/hex2, constants Playerdata..ScoreOdds, NumofTeams; SNES palettes extracted to data/Pals with the 93G file names. TeamList entries of later segments stay raw addresses until those teams are named. MATCH.
- bank83_9000: matched $838D83-$839D7C (4090 bytes): team records Chicago .. LongIsland, same values as 93G. MATCH.
- bank83_A000: matched $839D7D-$83AD01 (3973 bytes): team records Minnesota .. Philadelphia, same values as 93G. MATCH.
- bank83_B000: matched $83AD02-$83BCA7 (4006 bytes): team records Pittsburgh .. Toronto, same values as 93G. MATCH.
- bank83_C000: matched $83BCA8-$83CC0B (3940 bytes; bank83_D000 now starts at the code $83CC0C): the last team records, playoffseats (same bytes as 93G teamdata93.asm), and the packed big font tiles (100 tiles, 93G BigFont.map.jim chars) extracted to data/BigFont.pak, loaded by setupice by label. TeamList now uses labels for all 26 teams. MATCH.
- bank83_D000: matched $83CC0C-$83DFFF (4084 bytes). PlayerNumName (uniform number and name of a roster player into mesarea), then the vertical rink tile map IceRinkMap (48 x 85 words; the bank $89 loader reads it with a $60 row stride) extracted to data/IceRink.map. The row note about scouting report text at $83D630 was wrong: that is rink map data. New RAM: psitem, pausetimer, demoflag, textsave; JOY dpad/shoulder masks. MATCH.
- bank83_E000: matched $83E000-$83F72A (5931 bytes; bank83_F000 now starts at the rink palette $83F72B): the rest of the vertical rink map and the horizontal rink map (48 x 28 words, data/IceRinkHor.map), which the bank $8F SetHor code sends 32 columns at a time. MATCH.
- bank83_F000: matched $83F72B-$83FFFF (2261 bytes). The game palette, the pause screen (92G Pausemode with a fifth item, Team Roster; menu strings are in bank $8F), Restart, the ref window frames RefsMap (data/Refs.map), and asstab $F assgoalietopuck at $83FDFC (found from the 4-byte asstab). Bank $83 complete. MATCH.
- bank84_8000: matched $848000-$848FFF (4096 bytes). Bank $84 starts with sprite frame set 9 of the addframe frame set table $8FE67D (15 sets): the goalie frames 406-461. Frame set format worked out from $85FBB9: frames, pieces, tiles, piece table offset, tile offset, first piece per frame, 4-byte pieces, 4bpp tiles. Pieces and tiles extracted to data/Sprites. MATCH.
- bank84_9000: matched $849000-$849FFF (4096 bytes): SpriteSet9 tiles. MATCH.
- bank84_A000: matched $84A000-$84AFFF (4096 bytes): SpriteSet9 tiles. MATCH.
- bank84_B000: matched $84B000-$84BFFF (4096 bytes): SpriteSet9 tiles. MATCH.
- bank84_C000: matched $84C000-$84CFFF (4096 bytes): SpriteSet9 tiles. MATCH.
- bank84_D000: matched $84D000-$84E948 (6473 bytes; bank84_E000 now starts at $84E949): the last frame set 9 tiles and the scouting report text, extracted to data/Text/ScoutingReportText.bin like 93G. The bank83_D000 row note about the scouting text at $83D630 meant $84D630. MATCH.
- bank84_E000: matched $84E949-$84EF3B (1523 bytes; bank84_F000 now starts at HotList $84EF3C). SNES-only scouting report extras: two showcased players (one per team, from the line sets) skate in with their number and name, animated by scripts of SPA steps picked from their ratings. New RAM: tmscoutpl, the 93G scouting text variables (ScoutingReportTimer, PlayerScrollCtr, SelectedPlayerIdx, DispAttribCtr, VertLineScrolling, screentimer, asv, TestList). MATCH.
- bank84_F000: matched $84EF3C-$84FFFF (4292 bytes). HotList (stick hot spots per frame) extracted to data/HotList.bin and used by GetHot by label; the scouting text printer (93G UpdateScoutingDisplay/ScrollDisplayUp; ~ is the arena team, Montreal for the All-Stars); 92G DisplayStats (Body Checks where 92G has Fights Won); the 93G roster attribute columns (GetNameandAttrib, attribjmp handlers, strings); InitSortObjects and its tables. New RAM: sso arrays (ssox/ssoy/ssoframe/ssoattr/ssoz, roles by analogy with ffo), ffoxofs. Bank $84 complete. MATCH.
- bank85_8000: matched $858000-$858FFF (4096 bytes): sprite frame set 4, frames 225-272 (SPFhipl .. SPFsweep+15). MATCH.
- bank85_9000: matched $859000-$859FFF (4096 bytes): SpriteSet4 tiles. MATCH.
- bank85_A000: matched $85A000-$85AFFF (4096 bytes): SpriteSet4 tiles. MATCH.
- bank85_B000: matched $85B000-$85BFFF (4096 bytes): SpriteSet4 tiles. MATCH.
- bank85_C000: matched $85C000-$85CFFF (4096 bytes): SpriteSet4 tiles. MATCH.
- bank85_D000: matched $85D000-$85DFFF (4096 bytes): the last frame set 4 tiles, GetShifter ($85D5A4, gamelevel $014A), and the start of the packed title screen (map, 128 colours, 408 tiles) shown by the bank $88 title screen at $88F2B0. MATCH.
- bank85_E000: matched $85E000-$85EFFF (4096 bytes): packed menu screen continued. MATCH.
- bank85_F000: matched $85F000-$85FFFF (4096 bytes). DrawFrameSet: the SNES sprite emitter behind addframe (OAM entries in Satt/SattHi, 8x8 and 16x16 VRAM slot rotors, tile uploads through DMAList, cache by sprframetime/sprslottime). New RAM: the emitter DP variables (sprcount, sprpal, sprpattr, sprbigslot(end), sprslot(end), sprtile, sprox, sproy, sprtileptr, sprnodraw, sprpieces), SattHi, HomeTeam/VisTeam ($129A/$129C; PenaltyBufferEnd is now PenBuf-2), PerTimeTotal, gamelevel, sfpj. Bank $85 complete. MATCH.
- bank85 follow-up: MenuScreen88 renamed Title1Map (data/Title1.pak): rendered, it is the title screen (goalie and the NHLPA Hockey '93 logo), the 93G Title1Map / Title1.map.jim backdrop; $88F2B0 is the title screen code. MATCH.
- bank86_8000: matched $868000-$868FFF (4096 bytes). Bank $86 starts with the boot SPC upload stream (SPCBootUpload): the SPC700 sound driver ($26E7 bytes to APU $0400, kept as data/spc/driver.bin, not disassembled), the instrument table, the sample directory and the boot samples. Constants SPCDRIVER, SPCINSTR, SPCBOOTSAMPLES, SPCDRIVERSIZE, BOOTSAMPLESIZE. MATCH.
- bank86_9000: matched $869000-$869FFF (4096 bytes): SPC700 driver code continued. MATCH.
- bank86_A000: matched $86A000-$86AFFF (4096 bytes): the end of the driver, the 29-entry instrument table (sample, ADSR1, ADSR2, GAIN, pitch), the 9-entry boot sample directory and the first boot samples. MATCH.
