; $8FEE83-$8FFFFF  ROM $7EE83-$7FFFF: setoptions (hockey93_08) with its option strings, PixelRemapFramer/PixelRemapFont, UnpackNibbles,
; PushNumberWidth, StatsReport, Findhittype, prefmes, CheckInjury, setInjuryType, sublist/priolist, ShowInjuryBox, passtoa0,
; GetPlayerCount, GetPlayerNameWithAttrib, Acheck, divs16, doplayeracc, ResetAndSelectPlayers, cd0, MusicCue, sfx8F and the goal box
; (93G DisplayPlayerAttributeMenu) with attrText. The end of the ROM.
org $8FEE83
setoptions:		;auto: CODE_8FEE83 (jsl from bank $83). 93G setoptions (hockey93_08): the options screen: GameSetupMap backdrop, small font and Framer tiles (remapped), NHLPA logo, team blocks; Up/Down
		;   picks a line (.nms), Left/Right changes it (.IncItem), Start goes to maketree; after $12C0 idle frames a demo with random teams
	lda.w #vb2_blank		; $8FEE83: A9 CE 80
	sta.b vbint		; $8FEE86: 85 14
	lda.w #HBdefault		; $8FEE88: A9 A3 83
	sta.b hbint		; $8FEE8B: 85 16
	lda.b sprclock		; $8FEE8D: A5 A7
	sec		; $8FEE8F: 38
	sbc.w #$003C		; $8FEE90: E9 3C 00
	ldx.w #$0000		; $8FEE93: A2 00 00
.l1:
	sta.l sprframetime,x		; $8FEE96: 9F 00 20 7E
	inx		; $8FEE9A: E8
	inx		; $8FEE9B: E8
	cpx.w #$4C74		; $8FEE9C: E0 74 4C
	bne .l1		; $8FEE9F: D0 F5
	ldx.w #$0000		; $8FEEA1: A2 00 00
.l2:
	sta.w sprslottime,x		; $8FEEA4: 9D AB 04
	inx		; $8FEEA7: E8
	inx		; $8FEEA8: E8
	cpx.w #$0400		; $8FEEA9: E0 00 04
	bne .l2		; $8FEEAC: D0 F6
	stz.b DMAListend		; $8FEEAE: 64 A3
	sep #$20		; $8FEEB0: E2 20
	cli		; $8FEEB2: 58
	lda.w RDNMI		; $8FEEB3: AD 10 42
	lda.b #$81		; $8FEEB6: A9 81
	sta.w NMITIMEN		; $8FEEB8: 8D 00 42
	rep #$30		; $8FEEBB: C2 30
	lda.b vcount		; $8FEEBD: A5 00
.l3:
	cmp.b vcount		; $8FEEBF: C5 00
	beq .l3		; $8FEEC1: F0 FC
	jsl.l InitPPU		; $8FEEC3: 22 20 81 8D
	sep #$20		; $8FEEC7: E2 20
	cli		; $8FEEC9: 58
	lda.w RDNMI		; $8FEECA: AD 10 42
	lda.b #$81		; $8FEECD: A9 81
	sta.w NMITIMEN		; $8FEECF: 8D 00 42
	lda.b #$03		; $8FEED2: A9 03
	sta.w OBSEL		; $8FEED4: 8D 01 21
	lda.b #$01		; $8FEED7: A9 01
	sta.w BGMODE		; $8FEED9: 8D 05 21
	lda.b #$00		; $8FEEDC: A9 00
	sta.w BG1SC		; $8FEEDE: 8D 07 21
	lda.b #$04		; $8FEEE1: A9 04
	sta.w BG2SC		; $8FEEE3: 8D 08 21
	lda.b #$11		; $8FEEE6: A9 11
	sta.w BG12NBA		; $8FEEE8: 8D 0B 21
	lda.b #$13		; $8FEEEB: A9 13
	sta.w TM		; $8FEEED: 8D 2C 21
	rep #$30		; $8FEEF0: C2 30
	stz.w printfontset		; $8FEEF2: 9C CB 1B
	stz.w charofs		; $8FEEF5: 9C CD 1B
	stz.w charofs2		; $8FEEF8: 9C CF 1B
	lda.w #$0012		; $8FEEFB: A9 12 00
	sta.w blankchar		; $8FEEFE: 8D E7 1B
	inc a		; $8FEF01: 1A
	sta.w smallfontchars		; $8FEF02: 8D D7 1B
	clc		; $8FEF05: 18
	adc.w #$0064		; $8FEF06: 69 64 00
	sta.w Framercset		; $8FEF09: 8D DB 1B
	adc.w #$0004		; $8FEF0C: 69 04 00
	sta.w logochars		; $8FEF0F: 8D DD 1B
	adc.w #$0035		; $8FEF12: 69 35 00
	sta.w scorechars		; $8FEF15: 8D E5 1B
	jsl.l DrawGameSetupBack		; $8FEF18: 22 C3 88 88
	lda.w #GameSetupMap		; $8FEF1C: A9 00 80
	sta.b tmp0		; $8FEF1F: 85 73
	lda.w #GameSetupMap>>16		; $8FEF21: A9 88 00
	sta.b tmp1		; $8FEF24: 85 75
	jsl.l DecompressGraphics		; $8FEF26: 22 3E FA 86
	sep #$20		; $8FEF2A: E2 20
	stz.w CGADD		; $8FEF2C: 9C 21 21
	ldx.w #$0000		; $8FEF2F: A2 00 00
.l4:
	lda.l TestList+$800,x		; $8FEF32: BF 00 08 7F
	sta.l palbuffer,x		; $8FEF36: 9F 74 6C 7E
	sta.w CGDATA		; $8FEF3A: 8D 22 21
	inx		; $8FEF3D: E8
	cpx.w #$0100		; $8FEF3E: E0 00 01
	bne .l4		; $8FEF41: D0 EF
	ldx.w #$0000		; $8FEF43: A2 00 00
.l5:
	lda.l RinkPalette,x		; $8FEF46: BF 2B F7 83
	sta.l palbuffer+$100,x		; $8FEF4A: 9F 74 6D 7E
	sta.w CGDATA		; $8FEF4E: 8D 22 21
	inx		; $8FEF51: E8
	cpx.w #$0100		; $8FEF52: E0 00 01
	bne .l5		; $8FEF55: D0 EF
	rep #$30		; $8FEF57: C2 30
	lda.w #$1000		; $8FEF59: A9 00 10
	sta.w VMADDL		; $8FEF5C: 8D 16 21
	ldx.w #$0000		; $8FEF5F: A2 00 00
.l6:
	lda.l TestList+$900,x		; $8FEF62: BF 00 09 7F
	sta.w VMDATAL		; $8FEF66: 8D 18 21
	inx		; $8FEF69: E8
	inx		; $8FEF6A: E8
	cpx.w #$0240		; $8FEF6B: E0 40 02
	bne .l6		; $8FEF6E: D0 F2
	ldx.w #$0010		; $8FEF70: A2 10 00
.l7:
	stz.w VMDATAL		; $8FEF73: 9C 18 21
	dex		; $8FEF76: CA
	bne .l7		; $8FEF77: D0 FA
	lda.w #SmallFontTiles		; $8FEF79: A9 D8 C6
	sta.b tmp0		; $8FEF7C: 85 73
	lda.w #SmallFontTiles>>16		; $8FEF7E: A9 83 00
	sta.b tmp1		; $8FEF81: 85 75
	jsl.l DecompressGraphics		; $8FEF83: 22 3E FA 86
	lda.w #$0000		; $8FEF87: A9 00 00
	sta.b a0		; $8FEF8A: 85 33
	lda.w #$007F		; $8FEF8C: A9 7F 00
	sta.b a0+2		; $8FEF8F: 85 35
	lda.w #PixelRemapFont		; $8FEF91: A9 C8 F4
	sta.b a1		; $8FEF94: 85 37
	lda.w #PixelRemapFont>>16		; $8FEF96: A9 8F 00
	sta.b a1+2		; $8FEF99: 85 39
	lda.w #$0064		; $8FEF9B: A9 64 00
	sta.b d0		; $8FEF9E: 85 53
	jsl.l RemapTiles		; $8FEFA0: 22 E4 E0 8F
	lda.w #FramerTiles		; $8FEFA4: A9 2E 87
	sta.b a0		; $8FEFA7: 85 33
	lda.w #FramerTiles>>16		; $8FEFA9: A9 88 00
	sta.b a0+2		; $8FEFAC: 85 35
	lda.w #PixelRemapFramer		; $8FEFAE: A9 B8 F4
	sta.b a1		; $8FEFB1: 85 37
	lda.w #PixelRemapFramer>>16		; $8FEFB3: A9 8F 00
	sta.b a1+2		; $8FEFB6: 85 39
	lda.w #$0004		; $8FEFB8: A9 04 00
	sta.b d0		; $8FEFBB: 85 53
	jsl.l RemapTiles		; $8FEFBD: 22 E4 E0 8F
	lda.w #NHLPALogo		; $8FEFC1: A9 00 80
	sta.b tmp0		; $8FEFC4: 85 73
	lda.w #NHLPALogo>>16		; $8FEFC6: A9 8C 00
	sta.b tmp1		; $8FEFC9: 85 75
	jsl.l DecompressGraphics		; $8FEFCB: 22 3E FA 86
	ldx.w #$0000		; $8FEFCF: A2 00 00
.l8:
	lda.l TestList+$1A0,x		; $8FEFD2: BF A0 01 7F
	sta.w VMDATAL		; $8FEFD6: 8D 18 21
	inx		; $8FEFD9: E8
	inx		; $8FEFDA: E8
	cpx.w #$06A0		; $8FEFDB: E0 A0 06
	bne .l8		; $8FEFDE: D0 F2
	lda.w #TeamBlocksTiles		; $8FEFE0: A9 73 9B
	sta.b tmp0		; $8FEFE3: 85 73
	lda.w #TeamBlocksTiles>>16		; $8FEFE5: A9 88 00
	sta.b tmp1		; $8FEFE8: 85 75
	jsl.l DecompressGraphics		; $8FEFEA: 22 3E FA 86
	ldx.w #$0000		; $8FEFEE: A2 00 00
.l9:
	lda.l TestList,x		; $8FEFF1: BF 00 00 7F
	sta.w VMDATAL		; $8FEFF5: 8D 18 21
	inx		; $8FEFF8: E8
	inx		; $8FEFF9: E8
	cpx.w #$32A0		; $8FEFFA: E0 A0 32
	bne .l9		; $8FEFFD: D0 F2
	jsl.l ReadPads		; $8FEFFF: 22 E8 F3 80
	jsl.l Readjoy12		; $8FF003: 22 D2 FA 84
	lda.w #$0000		; $8FF007: A9 00 00
	sta.b sprpriority		; $8FF00A: 85 BB
	jsl.l printz		; $8FF00C: 22 0C B9 80
	dw $0005		; $8FF010  printz inline string: length (counts itself), then control bytes / text
	db $FE,$00,$00
	jsl.l InitSortObjects		; $8FF015: 22 16 F8 84
	lda.w #$0028		; $8FF019: A9 28 00
	sta.w OldXpos		; $8FF01C: 8D 1F 0A
	sta.w OldXpos+$C		; $8FF01F: 8D 2B 0A
	lda.w #.text		; $8FF022: A9 56 F4
	sta.b a1		; $8FF025: 85 37
	lda.w #.text>>16		; $8FF027: A9 8F 00
	sta.b a1+2		; $8FF02A: 85 39
.textlp:		;93G .textlp: print the .text lines until a 0 byte
	jsl.l print		; $8FF02C: 22 2D B9 80
	ldy.w #$0002		; $8FF030: A0 02 00
	lda.b [a1],y		; $8FF033: B7 37
	and.w #$00FF		; $8FF035: 29 FF 00
	bne .textlp		; $8FF038: D0 F2
	lda.w #$FFFF		; $8FF03A: A9 FF FF
	sta.w notdemo		; $8FF03D: 8D 0E 16
	lda.w OptPlayMode		; $8FF040: AD 00 16
	cmp.w #$0002		; $8FF043: C9 02 00
	bcc .l10		; $8FF046: 90 04
	jsl.l NewPO		; $8FF048: 22 00 80 8B
.l10:
	stz.b d7		; $8FF04C: 64 6F
	stz.b d0		; $8FF04E: 64 53
	jsl.l .nms		; $8FF050: 22 C5 F2 8F
	jsl.l .ps		; $8FF054: 22 EA F1 8F
	jsl.l ReadPads		; $8FF058: 22 E8 F3 80
	jsl.l StartSong6		; $8FF05C: 22 E1 FB 86
	lda.w #$0001		; $8FF060: A9 01 00
	sta.b fadein		; $8FF063: 85 08
.idle:		;restart the idle count (d6 = $12C0 frames until the demo)
	lda.w #$12C0		; $8FF065: A9 C0 12
	sta.b d6		; $8FF068: 85 6B
.frame:		;one frame: seed counts up while waiting for VBlank_SprPal to run
	inc.w seed		; $8FF06A: EE A1 04
	bne .l11		; $8FF06D: D0 03
	inc.w seed+2		; $8FF06F: EE A3 04
