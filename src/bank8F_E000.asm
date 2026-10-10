; $8FE00A-$8FEE82  ROM $7E00A-$7EE82: SetupTeamForIntermission, ClearSprites, RemapTiles, playeracc (logic93_5), ClearPenaltyBuffer, randomd0s,
; DefaultMenus, checkagr, WeightedRandomSelect, forceblack, passmode/dopass, FrameSetTable, CompLine, TeamRoster, addframe, Pmenu with the
; pause menu lists, GetPadTeam, setpde. Ends before setoptions (boundaries moved from $8FE00E / $8FF002).
org $8FE00A
SetupTeamForIntermission:		;auto: CODE_8FE00A (from Intermission). 93G SetupTeamForIntermission: ResetBench; both teams re-energized, line 0 (3/5 when a team is a man short or up)
	jsl.l ResetBench		; $8FE00A: 22 1A B0 80
	stz.b a2		; $8FE00E: 64 3B
	lda.w #$0002		; $8FE010: A9 02 00
	sta.b a3		; $8FE013: 85 3F
	jsl.l .team		; $8FE015: 22 20 E0 8F
	stz.b a3		; $8FE019: 64 3F
	lda.w #$0002		; $8FE01B: A9 02 00
	sta.b a2		; $8FE01E: 85 3B
.team:		;team a2 (a3 = the other)
	jsl.l reenergizeteam		; $8FE020: 22 D1 FE 80
	ldx.b a3		; $8FE024: A6 3F
	ldy.b a2		; $8FE026: A4 3B
	stz.w tmline,x		; $8FE028: 9E DE 13
	lda.w OptLine		; $8FE02B: AD 0C 16
	bne .l1		; $8FE02E: D0 1B
	lda.w tmap,x		; $8FE030: BD EE 13
	sec		; $8FE033: 38
	sbc.w tmap,y		; $8FE034: F9 EE 13
	sta.b d0		; $8FE037: 85 53
	beq .l1		; $8FE039: F0 10
	lda.w #$0003		; $8FE03B: A9 03 00
	sta.w tmline,x		; $8FE03E: 9D DE 13
	lda.b d0		; $8FE041: A5 53
	bpl .l1		; $8FE043: 10 06
	lda.w #$0005		; $8FE045: A9 05 00
	sta.w tmline,x		; $8FE048: 9D DE 13
.l1:
	rtl		; $8FE04B: 6B
ClearSprites:		;auto: CODE_8FE04C. SNES: all 128 OAM entries off screen (y $E0), the high table clear; new sprite frame (sprclock), VRAM slot rotors restart
	clc		; $8FE04C: 18
	ldx.w #$0000		; $8FE04D: A2 00 00
	ldy.w #$0008		; $8FE050: A0 08 00
.l1:
	lda.w #$E0E0		; $8FE053: A9 E0 E0
	sta.w Satt,x		; $8FE056: 9D FF 01
	stz.w Satt+2,x		; $8FE059: 9E 01 02
	sta.w Satt+$4,x		; $8FE05C: 9D 03 02
	stz.w Satt+$6,x		; $8FE05F: 9E 05 02
	sta.w Satt+$8,x		; $8FE062: 9D 07 02
	stz.w Satt+$A,x		; $8FE065: 9E 09 02
	sta.w Satt+$C,x		; $8FE068: 9D 0B 02
	stz.w Satt+$E,x		; $8FE06B: 9E 0D 02
	sta.w Satt+$10,x		; $8FE06E: 9D 0F 02
	stz.w Satt+$12,x		; $8FE071: 9E 11 02
	sta.w Satt+$14,x		; $8FE074: 9D 13 02
	stz.w Satt+$16,x		; $8FE077: 9E 15 02
	sta.w Satt+$18,x		; $8FE07A: 9D 17 02
	stz.w Satt+$1A,x		; $8FE07D: 9E 19 02
	sta.w Satt+$1C,x		; $8FE080: 9D 1B 02
	stz.w Satt+$1E,x		; $8FE083: 9E 1D 02
	sta.w Satt+$20,x		; $8FE086: 9D 1F 02
	stz.w Satt+$22,x		; $8FE089: 9E 21 02
	sta.w Satt+$24,x		; $8FE08C: 9D 23 02
	stz.w Satt+$26,x		; $8FE08F: 9E 25 02
	sta.w Satt+$28,x		; $8FE092: 9D 27 02
	stz.w Satt+$2A,x		; $8FE095: 9E 29 02
	sta.w Satt+$2C,x		; $8FE098: 9D 2B 02
	stz.w Satt+$2E,x		; $8FE09B: 9E 2D 02
	sta.w Satt+$30,x		; $8FE09E: 9D 2F 02
	stz.w Satt+$32,x		; $8FE0A1: 9E 31 02
	sta.w Satt+$34,x		; $8FE0A4: 9D 33 02
	stz.w Satt+$36,x		; $8FE0A7: 9E 35 02
	sta.w Satt+$38,x		; $8FE0AA: 9D 37 02
	stz.w Satt+$3A,x		; $8FE0AD: 9E 39 02
	sta.w Satt+$3C,x		; $8FE0B0: 9D 3B 02
	stz.w Satt+$3E,x		; $8FE0B3: 9E 3D 02
	txa		; $8FE0B6: 8A
	adc.w #$0040		; $8FE0B7: 69 40 00
	tax		; $8FE0BA: AA
	dey		; $8FE0BB: 88
	bne .l1		; $8FE0BC: D0 95
.l2:
	stz.w Satt,x		; $8FE0BE: 9E FF 01
	inx		; $8FE0C1: E8
	inx		; $8FE0C2: E8
	cpx.w #$0220		; $8FE0C3: E0 20 02
	bne .l2		; $8FE0C6: D0 F6
	stz.b sprcount		; $8FE0C8: 64 A9
	inc.b sprclock		; $8FE0CA: E6 A7
	lda.b sprnodraw		; $8FE0CC: A5 C7
	beq .l3		; $8FE0CE: F0 0B
	stz.b sprnodraw		; $8FE0D0: 64 C7
	lda.b sprslotlife		; $8FE0D2: A5 C1
	cmp.w #$0003		; $8FE0D4: C9 03 00
	bcc .l3		; $8FE0D7: 90 02
	dec.b sprslotlife		; $8FE0D9: C6 C1
.l3:
	lda.b sprbigslot		; $8FE0DB: A5 B1
	sta.b sprbigslotend		; $8FE0DD: 85 B3
	lda.b sprslot		; $8FE0DF: A5 B5
	sta.b sprslotend		; $8FE0E1: 85 B7
	rtl		; $8FE0E3: 6B
RemapTiles:		;auto: CODE_8FE0E4. SNES: d0 4bpp tiles at [a0] to vram with each pixel value remapped through the 16-byte table [a1]
	lda.w #$000E		; $8FE0E4: A9 0E 00
	sta.b tmp2+1		; $8FE0E7: 85 78
.l1:
	rep #$30		; $8FE0E9: C2 30
	ldy.b tmp2+1		; $8FE0EB: A4 78
	lda.b [a0],y		; $8FE0ED: B7 33
	sta.b tmp0		; $8FE0EF: 85 73
	tya		; $8FE0F1: 98
	clc		; $8FE0F2: 18
	adc.w #$0010		; $8FE0F3: 69 10 00
	tay		; $8FE0F6: A8
	lda.b [a0],y		; $8FE0F7: B7 33
	sta.b tmp1		; $8FE0F9: 85 75
	sep #$30		; $8FE0FB: E2 30
	ldx.b tmp2+1		; $8FE0FD: A6 78
	lda.b #$07		; $8FE0FF: A9 07
	sta.b tmp2		; $8FE101: 85 77
.l2:
	ldy.b #$00		; $8FE103: A0 00
	asl.b tmp1+1		; $8FE105: 06 76
	bcc .l3		; $8FE107: 90 02
	ldy.b #$08		; $8FE109: A0 08
.l3:
	asl.b tmp1		; $8FE10B: 06 75
	bcc .l4		; $8FE10D: 90 04
	iny		; $8FE10F: C8
	iny		; $8FE110: C8
	iny		; $8FE111: C8
	iny		; $8FE112: C8
.l4:
	asl.b tmp0+1		; $8FE113: 06 74
	bcc .l5		; $8FE115: 90 02
	iny		; $8FE117: C8
	iny		; $8FE118: C8
.l5:
	asl.b tmp0		; $8FE119: 06 73
	bcc .l6		; $8FE11B: 90 01
	iny		; $8FE11D: C8
.l6:
	lda.b [a1],y		; $8FE11E: B7 37
	lsr a		; $8FE120: 4A
	rol.b mula,x		; $8FE121: 36 7D
	lsr a		; $8FE123: 4A
	rol.b mula+1,x		; $8FE124: 36 7E
	lsr a		; $8FE126: 4A
	rol.b mula+16,x		; $8FE127: 36 8D
	lsr a		; $8FE129: 4A
	rol.b mula+17,x		; $8FE12A: 36 8E
	dec.b tmp2		; $8FE12C: C6 77
	bpl .l2		; $8FE12E: 10 D3
	dec.b tmp2+1		; $8FE130: C6 78
	dec.b tmp2+1		; $8FE132: C6 78
	bpl .l1		; $8FE134: 10 B3
	rep #$30		; $8FE136: C2 30
	ldx.w #$0000		; $8FE138: A2 00 00
.l7:
	lda.b mula,x		; $8FE13B: B5 7D
	sta.w VMDATAL		; $8FE13D: 8D 18 21
	inx		; $8FE140: E8
	inx		; $8FE141: E8
	cpx.w #$0020		; $8FE142: E0 20 00
	bne .l7		; $8FE145: D0 F4
	lda.b a0		; $8FE147: A5 33
	clc		; $8FE149: 18
	adc.w #$0020		; $8FE14A: 69 20 00
	sta.b a0		; $8FE14D: 85 33
	dec.b d0		; $8FE14F: C6 53
	bne RemapTiles		; $8FE151: D0 91
	rtl		; $8FE153: 6B
PixelRemap8F:		;SNES: 4bpp pixel value remap for RemapTiles: colour 1 stays, the rest 0
	db $00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8FE154
playeracc:		;auto: CODE_8FE164 (from noturn, fightinput). 93G playeracc (logic93_5): accelerate player X in direction d2 (dirtab8F, Wallsin/Wallcos, weight and legstr), cap at MaxSpeed; energy use
	asl.b d2		; $8FE164: 06 5B
	asl.b d2		; $8FE166: 06 5B
	ldx.b d2		; $8FE168: A6 5B
	lda.l dirtab8F+2,x		; $8FE16A: BF DB E2 8F
	sta.b mula		; $8FE16E: 85 7D
	lda.b d7		; $8FE170: A5 6F
	sta.b mulb		; $8FE172: 85 83
	jsl.l muls16		; $8FE174: 22 96 84 80
	lsr a		; $8FE178: 4A
	lsr a		; $8FE179: 4A
	bit.w #$2000		; $8FE17A: 89 00 20
	beq .l1		; $8FE17D: F0 03
	ora.w #$C000		; $8FE17F: 09 00 C0
