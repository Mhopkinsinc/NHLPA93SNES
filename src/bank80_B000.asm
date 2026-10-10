; $80B006-$80C18E  ROM $03006-$0418E: SetSPA, team personnel (ResetBench, forcepldata, Setplass, setplayer, setpersonel, SetPlList:
; hockey93_05), resetplstuff, assinsert/assreplace, setupice and team colors (hockey93_06), SprSort, the game frame (DoGameFrame,
; periodicevents: hockey93_01), AvgCline, printz/print (middle93_2), updatepwrplay, the goalie pulls (ChkGoalies, ReturnGoalies,
; CPgoalie: logic93_4), updatecrowdf, and PenaltyList (hockey93_11).
org $80B006
SetSPA:		;auto: CODE_80B006. 93G SetSPA (logic93_5): set sprite animation d1 on object X (restart at frame 0)
	lda.b d1
	cmp.w SPA,x		; same animation: keep going
	beq .rtl
	sta.w SPA,x
	stz.w SPAnum,x		; SPAnum = 0, SPAcnt = -1
	lda.w #$FFFF
	sta.w SPAcnt,x
.rtl:
	rtl
ResetBench:		;auto: CODE_80B01A. 93G ResetBench (hockey93_05): empty the penalty boxes / put all players on their own bench. PBnum = players left in the box, home*16 + visitors
	stz.w PBnum
	lda.w #$0010		; home: +$10 per player
	sta.b d1
	stz.b a0
	jsl.l .rb
	lda.w #$0001
	sta.b d1
	lda.w #$0002
	sta.b a0
.rb:		;team a0 (0/2), d1 = PBnum step
	lda.w #$0032		; (MaxRos-1)*2
	sta.b d0
.rb1:
	lda.w PBnum
	clc
	adc.b d1
	sta.w PBnum
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	bmi .nopen		; on the ice or bench
	beq .nopen
	bit.w #TMPDINJ		; TMPDINJ: stays in the box
	beq .next
	and.w #$07FF		; no time left: not counted
	sta.b d2
	bne .next
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	bra .next
.nopen:
	lda.w PBnum
	sec
	sbc.b d1
	sta.w PBnum
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT stays out
	beq .next
	lda.w #TMPDBENCH		; TMPDBENCH
	sta.w tmpdst,y
.next:
	dec.b d0
	dec.b d0
	bpl .rb1
	rtl
forcepldata:		;auto: CODE_80B086. 93G forcepldata (hockey93_05): a2 = team. No skating on/off: force the players to their new positions (faceoffs only)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	ldy.b a2
	lda.w tmsort,y
	sta.b a3
	lda.w #$0005
	sta.b d4
.top:
	ldx.b a3
	lda.w newpos,x		; position = newpos (byte)
	and.w #$00FF
	bit.w #$0080
	beq .pos
	ora.w #$FF00
.pos:
	sta.b d0
	sta.w position,x
	cmp.w #$0000
	bmi .next
	jsl.l Setplass
	ldx.b a3
	lda.w position,x
	cmp.w #$0004		; center
	bne .notnear
	lda.w #anearest		; anearest
	sta.b d0
	jsl.l assinsert
.notnear:
	ldx.b a3
	lda.w newpnum,x		; tmpdst of newpnum = TMPDICE: on the ice
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w #TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	jsl.l setplayer		; setplayer
.next:
	ldx.b a3
	lda.w #$FFFF		; newpnum = newpos = -1
	sta.w newpnum,x
	sta.w newpos,x
	inc.b a3
	inc.b a3
	dec.b d4
	bpl .top
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
Setplass:		;auto: CODE_80B138. 93G Setplass (hockey93_05): set the initial assignment of player X from its position
	lda.w position,x
	sta.b d0
	bmi .rtl		; no position: no assignment
	lda.w #.alist
	sta.b a0
	lda.w #.alist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	and.w #$00FF
	sta.b d0
	jmp.w assreplace
.rtl:
	rtl
.alist:		;93G .alist: assignment for each position (goalie, LD, RD, LW, C, RW, extra)
	db agoalie,adefd,adefd,awingd,acenterd,awingd,acenterd
setplayer:		;auto: CODE_80B15D. 93G setplayer (hockey93_05): bring roster player d3 (in d3 = $5F) onto the ice as object X and set his stats from the roster record plus the bonuses
	phx
	phy
	lda.w pflags,x		; clear pf2inj
	and.w #~pf2inj&$FFFF
	sta.w pflags,x
	stz.b a0
	lda.w pfteam,x
	beq .tm
	inc.b a0
	inc.b a0
.tm:
	lda.b d3
	and.w #$00FF
	sta.w pnum,x		; pnum = d3
	asl a
	sta.b d3
	lda.w #aepen		; aepen: from the penalty box
	sta.b d0
	lda.b a0
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpdst,y
	sta.b d1
	bpl .da
	lda.w #aeben		; aeben: from the bench
	sta.b d0
	lda.b d1
	cmp.w #TMPDBENCH
	bne .nda
.da:
	jsl.l assinsert
	stz.w pfalock,x		; pfalock = 0, SPA = 0
	stz.w SPA,x
.nda:
	lda.b a0
	beq .nda1
	lda.w #$0034