.l11:
	lda.b vbint		; $8FF072: A5 14
	cmp.w #VBlank_SprPal		; $8FF074: C9 C5 81  VBlank_SprPal not run yet?
	beq .frame		; $8FF077: F0 F1
	jsl.l ReadPads		; $8FF079: 22 E8 F3 80
	lda.b vcount		; $8FF07D: A5 00
	sta.w lastframevc		; $8FF07F: 8D DB 08
	sta.w oldvcount		; $8FF082: 8D 27 04
	jsl.l ClearSprites		; $8FF085: 22 4C E0 8F
	jsl.l ScoutPlayersRun		; $8FF089: 22 66 EA 84
	jsl.l Readjoy1		; $8FF08D: 22 0B C4 80
	jsl.l ProcessInputWithRepeat		; $8FF091: 22 53 FC 86
	lda.b d1		; $8FF095: A5 57
	bne .input		; $8FF097: D0 69
	jsl.l Readjoy2		; $8FF099: 22 29 C4 80
	jsl.l ProcessInputWithRepeat		; $8FF09D: 22 53 FC 86
	lda.b d1		; $8FF0A1: A5 57
	bne .input		; $8FF0A3: D0 5D
	jsl.l QueueTextDMA		; $8FF0A5: 22 F7 8E 8F
	lda.b DMAListend		; $8FF0A9: A5 A3
	bne .l12		; $8FF0AB: D0 04
	jsl.l QueueBackmapDMA		; $8FF0AD: 22 28 8F 8F
.l12:
	lda.w #VBlank_SprPal		; $8FF0B1: A9 C5 81
	sta.b vbint		; $8FF0B4: 85 14
	dec.b d6		; $8FF0B6: C6 6B
	bpl .frame		; $8FF0B8: 10 B0
	lda.w #$001A		; $8FF0BA: A9 1A 00  demo: random teams, both computer
	jsl.l randoma		; $8FF0BD: 22 8B AE 80
	sta.w OptTeam1		; $8FF0C1: 8D 04 16
	sta.w HomeTeam		; $8FF0C4: 8D 9A 12
.l13:
	lda.w #$001A		; $8FF0C7: A9 1A 00
	jsl.l randoma		; $8FF0CA: 22 8B AE 80
	cmp.w OptTeam1		; $8FF0CE: CD 04 16
	beq .l13		; $8FF0D1: F0 F4
	sta.w OptTeam2		; $8FF0D3: 8D 06 16
	sta.w VisTeam		; $8FF0D6: 8D 9C 12
	stz.w notdemo		; $8FF0D9: 9C 0E 16
	stz.w OptPlayMode		; $8FF0DC: 9C 00 16
	stz.w OptPlayers		; $8FF0DF: 9C 02 16
.start:		;Start, or the demo: pojoy from OptPlayers, the password in Cont. Playoffs, then maketree
	lda.w OptPlayers		; $8FF0E2: AD 02 16
	sec		; $8FF0E5: 38
	sbc.w #$0005		; $8FF0E6: E9 05 00
	sta.w pojoy		; $8FF0E9: 8D 4F 04
	lda.w OptPlayMode		; $8FF0EC: AD 00 16
	cmp.w #$0001		; $8FF0EF: C9 01 00
	bne .l14		; $8FF0F2: D0 04
	jsl.l GetPassWord		; $8FF0F4: 22 9C EF 88
.l14:
	lda.w #$0080		; $8FF0F8: A9 80 00
	tsb.w PassWord		; $8FF0FB: 0C 10 16
	jml.l maketree		; $8FF0FE: 5C 00 80 8D
.input:		;a pad pressed (d1): Start, Up/Down (.nms by 2), Left/Right (.IncItem by 1)
	lda.b d1		; $8FF102: A5 57
	bit.w #$1000		; $8FF104: 89 00 10
	bne .start		; $8FF107: D0 D9
	bit.w #$0400		; $8FF109: 89 00 04
	beq .l15		; $8FF10C: F0 10
	lda.w #$0002		; $8FF10E: A9 02 00
	sta.b d0		; $8FF111: 85 53
	jsl.l .nms		; $8FF113: 22 C5 F2 8F
	jsl.l .ps		; $8FF117: 22 EA F1 8F
	jmp.w .idle		; $8FF11B: 4C 65 F0
.l15:
	bit.w #$0800		; $8FF11E: 89 00 08
	beq .l17		; $8FF121: F0 10
	lda.w #$FFFE		; $8FF123: A9 FE FF
	sta.b d0		; $8FF126: 85 53
	jsl.l .nms		; $8FF128: 22 C5 F2 8F
	jsl.l .ps		; $8FF12C: 22 EA F1 8F
.l16:
	jmp.w .idle		; $8FF130: 4C 65 F0
.l17:
	lda.w #$0001		; $8FF133: A9 01 00
	sta.b d2		; $8FF136: 85 5B
	lda.b d1		; $8FF138: A5 57
	bit.w #$0100		; $8FF13A: 89 00 01
	bne .l18		; $8FF13D: D0 0A
	bit.w #$0200		; $8FF13F: 89 00 02
	beq .l16		; $8FF142: F0 EC
	lda.w #$FFFF		; $8FF144: A9 FF FF
	sta.b d2		; $8FF147: 85 5B
.l18:
	jsl.l .IncItem		; $8FF149: 22 54 F1 8F
	jsl.l .ps		; $8FF14D: 22 EA F1 8F
	jmp.w .idle		; $8FF151: 4C 65 F0
.IncItem:		;93G .IncItem: add d2 to option d7 (OptPlayMode + d7) within .pslim (d2 = 0: just limit it). Players is fixed to One outside Regular Season; Team 1 has $18 choices in the playoffs; a new
		;   mode or Team 1 in the playoffs restarts them (NewPO)
	lda.w #OptPlayMode		; $8FF154: A9 00 16
	sta.b a2		; $8FF157: 85 3B
	lda.w #$0000		; $8FF159: A9 00 00
	sta.b a2+2		; $8FF15C: 85 3D
	lda.w #.pslim		; $8FF15E: A9 67 F3
	sta.b a3		; $8FF161: 85 3F
	lda.w #.pslim>>16		; $8FF163: A9 8F 00
	sta.b a3+2		; $8FF166: 85 41
	stz.b d5		; $8FF168: 64 67
	ldy.b d7		; $8FF16A: A4 6F
	lda.b [a3],y		; $8FF16C: B7 3F
	sta.b d4		; $8FF16E: 85 63
	lda.b [a2],y		; $8FF170: B7 3B
	sta.b d3		; $8FF172: 85 5F
	lda.w OptPlayMode		; $8FF174: AD 00 16
	cmp.w #$0002		; $8FF177: C9 02 00
	bcc .l19		; $8FF17A: 90 0A
	cpy.w #$0004		; $8FF17C: C0 04 00
	bne .l19		; $8FF17F: D0 05
	lda.w #$0018		; $8FF181: A9 18 00
	sta.b d4		; $8FF184: 85 63
.l19:
	cpy.w #$0002		; $8FF186: C0 02 00
	bne .l20		; $8FF189: D0 11
	lda.w #$0005		; $8FF18B: A9 05 00
	sta.b d5		; $8FF18E: 85 67
	lda.w OptPlayMode		; $8FF190: AD 00 16
	bne .l20		; $8FF193: D0 07
	stz.b d5		; $8FF195: 64 67
	lda.w #$0005		; $8FF197: A9 05 00
	sta.b d4		; $8FF19A: 85 63
.l20:
	jsl.l .iilimit		; $8FF19C: 22 C1 F1 8F  d3 = the new value
	lda.b d3		; $8FF1A0: A5 5F
	sta.b [a2],y		; $8FF1A2: 97 3B
	lda.b d2		; $8FF1A4: A5 5B
	beq .rts		; $8FF1A6: F0 18
	lda.w OptPlayMode		; $8FF1A8: AD 00 16
	cmp.w #$0002		; $8FF1AB: C9 02 00
	bcc .rts		; $8FF1AE: 90 10
	tya		; $8FF1B0: 98
	bne .l21		; $8FF1B1: D0 04
	jml.l NewPO		; $8FF1B3: 5C 00 80 8B
.l21:
	cpy.w #$0004		; $8FF1B7: C0 04 00
	bne .rts		; $8FF1BA: D0 04
	jml.l NewPO		; $8FF1BC: 5C 00 80 8B
.rts:
	rtl		; $8FF1C0: 6B
.iilimit:		;93G .iilimit: d3 + d2, wrapped into d5 ... d4-1
	lda.b d3		; $8FF1C1: A5 5F
	clc		; $8FF1C3: 18
	adc.b d2		; $8FF1C4: 65 5B
	sta.b d3		; $8FF1C6: 85 5F
	sec		; $8FF1C8: 38
	sbc.b d5		; $8FF1C9: E5 67
	bmi .l22		; $8FF1CB: 30 04
	bvs .l23		; $8FF1CD: 70 04
	bra .l24		; $8FF1CF: 80 07
.l22:
	bvs .l24		; $8FF1D1: 70 05
.l23:
	lda.b d4		; $8FF1D3: A5 63
	dec a		; $8FF1D5: 3A
	sta.b d3		; $8FF1D6: 85 5F
.l24:
	lda.b d3		; $8FF1D8: A5 5F
	sec		; $8FF1DA: 38
	sbc.b d4		; $8FF1DB: E5 63
	bmi .l25		; $8FF1DD: 30 04
	bvc .l26		; $8FF1DF: 50 04
	bra .rts		; $8FF1E1: 80 DD
.l25:
	bvc .rts		; $8FF1E3: 50 DB
.l26:
	lda.b d5		; $8FF1E5: A5 67
	sta.b d3		; $8FF1E7: 85 5F
	rtl		; $8FF1E9: 6B
.ps:		;93G .ps: print the choices of all 7 lines (.psd), then PrintTeamNames
	lda.b d7		; $8FF1EA: A5 6F
	sta.b d6		; $8FF1EC: 85 6B
	lda.w #$FFFE		; $8FF1EE: A9 FE FF
	sta.b d7		; $8FF1F1: 85 6F
.psloop:
	inc.b d7		; $8FF1F3: E6 6F
	inc.b d7		; $8FF1F5: E6 6F
	stz.b d2		; $8FF1F7: 64 5B
	jsl.l .IncItem		; $8FF1F9: 22 54 F1 8F
	jsl.l .psd		; $8FF1FD: 22 10 F2 8F
	lda.b d7		; $8FF201: A5 6F
	cmp.w #$000C		; $8FF203: C9 0C 00
	bne .psloop		; $8FF206: D0 EB
	lda.b d6		; $8FF208: A5 6B
	sta.b d7		; $8FF20A: 85 6F
	jml.l PrintTeamNames		; $8FF20C: 5C 1E FF 85
.psd:		;93G .psd: print the choice of line d7 at x $11 (14 chars erased first): string d3 of its .pl list; the team lines print the team name (.psdtp)
	jsl.l printz		; $8FF210: 22 0C B9 80
	dw $0005		; $8FF214  printz inline string: length (counts itself), then control bytes / text
	db $BE,$11,$0D
	lda.w printy		; $8FF219: AD 7D 04
	clc		; $8FF21C: 18
	adc.b d7		; $8FF21D: 65 6F
	sta.w printy		; $8FF21F: 8D 7D 04
	lda.w #$000E		; $8FF222: A9 0E 00
	sta.b d0		; $8FF225: 85 53
	lda.w #$0001		; $8FF227: A9 01 00
	sta.b d1		; $8FF22A: 85 57
	lda.w blankchar		; $8FF22C: AD E7 1B
	sta.b d2		; $8FF22F: 85 5B
	jsl.l eraser		; $8FF231: 22 7C 84 8D
	dec.w printy		; $8FF235: CE 7D 04
	lda.w #$0011		; $8FF238: A9 11 00
	sta.w printx		; $8FF23B: 8D 7B 04
	ldy.b d7		; $8FF23E: A4 6F
	cpy.w #$0004		; $8FF240: C0 04 00
	beq .psdtp		; $8FF243: F0 37
	cpy.w #$0006		; $8FF245: C0 06 00
	beq .psdtp		; $8FF248: F0 32
	lda.w #OptPlayMode		; $8FF24A: A9 00 16
	sta.b a0		; $8FF24D: 85 33
	lda.w #$0000		; $8FF24F: A9 00 00
	sta.b a0+2		; $8FF252: 85 35
	lda.b [a0],y		; $8FF254: B7 33
	sta.b d3		; $8FF256: 85 5F
	lda.w #.pl>>16		; $8FF258: A9 8F 00
	sta.b a0+2		; $8FF25B: 85 35
	lda.w #.pl		; $8FF25D: A9 75 F3
	sta.b a0		; $8FF260: 85 33
	clc		; $8FF262: 18
	adc.b [a0],y		; $8FF263: 77 33
	sta.b a0		; $8FF265: 85 33
.psd3:		;93G .psd3: step to string d3
	lda.b a0+2		; $8FF267: A5 35
	sta.b a1+2		; $8FF269: 85 39
	lda.b a0		; $8FF26B: A5 33
	sta.b a1		; $8FF26D: 85 37
	clc		; $8FF26F: 18
	adc.b [a0]		; $8FF270: 67 33
	sta.b a0		; $8FF272: 85 33
	dec.b d3		; $8FF274: C6 5F
	bpl .psd3		; $8FF276: 10 EF
	jml.l print		; $8FF278: 5C 2D B9 80