.l1:
	sta.b d1		; $8FE182: 85 57
	lda.l dirtab8F,x		; $8FE184: BF D9 E2 8F
	sta.b mula		; $8FE188: 85 7D
	lda.b d7		; $8FE18A: A5 6F
	sta.b mulb		; $8FE18C: 85 83
	jsl.l muls16		; $8FE18E: 22 96 84 80
	lsr a		; $8FE192: 4A
	lsr a		; $8FE193: 4A
	bit.w #$2000		; $8FE194: 89 00 20
	beq .l2		; $8FE197: F0 03
	ora.w #$C000		; $8FE199: 09 00 C0
.l2:
	sta.b d0		; $8FE19C: 85 53
	ldx.b a3		; $8FE19E: A6 3F
	lda.w Wallsin,x		; $8FE1A0: BD 7F 0D
	beq .l3		; $8FE1A3: F0 06
	eor.b d0		; $8FE1A5: 45 53
	bpl .l3		; $8FE1A7: 10 02
	stz.b d0		; $8FE1A9: 64 53
.l3:
	lda.w Wallcos,x		; $8FE1AB: BD 5F 0D
	beq .l4		; $8FE1AE: F0 06
	eor.b d1		; $8FE1B0: 45 57
	bmi .l4		; $8FE1B2: 30 02
	stz.b d1		; $8FE1B4: 64 57
.l4:
	lda.w weight,x		; $8FE1B6: BD 3F 0F
	lsr a		; $8FE1B9: 4A
	lsr a		; $8FE1BA: 4A
	lsr a		; $8FE1BB: 4A
	lsr a		; $8FE1BC: 4A
	eor.w #$FFFF		; $8FE1BD: 49 FF FF
	inc a		; $8FE1C0: 1A
	clc		; $8FE1C1: 18
	adc.w #$0020		; $8FE1C2: 69 20 00
	clc		; $8FE1C5: 18
	adc.w legstr,x		; $8FE1C6: 7D 5F 0F
	sta.b d2		; $8FE1C9: 85 5B
	lda.w position,x		; $8FE1CB: BD 9F 0B
	bne .l5		; $8FE1CE: D0 0C
	lda.b d2		; $8FE1D0: A5 5B
	clc		; $8FE1D2: 18
	adc.w legstr,x		; $8FE1D3: 7D 5F 0F
	clc		; $8FE1D6: 18
	adc.w #$0008		; $8FE1D7: 69 08 00
	sta.b d2		; $8FE1DA: 85 5B
.l5:
	lda.b d2		; $8FE1DC: A5 5B
	pha		; $8FE1DE: 48
	sta.b mula		; $8FE1DF: 85 7D
	lda.b d0		; $8FE1E1: A5 53
	sta.b mulb		; $8FE1E3: 85 83
	jsl.l muls32		; $8FE1E5: 22 DB FC 82
	lsr.b mulres+2		; $8FE1E9: 46 95
	ror a		; $8FE1EB: 6A
	lsr.b mulres+2		; $8FE1EC: 46 95
	ror a		; $8FE1EE: 6A
	lsr.b mulres+2		; $8FE1EF: 46 95
	ror a		; $8FE1F1: 6A
	lsr.b mulres+2		; $8FE1F2: 46 95
	ror a		; $8FE1F4: 6A
	lsr.b mulres+2		; $8FE1F5: 46 95
	ror a		; $8FE1F7: 6A
	sta.b mula		; $8FE1F8: 85 7D
	lda.b d7		; $8FE1FA: A5 6F
	sta.b mulb		; $8FE1FC: 85 83
	jsl.l muls16		; $8FE1FE: 22 96 84 80
	adc.w Xvel,x		; $8FE202: 7D DF 0A
	sta.b d0		; $8FE205: 85 53
	sta.b mula		; $8FE207: 85 7D
	sta.b mulb		; $8FE209: 85 83
	jsl.l muls32		; $8FE20B: 22 DB FC 82
	sta.b d2		; $8FE20F: 85 5B
	lda.b mulres+2		; $8FE211: A5 95
	sta.b d2+2		; $8FE213: 85 5D
	pla		; $8FE215: 68
	sta.b mula		; $8FE216: 85 7D
	lda.b d1		; $8FE218: A5 57
	sta.b mulb		; $8FE21A: 85 83
	jsl.l muls32		; $8FE21C: 22 DB FC 82
	lsr.b mulres+2		; $8FE220: 46 95
	ror a		; $8FE222: 6A
	lsr.b mulres+2		; $8FE223: 46 95
	ror a		; $8FE225: 6A
	lsr.b mulres+2		; $8FE226: 46 95
	ror a		; $8FE228: 6A
	lsr.b mulres+2		; $8FE229: 46 95
	ror a		; $8FE22B: 6A
	lsr.b mulres+2		; $8FE22C: 46 95
	ror a		; $8FE22E: 6A
	sta.b mula		; $8FE22F: 85 7D
	lda.b d7		; $8FE231: A5 6F
	sta.b mulb		; $8FE233: 85 83
	jsl.l muls16		; $8FE235: 22 96 84 80
	adc.w Yvel,x		; $8FE239: 7D FF 0A
	sta.b d1		; $8FE23C: 85 57
	sta.b mula		; $8FE23E: 85 7D
	sta.b mulb		; $8FE240: 85 83
	jsl.l muls32		; $8FE242: 22 DB FC 82
	adc.b d2		; $8FE246: 65 5B
	sta.b d3		; $8FE248: 85 5F
	lda.b mulres+2		; $8FE24A: A5 95
	adc.b d2+2		; $8FE24C: 65 5D
	sta.b d3+2		; $8FE24E: 85 61
	lda.b d1		; $8FE250: A5 57
	pha		; $8FE252: 48
	lda.b d0		; $8FE253: A5 53
	pha		; $8FE255: 48
	jsl.l getpde		; $8FE256: 22 C4 84 80
	lda.w legspd,x		; $8FE25A: BD 7F 0F
	sta.b mula		; $8FE25D: 85 7D
	lda.b d0		; $8FE25F: A5 53
	lsr a		; $8FE261: 4A
	clc		; $8FE262: 18
	adc.w #$0800		; $8FE263: 69 00 08
	sta.b mulb		; $8FE266: 85 83
	jsl.l mulu		; $8FE268: 22 42 89 88
	asl a		; $8FE26C: 0A
	rol.b mulres+2		; $8FE26D: 26 95
	asl a		; $8FE26F: 0A
	rol.b mulres+2		; $8FE270: 26 95
	asl a		; $8FE272: 0A
	rol.b mulres+2		; $8FE273: 26 95
	asl a		; $8FE275: 0A
	rol.b mulres+2		; $8FE276: 26 95
	lda.b mulres+2		; $8FE278: A5 95
	asl a		; $8FE27A: 0A
	asl a		; $8FE27B: 0A
	tax		; $8FE27C: AA
	lda.l MaxSpeed,x		; $8FE27D: BF E7 84 80
	sta.b d2		; $8FE281: 85 5B
	lda.l MaxSpeed+2,x		; $8FE283: BF E9 84 80
	sta.b d2+2		; $8FE287: 85 5D
	ldx.b a3		; $8FE289: A6 3F
	pla		; $8FE28B: 68
	sta.b d0		; $8FE28C: 85 53
	pla		; $8FE28E: 68
	sta.b d1		; $8FE28F: 85 57
	lda.b d2		; $8FE291: A5 5B
	cmp.b d3		; $8FE293: C5 5F
	lda.b d2+2		; $8FE295: A5 5D
	sbc.b d3+2		; $8FE297: E5 61
	bcc .l6		; $8FE299: 90 0A
	lda.b d0		; $8FE29B: A5 53
	sta.w Xvel,x		; $8FE29D: 9D DF 0A
	lda.b d1		; $8FE2A0: A5 57
	sta.w Yvel,x		; $8FE2A2: 9D FF 0A
.l6:
	lda.w OptLine		; $8FE2A5: AD 0C 16
	bne .l10		; $8FE2A8: D0 2E
	lda.w seed		; $8FE2AA: AD A1 04
	and.w #$003F		; $8FE2AD: 29 3F 00
	bne .l10		; $8FE2B0: D0 26
	jsl.l getpde		; $8FE2B2: 22 C4 84 80
	lda.b d0		; $8FE2B6: A5 53
	sec		; $8FE2B8: 38
	sbc.w #$0021		; $8FE2B9: E9 21 00
	sta.b d0		; $8FE2BC: 85 53
	sec		; $8FE2BE: 38
	sbc.w #$0C00		; $8FE2BF: E9 00 0C
	bmi .l8		; $8FE2C2: 30 05
	bvc .l9		; $8FE2C4: 50 05
.l7:
	jmp.w setpde		; $8FE2C6: 4C 6B EE
.l8:
	bvc .l7		; $8FE2C9: 50 FB
.l9:
	lda.w endurance,x		; $8FE2CB: BD 9F 10
	sta.b d2		; $8FE2CE: 85 5B
	clc		; $8FE2D0: 18
	adc.b d0		; $8FE2D1: 65 53
	sta.b d0		; $8FE2D3: 85 53
	jmp.w setpde		; $8FE2D5: 4C 6B EE
.l10:
	rtl		; $8FE2D8: 6B
dirtab8F:		;93G dirtab: x, y acceleration per direction 0-7 (playeracc)
	dw 0,800		; $8FE2D9
	dw 565,565		; $8FE2DD
	dw 800,0		; $8FE2E1
	dw 565,-565		; $8FE2E5
	dw 0,-800		; $8FE2E9
	dw -565,-565		; $8FE2ED
	dw -800,0		; $8FE2F1
	dw -565,565		; $8FE2F5
ClearPenaltyBuffer:		;auto: CODE_8FE2F9. 93G ClearPenaltyBuffer: clear the 32 words of the penalty list (PenBuf)
	lda.w #$001F		; $8FE2F9: A9 1F 00
	sta.b d0		; $8FE2FC: 85 53
	lda.w #PenBuf		; $8FE2FE: A9 9E 12
	sta.b a0		; $8FE301: 85 33
	lda.w #$0000		; $8FE303: A9 00 00
	sta.b a0+2		; $8FE306: 85 35
.l1:
	lda.w #$0000		; $8FE308: A9 00 00
	sta.b [a0]		; $8FE30B: 87 33
	inc.b a0		; $8FE30D: E6 33
	inc.b a0		; $8FE30F: E6 33
	dec.b d0		; $8FE311: C6 53
	bpl .l1		; $8FE313: 10 F3
	rtl		; $8FE315: 6B
randomd0sd0:		;auto: CODE_8FE316. 93G randomd0s with the range in d0: d0 = random -d0..+d0 (randomd0s in bank $80 takes A)
	lda.b d0		; $8FE316: A5 53
	pha		; $8FE318: 48
	asl.b d0		; $8FE319: 06 53
	jsl.l randomd0		; $8FE31B: 22 A3 97 80
	pla		; $8FE31F: 68
	eor.w #$FFFF		; $8FE320: 49 FF FF
	inc a		; $8FE323: 1A
	clc		; $8FE324: 18
	adc.b d0		; $8FE325: 65 53
	sta.b d0		; $8FE327: 85 53
	clc		; $8FE329: 18
	rtl		; $8FE32A: 6B
