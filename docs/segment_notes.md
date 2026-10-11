# Old segment notes

The header comments of the 128 ~4 KB slices (`src/bankXX_YYYY.asm`) before the files were regrouped into
the 93G module files. Kept for the history; `SEGMENT_AGENT.md` has the per-slice work log.

## bank80_8000 (org $808000)

$808000-$80910E  ROM $00000-$0110E: reset, vblank/irq handlers, and the start of the player logic (93G logic93_5 / logic93_1 /
logic93_3 / logic93_4 routines). The 68k registers of 93G are DP pseudo registers (d0 = $53 ... a3 = $3F, see ram93snes.asm);
X = SCnum*2 of the current object (93G a3). Out-of-bank or later-segment calls keep their address with the 93G name in the comment.

## bank80_9000 (org $80910F)

$80910F-$80A120  ROM $0110F-$02120: 93G player logic continued: asspassrec, assfight (chkhit, CwdFight, FightFall), assfwatch,
assfaceoff, assexit, assfaceoffp1 (logic93_2/4/5), randomd0, puck logic pucknorm with findpc, divs, a2touchpuck, a2offsides,
GetHot, puckIChk, ChkOffsides (logic93_4/5), and the puck/player collision checkpuckcoll, puckstick, puckglue (hockey93_04/05).

## bank80_A000 (org $80A121)

$80A121-$80B005  ROM $02121-$03005: puck deflect/body/goalie collisions (hockey93_05), controller player switching (logic93_1),
makepde, pucknothing, the faceoff (puckfaceoff, puckfaceoff2, updatefaceoff, Endfaceoff: logic93_4) with the line change box
(SetLCmode, SetLCmode2) and ClrHor, dirtab, random/randoma, changeplayer, vtoa (logic93_5 / middle93_1).

## bank80_B000 (org $80B006)

$80B006-$80C18E  ROM $03006-$0418E: SetSPA, team personnel (ResetBench, forcepldata, Setplass, setplayer, setpersonel, SetPlList:
hockey93_05), resetplstuff, assinsert/assreplace, setupice and team colors (hockey93_06), SprSort, the game frame (DoGameFrame,
periodicevents: hockey93_01), AvgCline, printz/print (middle93_2), updatepwrplay, the goalie pulls (ChkGoalies, ReturnGoalies,
CPgoalie: logic93_4), updatecrowdf, and PenaltyList (hockey93_11).

## bank80_C000 (org $80C18F)

$80C18F-$80CEE6  ROM $0418F-$04EE6: AddPenalty/AddPenalty2 (penalty93_1), freezewindow, sfx, updatereplay, demoread and the joypad
readers (hockey93_01/middle93_1), updateplayers (hockey93_02), checkcoll, checkwallcoll, wallcollb, wallcoll (hockey93_03/04),
sroot, divu, puckflip.

## bank80_D000 (org $80CEE7)

$80CEE7-$80E0E0  ROM $04EE7-$060E0: checkgoal, Goal, checkgoalp, CheckBump (hockey93_04), ChkShotStat (penalty93_2), PenGoalStuff
(penalty93_1), checkplcoll, checkcx, newcheck, checkint, FallDown, checkcheck (hockey93_03), checkfight, SetInst (hockey93_04),
doinput, faceoffinput, holdplayer (logic93_1). Starts at checkgoal (boundary moved from $80D002), ends before setpads.

## bank80_E000 (org $80E0E1)

$80E0E1-$80ED37  ROM $060E1-$06D37: setpads (logic93_1), updateanim, checkwindow (hockey93_02), setvideo, show_rink, checkfo
(video93_1), setsortcords, setffo, uppads (video93_2) with the SNES projxy, PenaltyManager, chkatop, checkfornewpen, Stop4Pen,
limitfo, chkprogress, InProgress, coinsearch, UpdatePA, SetPA (penalty93_1). Starts at setpads (boundary moved from $80E001),
ends before the compressed block at $80ED38 (now in bank80_F000).

## bank80_F000 (org $80ED38)

$80ED38-$80FFFF  ROM $06D38-$07FFF: RonBarrMap (packed), adda43 (hockey93_02), setlccords, startpause, ReadPads,
asspuckc (logic93_3), SuperDiv, randomd0s, assgoalie, ClampYPosition, AdjustFacingDirection, GoalieSaveList (logic93_3),
checkgoalp_CalcGoalShotDir, CalcAngleOffset (logic93_1), reenergizeteam (penalty93_2), the internal header and the vectors.
Starts at RonBarrMap (boundary moved from $80F008).