.psdtp:		;93G .psdtp: team line: the name of team d3 from its bank $83 team record, or .playoffs in Cont. Playoffs
	ldy.b d7		; $8FF27C: A4 6F
	lda.w #OptPlayMode		; $8FF27E: A9 00 16
	sta.b a1		; $8FF281: 85 37
	lda.w #$0000		; $8FF283: A9 00 00
	sta.b a1+2		; $8FF286: 85 39
	lda.b [a1],y		; $8FF288: B7 37
	sta.b d3		; $8FF28A: 85 5F
	asl a		; $8FF28C: 0A
	asl a		; $8FF28D: 0A
	tay		; $8FF28E: A8
	lda.w #TeamList		; $8FF28F: A9 00 80
	sta.b a1		; $8FF292: 85 37
	lda.w #TeamList>>16		; $8FF294: A9 83 00
	sta.b a1+2		; $8FF297: 85 39
	lda.b [a1],y		; $8FF299: B7 37
	sta.b a1		; $8FF29B: 85 37
	ldy.w #$0004		; $8FF29D: A0 04 00
	clc		; $8FF2A0: 18
	adc.b [a1],y		; $8FF2A1: 77 37
	sta.b a1		; $8FF2A3: 85 37
	lda.w OptPlayMode		; $8FF2A5: AD 00 16
	cmp.w #$0001		; $8FF2A8: C9 01 00
	bne .l27		; $8FF2AB: D0 0A
	lda.w #.playoffs		; $8FF2AD: A9 BB F2
	sta.b a1		; $8FF2B0: 85 37
	lda.w #.playoffs>>16		; $8FF2B2: A9 8F 00
	sta.b a1+2		; $8FF2B5: 85 39
.l27:
	jml.l print		; $8FF2B7: 5C 2D B9 80
.playoffs:		;the Team 1 / Team 2 choice in Cont. Playoffs
	dw 10		; $8FF2BB
	db "Playoffs"
.nms:		;93G .nms: move to line d7 + d0 (0..$C), skipping the lines fixed in this mode (Players in the playoffs, lines 1-3 in Cont. Playoffs, Team 2 in the playoffs), then move the frame from line d3
		;   to d7
	lda.b d7		; $8FF2C5: A5 6F
	sta.b d3		; $8FF2C7: 85 5F
.nms0:
	lda.b d7		; $8FF2C9: A5 6F
	clc		; $8FF2CB: 18
	adc.b d0		; $8FF2CC: 65 53
	sta.b d7		; $8FF2CE: 85 6F
	bpl .nms1		; $8FF2D0: 10 02
	stz.b d7		; $8FF2D2: 64 6F
.nms1:
	lda.b d7		; $8FF2D4: A5 6F
	cmp.w #$000E		; $8FF2D6: C9 0E 00
	bcc .nms2		; $8FF2D9: 90 06
	lda.b d7		; $8FF2DB: A5 6F
	sbc.b d0		; $8FF2DD: E5 53
	sta.b d7		; $8FF2DF: 85 6F
.nms2:
	lda.w OptPlayMode		; $8FF2E1: AD 00 16
	cmp.w #$0002		; $8FF2E4: C9 02 00
	bcc .l28		; $8FF2E7: 90 0C
	cmp.w #$0004		; $8FF2E9: C9 04 00
	bcs .l28		; $8FF2EC: B0 07
	lda.b d7		; $8FF2EE: A5 6F
	cmp.w #$0002		; $8FF2F0: C9 02 00
	beq .nms0		; $8FF2F3: F0 D4
.l28:
	lda.w OptPlayMode		; $8FF2F5: AD 00 16
	cmp.w #$0001		; $8FF2F8: C9 01 00
	bne .l29		; $8FF2FB: D0 09
	lda.b d7		; $8FF2FD: A5 6F
	beq .l29		; $8FF2FF: F0 05
	cmp.w #$0007		; $8FF301: C9 07 00
	bcc .nms0		; $8FF304: 90 C3
.l29:
	lda.w OptPlayMode		; $8FF306: AD 00 16
	cmp.w #$0002		; $8FF309: C9 02 00
	bcc .nms4		; $8FF30C: 90 07
	lda.b d7		; $8FF30E: A5 6F
	cmp.w #$0006		; $8FF310: C9 06 00
	beq .nms0		; $8FF313: F0 B4
.nms4:		;93G .nms4: erase the old frame, draw the new one
	jsl.l .setrect		; $8FF315: 22 2E F3 8F
	lda.w blankchar		; $8FF319: AD E7 1B
	sta.b d2		; $8FF31C: 85 5B
	jsl.l eraser		; $8FF31E: 22 7C 84 8D
	lda.b d7		; $8FF322: A5 6F
	sta.b d3		; $8FF324: 85 5F
	jsl.l .setrect		; $8FF326: 22 2E F3 8F
	jml.l Framer		; $8FF32A: 5C 9F D6 8F
.setrect:		;93G .setrect: printx $10, printy $C + d3, frame size d0 x d1 = $10 x 3 (5 tall for Team 1 in the new playoffs)
	jsl.l printz		; $8FF32E: 22 0C B9 80
	dw $0005		; $8FF332  printz inline string: length (counts itself), then control bytes / text
	db $FF,$10,$0C
	lda.w printy		; $8FF337: AD 7D 04
	clc		; $8FF33A: 18
	adc.b d3		; $8FF33B: 65 5F
	sta.w printy		; $8FF33D: 8D 7D 04
	lda.w #$0010		; $8FF340: A9 10 00
	sta.b d0		; $8FF343: 85 53
	lda.w #$0003		; $8FF345: A9 03 00
	sta.b d1		; $8FF348: 85 57
	lda.w OptPlayMode		; $8FF34A: AD 00 16
	cmp.w #$0002		; $8FF34D: C9 02 00
	bcs .l30		; $8FF350: B0 03
	jmp.w .rts		; $8FF352: 4C C0 F1
.l30:
	lda.b d3		; $8FF355: A5 5F
	cmp.w #$0004		; $8FF357: C9 04 00
	beq .l31		; $8FF35A: F0 03
	jmp.w .rts		; $8FF35C: 4C C0 F1
.l31:
	lda.w #$0005		; $8FF35F: A9 05 00
	sta.b d1		; $8FF362: 85 57
	rtl		; $8FF364: 6B
	dw 0		; $8FF365
.pslim:		;93G .pslim: choices of each line (Play Mode, Players, Team 1, Team 2, Per. Length, Penalties, Line Changes)
	dw $4,$6,$1A,$1A,$3,$3,$2		; $8FF367
.pl:		;93G .pl: offsets from .pl of the choice strings of each line
	dw .pl0-.pl		; $8FF375
	dw .pl1-.pl		; $8FF377
	dw .pl2-.pl		; $8FF379
	dw .pl3-.pl		; $8FF37B
	dw .pl4-.pl		; $8FF37D
	dw .pl5-.pl		; $8FF37F
	dw .pl6-.pl		; $8FF381
.pl0:		;Play Mode
	dw 16		; $8FF383
	db "Regular Season"
	dw 16		; $8FF393
	db "Cont. Playoffs"
	dw 14		; $8FF3A3
	db "New Playoffs"
	dw 11		; $8FF3B1
	db "Best of 7"
.pl1:		;Players (the last, One, is the only choice in the playoffs)
	dw 6		; $8FF3BC
	db "Demo"
	dw 12		; $8FF3C2
	db "One - Home"
	dw 15		; $8FF3CE
	db "One - Visitor"
	dw 11		; $8FF3DD
	db "Teammates"
	dw 14		; $8FF3E8
	db "Head to Head"
	dw 5		; $8FF3F6
	db "One"
.pl2:		;Team 1 and Team 2 (not used: .psdtp prints team names), Per. Length (30 Seconds is beyond .pslim)
.pl3:
.pl4:
	dw 11		; $8FF3FB
	db "5 Minutes"
	dw 12		; $8FF406
	db "10 Minutes"
	dw 12		; $8FF412
	db "20 Minutes"
	dw 12		; $8FF41E
	db "30 Seconds"
.pl5:		;Penalties
	dw 15		; $8FF42A
	db "Only Fighting"
	dw 4		; $8FF439
	db "On"
	dw 16		; $8FF43D
	db "On, No Offside"
.pl6:		;Line Changes
	dw 4		; $8FF44D
	db "On"
	dw 5		; $8FF451
	db "Off"
.text:		;93G .text: the line names
	dw 14		; $8FF456
	db $FE,$03,$0D,"Play Mode"
	dw 12		; $8FF464
	db $FE,$03,$0F,"Players"
	dw 11		; $8FF470
	db $FE,$03,$11,"Team 1"
	dw 11		; $8FF47B
	db $FE,$03,$13,"Team 2"
	dw 16		; $8FF486
	db $FE,$03,$15,"Per. Length"
	dw 14		; $8FF496
	db $FE,$03,$17,"Penalties"
	dw 17		; $8FF4A4
	db $FE,$03,$19,"Line Changes"
	dw 3		; $8FF4B5 end (a 0 byte)
	db 0
PixelRemapFramer:		;SNES: RemapTiles table for the Framer tiles (setoptions)
	db $00,$01,$0A,$03,$04,$05,$06,$02,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F		; $8FF4B8
PixelRemapFont:		;SNES: RemapTiles table for the small font (setoptions)
	db $00,$0F,$00,$00,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F		; $8FF4C8
UnpackNibbles:		;auto: CODE_8FF4D8 (from bank $86). 93G UnpackNibbles (logic93_5): d0 nibbles at [a0], high nibble first, to words at nibblebuffer; saves d0-d2, a0-a1
	stx.b xsave		; $8FF4D8: 86 0A
	ldx.w #$0000		; $8FF4DA: A2 00 00
.l1:
	lda.b d0,x		; $8FF4DD: B5 53
	pha		; $8FF4DF: 48
	inx		; $8FF4E0: E8
	inx		; $8FF4E1: E8
	cpx.w #$000C		; $8FF4E2: E0 0C 00
	bne .l1		; $8FF4E5: D0 F6
	ldx.b xsave		; $8FF4E7: A6 0A
	stx.b xsave		; $8FF4E9: 86 0A
	ldx.w #$0000		; $8FF4EB: A2 00 00
.l2:
	lda.b a0,x		; $8FF4EE: B5 33
	pha		; $8FF4F0: 48
	inx		; $8FF4F1: E8
	inx		; $8FF4F2: E8
	cpx.w #$0008		; $8FF4F3: E0 08 00
	bne .l2		; $8FF4F6: D0 F6
	ldx.b xsave		; $8FF4F8: A6 0A
	lda.w #nibblebuffer		; $8FF4FA: A9 1F 04
	sta.b a1		; $8FF4FD: 85 37
	lda.w #$0000		; $8FF4FF: A9 00 00
	sta.b a1+2		; $8FF502: 85 39
	stz.b d2		; $8FF504: 64 5B
	bra .l5		; $8FF506: 80 25
.l3:
	lda.b [a0]		; $8FF508: A7 33
	inc.b a0		; $8FF50A: E6 33
	and.w #$00FF		; $8FF50C: 29 FF 00
	sta.b d1		; $8FF50F: 85 57
	inc.b d2		; $8FF511: E6 5B
	lda.b d2		; $8FF513: A5 5B
	lsr a		; $8FF515: 4A
	bcc .l4		; $8FF516: 90 0A
	dec.b a0		; $8FF518: C6 33
	lda.b d1		; $8FF51A: A5 57
	lsr a		; $8FF51C: 4A
	lsr a		; $8FF51D: 4A
	lsr a		; $8FF51E: 4A
	lsr a		; $8FF51F: 4A
	sta.b d1		; $8FF520: 85 57
.l4:
	lda.b d1		; $8FF522: A5 57
	and.w #$000F		; $8FF524: 29 0F 00
	sta.b [a1]		; $8FF527: 87 37
	inc.b a1		; $8FF529: E6 37
	inc.b a1		; $8FF52B: E6 37
.l5:
	dec.b d0		; $8FF52D: C6 53
	bpl .l3		; $8FF52F: 10 D7
	stx.b xsave		; $8FF531: 86 0A
	ldx.w #$0006		; $8FF533: A2 06 00
.l6:
	pla		; $8FF536: 68
	sta.b a0,x		; $8FF537: 95 33
	dex		; $8FF539: CA
	dex		; $8FF53A: CA
	bpl .l6		; $8FF53B: 10 F9
	ldx.b xsave		; $8FF53D: A6 0A
	stx.b xsave		; $8FF53F: 86 0A
	ldx.w #$000A		; $8FF541: A2 0A 00
.l7:
	pla		; $8FF544: 68
	sta.b d0,x		; $8FF545: 95 53
	dex		; $8FF547: CA
	dex		; $8FF548: CA
	bpl .l7		; $8FF549: 10 F9
	ldx.b xsave		; $8FF54B: A6 0A
	rtl		; $8FF54D: 6B
PushNumberWidth:		;auto: CODE_8FF54E. 93G PushNumberWidth (middle93_2): a1 = PushWidthBuf: d0 as a d1 digit decimal string, right aligned with leading spaces (the last digit always shown)
	lda.w #PushWidthBuf		; $8FF54E: A9 F5 01
	sta.b a1		; $8FF551: 85 37
	lda.w #$0000		; $8FF553: A9 00 00
	sta.b a1+2		; $8FF556: 85 39
	lda.b d1		; $8FF558: A5 57
	inc a		; $8FF55A: 1A
	inc a		; $8FF55B: 1A
	sta.w PushWidthBuf		; $8FF55C: 8D F5 01
	tay		; $8FF55F: A8
	lda.w #$2020		; $8FF560: A9 20 20
	sta.w PushWidthBuf+2		; $8FF563: 8D F7 01
	sta.w PushWidthBuf+4		; $8FF566: 8D F9 01
	sta.w PushWidthBuf+6		; $8FF569: 8D FB 01
	sta.w PushWidthBuf+8		; $8FF56C: 8D FD 01
	lda.b d0		; $8FF56F: A5 53
.l1:
	sta.b mulb		; $8FF571: 85 83
	lda.w #$000A		; $8FF573: A9 0A 00
	sta.b mula		; $8FF576: 85 7D
	dey		; $8FF578: 88
	jsl.l divu16		; $8FF579: 22 D8 B8 80
	lda.b mulres+2		; $8FF57D: A5 95
	sep #$20		; $8FF57F: E2 20
	adc.b #$30		; $8FF581: 69 30
	sta.w PushWidthBuf,y		; $8FF583: 99 F5 01
	rep #$20		; $8FF586: C2 20
	lda.b mulres		; $8FF588: A5 93
	bne .l1		; $8FF58A: D0 E5
	rtl		; $8FF58C: 6B