DefaultMenus:		;auto: CODE_8FE32B (from Start). 93G DefaultMenus: the 7 options at $1600 from .tab; notdemo set
	lda.w #$FFFF		; $8FE32B: A9 FF FF
	sta.w notdemo		; $8FE32E: 8D 0E 16
	lda.w #OptPlayMode		; $8FE331: A9 00 16
	sta.b a0		; $8FE334: 85 33
	lda.w #$0000		; $8FE336: A9 00 00
	sta.b a0+2		; $8FE339: 85 35
	lda.w #.tab		; $8FE33B: A9 5B E3
	sta.b a1		; $8FE33E: 85 37
	lda.w #.tab>>16		; $8FE340: A9 8F 00
	sta.b a1+2		; $8FE343: 85 39
	lda.w #$0006		; $8FE345: A9 06 00
	sta.b d0		; $8FE348: 85 53
.l1:
	lda.b [a1]		; $8FE34A: A7 37
	inc.b a1		; $8FE34C: E6 37
	inc.b a1		; $8FE34E: E6 37
	sta.b [a0]		; $8FE350: 87 33
	inc.b a0		; $8FE352: E6 33
	inc.b a0		; $8FE354: E6 33
	dec.b d0		; $8FE356: C6 53
	bpl .l1		; $8FE358: 10 F0
	rtl		; $8FE35A: 6B
.tab:		;93G DefaultMenus .tab: OptPlayMode, OptPlayers, OptTeam1, OptTeam2, OptPerlen, OptPen, OptLine
	dw $0000,$0001,$000F,$0003,$0001,$0000,$0001		; $8FE35B
checkagr:		;auto: CODE_8FE369. 93G checkagr: d0 = random value by the GGSleft rating of player X (x2 joystick controlled, /2 near the puck): small values call a penalty
	lda.w #$0014		; $8FE369: A9 14 00
	sec		; $8FE36C: 38
	sbc.w GGSleft,x		; $8FE36D: FD BF 10
	asl a		; $8FE370: 0A
	asl a		; $8FE371: 0A
	asl a		; $8FE372: 0A
	asl a		; $8FE373: 0A
	sta.b d0		; $8FE374: 85 53
	lda.w pflags,x		; $8FE376: BD DF 0E
	bit.w #$0008		; $8FE379: 89 08 00
	beq .l1		; $8FE37C: F0 02
	asl.b d0		; $8FE37E: 06 53
.l1:
	lda.w Xpos,x		; $8FE380: BD FF 08
	sec		; $8FE383: 38
	sbc.w puckx		; $8FE384: ED 1B 09
	bit.w #$8000		; $8FE387: 89 00 80
	beq .l2		; $8FE38A: F0 04
	eor.w #$FFFF		; $8FE38C: 49 FF FF
	inc a		; $8FE38F: 1A
.l2:
	cmp.w #$0029		; $8FE390: C9 29 00
	bcs .l4		; $8FE393: B0 17
	lda.w Ypos,x		; $8FE395: BD 5F 09
	sec		; $8FE398: 38
	sbc.w pucky		; $8FE399: ED 7B 09
	bit.w #$8000		; $8FE39C: 89 00 80
	beq .l3		; $8FE39F: F0 04
	eor.w #$FFFF		; $8FE3A1: 49 FF FF
	inc a		; $8FE3A4: 1A
.l3:
	cmp.w #$0029		; $8FE3A5: C9 29 00
	bcs .l4		; $8FE3A8: B0 02
	lsr.b d0		; $8FE3AA: 46 53
.l4:
	jml.l randomd0		; $8FE3AC: 5C A3 97 80
WeightedRandomSelect:		;auto: CODE_8FE3B0. 93G WeightedRandomSelect: d0 = random index 0..d0-1 weighted by the words in nibblebuffer
	lda.b d1+2		; $8FE3B0: A5 59
	pha		; $8FE3B2: 48
	lda.b d1		; $8FE3B3: A5 57
	pha		; $8FE3B5: 48
	lda.b a1+2		; $8FE3B6: A5 39
	pha		; $8FE3B8: 48
	lda.b a1		; $8FE3B9: A5 37
	pha		; $8FE3BB: 48
	lda.w #nibblebuffer		; $8FE3BC: A9 1F 04
	sta.b a1		; $8FE3BF: 85 37
	lda.w #$0000		; $8FE3C1: A9 00 00
	sta.b a1+2		; $8FE3C4: 85 39
	stz.b d1		; $8FE3C6: 64 57
	bra .l2		; $8FE3C8: 80 0B
.l1:
	lda.b d1		; $8FE3CA: A5 57
	clc		; $8FE3CC: 18
	adc.b [a1]		; $8FE3CD: 67 37
	sta.b d1		; $8FE3CF: 85 57
	inc.b a1		; $8FE3D1: E6 37
	inc.b a1		; $8FE3D3: E6 37
.l2:
	dec.b d0		; $8FE3D5: C6 53
	bpl .l1		; $8FE3D7: 10 F1
	lda.b d1		; $8FE3D9: A5 57
	sta.b d0		; $8FE3DB: 85 53
	jsl.l randomd0		; $8FE3DD: 22 A3 97 80
.l3:
	dec.b a1		; $8FE3E1: C6 37
	dec.b a1		; $8FE3E3: C6 37
	lda.b d0		; $8FE3E5: A5 53
	sec		; $8FE3E7: 38
	sbc.b [a1]		; $8FE3E8: E7 37
	sta.b d0		; $8FE3EA: 85 53
	bpl .l3		; $8FE3EC: 10 F3
	lda.b a1		; $8FE3EE: A5 37
	sec		; $8FE3F0: 38
	sbc.w #nibblebuffer		; $8FE3F1: E9 1F 04
	lsr a		; $8FE3F4: 4A
	sta.b d0		; $8FE3F5: 85 53
	pla		; $8FE3F7: 68
	sta.b a1		; $8FE3F8: 85 37
	pla		; $8FE3FA: 68
	sta.b a1+2		; $8FE3FB: 85 39
	pla		; $8FE3FD: 68
	sta.b d1		; $8FE3FE: 85 57
	pla		; $8FE400: 68
	sta.b d1+2		; $8FE401: 85 59
	rtl		; $8FE403: 6B
forceblack:		;auto: CODE_8FE404. 93G forceblack role: the default vblank/IRQ handlers, the sprite VRAM caches reset, wait a frame, empty DMAList
	phx		; $8FE404: DA
	lda.w #$80CE		; $8FE405: A9 CE 80
	sta.b vbint		; $8FE408: 85 14
	lda.w #$83A3		; $8FE40A: A9 A3 83
	sta.b hbint		; $8FE40D: 85 16
	lda.b vcount		; $8FE40F: A5 00
	pha		; $8FE411: 48
	lda.b sprclock		; $8FE412: A5 A7
	sec		; $8FE414: 38
	sbc.w #$003C		; $8FE415: E9 3C 00
	ldx.w #$0000		; $8FE418: A2 00 00
.l1:
	sta.l sprframetime,x		; $8FE41B: 9F 00 20 7E
	inx		; $8FE41F: E8
	inx		; $8FE420: E8
	cpx.w #$4C74		; $8FE421: E0 74 4C
	bne .l1		; $8FE424: D0 F5
	ldx.w #$0000		; $8FE426: A2 00 00
.l2:
	sta.w sprslottime,x		; $8FE429: 9D AB 04
	inx		; $8FE42C: E8
	inx		; $8FE42D: E8
	cpx.w #$0400		; $8FE42E: E0 00 04
	bne .l2		; $8FE431: D0 F6
	pla		; $8FE433: 68
.l3:
	cmp.b vcount		; $8FE434: C5 00
	beq .l3		; $8FE436: F0 FC
	stz.b DMAListend		; $8FE438: 64 A3
	plx		; $8FE43A: FA
	rtl		; $8FE43B: 6B
passmode:		;auto: CODE_8FE43C (from joyplayer). 93G passmode: B held: a dpad direction sets passdir (d0 | 8) before dopass
	lda.b d2		; $8FE43C: A5 5B
	bit.w #$8000		; $8FE43E: 89 00 80
	bne dopass		; $8FE441: D0 15
	lda.b d0		; $8FE443: A5 53
	bit.w #$0008		; $8FE445: 89 08 00
	bne .l1		; $8FE448: D0 0D
	and.w #$0007		; $8FE44A: 29 07 00
	sta.w passdir		; $8FE44D: 8D 3B 04
	ora.w #$0008		; $8FE450: 09 08 00
	sta.b d0		; $8FE453: 85 53
	bra dopass		; $8FE455: 80 01
.l1:
	rtl		; $8FE457: 6B
dopass:		;auto: CODE_8FE458. 93G dopass: pass the puck: the team mate nearest the passdir lane (or passdir), puck velocity, SPA, pfalock
	stx.b xsave		; $8FE458: 86 0A
	ldx.w #$0000		; $8FE45A: A2 00 00
.l1:
	lda.b d0,x		; $8FE45D: B5 53
	pha		; $8FE45F: 48
	inx		; $8FE460: E8
	inx		; $8FE461: E8
	cpx.w #$0018		; $8FE462: E0 18 00
	bne .l1		; $8FE465: D0 F6
	ldx.b xsave		; $8FE467: A6 0A
	stx.b xsave		; $8FE469: 86 0A
	ldx.w #$0000		; $8FE46B: A2 00 00
.l2:
	lda.b a0,x		; $8FE46E: B5 33
	pha		; $8FE470: 48
	inx		; $8FE471: E8
	inx		; $8FE472: E8
	cpx.w #$0008		; $8FE473: E0 08 00
	bne .l2		; $8FE476: D0 F6
	ldx.b xsave		; $8FE478: A6 0A
	lda.w seed+2		; $8FE47A: AD A3 04
	and.w #$0003		; $8FE47D: 29 03 00
	clc		; $8FE480: 18
	adc.w #$0098		; $8FE481: 69 98 00
	pha		; $8FE484: 48
	jsl.l sfx		; $8FE485: 22 8B C2 80
	lda.w #$0004		; $8FE489: A9 04 00
	trb.w sflags		; $8FE48C: 1C 8C 12
	lda.w #$FFFF		; $8FE48F: A9 FF FF
	sta.w puckc		; $8FE492: 8D BB 0E
	lda.w #$0010		; $8FE495: A9 10 00
	sta.w nopuck,x		; $8FE498: 9D 5F 0E
	txa		; $8FE49B: 8A
	lsr a		; $8FE49C: 4A
	sta.w lastplayer		; $8FE49D: 8D 7D 01
	lda.w #$0007		; $8FE4A0: A9 07 00
	sta.b d0		; $8FE4A3: 85 53
	lda.w position,x		; $8FE4A5: BD 9F 0B
	beq .l3		; $8FE4A8: F0 05
	lda.w passacc,x		; $8FE4AA: BD 1F 10
	sta.b d0		; $8FE4AD: 85 53