.nda1:
	clc
	adc.b d3
	tay
	lda.w #TMPDICE		; tmpdst = TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	ldy.b a0		; a0 = team data (bank $83)
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .push
	ldx.b xsave
	ldy.w #$0008		; team data + word at +8: bonus bytes
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.w PPBonus		; all four bonuses = 0
	stz.w PKBonus
	stz.b ThirdPBonus
	stz.w HmAwBonus
	lda.w position,x		; goalie: no modifiers
	bne .mods
	jmp.w .nomod
.mods:
	lda.w sflags
	bit.w #sf2pwrplay		; sf2pwrplay
	beq .nda3
	jsl.l chkpk2
	beq .nda2
	ldy.w #$0001		; power play: PPBonus = low nibble of byte 1
	lda.b [a0],y
	and.w #$000F
	sta.w PPBonus
	bra .nda3
.nda2:
	ldy.w #$0001		; short-handed: PKBonus = -high nibble of byte 1
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.w PKBonus
.nda3:
	ldy.w #$0002		; HmAwBonus: home = high nibble of byte 2, visitors = -low nibble
	lda.b [a0],y
	and.w #$000F
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w pfteam,x
	bne .tmb
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
.tmb:
	lda.b d0
	sta.w HmAwBonus
	lda.w gsp		; 3rd period?
	sec
	sbc.w #$0002
	bmi .v1
	bvc .p3
	bra .nomod
.v1:
	bvc .nomod
.p3:
	beq .half
	bmi .v2
	bvs .half
	bra .score
.v2:
	bvs .score
.half:
	jsl.l GetPeriodTime		; GetPeriodTime
	lsr.b d0
	lda.b d0
	sec
	sbc.w gameclock
	beq .score
	bmi .v3
	bvs .score
	bra .nomod
.v3:
	bvs .nomod
.score:
	lda.w tmscore		; tied or trailing: ThirdPBonus = 2
	sec
	sbc.w tmscore+2
	sta.b tmp0
	beq .close
	lda.w pfteam,x
	beq .side
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.side:
	lda.b tmp0
	bpl .nomod
.close:
	lda.w #$0002
	sta.b ThirdPBonus
.nomod:
	stx.b xsave
	ldx.w #$0002
.pop:
	pla
	sta.b a0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	ldy.w #$0000		; a0 = roster records
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.find:		;skip the roster records before player d3
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	dec.b d3
	bpl .find
	lda.b a0
	sec
	sbc.w #$0008
	sta.b a0
	lda.b [a0]		; byte 0: rostnum
	and.w #$00FF
	sta.w rostnum,x
	ldy.w #$0001		; byte 1: weight (high nibble*8), legstr
	lda.b [a0],y
	and.w #$00F0
	lsr a
	sta.w weight,x
	lda.b [a0],y
	and.w #$000F
	sta.w legstr,x
	iny		; byte 2: legspd, aioff
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w legspd,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	eor.w #$000F		; frames to skip: (15-n+15)/2
	clc
	adc.w #$000F
	lsr a
	sta.w aioff,x
	iny		; byte 3: aidef, shotspd
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	eor.w #$000F
	clc
	adc.w #$000F
	lsr a
	sta.w aidef,x
	lda.b [a0],y
	and.w #$000F
	sta.w shotspd,x
	lda.w attribute,x		; clear the x flip
	and.w #~attrxflip&$FFFF
	sta.w attribute,x
	iny		; byte 4: aggress, handed, fightagg
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w aggress,x
	lda.b [a0],y
	and.w #$0001		; bit 0 set: left handed
	sta.w handed,x
	bne .ha
	lda.w attribute,x
	ora.w #attrxflip
	sta.w attribute,x
.ha:
	lda.b [a0],y
	and.w #$000E
	sta.w fightagg,x
	iny		; byte 5: stickhand, shotacc
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w stickhand,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w PKBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w shotacc,x
	iny		; byte 6: endurance, spodds
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.w endurance,x
	lda.b [a0],y
	and.w #$000F
	clc
	adc.b ThirdPBonus
	clc
	adc.b ThirdPBonus
	jsl.l ClampNibble
	sta.w spodds,x
	iny		; byte 7: passacc, GGSleft
	lda.b [a0],y
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	clc
	adc.w PPBonus
	clc
	adc.w HmAwBonus
	jsl.l ClampNibble
	sta.w passacc,x
	lda.b [a0],y
	and.w #$000F
	sta.w GGSleft,x
	ply
	plx
	rtl
ClampNibble:		;auto: CODE_80B3E7. 93G ClampNibble (hockey93_05): clamp A to 0-15
	bit.w #$0080		; negative: 0
	beq .hi
	lda.w #$0000
.hi:
	cmp.w #$000F
	bcc .x
	lda.w #$000F
.x:
	rtl
resetplstuff:		;auto: CODE_80B3F8. 93G resetplstuff (hockey93_06): reset team variables and the players on both teams
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	stz.b a2
	jsl.l .top
	lda.w #$0002
	sta.b a2
	jsl.l .top
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
.top:		;team a2
	ldy.b a2
	lda.w tmflags,y
	and.w #~tmfoffside&$FFFF		; clear tmfoffside
	sta.w tmflags,y
	lda.w #$0005
	sta.b d2
	ldx.w tmsort,y
	stx.b a3