StatsReport:		;auto: CODE_8FF58D (from the pause code in bank $83, $8F850B). 92G StatsReport role: clear the text screen, send 28 rows of HorRinkMap (32 columns each) to vram $0418 and, 8 columns
		;   in, to $0800, then USBoard
	jsl.l printz		; $8FF58D: 22 0C B9 80
	dw $0005		; $8FF591  printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0020		; $8FF596: A9 20 00
	sta.b d0		; $8FF599: 85 53
	lda.w #$001D		; $8FF59B: A9 1D 00
	sta.b d1		; $8FF59E: 85 57
	lda.w blankchar		; $8FF5A0: AD E7 1B
	sta.b d2		; $8FF5A3: 85 5B
	jsl.l eraser		; $8FF5A5: 22 7C 84 8D
	jsl.l printz		; $8FF5A9: 22 0C B9 80
	dw $0005		; $8FF5AD  printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0418		; $8FF5B2: A9 18 04
	sta.w VMADDL		; $8FF5B5: 8D 16 21
	lda.w #$001C		; $8FF5B8: A9 1C 00
	sta.b tmp0		; $8FF5BB: 85 73
	ldx.w #$0000		; $8FF5BD: A2 00 00
.l1:
	ldy.w #$0020		; $8FF5C0: A0 20 00
.l2:
	lda.l HorRinkMap,x		; $8FF5C3: BF AB EC 83
	sta.w VMDATAL		; $8FF5C7: 8D 18 21
	inx		; $8FF5CA: E8
	inx		; $8FF5CB: E8
	dey		; $8FF5CC: 88
	bne .l2		; $8FF5CD: D0 F4
	txa		; $8FF5CF: 8A
	clc		; $8FF5D0: 18
	adc.w #$0020		; $8FF5D1: 69 20 00
	tax		; $8FF5D4: AA
	dec.b tmp0		; $8FF5D5: C6 73
	bne .l1		; $8FF5D7: D0 E7
	lda.w #$0800		; $8FF5D9: A9 00 08
	sta.w VMADDL		; $8FF5DC: 8D 16 21
	lda.w #$001C		; $8FF5DF: A9 1C 00
	sta.b tmp0		; $8FF5E2: 85 73
	ldx.w #$0000		; $8FF5E4: A2 00 00
.l3:
	ldy.w #$0020		; $8FF5E7: A0 20 00
.l4:
	lda.l HorRinkMap+$10,x		; $8FF5EA: BF BB EC 83
	sta.w VMDATAL		; $8FF5EE: 8D 18 21
	inx		; $8FF5F1: E8
	inx		; $8FF5F2: E8
	dey		; $8FF5F3: 88
	bne .l4		; $8FF5F4: D0 F4
	txa		; $8FF5F6: 8A
	clc		; $8FF5F7: 18
	adc.w #$0020		; $8FF5F8: 69 20 00
	tax		; $8FF5FB: AA
	dec.b tmp0		; $8FF5FC: C6 73
	bne .l3		; $8FF5FE: D0 E7
	jmp.w USBoard		; $8FF600: 4C 2E 85
Findhittype:		;auto: CODE_8FF603 (from dopass). 93G Findhittype (logic93_1): swing type of player X for launch direction d0: A = 0 forehand (Z set), 1 backhand; .xflip when attribute bit $800 (x
		;   flip)
	lda.b d0		; $8FF603: A5 53
	eor.w #$FFFF		; $8FF605: 49 FF FF
	inc a		; $8FF608: 1A
	clc		; $8FF609: 18
	adc.w facedir,x		; $8FF60A: 7D BF 0D
	and.w #$0007		; $8FF60D: 29 07 00
	sta.b d0		; $8FF610: 85 53
	lda.w attribute,x		; $8FF612: BD DF 09
	bit.w #$0800		; $8FF615: 89 00 08
	beq .l1		; $8FF618: F0 0C
	phx		; $8FF61A: DA
	ldx.b d0		; $8FF61B: A6 53
	lda.l .xflip,x		; $8FF61D: BF 32 F6 8F  x flip: backhand for d0 4-7
	plx		; $8FF621: FA
	and.w #$00FF		; $8FF622: 29 FF 00
	rtl		; $8FF625: 6B
.l1:
	phx		; $8FF626: DA
	ldx.b d0		; $8FF627: A6 53
	lda.l .noflip,x		; $8FF629: BF 35 F6 8F  backhand for d0 1-4
	plx		; $8FF62D: FA
	and.w #$00FF		; $8FF62E: 29 FF 00
	rtl		; $8FF631: 6B
.xflip:		;x flip: 1 = backhand for d0 4-7 (93G %11110000); its last 5 bytes start .noflip
	db $00,$00,$00		; $8FF632
.noflip:		;1 = backhand for d0 1-4 (93G %00011110)
	db $00,$01,$01,$01,$01,$00,$00,$00		; $8FF635
prefmes:		;auto: CODE_8FF63D. 93G prefmes (penalty93_1): print the message of penalty d0 (negative clears it). Vertical: framed under the ref at y $A, centred by its length; horizontal (sfhormode):
		;   PrintPenaltyMessagesString, one centred line at x $11, y $B. Saves d0-d2, a1
	stx.b xsave		; $8FF63D: 86 0A
	ldx.w #$0000		; $8FF63F: A2 00 00
.l1:
	lda.b d0,x		; $8FF642: B5 53
	pha		; $8FF644: 48
	inx		; $8FF645: E8
	inx		; $8FF646: E8
	cpx.w #$000C		; $8FF647: E0 0C 00
	bne .l1		; $8FF64A: D0 F6
	ldx.b xsave		; $8FF64C: A6 0A
	stx.b xsave		; $8FF64E: 86 0A
	ldx.w #$0000		; $8FF650: A2 00 00
.l2:
	lda.b a1,x		; $8FF653: B5 37
	pha		; $8FF655: 48
	inx		; $8FF656: E8
	inx		; $8FF657: E8
	cpx.w #$0004		; $8FF658: E0 04 00
	bne .l2		; $8FF65B: D0 F6
	ldx.b xsave		; $8FF65D: A6 0A
	lda.w sfhormode		; $8FF65F: AD 8E 12
	beq .l3		; $8FF662: F0 03
	jmp.w .l8		; $8FF664: 4C EC F6
.l3:
	lda.b d0		; $8FF667: A5 53
	bpl .l4		; $8FF669: 10 1F
	jsl.l printz		; $8FF66B: 22 0C B9 80
	dw $0005		; $8FF66F  printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0A
	lda.w #$000D		; $8FF674: A9 0D 00
	sta.b d0		; $8FF677: 85 53
	lda.w #$0003		; $8FF679: A9 03 00
	sta.b d1		; $8FF67C: 85 57
	lda.w blankchar		; $8FF67E: AD E7 1B
	sta.b d2		; $8FF681: 85 5B
	jsl.l eraser		; $8FF683: 22 7C 84 8D
	jmp.w .l10		; $8FF687: 4C 24 F7
.l4:
	jsl.l printz		; $8FF68A: 22 0C B9 80
	dw $0005		; $8FF68E  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0A
	ldy.b d0		; $8FF693: A4 53
	lda.w #PenaltyList		; $8FF695: A9 6A BF
	sta.b a1		; $8FF698: 85 37
	lda.w #PenaltyList>>16		; $8FF69A: A9 80 00
.l5:
	sta.b a1+2		; $8FF69D: 85 39
	lda.b [a1],y		; $8FF69F: B7 37
	clc		; $8FF6A1: 18
	adc.b a1		; $8FF6A2: 65 37
	inc a		; $8FF6A4: 1A
	inc a		; $8FF6A5: 1A
	sta.b a1		; $8FF6A6: 85 37
	lda.b [a1]		; $8FF6A8: A7 37
	dec a		; $8FF6AA: 3A
	dec a		; $8FF6AB: 3A
	sta.b d0		; $8FF6AC: 85 53
	beq .l10		; $8FF6AE: F0 74
	inc a		; $8FF6B0: 1A
	lsr a		; $8FF6B1: 4A
	sta.b d0		; $8FF6B2: 85 53
	lda.w printx		; $8FF6B4: AD 7B 04
	sec		; $8FF6B7: 38
	sbc.b d0		; $8FF6B8: E5 53
	sta.w printx		; $8FF6BA: 8D 7B 04
	bpl .l6		; $8FF6BD: 10 03
	stz.w printx		; $8FF6BF: 9C 7B 04
.l6:
	lda.b [a1]		; $8FF6C2: A7 37
	sta.b d0		; $8FF6C4: 85 53
	tay		; $8FF6C6: A8
	dec.b a1		; $8FF6C7: C6 37
	lda.b [a1],y		; $8FF6C9: B7 37
	inc.b a1		; $8FF6CB: E6 37
	and.w #$00FF		; $8FF6CD: 29 FF 00
	bne .l7		; $8FF6D0: D0 02
	dec.b d0		; $8FF6D2: C6 53
.l7:
	lda.w #$0003		; $8FF6D4: A9 03 00
	sta.b d1		; $8FF6D7: 85 57
	jsl.l Framer		; $8FF6D9: 22 9F D6 8F
	dec.w printy		; $8FF6DD: CE 7D 04
	dec.w printy		; $8FF6E0: CE 7D 04
	inc.w printx		; $8FF6E3: EE 7B 04
	jsl.l print		; $8FF6E6: 22 2D B9 80
	bra .l10		; $8FF6EA: 80 38
.l8:
	jsl.l PrintPenaltyMessagesString		; $8FF6EC: 22 95 FD 82
	lda.b d0		; $8FF6F0: A5 53
	bmi .l10		; $8FF6F2: 30 30
	jsl.l printz		; $8FF6F4: 22 0C B9 80
	dw $0005		; $8FF6F8  printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	lda.w #PenaltyList		; $8FF6FD: A9 6A BF
	sta.b a1		; $8FF700: 85 37
	lda.w #PenaltyList>>16		; $8FF702: A9 80 00
.l9:
	sta.b a1+2		; $8FF705: 85 39
	ldy.b d0		; $8FF707: A4 53
	lda.b [a1],y		; $8FF709: B7 37
	clc		; $8FF70B: 18
	adc.b a1		; $8FF70C: 65 37
	inc a		; $8FF70E: 1A
	inc a		; $8FF70F: 1A
	sta.b a1		; $8FF710: 85 37
	lda.b [a1]		; $8FF712: A7 37
	lsr a		; $8FF714: 4A
	sta.b d0		; $8FF715: 85 53
	lda.w printx		; $8FF717: AD 7B 04
	sec		; $8FF71A: 38
	sbc.b d0		; $8FF71B: E5 53
	sta.w printx		; $8FF71D: 8D 7B 04
	jsl.l print		; $8FF720: 22 2D B9 80
.l10:
	stx.b xsave		; $8FF724: 86 0A
	ldx.w #$0002		; $8FF726: A2 02 00
.l11:
	pla		; $8FF729: 68
	sta.b a1,x		; $8FF72A: 95 37
	dex		; $8FF72C: CA
	dex		; $8FF72D: CA
	bpl .l11		; $8FF72E: 10 F9
	ldx.b xsave		; $8FF730: A6 0A
	stx.b xsave		; $8FF732: 86 0A
	ldx.w #$000A		; $8FF734: A2 0A 00
.l12:
	pla		; $8FF737: 68
	sta.b d0,x		; $8FF738: 95 53
	dex		; $8FF73A: CA
	dex		; $8FF73B: CA
	bpl .l12		; $8FF73C: 10 F9
	ldx.b xsave		; $8FF73E: A6 0A
	rtl		; $8FF740: 6B
CheckInjury:		;auto: CODE_8FF741. 93G CheckInjury (hockey93_01): once a second: count InjCntDown down; at zero ShowInjuryBox
	dec.w InjCntDown		; $8FF741: CE E6 12
	bne .l1		; $8FF744: D0 03
	jmp.w ShowInjuryBox		; $8FF746: 4C 27 F8
.l1:
	rtl		; $8FF749: 6B
setInjuryType:		;auto: CODE_8FF74A. 93G setInjuryType (hockey93_03): player a2 is injured: pflags bit $1000, crowdlevel + $12C, sfx $8C, the scroll locked on him (xc1/yc1, sflags $40), TempPlOffset
		;   = pnum (| $8000 for the visitors), his tmpdst = $FFFD (out for the period)
	ldy.b a2		; $8FF74A: A4 3B
	lda.w pflags,y		; $8FF74C: B9 DF 0E
	ora.w #$1000		; $8FF74F: 09 00 10
	sta.w pflags,y		; $8FF752: 99 DF 0E
	lda.b crowdlevel		; $8FF755: A5 DE
	clc		; $8FF757: 18
	adc.w #$012C		; $8FF758: 69 2C 01
	sta.b crowdlevel		; $8FF75B: 85 DE
	lda.w #$008C		; $8FF75D: A9 8C 00
	pha		; $8FF760: 48
	jsl.l sfx		; $8FF761: 22 8B C2 80
	ldy.b a2		; $8FF765: A4 3B
	lda.w Xpos,y		; $8FF767: B9 FF 08
	sta.w xc1		; $8FF76A: 8D F5 08
	lda.w Ypos,y		; $8FF76D: B9 5F 09
	sta.w yc1		; $8FF770: 8D F7 08
	lda.w #$0040		; $8FF773: A9 40 00
	tsb.w sflags		; $8FF776: 0C 8C 12
	stz.b d1		; $8FF779: 64 57
	stz.b a0		; $8FF77B: 64 33
	lda.w pfteam,y		; $8FF77D: B9 9F 11
	beq .l1		; $8FF780: F0 0A
	lda.w #$8000		; $8FF782: A9 00 80
	sta.b d1		; $8FF785: 85 57
	lda.w #$0002		; $8FF787: A9 02 00
	sta.b a0		; $8FF78A: 85 33