.l3:
	lda.b d0		; $8FE4AF: A5 53
	asl a		; $8FE4B1: 0A
	asl a		; $8FE4B2: 0A
	adc.w #$0090		; $8FE4B3: 69 90 00
	sta.w passspeed		; $8FE4B6: 8D 3D 04
	lda.w #$FFFF		; $8FE4B9: A9 FF FF
	sta.b d4+2		; $8FE4BC: 85 65
	lda.w #$0005		; $8FE4BE: A9 05 00
	sta.b d3		; $8FE4C1: 85 5F
	stz.b a1		; $8FE4C3: 64 37
	cpx.w #$000C		; $8FE4C5: E0 0C 00
	bcc .l4		; $8FE4C8: 90 05
	lda.w #$000C		; $8FE4CA: A9 0C 00
	sta.b a1		; $8FE4CD: 85 37
.l4:
	cpx.b a1		; $8FE4CF: E4 37
	bne .l5		; $8FE4D1: D0 03
	jmp.w .l9		; $8FE4D3: 4C 82 E5
.l5:
	ldy.b a1		; $8FE4D6: A4 37
	lda.w position,y		; $8FE4D8: B9 9F 0B
	bne .l6		; $8FE4DB: D0 03
	jmp.w .l9		; $8FE4DD: 4C 82 E5
.l6:
	lda.w pflags,y		; $8FE4E0: B9 DF 0E
	bit.w #$1000		; $8FE4E3: 89 00 10
	beq .l7		; $8FE4E6: F0 03
	jmp.w .l9		; $8FE4E8: 4C 82 E5
.l7:
	lda.w Ypos,y		; $8FE4EB: B9 5F 09
	sec		; $8FE4EE: 38
	sbc.w pucky		; $8FE4EF: ED 7B 09
	sta.b d1		; $8FE4F2: 85 57
	pha		; $8FE4F4: 48
	lda.w Xpos,y		; $8FE4F5: B9 FF 08
	sec		; $8FE4F8: 38
	sbc.w puckx		; $8FE4F9: ED 1B 09
	sta.b d0		; $8FE4FC: 85 53
	pha		; $8FE4FE: 48
	jsl.l vtoa		; $8FE4FF: 22 A8 AF 80
	pla		; $8FE503: 68
	sta.b d1		; $8FE504: 85 57
	pla		; $8FE506: 68
	sta.b d2		; $8FE507: 85 5B
	lda.b d0		; $8FE509: A5 53
	sec		; $8FE50B: 38
	sbc.w passdir		; $8FE50C: ED 3B 04
	and.w #$0007		; $8FE50F: 29 07 00
	asl a		; $8FE512: 0A
	asl a		; $8FE513: 0A
	asl a		; $8FE514: 0A
	asl a		; $8FE515: 0A
	asl a		; $8FE516: 0A
	and.w #$00FF		; $8FE517: 29 FF 00
	bit.w #$0080		; $8FE51A: 89 80 00
	beq .l8		; $8FE51D: F0 03
	ora.w #$FF00		; $8FE51F: 09 00 FF
.l8:
	asl a		; $8FE522: 0A
	asl a		; $8FE523: 0A
	asl a		; $8FE524: 0A
	sta.b mula		; $8FE525: 85 7D
	sta.b mulb		; $8FE527: 85 83
	jsl.l muls32		; $8FE529: 22 DB FC 82
	sta.b d0		; $8FE52D: 85 53
	cmp.w #$0001		; $8FE52F: C9 01 00
	lda.b mulres+2		; $8FE532: A5 95
	sta.b d0+2		; $8FE534: 85 55
	sbc.w #$0001		; $8FE536: E9 01 00
	bcs .l9		; $8FE539: B0 47
	lda.b d1		; $8FE53B: A5 57
	sta.b mula		; $8FE53D: 85 7D
	sta.b mulb		; $8FE53F: 85 83
	jsl.l muls32		; $8FE541: 22 DB FC 82
	sta.b d1		; $8FE545: 85 57
	lda.b mulres+2		; $8FE547: A5 95
	sta.b d1+2		; $8FE549: 85 59
	lda.b d2		; $8FE54B: A5 5B
	sta.b mula		; $8FE54D: 85 7D
	sta.b mulb		; $8FE54F: 85 83
	jsl.l muls32		; $8FE551: 22 DB FC 82
	adc.b d1		; $8FE555: 65 57
	sta.b d2		; $8FE557: 85 5B
	lda.b mulres+2		; $8FE559: A5 95
	adc.b d1+2		; $8FE55B: 65 59
	sta.b d2+2		; $8FE55D: 85 5D
	lda.b d2		; $8FE55F: A5 5B
	clc		; $8FE561: 18
	adc.b d0		; $8FE562: 65 53
	sta.b d2		; $8FE564: 85 5B
	lda.b d2+2		; $8FE566: A5 5D
	adc.b d0+2		; $8FE568: 65 55
	sta.b d2+2		; $8FE56A: 85 5D
	lda.b d4		; $8FE56C: A5 63
	cmp.b d2		; $8FE56E: C5 5B
	lda.b d4+2		; $8FE570: A5 65
	sbc.b d2+2		; $8FE572: E5 5D
	bcc .l9		; $8FE574: 90 0C
	lda.b d2		; $8FE576: A5 5B
	sta.b d4		; $8FE578: 85 63
	lda.b d2+2		; $8FE57A: A5 5D
	sta.b d4+2		; $8FE57C: 85 65
	lda.b a1		; $8FE57E: A5 37
	sta.b a0		; $8FE580: 85 33
.l9:
	inc.b a1		; $8FE582: E6 37
	inc.b a1		; $8FE584: E6 37
	dec.b d3		; $8FE586: C6 5F
	bmi .l10		; $8FE588: 30 03
	jmp.w .l4		; $8FE58A: 4C CF E4
.l10:
	lda.b d4+2		; $8FE58D: A5 65
	bmi .l11		; $8FE58F: 30 07
	jsl.l passtoa0		; $8FE591: 22 C4 F8 8F
	jmp.w .l12		; $8FE595: 4C 11 E6
.l11:
	lda.w passdir		; $8FE598: AD 3B 04
	asl a		; $8FE59B: 0A
	asl a		; $8FE59C: 0A
	adc.w #dirtab+2		; $8FE59D: 69 38 AE
	sta.b a0		; $8FE5A0: 85 33
	lda.w #dirtab>>16		; $8FE5A2: A9 80 00
	sta.b a0+2		; $8FE5A5: 85 35
	lda.b [a0]		; $8FE5A7: A7 33
	sta.b mulb		; $8FE5A9: 85 83
	lda.w passspeed		; $8FE5AB: AD 3D 04
	sta.b mula		; $8FE5AE: 85 7D
	jsl.l muls32		; $8FE5B0: 22 DB FC 82
	stz.b mulb		; $8FE5B4: 64 83
	lda.b mulres		; $8FE5B6: A5 93
	sta.b mulb+1		; $8FE5B8: 85 84
	lda.b mulres+2		; $8FE5BA: A5 95
	sta.b mulb+3		; $8FE5BC: 85 86
	asl.b mulb		; $8FE5BE: 06 83
	rol.b mulb+2		; $8FE5C0: 26 85
	asl.b mulb		; $8FE5C2: 06 83
	rol.b mulb+2		; $8FE5C4: 26 85
	lda.w #$0BB8		; $8FE5C6: A9 B8 0B
	sta.b mula		; $8FE5C9: 85 7D
	jsl.l divs		; $8FE5CB: 22 6C 99 80
	adc.w Yvel,x		; $8FE5CF: 7D FF 0A
	sta.w puckvy		; $8FE5D2: 8D 1B 0B
	dec.b a0		; $8FE5D5: C6 33
	dec.b a0		; $8FE5D7: C6 33
	lda.b [a0]		; $8FE5D9: A7 33
	sta.b mulb		; $8FE5DB: 85 83
	lda.w passspeed		; $8FE5DD: AD 3D 04
	sta.b mula		; $8FE5E0: 85 7D
	jsl.l muls32		; $8FE5E2: 22 DB FC 82
	stz.b mulb		; $8FE5E6: 64 83
	lda.b mulres		; $8FE5E8: A5 93
	sta.b mulb+1		; $8FE5EA: 85 84
	lda.b mulres+2		; $8FE5EC: A5 95
	sta.b mulb+3		; $8FE5EE: 85 86
	asl.b mulb		; $8FE5F0: 06 83
	rol.b mulb+2		; $8FE5F2: 26 85
	asl.b mulb		; $8FE5F4: 06 83
	rol.b mulb+2		; $8FE5F6: 26 85
	lda.w #$0BB8		; $8FE5F8: A9 B8 0B
	sta.b mula		; $8FE5FB: 85 7D
	jsl.l divs		; $8FE5FD: 22 6C 99 80
	adc.w Xvel,x		; $8FE601: 7D DF 0A
	sta.w puckvx		; $8FE604: 8D FB 0A
	lda.w #$1000		; $8FE607: A9 00 10
	jsl.l randoma		; $8FE60A: 22 8B AE 80
	sta.w puckvz		; $8FE60E: 8D 3B 0B
.l12:
	lda.w position,x		; $8FE611: BD 9F 0B
	bne .l15		; $8FE614: D0 18
	lda.w pfgoal,x		; $8FE616: BD 3F 11
	beq .l13		; $8FE619: F0 07
	lda.w puckvy		; $8FE61B: AD 1B 0B
	bmi .l14		; $8FE61E: 30 07
	bra .l15		; $8FE620: 80 0C
.l13:
	lda.w puckvy		; $8FE622: AD 1B 0B
	bmi .l15		; $8FE625: 30 07
.l14:
	eor.w #$FFFF		; $8FE627: 49 FF FF
	inc a		; $8FE62A: 1A
	sta.w puckvy		; $8FE62B: 8D 1B 0B
.l15:
	lda.w puckvx		; $8FE62E: AD FB 0A
	sta.b d0		; $8FE631: 85 53
	lda.w puckvy		; $8FE633: AD 1B 0B
	sta.b d1		; $8FE636: 85 57
	jsl.l vtoa		; $8FE638: 22 A8 AF 80
	lda.w #$02D2		; $8FE63C: A9 D2 02
	sta.b d1		; $8FE63F: 85 57
	lda.w position,x		; $8FE641: BD 9F 0B
	beq .l16		; $8FE644: F0 10
	lda.w #$06C4		; $8FE646: A9 C4 06
	sta.b d1		; $8FE649: 85 57
	jsl.l Findhittype		; $8FE64B: 22 03 F6 8F
	beq .l16		; $8FE64F: F0 05
	lda.w #$0736		; $8FE651: A9 36 07
	sta.b d1		; $8FE654: 85 57
.l16:
	jsl.l SetSPA		; $8FE656: 22 06 B0 80
	lda.w #$0001		; $8FE65A: A9 01 00
	sta.w pfalock,x		; $8FE65D: 9D 7F 11
	stx.b xsave		; $8FE660: 86 0A
	ldx.w #$0006		; $8FE662: A2 06 00
.l17:
	pla		; $8FE665: 68
	sta.b a0,x		; $8FE666: 95 33
	dex		; $8FE668: CA
	dex		; $8FE669: CA
	bpl .l17		; $8FE66A: 10 F9
	ldx.b xsave		; $8FE66C: A6 0A
	stx.b xsave		; $8FE66E: 86 0A
	ldx.w #$0016		; $8FE670: A2 16 00