.loop:
	stz.w pf2fight,x		; pf2fight = pf2aip = 0, pflags2 bits cleared
	stz.w pf2aip,x
	lda.w pflags,x
	and.w #~(pf2unav|pf2lcm|pf2pen|pf2npc)&$FFFF
	sta.w pflags,x
	lda.w position,x
	bmi .next
	lda.w #SPAglide
	sta.b d1
	jsl.l SetSPA
	stz.w impact,x		; impact = 0, nopuck = 0
	stz.w nopuck,x
	lda.w pflags,x
	and.w #~(pfdoff|pfjoycon)&$FFFF		; keep pfteam/pfgoal/pfna: clear pfdoff, pfjoycon
	sta.w pflags,x
	stz.w pfnc,x
	stz.w pfrev,x
	stz.w pfalock,x
.next:
	inc.b a3
	inc.b a3
	ldx.b a3
	dec.b d2
	bpl .loop
	rtl
assinsert:		;auto: CODE_80B49D. 93G assinsert (logic93_5): insert assignment d0 on player X. Falls into assreplace
	lda.w assnum,x		; assnum - 1
	dec a
	and.w #$0007
	sta.w assnum,x
assreplace:		;auto: CODE_80B4A7. 93G assreplace (logic93_5): replace the current assignment of player X with d0
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	txa		; asslist+X*4+assnum = d0 (byte)
	asl a
	asl a
	adc.w assnum,x
	tay
	sep #$20
	lda.b d0
	sta.w asslist,y
	rep #$30
	rtl
setupice:		;auto: CODE_80B4C1. 93G setupice (hockey93_06): set all variables, send the rink and text graphics to vram, palettes, video mode, team colors
	jsl.l forceblack		; 93G setvram role (bank $8F), bank $8F
	lda.w #$0207		; vram tile bases of the text layer
	sta.w faceoffvrcset
	clc
	adc.w #$0037
	sta.w unusedchars
	adc.w #$000E
	sta.w refcharshor
	adc.w #$0068
	sta.w refchars
	adc.w #$0075
	sta.w blankchar
	inc a
	sta.w smallfontchars
	adc.w #$0064
	sta.w Framercset
	adc.w #$0004
	sta.w BigFontChars
	adc.w #$0090
	sta.w scorechars
	adc.w #$0195
	sta.w ExtraChars
	lda.w #$FF00		; charofs = $FF00
	sta.w charofs
	stz.w charofs+2
	jsl.l InitPPU		; PPU init (bank $8D), bank $8D: PPU registers off/clear, sound driver start
	sep #$20
	cli
	lda.w RDNMI
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY		; NMI on, auto joypad read
	sta.w NMITIMEN
	lda.b #$03		; OBSEL: 8x8/16x16 sprites at $6000
	sta.w OBSEL
	lda.b #BGMODE_1		; BGMODE 1
	sta.w BGMODE
	lda.b #$00
	sta.w BG1SC
	lda.b #$05		; BG2 map at $0400, 64x32
	sta.w BG2SC
	lda.b #$12		; BG1 tiles $2000, BG2 tiles $1000
	sta.w BG12NBA
	lda.b #TM_BG1|TM_BG2|TM_OBJ		; TM: BG1, BG2, sprites
	sta.w TM
	rep #$30
	ldx.w #$00FE
.pal:		;rink palette (bank $83) to both halves of palbuffer
	lda.l RinkPalette,x
	sta.l palbuffer,x
	sta.l palbuffer+$100,x
	dex
	dex
	bpl .pal
	jsl.l sndqreset		; sound queue reset (bank $82)
	lda.w sndbank		; in-game sound set not loaded yet: load it
	cmp.w #$0001
	beq .gfx
	jsl.l SPCGameUpload
.gfx:		;decompress each tile set to $7F0000 and send it to vram
	lda.w #IceRinkTiles		; packed rink tiles (bank82_D000)
	sta.b tmp0
	lda.w #IceRinkTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	lda.w #$1000		; vram $1000
	sta.w VMADDL
	ldx.w #$0000
.up1:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$40E0
	bne .up1
	lda.w #FaceOffTiles		; packed faceoff box tiles (bank87_C000)
	sta.b tmp0
	lda.w #FaceOffTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.up2:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$06E0
	bne .up2
	lda.w #RinkLogoTiles		; packed rink logo tiles (bank84_F000)
	sta.b tmp0
	lda.w #RinkLogoTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.up3:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$01C0
	bne .up3
	lda.w #RefTilesHor		; packed ref window tiles, horizontal rink (bank89_E000)
	sta.b tmp0
	lda.w #RefTilesHor>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.up4:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0D00
	bne .up4
	lda.w #RefTiles		; packed ref window tiles, vertical rink (bank87_F000)
	sta.b tmp0
	lda.w #RefTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	ldx.w #$0000
.up5:
	lda.l unpackbuf,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0EA0
	bne .up5
	ldx.w #$0010
.blank:		;blank tile
	stz.w VMDATAL
	dex
	bne .blank
	lda.w #SmallFontTiles		; packed small font tiles (bank83_C000)
	sta.b tmp0
	lda.w #SmallFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	stz.b a0		; sprite frame list from the $7F0000 data
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap83
	sta.b a1
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #$0064
	sta.b d0
	jsl.l RemapTiles		; bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #FramerTiles
	sta.b a0
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles		; bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #BigFontTiles		; packed big font tiles (bank8D_E000)
	sta.b tmp0
	lda.w #BigFontTiles>>16
	sta.b tmp1
	jsl.l DecompressGraphics
	stz.b a0
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #PixelRemap8D
	sta.b a1
	lda.w #PixelRemap8D>>16
	sta.b a1+2
	lda.w #$0090
	sta.b d0
	jsl.l RemapTiles		; bank $8F: build a sprite frame list ([a0] data, [a1] table, d0 count)
	lda.w #999		; Oldrow = 999, no pause, Hpos = Vpos = 0
	sta.w Oldrow
	lda.w #$0001
	trb.w sflags
	stz.w Hpos
	stz.w Vpos
	lda.b vcount+2		; vcountmark well in the past
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l InitSortObjects
	stz.w zamx
	jsl.l nullrtl
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .gok
	ldx.w #$0016