.l1:
	lda.w pnum,y		; $8FF78C: B9 1F 0F
	and.w #$00FF		; $8FF78F: 29 FF 00
	ora.b d1		; $8FF792: 05 57
	sta.w TempPlOffset		; $8FF794: 8D FA 12
	and.w #$00FF		; $8FF797: 29 FF 00
	bit.w #$0080		; $8FF79A: 89 80 00
	beq .l2		; $8FF79D: F0 03
	ora.w #$FF00		; $8FF79F: 09 00 FF
.l2:
	asl a		; $8FF7A2: 0A
	sta.b d1		; $8FF7A3: 85 57
	lda.b a0		; $8FF7A5: A5 33
	beq .l3		; $8FF7A7: F0 03
	lda.w #$0034		; $8FF7A9: A9 34 00
.l3:
	adc.b d1		; $8FF7AC: 65 57
	tay		; $8FF7AE: A8
	lda.w #$FFFD		; $8FF7AF: A9 FD FF
	sta.w tmpdst,y		; $8FF7B2: 99 E2 14
	rtl		; $8FF7B5: 6B
sublist:		;93G sublist (hockey93_11): substitution lists by position: word offsets from sublist, then roster slots (line * 8 + position); -1 ends
	dw .defl-sublist		; $8FF7B6 goalie
	dw .defl-sublist		; $8FF7B8 LD
	dw .defr-sublist		; $8FF7BA RD
	dw .wingl-sublist		; $8FF7BC LW
	dw .center-sublist		; $8FF7BE C
	dw .wingr-sublist		; $8FF7C0 RW
	dw .center-sublist		; $8FF7C2 extra attacker
.defl:	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1		; $8FF7C4
	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2		; $8FF7CB
.defr:	db 0+2,8+2,16+2,24+2,32+2,40+2,48+2		; $8FF7D2
	db 0+1,8+1,16+1,24+1,32+1,40+1,48+1		; $8FF7D9
.wingl:	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3		; $8FF7E0
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5		; $8FF7E7
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4		; $8FF7EE
.wingr:	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5		; $8FF7F5
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3		; $8FF7FC
	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4		; $8FF803
.center:	db 0+4,8+4,16+4,24+4,32+4,40+4,48+4		; $8FF80A
	db 0+3,8+3,16+3,24+3,32+3,40+3,48+3		; $8FF811
	db 0+5,8+5,16+5,24+5,32+5,40+5,48+5		; $8FF818
	db -1		; $8FF81F
priolist:		;93G priolist: positions in order of importance (SetPlList, releasepl, getlinee); no pad byte on the SNES
	db 0,1,2,4,3,5,6		; $8FF820
ShowInjuryBox:		;auto: CODE_8FF827. 93G ShowInjuryBox (hockey93_10): "Injury to:" the player TempPlOffset (GetPlayerNameWithAttrib), "Out for period", or "the game" when pf2fight of the puck is set.
		;   Jumped to by CheckInjury; saves d0-d2, a0-a4, ends with X = a3
	stx.b xsave		; $8FF827: 86 0A
	ldx.w #$0000		; $8FF829: A2 00 00
.l1:
	lda.b d0,x		; $8FF82C: B5 53
	pha		; $8FF82E: 48
	inx		; $8FF82F: E8
	inx		; $8FF830: E8
	cpx.w #$000C		; $8FF831: E0 0C 00
	bne .l1		; $8FF834: D0 F6
	ldx.b xsave		; $8FF836: A6 0A
	stx.b xsave		; $8FF838: 86 0A
	ldx.w #$0000		; $8FF83A: A2 00 00
.l2:
	lda.b a0,x		; $8FF83D: B5 33
	pha		; $8FF83F: 48
	inx		; $8FF840: E8
	inx		; $8FF841: E8
	cpx.w #$0014		; $8FF842: E0 14 00
	bne .l2		; $8FF845: D0 F6
	ldx.b xsave		; $8FF847: A6 0A
	jsl.l printz		; $8FF849: 22 0C B9 80
	dw $0005		; $8FF84D  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$03
	lda.w #$0012		; $8FF852: A9 12 00
	sta.b d0		; $8FF855: 85 53
	lda.w #$0005		; $8FF857: A9 05 00
	sta.b d1		; $8FF85A: 85 57
	jsl.l Framer		; $8FF85C: 22 9F D6 8F
	jsl.l printz		; $8FF860: 22 0C B9 80
	dw $0023		; $8FF864  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$04,"Injury to:",$BF,$0C,$06,"Out for period",$BF,$0C,$05
	jsl.l GetPlayerNameWithAttrib		; $8FF887: 22 2B FB 8F
	jsl.l print		; $8FF88B: 22 2D B9 80
	lda.w pf2fight+puckobj		; $8FF88F: AD 7B 11
	beq .l3		; $8FF892: F0 11
	jsl.l printz		; $8FF894: 22 0C B9 80
	dw $000D		; $8FF898  printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$06,"the game"
.l3:
	stx.b xsave		; $8FF8A5: 86 0A
	ldx.w #$0012		; $8FF8A7: A2 12 00
.l4:
	pla		; $8FF8AA: 68
	sta.b a0,x		; $8FF8AB: 95 33
	dex		; $8FF8AD: CA
	dex		; $8FF8AE: CA
	bpl .l4		; $8FF8AF: 10 F9
	ldx.b xsave		; $8FF8B1: A6 0A
	stx.b xsave		; $8FF8B3: 86 0A
	ldx.w #$000A		; $8FF8B5: A2 0A 00
.l5:
	pla		; $8FF8B8: 68
	sta.b d0,x		; $8FF8B9: 95 53
	dex		; $8FF8BB: CA
	dex		; $8FF8BC: CA
	bpl .l5		; $8FF8BD: 10 F9
	ldx.b xsave		; $8FF8BF: A6 0A
	ldx.b a3		; $8FF8C1: A6 3F
	rtl		; $8FF8C3: 6B
passtoa0:		;auto: CODE_8FF8C4 (from dopass). 93G passtoa0 (logic93_1): pass the puck from player a3 to player a0 (no pass count on the SNES): lead him by his velocity, solve the travel time d2
		;   (sroot, divs16; 1-$18), then puckvz, the puck temp1/nopuck, the target temp3/temp4, puckvx/puckvy
	jsl.l loadTeamStruct		; $8FF8C4: 22 F9 DB 8F
	lda.b a0		; $8FF8C8: A5 33
	lsr a		; $8FF8CA: 4A
	sta.w passReceiverPlayerNum		; $8FF8CB: 8D 3F 04
	lda.w passspeed		; $8FF8CE: AD 3D 04
	lsr a		; $8FF8D1: 4A
	lsr a		; $8FF8D2: 4A
	bit.w #$2000		; $8FF8D3: 89 00 20
	beq .l1		; $8FF8D6: F0 03
	ora.w #$C000		; $8FF8D8: 09 00 C0
.l1:
	sta.b d5		; $8FF8DB: 85 67
	ldx.b a0		; $8FF8DD: A6 33
	ldy.b a3		; $8FF8DF: A4 3F
	stx.b a3		; $8FF8E1: 86 3F
	sty.b a0		; $8FF8E3: 84 33
.l2:
	lda.w #$0013		; $8FF8E5: A9 13 00
	sta.b d0		; $8FF8E8: 85 53
	jsl.l assinsert		; $8FF8EA: 22 9D B4 80
	ldx.b a0		; $8FF8EE: A6 33
	ldy.b a3		; $8FF8F0: A4 3F
	stx.b a3		; $8FF8F2: 86 3F
	sty.b a0		; $8FF8F4: 84 33
	tya		; $8FF8F6: 98
	jsl.l GetHot		; $8FF8F7: 22 0A 9B 80
	ldy.b a0		; $8FF8FB: A4 33
	lda.b d1		; $8FF8FD: A5 57
	clc		; $8FF8FF: 18
	adc.w Ypos,y		; $8FF900: 79 5F 09
	sec		; $8FF903: 38
	sbc.w pucky		; $8FF904: ED 7B 09
	sta.b d1		; $8FF907: 85 57
	pha		; $8FF909: 48
	lsr a		; $8FF90A: 4A
	lsr a		; $8FF90B: 4A
	bit.w #$2000		; $8FF90C: 89 00 20
	beq .l3		; $8FF90F: F0 03
	ora.w #$C000		; $8FF911: 09 00 C0
.l3:
	sta.b d3		; $8FF914: 85 5F
	lda.b d0		; $8FF916: A5 53
	clc		; $8FF918: 18
	adc.w Xpos,y		; $8FF919: 79 FF 08
	sec		; $8FF91C: 38
	sbc.w puckx		; $8FF91D: ED 1B 09
	sta.b d0		; $8FF920: 85 53
	pha		; $8FF922: 48
	lsr a		; $8FF923: 4A
	lsr a		; $8FF924: 4A
	bit.w #$2000		; $8FF925: 89 00 20
	beq .l4		; $8FF928: F0 03
	ora.w #$C000		; $8FF92A: 09 00 C0
.l4:
	sta.b d2		; $8FF92D: 85 5B
	lda.w Yvel,y		; $8FF92F: B9 FF 0A
	sta.b mulb		; $8FF932: 85 83
	lda.w #$00F0		; $8FF934: A9 F0 00
	sta.b mula		; $8FF937: 85 7D
	jsl.l muls32		; $8FF939: 22 DB FC 82
	lda.b mulres+2		; $8FF93D: A5 95
	sta.b d1		; $8FF93F: 85 57
	pha		; $8FF941: 48
	lda.w Xvel,y		; $8FF942: B9 DF 0A
	sta.b mulb		; $8FF945: 85 83
	lda.w #$00F0		; $8FF947: A9 F0 00
	sta.b mula		; $8FF94A: 85 7D
	jsl.l muls32		; $8FF94C: 22 DB FC 82
	lda.b mulres+2		; $8FF950: A5 95
	sta.b d0		; $8FF952: 85 53
	pha		; $8FF954: 48
	sta.b mulb		; $8FF955: 85 83
	lda.b d2		; $8FF957: A5 5B
	sta.b mula		; $8FF959: 85 7D
	jsl.l muls16		; $8FF95B: 22 96 84 80
	sta.b d0		; $8FF95F: 85 53
	lda.b d3		; $8FF961: A5 5F
	sta.b mula		; $8FF963: 85 7D
	lda.b d1		; $8FF965: A5 57
	sta.b mulb		; $8FF967: 85 83
	jsl.l muls16		; $8FF969: 22 96 84 80
	adc.b d0		; $8FF96D: 65 53
	asl a		; $8FF96F: 0A
	sta.b d4		; $8FF970: 85 63
	lda.b $01,s		; $8FF972: A3 01
	sta.b mula		; $8FF974: 85 7D
	sta.b mulb		; $8FF976: 85 83
	jsl.l muls16		; $8FF978: 22 96 84 80
	sta.b d0		; $8FF97C: 85 53
	lda.b $03,s		; $8FF97E: A3 03
	sta.b mula		; $8FF980: 85 7D
	sta.b mulb		; $8FF982: 85 83
	jsl.l muls16		; $8FF984: 22 96 84 80
	sta.b d1		; $8FF988: 85 57
	lda.b d5		; $8FF98A: A5 67
	sta.b mula		; $8FF98C: 85 7D
	eor.w #$FFFF		; $8FF98E: 49 FF FF
	inc a		; $8FF991: 1A
	sta.b mulb		; $8FF992: 85 83
	jsl.l muls16		; $8FF994: 22 96 84 80
	adc.b d0		; $8FF998: 65 53
	clc		; $8FF99A: 18
	adc.b d1		; $8FF99B: 65 57
	sta.b d5		; $8FF99D: 85 67
	lda.b d2		; $8FF99F: A5 5B
	sta.b mula		; $8FF9A1: 85 7D
	sta.b mulb		; $8FF9A3: 85 83
	jsl.l muls16		; $8FF9A5: 22 96 84 80
	sta.b d2		; $8FF9A9: 85 5B
	lda.b d3		; $8FF9AB: A5 5F
	sta.b mula		; $8FF9AD: 85 7D
	sta.b mulb		; $8FF9AF: 85 83
	jsl.l muls16		; $8FF9B1: 22 96 84 80
	adc.b d2		; $8FF9B5: 65 5B
	sta.b mulb		; $8FF9B7: 85 83
	lda.b d5		; $8FF9B9: A5 67
	sta.b mula		; $8FF9BB: 85 7D
	jsl.l muls32		; $8FF9BD: 22 DB FC 82
	sta.b d3		; $8FF9C1: 85 5F
	lda.b mulres+2		; $8FF9C3: A5 95
	sta.b d3+2		; $8FF9C5: 85 61
	asl.b d3		; $8FF9C7: 06 5F
	rol.b d3+2		; $8FF9C9: 26 61
	asl.b d3		; $8FF9CB: 06 5F
	rol.b d3+2		; $8FF9CD: 26 61
	lda.b d4		; $8FF9CF: A5 63
	sta.b mula		; $8FF9D1: 85 7D
	sta.b mulb		; $8FF9D3: 85 83
	jsl.l muls32		; $8FF9D5: 22 DB FC 82
	sec		; $8FF9D9: 38
	sbc.b d3		; $8FF9DA: E5 5F
	sta.b d0		; $8FF9DC: 85 53
	lda.b mulres+2		; $8FF9DE: A5 95
	sbc.b d3+2		; $8FF9E0: E5 61
	sta.b d0+2		; $8FF9E2: 85 55
	jsl.l sroot		; $8FF9E4: 22 B1 CB 80
	lda.w #$0001		; $8FF9E8: A9 01 00
	sta.b d3		; $8FF9EB: 85 5F
	lda.b d5		; $8FF9ED: A5 67
	lsr a		; $8FF9EF: 4A
	lsr a		; $8FF9F0: 4A
	bit.w #$2000		; $8FF9F1: 89 00 20
	beq .l5		; $8FF9F4: F0 03
	ora.w #$C000		; $8FF9F6: 09 00 C0