.l18:
	pla		; $8FE673: 68
	sta.b d0,x		; $8FE674: 95 53
	dex		; $8FE676: CA
	dex		; $8FE677: CA
	bpl .l18		; $8FE678: 10 F9
	ldx.b xsave		; $8FE67A: A6 0A
	rtl		; $8FE67C: 6B
FrameSetTable:		;SNES: long pointers to the 15 sprite frame sets (addframe), then a 0 entry
	dd SpriteSet0		; $8FE67D
	dd SpriteSet1		; $8FE681
	dd SpriteSet2		; $8FE685
	dd SpriteSet3		; $8FE689
	dd SpriteSet4		; $8FE68D
	dd SpriteSet5		; $8FE691
	dd SpriteSet6		; $8FE695
	dd SpriteSet7		; $8FE699
	dd SpriteSet8		; $8FE69D
	dd SpriteSet9		; $8FE6A1
	dd SpriteSet10		; $8FE6A5
	dd SpriteSet11		; $8FE6A9
	dd SpriteSet12		; $8FE6AD
	dd SpriteSet13		; $8FE6B1
	dd SpriteSet14		; $8FE6B5
	dd 0		; $8FE6B9 end
CompLine:		;auto: CODE_8FE6BD (from setpersonel). 93G CompLine: the computer team picks a line by the man advantage, the score late in the game and the line energies (getlinee)
	stx.b xsave		; $8FE6BD: 86 0A
	ldx.w #$0000		; $8FE6BF: A2 00 00
.l1:
	lda.b d0,x		; $8FE6C2: B5 53
	pha		; $8FE6C4: 48
	inx		; $8FE6C5: E8
	inx		; $8FE6C6: E8
	cpx.w #$000C		; $8FE6C7: E0 0C 00
	bne .l1		; $8FE6CA: D0 F6
	ldx.b xsave		; $8FE6CC: A6 0A
	stx.b xsave		; $8FE6CE: 86 0A
	ldx.w #$0000		; $8FE6D0: A2 00 00
.l2:
	lda.b a0,x		; $8FE6D3: B5 33
	pha		; $8FE6D5: 48
	inx		; $8FE6D6: E8
	inx		; $8FE6D7: E8
	cpx.w #$0004		; $8FE6D8: E0 04 00
	bne .l2		; $8FE6DB: D0 F6
	ldx.b xsave		; $8FE6DD: A6 0A
	lda.w #$0003		; $8FE6DF: A9 03 00
	sta.b d0		; $8FE6E2: 85 53
	ldy.b a2		; $8FE6E4: A4 3B
	lda.w tmap,y		; $8FE6E6: B9 EE 13
	ldy.b a1		; $8FE6E9: A4 37
	cmp.w tmap,y		; $8FE6EB: D9 EE 13
	beq .l10		; $8FE6EE: F0 4D
	bpl .l3		; $8FE6F0: 10 04
	inc.b d0		; $8FE6F2: E6 53
	inc.b d0		; $8FE6F4: E6 53
.l3:
	lda.b d0		; $8FE6F6: A5 53
	pha		; $8FE6F8: 48
	jsl.l getlinee		; $8FE6F9: 22 05 84 88
	lda.b d0		; $8FE6FD: A5 53
	sta.b d1		; $8FE6FF: 85 57
	lda.b $01,s		; $8FE701: A3 01
	inc a		; $8FE703: 1A
	sta.b d0		; $8FE704: 85 53
	jsl.l getlinee		; $8FE706: 22 05 84 88
	lda.b d1		; $8FE70A: A5 57
	sec		; $8FE70C: 38
	sbc.b d0		; $8FE70D: E5 53
	bmi .l4		; $8FE70F: 30 04
	bvs .l5		; $8FE711: 70 04
	bra .l6		; $8FE713: 80 05
.l4:
	bvs .l6		; $8FE715: 70 03
.l5:
	pla		; $8FE717: 68
	inc a		; $8FE718: 1A
	pha		; $8FE719: 48
.l6:
	pla		; $8FE71A: 68
	ldy.b a2		; $8FE71B: A4 3B
	sta.w tmline,y		; $8FE71D: 99 DE 13
.l7:
	stx.b xsave		; $8FE720: 86 0A
	ldx.w #$0002		; $8FE722: A2 02 00
.l8:
	pla		; $8FE725: 68
	sta.b a0,x		; $8FE726: 95 33
	dex		; $8FE728: CA
	dex		; $8FE729: CA
	bpl .l8		; $8FE72A: 10 F9
	ldx.b xsave		; $8FE72C: A6 0A
	stx.b xsave		; $8FE72E: 86 0A
	ldx.w #$000A		; $8FE730: A2 0A 00
.l9:
	pla		; $8FE733: 68
	sta.b d0,x		; $8FE734: 95 53
	dex		; $8FE736: CA
	dex		; $8FE737: CA
	bpl .l9		; $8FE738: 10 F9
	ldx.b xsave		; $8FE73A: A6 0A
	rtl		; $8FE73C: 6B
.l10:
	ldy.b a2		; $8FE73D: A4 3B
	bne .l12		; $8FE73F: D0 7C
	lda.w #$0002		; $8FE741: A9 02 00
	sta.b d1		; $8FE744: 85 57
	lda.w #.tie		; $8FE746: A9 93 E7
	sta.b a0		; $8FE749: 85 33
	lda.w #.tie>>16		; $8FE74B: A9 8F 00
	sta.b a0+2		; $8FE74E: 85 35
	lda.w gsp		; $8FE750: AD F0 12
	cmp.w #$0002		; $8FE753: C9 02 00
	bne .l11		; $8FE756: D0 18
	lda.w tmscore,y		; $8FE758: B9 D6 13
	ldy.b a1		; $8FE75B: A4 37
	cmp.w tmscore,y		; $8FE75D: D9 D6 13
	beq .l11		; $8FE760: F0 0E
	php		; $8FE762: 08
	lda.w #.ahead		; $8FE763: A9 A1 E7
	sta.b a0		; $8FE766: 85 33
	plp		; $8FE768: 28
	bpl .l11		; $8FE769: 10 05
	lda.w #.behind		; $8FE76B: A9 AF E7
	sta.b a0		; $8FE76E: 85 33
.l11:
	ldy.b a1		; $8FE770: A4 37
	lda.w tmline,y		; $8FE772: B9 DE 13
	asl a		; $8FE775: 0A
	sta.b d1		; $8FE776: 85 57
	tay		; $8FE778: A8
	lda.b [a0],y		; $8FE779: B7 33
	sta.b d0		; $8FE77B: 85 53
	jsl.l getlinee		; $8FE77D: 22 05 84 88
	lda.b d0		; $8FE781: A5 53
	cmp.w #$0C01		; $8FE783: C9 01 0C
	bcc .l12		; $8FE786: 90 35
	ldy.b d1		; $8FE788: A4 57
	lda.b [a0],y		; $8FE78A: B7 33
	ldy.b a2		; $8FE78C: A4 3B
	sta.w tmline,y		; $8FE78E: 99 DE 13
	bra .l7		; $8FE791: 80 8D
.tie:		;93G CompLine tables: next line by tmline, score tied (7 words)
	dw 0,1,2,0,1,0,1		; $8FE793
.ahead:		;ahead in the third period
	dw 2,0,1,2,0,2,0		; $8FE7A1
.behind:		;behind in the third period
	dw 0,1,0,0,1,0,1		; $8FE7AF
.l12:
	lda.w #$0002		; $8FE7BD: A9 02 00
	sta.b d1		; $8FE7C0: 85 57
	lda.w #.tie2		; $8FE7C2: A9 13 E8
	sta.b a0		; $8FE7C5: 85 33
	lda.w #.tie2>>16		; $8FE7C7: A9 8F 00
	sta.b a0+2		; $8FE7CA: 85 35
	lda.w gsp		; $8FE7CC: AD F0 12
	cmp.w #$0002		; $8FE7CF: C9 02 00
	bne .l13		; $8FE7D2: D0 1A
	ldy.b a2		; $8FE7D4: A4 3B
	lda.w tmscore,y		; $8FE7D6: B9 D6 13
	ldy.b a1		; $8FE7D9: A4 37
	cmp.w tmscore,y		; $8FE7DB: D9 D6 13
	beq .l13		; $8FE7DE: F0 0E
	php		; $8FE7E0: 08
	lda.w #.ahead2		; $8FE7E1: A9 19 E8
	sta.b a0		; $8FE7E4: 85 33
	plp		; $8FE7E6: 28
	bpl .l13		; $8FE7E7: 10 05
	lda.w #.behind2		; $8FE7E9: A9 1F E8
	sta.b a0		; $8FE7EC: 85 33
.l13:
	lda.b [a0]		; $8FE7EE: A7 33
	inc.b a0		; $8FE7F0: E6 33
	inc.b a0		; $8FE7F2: E6 33
	sta.b d0		; $8FE7F4: 85 53
	jsl.l getlinee		; $8FE7F6: 22 05 84 88
	lda.b d0		; $8FE7FA: A5 53
	cmp.w #$0F34		; $8FE7FC: C9 34 0F
	bcs .l14		; $8FE7FF: B0 04
	dec.b d1		; $8FE801: C6 57
	bpl .l13		; $8FE803: 10 E9
.l14:
	dec.b a0		; $8FE805: C6 33
	dec.b a0		; $8FE807: C6 33
	ldy.b a2		; $8FE809: A4 3B
	lda.b [a0]		; $8FE80B: A7 33
	sta.w tmline,y		; $8FE80D: 99 DE 13
	jmp.w .l7		; $8FE810: 4C 20 E7
.tie2:		;the lines tried on a power play / penalty kill (3 words each)
	dw 0,1,2		; $8FE813
.ahead2:
	dw 0,2,1		; $8FE819
.behind2:
	dw 0,1,0		; $8FE81F