.flip:		;gmdir: flip pfgoal of the 12 players
	lda.w pfgoal,x
	eor.w #$0001
	sta.w pfgoal,x
	dex
	dex
	bpl .flip
.gok:
	jsl.l setplayercolors
	lda.w #$FFFF		; PadControlBits = $FFFF, padcont = 0
	sta.w PadControlBits
	stz.w padcont
	stz.w padcont+2
	stz.w padcont+4
	stz.w padcont+6
	lda.w #$FFFF		; c1playernum = c2playernum = -1
	sta.w c1playernum
	sta.w c2playernum
	stz.b brightness		; brightness 0, fade in after 10 frames
	lda.w #$000A
	sta.b fadein
	rtl
setplayercolors:		;auto: CODE_80B6D5. 93G setplayercolors (hockey93_06): team colors into palbuffer, then the whole palette to CGRAM
	stz.w ffoframe+6		; pad 3 frame = 0
	stz.w colorflag1
	stz.w colorflag2
	jsl.l SetTeamColors
	lda.w #DMA_CGRAM		; whole CGRAM from palbuffer
	sta.w DMAP7
	lda.w #palbuffer
	sta.w A1T7L
	lda.w #$0200
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	rtl
SetTeamColors:		;auto: CODE_80B706. 92 SetTeamColors role: convert both teams' Genesis colors (team data +2) to SNES colors in palbuffer (BG and sprite halves)
	phx
	phy
	ldx.w #$0000
	lda.w tmdata		; home team colors: palbuffer+$40
	sta.b tmp0
	lda.w #TeamList>>16
	sta.b tmp1
	stz.b tmp2+1
	jsl.l SetTeamColors_team
	lda.w tmdata+2		; away team colors: palbuffer+$60
	sta.b tmp0
	lda.w #$0020
	sta.b tmp2+1
	jsl.l SetTeamColors_team
	ply
	plx
	rtl
SetTeamColors_team:		;auto: CODE_80B72C. one team: tmp0 = team data, tmp2+1 = palbuffer offset
	ldy.w #$0002		; team data + word at +2: palette
	lda.b [tmp0],y
	clc
	adc.b tmp2+1
	tay
	lda.w #$0010
	sta.b tmp2+1
.col:		;0BGR (4 bits) -> 0BBBBBGGGGGRRRRR
	lda.b [tmp0],y
	xba
	and.w #$000F
	asl a
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$00F0
	asl a
	asl a
	ora.b tmp1+1
	sta.b tmp1+1
	lda.b [tmp0],y
	xba
	and.w #$0F00
	asl a
	asl a
	asl a
	ora.b tmp1+1
	sta.l palbuffer+$40,x
	sta.l palbuffer+$140,x
	inx
	inx
	iny
	iny
	dec.b tmp2+1
	bne .col
	rtl
nullrtl:		;auto: CODE_80B76B. does nothing (setupice calls it)
	rtl
SprSort:		;auto: CODE_80B76C. 93G SprSort (hockey93_06): sort the objects by y (x in horizontal mode) into OOlist/OOlistpos
	phx
	phy
	stx.b xsave
	ldx.w #$0000
.push:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .push
	ldx.b xsave
	ldx.w #$0000
	lda.w sfhormode		; horizontal mode sorts by x
	bne .xlist
.ylist:
	lda.w Ypos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .ylist
	bra .loop
.xlist:
	lda.w Xpos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .xlist
.loop:
	stz.b d2
	ldx.w #$0000
.pair:
	lda.w OOlist+1,x
	and.w #$00FF
	sta.b d1
	lda.w OOlist,x
	and.w #$00FF
	sta.b d0
	tay
	lda.w Ylist,y
	ldy.b d1
	sec
	sbc.w Ylist,y
	beq .next
	bmi .v1
	bvc .swap
	bra .next
.v1:
	bvc .next
.swap:
	lda.w OOlist,x
	xba
	sta.w OOlist,x
	txa
	sta.w OOlistpos,y
	inc a
	ldy.b d0
	sta.w OOlistpos,y
	inc.b d2
.next:
	inx
	cpx.w #$000F
	bne .pair
	lda.b d2		; swapped: sort again
	bne .loop
	stx.b xsave
	ldx.w #$000A
.pop:
	pla
	sta.b d0,x
	dex
	dex
	bpl .pop
	ldx.b xsave
	ply
	plx
	rtl
DoGameFrame:		;auto: CODE_80B7FA. 93G DoGameFrame (hockey93_01): one frame of game logic (d7 = elapsed frames, set by the caller)
	jsl.l periodicevents		; periodicevents
	jsl.l updateplayers		; updateplayers
	jsl.l checkwindow		; checkwindow
	jsl.l updatereplay		; updatereplay
	jmp.w setvideo