.l5:
	sta.b d5		; $8FF9F9: 85 67
	lda.b d5		; $8FF9FB: A5 67
	bne .l6		; $8FF9FD: D0 05
	lda.w #$0001		; $8FF9FF: A9 01 00
	sta.b d5		; $8FFA02: 85 67
.l6:
	lda.b d0		; $8FFA04: A5 53
	sta.b d2		; $8FFA06: 85 5B
	eor.w #$FFFF		; $8FFA08: 49 FF FF
	inc a		; $8FFA0B: 1A
	sta.b d0		; $8FFA0C: 85 53
	lda.b d2		; $8FFA0E: A5 5B
	sec		; $8FFA10: 38
	sbc.b d4		; $8FFA11: E5 63
	sta.b mulb		; $8FFA13: 85 83
	lda.b d5		; $8FFA15: A5 67
	sta.b mula		; $8FFA17: 85 7D
	jsl.l divs16		; $8FFA19: 22 8B FB 8F
	sta.b d2		; $8FFA1D: 85 5B
	bpl .l7		; $8FFA1F: 10 04
	dec.b d3		; $8FFA21: C6 5F
	bpl .l6		; $8FFA23: 10 DF
.l7:
	bne .l8		; $8FFA25: D0 02
	inc.b d2		; $8FFA27: E6 5B
.l8:
	lda.b d2		; $8FFA29: A5 5B
	cmp.w #$0019		; $8FFA2B: C9 19 00
	bcc .l9		; $8FFA2E: 90 05
	lda.w #$0018		; $8FFA30: A9 18 00
	sta.b d2		; $8FFA33: 85 5B
.l9:
	lda.b d2		; $8FFA35: A5 5B
	sep #$20		; $8FFA37: E2 20
	sta.w puckvz+1		; $8FFA39: 8D 3C 0B
	rep #$30		; $8FFA3C: C2 30
	cmp.w #$000C		; $8FFA3E: C9 0C 00
	bcc .l10		; $8FFA41: 90 09
	sep #$20		; $8FFA43: E2 20
	lda.b #$0C		; $8FFA45: A9 0C
	sta.w puckvz+1		; $8FFA47: 8D 3C 0B
	rep #$30		; $8FFA4A: C2 30
.l10:
	ldy.b a0		; $8FFA4C: A4 33
	lda.b d2		; $8FFA4E: A5 5B
	asl a		; $8FFA50: 0A
	asl a		; $8FFA51: 0A
	asl a		; $8FFA52: 0A
	sec		; $8FFA53: 38
	sbc.w #$000A		; $8FFA54: E9 0A 00
	sta.w temp1,y		; $8FFA57: 99 5F 0C
	sec		; $8FFA5A: 38
	sbc.w #$0006		; $8FFA5B: E9 06 00
	sta.w nopuck+puckobj		; $8FFA5E: 8D 7B 0E
	pla		; $8FFA61: 68
	sta.b d0		; $8FFA62: 85 53
	sta.b mulb		; $8FFA64: 85 83
	pla		; $8FFA66: 68
	sta.b d1		; $8FFA67: 85 57
	lda.b d2		; $8FFA69: A5 5B
	sta.b mula		; $8FFA6B: 85 7D
	jsl.l muls32		; $8FFA6D: 22 DB FC 82
	lda.b mulres+2		; $8FFA71: A5 95
	lsr a		; $8FFA73: 4A
	lda.b mulres		; $8FFA74: A5 93
	ror a		; $8FFA76: 6A
	sta.b d0		; $8FFA77: 85 53
	lda.b mulres+2		; $8FFA79: A5 95
	pha		; $8FFA7B: 48
	asl a		; $8FFA7C: 0A
	pla		; $8FFA7D: 68
	ror a		; $8FFA7E: 6A
	sta.b d0+2		; $8FFA7F: 85 55
	pla		; $8FFA81: 68
	clc		; $8FFA82: 18
	adc.b d0		; $8FFA83: 65 53
	sta.b d0		; $8FFA85: 85 53
	clc		; $8FFA87: 18
	adc.w puckx		; $8FFA88: 6D 1B 09
	ldy.b a0		; $8FFA8B: A4 33
	sta.w temp3,y		; $8FFA8D: 99 9F 0C
	lda.b d2		; $8FFA90: A5 5B
	sta.b mula		; $8FFA92: 85 7D
	lda.b d1		; $8FFA94: A5 57
	sta.b mulb		; $8FFA96: 85 83
	jsl.l muls32		; $8FFA98: 22 DB FC 82
	lda.b mulres+2		; $8FFA9C: A5 95
	lsr a		; $8FFA9E: 4A
	lda.b mulres		; $8FFA9F: A5 93
	ror a		; $8FFAA1: 6A
	sta.b d1		; $8FFAA2: 85 57
	lda.b mulres+2		; $8FFAA4: A5 95
	pha		; $8FFAA6: 48
	asl a		; $8FFAA7: 0A
	pla		; $8FFAA8: 68
	ror a		; $8FFAA9: 6A
	sta.b d1+2		; $8FFAAA: 85 59
	pla		; $8FFAAC: 68
	clc		; $8FFAAD: 18
	adc.b d1		; $8FFAAE: 65 57
	sta.b d1		; $8FFAB0: 85 57
	clc		; $8FFAB2: 18
	adc.w pucky		; $8FFAB3: 6D 7B 09
	ldy.b a0		; $8FFAB6: A4 33
	sta.w temp4,y		; $8FFAB8: 99 BF 0C
	lda.w #$0078		; $8FFABB: A9 78 00
	sta.b mula		; $8FFABE: 85 7D
	lda.b d2		; $8FFAC0: A5 5B
	sta.b mulb		; $8FFAC2: 85 83
	jsl.l mulu16		; $8FFAC4: 22 1C 87 8D
	sta.b d2		; $8FFAC8: 85 5B
	sta.b mula		; $8FFACA: 85 7D
	lda.b d0		; $8FFACC: A5 53
	sta.b mulb+2		; $8FFACE: 85 85
	lda.b d0+2		; $8FFAD0: A5 55
	sta.b mulb		; $8FFAD2: 85 83
	jsl.l divs		; $8FFAD4: 22 6C 99 80
	sta.b d0		; $8FFAD8: 85 53
	sta.w puckvx		; $8FFADA: 8D FB 0A
	lda.b d2		; $8FFADD: A5 5B
	sta.b mula		; $8FFADF: 85 7D
	lda.b d1		; $8FFAE1: A5 57
	sta.b mulb+2		; $8FFAE3: 85 85
	lda.b d1+2		; $8FFAE5: A5 59
	sta.b mulb		; $8FFAE7: 85 83
	jsl.l divs		; $8FFAE9: 22 6C 99 80
	sta.b d1		; $8FFAED: 85 57
	sta.w puckvy		; $8FFAEF: 8D 1B 0B
	rtl		; $8FFAF2: 6B
GetPlayerCount:		;auto: CODE_8FFAF3. 93G GetPlayerCount: d0 = roster players of team a2 (its bank $83 team record: Player entries until the empty one); saves a0
	lda.b a0+2		; $8FFAF3: A5 35  save a0
	pha		; $8FFAF5: 48
	lda.b a0		; $8FFAF6: A5 33
	pha		; $8FFAF8: 48
	ldy.b a2		; $8FFAF9: A4 3B
	lda.w tmdata,y		; $8FFAFB: B9 CE 13
	sta.b a0		; $8FFAFE: 85 33
	lda.w #TeamList>>16		; $8FFB00: A9 83 00
	sta.b a0+2		; $8FFB03: 85 35
	ldy.w #$0000		; $8FFB05: A0 00 00
	lda.b [a0],y		; $8FFB08: B7 33
	clc		; $8FFB0A: 18
	adc.b a0		; $8FFB0B: 65 33
	sta.b a0		; $8FFB0D: 85 33
	stz.b d0		; $8FFB0F: 64 53
.l1:
	inc.b d0		; $8FFB11: E6 53
	lda.b [a0]		; $8FFB13: A7 33
	clc		; $8FFB15: 18
	adc.b a0		; $8FFB16: 65 33
	adc.w #$0008		; $8FFB18: 69 08 00
	sta.b a0		; $8FFB1B: 85 33
	lda.b [a0]		; $8FFB1D: A7 33
	cmp.w #$0002		; $8FFB1F: C9 02 00
	bne .l1		; $8FFB22: D0 ED
	pla		; $8FFB24: 68
	sta.b a0		; $8FFB25: 85 33
	pla		; $8FFB27: 68
	sta.b a0+2		; $8FFB28: 85 35
	rtl		; $8FFB2A: 6B
GetPlayerNameWithAttrib:		;auto: CODE_8FFB2B. 93G GetPlayerNameWithAttrib: a1 = the name of player TempPlOffset (PlayerShortName; bit 15 = the visitors); saves d0, a2
	lda.b d0+2		; $8FFB2B: A5 55
	pha		; $8FFB2D: 48
	lda.b d0		; $8FFB2E: A5 53
	pha		; $8FFB30: 48
	lda.b a2+2		; $8FFB31: A5 3D
	pha		; $8FFB33: 48
	lda.b a2		; $8FFB34: A5 3B
	pha		; $8FFB36: 48
	stz.b a2		; $8FFB37: 64 3B
	lda.w TempPlOffset		; $8FFB39: AD FA 12
	sta.b d0		; $8FFB3C: 85 53
	bpl .l1		; $8FFB3E: 10 0A
	and.w #$00FF		; $8FFB40: 29 FF 00
	sta.b d0		; $8FFB43: 85 53
	lda.w #$0002		; $8FFB45: A9 02 00
	sta.b a2		; $8FFB48: 85 3B
.l1:
	jsl.l PlayerShortName		; $8FFB4A: 22 82 81 8E
	pla		; $8FFB4E: 68
	sta.b a2		; $8FFB4F: 85 3B
	pla		; $8FFB51: 68
	sta.b a2+2		; $8FFB52: 85 3D
	pla		; $8FFB54: 68
	sta.b d0		; $8FFB55: 85 53
	pla		; $8FFB57: 68
	sta.b d0+2		; $8FFB58: 85 55
	rtl		; $8FFB5A: 6B
Acheck:		;auto: CODE_8FFB5B. 93G Acheck (logic93_1): player X holds a0: pfalock, SPAhook, or SPAHold when he has impact and a0 is not ahead. SNES: with pfgoal clear the bmi tests the pfgoal load, so
		;   always SPAHold then
	ldy.b a0		; $8FFB5B: A4 33
	lda.w #SPAhook		; $8FFB5D: A9 54 13
	sta.b d1		; $8FFB60: 85 57
	sta.w pfalock,x		; $8FFB62: 9D 7F 11
	lda.w impact,x		; $8FFB65: BD 7F 0B
	beq .l2		; $8FFB68: F0 1D
	lda.w Ypos,x		; $8FFB6A: BD 5F 09
	sec		; $8FFB6D: 38
	sbc.w Ypos,y		; $8FFB6E: F9 5F 09
	sta.b d0		; $8FFB71: 85 53
	lda.w pfgoal,x		; $8FFB73: BD 3F 11
	beq .l1		; $8FFB76: F0 08
	lda.b d0		; $8FFB78: A5 53
	eor.w #$FFFF		; $8FFB7A: 49 FF FF
	inc a		; $8FFB7D: 1A
	sta.b d0		; $8FFB7E: 85 53
.l1:
	bmi .l2		; $8FFB80: 30 05
	lda.w #SPAHold		; $8FFB82: A9 FC 0B
	sta.b d1		; $8FFB85: 85 57
.l2:
	jml.l SetSPA		; $8FFB87: 5C 06 B0 80
divs16:		;auto: CODE_8FFB8B. SNES: signed 16 / 16 divide: A = mulres = mulb / mula (toward zero; also left in mula and mulb); uses mulsign, mulcnt
	stz.b mulsign		; $8FFB8B: 64 81
	lda.b mula		; $8FFB8D: A5 7D
	bpl .l1		; $8FFB8F: 10 06
	eor.w #$FFFF		; $8FFB91: 49 FF FF
	inc a		; $8FFB94: 1A
	inc.b mulsign		; $8FFB95: E6 81
.l1:
	sta.b mula+2		; $8FFB97: 85 7F
	stz.b mula		; $8FFB99: 64 7D
	lda.w #$0010		; $8FFB9B: A9 10 00
	sta.b mulcnt		; $8FFB9E: 85 87
	lda.b mulb		; $8FFBA0: A5 83
	bpl .l2		; $8FFBA2: 10 08
	eor.w #$FFFF		; $8FFBA4: 49 FF FF
	inc a		; $8FFBA7: 1A
	sta.b mulb		; $8FFBA8: 85 83
	inc.b mulsign		; $8FFBAA: E6 81