## bank81_8000 (org $818000)

$818000-$818FFF  ROM $08000-$08FFF: the in-game SPC700 upload stream (GameSoundUpload), $818000-$82B86B. setupice sends it
with the uploader at $82FA7A ($82FAB9: blocks of length word, APU address word, data; a length of 0 ends and jumps to the address).
Blocks: the sample directory (to APU $2C00), the BRR samples (data/gamesamples.brr, to APU $2C50), the end block (jump to SPCRESUME, in bank82_B000).
The samples run on through bank $81 (one incbin slice per segment file) and end in bank82_B000.

## bank81_9000 (org $819000)

$819000-$819FFF  ROM $09000-$09FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_A000 (org $81A000)

$81A000-$81AFFF  ROM $0A000-$0AFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_B000 (org $81B000)

$81B000-$81BFFF  ROM $0B000-$0BFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_C000 (org $81C000)

$81C000-$81CFFF  ROM $0C000-$0CFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_D000 (org $81D000)

$81D000-$81DFFF  ROM $0D000-$0DFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_E000 (org $81E000)

$81E000-$81EFFF  ROM $0E000-$0EFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank81_F000 (org $81F000)

$81F000-$81FFFF  ROM $0F000-$0FFFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank82_8000 (org $828000)

$828000-$828FFF  ROM $10000-$10FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank82_9000 (org $829000)

$829000-$829FFF  ROM $11000-$11FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank82_A000 (org $82A000)

$82A000-$82AFFF  ROM $12000-$12FFF: GameSamples continued (BRR samples of the in-game SPC upload stream, see bank81_8000)

## bank82_B000 (org $82B000)

$82B000-$82B86B  ROM $13000-$1386B: the end of the in-game SPC upload stream (see bank81_8000): the last BRR samples and the end block.
Ends before SPAList (boundary moved from $82BFFF).

## bank82_C000 (org $82B86C)

$82B86C-$82CD9F  ROM $1386C-$14D9F: SPAList, the animation tables (93G frames93.asm SPAList). Starts at SPAList (boundary moved from
), ends before the packed rink tiles. SPA (sort object field) is an offset in this table. Each SPA table: 8 words = offset
of the frame list for each direction (facedir 0-7, from the table start), 1 word of attributes (bit 0 = the animation loops),
then the frame lists: pairs of (sprite frame, delay in frames); a negative delay marks the last frame (updateanim, bank80_E000).
Frames are SPF base + n (SNES frame numbering, see ram93snes.asm). Each table is asserted against its SPA constant.

## bank82_D000 (org $82CDA0)

$82CDA0-$82DFFF  ROM $14DA0-$15FFF: IceRinkTiles, the rink background tiles packed for the decompressor at $86FA3E (stream format at
DecompressGraphics, bank86_F000). setupice unpacks them to $7F0000 and sends $40E0 bytes to vram $1000 (93G IceRink.map.jim tiles).
data/IceRink.chr.pak is the packed stream ($2B9C bytes, $82CDA0-$82F93B); this file holds the first part, bank82_E000 the rest.
Starts at the packed rink tiles (boundary moved from $82D000).

## bank82_E000 (org $82E000)

$82E000-$82F93B  ROM $16000-$1793B: IceRinkTiles continued (packed rink tiles, see bank82_D000). Ends at the end of the packed stream
(boundary moved from $82EFFF); the bank $82 code starts after it in bank82_F000.

## bank82_F000 (org $82F93C)

$82F93C-$82FFFF  ROM $1793C-$17FFF: code after the packed rink tiles. SetPA2, ClearPenaltyMessage (penalty93_1), UpdateScores
(penalty93_2), the 92G password code (BitstoPW, PasstoText, PWtoBits, ClrPassBits, PushBits), asscentero (logic93_3), startpause2,
and SNES helpers: the SPC700 uploads and the sound queue, muls32, textmap dirty marks, inline string far calls, trampolines.
Starts after the packed rink tiles (boundary moved from $82F000). Ends with $FF fill.

## bank83_8000 (org $838000)

$838000-$838D82  ROM $18000-$18D82: team data (93G teamdata93.asm, identical values; SNES palettes and little-endian words).
TeamList, then the team records in ROM order: AllStarsEast, AllStarsWest, Boston, Buffalo, Calgary. Record: 6 offsets (Playerdata,
Palettedata, Teamname, LineSets, ScoutReport, ScoreOdds), .pad home/visitor palettes, .sr scout ratings, .sodds, .ls 7 line sets,
.pld players (Player: length word, name, 8 rating bytes), the empty end entry, .tn / .ta name and abbreviation (String).
Ends at the end of Calgary (boundary moved from $838FFF).