periodicevents:		;auto: CODE_80B80D. 93G periodicevents (hockey93_01): every game loop; once a second (lldisp) the slower checks
	jsl.l PenaltyManager		; PenaltyManager
	jsl.l updatecrowdf		; updatecrowdf
	jsl.l updatesound		; updatesound, bank $8D: 93G updatesound
	jsl.l clockcont		; clockcont, bank $8F: 93G clockcont
	lda.w sfhormode		; horizontal: no screen updates
	bne .rtl
	lda.w lldisp
	sec
	sbc.b d7
	sta.w lldisp
	bpl .rtl
	clc
	adc.w #$0018		; +$18 frames
	sta.w lldisp
	jsl.l ChkGoalies		; ChkGoalies
	jsl.l UpdateCwdExcite		; UpdateCwdExcite, bank $8F: 93G UpdateCwdExcite
	jsl.l CheckPeriodEnd		; CheckPeriodEnd, bank $8F: 93G CheckPeriodEnd
	jsl.l UpdateLineChange		; UpdateLineChange
	jsl.l CheckInjury		; CheckInjury, bank $8F: 93G CheckInjury
	jmp.w updatepwrplay
.rtl:
	rtl
AvgCline:		;auto: CODE_80B84C. 93G AvgCline (penalty93_2): d0 = average energy of the current line of team a2
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	stz.b d0
	stz.b d1
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.l0:
	ldy.b a0
	lda.w position,y
	beq .next
	bmi .next
	lda.w pnum,y
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpde,y
	adc.b d0
	sta.b d0
	inc.b d1
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .l0
	lda.b d1		; players counted
	beq .ex
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l divu16
	sta.b d0
.ex:
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
divu16:		;auto: CODE_80B8D8. 68k divu.w: mulres = mulb / mula (16-bit), mulres+2 = remainder; A = mula = mulb = quotient. C clear
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulb+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
	lda.b mulb
	cmp.b mula
	lda.w #$0000
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	inc.b mulres
.next:
	dec.b mulb+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
printz:		;auto: CODE_80B90C. 93G printz (middle93_2): print the string that follows the jsl (length word counting itself, then control bytes / text), return after it. Keeps a1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.b $07,s		; a1 = return address+1: the string
	sta.b a1+2
	lda.b $05,s
	inc a
	sta.b a1
	lda.b [a1]		; return past the string
	clc
	adc.b $05,s
	sta.b $05,s
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
print:		;auto: CODE_80B92D. 93G print (middle93_2): [a1] = string (length word, control bytes / text) into textmap at printx/printy; marks textdirtylo/hi. "@" = blank tile
	lda.b [a1]
	cmp.w #$0100
.hang:		;string longer than 255: hang
	bcs .hang
	phx
	ldy.w #$0002		; Y = 2: skip the length word
.pos:
	lda.w printy		; X = (printy*32+printx)*2 + printm
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
.char:
	tya
	cmp.b [a1]
	bne .ctl
	jmp.w .done
.ctl:
	lda.b [a1],y
	bit.w #$0080		; bit 7: control code
	bne .code
	and.w #$00FF
	cmp.w #$0040		; "@" = blank tile
	bne .font
	jmp.w .blank
.font:
	phx
	asl a
	tax
	lda.l SmallFontMap,x		; char -> tile (bank $88 table) + font + printa
	adc.w smallfontchars
	adc.w printfontset
	ora.w printa
	plx
.put:
	cmp.l textmap,x
	beq .nextc
	sta.l textmap,x
	txa
	lsr a
	cmp.b textdirtylo		; textdirtylo/hi
	bcs .hi
	sta.b textdirtylo
.hi:
	cmp.b textdirtyhi
	bcc .nextc
	sta.b textdirtyhi
.nextc:
	inc.w printx
	inx
	inx
	iny
	bra .char
.code:		;control code -n: palette/priority bits, font number, map; then x, y
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030		; bits 4-5: palette (printa bits 10-12)
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa
	lda.b $01,s
	and.w #$0040		; bit 6: priority
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.w printa
	pla
	and.w #$0003		; bits 0-1: font, printfontset = font table entry
	sta.w printfont
	pha
	asl a
	tax
	lda.w printfontset,x
	sta.w printfontset
	pla
	dec a		; map (font-1) * $800 bytes
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	sta.b printm
	iny
	lda.b [a1],y
	and.w #$007F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$007F
	sta.w printy
	iny
	jmp.w .pos
.done:
	clc
	adc.b a1
	sta.b a1
	plx
	rtl
.blank:
	lda.w blankchar
	clc
	adc.w printfontset
	jmp.w .put
updatepwrplay:		;auto: CODE_80B9F4. 93G updatepwrplay (penalty93_1): show the power play box: time left and the team on the power play
	stz.b a2		; a2 = home, a3 = away
	lda.w #$0002
	sta.b a3
	lda.w tmap
	sec
	sbc.w tmap+2
	sta.b d0
	bne .neg
	jmp.w updatepwrplay_clr
.neg:
	bpl .t0
	lda.w sflags
	bit.w #sf2pwrtm		; sf2pwrtm
	bne .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	tsb.w sflags
	bra .upp
.t0:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w sflags
	bit.w #sf2pwrtm
	beq .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	trb.w sflags
.upp:
	lda.w #sf2pwrplay		; sf2pwrplay; new: tmPwrPlays + 1
	tsb.w sflags
	bne .uppt
	ldx.b a3
	inc.w tmPwrPlays,x