.l2:
	lsr.b mula+2		; $8FFBAC: 46 7F
	ror.b mula		; $8FFBAE: 66 7D
	asl.b mulres		; $8FFBB0: 06 93
	lda.b mulb		; $8FFBB2: A5 83
	cmp.b mula		; $8FFBB4: C5 7D
	lda.w #$0000		; $8FFBB6: A9 00 00
	sbc.b mula+2		; $8FFBB9: E5 7F
	bcc .l3		; $8FFBBB: 90 08
	lda.b mulb		; $8FFBBD: A5 83
	sbc.b mula		; $8FFBBF: E5 7D
	sta.b mulb		; $8FFBC1: 85 83
	inc.b mulres		; $8FFBC3: E6 93
.l3:
	dec.b mulcnt		; $8FFBC5: C6 87
	bne .l2		; $8FFBC7: D0 E3
	lsr.b mulsign		; $8FFBC9: 46 81
	bcc .l4		; $8FFBCB: 90 07
	lda.w #$0000		; $8FFBCD: A9 00 00
	sbc.b mulres		; $8FFBD0: E5 93
	sta.b mulres		; $8FFBD2: 85 93
.l4:
	lda.b mulres		; $8FFBD4: A5 93
	sta.b mula		; $8FFBD6: 85 7D
	sta.b mulb		; $8FFBD8: 85 83
	clc		; $8FFBDA: 18
	rtl		; $8FFBDB: 6B
doplayeracc:		;auto: CODE_8FFBDC. 93G doplayeracc (logic93_5): player X skates in direction d0 (0-7; 8 glides, 9 stops when moving); goalies use goalieacc. Sets pfrev to skate backwards in his own
		;   zone, turns facedir/facefrac toward d0 (.ftab * d7, slower when fast), SPAturnl/SPAturnr or SPAglide/SPAglideback; revplayeracc when moving
	lda.w position,x		; $8FFBDC: BD 9F 0B
	bne .l1		; $8FFBDF: D0 04
	jml.l goalieacc		; $8FFBE1: 5C AB 83 80
.l1:
	lda.w #SPAglide		; $8FFBE5: A9 78 04
	sta.b d1		; $8FFBE8: 85 57
	lda.w pfrev,x		; $8FFBEA: BD BF 11
	beq .d0		; $8FFBED: F0 05
	lda.w #SPAglideback		; $8FFBEF: A9 CC 09
	sta.b d1		; $8FFBF2: 85 57
.d0:		;93G .d0
	lda.b d0		; $8FFBF4: A5 53
	and.w #$000F		; $8FFBF6: 29 0F 00
	sta.b d0		; $8FFBF9: 85 53
	cmp.w #$0008		; $8FFBFB: C9 08 00
	bcc .d1		; $8FFBFE: 90 1B
	cmp.w #$0009		; $8FFC00: C9 09 00
	bne .cgl		; $8FFC03: D0 0C
	lda.w Xvel,x		; $8FFC05: BD DF 0A
	ora.w Yvel,x		; $8FFC08: 1D FF 0A
	beq .cgl		; $8FFC0B: F0 04
	jml.l dostop		; $8FFC0D: 5C 04 84 80
.cgl:		;93G .cgl: no turn animation playing (pf2aip): SetSPA
	lda.w pf2aip,x		; $8FFC11: BD DF 11
	bne .l2		; $8FFC14: D0 04
	jml.l SetSPA		; $8FFC16: 5C 06 B0 80
.l2:
	rtl		; $8FFC1A: 6B
.d1:		;93G .d1: a direction: pfrev, then the turn
	lda.b d1		; $8FFC1B: A5 57
	pha		; $8FFC1D: 48
	lda.b d0		; $8FFC1E: A5 53
	pha		; $8FFC20: 48
	sta.b d2		; $8FFC21: 85 5B
	txa		; $8FFC23: 8A
	lsr a		; $8FFC24: 4A
	cmp.w puckc		; $8FFC25: CD BB 0E
	bne .l3		; $8FFC28: D0 03
	jmp.w .clrrev		; $8FFC2A: 4C DF FC
.l3:
	lda.w puckx		; $8FFC2D: AD 1B 09
	sec		; $8FFC30: 38
	sbc.w Xpos,x		; $8FFC31: FD FF 08
	sta.b d0		; $8FFC34: 85 53
	lda.w Ypos,x		; $8FFC36: BD 5F 09
	sta.b d3		; $8FFC39: 85 5F
	lda.w puckvy		; $8FFC3B: AD 1B 0B
	lsr a		; $8FFC3E: 4A
	lsr a		; $8FFC3F: 4A
	lsr a		; $8FFC40: 4A
	lsr a		; $8FFC41: 4A
	lsr a		; $8FFC42: 4A
	lsr a		; $8FFC43: 4A
	lsr a		; $8FFC44: 4A
	bit.w #$0100		; $8FFC45: 89 00 01
	beq .l4		; $8FFC48: F0 03
	ora.w #$FE00		; $8FFC4A: 09 00 FE
.l4:
	clc		; $8FFC4D: 18
	adc.w pucky		; $8FFC4E: 6D 7B 09
	sec		; $8FFC51: 38
	sbc.b d3		; $8FFC52: E5 5F
	sta.b d1		; $8FFC54: 85 57
	lda.w pfgoal,x		; $8FFC56: BD 3F 11
	bne .c1		; $8FFC59: D0 1F
	lda.b d0		; $8FFC5B: A5 53
	eor.w #$FFFF		; $8FFC5D: 49 FF FF
	inc a		; $8FFC60: 1A
	sta.b d0		; $8FFC61: 85 53
	lda.b d1		; $8FFC63: A5 57
	eor.w #$FFFF		; $8FFC65: 49 FF FF
	inc a		; $8FFC68: 1A
	sta.b d1		; $8FFC69: 85 57
	lda.b d3		; $8FFC6B: A5 5F
	eor.w #$FFFF		; $8FFC6D: 49 FF FF
	inc a		; $8FFC70: 1A
	sta.b d3		; $8FFC71: 85 5F
	lda.b d2		; $8FFC73: A5 5B
	eor.w #$0004		; $8FFC75: 49 04 00
	sta.b d2		; $8FFC78: 85 5B
.c1:		;93G .c1
	lda.w pfrev,x		; $8FFC7A: BD BF 11
	bne .inrev		; $8FFC7D: D0 1A
	lda.b d3		; $8FFC7F: A5 5F
	bpl .clrrev		; $8FFC81: 10 5C
	lda.b d2		; $8FFC83: A5 5B
	cmp.w #$0004		; $8FFC85: C9 04 00
	bne .clrrev		; $8FFC88: D0 55
	jsl.l vtoa		; $8FFC8A: 22 A8 AF 80
	inc a		; $8FFC8E: 1A
	and.w #$0007		; $8FFC8F: 29 07 00
	cmp.w #$0003		; $8FFC92: C9 03 00
	bcs .clrrev		; $8FFC95: B0 48
	bra .rev		; $8FFC97: 80 1C
.inrev:		;93G .inrev
	lda.b d2		; $8FFC99: A5 5B
	sec		; $8FFC9B: 38
	sbc.w #$0003		; $8FFC9C: E9 03 00
	and.w #$0007		; $8FFC9F: 29 07 00
	cmp.w #$0003		; $8FFCA2: C9 03 00
	bcs .clrrev		; $8FFCA5: B0 38
	jsl.l vtoa		; $8FFCA7: 22 A8 AF 80
	inc a		; $8FFCAB: 1A
	inc a		; $8FFCAC: 1A
	and.w #$0007		; $8FFCAD: 29 07 00
	cmp.w #$0005		; $8FFCB0: C9 05 00
	bcs .clrrev		; $8FFCB3: B0 2A
.rev:		;93G .rev
	lda.w pfrev,x		; $8FFCB5: BD BF 11
	bne .done		; $8FFCB8: D0 28
	lda.w Xvel,x		; $8FFCBA: BD DF 0A
	sta.b d0		; $8FFCBD: 85 53
	ora.w Yvel,x		; $8FFCBF: 1D FF 0A
	beq .setrev		; $8FFCC2: F0 15
	lda.w Yvel,x		; $8FFCC4: BD FF 0A
	sta.b d1		; $8FFCC7: 85 57
	jsl.l vtoa		; $8FFCC9: 22 A8 AF 80
	sec		; $8FFCCD: 38
	sbc.b $01,s		; $8FFCCE: E3 01
	inc a		; $8FFCD0: 1A
	and.w #$0007		; $8FFCD1: 29 07 00
	cmp.w #$0003		; $8FFCD4: C9 03 00
	bcs .done		; $8FFCD7: B0 09
.setrev:		;93G .setrev
	inc a		; $8FFCD9: 1A
	sta.w pfrev,x		; $8FFCDA: 9D BF 11
	bra .done		; $8FFCDD: 80 03
.clrrev:		;93G .fwd / .clrrev
	stz.w pfrev,x		; $8FFCDF: 9E BF 11
.done:		;93G .done: turn rate = .ftab (direction difference) * d7; 0: noturn0
	pla		; $8FFCE2: 68
	sta.b d0		; $8FFCE3: 85 53
	pla		; $8FFCE5: 68
	sta.b d1		; $8FFCE6: 85 57
	lda.w facedir,x		; $8FFCE8: BD BF 0D
	sta.b d2		; $8FFCEB: 85 5B
	lda.b d0		; $8FFCED: A5 53
	sec		; $8FFCEF: 38
	sbc.b d2		; $8FFCF0: E5 5B
	and.w #$0007		; $8FFCF2: 29 07 00
	asl a		; $8FFCF5: 0A
	sta.b d0		; $8FFCF6: 85 53
	tax		; $8FFCF8: AA
	lda.l .ftab,x		; $8FFCF9: BF C8 FD 8F
	ldx.b a3		; $8FFCFD: A6 3F
	sta.b mula		; $8FFCFF: 85 7D
	lda.b d7		; $8FFD01: A5 6F
	sta.b mulb		; $8FFD03: 85 83
	jsl.l muls16		; $8FFD05: 22 96 84 80
	sta.b tmp0		; $8FFD09: 85 73
	lda.b tmp0		; $8FFD0B: A5 73
	bne .l5		; $8FFD0D: D0 04
	jml.l noturn0		; $8FFD0F: 5C 48 85 88
.l5:
	lda.w Xvel,x		; $8FFD13: BD DF 0A
	sta.b mula		; $8FFD16: 85 7D
	sta.b mulb		; $8FFD18: 85 83
	jsl.l muls32		; $8FFD1A: 22 DB FC 82
	sta.b d4		; $8FFD1E: 85 63
	lda.b mulres+2		; $8FFD20: A5 95
	sta.b d4+2		; $8FFD22: 85 65
	lda.w Yvel,x		; $8FFD24: BD FF 0A
	sta.b mula		; $8FFD27: 85 7D
	sta.b mulb		; $8FFD29: 85 83
	jsl.l muls32		; $8FFD2B: 22 DB FC 82
	adc.b d4		; $8FFD2F: 65 63
	lda.b mulres+2		; $8FFD31: A5 95
	adc.b d4+2		; $8FFD33: 65 65
	sta.b d3		; $8FFD35: 85 5F
	lda.w #$0300		; $8FFD37: A9 00 03
	sec		; $8FFD3A: 38
	sbc.b d3		; $8FFD3B: E5 5F
	sta.b d4		; $8FFD3D: 85 63
	sec		; $8FFD3F: 38
	sbc.w #$0180		; $8FFD40: E9 80 01
	bmi .l6		; $8FFD43: 30 04
	bvs .l7		; $8FFD45: 70 04
	bra .iok		; $8FFD47: 80 07
.l6:
	bvs .iok		; $8FFD49: 70 05
.l7:
	lda.w #$0180		; $8FFD4B: A9 80 01
	sta.b d4		; $8FFD4E: 85 63
.iok:		;93G .iok
	lda.b tmp0		; $8FFD50: A5 73
	sta.b mula		; $8FFD52: 85 7D
	lda.b d4		; $8FFD54: A5 63
	sta.b mulb		; $8FFD56: 85 83
	jsl.l muls32		; $8FFD58: 22 DB FC 82
	sta.b d4		; $8FFD5C: 85 63
	lda.b mulres+2		; $8FFD5E: A5 95
	sta.b d4+2		; $8FFD60: 85 65
	lda.w pfrev,x		; $8FFD62: BD BF 11
	beq .i0		; $8FFD65: F0 0F
	lda.w #$0000		; $8FFD67: A9 00 00
	sec		; $8FFD6A: 38
	sbc.b d4		; $8FFD6B: E5 63
	sta.b d4		; $8FFD6D: 85 63
	lda.w #$0000		; $8FFD6F: A9 00 00
	sbc.b d4+2		; $8FFD72: E5 65
	sta.b d4+2		; $8FFD74: 85 65
.i0:		;93G .i0: facedir.l + d4
	lda.w facefrac,x		; $8FFD76: BD DF 0D
	clc		; $8FFD79: 18
	adc.b d4		; $8FFD7A: 65 63
	sta.w facefrac,x		; $8FFD7C: 9D DF 0D
	lda.w facedir,x		; $8FFD7F: BD BF 0D
	adc.b d4+2		; $8FFD82: 65 65
	and.w #$0007		; $8FFD84: 29 07 00
	sta.w facedir,x		; $8FFD87: 9D BF 0D
	sta.b d2		; $8FFD8A: 85 5B
	lda.b d3		; $8FFD8C: A5 5F
	cmp.w #$0015		; $8FFD8E: C9 15 00
	bcc .s3		; $8FFD91: 90 25
	stz.b d1		; $8FFD93: 64 57
	lda.b tmp0		; $8FFD95: A5 73
	bpl .s1		; $8FFD97: 10 05
	lda.w #SPAturnl-SPAturnr		; $8FFD99: A9 CE FF
	sta.b d1		; $8FFD9C: 85 57