## bank83_9000 (org $838D83)

$838D83-$839D7C  ROM $18D83-$19D7C: team records Chicago, Detroit, Edmonton, Hartford, LosAngeles, LongIsland (93G teamdata93.asm, same values; see bank83_8000 for the format).
Starts at Chicago, ends at the end of LongIsland (boundaries moved to the records).

## bank83_A000 (org $839D7D)

$839D7D-$83AD01  ROM $19D7D-$1AD01: team records Minnesota, Montreal, NewJersey, NewYork, Ottawa, Philadelphia (93G teamdata93.asm, same values; see bank83_8000 for the format).
Starts at Minnesota, ends at the end of Philadelphia (boundaries moved to the records).

## bank83_B000 (org $83AD02)

$83AD02-$83BCA7  ROM $1AD02-$1BCA7: team records Pittsburgh, Quebec, SanJose, StLouis, TampaBay, Toronto (93G teamdata93.asm, same values; see bank83_8000 for the format).
Starts at Pittsburgh, ends at the end of Toronto (boundaries moved to the records).

## bank83_C000 (org $83BCA8)

$83BCA8-$83CC0B  ROM $1BCA8-$1CC0B: team records Vancouver, Winnipeg, Washington (93G teamdata93.asm, see bank83_8000), playoffseats (93G teamdata93.asm,
same bytes), then SmallFontTiles: the small font tiles packed for the decompressor $86FA3E (93G SmallFont.map.jim chars). Starts at
Vancouver, ends at the end of the packed tiles (boundaries moved); the code after it is in bank83_D000.

## bank83_D000 (org $83CC0C)

$83CC0C-$83DFFF  ROM $1CC0C-$1DFFF: PlayerNumName, then the start of IceRinkMap (vertical rink tile map, data/IceRink.snesmap,
continued in bank83_E000). Starts after the packed small font tiles (boundary moved from $83D000).

## bank83_E000 (org $83E000)

$83E000-$83F72A  ROM $1E000-$1F72A: IceRinkMap continued (vertical rink tile map, see bank83_D000), then HorRinkMap: the horizontal
rink tile map, 48 x 28 words (data/IceRinkHor.snesmap). SetHor ($8FF5C3/$8FF5EA) sends 32 columns of each row from $83ECAB, or from
(8 columns in) for the other end. Ends before the rink palette (boundary moved from $83EFFF).

## bank83_F000 (org $83F72B)

$83F72B-$83FFFF  ROM $1F72B-$1FFFF: RinkPalette, Pausemode and its menu (92G hockey.asm Pausemode: .top, .gj, .jump, .rjoy;
the SNES menu has a fifth item, Team Roster), Restart, RefsMap (the ref window frames), assgoalietopuck (logic93_3), $FF fill.
Starts at the rink palette (boundary moved from $83F000).

## bank84_8000 (org $848000)

$848000-$848FFF  ROM $20000-$20FFF: SpriteSet9, sprite frame set 9 of the frame set table at $8FE67D: frames 406-461
(SPFGoalie .. SPFGoalie+55, the first goalie frames). A frame set: header (frames, pieces, tiles, piece table offset, tile offset),
the first piece of each frame (+1 entry for the end), the pieces (4 bytes: x, y, tile, attributes; data/Sprites/set09.pieces),
then the 4bpp tiles (data/Sprites/set09.chr, continued in bank84_9000 .. bank84_D000). Drawn by addframe ($8FEC68 / $85FBB9).

## bank84_9000 (org $849000)

$849000-$849FFF  ROM $21000: SpriteSet9 tiles continued (see bank84_8000)

## bank84_A000 (org $84A000)

$84A000-$84AFFF  ROM $22000: SpriteSet9 tiles continued (see bank84_8000)

## bank84_B000 (org $84B000)

$84B000-$84BFFF  ROM $23000: SpriteSet9 tiles continued (see bank84_8000)

## bank84_C000 (org $84C000)

$84C000-$84CFFF  ROM $24000: SpriteSet9 tiles continued (see bank84_8000)

## bank84_D000 (org $84D000)

$84D000-$84E948  ROM $25000-$26948: the last SpriteSet9 tiles, then ScoutingReportText: the scouting report paragraphs (93G
ScoutingReportText, sound93.asm incbin Text/ScoutingReportText.bin; the SNES text is 4889 bytes, 93G 4915). One paragraph per team
ending with a carriage return, then the intro lines (~ [ ] { } are filled in by the printer). Ends at the end of the text
(boundary moved from $84DFFF).