TeamRoster:		;auto: CODE_8FE825 (pause menu). SNES Team Roster screen: the team block, each line's players and an attribute; dpad moves, Y switches team, Start leaves
	jsl.l forceblack		; $8FE825: 22 04 E4 8F
	sep #$20		; $8FE829: E2 20
	stz.w BG1HOFS		; $8FE82B: 9C 0D 21
	stz.w BG1HOFS		; $8FE82E: 9C 0D 21
	stz.w BG1VOFS		; $8FE831: 9C 0E 21
	stz.w BG1VOFS		; $8FE834: 9C 0E 21
	stz.w BG2HOFS		; $8FE837: 9C 0F 21
	stz.w BG2HOFS		; $8FE83A: 9C 0F 21
	stz.w BG2VOFS		; $8FE83D: 9C 10 21
	stz.w BG2VOFS		; $8FE840: 9C 10 21
	lda.b #$00		; $8FE843: A9 00
	sta.w BG1SC		; $8FE845: 8D 07 21
	lda.b #$04		; $8FE848: A9 04
	sta.w BG2SC		; $8FE84A: 8D 08 21
	lda.b #$44		; $8FE84D: A9 44
	sta.w BG12NBA		; $8FE84F: 8D 0B 21
	lda.b #$03		; $8FE852: A9 03
	sta.w TM		; $8FE854: 8D 2C 21
	rep #$30		; $8FE857: C2 30
	lda.w #$FD00		; $8FE859: A9 00 FD
	sta.w charofs		; $8FE85C: 8D CD 1B
	sta.w charofs2		; $8FE85F: 8D CF 1B
	sta.w printfontset		; $8FE862: 8D CB 1B
	stz.b printm		; $8FE865: 64 D4
	lda.w smallfontchars		; $8FE867: AD D7 1B
	asl a		; $8FE86A: 0A
	asl a		; $8FE86B: 0A
	asl a		; $8FE86C: 0A
	asl a		; $8FE86D: 0A
	adc.w #$1000		; $8FE86E: 69 00 10
	sta.w VMADDL		; $8FE871: 8D 16 21
	lda.w #SmallFontTiles		; $8FE874: A9 D8 C6
	sta.b tmp0		; $8FE877: 85 73
	lda.w #SmallFontTiles>>16		; $8FE879: A9 83 00
	sta.b tmp1		; $8FE87C: 85 75
	jsl.l DecompressGraphics		; $8FE87E: 22 3E FA 86
	stz.b a0		; $8FE882: 64 33
	lda.w #$007F		; $8FE884: A9 7F 00
	sta.b a0+2		; $8FE887: 85 35
	lda.w #PixelRemap8F		; $8FE889: A9 54 E1
	sta.b a1		; $8FE88C: 85 37
	lda.w #PixelRemap8F>>16		; $8FE88E: A9 8F 00
	sta.b a1+2		; $8FE891: 85 39
	lda.w #$0064		; $8FE893: A9 64 00
	sta.b d0		; $8FE896: 85 53
	jsl.l RemapTiles		; $8FE898: 22 E4 E0 8F
	ldx.w #$0000		; $8FE89C: A2 00 00
.l1:
	lda.l FramerTiles,x		; $8FE89F: BF 2E 87 88
	sta.w VMDATAL		; $8FE8A3: 8D 18 21
	inx		; $8FE8A6: E8
	inx		; $8FE8A7: E8
	cpx.w #$0080		; $8FE8A8: E0 80 00
	bne .l1		; $8FE8AB: D0 F2
	lda.w scorechars		; $8FE8AD: AD E5 1B
	asl a		; $8FE8B0: 0A
	asl a		; $8FE8B1: 0A
	asl a		; $8FE8B2: 0A
	asl a		; $8FE8B3: 0A
	adc.w #$1000		; $8FE8B4: 69 00 10
	sta.w VMADDL		; $8FE8B7: 8D 16 21
	lda.w #TeamBlocksTiles		; $8FE8BA: A9 73 9B
	sta.b tmp0		; $8FE8BD: 85 73
	lda.w #TeamBlocksTiles>>16		; $8FE8BF: A9 88 00
	sta.b tmp1		; $8FE8C2: 85 75
	jsl.l DecompressGraphics		; $8FE8C4: 22 3E FA 86
	ldx.w #$0000		; $8FE8C8: A2 00 00
.l2:
	lda.l TestList,x		; $8FE8CB: BF 00 00 7F
	sta.w VMDATAL		; $8FE8CF: 8D 18 21
	inx		; $8FE8D2: E8
	inx		; $8FE8D3: E8
	cpx.w #$32A0		; $8FE8D4: E0 A0 32
	bne .l2		; $8FE8D7: D0 F2
	lda.w #EASNMap		; $8FE8D9: A9 A0 C3
	sta.b tmp0		; $8FE8DC: 85 73
	lda.w #EASNMap>>16		; $8FE8DE: A9 87 00
	sta.b tmp1		; $8FE8E1: 85 75
	jsl.l DecompressGraphics		; $8FE8E3: 22 3E FA 86
	ldx.w #$0000		; $8FE8E7: A2 00 00
.l3:
	lda.l TestList+$400,x		; $8FE8EA: BF 00 04 7F
	sta.w VMDATAL		; $8FE8EE: 8D 18 21
	inx		; $8FE8F1: E8
	inx		; $8FE8F2: E8
	cpx.w #$04A0		; $8FE8F3: E0 A0 04
	bne .l3		; $8FE8F6: D0 F2
	ldx.w #$03FE		; $8FE8F8: A2 FE 03
.l4:
	lda.l TestList,x		; $8FE8FB: BF 00 00 7F
	clc		; $8FE8FF: 18
	adc.w ExtraChars		; $8FE900: 6D D5 1B
	clc		; $8FE903: 18
	adc.w charofs2		; $8FE904: 6D CF 1B
	sta.l backmap,x		; $8FE907: 9F 74 76 7E
	sta.l backmap+$400,x		; $8FE90B: 9F 74 7A 7E
	dex		; $8FE90F: CA
	dex		; $8FE910: CA
	bpl .l4		; $8FE911: 10 E8
	lda.w #RonBarrMap		; $8FE913: A9 38 ED
	sta.b tmp0		; $8FE916: 85 73
	lda.w #RonBarrMap>>16		; $8FE918: A9 80 00
	sta.b tmp1		; $8FE91B: 85 75
	jsl.l DecompressGraphics		; $8FE91D: 22 3E FA 86
	sep #$20		; $8FE921: E2 20
	stz.w CGADD		; $8FE923: 9C 21 21
	ldx.w #$0000		; $8FE926: A2 00 00
.l5:
	lda.l TestList+$90,x		; $8FE929: BF 90 00 7F
	sta.w CGDATA		; $8FE92D: 8D 22 21
	inx		; $8FE930: E8
	cpx.w #$0080		; $8FE931: E0 80 00
	bne .l5		; $8FE934: D0 F3
	rep #$30		; $8FE936: C2 30
	stz.b a2		; $8FE938: 64 3B
	lda.w cont1team		; $8FE93A: AD 96 12
	sta.b tmp0		; $8FE93D: 85 73
	lda.w sflags		; $8FE93F: AD 8C 12
	bit.w #$0002		; $8FE942: 89 02 00
	beq .l6		; $8FE945: F0 05
	lda.w cont2team		; $8FE947: AD 98 12
	sta.b tmp0		; $8FE94A: 85 73
.l6:
	lda.b tmp0		; $8FE94C: A5 73
	cmp.w #$0002		; $8FE94E: C9 02 00
	bne .l7		; $8FE951: D0 05
	lda.w #$0002		; $8FE953: A9 02 00
	sta.b a2		; $8FE956: 85 3B
.l7:
	ldy.b a2		; $8FE958: A4 3B
	lda.w tmline,y		; $8FE95A: B9 DE 13
	inc a		; $8FE95D: 1A
	sta.b d0		; $8FE95E: 85 53
	sta.w SelectedPlayerIdx		; $8FE960: 8D ED 08
	stz.w DispAttribCtr		; $8FE963: 9C F1 08
.l8:
	jsl.l printz		; $8FE966: 22 0C B9 80
	dw $0005		; $8FE96A  printz inline string: length (counts itself), then control bytes / text
	db $FE,$03,$01
	lda.w #$001A		; $8FE96F: A9 1A 00
	sta.b d0		; $8FE972: 85 53
	lda.w #$0006		; $8FE974: A9 06 00
	sta.b d1		; $8FE977: 85 57
	jsl.l Framer		; $8FE979: 22 9F D6 8F
	lda.w blankchar		; $8FE97D: AD E7 1B
	clc		; $8FE980: 18
	adc.w charofs		; $8FE981: 6D CD 1B
	ldx.w #$07FE		; $8FE984: A2 FE 07
.l9:
	sta.l textmap,x		; $8FE987: 9F 74 6E 7E
	dex		; $8FE98B: CA
	dex		; $8FE98C: CA
	bpl .l9		; $8FE98D: 10 F8
	jsl.l printz8B		; $8FE98F: 22 BF FD 82
	dw $0014		; $8FE993  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$04,"Team  Roster",$BF,$0B,$01
	lda.w HomeTeam		; $8FE9A7: AD 9A 12
	sta.b d1		; $8FE9AA: 85 57
	lda.b a2		; $8FE9AC: A5 3B
	beq .l10		; $8FE9AE: F0 08
	lda.w VisTeam		; $8FE9B0: AD 9C 12
	sta.b d1		; $8FE9B3: 85 57
	lda.w #$0030		; $8FE9B5: A9 30 00
.l10:
	sta.b d0		; $8FE9B8: 85 53
	jsl.l DrawTeamBlocks		; $8FE9BA: 22 E2 84 8D
	jsl.l printz		; $8FE9BE: 22 0C B9 80
	dw $0017		; $8FE9C2  printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$0C,"Player",$9F,$18,$0C,"Rating",$BE,$01,$08
	lda.w #$000F		; $8FE9D9: A9 0F 00
	sta.b d0		; $8FE9DC: 85 53
	lda.w #$0003		; $8FE9DE: A9 03 00
	sta.b d1		; $8FE9E1: 85 57
	jsl.l Framer		; $8FE9E3: 22 9F D6 8F
	jsl.l printz		; $8FE9E7: 22 0C B9 80
	dw $0005		; $8FE9EB  printz inline string: length (counts itself), then control bytes / text
	db $BE,$10,$08
	lda.w #$000F		; $8FE9F0: A9 0F 00
	sta.b d0		; $8FE9F3: 85 53
	lda.w #$0003		; $8FE9F5: A9 03 00
	sta.b d1		; $8FE9F8: 85 57
	jsl.l Framer		; $8FE9FA: 22 9F D6 8F
	jsl.l .show		; $8FE9FE: 22 96 EA 8F
.l11:
	lda.w #textmap		; $8FEA02: A9 74 6E
	sta.w DMAList		; $8FEA05: 8D 53 16
	lda.w #textmap>>16		; $8FEA08: A9 7E 00
	sta.w DMAList+dmabank		; $8FEA0B: 8D 55 16
	lda.w #$1000		; $8FEA0E: A9 00 10
	sta.w DMAList+dmalen		; $8FEA11: 8D 56 16
	stz.w DMAList+dmavram		; $8FEA14: 9C 58 16
	lda.w #$0007		; $8FEA17: A9 07 00
	sta.b DMAListend		; $8FEA1A: 85 A3
	lda.w #$8250		; $8FEA1C: A9 50 82
	sta.b vbint		; $8FEA1F: 85 14
.l12:
	cmp.b vbint		; $8FEA21: C5 14
	beq .l12		; $8FEA23: F0 FC
	jsl.l ReadPads		; $8FEA25: 22 E8 F3 80
	jsl.l getpzjoy		; $8FEA29: 22 0E FF 85
	jsl.l ProcessInputWithRepeat		; $8FEA2D: 22 53 FC 86
	lda.b d1		; $8FEA31: A5 57
	bit.w #$1000		; $8FEA33: 89 00 10
	beq .l13		; $8FEA36: F0 03
	jmp.w .l26		; $8FEA38: 4C DF EB