.s1:		;93G .s1
	lda.w attribute,x		; $8FFD9E: BD DF 09
	bit.w #$0800		; $8FFDA1: 89 00 08
	beq .s2		; $8FFDA4: F0 07
	lda.b d1		; $8FFDA6: A5 57
	eor.w #SPAturnl-SPAturnr		; $8FFDA8: 49 CE FF
	sta.b d1		; $8FFDAB: 85 57
.s2:		;93G .s2: SPAturnr (or SPAturnl), pf2aip
	lda.b d1		; $8FFDAD: A5 57
	clc		; $8FFDAF: 18
	adc.w #SPAturnr		; $8FFDB0: 69 40 06
	sta.b d1		; $8FFDB3: 85 57
	sta.w pf2aip,x		; $8FFDB5: 9D DF 11
.s3:		;93G .s3
	jsl.l SetSPA		; $8FFDB8: 22 06 B0 80
	lda.b d3		; $8FFDBC: A5 5F
	cmp.w #$0003		; $8FFDBE: C9 03 00
	bcc .l8		; $8FFDC1: 90 04
	jml.l revplayeracc		; $8FFDC3: 5C 54 FD 82
.l8:
	rtl		; $8FFDC7: 6B
.ftab:		;93G .ftab: turn rate by the direction difference (93G $10)
	dw 0,23,23,23,0,-23,-23,-23		; $8FFDC8
ResetAndSelectPlayers:		;auto: CODE_8FFDD8. 93G ResetAndSelectPlayers (logic93_4): c1playernum/c2playernum = -1, then changeplayer for each human team (d4 = 0, 2)
	lda.w #$FFFF		; $8FFDD8: A9 FF FF
	sta.w c1playernum		; $8FFDDB: 8D 92 12
	sta.w c2playernum		; $8FFDDE: 8D 94 12
	lda.w cont1team		; $8FFDE1: AD 96 12
	beq .l1		; $8FFDE4: F0 06
	stz.b d4		; $8FFDE6: 64 63
	jsl.l changeplayer		; $8FFDE8: 22 9D AE 80
.l1:
	lda.w cont2team		; $8FFDEC: AD 98 12
	beq .l2		; $8FFDEF: F0 09
	lda.w #$0002		; $8FFDF1: A9 02 00
	sta.b d4		; $8FFDF4: 85 63
	jsl.l changeplayer		; $8FFDF6: 22 9D AE 80
.l2:
	rtl		; $8FFDFA: 6B
cd0:		;93G cd0 (hockey93_11): $fftt = frame/time for the levels of crowd excitement (updatecrowdf: crowd level, crowdstep); 4 levels of 16
	dw $010C,$020C,$030C,$040C,$050C,$0A0C,$090C,$080C		; $8FFDFB
	dw $060C,$070C,$080C,$090C,$0A0C,$050C,$040C,$030C		; $8FFE0B
	dw $0107,$0207,$0307,$0407,$0507,$0B07,$0C07,$0D07		; $8FFE1B
	dw $0607,$0707,$0807,$0907,$0A07,$0B07,$0C07,$0D07		; $8FFE2B
	dw $0E07,$0F07,$1007,$1107,$1207,$0B07,$0C07,$0D07		; $8FFE3B
	dw $1207,$1107,$1007,$0F07,$0E07,$0D07,$0C07,$0B07		; $8FFE4B
	dw $0E03,$0F03,$1003,$1103,$1203,$0B03,$0C03,$0D03		; $8FFE5B
	dw $1203,$1103,$1003,$0F03,$0E03,$0D03,$0C03,$0B03		; $8FFE6B
MusicCue:		;auto: CODE_8FFE7B (from StartSong1-5). SNES: send driver command A (a music cue): the sound queue becomes just A (sndqueue, out 0, in 2), under sndlock
	pha		; $8FFE7B: 48
	lda.w #$0001		; $8FFE7C: A9 01 00
	sta.b sndlock		; $8FFE7F: 85 21
	pla		; $8FFE81: 68
	sta.b sndqueue		; $8FFE82: 85 23
	stz.b sndqout		; $8FFE84: 64 1F
	lda.w #$0002		; $8FFE86: A9 02 00
	sta.b sndqin		; $8FFE89: 85 1D
	stz.b sndlock		; $8FFE8B: 64 21
	rtl		; $8FFE8D: 6B
sfx8F:		;auto: CODE_8FFE8E. SNES: bank $8F copy of sfx: queue the sound pushed before the jsl (0 = none) unless within 180 frames of sfxmutetime; no lastsfx; returns through jmlvector. Sends the
		;   crowd volume (bank $8D, $8F87C4)
	pla		; $8FFE8E: 68  return address +1 into jmlvector
	inc a		; $8FFE8F: 1A
	sta.w jmlvector+1		; $8FFE90: 8D 79 01
	sep #$20		; $8FFE93: E2 20
	pla		; $8FFE95: 68
	sta.w jmlvector+3		; $8FFE96: 8D 7B 01
	rep #$20		; $8FFE99: C2 20
	lda.b vcount		; $8FFE9B: A5 00
	sec		; $8FFE9D: 38
	sbc.w sfxmutetime		; $8FFE9E: ED A7 04
	cmp.w #$00B4		; $8FFEA1: C9 B4 00
	bcc .l2		; $8FFEA4: 90 0B
	pla		; $8FFEA6: 68  the sound (0 = none)
	beq .l1		; $8FFEA7: F0 04
	jsl.l QueueSound		; $8FFEA9: 22 79 FB 82
.l1:
	jml.l jmlvector		; $8FFEAD: 5C 78 01 00
.l2:
	pla		; $8FFEB1: 68
	bra .l1		; $8FFEB2: 80 F9
DisplayPlayerAttributeMenu:		;auto: CODE_8FFEB4. 93G DisplayPlayerAttributeMenu (hockey93_10), really the goal box: close both line change boxes (lcfound2), Framer at x $B, y 2 (5-8 tall by the
		;   assists), printbig "GOAL!" or "HAT TRICK!" (the scorer's third goal, tmgoals), the scorer and "Assist by:" names from the last ScoreSum entry; saves d0-d2, a0-a4, ends with X = a3
	stx.b xsave		; $8FFEB4: 86 0A
	ldx.w #$0000		; $8FFEB6: A2 00 00
.l1:
	lda.b d0,x		; $8FFEB9: B5 53
	pha		; $8FFEBB: 48
	inx		; $8FFEBC: E8
	inx		; $8FFEBD: E8
	cpx.w #$000C		; $8FFEBE: E0 0C 00
	bne .l1		; $8FFEC1: D0 F6
	ldx.b xsave		; $8FFEC3: A6 0A
	stx.b xsave		; $8FFEC5: 86 0A
	ldx.w #$0000		; $8FFEC7: A2 00 00
.l2:
	lda.b a0,x		; $8FFECA: B5 33
	pha		; $8FFECC: 48
	inx		; $8FFECD: E8
	inx		; $8FFECE: E8
	cpx.w #$0014		; $8FFECF: E0 14 00
	bne .l2		; $8FFED2: D0 F6
	ldx.b xsave		; $8FFED4: A6 0A
	stz.b a2		; $8FFED6: 64 3B
	jsl.l lcfound2		; $8FFED8: 22 B7 FC 86
	inc.b a2		; $8FFEDC: E6 3B
	inc.b a2		; $8FFEDE: E6 3B
	jsl.l lcfound2		; $8FFEE0: 22 B7 FC 86
	lda.w #$0000		; $8FFEE4: A9 00 00
	sta.b a4+2		; $8FFEE7: 85 45
	lda.w #ScoreSum-6		; $8FFEE9: A9 F8 12
	clc		; $8FFEEC: 18
	adc.w ScoreSumbytes		; $8FFEED: 6D FC 12
	sta.b a4		; $8FFEF0: 85 43
	jsl.l printz		; $8FFEF2: 22 0C B9 80
	dw $0005		; $8FFEF6  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02
	lda.w #$0013		; $8FFEFB: A9 13 00
	sta.b d0		; $8FFEFE: 85 53
	lda.w #$0005		; $8FFF00: A9 05 00
	sta.b d1		; $8FFF03: 85 57
	ldy.w #$0004		; $8FFF05: A0 04 00
	lda.b [a4],y		; $8FFF08: B7 43
	bit.w #$0080		; $8FFF0A: 89 80 00
	bne .l3		; $8FFF0D: D0 0A
	inc.b d1		; $8FFF0F: E6 57
	inc.b d1		; $8FFF11: E6 57
	lda.b [a4],y		; $8FFF13: B7 43
	bmi .l3		; $8FFF15: 30 02
	inc.b d1		; $8FFF17: E6 57
.l3:
	jsl.l Framer		; $8FFF19: 22 9F D6 8F
	stz.b a2		; $8FFF1D: 64 3B
	ldy.w #$0002		; $8FFF1F: A0 02 00
	lda.b [a4],y		; $8FFF22: B7 43
	bit.w #$0080		; $8FFF24: 89 80 00
	beq .l4		; $8FFF27: F0 04
	inc.b a2		; $8FFF29: E6 3B
	inc.b a2		; $8FFF2B: E6 3B
.l4:
	lda.w #attrText		; $8FFF2D: A9 DC FF
	sta.b a1		; $8FFF30: 85 37
	lda.w #attrText>>16		; $8FFF32: A9 8F 00
	sta.b a1+2		; $8FFF35: 85 39
	ldy.w #$0003		; $8FFF37: A0 03 00
	lda.b [a4],y		; $8FFF3A: B7 43
	and.w #$00FF		; $8FFF3C: 29 FF 00
	ldy.b a2		; $8FFF3F: A4 3B
	beq .l5		; $8FFF41: F0 04
	clc		; $8FFF43: 18
	adc.w #$001A		; $8FFF44: 69 1A 00
.l5:
	tay		; $8FFF47: A8
	lda.w tmgoals,y		; $8FFF48: B9 12 14  goals of the scorer
	and.w #$00FF		; $8FFF4B: 29 FF 00
	cmp.w #$0003		; $8FFF4E: C9 03 00
	bne .l6		; $8FFF51: D0 07
	lda.b a1		; $8FFF53: A5 37
	clc		; $8FFF55: 18
	adc.b [a1]		; $8FFF56: 67 37
	sta.b a1		; $8FFF58: 85 37
.l6:
	jsl.l printbig		; $8FFF5A: 22 CE FC 8B
	ldy.w #$0003		; $8FFF5E: A0 03 00
	lda.b [a4],y		; $8FFF61: B7 43
	and.w #$00FF		; $8FFF63: 29 FF 00
	sta.b d0		; $8FFF66: 85 53
	jsl.l PlayerShortName		; $8FFF68: 22 82 81 8E
	jsl.l print		; $8FFF6C: 22 2D B9 80
	ldy.w #$0004		; $8FFF70: A0 04 00
	lda.b [a4],y		; $8FFF73: B7 43
	and.w #$00FF		; $8FFF75: 29 FF 00
	sta.b d0		; $8FFF78: 85 53
	bit.w #$0080		; $8FFF7A: 89 80 00
	bne .ex		; $8FFF7D: D0 3E
	jsl.l printz		; $8FFF7F: 22 0C B9 80
	dw $0012		; $8FFF83  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$06,"Assist by:",$BF,$0C,$07
	jsl.l PlayerShortName		; $8FFF95: 22 82 81 8E
	jsl.l print		; $8FFF99: 22 2D B9 80
	ldy.w #$0005		; $8FFF9D: A0 05 00
	lda.b [a4],y		; $8FFFA0: B7 43
	and.w #$00FF		; $8FFFA2: 29 FF 00
	sta.b d0		; $8FFFA5: 85 53
	bit.w #$0080		; $8FFFA7: 89 80 00
	bne .ex		; $8FFFAA: D0 11
	jsl.l printz		; $8FFFAC: 22 0C B9 80
	dw $0005		; $8FFFB0  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$08
	jsl.l PlayerShortName		; $8FFFB5: 22 82 81 8E
	jsl.l print		; $8FFFB9: 22 2D B9 80
.ex:		;93G .ex
	stx.b xsave		; $8FFFBD: 86 0A
	ldx.w #$0012		; $8FFFBF: A2 12 00
.l7:
	pla		; $8FFFC2: 68
	sta.b a0,x		; $8FFFC3: 95 33
	dex		; $8FFFC5: CA
	dex		; $8FFFC6: CA
	bpl .l7		; $8FFFC7: 10 F9
	ldx.b xsave		; $8FFFC9: A6 0A
	stx.b xsave		; $8FFFCB: 86 0A
	ldx.w #$000A		; $8FFFCD: A2 0A 00
.l8:
	pla		; $8FFFD0: 68
	sta.b d0,x		; $8FFFD1: 95 53
	dex		; $8FFFD3: CA
	dex		; $8FFFD4: CA
	bpl .l8		; $8FFFD5: 10 F9
	ldx.b xsave		; $8FFFD7: A6 0A
	ldx.b a3		; $8FFFD9: A6 3F
	rtl		; $8FFFDB: 6B
attrText:		;93G attrText: printbig strings of DisplayPlayerAttributeMenu: GOAL!, then HAT TRICK!
	dw 13		; $8FFFDC
	db $BF,$0F,$03,"GOAL!",$BF,$0C,$05
	dw 18		; $8FFFE9
	db $BF,$0C,$03,"HAT TRICK!",$BF,$0C,$05
unusedFF8F:		;the end of the ROM: zero fill
	db 0,0,0,0,0		; $8FFFFB