.uppt:
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19,"   ",$16,$17,$18,$19,$BF,$01,$1A,"   "
	jsl.l GetLowestPen		; bank $8D: 93G GetLowestPen
	jsl.l PushTime		; bank $8F: 93G PushTime
	jsl.l print
	ldx.b a3
	lda.w tmdata,x		; team name (bank $83)
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w #mesarea		; a3 = mesarea, length 2
	sta.b a3
	lda.w #mesarea>>16
	sta.b a3+2
	lda.w #$0002
	sta.b [a3]
	jsl.l appendz		; appendz (bank $82)
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	lda.b a0
	ldy.w #$0004
	clc
	adc.b [a0],y
	sta.b a0
	adc.b [a0]
	sta.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	jsl.l appstring		; appstring, bank $8F: 93G appstring
	lda.b a3
	sta.b a1
	lda.b a3+2
	sta.b a1+2
	jmp.w print
updatepwrplay_clr:		;auto: CODE_80BAAF. 93G updatepwrplay .clrpwrplay: power play over, EASN logo back
	lda.w #sf2pwrplay
	trb.w sflags
	beq .rtl
	jml.l EASNLogo		; EASNLogo, bank $8D: 93G EASNLogo
.rtl:
	rtl
printteamname:		;auto: CODE_80BABC. print the team name of team d3 (0 home) at printx/printy, then printy += 2
	lda.w printx
	pha
	lda.w tmdata		; tmdata of team d3
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b d3
	beq .name
	lda.w tmdata+2
	sta.b a1
.name:
	ldy.w #$0004
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	adc.b a1
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	inc.w printy
	rtl
ChkGoalies:		;auto: CODE_80BAF2. 93G ChkGoalies (logic93_4): computer pulls the goalie on a delayed penalty. Called from periodicevents
	lda.w gmclock		; clock stopped
	bne ChkGoalies_CPG_rtl
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ChkGoalies_CPG
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ChkGoalies_CPG:		;auto: CODE_80BB12. 93G ChkGoalies .CPG: d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y		; goalie already out
	bmi .rtl
	lda.w puckc
	bmi .rtl
	sec
	sbc.w #$0006		; puckc - 6, negated for the away team: negative = team a2 has the puck
	ldy.b a2
	beq .side
	eor.w #$FFFF
	inc a
.side:
	sta.b d0
	cmp.w #$0000
	bpl .rtl
	lda.w pucky
	sta.b d1
	lda.w gmode
	bit.w #gmpendel		; gmpendel
	bne .pull
	jmp.w CPgoalie
.pull:		;delayed penalty: pull the goalie, any team
	lda.w tmgoalie,y
	ora.w #$FF00		; tmgoalie high byte $FF: pulled
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl
setpersonel:		;auto: CODE_80BB5A. 93G setpersonel (hockey93_05): set the personel of team a2 from SetPlList: keep the players already on the ice, place the rest
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pusha
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #$0005
	sta.b d4
.l0:
	lda.w #$FFFF		; newpos = newpnum = -1 for the 6 objects
	sta.w newpos,x
	sta.w newpnum,x
	inx
	inx
	stx.b a3
	dec.b d4
	bpl .l0
	jsl.l SetPlList
	lda.w #$0005
	sta.b d4
	lda.w #PlList		; a4 = PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.l1:		;wanted players already on the ice keep their object
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.l2:
	inx
	inx
	stx.b a3
	lda.w pnum,x
	and.w #$00FF
	sta.b tmp0
	lda.b d5
	and.w #$00FF
	cmp.b tmp0
	beq .found
	dec.b d3
	bpl .l2
	bra .next
.found:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np
	ora.w #$FF00
.np:
	sta.w newpos,x
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn
	ora.w #$FF00
.npn:
	sta.w newpnum,x
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .l1
	lda.w #$0005
	sta.b d4
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.l3:		;the rest go to objects with no requested player
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next2
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.l4:
	inx
	inx
	stx.b a3
	lda.w newpnum,x
	bit.w #$0080
	bne .free
	dec.b d3
	bpl .l4
	bra .chkpos
.free:
	stx.b a0
.chkpos:
	lda.w position,x
	bpl .put
	dec.b d3
	bpl .l4
.put:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np2
	ora.w #$FF00
.np2:
	ldy.b a0
	sta.w newpos,y
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn2
	ora.w #$FF00
.npn2:
	sta.w newpnum,y
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next2:
	dec.b d4
	bpl .l3
	stx.b xsave
	ldx.w #$0012
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
SetPlList:		;auto: CODE_80BCB0. 93G SetPlList (hockey93_05): make PlList, the players we want on the ice now (team a2)
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #$0000
	sta.b [a4]
	ldy.w #$0002
	sta.b [a4],y
	ldy.w #$0004
	sta.b [a4],y
	lda.w #priolist		; priolist (bank $8F)
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmgoalie,y
	bpl .gin		; no goalie: skip the priolist goalie entry
	inc.b a0
.gin:
	lda.w tmdata,y		; line sets: team data + word at +6, + tmline*8
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #$0006
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	ldy.b a2
	lda.w tmline,y
	asl a
	asl a
	asl a
	sta.b d0
	adc.b a1
	sta.b a1
	lda.w tmap,y		; tmap: players on ice
	sta.b d4
	bra .next
.l0:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	sta.b d5
	tay
	sep #$20
	lda.b [a1],y
	ldy.b d4
	sta.b [a4],y
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b d5
	sta.b [a4],y
	rep #$20
	lda.b d5
	bne .next
	ldy.b a2		; goalie: 1 + tmgoalie
	lda.w tmgoalie,y
	inc a
	sta.b d3
	ldy.b d4
	sep #$20
	lda.b d3
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .l0
	lda.w #$0005
	sta.b d4