## bank84_E000 (org $84E949)

$84E949-$84EF3B  ROM $26949-$26F3B: FaceOffMap, then the SNES scouting report extras: PutDigits2, the two showcased
players who skate in with their number and name (ScoutPlayersRun: one per team, picked from the line sets in ScoutLineOrder,
animated with the ScoutScripts chosen from their ratings), and the roster helpers. The team stat words are scratch during the
scouting report: tmshots = team shown, tmPwrGoals = ScoutLineOrder index, tmPwrPlays = roster player, tmPenalties = line slot,
tmPenmin = script, tmATOP = script step. Starts after ScoutingReportText (boundary moved), ends before HotList.

## bank84_F000 (org $84EF3C)

$84EF3C-$84FFFF  ROM $26F3C-$27FFF: HotList, UpdateScoutingDisplay, ScrollDisplayUp (hockey93_07), PlayoffTiles, InitSortObjects and
its tables, Readjoy12, DisplayStats (92G penalty.asm), GetNameandAttrib, attribjmp and its handlers (stats93), $FF fill.
Starts at HotList (boundary moved from $84F00C).

## bank85_8000 (org $858000)

$858000-$858FFF  ROM $28000-$28FFF: SpriteSet4, sprite frame set 4 of the frame set table at $8FE67D: frames 225-272 (SPFhipl ..
SPFfallback-1: the hip, shoulder and sweep check frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank85_D000.

## bank85_9000 (org $859000)

$859000-$859FFF  ROM $29000: SpriteSet4 tiles continued (see bank85_8000)

## bank85_A000 (org $85A000)

$85A000-$85AFFF  ROM $2A000: SpriteSet4 tiles continued (see bank85_8000)

## bank85_B000 (org $85B000)

$85B000-$85BFFF  ROM $2B000: SpriteSet4 tiles continued (see bank85_8000)

## bank85_C000 (org $85C000)

$85C000-$85CFFF  ROM $2C000: SpriteSet4 tiles continued (see bank85_8000)

## bank85_D000 (org $85D000)

$85D000-$85DFFF  ROM $2D000-$2DFFF: the last SpriteSet4 tiles, GetShifter (93G penalty93_2 / 92G), then the start of
Title1Map, the title screen (goalie and the NHLPA Hockey '93 logo) packed for the decompressor $86FA3E (data/Title1.map.pak, $85D5C0-$85FBB8): unpacked it is a
32 x 28 tile map ($7F0000), 128 colours ($7F0700) and 408 tiles ($7F0800); the bank $88 title screen ($88F2B0, 93G TitleScreen) shows it.

## bank85_E000 (org $85E000)

$85E000-$85EFFF  ROM $2E000-$2EFFF: Title1Map continued (packed title screen, see bank85_D000)

## bank85_F000 (org $85F000)

$85F000-$85FFFF  ROM $2F000-$2FFFF: the end of Title1Map (packed title screen, see bank85_D000), then DrawFrameHi: the SNES sprite
emitter for addframe (OAM entries, the sprite VRAM tile cache and the tile dma list), getpzjoy, PrintTeamNames, ResetClock.
The cache: sprframetime (4 bytes per frame: sprclock when sent, VRAM slot), sprslottime (sprclock per 32-byte slot);
a slot is free when sprclock - its time >= sprslotlife.

## bank86_8000 (org $868000)

$868000-$868FFF  ROM $30000-$30FFF: BootSoundUpload, the SPC700 upload stream sent at boot by SPCBootUpload ($82FA31). Same block
format as GameSoundUpload (bank81_8000). Blocks: the sound driver (SPC700 code, data/spc/driver.spc700) to APU $0400, the instrument
table to $2B00, the sample directory to $2C00, the boot BRR samples (data/bootsamples.brr) to $2C30, then the end block (start the
driver at $0400). The driver runs on through bank86_A000.

## bank86_9000 (org $869000)

$869000-$869FFF  ROM $31000-$31FFF: SPCDriver continued (SPC700 sound driver code, see bank86_8000)

## bank86_A000 (org $86A000)

$86A000-$86AFFF  ROM $32000-$32FFF: the end of SPCDriver, then the other blocks of BootSoundUpload: BootInstruments (APU $2B00),
BootSampleDir (APU $2C00) and the start of BootSamples (data/bootsamples.brr, APU $2C30, continued to bank86_F000).

## bank86_B000 (org $86B000)

$86B000-$86BFFF  ROM $33000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)

## bank86_C000 (org $86C000)

$86C000-$86CFFF  ROM $34000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)