.l13:
	bit.w #$4000		; $8FEA3B: 89 00 40
	bne .l17		; $8FEA3E: D0 4C
	stz.b d0		; $8FEA40: 64 53
	inc.b d0		; $8FEA42: E6 53
	bit.w #$0100		; $8FEA44: 89 00 01
	bne .l16		; $8FEA47: D0 30
	dec.b d0		; $8FEA49: C6 53
	dec.b d0		; $8FEA4B: C6 53
	bit.w #$0200		; $8FEA4D: 89 00 02
	bne .l16		; $8FEA50: D0 27
	bit.w #$0800		; $8FEA52: 89 00 08
	bne .l14		; $8FEA55: D0 09
	inc.b d0		; $8FEA57: E6 53
	inc.b d0		; $8FEA59: E6 53
	bit.w #$0400		; $8FEA5B: 89 00 04
	beq .l15		; $8FEA5E: F0 16
.l14:
	lda.b d0		; $8FEA60: A5 53
	clc		; $8FEA62: 18
	adc.w SelectedPlayerIdx		; $8FEA63: 6D ED 08
	sta.b d0		; $8FEA66: 85 53
	bmi .l15		; $8FEA68: 30 0C
	cmp.w #$0008		; $8FEA6A: C9 08 00
	bcs .l15		; $8FEA6D: B0 07
	sta.w SelectedPlayerIdx		; $8FEA6F: 8D ED 08
	jsl.l .show		; $8FEA72: 22 96 EA 8F
.l15:
	jmp.w .l11		; $8FEA76: 4C 02 EA
.l16:
	lda.b d0		; $8FEA79: A5 53
	clc		; $8FEA7B: 18
	adc.w DispAttribCtr		; $8FEA7C: 6D F1 08
	sta.b d0		; $8FEA7F: 85 53
	bmi .l15		; $8FEA81: 30 F3
	sta.w DispAttribCtr		; $8FEA83: 8D F1 08
	jsl.l .show		; $8FEA86: 22 96 EA 8F
	bra .l15		; $8FEA8A: 80 EA
.l17:
	lda.b a2		; $8FEA8C: A5 3B
	eor.w #$0002		; $8FEA8E: 49 02 00
	sta.b a2		; $8FEA91: 85 3B
	jmp.w .l8		; $8FEA93: 4C 66 E9
.show:		;print the selected line and attribute column
	jsl.l printz		; $8FEA96: 22 0C B9 80
	dw $0005		; $8FEA9A  printz inline string: length (counts itself), then control bytes / text
	db $9F,$02,$09
	lda.w SelectedPlayerIdx		; $8FEA9F: AD ED 08
	sta.b d0		; $8FEAA2: 85 53
	lda.w #RosterLineNames		; $8FEAA4: A9 F0 EB
	sta.b a1		; $8FEAA7: 85 37
	lda.w #RosterLineNames>>16		; $8FEAA9: A9 8F 00
	sta.b a1+2		; $8FEAAC: 85 39
	jsl.l AdvanceStringPtr		; $8FEAAE: 22 93 D7 8F
	jsl.l print		; $8FEAB2: 22 2D B9 80
	lda.w #$0011		; $8FEAB6: A9 11 00
	sta.w printx		; $8FEAB9: 8D 7B 04
	lda.w #$0009		; $8FEABC: A9 09 00
	sta.w printy		; $8FEABF: 8D 7D 04
.l18:
	lda.w #AttribMenuSkater		; $8FEAC2: A9 A1 D7
	sta.b a1		; $8FEAC5: 85 37
	lda.w #AttribMenuSkater>>16		; $8FEAC7: A9 8F 00
	sta.b a1+2		; $8FEACA: 85 39
	lda.w DispAttribCtr		; $8FEACC: AD F1 08
	sta.b d0		; $8FEACF: 85 53
	lda.w SelectedPlayerIdx		; $8FEAD1: AD ED 08
	bne .l20		; $8FEAD4: D0 16
	lda.w #AttribMenuGoalie		; $8FEAD6: A9 E6 D8
	sta.b a1		; $8FEAD9: 85 37
	lda.w #AttribMenuGoalie>>16		; $8FEADB: A9 8F 00
	sta.b a1+2		; $8FEADE: 85 39
	bra .l20		; $8FEAE0: 80 0A
.l19:
	lda.b a1		; $8FEAE2: A5 37
	clc		; $8FEAE4: 18
	adc.b [a1]		; $8FEAE5: 67 37
	adc.w #$0004		; $8FEAE7: 69 04 00
	sta.b a1		; $8FEAEA: 85 37
.l20:
	lda.b [a1]		; $8FEAEC: A7 37
	bmi .l21		; $8FEAEE: 30 04
	dec.b d0		; $8FEAF0: C6 53
	bpl .l19		; $8FEAF2: 10 EE
.l21:
	lda.b [a1]		; $8FEAF4: A7 37
	bpl .l22		; $8FEAF6: 10 05
	dec.w DispAttribCtr		; $8FEAF8: CE F1 08
	bra .l18		; $8FEAFB: 80 C5
.l22:
	jsl.l print		; $8FEAFD: 22 2D B9 80
	lda.b [a1]		; $8FEB01: A7 37
	sta.b d4+2		; $8FEB03: 85 65
	ldy.w #$0002		; $8FEB05: A0 02 00
	lda.b [a1],y		; $8FEB08: B7 37
	sta.b d4		; $8FEB0A: 85 63
	jsl.l printz		; $8FEB0C: 22 0C B9 80
	dw $0005		; $8FEB10  printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0D
	lda.w #$0020		; $8FEB15: A9 20 00
	sta.b d0		; $8FEB18: 85 53
	lda.w #$0013		; $8FEB1A: A9 13 00
	sta.b d1		; $8FEB1D: 85 57
	lda.w blankchar		; $8FEB1F: AD E7 1B
	sta.b d2		; $8FEB22: 85 5B
	jsl.l eraser		; $8FEB24: 22 7C 84 8D
	jsl.l printz		; $8FEB28: 22 0C B9 80
	dw $0018		; $8FEB2C  printz inline string: length (counts itself), then control bytes / text
	db $9F,$08,$1A,"Y - Switch Teams",$BF,$00,$0E
	jsl.l GoalieCount		; $8FEB44: 22 6B D7 8F
	lda.b d0		; $8FEB48: A5 53
	dec a		; $8FEB4A: 3A
	sta.b d1		; $8FEB4B: 85 57
	lda.w #RosterG		; $8FEB4D: A9 E4 EB
	sta.b a4+4		; $8FEB50: 85 47
	lda.w #RosterG>>16		; $8FEB52: A9 8F 00
	sta.b a4+6		; $8FEB55: 85 49
	lda.w #RosterGoalies		; $8FEB57: A9 E0 EB
	sta.b a3		; $8FEB5A: 85 3F
	lda.w #RosterGoalies>>16		; $8FEB5C: A9 8F 00
	sta.b a3+2		; $8FEB5F: 85 41
	lda.w SelectedPlayerIdx		; $8FEB61: AD ED 08
	dec a		; $8FEB64: 3A
	sta.b d0		; $8FEB65: 85 53
	bmi .l25		; $8FEB67: 30 3E
	asl a		; $8FEB69: 0A
	asl a		; $8FEB6A: 0A
	asl a		; $8FEB6B: 0A
	sta.b d0		; $8FEB6C: 85 53
	ldy.b a2		; $8FEB6E: A4 3B
	lda.w #$0083		; $8FEB70: A9 83 00
	sta.b a3+2		; $8FEB73: 85 41
	lda.w tmdata,y		; $8FEB75: B9 CE 13
	sta.b a3		; $8FEB78: 85 3F
	ldy.w #$0006		; $8FEB7A: A0 06 00
	clc		; $8FEB7D: 18
	adc.b [a3],y		; $8FEB7E: 77 3F
	sec		; $8FEB80: 38
	adc.b d0		; $8FEB81: 65 53
	sta.b a3		; $8FEB83: 85 3F
	lda.w #PositionNames		; $8FEB85: A9 CC D9
	sta.b a4+4		; $8FEB88: 85 47
	lda.w #PositionNames>>16		; $8FEB8A: A9 8F 00
	sta.b a4+6		; $8FEB8D: 85 49
	lda.w #$0004		; $8FEB8F: A9 04 00
	sta.b d1		; $8FEB92: 85 57
	lda.w SelectedPlayerIdx		; $8FEB94: AD ED 08
	sec		; $8FEB97: 38
	sbc.w #$0005		; $8FEB98: E9 05 00
	beq .l25		; $8FEB9B: F0 0A
	bmi .l23		; $8FEB9D: 30 04
	bvc .l24		; $8FEB9F: 50 04
	bra .l25		; $8FEBA1: 80 04
.l23:
	bvc .l25		; $8FEBA3: 50 02
.l24:
	dec.b d1		; $8FEBA5: C6 57
.l25:
	lda.w #$0002		; $8FEBA7: A9 02 00
	sta.w printx		; $8FEBAA: 8D 7B 04
	lda.b a4+4		; $8FEBAD: A5 47
	sta.b a1		; $8FEBAF: 85 37
	lda.b a4+6		; $8FEBB1: A5 49
	sta.b a1+2		; $8FEBB3: 85 39
	jsl.l print		; $8FEBB5: 22 2D B9 80
	lda.b a1		; $8FEBB9: A5 37
	sta.b a4+4		; $8FEBBB: 85 47
	lda.b a1+2		; $8FEBBD: A5 39
	sta.b a4+6		; $8FEBBF: 85 49
	lda.w #$0005		; $8FEBC1: A9 05 00
	sta.w printx		; $8FEBC4: 8D 7B 04
	lda.b [a3]		; $8FEBC7: A7 3F
	inc.b a3		; $8FEBC9: E6 3F
	and.w #$00FF		; $8FEBCB: 29 FF 00
	dec a		; $8FEBCE: 3A
	sta.b d0		; $8FEBCF: 85 53
	jsl.l GetNameandAttrib		; $8FEBD1: 22 44 FC 84
	inc.w printy		; $8FEBD5: EE 7D 04
	inc.w printy		; $8FEBD8: EE 7D 04
	dec.b d1		; $8FEBDB: C6 57
	bpl .l25		; $8FEBDD: 10 C8
.l26:
	rtl		; $8FEBDF: 6B
RosterGoalies:		;SNES: the goalie row numbers of the Team Roster screen
	db 1,2,3,4		; $8FEBE0
RosterG:		;SNES: the "G" position label of the goalie rows
	dw 3		; $8FEBE4
	db "G"
	dw 3		; $8FEBE7
	db "G"
	dw 3		; $8FEBEA
	db "G"
	dw 3		; $8FEBED
	db "G"
RosterLineNames:		;SNES: the Team Roster line names (15-byte strings)
	dw 15		; $8FEBF0
	db "  Goalies   }"
	dw 15		; $8FEBFF
	db "{Scoring  1 }"
	dw 15		; $8FEC0E
	db "{Scoring  2 }"
	dw 15		; $8FEC1D
	db "{ Checking  }"
	dw 15		; $8FEC2C
	db "{Pwr. Play 1}"
	dw 15		; $8FEC3B
	db "{Pwr. Play 2}"
	dw 15		; $8FEC4A
	db "{Pen. Kill 1}"
	dw 15		; $8FEC59
	db "{Pen. Kill 2 "