.l1:		;is each wanted player available?
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d3
	beq .next1
	and.w #$00FF
	bit.w #$0080
	beq .p
	ora.w #$FF00
.p:
	dec a
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	clc
	adc.b d3
	tay
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: substitute
	beq .sub
	lda.w tmpdst,y
	bmi .next1		; bench or ice: ok
	beq .next1
.sub:		;not available: find a player of a similar position (sublist)
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #$0006
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	asl a
	sta.b d0
	lda.w #sublist		; sublist (bank $8F, word offsets)
	sta.b a0
	lda.w #sublist>>16
	sta.b a0+2
	ldy.b d0
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.s1:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .all
	ldy.b d0
	lda.b [a1],y
	and.w #$00FF
	sta.b d0
	jsl.l TryAddPlayerToList
	beq .s1
.next1:
	dec.b d4
	bmi .rtl
	jmp.w .l1
.rtl:
	rtl
.all:		;try every roster player, last first
	jsl.l GetPlayerCount		; GetPlayerCount, bank $8F: 93G GetPlayerCount
	lda.b d0
	sta.b d3
.try:
	lda.b d3
	sta.b d0
	dec.b d3
	bmi .next1
	jsl.l TryAddPlayerToList
	beq .try
	bra .next1
TryAddPlayerToList:		;auto: CODE_80BDEB. 93G TryAddPlayerToList (hockey93_05): d0 = roster player (1 based), d4 = PlList slot. A = d1 = player if added, 0 (Z set) if not available
	lda.b d0
	sta.b d1
	dec.b d0
	asl.b d0
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0000
	beq .chk
	bmi .v1
	bvs .chk
	bra .no
.v1:
	bvs .no
.chk:
	lda.w tmpdst,y
	cmp.w #TMPDOUT		; TMPDOUT: not available
	beq .no
	lda.w #$0005
	sta.b d0
.s2:
	ldy.b d0
	lda.b [a4],y
	and.w #$00FF
	sta.b tmp0
	lda.b d1
	and.w #$00FF
	cmp.b tmp0
	beq .no		; already in PlList
	dec.b d0
	bpl .s2
	ldy.b d4
	sep #$20
	lda.b d1
	sta.b [a4],y
	rep #$20
	lda.b d1
	and.w #$00FF
	rtl
.no:
	lda.w #$0000
	sta.b d1
	rtl
ReturnGoalies:		;auto: CODE_80BE47. 93G ReturnGoalies (logic93_4): if the computer pulled its goalie, should he come back? Called from puckfaceoff
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ReturnGoalies_r
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ReturnGoalies_r:		;auto: CODE_80BE62. 93G ReturnGoalies .r: d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y
	bpl .rtl		; goalie in
	and.w #$00FF
	cmp.w #$000A		; low byte = goalie to return
	bcs .rtl
	sta.w tmgoalie,y
	lda.w foy		; d1 = foy
	sta.b d1
	jmp.w CPgoalie
.rtl:
	rtl
CPgoalie:		;auto: CODE_80BE89. 93G CPgoalie (logic93_4): should the computer pull its goalie? d1 = puck/faceoff y. 3rd period, behind by 2, under a minute
	lda.w gsp		; 3rd period only
	cmp.w #$0002
	bne .rtl
	ldy.b a1
	lda.w tmscore,y
	ldy.b a2
	sec
	sbc.w tmscore,y
	sta.b d0
	bmi .rtl
	cmp.w #$0002		; behind by exactly 2
	bne .rtl
	lda.w gameclock
	cmp.w #$003D		; 60 seconds or less
	bcs .rtl
	lda.w tmsort,y
	tay
	lda.w pfgoal,y		; own half of the faceoff/puck
	bne .side
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.side:
	lda.b d1
	bmi .rtl
	ldy.b a2
	lda.w tmgoalie,y
	ora.w #$FF00		; pull the goalie
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl
updatecrowdf:		;auto: CODE_80BED1. 93G updatecrowdf (hockey93_01): every game loop (d7 = elapsed frames): crowd level decay and the crowd animation frame
	lda.b crowdlevel
	sec
	sbc.w #$015E		; 350
	bmi .v1
	bvc .loud
	bra .dec
.v1:
	bvc .dec
.loud:
	dec.b crowdlevel		; loud crowd calms down faster
	dec.b crowdlevel
	dec.b crowdlevel
.dec:
	lda.b crowdlevel
	sec
	sbc.b d7
	sta.b crowdlevel
	bpl .cnt
	stz.b crowdlevel
.cnt:
	lda.b crowdcnt
	sec
	sbc.b d7
	sta.b crowdcnt
	bpl .cf
	lda.b crowdlevel
	lsr a
	sta.b d0
	cmp.w #$0080
	bcc .lvl
	lda.w #$007F
	sta.b d0
.lvl:
	lda.b d0
	and.w #$0060		; %01100000
	sta.b d0
	lda.b crowdstep
	inc a
	inc a
	and.w #$001E		; %00011110
	sta.b crowdstep
	clc
	adc.b d0
	sta.b d0
	tay
	lda.w #cd0		; cd0 (bank $8F): frame high byte, time low byte
	sta.b a0
	lda.w #cd0>>16
	sta.b a0+2
	lda.b [a0],y
	xba
	sep #$20
	sta.b crowdframe+1
	rep #$20
	lda.b [a0],y
	and.w #$00FF
	sta.b d1
	lda.w seed		; random 0..time
	and.b d1
	sta.b d2
	clc
	adc.b d1
	sta.b d1
	sta.b crowdcnt