## bank86_D000 (org $86D000)

$86D000-$86DFFF  ROM $35000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)

## bank86_E000 (org $86E000)

$86E000-$86EFFF  ROM $36000: BootSamples continued (BRR samples of the boot SPC upload, see bank86_A000)

## bank86_F000 (org $86F000)

$86F000-$86FFFF  ROM $37000-$37FFF: the last BootSamples and the end block of BootSoundUpload, then DecompressGraphics, UpdateLineChange,
the song starters, setteams, ProcessInputWithRepeat, GetPeriodTimeRemaining, GetPeriodTime, lcfound2, PickStartingGoalie,
assscore (logic93_2), $FF fill.

## bank87_8000 (org $878000)

$878000-$878FFF  ROM $38000-$38FFF: SpriteSet2, sprite frame set 2 of the frame set table at $8FE67D: frames 145-184 (SPFstop ..
SPFskateb+23: the stop and skate backwards frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank87_C000.

## bank87_9000 (org $879000)

$879000-$879FFF  ROM $39000: SpriteSet2 tiles continued (see bank87_8000)

## bank87_A000 (org $87A000)

$87A000-$87AFFF  ROM $3A000: SpriteSet2 tiles continued (see bank87_8000)

## bank87_B000 (org $87B000)

$87B000-$87BFFF  ROM $3B000: SpriteSet2 tiles continued (see bank87_8000)

## bank87_C000 (org $87C000)

$87C000-$87D204  ROM $3C000-$3D204: the last SpriteSet2 tiles; EASNMap (93G EASN.map.jim: the EASN logo backdrop, packed map and
tiles); FaceOffTiles (packed faceoff box tiles); TeamBlocksMap (93G TeamBlocks.map: the 9 x 2 tile name block of each team);
DrawFrame, the SNES sprite emitter for frames below $293 (4-byte pieces) and the addframe end. Ends after it (boundary moved from $87CFFF).

## bank87_D000 (org $87D205)

$87D205-$87DFFF  ROM $3D205-$3DFFF: SpriteSet6, sprite frame set 6 of the frame set table at $8FE67D: frames 337-352 (SPFduck ..
SPFhold+7: the duck and hold frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank87_F000. Starts after DrawFrame
(boundary moved from $87D000).

## bank87_E000 (org $87E000)

$87E000-$87EFFF  ROM $3E000-$3EFFF: SpriteSet6 tiles continued (see bank87_D000)

## bank87_F000 (org $87F000)

$87F000-$87FFFF  ROM $3F000-$3FFFF: the last SpriteSet6 tiles, RestoreReplayFrame (hockey93_02), PixelRemap87, RefTiles (packed ref window tiles, vertical
surround tiles for setupice), assepen (logic93_2, asstab $A), $FF fill.

## bank88_8000 (org $888000)

$888000-$88900E  ROM $40000-$4100E: GameSetupMap (packed game setup screen backdrop), SmallFontMap (print: character -> small font tile),
mulu32, getlinee (penalty93_2), the 92G password code (WritePassBits, EncodePW, PWprint, SuperMult), noturn0 (logic93_5), FramerMap and
FramerTiles, showcrowd (video93_1), DrawGameSetupBack, mulu; then SpriteSet8 (frame set 8: arrows, pads, puck, goal), tiles continue to bank88_9000.

## bank88_9000 (org $88900F)

$88900F-$889FFF  ROM $4100F-$41FFF: the rest of SpriteSet8 (see bank88_8000), then TeamBlocksTiles (packed team name banner tiles,
continued in bank88_A000).

## bank88_A000 (org $88A00F)

$88A00F-$88AFFF  ROM $4200F-$42FFF: TeamBlocksTiles continued (see bank88_9000)

## bank88_B000 (org $88B00F)

$88B00F-$88C00E  ROM $4300F-$4400E: the end of TeamBlocksTiles, then SpriteSet7, sprite frame set 7 of the frame set table at $8FE67D:
frames 353-383 (SPFgloves .. SPFPen+6: the fight and penalty box frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank88_E000.

## bank88_C000 (org $88C00F)

$88C00F-$88D00E  ROM $4400F-$4500E: SpriteSet7 tiles continued (see bank88_B000)

## bank88_D000 (org $88D00F)

$88D00F-$88E00E  ROM $4500F-$4600E: SpriteSet7 tiles continued (see bank88_B000)

## bank88_E000 (org $88E00F)

$88E00F-$88EF9B  ROM $4600F-$46F9B: the last SpriteSet7 tiles (see bank88_B000). Ends at the set end; the code after it is in bank88_F000
(boundary moved from $88F001).

## bank88_F000 (org $88EF9C)

$88EF9C-$88FFFF  ROM $46F9C-$47FFF: GetPassWord (92G, the password screen), TitleScreen (93G hockey93_07: title backdrop and scrolling credits),
PlayoffScreen (93G hockey93_06: the playoff tree) with PlayoffTreeSetup, assdefd (logic93_2, asstab 2), SuperAdd (92G), skateto (logic93_5),
$FF fill. Starts after SpriteSet7 (boundary moved from $88F002).

## bank89_8000 (org $898000)

$898000-$898FFF  ROM $48000-$48FFF: SpriteSet11, sprite frame set 11 of the frame set table at $8FE67D: frames 518-531 (SPFSiren ..
SPFSiren+13: the goal siren light frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank89_9000.

## bank89_9000 (org $899000)

$899000-$899FFF  ROM $49000-$49FFF: the last SpriteSet11 tiles, ReplayMode (93G hockey93_02: instant replay control), then SpriteSet13
(frame set 13: goalie catch, glass and save frames), tiles continue to bank89_E000.

## bank89_A000 (org $89A000)

$89A000-$89AFFF  ROM $4A000-$4AFFF: SpriteSet13 tiles continued (see bank89_9000)

## bank89_B000 (org $89B000)

$89B000-$89BFFF  ROM $4B000-$4BFFF: SpriteSet13 tiles continued (see bank89_9000)

## bank89_C000 (org $89C000)

$89C000-$89CFFF  ROM $4C000-$4CFFF: SpriteSet13 tiles continued (see bank89_9000)

## bank89_D000 (org $89D000)

$89D000-$89DFFF  ROM $4D000-$4DFFF: SpriteSet13 tiles continued (see bank89_9000)

## bank89_E000 (org $89E000)

$89E000-$89F009  ROM $4E000-$4F009: the last SpriteSet13 tiles, printscores1 (penalty93_2) with PrintPerLabel and PrintTeamNameAndScore,
p_music_vblank (the sound command sender), then RefTilesHor (packed ref window tiles for the horizontal rink), continued in bank89_F000.

## bank89_F000 (org $89F00A)

$89F00A-$89FFFF  ROM $4F00A-$4FFFF: the rest of RefTilesHor, RefsMapHor (ref window frames for the horizontal rink), the music cue starters
StartSong1-5/8/9, CopyWords, EraseScoutName, GetPlayerRecord, MesAreaDone, StartGame and restoreteams (hockey93_01), EvadePC (logic93_3),
asswingd (logic93_2, asstab 3), $FF fill.

## bank8A_8000 (org $8A8000)

$8A8000-$8A8FFF  ROM $50000-$50FFF: SpriteSet12, sprite frame set 12 of the frame set table at $8FE67D: frames 532-605 (with
SPFflip, SPFstumble and SPFhook). Format as SpriteSet9 (bank84_8000); tiles continue to bank8A_F000.

## bank8A_9000 (org $8A9000)

$8A9000-$8A9FFF  ROM $51000-$51FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_A000 (org $8AA000)

$8AA000-$8AAFFF  ROM $52000-$52FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_B000 (org $8AB000)

$8AB000-$8ABFFF  ROM $53000-$53FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_C000 (org $8AC000)

$8AC000-$8ACFFF  ROM $54000-$54FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_D000 (org $8AD000)

$8AD000-$8ADFFF  ROM $55000-$55FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_E000 (org $8AE000)

$8AE000-$8AEFFF  ROM $56000-$56FFF: SpriteSet12 tiles continued (see bank8A_8000)

## bank8A_F000 (org $8AF000)

$8AF000-$8AFFFF  ROM $57000-$57FFF: the last SpriteSet12 tiles, PlayoffBracketMap (the playoff tree connectors), Credits (title screen text),
lineinput and getlchoice (logic93_1), SetScore (penalty93_2), $FF fill.

## bank8B_8000 (org $8B8000)

$8B8000-$8B9002  ROM $58000-$59002: the 92G playoff code: NewPO, FigureJoy, Opening/Opening4, ReadPassBits, ResolveGames; then SpriteSet5
(frame set 5: the falls), tiles continue to bank8B_F000.

## bank8B_9000 (org $8B9003)

$8B9003-$8BA002  ROM $59003-$5A002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_A000 (org $8BA003)

$8BA003-$8BB002  ROM $5A003-$5B002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_B000 (org $8BB003)

$8BB003-$8BC002  ROM $5B003-$5C002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_C000 (org $8BC003)

$8BC003-$8BD002  ROM $5C003-$5D002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_D000 (org $8BD003)

$8BD003-$8BE002  ROM $5D003-$5E002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_E000 (org $8BE003)

$8BE003-$8BF002  ROM $5E003-$5F002: SpriteSet5 tiles continued (see bank8B_8000)

## bank8B_F000 (org $8BF003)

$8BF003-$8BFFFF  ROM $5F003-$5FFFF: the last SpriteSet5 tiles, printbig (middle93_2), asswingo (logic93_3, asstab 4), showref (video93_1),
skatetopuckinit (logic93_5).

## bank8C_8000 (org $8C8000)

$8C8000-$8C8FFF  ROM $60000-$60FFF: NHLPALogo (the packed NHLPA logo picture), then SpriteSet0 (frame set 0: skating and turning
frames 1-96), tiles continue to bank8C_F000.

## bank8C_9000 (org $8C9000)

$8C9000-$8C9FFF  ROM $61000-$61FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_A000 (org $8CA000)

$8CA000-$8CAFFF  ROM $62000-$62FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_B000 (org $8CB000)

$8CB000-$8CBFFF  ROM $63000-$63FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_C000 (org $8CC000)

$8CC000-$8CCFFF  ROM $64000-$64FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_D000 (org $8CD000)

$8CD000-$8CDFFF  ROM $65000-$65FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_E000 (org $8CE000)

$8CE000-$8CEFFF  ROM $66000-$66FFF: SpriteSet0 tiles continued (see bank8C_8000)

## bank8C_F000 (org $8CF000)

$8CF000-$8CFFFF  ROM $67000-$67FFF: the last SpriteSet0 tiles, checksso (video93_2: off-screen player arrows), chk4pass (logic93_3),
$FF fill.

## bank8D_8000 (org $8D8000)

$8D8000-$8D900B  ROM $68000-$6900B: maketree (hockey93_09), InitPPU, StartPer (hockey93_01), GetLowestPen (penalty93_1), Bcheck (hockey93_03),
NewPO93, eraser, DrawTeamBlocks, EASNLogo (penalty93_2), PeriodOver, GetPlayerName, updatesound, asstab, mulu16, puckshadow, setd0player;
then SpriteSet10 (frame set 10), tiles continue to bank8D_E000.

## bank8D_9000 (org $8D900C)

$8D900C-$8DA00B  ROM $6900C-$6A00B: SpriteSet10 tiles continued (see bank8D_8000)

## bank8D_A000 (org $8DA00C)

$8DA00C-$8DB00B  ROM $6A00C-$6B00B: SpriteSet10 tiles continued (see bank8D_8000)

## bank8D_B000 (org $8DB00C)

$8DB00C-$8DC00B  ROM $6B00C-$6C00B: SpriteSet10 tiles continued (see bank8D_8000)

## bank8D_C000 (org $8DC00C)

$8DC00C-$8DD00B  ROM $6C00C-$6D00B: SpriteSet10 tiles continued (see bank8D_8000)

## bank8D_D000 (org $8DD00C)

$8DD00C-$8DE00B  ROM $6D00C-$6E00B: SpriteSet10 tiles continued (see bank8D_8000)

## bank8D_E000 (org $8DE00C)

$8DE00C-$8DF00B  ROM $6E00C-$6F00B: the last SpriteSet10 tiles (see bank8D_8000), then BigFontTiles (the packed big font), continued in bank8D_F000.

## bank8D_F000 (org $8DF00C)

$8DF00C-$8DFFFF  ROM $6F00C-$6FFFF: the rest of BigFontTiles, StartHL2 (92G penalty.asm: play the highlight of another playoff game), asspenalty
and clrplayer (logic93_2, asstab $C), avdgoal (logic93_5), zero fill.

## bank8E_8000 (org $8E8000)

$8E8000-$8E900A  ROM $70000-$7100A: Gameloop (hockey93_01, with the DoGameFrame time steps), PlayerShortName, assbench (logic93_2, asstab $B);
then SpriteSet3 (frame set 3: celebrations), tiles continue to bank8E_D000.

## bank8E_9000 (org $8E900B)

$8E900B-$8EA00A  ROM $7100B-$7200A: SpriteSet3 tiles continued (see bank8E_8000)

## bank8E_A000 (org $8EA00B)

$8EA00B-$8EB00A  ROM $7200B-$7300A: SpriteSet3 tiles continued (see bank8E_8000)

## bank8E_B000 (org $8EB00B)

$8EB00B-$8EC00A  ROM $7300B-$7400A: SpriteSet3 tiles continued (see bank8E_8000)

## bank8E_C000 (org $8EC00B)

$8EC00B-$8ED00A  ROM $7400B-$7500A: SpriteSet3 tiles continued (see bank8E_8000)

## bank8E_D000 (org $8ED00B)

$8ED00B-$8EE00A  ROM $7500B-$7600A: the last SpriteSet3 tiles, then SpriteSet14 (frame set 14: frames 659-720 with 6-byte pieces);
its pieces continue in bank8E_E000.

## bank8E_E000 (org $8EE00B)

$8EE00B-$8EF00A  ROM $7600B-$7700A: the rest of the SpriteSet14 pieces and the first set 14 tiles (see bank8E_D000)

## bank8E_F000 (org $8EF00B)

$8EF00B-$8EFFFF  ROM $7700B-$77FFF: the last SpriteSet14 tiles, assdefo (logic93_2, asstab 1), zero fill.

## bank8F_8000 (org $8F8000)

$8F8000-$8F9084  ROM $78000-$79084: BigFontMap, an unused energy bar routine, PerLabels, EASNLogoMap, BigFontIndex; the clock, ref, scoreboard
and ticker code (showclock, PushRef, SetHor, USBoard, Intermission, NewTicker), clockcont, updatepentime, linebar, the pause and replay
helpers, the textmap/rink DMA queuers, InitScores, ResetPassWord. Ends before SpriteSet1 (boundary moved from $8F8FFF).

## bank8F_9000 (org $8F9085)

$8F9085-$8FA004  ROM $79085-$7A004: SpriteSet1, sprite frame set 1 of the frame set table at $8FE67D: frames 97-144 (SPFswing: the
shot and swing frames). Format as SpriteSet9 (bank84_8000); tiles continue to bank8F_D000. Starts after the code (boundary moved from $8F9000).

## bank8F_A000 (org $8FA005)

$8FA005-$8FB004  ROM $7A005-$7B004: SpriteSet1 tiles continued (see bank8F_9000)

## bank8F_B000 (org $8FB005)

$8FB005-$8FC004  ROM $7B005-$7C004: SpriteSet1 tiles continued (see bank8F_9000)

## bank8F_C000 (org $8FC005)

$8FC005-$8FD004  ROM $7C005-$7D004: SpriteSet1 tiles continued (see bank8F_9000)

## bank8F_D000 (org $8FD005)

$8FD005-$8FE009  ROM $7D005-$7E009: the last SpriteSet1 tiles, fightinput, holdcheck, PrintStringFromList, Framer, assnothing, GoalieCount,
AdvanceStringPtr, the attribute menu tables, releasepl, assstanley, RemovePlayerFromList, asscenterd, loadTeamStruct, ScoutingReport,
ScoutLabels, PuckcSpots. Ends before SetupTeamForIntermission (boundary moved from $8FE00D).

## bank8F_E000 (org $8FE00A)

$8FE00A-$8FEE82  ROM $7E00A-$7EE82: SetupTeamForIntermission, ClearSprites, RemapTiles, playeracc (logic93_5), ClearPenaltyBuffer, randomd0s,
DefaultMenus, checkagr, WeightedRandomSelect, forceblack, passmode/dopass, FrameSetTable, CompLine, TeamRoster, addframe, Pmenu with the
pause menu lists, GetPadTeam, setpde. Ends before setoptions (boundaries moved from $8FE00E / $8FF002).

## bank8F_F000 (org $8FEE83)

$8FEE83-$8FFFFF  ROM $7EE83-$7FFFF: setoptions (hockey93_08) with its option strings, PixelRemapFramer/PixelRemapFont, UnpackNibbles,
PushNumberWidth, StatsReport, Findhittype, prefmes, CheckInjury, setInjuryType, sublist/priolist, ShowInjuryBox, passtoa0,
GetPlayerCount, GetPlayerNumInitial, Acheck, divs16, doplayeracc, ResetAndSelectPlayers, cd0, MusicCue, sfx8F and the goal box
(93G ShowGoalBox) with GoalBoxText. The end of the ROM.