addframe:		;auto: CODE_8FEC68. 93G addframe: sprite frame sprframe at sprx/spry: find its frame set in FrameSetTable (sprsetofs), then DrawFrame; frames $293 and up are drawn by addframe_hi
	lda.b sprframe		; $8FEC68: A5 C3
	cmp.w #$0293		; $8FEC6A: C9 93 02
	bcc .l1		; $8FEC6D: 90 04
	jml.l addframe_end		; $8FEC6F: 5C FE D1 87
.l1:
	dec.b sprframe		; $8FEC73: C6 C3
	bpl .l2		; $8FEC75: 10 04
	jml.l addframe_end		; $8FEC77: 5C FE D1 87
.l2:
	stz.b sprsetofs		; $8FEC7B: 64 C5
	ldx.w #$0000		; $8FEC7D: A2 00 00
	ldy.w #$0002		; $8FEC80: A0 02 00
.l3:
	lda.l FrameSetTable,x		; $8FEC83: BF 7D E6 8F
	beq .l3		; $8FEC87: F0 FA
	sta.b farptr		; $8FEC89: 85 0C
	lda.l FrameSetTable+1,x		; $8FEC8B: BF 7E E6 8F
	sta.b farptr+1		; $8FEC8F: 85 0D
	lda.b sprframe		; $8FEC91: A5 C3
	sec		; $8FEC93: 38
	sbc.b [farptr]		; $8FEC94: E7 0C
	bcs .l4		; $8FEC96: B0 04
	jml.l DrawFrame		; $8FEC98: 5C 62 CE 87
.l4:
	sta.b sprframe		; $8FEC9C: 85 C3
	lda.b sprsetofs		; $8FEC9E: A5 C5
	clc		; $8FECA0: 18
	adc.b [farptr],y		; $8FECA1: 77 0C
	sta.b sprsetofs		; $8FECA3: 85 C5
	inx		; $8FECA5: E8
	inx		; $8FECA6: E8
	inx		; $8FECA7: E8
	inx		; $8FECA8: E8
	bra .l3		; $8FECA9: 80 D8
Pmenu:		;auto: CODE_8FECAB (from Pausemode, StartHL2). 92G Pausemode .Pmenu: the 5 pause menu items (.mlist, game-over list when gsp = 4), item psitem highlighted
	jsl.l printz		; $8FECAB: 22 0C B9 80
	dw $0005		; $8FECAF  printz inline string: length (counts itself), then control bytes / text
	db $BF,$06,$0D
	stz.b d0		; $8FECB4: 64 53
	lda.w #.mlist		; $8FECB6: A9 C6 ED
	sta.b a0		; $8FECB9: 85 33
	lda.w #.mlist>>16		; $8FECBB: A9 8F 00
	sta.b a0+2		; $8FECBE: 85 35
	lda.w gsp		; $8FECC0: AD F0 12
	cmp.w #$0004		; $8FECC3: C9 04 00
	bne .l1		; $8FECC6: D0 05
	lda.w #.mlist2		; $8FECC8: A9 09 EE
	sta.b a0		; $8FECCB: 85 33
.l1:
	lda.w #$2400		; $8FECCD: A9 00 24
	sta.w printa		; $8FECD0: 8D 77 04
	lda.b d0		; $8FECD3: A5 53
	cmp.w psitem		; $8FECD5: CD 85 04
	bne .l2		; $8FECD8: D0 06
	lda.w #$2000		; $8FECDA: A9 00 20
	sta.w printa		; $8FECDD: 8D 77 04
.l2:
	lda.w #$0006		; $8FECE0: A9 06 00
	sta.w printx		; $8FECE3: 8D 7B 04
	jsl.l printz		; $8FECE6: 22 0C B9 80
	dw $0016		; $8FECEA  printz inline string: length (counts itself), then control bytes / text
	db "                    "
	lda.w #$0191		; $8FED00: A9 91 01
	sta.b a1		; $8FED03: 85 37
	lda.w #$0000		; $8FED05: A9 00 00
	sta.b a1+2		; $8FED08: 85 39
	ldy.w #$001E		; $8FED0A: A0 1E 00
.l3:
	lda.b [a0],y		; $8FED0D: B7 33
	sta.b [a1],y		; $8FED0F: 97 37
	dey		; $8FED11: 88
	dey		; $8FED12: 88
	bpl .l3		; $8FED13: 10 F8
	jsl.l .goalie		; $8FED15: 22 3F ED 8F
	lda.b [a1]		; $8FED19: A7 37
	lsr a		; $8FED1B: 4A
	eor.w #$FFFF		; $8FED1C: 49 FF FF
	inc a		; $8FED1F: 1A
	clc		; $8FED20: 18
	adc.w #$0011		; $8FED21: 69 11 00
	sta.w printx		; $8FED24: 8D 7B 04
	jsl.l print		; $8FED27: 22 2D B9 80
	inc.w printy		; $8FED2B: EE 7D 04
	lda.b a0		; $8FED2E: A5 33
	clc		; $8FED30: 18
	adc.b [a0]		; $8FED31: 67 33
	sta.b a0		; $8FED33: 85 33
	inc.b d0		; $8FED35: E6 53
	lda.b d0		; $8FED37: A5 53
	cmp.w #$0005		; $8FED39: C9 05 00
	bne .l1		; $8FED3C: D0 8F
	rtl		; $8FED3E: 6B
.goalie:		;item 3: append the name of the goalie on the ice (or NONE)
	lda.b d0		; $8FED3F: A5 53
	cmp.w #$0003		; $8FED41: C9 03 00
	beq .l4		; $8FED44: F0 03
	jmp.w .l9		; $8FED46: 4C 9D ED
.l4:
	jsl.l GetPadTeam		; $8FED49: 22 4A EE 8F
	ldy.b a2		; $8FED4D: A4 3B
	lda.w tmgoalie,y		; $8FED4F: B9 F2 13
	bmi .l10		; $8FED52: 30 4A
	sta.b tmp0		; $8FED54: 85 73
	lda.w tmdata,y		; $8FED56: B9 CE 13
	sta.b a4		; $8FED59: 85 43
	lda.w #$0083		; $8FED5B: A9 83 00
	sta.b a4+2		; $8FED5E: 85 45
	ldy.w #$0000		; $8FED60: A0 00 00
	lda.b [a4],y		; $8FED63: B7 43
	clc		; $8FED65: 18
	adc.b a4		; $8FED66: 65 43
	sta.b a4		; $8FED68: 85 43
.l5:
	dec.b tmp0		; $8FED6A: C6 73
	bmi .l6		; $8FED6C: 30 0C
	lda.b [a4]		; $8FED6E: A7 43
	clc		; $8FED70: 18
	adc.b a4		; $8FED71: 65 43
	adc.w #$0008		; $8FED73: 69 08 00
	sta.b a4		; $8FED76: 85 43
	bra .l5		; $8FED78: 80 F0
.l6:
	ldy.w #$0001		; $8FED7A: A0 01 00
.l7:
	iny		; $8FED7D: C8
	lda.b [a4],y		; $8FED7E: B7 43
	and.w #$00FF		; $8FED80: 29 FF 00
	cmp.w #$0020		; $8FED83: C9 20 00
	bne .l7		; $8FED86: D0 F5
.l8:
	iny		; $8FED88: C8
	tya		; $8FED89: 98
	cmp.b [a4]		; $8FED8A: C7 43
	beq .l9		; $8FED8C: F0 0F
	lda.b [a4],y		; $8FED8E: B7 43
	phy		; $8FED90: 5A
	ldy.w mesarea		; $8FED91: AC 91 01
	sta.w mesarea,y		; $8FED94: 99 91 01
	inc.w mesarea		; $8FED97: EE 91 01
	ply		; $8FED9A: 7A
	bra .l8		; $8FED9B: 80 EB
.l9:
	rtl		; $8FED9D: 6B
.l10:
	ldy.w mesarea		; $8FED9E: AC 91 01
	lda.w #$004E		; $8FEDA1: A9 4E 00
	sta.w mesarea,y		; $8FEDA4: 99 91 01
	lda.w #$004F		; $8FEDA7: A9 4F 00
	sta.w mesarea+1,y		; $8FEDAA: 99 92 01
	lda.w #$004E		; $8FEDAD: A9 4E 00
	sta.w mesarea+2,y		; $8FEDB0: 99 93 01
	lda.w #$0045		; $8FEDB3: A9 45 00
	sta.w mesarea+3,y		; $8FEDB6: 99 94 01
	inc.w mesarea		; $8FEDB9: EE 91 01
	inc.w mesarea		; $8FEDBC: EE 91 01
	inc.w mesarea		; $8FEDBF: EE 91 01
	inc.w mesarea		; $8FEDC2: EE 91 01
	rtl		; $8FEDC5: 6B
.mlist:		;92G Pausemode .mlist: the pause menu items
	dw 13		; $8FEDC6
	db "Resume Game"
	dw 16		; $8FEDD3
	db "Instant Replay"
	dw 14		; $8FEDE3
	db "Stats Report"
	dw 11		; $8FEDF1
	db "Goalie - "
	dw 13		; $8FEDFC
	db "Team Roster"
.mlist2:		;SNES: the menu items after the game (Exit Game first)
	dw 11		; $8FEE09
	db "Exit Game"
	dw 16		; $8FEE14
	db "Instant Replay"
	dw 14		; $8FEE24
	db "Stats Report"
	dw 11		; $8FEE32
	db "Goalie - "
	dw 13		; $8FEE3D
	db "Team Roster"
GetPadTeam:		;auto: CODE_8FEE4A. SNES: a2 = team of the controller that paused (cont1team/cont2team by sfpj)
	stz.b a2		; $8FEE4A: 64 3B
	lda.w cont1team		; $8FEE4C: AD 96 12
	beq .l3		; $8FEE4F: F0 19
	lda.w sflags		; $8FEE51: AD 8C 12
	bit.w #$0002		; $8FEE54: 89 02 00
	beq .l1		; $8FEE57: F0 05
	lda.w cont2team		; $8FEE59: AD 98 12
	bra .l2		; $8FEE5C: 80 03
.l1:
	lda.w cont1team		; $8FEE5E: AD 96 12
.l2:
	cmp.w #$0001		; $8FEE61: C9 01 00
	beq .l3		; $8FEE64: F0 04
	inc.b a2		; $8FEE66: E6 3B
	inc.b a2		; $8FEE68: E6 3B
.l3:
	rtl		; $8FEE6A: 6B
setpde:		;auto: CODE_8FEE6B. 93G setpde: tmpde of player d1 (team a2) = d0 (not below 0)
	lda.b a2		; $8FEE6B: A5 3B
	beq .l1		; $8FEE6D: F0 03
	lda.w #$0034		; $8FEE6F: A9 34 00
.l1:
	clc		; $8FEE72: 18
	adc.b d1		; $8FEE73: 65 57
	tay		; $8FEE75: A8
	lda.b d0		; $8FEE76: A5 53
	bpl .l2		; $8FEE78: 10 05
	lda.w #$0000		; $8FEE7A: A9 00 00
	sta.b d0		; $8FEE7D: 85 53
.l2:
	sta.w tmpde,y		; $8FEE7F: 99 7A 14
	rtl		; $8FEE82: 6B