.cf:		;random extra frame 19-25 when the crowd is loud
	sep #$20
	stz.b crowdframe
	rep #$30
	lda.b crowdlevel
	cmp.w #$0119		; 280
	bcc .rtl
	lda.w seed
	and.w #$007F
	cmp.w #$0013
	bcc .rtl
	cmp.w #$001A
	bcs .rtl
	sep #$20
	sta.b crowdframe
	rep #$30
.rtl:
	rtl
PenaltyList:		;93G PenaltyList (hockey93_11): penalty number = word offset into this table. Used by AddPenalty, the penalty box and stats
	dw $0000		; 0
	dw .eop-PenaltyList		; $02 period over (92 PenEOP 2)
	dw .eog-PenaltyList		; $04 game over (92 PenEOG 4)
	dw .ghold-PenaltyList		; $06 (92 PenOOP $C)
	dw .ghold-PenaltyList		; $08 (92 PenGhold $E)
	dw .whistle-PenaltyList		; $0A whistle (92 PenWhistle $26)
	dw .ice-PenaltyList		; $0C icing (92 PenIcing 8)
	dw .goal-PenaltyList		; $0E goal (92 PenGoal 6)
	dw .offsides-PenaltyList		; $10 offsides (92 PenOffsides $A)
	dw .rough2-PenaltyList		; $12 roughing, slow down time $A
	dw .p14-PenaltyList		; $14 93 only, no text
	dw .charge-PenaltyList		; $16 charging
	dw .slash-PenaltyList		; $18 slashing
	dw .rough-PenaltyList		; $1A roughing
	dw .cross-PenaltyList		; $1C cross check
	dw .hook-PenaltyList		; $1E hooking
	dw .trip-PenaltyList		; $20 tripping
	dw .int-PenaltyList		; $22 interference
	dw .hold-PenaltyList		; $24 holding
	dw .fight-PenaltyList		; $26 fighting
	dw .fight2-PenaltyList		; $28 fighting * (93 only)
	dw .inst-PenaltyList		; $2A fight instigator
	dw .delay-PenaltyList		; $2C delay (92 PenDelay $24)
;format: dw $ttmm (tt = slow down time in half secs, mm = penalty min.); string (length word counting itself, text);
;then dw $ffdd,... (ff = frame, dd = delay; negative ends). 93G PenaltyList (hockey93_11)
.eop:		;period over (92 PenEOP 2)
	dw $0100
	dw 13
	db "Period Over"
	dw -$0510
.eog:		;game over (92 PenEOG 4)
	dw $0100
	dw 11
	db "Game Over"
	dw $0510,-$4030
.goal:		;goal (92 PenGoal 6)
	dw $0100
	dw 2
	dw $050A,-$4010
.p14:		;93 only, no text
	dw $0100
	dw 2
	dw $0510,-$4018
.ice:		;icing (92 PenIcing 8)
	dw $0100
	dw 7
	db "Icing"
	dw $0002,$0101,-$0206
.offsides:		;offsides (92 PenOffsides $A)
	dw $0100
	dw 10
	db "Off-side"
	dw $0002,$0301,-$040F
.ghold:		;(92 PenOOP $C)
	dw $0100
	dw 10
	db "Face Off"
	dw -$050A
.delay:		;delay (92 PenDelay $24)
	dw $0000
	dw 9
	db "Penalty"
	dw $0003,$0301,-$040F
.whistle:		;whistle (92 PenWhistle $26)
	dw $0000
	dw 2
	dw -$050A
.charge:		;charging
	dw $0402
	dw 10
	db "Charging"
	dw $0004,$0101,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,$0A01,$0B01,-$0101
.slash:		;slashing
	dw $0402
	dw 10
	db "Slashing"
	dw $0004,$0101,$0201,$0301,$0201,$0301,$0201,$0301,$0201,$0301,-$0101
.trip:		;tripping
	dw $0402
	dw 10
	db "Tripping"
	dw $0004,$0401,$0501,$0401,$0501,$0401,$0501,$0401,$0501,-$0101
.rough2:		;roughing, slow down time $A
	dw $0A02
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.rough:		;roughing
	dw $0402
	dw 10
	db "Roughing"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.hook:		;hooking
	dw $0402
	dw 9
	db "Hooking"
	dw $0004,$0101,$0901,$0801,$0901,$0801,$0901,$0801,$0901,$0801,-$0101
.cross:		;cross check
	dw $0402
	dw 13
	db "Cross Check"
	dw $0004,$0601,$0F01,$1001,$0F01,$1001,$0F01,$1001,$0F01,$1001,-$0101
.int:		;interference
	dw $0402
	dw 14
	db "Interference"
	dw $0004,$0101,$0C06,-$0101
.hold:		;holding
	dw $0402
	dw 9
	db "Holding"
	dw $0004,$0101,$0706,-$0101
.fight:		;fighting
	dw $2805
	dw 10
	db "Fighting"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.fight2:		;fighting * (93 only)
	dw $2805
	dw 12
	db "Fighting *"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
.inst:		;fight instigator
	dw $2802
	dw 18
	db "Fight Instigator"
	dw $0004,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,$0D01,$0E01,-$0101
