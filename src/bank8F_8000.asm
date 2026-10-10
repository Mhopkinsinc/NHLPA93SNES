; $8F8000-$8F9084  ROM $78000-$79084: BigFontMap, an unused energy bar routine, PerLabels, EASNLogoMap, BigFontIndex; the clock, ref, scoreboard
; and ticker code (showclock, PushRef, SetHor, USBoard, Intermission, NewTicker), clockcont, updatepentime, linebar, the pause and replay
; helpers, the textmap/rink DMA queuers, InitScores, ResetPassWord. Ends before SpriteSet1 (boundary moved from $8F8FFF).
org $8F8000
BigFontMap:		;93G bigfont.map: big font tiles of each character: 76 top-row words, then the 76 bottom-row words (+$98); printbig uses BigFontIndex
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406,$0407		; $8F8000
	dw $0408,$0409,$0408,$0409,$040A,$040B,$040C,$040D		; $8F8010
	dw $040E,$040F,$0410,$0411,$0412,$0413,$0414,$0415		; $8F8020
	dw $0416,$0417,$0418,$0419,$041A,$041B,$041C,$041D		; $8F8030
	dw $041E,$041B,$041F,$0420,$0421,$0422,$0423,$0424		; $8F8040
	dw $0425,$0424,$0426,$0427,$0428,$0429,$042A,$042B		; $8F8050
	dw $042C,$042D,$042E,$042F,$0430,$0431,$0432,$0433		; $8F8060
	dw $0434,$0435,$0436,$0437,$0438,$0439,$043A,$043B		; $8F8070
	dw $043C,$043D,$043E,$043F,$0440,$0441,$0442,$0443		; $8F8080
	dw $0414,$0444,$0445,$0446,$0447,$0448,$0449,$044A		; $8F8090
	dw $044B,$044C,$044D,$044E,$044F,$0450,$0451,$0452		; $8F80A0
	dw $0453,$0454,$0455,$0456,$0457,$0458,$0459,$045A		; $8F80B0
	dw $045B,$0458,$045C,$045D,$045E,$045F,$0460,$0461		; $8F80C0
	dw $0462,$0463,$0464,$0465,$0466,$0467,$0468,$0469		; $8F80D0
	dw $046A,$046B,$046C,$046D,$0459,$046E,$046F,$0470		; $8F80E0
	dw $0471,$0472,$0473,$0474,$0475,$0476,$0477,$0478		; $8F80F0
	dw $0479,$047A,$047B,$047C,$047D,$047E,$047F,$0480		; $8F8100
	dw $0481,$0482,$0483,$0484,$0485,$0486,$0487,$0488		; $8F8110
	dw $0489,$048A,$048B,$048C,$0442,$048D,$048E,$048F		; $8F8120
unusedEnergyBar:		;auto: CODE_8F8130. SNES: no caller found: a 4-character energy bar of d0 (8 levels per character) printed at printx-11, palette by d1
	stx.b xsave		; $8F8130: 86 0A
	ldx.w #$0000		; $8F8132: A2 00 00
.l1:
	lda.b d0,x		; $8F8135: B5 53
	pha		; $8F8137: 48
	inx		; $8F8138: E8
	inx		; $8F8139: E8
	cpx.w #$0010		; $8F813A: E0 10 00
	bne .l1		; $8F813D: D0 F6
	ldx.b xsave		; $8F813F: A6 0A
	stx.b xsave		; $8F8141: 86 0A
	ldx.w #$0000		; $8F8143: A2 00 00
.l2:
	lda.b a1,x		; $8F8146: B5 37
	pha		; $8F8148: 48
	inx		; $8F8149: E8
	inx		; $8F814A: E8
	cpx.w #$0004		; $8F814B: E0 04 00
	bne .l2		; $8F814E: D0 F6
	ldx.b xsave		; $8F8150: A6 0A
	lda.w #$2000		; $8F8152: A9 00 20
	sta.w printa		; $8F8155: 8D 77 04
	lda.b d0		; $8F8158: A5 53
	lsr a		; $8F815A: 4A
	lsr a		; $8F815B: 4A
	lsr a		; $8F815C: 4A
	lsr a		; $8F815D: 4A
	lsr a		; $8F815E: 4A
	lsr a		; $8F815F: 4A
	lsr a		; $8F8160: 4A
	cmp.w #$0020		; $8F8161: C9 20 00
	bcc .l3		; $8F8164: 90 03
	lda.w #$001F		; $8F8166: A9 1F 00
.l3:
	sta.b d0		; $8F8169: 85 53
	ldy.w #$0002		; $8F816B: A0 02 00
	lda.w #$0006		; $8F816E: A9 06 00
	sta.w mesarea		; $8F8171: 8D 91 01
	lda.w #$0003		; $8F8174: A9 03 00
	sta.b d3		; $8F8177: 85 5F
.l4:
	lda.w #$FFFF		; $8F8179: A9 FF FF
	sta.b d2		; $8F817C: 85 5B
	lda.b d0		; $8F817E: A5 53
	bmi .l5		; $8F8180: 30 0C
	sta.b d2		; $8F8182: 85 5B
	cmp.w #$0008		; $8F8184: C9 08 00
	bcc .l5		; $8F8187: 90 05
	lda.w #$0007		; $8F8189: A9 07 00
	sta.b d2		; $8F818C: 85 5B
.l5:
	lda.b d2		; $8F818E: A5 5B
	sec		; $8F8190: 38
	adc.b d1		; $8F8191: 65 57
	and.w #$00FF		; $8F8193: 29 FF 00
	bne .l6		; $8F8196: D0 03
	lda.w #$0020		; $8F8198: A9 20 00
.l6:
	sta.w mesarea,y		; $8F819B: 99 91 01
	iny		; $8F819E: C8
	lda.b d0		; $8F819F: A5 53
	sec		; $8F81A1: 38
	sbc.w #$0008		; $8F81A2: E9 08 00
	sta.b d0		; $8F81A5: 85 53
	dec.b d3		; $8F81A7: C6 5F
	bpl .l4		; $8F81A9: 10 CE
	lda.b d1		; $8F81AB: A5 57
	beq .l7		; $8F81AD: F0 06
	lda.w #$0C00		; $8F81AF: A9 00 0C
	tsb.w printa		; $8F81B2: 0C 77 04
.l7:
	lda.w #$0191		; $8F81B5: A9 91 01
	sta.b a1		; $8F81B8: 85 37
	lda.w #$0000		; $8F81BA: A9 00 00
	sta.b a1+2		; $8F81BD: 85 39
	lda.w printx		; $8F81BF: AD 7B 04
	sec		; $8F81C2: 38
	sbc.w #$000B		; $8F81C3: E9 0B 00
	sta.w printx		; $8F81C6: 8D 7B 04
	lda.w #$4000		; $8F81C9: A9 00 40
	tsb.w printa		; $8F81CC: 0C 77 04
	lda.w #$0191		; $8F81CF: A9 91 01
	sta.b a1		; $8F81D2: 85 37
	lda.w #$0000		; $8F81D4: A9 00 00
	sta.b a1+2		; $8F81D7: 85 39
	sep #$20		; $8F81D9: E2 20
	lda.w mesarea+5		; $8F81DB: AD 96 01
	ldy.w mesarea+2		; $8F81DE: AC 93 01
	sta.w mesarea+2		; $8F81E1: 8D 93 01
	sty.w mesarea+5		; $8F81E4: 8C 96 01
	rep #$30		; $8F81E7: C2 30
	lda.w mesarea+3		; $8F81E9: AD 94 01
	xba		; $8F81EC: EB
	sta.w mesarea+3		; $8F81ED: 8D 94 01
	lda.w #$4000		; $8F81F0: A9 00 40
	trb.w printa		; $8F81F3: 1C 77 04
	stx.b xsave		; $8F81F6: 86 0A
	ldx.w #$0002		; $8F81F8: A2 02 00
.l8:
	pla		; $8F81FB: 68
	sta.b a1,x		; $8F81FC: 95 37
	dex		; $8F81FE: CA
	dex		; $8F81FF: CA
	bpl .l8		; $8F8200: 10 F9
	ldx.b xsave		; $8F8202: A6 0A
	stx.b xsave		; $8F8204: 86 0A
	ldx.w #$000E		; $8F8206: A2 0E 00
.l9:
	pla		; $8F8209: 68
	sta.b d0,x		; $8F820A: 95 53
	dex		; $8F820C: CA
	dex		; $8F820D: CA
	bpl .l9		; $8F820E: 10 F9
	ldx.b xsave		; $8F8210: A6 0A
	rtl		; $8F8212: 6B
unusedStatLabels:		;SNES: no reader found: short stat labels Sc1, Sc2, Chk, Pw1, Pw2, PK1, PK2
	dw 5		; $8F8213
	db "Sc1"
	dw 5		; $8F8218
	db "Sc2"
	dw 5		; $8F821D
	db "Chk"
	dw 5		; $8F8222
	db "Pw1"
	dw 5		; $8F8227
	db "Pw2"
	dw 5		; $8F822C
	db "PK1"
	dw 5		; $8F8231
	db "PK2"
PerLabels:		;93G PerLabels: period names (gsp 0-4); $12-$14 are the "st", "nd", "rd" small font tiles
	dw 4		; $8F8236
	db "1",$12
	dw 4		; $8F823A
	db "2",$13
	dw 4		; $8F823E
	db "3",$14
	dw 4		; $8F8242
	db "OT"
	dw 7		; $8F8246
	db "Final"
EASNLogoMap:		;93G easn.map (small): the 7 x 2 EASN logo tile words for EASNLogo (unusedchars + n)
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406		; $8F824D
	dw $0407,$0408,$0409,$040A,$040B,$040C,$040D		; $8F825B
BigFontIndex:		;SNES: big font index of each character $20-$5A (*2 into BigFontMap); negative = one column wide
	db $00,$B7,$00,$00,$00,$00,$00,$BA,$00,$00,$00,$00,$00,$00,$C2,$00		; $8F8269
	db $33,$CB,$36,$38,$3A,$3C,$3E,$40,$42,$44,$BB,$00,$00,$00,$00,$48		; $8F8279
	db $4A,$00,$02,$04,$06,$08,$0A,$0C,$0E,$F0,$11,$13,$15,$17,$19,$1B		; $8F8289
	db $1D,$1F,$21,$23,$25,$27,$29,$2B,$2D,$2F,$31		; $8F8299
showclock:		;auto: CODE_8F82A4 (from setvideo). 93G showclock (video93_2): the game clock m:ss at x 3, y $18 (horizontal rink: x $D, y 4; not when gsp = 4); not in replay
	lda.w sflags		; $8F82A4: AD 8C 12
	bit.w #sf2replay		; $8F82A7: 89 00 08
	beq .l1		; $8F82AA: F0 03
	jmp.w .l4		; $8F82AC: 4C 3E 83
.l1:
	lda.w #$0007		; $8F82AF: A9 07 00
	sta.w mesarea		; $8F82B2: 8D 91 01
	lda.w #$0020		; $8F82B5: A9 20 00
	sta.w mesarea+2		; $8F82B8: 8D 93 01
	lda.w gameclock		; $8F82BB: AD F2 12
	sta.b mulb		; $8F82BE: 85 83
	lda.w #600		; $8F82C0: A9 58 02
	sta.b mula		; $8F82C3: 85 7D
	jsl.l divu16		; $8F82C5: 22 D8 B8 80
	beq .l2		; $8F82C9: F0 06
	adc.w #$0030		; $8F82CB: 69 30 00
	sta.w mesarea+2		; $8F82CE: 8D 93 01
.l2:
	lda.w #60		; $8F82D1: A9 3C 00
	sta.b mula		; $8F82D4: 85 7D
	lda.b mulres+2		; $8F82D6: A5 95
	sta.b mulb		; $8F82D8: 85 83
	jsl.l divu16		; $8F82DA: 22 D8 B8 80
	adc.w #$0030		; $8F82DE: 69 30 00
	sta.w mesarea+3		; $8F82E1: 8D 94 01
	lda.w #':'		; $8F82E4: A9 3A 00
	sta.w mesarea+4		; $8F82E7: 8D 95 01
	lda.w #10		; $8F82EA: A9 0A 00
	sta.b mula		; $8F82ED: 85 7D
	lda.b mulres+2		; $8F82EF: A5 95
	sta.b mulb		; $8F82F1: 85 83
	jsl.l divu16		; $8F82F3: 22 D8 B8 80
	adc.w #$0030		; $8F82F7: 69 30 00
	sta.w mesarea+5		; $8F82FA: 8D 96 01
	lda.b mulres+2		; $8F82FD: A5 95
	adc.w #$0030		; $8F82FF: 69 30 00
	sta.w mesarea+6		; $8F8302: 8D 97 01
	lda.w #$2000		; $8F8305: A9 00 20
	sta.w printa		; $8F8308: 8D 77 04
	lda.w #$0003		; $8F830B: A9 03 00
	sta.w printx		; $8F830E: 8D 7B 04
	lda.w #$0018		; $8F8311: A9 18 00
	sta.w printy		; $8F8314: 8D 7D 04
	lda.w sfhormode		; $8F8317: AD 8E 12
	beq .l3		; $8F831A: F0 14
	lda.w #$000D		; $8F831C: A9 0D 00
	sta.w printx		; $8F831F: 8D 7B 04
	lda.w #$0004		; $8F8322: A9 04 00
	sta.w printy		; $8F8325: 8D 7D 04
	lda.w gsp		; $8F8328: AD F0 12
	cmp.w #$0004		; $8F832B: C9 04 00
	beq .l4		; $8F832E: F0 0E
.l3:
	lda.w #$0191		; $8F8330: A9 91 01
	sta.b a1		; $8F8333: 85 37
	lda.w #$0000		; $8F8335: A9 00 00
	sta.b a1+2		; $8F8338: 85 39
	jml.l print		; $8F833A: 5C 2D B9 80
.l4:
	rtl		; $8F833E: 6B
asseben:		;auto: CODE_8F833F (asstab 9). 93G asseben (logic93_2): player X comes onto the ice from the bench door (SPAwallright), then assexit
	lda.w pfalock,x		; $8F833F: BD 7F 11
	bne .l2		; $8F8342: D0 43
	lda.w pflags,x		; $8F8344: BD DF 0E
	bit.w #$0002		; $8F8347: 89 02 00
	beq .l3		; $8F834A: F0 3C
	and.w #$FFFD		; $8F834C: 29 FD FF
	sta.w pflags,x		; $8F834F: 9D DF 0E
	stz.w Xvel,x		; $8F8352: 9E DF 0A
	stz.w Yvel,x		; $8F8355: 9E FF 0A
	txa		; $8F8358: 8A
	lsr a		; $8F8359: 4A
	sec		; $8F835A: 38
	sbc.w #$0006		; $8F835B: E9 06 00
	bmi .l1		; $8F835E: 30 01
	inc a		; $8F8360: 1A
.l1:
	sta.b mulb		; $8F8361: 85 83
	lda.w #$000E		; $8F8363: A9 0E 00
	sta.b mula		; $8F8366: 85 7D
	jsl.l muls16		; $8F8368: 22 96 84 80
	sta.w Ypos,x		; $8F836C: 9D 5F 09
	lda.w #$FF78		; $8F836F: A9 78 FF
	sta.w Xpos,x		; $8F8372: 9D FF 08
	lda.w #$0002		; $8F8375: A9 02 00
	sta.w facedir,x		; $8F8378: 9D BF 0D
	sta.w pfalock,x		; $8F837B: 9D 7F 11
	lda.w #$101A		; $8F837E: A9 1A 10
	sta.b d1		; $8F8381: 85 57
	jml.l SetSPA		; $8F8383: 5C 06 B0 80
.l2:
	rtl		; $8F8387: 6B
.l3:
	lda.w #$0004		; $8F8388: A9 04 00
	sta.w facedir,x		; $8F838B: 9D BF 0D
	lda.w pflags,x		; $8F838E: BD DF 0E
	and.w #$6FFF		; $8F8391: 29 FF 6F
	sta.w pflags,x		; $8F8394: 9D DF 0E
	stz.w pfnc,x		; $8F8397: 9E FF 11
	stz.w SPA,x		; $8F839A: 9E FF 0D
	lda.w #$1000		; $8F839D: A9 00 10
	sta.w Xvel,x		; $8F83A0: 9D DF 0A
	jml.l assexit		; $8F83A3: 5C F9 96 80
PushRef:		;auto: CODE_8F83A7. 93G PushRef: ref window frame d0 (RefsMap or RefsMapHor, 8 x 7 words) into textmap; d0 $40 erases the window and prefmes
	phx		; $8F83A7: DA
	stx.b xsave		; $8F83A8: 86 0A
	ldx.w #$0000		; $8F83AA: A2 00 00
.l1:
	lda.b d0,x		; $8F83AD: B5 53
	pha		; $8F83AF: 48
	inx		; $8F83B0: E8
	inx		; $8F83B1: E8
	cpx.w #$000C		; $8F83B2: E0 0C 00
	bne .l1		; $8F83B5: D0 F6
	ldx.b xsave		; $8F83B7: A6 0A
	stx.b xsave		; $8F83B9: 86 0A
	ldx.w #$0000		; $8F83BB: A2 00 00
.l2:
	lda.b a0,x		; $8F83BE: B5 33
	pha		; $8F83C0: 48
	inx		; $8F83C1: E8
	inx		; $8F83C2: E8
	cpx.w #$0008		; $8F83C3: E0 08 00
	bne .l2		; $8F83C6: D0 F6
	ldx.b xsave		; $8F83C8: A6 0A
	lda.b d0		; $8F83CA: A5 53
	cmp.w #$40		; $8F83CC: C9 40 00
	bne .l3		; $8F83CF: D0 03
	jmp.w .l9		; $8F83D1: 4C 5B 84
.l3:
	sta.b mulb		; $8F83D4: 85 83
	lda.w #$70		; $8F83D6: A9 70 00
	sta.b mula		; $8F83D9: 85 7D
	jsl.l mulu16		; $8F83DB: 22 1C 87 8D
	sta.b d0		; $8F83DF: 85 53
	lda.w #RefsMap		; $8F83E1: A9 EC FA
	sta.b a0		; $8F83E4: 85 33
	lda.w #RefsMap>>16		; $8F83E6: A9 83 00
	sta.b a0+2		; $8F83E9: 85 35
	lda.w #$0084		; $8F83EB: A9 84 00
	sta.b tmp1		; $8F83EE: 85 75
	lda.w refchars		; $8F83F0: AD E1 1B
	sta.b tmp0		; $8F83F3: 85 73
	lda.w sfhormode		; $8F83F5: AD 8E 12
	beq .l4		; $8F83F8: F0 14
	lda.w refcharshor		; $8F83FA: AD DF 1B
	sta.b tmp0		; $8F83FD: 85 73
	lda.w #$03DA		; $8F83FF: A9 DA 03
	sta.b tmp1		; $8F8402: 85 75
	lda.w #RefsMapHor		; $8F8404: A9 FB F3
	sta.b a0		; $8F8407: 85 33
	lda.w #RefsMapHor>>16		; $8F8409: A9 89 00
	sta.b a0+2		; $8F840C: 85 35
.l4:
	lda.b a0		; $8F840E: A5 33
	clc		; $8F8410: 18
	adc.b d0		; $8F8411: 65 53
	sta.b a0		; $8F8413: 85 33
	lda.w #$0008		; $8F8415: A9 08 00
	sta.b tmp2		; $8F8418: 85 77
.l5:
	ldy.w #$0007		; $8F841A: A0 07 00
.l6:
	lda.b [a0]		; $8F841D: A7 33
	clc		; $8F841F: 18
	adc.b tmp0		; $8F8420: 65 73
	adc.w charofs		; $8F8422: 6D CD 1B
	ldx.b tmp1		; $8F8425: A6 75
	ora.w #$2000		; $8F8427: 09 00 20
	sta.l textmap,x		; $8F842A: 9F 74 6E 7E
	txa		; $8F842E: 8A
	lsr a		; $8F842F: 4A
	cmp.b textdirtylo		; $8F8430: C5 D0
	bcs .l7		; $8F8432: B0 02
	sta.b textdirtylo		; $8F8434: 85 D0
.l7:
	cmp.b textdirtyhi		; $8F8436: C5 D2
	bcc .l8		; $8F8438: 90 02
	sta.b textdirtyhi		; $8F843A: 85 D2
.l8:
	inc.b a0		; $8F843C: E6 33
	inc.b a0		; $8F843E: E6 33
	inc.b tmp1		; $8F8440: E6 75
	inc.b tmp1		; $8F8442: E6 75
	dey		; $8F8444: 88
	bne .l6		; $8F8445: D0 D6
	lda.b tmp1		; $8F8447: A5 75
	clc		; $8F8449: 18
	adc.w #$0032		; $8F844A: 69 32 00
	sta.b tmp1		; $8F844D: 85 75
	dec.b tmp2		; $8F844F: C6 77
	bne .l5		; $8F8451: D0 C7
	lda.w #sf2refref		; $8F8453: A9 00 02
	tsb.w sflags		; $8F8456: 0C 8C 12
	bra .l11		; $8F8459: 80 3C
.l9:
	lda.w #$0007		; $8F845B: A9 07 00
	sta.b d0		; $8F845E: 85 53
	lda.w #$0008		; $8F8460: A9 08 00
	sta.b d1		; $8F8463: 85 57
	lda.w blankchar		; $8F8465: AD E7 1B
	sta.b d2		; $8F8468: 85 5B
	lda.w #$0002		; $8F846A: A9 02 00
	sta.w printx		; $8F846D: 8D 7B 04
	sta.w printy		; $8F8470: 8D 7D 04
	lda.w sfhormode		; $8F8473: AD 8E 12
	beq .l10		; $8F8476: F0 0C
	lda.w #$000D		; $8F8478: A9 0D 00
	sta.w printx		; $8F847B: 8D 7B 04
	lda.w #$000F		; $8F847E: A9 0F 00
	sta.w printy		; $8F8481: 8D 7D 04
.l10:
	jsl.l eraser		; $8F8484: 22 7C 84 8D
	lda.w #sf2refref		; $8F8488: A9 00 02
	tsb.w sflags		; $8F848B: 0C 8C 12
	lda.w #$FFFF		; $8F848E: A9 FF FF
	sta.b d0		; $8F8491: 85 53
	jsl.l $8FF63D		; $8F8493: 22 3D F6 8F  bank8F_F000: 93G prefmes
.l11:
	stx.b xsave		; $8F8497: 86 0A
	ldx.w #$0006		; $8F8499: A2 06 00
.l12:
	pla		; $8F849C: 68
	sta.b a0,x		; $8F849D: 95 33
	dex		; $8F849F: CA
	dex		; $8F84A0: CA
	bpl .l12		; $8F84A1: 10 F9
	ldx.b xsave		; $8F84A3: A6 0A
	stx.b xsave		; $8F84A5: 86 0A
	ldx.w #$000A		; $8F84A7: A2 0A 00
.l13:
	pla		; $8F84AA: 68
	sta.b d0,x		; $8F84AB: 95 53
	dex		; $8F84AD: CA
	dex		; $8F84AE: CA
	bpl .l13		; $8F84AF: 10 F9
	ldx.b xsave		; $8F84B1: A6 0A
	plx		; $8F84B3: FA
	rtl		; $8F84B4: 6B
SetHor:		;auto: CODE_8F84B5. 93G SetHor: switch to the horizontal rink (scoreboard screen): half puck speed, forceblack, sfhormode, StatsReport
	stx.b xsave		; $8F84B5: 86 0A
	ldx.w #$0000		; $8F84B7: A2 00 00
.l1:
	lda.b d0,x		; $8F84BA: B5 53
	pha		; $8F84BC: 48
	inx		; $8F84BD: E8
	inx		; $8F84BE: E8
	cpx.w #$001C		; $8F84BF: E0 1C 00
	bne .l1		; $8F84C2: D0 F6
	ldx.b xsave		; $8F84C4: A6 0A
	stx.b xsave		; $8F84C6: 86 0A
	ldx.w #$0000		; $8F84C8: A2 00 00
.l2:
	lda.b a0,x		; $8F84CB: B5 33
	pha		; $8F84CD: 48
	inx		; $8F84CE: E8
	inx		; $8F84CF: E8
	cpx.w #$001C		; $8F84D0: E0 1C 00
	bne .l2		; $8F84D3: D0 F6
	ldx.b xsave		; $8F84D5: A6 0A
	lda.w puckvx		; $8F84D7: AD FB 0A
	pha		; $8F84DA: 48
	asl a		; $8F84DB: 0A
	pla		; $8F84DC: 68
	ror a		; $8F84DD: 6A
	sta.w puckvx		; $8F84DE: 8D FB 0A
	lda.w puckvy		; $8F84E1: AD 1B 0B
	pha		; $8F84E4: 48
	asl a		; $8F84E5: 0A
	pla		; $8F84E6: 68
	ror a		; $8F84E7: 6A
	sta.w puckvy		; $8F84E8: 8D 1B 0B
	jsl.l $8FE404		; $8F84EB: 22 04 E4 8F  bank8F_E000: 93G forceblack
	lda.w #$0001		; $8F84EF: A9 01 00
	sta.w sfhormode		; $8F84F2: 8D 8E 12
	stz.w Hscroll		; $8F84F5: 9C 56 01
	lda.w #$FFFF		; $8F84F8: A9 FF FF
	sta.w Vscroll		; $8F84FB: 8D E1 08
	lda.w #$002E		; $8F84FE: A9 2E 00
	sta.w Oldrow		; $8F8501: 8D 9B 04
	stz.w vramrow		; $8F8504: 9C 9D 04
	jsl.l SprSort		; $8F8507: 22 6C B7 80
	jsl.l $8FF58D		; $8F850B: 22 8D F5 8F  bank8F_F000: 92G StatsReport
	stx.b xsave		; $8F850F: 86 0A
	ldx.w #$001A		; $8F8511: A2 1A 00
.l3:
	pla		; $8F8514: 68
	sta.b a0,x		; $8F8515: 95 33
	dex		; $8F8517: CA
	dex		; $8F8518: CA
	bpl .l3		; $8F8519: 10 F9
	ldx.b xsave		; $8F851B: A6 0A
	stx.b xsave		; $8F851D: 86 0A
	ldx.w #$001A		; $8F851F: A2 1A 00
.l4:
	pla		; $8F8522: 68
	sta.b d0,x		; $8F8523: 95 53
	dex		; $8F8525: CA
	dex		; $8F8526: CA
	bpl .l4		; $8F8527: 10 F9
	ldx.b xsave		; $8F8529: A6 0A
	ldx.b a3		; $8F852B: A6 3F
	rtl		; $8F852D: 6B
USBoard:		;auto: CODE_8F852E. 93G USBoard (penalty93_2): printscores1, then each team's penalty box players and their time (.dispen)
	stx.b xsave		; $8F852E: 86 0A
	ldx.w #$0000		; $8F8530: A2 00 00
.l1:
	lda.b d0,x		; $8F8533: B5 53
	pha		; $8F8535: 48
	inx		; $8F8536: E8
	inx		; $8F8537: E8
	cpx.w #$0020		; $8F8538: E0 20 00
	bne .l1		; $8F853B: D0 F6
	ldx.b xsave		; $8F853D: A6 0A
	stx.b xsave		; $8F853F: 86 0A
	ldx.w #$0000		; $8F8541: A2 00 00
.l2:
	lda.b a0,x		; $8F8544: B5 33
	pha		; $8F8546: 48
	inx		; $8F8547: E8
	inx		; $8F8548: E8
	cpx.w #$0010		; $8F8549: E0 10 00
	bne .l2		; $8F854C: D0 F6
	ldx.b xsave		; $8F854E: A6 0A
	jsl.l printscores1		; $8F8550: 22 5D E9 89
	jsl.l printz		; $8F8554: 22 0C B9 80
	dw $0005		; $8F8558  printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$08
	stz.b a2		; $8F855D: 64 3B
	jsl.l .dispen		; $8F855F: 22 94 85 8F
	jsl.l printz		; $8F8563: 22 0C B9 80
	dw $0005		; $8F8567  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$08
	lda.w #$0002		; $8F856C: A9 02 00
	sta.b a2		; $8F856F: 85 3B
	jsl.l .dispen		; $8F8571: 22 94 85 8F
	stx.b xsave		; $8F8575: 86 0A
	ldx.w #$000E		; $8F8577: A2 0E 00
.l3:
	pla		; $8F857A: 68
	sta.b a0,x		; $8F857B: 95 33
	dex		; $8F857D: CA
	dex		; $8F857E: CA
	bpl .l3		; $8F857F: 10 F9
	ldx.b xsave		; $8F8581: A6 0A
	stx.b xsave		; $8F8583: 86 0A
	ldx.w #$001E		; $8F8585: A2 1E 00
.l4:
	pla		; $8F8588: 68
	sta.b d0,x		; $8F8589: 95 53
	dex		; $8F858B: CA
	dex		; $8F858C: CA
	bpl .l4		; $8F858D: 10 F9
	ldx.b xsave		; $8F858F: A6 0A
	ldx.b a3		; $8F8591: A6 3F
.l5:
	rtl		; $8F8593: 6B
.dispen:		;93G .dispen: penalty box list of team a2: timed players first
	lda.b a2		; $8F8594: A5 3B
	beq .l6		; $8F8596: F0 03
	lda.w #$001A		; $8F8598: A9 1A 00
.l6:
	sta.b a0		; $8F859B: 85 33
.l7:
	ldy.b a0		; $8F859D: A4 33
	lda.w tmboxlist,y		; $8F859F: B9 4A 15
	inc.b a0		; $8F85A2: E6 33
	and.w #$00FF		; $8F85A4: 29 FF 00
	sta.b d0		; $8F85A7: 85 53
	bit.w #$0080		; $8F85A9: 89 80 00
	bne .l9		; $8F85AC: D0 19
	lda.b a2		; $8F85AE: A5 3B
	beq .l8		; $8F85B0: F0 03
	lda.w #$0034		; $8F85B2: A9 34 00
.l8:
	clc		; $8F85B5: 18
	adc.b d0		; $8F85B6: 65 53
	tay		; $8F85B8: A8
	lda.w tmpdst,y		; $8F85B9: B9 E2 14
	bit.w #$4000		; $8F85BC: 89 00 40
	bne .l7		; $8F85BF: D0 DC
	jsl.l pplpen		; $8F85C1: 22 FA 85 8F
	bra .l7		; $8F85C5: 80 D6
.l9:
	lda.b a2		; $8F85C7: A5 3B
	beq .l10		; $8F85C9: F0 03
	lda.w #$001A		; $8F85CB: A9 1A 00
.l10:
	sta.b a0		; $8F85CE: 85 33
.l11:
	ldy.b a0		; $8F85D0: A4 33
	lda.w tmboxlist,y		; $8F85D2: B9 4A 15
	inc.b a0		; $8F85D5: E6 33
	and.w #$00FF		; $8F85D7: 29 FF 00
	sta.b d0		; $8F85DA: 85 53
	bit.w #$0080		; $8F85DC: 89 80 00
	bne .l5		; $8F85DF: D0 B2
	lda.b a2		; $8F85E1: A5 3B
	beq .l12		; $8F85E3: F0 03
	lda.w #$0034		; $8F85E5: A9 34 00
.l12:
	clc		; $8F85E8: 18
	adc.b d0		; $8F85E9: 65 53
	tay		; $8F85EB: A8
	lda.w tmpdst,y		; $8F85EC: B9 E2 14
	bit.w #$4000		; $8F85EF: 89 00 40
	beq .l11		; $8F85F2: F0 DC
	jsl.l pplpen		; $8F85F4: 22 FA 85 8F
	bra .l11		; $8F85F8: 80 D6
pplpen:		;auto: CODE_8F85FA. 93G pplpen: one penalty box line: player number and time left (rows up to y $A)
	lda.w printy		; $8F85FA: AD 7D 04
	cmp.w #$000B		; $8F85FD: C9 0B 00
	bcs USBoard_l5		; $8F8600: B0 91
	lda.b a2		; $8F8602: A5 3B
	beq .l1		; $8F8604: F0 03
	lda.w #$0034		; $8F8606: A9 34 00
.l1:
	adc.b d0		; $8F8609: 65 53
	tay		; $8F860B: A8
	lda.w tmpdst,y		; $8F860C: B9 E2 14
	and.w #$07FF		; $8F860F: 29 FF 07
	sta.b d2		; $8F8612: 85 5B
	lda.w #$0083		; $8F8614: A9 83 00
	sta.b a1+2		; $8F8617: 85 39
	ldy.b a2		; $8F8619: A4 3B
	lda.w tmdata,y		; $8F861B: B9 CE 13
	sta.b a1		; $8F861E: 85 37
	ldy.w #$0000		; $8F8620: A0 00 00
	adc.b [a1],y		; $8F8623: 77 37
	sta.b a1		; $8F8625: 85 37
	lsr.b d0		; $8F8627: 46 53
.l2:
	lda.b [a1]		; $8F8629: A7 37
	clc		; $8F862B: 18
	adc.b a1		; $8F862C: 65 37
	adc.w #$0008		; $8F862E: 69 08 00
	sta.b a1		; $8F8631: 85 37
	dec.b d0		; $8F8633: C6 53
	bpl .l2		; $8F8635: 10 F2
	lda.b a1		; $8F8637: A5 37
	sec		; $8F8639: 38
	sbc.w #$0008		; $8F863A: E9 08 00
	sta.b a1		; $8F863D: 85 37
	lda.b [a1]		; $8F863F: A7 37
	and.w #$00FF		; $8F8641: 29 FF 00
	sta.b d0		; $8F8644: 85 53
	lda.w printx		; $8F8646: AD 7B 04
	pha		; $8F8649: 48
	lda.w #$0193		; $8F864A: A9 93 01
	sta.b a1		; $8F864D: 85 37
	lda.w #$0000		; $8F864F: A9 00 00
	sta.b a1+2		; $8F8652: 85 39
	jsl.l PutDigits2		; $8F8654: 22 39 EA 84
	lda.w #$0191		; $8F8658: A9 91 01
	sta.b a1		; $8F865B: 85 37
	lda.w #$0000		; $8F865D: A9 00 00
	sta.b a1+2		; $8F8660: 85 39
	lda.w #$0004		; $8F8662: A9 04 00
	sta.b [a1]		; $8F8665: 87 37
	jsl.l print		; $8F8667: 22 2D B9 80
	lda.b d2		; $8F866B: A5 5B
	sta.b d0		; $8F866D: 85 53
	jsl.l PushTime		; $8F866F: 22 EA 87 8F
	inc.w printx		; $8F8673: EE 7B 04
	jsl.l print		; $8F8676: 22 2D B9 80
	pla		; $8F867A: 68
	sta.w printx		; $8F867B: 8D 7B 04
	inc.w printy		; $8F867E: EE 7D 04
	rtl		; $8F8681: 6B
pushnumber:		;auto: CODE_8F8682. 93G pushnumber: mesarea string of the decimal number d0 (built backward from $1AF)
	lda.w #$01AF		; $8F8682: A9 AF 01
	sta.b a1		; $8F8685: 85 37
	lda.w #$0000		; $8F8687: A9 00 00
	sta.b a1+2		; $8F868A: 85 39
	lda.b d0		; $8F868C: A5 53
.l1:
	sta.b mulb		; $8F868E: 85 83
	lda.w #$000A		; $8F8690: A9 0A 00
	sta.b mula		; $8F8693: 85 7D
	jsl.l divu16		; $8F8695: 22 D8 B8 80
	dec.b a1		; $8F8699: C6 37
	sep #$20		; $8F869B: E2 20
	lda.b mulres+2		; $8F869D: A5 95
	adc.b #$30		; $8F869F: 69 30
	sta.b [a1]		; $8F86A1: 87 37
	rep #$30		; $8F86A3: C2 30
	lda.b mulres		; $8F86A5: A5 93
	bne .l1		; $8F86A7: D0 E5
	dec.b a1		; $8F86A9: C6 37
	dec.b a1		; $8F86AB: C6 37
	lda.w #$01AF		; $8F86AD: A9 AF 01
	sec		; $8F86B0: 38
	sbc.b a1		; $8F86B1: E5 37
	sta.b [a1]		; $8F86B3: 87 37
	rtl		; $8F86B5: 6B
Intermission:		;auto: CODE_8F86B6 (from PeriodOver). 93G Intermission (SNES form): the pause menu screen with the ticker scores of the other games (IntermissionTick), then the highlights
	jsl.l sndqreset		; $8F86B6: 22 1A FA 82
	jsl.l $8FE00A		; $8F86BA: 22 0A E0 8F  bank8F_D000: 93G SetupTeamForIntermission
	lda.w #$0000		; $8F86BE: A9 00 00
	ldy.w #$001E		; $8F86C1: A0 1E 00
.l1:
	sta.w Xpos,y		; $8F86C4: 99 FF 08
	dey		; $8F86C7: 88
	dey		; $8F86C8: 88
	bpl .l1		; $8F86C9: 10 F9
.l2:
	lda.b vcount		; $8F86CB: A5 00
	ldy.b vcount+2		; $8F86CD: A4 02
	cmp.b vcount		; $8F86CF: C5 00
	bne .l2		; $8F86D1: D0 F8
	sta.w vcountmark		; $8F86D3: 8D FB 08
	sty.w vcountmark+2		; $8F86D6: 8C FD 08
	lda.w #$0001		; $8F86D9: A9 01 00
	trb.w sflags		; $8F86DC: 1C 8C 12
	lda.w gsp		; $8F86DF: AD F0 12
	cmp.w #$0004		; $8F86E2: C9 04 00
	beq .l3		; $8F86E5: F0 02
	bra .l3		; $8F86E7: 80 00
.l3:
	lda.w #$0708		; $8F86E9: A9 08 07
	sta.b pausetimer		; $8F86EC: 85 EE
	lda.w #$0001		; $8F86EE: A9 01 00
	sta.w demoflag		; $8F86F1: 8D D5 08
	lda.b vcount		; $8F86F4: A5 00
	sec		; $8F86F6: 38
	sbc.w #$0150		; $8F86F7: E9 50 01
	sta.w tickervc		; $8F86FA: 8D D9 08
	jsl.l InitTicker		; $8F86FD: 22 3F 87 8F
	lda.w TickerNum		; $8F8701: AD D7 08
	sta.w tickerstart		; $8F8704: 8D 58 01
.l4:
	lda.w #$0000		; $8F8707: A9 00 00
	ldy.w #$001E		; $8F870A: A0 1E 00
.l5:
	sta.w Xpos,y		; $8F870D: 99 FF 08
	dey		; $8F8710: 88
	dey		; $8F8711: 88
	bpl .l5		; $8F8712: 10 F9
	jsl.l printz		; $8F8714: 22 0C B9 80
	dw $0005		; $8F8718  printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #$0016		; $8F871D: A9 16 00
	sta.b d0		; $8F8720: 85 53
	lda.w #$0007		; $8F8722: A9 07 00
	sta.b d1		; $8F8725: 85 57
	jsl.l $8FD69F		; $8F8727: 22 9F D6 8F  bank8F_D000: 93G Framer
	jsl.l printscores1		; $8F872B: 22 5D E9 89
	lda.w #$0002		; $8F872F: A9 02 00
	trb.w sflags		; $8F8732: 1C 8C 12
	jsl.l PauseMenu		; $8F8735: 22 91 F8 83
	bne .l4		; $8F8739: D0 CC
	stz.w demoflag		; $8F873B: 9C D5 08
.l6:
	rtl		; $8F873E: 6B
InitTicker:		;auto: CODE_8F873F. SNES: start the ticker at the last game of the round (GetShifter) unless one is running, then NewTicker2
	lda.w TickerNum		; $8F873F: AD D7 08
	bmi .l1		; $8F8742: 30 05
	ora.w gamenum		; $8F8744: 0D 4C 01
	bne .l2		; $8F8747: D0 0B
.l1:
	jsl.l GetShifter		; $8F8749: 22 A4 D5 85
	lda.b d1		; $8F874D: A5 57
	sta.w TickerNum		; $8F874F: 8D D7 08
	bmi Intermission_l6		; $8F8752: 30 EA
.l2:
	jmp.w NewTicker2		; $8F8754: 4C 61 88
StatsScreen:		;auto: CODE_8F8757 (pause menu). SNES: DisplayStats, then wait for A or 60 seconds
	jsl.l DisplayStats		; $8F8757: 22 E3 FA 84
	lda.b vcount		; $8F875B: A5 00
	pha		; $8F875D: 48
.l1:
	jsl.l setvideo		; $8F875E: 22 5E E3 80
	jsl.l ReadPads		; $8F8762: 22 E8 F3 80
	jsl.l getpzjoy		; $8F8766: 22 0E FF 85
	lda.b d1		; $8F876A: A5 57
	bit.w #$0080		; $8F876C: 89 80 00
	bne .l2		; $8F876F: D0 0A
	lda.b vcount		; $8F8771: A5 00
	sec		; $8F8773: 38
	sbc.b $01,s		; $8F8774: E3 01
	cmp.w #$0E10		; $8F8776: C9 10 0E
	bcc .l1		; $8F8779: 90 E3
.l2:
	pla		; $8F877B: 68
	rtl		; $8F877C: 6B
IntermissionTick:		;auto: CODE_8F877D (from PauseMenu). SNES: during the intermission show the next ticker score every $150 frames; after the last one the highlights (DoHiLights). A = 0: go on
	lda.w demoflag		; $8F877D: AD D5 08
	beq .l1		; $8F8780: F0 21
	lda.b vcount		; $8F8782: A5 00
	sec		; $8F8784: 38
	sbc.w tickervc		; $8F8785: ED D9 08
	cmp.w #$0150		; $8F8788: C9 50 01
	bcc .l2		; $8F878B: 90 17
	jsl.l TickerNext		; $8F878D: 22 A8 87 8F
	lda.w tickerstart		; $8F8791: AD 58 01
	cmp.w TickerNum		; $8F8794: CD D7 08
	bne IntermissionTick		; $8F8797: D0 E4
	jsl.l DoHiLights		; $8F8799: 22 1B 8C 8F
	lda.w #$0008		; $8F879D: A9 08 00
	trb.w sflags3		; $8F87A0: 1C 90 12
.l1:
	rtl		; $8F87A3: 6B
.l2:
	lda.w #$0000		; $8F87A4: A9 00 00
	rtl		; $8F87A7: 6B
TickerNext:		;auto: CODE_8F87A8. SNES: next ticker game (restart at the last game of the round), NewTicker2
	lda.w TickerNum		; $8F87A8: AD D7 08
	bmi .l1		; $8F87AB: 30 05
	ora.w gamenum		; $8F87AD: 0D 4C 01
	bne .l2		; $8F87B0: D0 0B
.l1:
	jsl.l GetShifter		; $8F87B2: 22 A4 D5 85
	lda.b d1		; $8F87B6: A5 57
	sta.w TickerNum		; $8F87B8: 8D D7 08
	bmi IntermissionTick_l1		; $8F87BB: 30 E6
.l2:
	jmp.w NewTicker2		; $8F87BD: 4C 61 88
KillCrowd:		;auto: CODE_8F87C0. 93G KillCrowd: crowd volume $88 (silence) to the sound driver
	lda.w #$0088		; $8F87C0: A9 88 00
	pha		; $8F87C3: 48
	jsl.l $8FFE8E		; $8F87C4: 22 8E FE 8F  bank8F_F000: crowd volume to the sound driver
	rtl		; $8F87C8: 6B
appstring:		;auto: CODE_8F87C9. 93G appstring: append string [a1] to the string [a3]
	lda.w #$0002		; $8F87C9: A9 02 00
	sta.b tmp0		; $8F87CC: 85 73
	lda.b [a3]		; $8F87CE: A7 3F
	sta.b tmp1		; $8F87D0: 85 75
.l1:
	lda.b tmp0		; $8F87D2: A5 73
	cmp.b [a1]		; $8F87D4: C7 37
	beq .l2		; $8F87D6: F0 0D
	tay		; $8F87D8: A8
	lda.b [a1],y		; $8F87D9: B7 37
	ldy.b tmp1		; $8F87DB: A4 75
	sta.b [a3],y		; $8F87DD: 97 3F
	inc.b tmp0		; $8F87DF: E6 73
	inc.b tmp1		; $8F87E1: E6 75
	bra .l1		; $8F87E3: 80 ED
.l2:
	lda.b tmp1		; $8F87E5: A5 75
	sta.b [a3]		; $8F87E7: 87 3F
	rtl		; $8F87E9: 6B
PushTime:		;auto: CODE_8F87EA. 93G PushTime: mesarea string m:ss of the time d0 (seconds)
	lda.w #$01AF		; $8F87EA: A9 AF 01
	sta.b a1		; $8F87ED: 85 37
	lda.w #$0000		; $8F87EF: A9 00 00
	sta.b a1+2		; $8F87F2: 85 39
	lda.b d0		; $8F87F4: A5 53
	sta.b mulb		; $8F87F6: 85 83
	lda.w #$000A		; $8F87F8: A9 0A 00
	sta.b mula		; $8F87FB: 85 7D
	jsl.l divu16		; $8F87FD: 22 D8 B8 80
	dec.b a1		; $8F8801: C6 37
	sep #$20		; $8F8803: E2 20
	lda.b mulres+2		; $8F8805: A5 95
	adc.b #$30		; $8F8807: 69 30
	sta.b [a1]		; $8F8809: 87 37
	rep #$30		; $8F880B: C2 30
	lda.w #$0006		; $8F880D: A9 06 00
	sta.b mula		; $8F8810: 85 7D
	jsl.l divu16		; $8F8812: 22 D8 B8 80
	dec.b a1		; $8F8816: C6 37
	sep #$20		; $8F8818: E2 20
	lda.b mulres+2		; $8F881A: A5 95
	adc.b #$30		; $8F881C: 69 30
	sta.b [a1]		; $8F881E: 87 37
	dec.b a1		; $8F8820: C6 37
	lda.b #$3A		; $8F8822: A9 3A
	sta.b [a1]		; $8F8824: 87 37
	rep #$30		; $8F8826: C2 30
	lda.w #$000A		; $8F8828: A9 0A 00
	sta.b mula		; $8F882B: 85 7D
	jsl.l divu16		; $8F882D: 22 D8 B8 80
	dec.b a1		; $8F8831: C6 37
	sep #$20		; $8F8833: E2 20
	lda.b mulres+2		; $8F8835: A5 95
	adc.b #$30		; $8F8837: 69 30
	sta.b [a1]		; $8F8839: 87 37
	rep #$30		; $8F883B: C2 30
	lda.b mulres		; $8F883D: A5 93
	beq .l1		; $8F883F: F0 0A
	dec.b a1		; $8F8841: C6 37
	sep #$20		; $8F8843: E2 20
	adc.b #$30		; $8F8845: 69 30
	sta.b [a1]		; $8F8847: 87 37
	rep #$30		; $8F8849: C2 30
.l1:
	dec.b a1		; $8F884B: C6 37
	dec.b a1		; $8F884D: C6 37
	lda.w #$01AF		; $8F884F: A9 AF 01
	sec		; $8F8852: 38
	sbc.b a1		; $8F8853: E5 37
	sta.b [a1]		; $8F8855: 87 37
	rtl		; $8F8857: 6B
NewTicker:		;auto: CODE_8F8858 (from chkprogress). 93G NewTicker: once the clock is at 8:00 or less, the next ticker score
	lda.w gameclock		; $8F8858: AD F2 12
	cmp.w #$01E1		; $8F885B: C9 E1 01
	bcc NewTicker2		; $8F885E: 90 01
	rtl		; $8F8860: 6B
NewTicker2:		;auto: CODE_8F8861. 93G NewTicker2/CheckGameTickerStatus: d3 = next ticker game (not the user game, no highlight coming, series not over)
	lda.w OptPlayMode		; $8F8861: AD 00 16
	beq .l1		; $8F8864: F0 13
	lda.w TickerNum		; $8F8866: AD D7 08
	sta.b d3		; $8F8869: 85 5F
	bmi .l1		; $8F886B: 30 0C
	dec.w TickerNum		; $8F886D: CE D7 08
	lda.b d3		; $8F8870: A5 5F
	cmp.w gamenum		; $8F8872: CD 4C 01
	beq NewTicker2		; $8F8875: F0 EA
	bra NewTicker3		; $8F8877: 80 01
.l1:
	rtl		; $8F8879: 6B
NewTicker3:		;auto: CODE_8F887A. 93G NewTicker3: the ticker box for game d3: GameLabels round name, period, both teams with scores (TickerTeam)
	lda.b d3		; $8F887A: A5 5F
	asl a		; $8F887C: 0A
	sta.b a0		; $8F887D: 85 33
	tay		; $8F887F: A8
	lda.w gsflags,y		; $8F8880: B9 EF 15
	bit.w #$0006		; $8F8883: 89 06 00
	bne NewTicker2		; $8F8886: D0 D9
	jsl.l printz		; $8F8888: 22 0C B9 80
	dw $0005		; $8F888C  printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
	lda.w sflags		; $8F8891: AD 8C 12
	bit.w #$0001		; $8F8894: 89 01 00
	bne .l1		; $8F8897: D0 09
	jsl.l printz		; $8F8899: 22 0C B9 80
	dw $0005		; $8F889D  printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
.l1:
	lda.w sfhormode		; $8F88A2: AD 8E 12
	bne .l2		; $8F88A5: D0 0A
	lda.w printy		; $8F88A7: AD 7D 04
	sec		; $8F88AA: 38
	sbc.w #$0005		; $8F88AB: E9 05 00
	sta.w printy		; $8F88AE: 8D 7D 04
.l2:
	lda.w #$001C		; $8F88B1: A9 1C 00
	sta.b d0		; $8F88B4: 85 53
	lda.w #$0005		; $8F88B6: A9 05 00
	sta.b d1		; $8F88B9: 85 57
	jsl.l $8FD69F		; $8F88BB: 22 9F D6 8F  bank8F_D000: 93G Framer
	lda.b vcount		; $8F88BF: A5 00
	sta.w tickervc		; $8F88C1: 8D D9 08
	inc.w printx		; $8F88C4: EE 7B 04
	lda.w printy		; $8F88C7: AD 7D 04
	sec		; $8F88CA: 38
	sbc.w #$0004		; $8F88CB: E9 04 00
	sta.w printy		; $8F88CE: 8D 7D 04
	lda.w printx		; $8F88D1: AD 7B 04
	pha		; $8F88D4: 48
	jsl.l GetShifter		; $8F88D5: 22 A4 D5 85
	lda.w #$2400		; $8F88D9: A9 00 24
	sta.w printa		; $8F88DC: 8D 77 04
	jsl.l printz		; $8F88DF: 22 0C B9 80
	dw $001C		; $8F88E3  printz inline string: length (counts itself), then control bytes / text
	db "                          "
	lda.b $01,s		; $8F88FF: A3 01
	sta.w printx		; $8F8901: 8D 7B 04
	lda.b d3		; $8F8904: A5 5F
	clc		; $8F8906: 18
	adc.b d2		; $8F8907: 65 5B
	sta.b d0		; $8F8909: 85 53
	lda.w #GameLabels		; $8F890B: A9 A3 89
	sta.b a1		; $8F890E: 85 37
	lda.w #GameLabels>>16		; $8F8910: A9 8F 00
	sta.b a1+2		; $8F8913: 85 39
	jsl.l $8FD68C		; $8F8915: 22 8C D6 8F  bank8F_D000: 93G PrintStringFromList
	lda.b $01,s		; $8F8919: A3 01
	clc		; $8F891B: 18
	adc.w #$0015		; $8F891C: 69 15 00
	sta.w printx		; $8F891F: 8D 7B 04
	ldy.b a0		; $8F8922: A4 33
	lda.w gsper,y		; $8F8924: B9 BF 15
	dec a		; $8F8927: 3A
	sta.b d0		; $8F8928: 85 53
	lda.w #PerLabels		; $8F892A: A9 36 82
	sta.b a1		; $8F892D: 85 37
	lda.w #PerLabels>>16		; $8F892F: A9 8F 00
	sta.b a1+2		; $8F8932: 85 39
	jsl.l $8FD68C		; $8F8934: 22 8C D6 8F  bank8F_D000: 93G PrintStringFromList
	lda.w #$2000		; $8F8938: A9 00 20
	sta.w printa		; $8F893B: 8D 77 04
	ldy.b a0		; $8F893E: A4 33
	lda.w gst1,y		; $8F8940: B9 7F 15
	sta.b d0		; $8F8943: 85 53
	lda.w gss1,y		; $8F8945: B9 CF 15
	sta.b d1		; $8F8948: 85 57
	jsl.l TickerTeam		; $8F894A: 22 60 89 8F
	ldy.b a0		; $8F894E: A4 33
	lda.w gst2,y		; $8F8950: B9 8F 15
	sta.b d0		; $8F8953: 85 53
	lda.w gss2,y		; $8F8955: B9 DF 15
	sta.b d1		; $8F8958: 85 57
	jsl.l TickerTeam		; $8F895A: 22 60 89 8F
	pla		; $8F895E: 68
	rtl		; $8F895F: 6B
TickerTeam:		;auto: CODE_8F8960. SNES: ticker line: team d0 name (TeamList record) and score d1, one row down
	lda.b $04,s		; $8F8960: A3 04
	sta.w printx		; $8F8962: 8D 7B 04
	inc.w printy		; $8F8965: EE 7D 04
	lda.w #TeamList		; $8F8968: A9 00 80
	sta.b a1		; $8F896B: 85 37
	lda.w #TeamList>>16		; $8F896D: A9 83 00
	sta.b a1+2		; $8F8970: 85 39
	asl.b d0		; $8F8972: 06 53
	asl.b d0		; $8F8974: 06 53
	ldy.b d0		; $8F8976: A4 53
	lda.b [a1],y		; $8F8978: B7 37
	sta.b a1		; $8F897A: 85 37
	lda.w #$0083		; $8F897C: A9 83 00
	sta.b a1+2		; $8F897F: 85 39
	ldy.w #$0004		; $8F8981: A0 04 00
	lda.b [a1],y		; $8F8984: B7 37
	adc.b a1		; $8F8986: 65 37
	sta.b a1		; $8F8988: 85 37
	jsl.l print		; $8F898A: 22 2D B9 80
	lda.b $04,s		; $8F898E: A3 04
	clc		; $8F8990: 18
	adc.w #$0017		; $8F8991: 69 17 00
	sta.w printx		; $8F8994: 8D 7B 04
	lda.b d1		; $8F8997: A5 57
	sta.b d0		; $8F8999: 85 53
	jsl.l pushnumber		; $8F899B: 22 82 86 8F
	jml.l print		; $8F899F: 5C 2D B9 80
GameLabels:		;SNES GameLabels (93G GameLabels): the ticker round names by playoff game (EASN Hockey Night for the regular season)
	dw 19		; $8F89A3
	db "EASN Hockey Night"
	dw 18		; $8F89B6
	db "EA Cup Qualifier"
	dw 18		; $8F89C8
	db "EA Cup Qualifier"
	dw 18		; $8F89DA
	db "EA Cup Qualifier"
	dw 18		; $8F89EC
	db "EA Cup Qualifier"
	dw 18		; $8F89FE
	db "EA Cup Qualifier"
	dw 18		; $8F8A10
	db "EA Cup Qualifier"
	dw 18		; $8F8A22
	db "EA Cup Qualifier"
	dw 18		; $8F8A34
	db "EA Cup Qualifier"
	dw 17		; $8F8A46
	db "EA Quarterfinal"
	dw 17		; $8F8A57
	db "EA Quarterfinal"
	dw 17		; $8F8A68
	db "EA Quarterfinal"
	dw 17		; $8F8A79
	db "EA Quarterfinal"
	dw 18		; $8F8A8A
	db "EA Cup Semifinal"
	dw 18		; $8F8A9C
	db "EA Cup Semifinal"
	dw 14		; $8F8AAE
	db "EA Cup final"
showzam:		;auto: CODE_8F8ABC (from setvideo). 93G showzam role: on the horizontal rink the zamboni sprite ($22D) moves with the time since vcountmark
	lda.b vcount		; $8F8ABC: A5 00
	ldy.b vcount+2		; $8F8ABE: A4 02
	cmp.b vcount		; $8F8AC0: C5 00
	bne showzam		; $8F8AC2: D0 F8
	sbc.w vcountmark		; $8F8AC4: ED FB 08
	sta.b tmp0		; $8F8AC7: 85 73
	tya		; $8F8AC9: 98
	sbc.w vcountmark+2		; $8F8ACA: ED FD 08
	bne .l1		; $8F8ACD: D0 19
	lda.w sfhormode		; $8F8ACF: AD 8E 12
	beq .l1		; $8F8AD2: F0 14
	lda.b tmp0		; $8F8AD4: A5 73
	lsr a		; $8F8AD6: 4A
	lsr a		; $8F8AD7: 4A
	sta.b sprx		; $8F8AD8: 85 C9
	lda.w #$00C8		; $8F8ADA: A9 C8 00
	sta.b spry		; $8F8ADD: 85 CB
	lda.w #$022D		; $8F8ADF: A9 2D 02
	sta.b sprframe		; $8F8AE2: 85 C3
	jsl.l $8FEC68		; $8F8AE4: 22 68 EC 8F  bank8F_E000: 93G addframe
.l1:
	rtl		; $8F8AE8: 6B
waitxsr:		;auto: CODE_8F8AE9. 92G waitxsr: wait d0 frames or until a pad button (d1)
	lda.b d0		; $8F8AE9: A5 53
	pha		; $8F8AEB: 48
.l1:
	jsl.l Readjoy1		; $8F8AEC: 22 0B C4 80
	lda.b d1		; $8F8AF0: A5 57
	bne .l3		; $8F8AF2: D0 1B
	jsl.l Readjoy2		; $8F8AF4: 22 29 C4 80
	lda.b d1		; $8F8AF8: A5 57
	bne .l3		; $8F8AFA: D0 13
	jsl.l setvideo		; $8F8AFC: 22 5E E3 80
	lda.b vcount		; $8F8B00: A5 00
.l2:
	cmp.b vcount		; $8F8B02: C5 00
	beq .l2		; $8F8B04: F0 FC
	jsl.l ReadPads		; $8F8B06: 22 E8 F3 80
	pla		; $8F8B0A: 68
	dec a		; $8F8B0B: 3A
	pha		; $8F8B0C: 48
	bpl .l1		; $8F8B0D: 10 DD
.l3:
	pla		; $8F8B0F: 68
	rtl		; $8F8B10: 6B
clockcont:		;auto: CODE_8F8B11 (from periodicevents). 93G clockcont (hockey93_01): clock at 0: freezewindow, then clockcont_0
	lda.w gmclock		; $8F8B11: AD 8A 12
	ora.w gameclock		; $8F8B14: 0D F2 12
	bne .l1		; $8F8B17: D0 07
	jsl.l freezewindow		; $8F8B19: 22 78 C2 80
	jmp.w clockcont_0		; $8F8B1D: 4C 21 8B
.l1:
	rtl		; $8F8B20: 6B
clockcont_0:		;auto: CODE_8F8B21 (also from puckfaceoff). 93G clockcont_0: end of period: puck pucknorm; third period winners celebrate (assscore, the Stanley Cup in the final), the game clock stops
	ldx.w #$001C		; $8F8B21: A2 1C 00
	stx.b a3		; $8F8B24: 86 3F
	lda.w #$18		; $8F8B26: A9 18 00
	sta.b d0		; $8F8B29: 85 53
	jsl.l assinsert		; $8F8B2B: 22 9D B4 80
	lda.w gsp		; $8F8B2F: AD F0 12
	cmp.w #$0002		; $8F8B32: C9 02 00
	bcs .l1		; $8F8B35: B0 03
	jmp.w .l11		; $8F8B37: 4C 05 8C
.l1:
	lda.w #$0007		; $8F8B3A: A9 07 00
	sta.b d0		; $8F8B3D: 85 53
	ldx.w #$0000		; $8F8B3F: A2 00 00
	stx.b a3		; $8F8B42: 86 3F
	lda.w gamelevel		; $8F8B44: AD 4A 01
	cmp.w #$0003		; $8F8B47: C9 03 00
	bne .l6		; $8F8B4A: D0 58
	lda.b bosgames		; $8F8B4C: A5 D6
	cmp.w #$0007		; $8F8B4E: C9 07 00
	beq .l4		; $8F8B51: F0 33
	lda.w gamenum		; $8F8B53: AD 4C 01
	asl a		; $8F8B56: 0A
	sta.b a0		; $8F8B57: 85 33
	tay		; $8F8B59: A8
	stz.b d3		; $8F8B5A: 64 5F
	lda.w gsflags,y		; $8F8B5C: B9 EF 15
	bit.w #$0001		; $8F8B5F: 89 01 00
	beq .l2		; $8F8B62: F0 05
	lda.w #$0010		; $8F8B64: A9 10 00
	sta.b d3		; $8F8B67: 85 5F
.l2:
	lda.w tmscore		; $8F8B69: AD D6 13
	cmp.w tmscore+2		; $8F8B6C: CD D8 13
	bpl .l3		; $8F8B6F: 10 07
	lda.b d3		; $8F8B71: A5 5F
	eor.w #$0010		; $8F8B73: 49 10 00
	sta.b d3		; $8F8B76: 85 5F
.l3:
	lda.b a0		; $8F8B78: A5 33
	clc		; $8F8B7A: 18
	adc.b d3		; $8F8B7B: 65 5F
	tay		; $8F8B7D: A8
	lda.w gspotwins,y		; $8F8B7E: B9 9F 15
	cmp.w #$0003		; $8F8B81: C9 03 00
	bne .l6		; $8F8B84: D0 1E
.l4:
	lda.w #$0008		; $8F8B86: A9 08 00
	sta.b d0		; $8F8B89: 85 53
	lda.w #$000B		; $8F8B8B: A9 0B 00
	sta.b d2		; $8F8B8E: 85 5B
.l5:
	lda.w pflags,x		; $8F8B90: BD DF 0E
	and.w #$FFF7		; $8F8B93: 29 F7 FF
	sta.w pflags,x		; $8F8B96: 9D DF 0E
	inx		; $8F8B99: E8
	inx		; $8F8B9A: E8
	dec.b d2		; $8F8B9B: C6 5B
	bpl .l5		; $8F8B9D: 10 F1
	ldx.w #$0000		; $8F8B9F: A2 00 00
	stx.b a3		; $8F8BA2: 86 3F
.l6:
	lda.w #$0005		; $8F8BA4: A9 05 00
	sta.b d2		; $8F8BA7: 85 5B
	lda.w tmscore		; $8F8BA9: AD D6 13
	cmp.w tmscore+2		; $8F8BAC: CD D8 13
	beq .l11		; $8F8BAF: F0 54
	bpl .l7		; $8F8BB1: 10 05
	ldx.w #$000C		; $8F8BB3: A2 0C 00
	stx.b a3		; $8F8BB6: 86 3F
.l7:
	lda.w position,x		; $8F8BB8: BD 9F 0B
	beq .l8		; $8F8BBB: F0 09
	jsl.l assinsert		; $8F8BBD: 22 9D B4 80
	lda.w #$0007		; $8F8BC1: A9 07 00
	sta.b d0		; $8F8BC4: 85 53
.l8:
	inx		; $8F8BC6: E8
	inx		; $8F8BC7: E8
	stx.b a3		; $8F8BC8: 86 3F
	dec.b d2		; $8F8BCA: C6 5B
	bpl .l7		; $8F8BCC: 10 EA
.l9:
	jsl.l $8FE2F9		; $8F8BCE: 22 F9 E2 8F  bank8F_E000: 93G ClearPenaltyBuffer
	lda.b crowdlevel		; $8F8BD2: A5 DE
	clc		; $8F8BD4: 18
	adc.w #$03E8		; $8F8BD5: 69 E8 03
	sta.b crowdlevel		; $8F8BD8: 85 DE
	lda.w #$0040		; $8F8BDA: A9 40 00
	sta.w gmclock		; $8F8BDD: 8D 8A 12
	tsb.w gmode		; $8F8BE0: 0C 88 12
	lda.w tmscore		; $8F8BE3: AD D6 13
	cmp.w tmscore+2		; $8F8BE6: CD D8 13
	bmi .l10		; $8F8BE9: 30 11
	stz.b crowdlevel		; $8F8BEB: 64 DE
	lda.w #$0003		; $8F8BED: A9 03 00
	sta.w cheercnt		; $8F8BF0: 8D 50 01
	lda.b vcount		; $8F8BF3: A5 00
	sec		; $8F8BF5: 38
	sbc.w #$0096		; $8F8BF6: E9 96 00
	sta.w cheervc		; $8F8BF9: 8D 52 01
.l10:
	lda.w #$0004		; $8F8BFC: A9 04 00
	sta.b d0		; $8F8BFF: 85 53
	jml.l AddPenalty2		; $8F8C01: 5C B0 C1 80
.l11:
	lda.w gsp		; $8F8C05: AD F0 12
	cmp.w #$0003		; $8F8C08: C9 03 00
	bne .l12		; $8F8C0B: D0 05
	lda.w OptPlayMode		; $8F8C0D: AD 00 16
	beq .l9		; $8F8C10: F0 BC
.l12:
	lda.w #$0002		; $8F8C12: A9 02 00
	sta.b d0		; $8F8C15: 85 53
	jml.l AddPenalty2		; $8F8C17: 5C B0 C1 80
DoHiLights:		;auto: CODE_8F8C1B. 92G DoHiLights: in the playoffs play the highlight of each game of the round that asks for one (gsfhl, StartHL2)
	lda.w OptPlayMode		; $8F8C1B: AD 00 16
	beq .l3		; $8F8C1E: F0 2A
	jsl.l GetShifter		; $8F8C20: 22 A4 D5 85
	lda.b d1		; $8F8C24: A5 57
	asl a		; $8F8C26: 0A
	sta.b a0		; $8F8C27: 85 33
.l1:
	ldy.b a0		; $8F8C29: A4 33
	lda.w gsflags,y		; $8F8C2B: B9 EF 15
	bit.w #$0004		; $8F8C2E: 89 04 00
	bne .l2		; $8F8C31: D0 0F
	bit.w #$0002		; $8F8C33: 89 02 00
	beq .l2		; $8F8C36: F0 0A
	and.w #$FFFD		; $8F8C38: 29 FD FF
	sta.w gsflags,y		; $8F8C3B: 99 EF 15
	jsl.l far8DF888		; $8F8C3E: 22 97 FC 82
.l2:
	dec.b a0		; $8F8C42: C6 33
	dec.b a0		; $8F8C44: C6 33
	dec.b d1		; $8F8C46: C6 57
	bpl .l1		; $8F8C48: 10 DF
.l3:
	rtl		; $8F8C4A: 6B
assdopen:		;auto: CODE_8F8C4B (asstab $D). 93G assdopen (logic93_2): add player X to the penalty box (PBnum), position -1, frame 0
	lda.w pfalock,x		; $8F8C4B: BD 7F 11
	bne .l2		; $8F8C4E: D0 21
	lda.w #$0010		; $8F8C50: A9 10 00
	sta.b d0		; $8F8C53: 85 53
	lda.w pfteam,x		; $8F8C55: BD 9F 11
	beq .l1		; $8F8C58: F0 05
	lda.w #$0001		; $8F8C5A: A9 01 00
	sta.b d0		; $8F8C5D: 85 53
.l1:
	lda.w PBnum		; $8F8C5F: AD E4 12
	clc		; $8F8C62: 18
	adc.b d0		; $8F8C63: 65 53
	sta.w PBnum		; $8F8C65: 8D E4 12
	lda.w #$FFFF		; $8F8C68: A9 FF FF
	sta.w position,x		; $8F8C6B: 9D 9F 0B
	stz.w frame,x		; $8F8C6E: 9E 3F 09
.l2:
	rtl		; $8F8C71: 6B
updatepentime:		;auto: CODE_8F8C72. 93G updatepentime: once a second count down the penalty box times of both teams; release players whose time is up
	lda.w #$0020		; $8F8C72: A9 20 00
	trb.w sflags3		; $8F8C75: 1C 90 12
	lda.w gmclock		; $8F8C78: AD 8A 12
	bne .l5		; $8F8C7B: D0 7F
	lda.w pentimer		; $8F8C7D: AD E2 12
	sec		; $8F8C80: 38
	sbc.b d7		; $8F8C81: E5 6F
	sta.w pentimer		; $8F8C83: 8D E2 12
	bpl .l5		; $8F8C86: 10 74
	adc.w #$0018		; $8F8C88: 69 18 00
	sta.w pentimer		; $8F8C8B: 8D E2 12
	lda.w #$0020		; $8F8C8E: A9 20 00
	tsb.w sflags3		; $8F8C91: 0C 90 12
	jsl.l chkatop		; $8F8C94: 22 D6 E6 80
	stz.b a2		; $8F8C98: 64 3B
	jsl.l .team		; $8F8C9A: 22 A3 8C 8F
	lda.w #$0002		; $8F8C9E: A9 02 00
	sta.b a2		; $8F8CA1: 85 3B
.team:		;team a2
	lda.b a2		; $8F8CA3: A5 3B
	beq .l1		; $8F8CA5: F0 03
	lda.w #$001A		; $8F8CA7: A9 1A 00
.l1:
	sta.b a0		; $8F8CAA: 85 33
	lda.w #$0191		; $8F8CAC: A9 91 01
	sta.b a1		; $8F8CAF: 85 37
	lda.w #$0000		; $8F8CB1: A9 00 00
	sta.b a1+2		; $8F8CB4: 85 39
	lda.w #$0002		; $8F8CB6: A9 02 00
	sta.b d1		; $8F8CB9: 85 57
	sta.b d3		; $8F8CBB: 85 5F
.l2:
	ldy.b a0		; $8F8CBD: A4 33
	lda.w tmboxlist,y		; $8F8CBF: B9 4A 15
	inc.b a0		; $8F8CC2: E6 33
	and.w #$00FF		; $8F8CC4: 29 FF 00
	sta.b d0		; $8F8CC7: 85 53
	bit.w #$0080		; $8F8CC9: 89 80 00
	bne .l6		; $8F8CCC: D0 2F
	lda.b a2		; $8F8CCE: A5 3B
	beq .l3		; $8F8CD0: F0 03
	lda.w #$0034		; $8F8CD2: A9 34 00
.l3:
	clc		; $8F8CD5: 18
	adc.b d0		; $8F8CD6: 65 53
	tay		; $8F8CD8: A8
	lda.w tmpdst,y		; $8F8CD9: B9 E2 14
	bit.w #$4000		; $8F8CDC: 89 00 40
	bne .l13		; $8F8CDF: D0 64
	dec.b d1		; $8F8CE1: C6 57
	bmi .l2		; $8F8CE3: 30 D8
	lda.b d0		; $8F8CE5: A5 53
	sta.b [a1]		; $8F8CE7: 87 37
	inc.b a1		; $8F8CE9: E6 37
	inc.b a1		; $8F8CEB: E6 37
	lda.w tmpdst,y		; $8F8CED: B9 E2 14
	dec a		; $8F8CF0: 3A
	sta.w tmpdst,y		; $8F8CF1: 99 E2 14
	bne .l4		; $8F8CF4: D0 04
	jsl.l $8FDAFC		; $8F8CF6: 22 FC DA 8F  bank8F_D000: 93G RemovePlayerFromList
.l4:
	bra .l2		; $8F8CFA: 80 C1
.l5:
	rtl		; $8F8CFC: 6B
.l6:
	lda.w mesarea		; $8F8CFD: AD 91 01
	sta.b d0		; $8F8D00: 85 53
	lda.b d1		; $8F8D02: A5 57
	cmp.w #$0001		; $8F8D04: C9 01 00
	beq .rel		; $8F8D07: F0 16
	lda.b d1		; $8F8D09: A5 57
	bne .l7		; $8F8D0B: D0 06
	jsl.l .rel		; $8F8D0D: 22 1F 8D 8F
	bra .l8		; $8F8D11: 80 07
.l7:
	lda.b d1		; $8F8D13: A5 57
	cmp.w #$FFFF		; $8F8D15: C9 FF FF
	bne .l5		; $8F8D18: D0 E2
.l8:
	lda.w mesarea+2		; $8F8D1A: AD 93 01
	sta.b d0		; $8F8D1D: 85 53
.rel:		;release player d0 when his time is <= 5 (RemovePlayerFromList)
	lda.b a2		; $8F8D1F: A5 3B
	beq .l9		; $8F8D21: F0 03
	lda.w #$0034		; $8F8D23: A9 34 00
.l9:
	clc		; $8F8D26: 18
	adc.b d0		; $8F8D27: 65 53
	tay		; $8F8D29: A8
	lda.w tmpdst,y		; $8F8D2A: B9 E2 14
	sec		; $8F8D2D: 38
	sbc.w #$0005		; $8F8D2E: E9 05 00
	beq .l11		; $8F8D31: F0 08
	bmi .l10		; $8F8D33: 30 04
	bvs .l11		; $8F8D35: 70 04
	bra .l5		; $8F8D37: 80 C3
.l10:
	bvs .l5		; $8F8D39: 70 C1
.l11:
	lda.w tmpdst,y		; $8F8D3B: B9 E2 14
	bne .l12		; $8F8D3E: D0 04
	jsl.l $8FD9DF		; $8F8D40: 22 DF D9 8F  bank8F_D000: release player d0
.l12:
	rtl		; $8F8D44: 6B
.l13:
	dec a		; $8F8D45: 3A
	sta.w tmpdst,y		; $8F8D46: 99 E2 14
	bit.w #$0800		; $8F8D49: 89 00 08
	bne .l14		; $8F8D4C: D0 03
	jmp.w .l2		; $8F8D4E: 4C BD 8C
.l14:
	bit.w #$1000		; $8F8D51: 89 00 10
	bne .l15		; $8F8D54: D0 09
	lda.w #$1000		; $8F8D56: A9 00 10
	sta.w tmpdst,y		; $8F8D59: 99 E2 14
	jmp.w $DAFC		; $8F8D5C: 4C FC DA  bank8F_D000: 93G RemovePlayerFromList
.l15:
	lda.w #$0000		; $8F8D5F: A9 00 00
	sta.w tmpdst,y		; $8F8D62: 99 E2 14
	jmp.w $DAFC		; $8F8D65: 4C FC DA  bank8F_D000: 93G RemovePlayerFromList
linebar:		;auto: CODE_8F8D68 (line change box). 93G linebar: energy bar of line d0 (getlinee) as 5 small font characters
	jsl.l getlinee		; $8F8D68: 22 05 84 88
	lda.w printa		; $8F8D6C: AD 77 04
	pha		; $8F8D6F: 48
	lda.w #$3000		; $8F8D70: A9 00 30
	sta.w printa		; $8F8D73: 8D 77 04
	lda.b d0		; $8F8D76: A5 53
	cmp.w #$1000		; $8F8D78: C9 00 10
	bcc .l1		; $8F8D7B: 90 03
	lda.w #$1000		; $8F8D7D: A9 00 10
.l1:
	sta.b d0		; $8F8D80: 85 53
	sta.b mula		; $8F8D82: 85 7D
	lda.w #$002F		; $8F8D84: A9 2F 00
	sta.b mulb		; $8F8D87: 85 83
	jsl.l mulu		; $8F8D89: 22 42 89 88
	lda.b mulres+2		; $8F8D8D: A5 95
	adc.w #$001D		; $8F8D8F: 69 1D 00
	sta.w mesarea+2		; $8F8D92: 8D 93 01
	sta.w mesarea+3		; $8F8D95: 8D 94 01
	sta.w mesarea+4		; $8F8D98: 8D 95 01
	sta.w mesarea+5		; $8F8D9B: 8D 96 01
	sta.w mesarea+6		; $8F8D9E: 8D 97 01
	lda.w #$0191		; $8F8DA1: A9 91 01
	sta.b a1		; $8F8DA4: 85 37
	lda.w #$0000		; $8F8DA6: A9 00 00
	sta.b a1+2		; $8F8DA9: 85 39
	lda.b d0		; $8F8DAB: A5 53
	sta.b mula		; $8F8DAD: 85 7D
	lda.w #$0054		; $8F8DAF: A9 54 00
	sta.b mulb		; $8F8DB2: 85 83
	jsl.l mulu		; $8F8DB4: 22 42 89 88
	lda.b mulres+2		; $8F8DB8: A5 95
	inc a		; $8F8DBA: 1A
	inc a		; $8F8DBB: 1A
	sta.b [a1]		; $8F8DBC: 87 37
	jsl.l print		; $8F8DBE: 22 2D B9 80
	pla		; $8F8DC2: 68
	sta.w printa		; $8F8DC3: 8D 77 04
	rtl		; $8F8DC6: 6B
lcfound:		;auto: CODE_8F8DC7. 93G lcfound (logic93_1): d2 = line choice 0-2: getlchoice; loadTeamStruct, tmline, setpersonel, lcfound2
	ldx.b a3		; $8F8DC7: A6 3F
	ldy.b a2		; $8F8DC9: A4 3B
	lda.b d2		; $8F8DCB: A5 5B
	sta.b d0		; $8F8DCD: 85 53
	sta.w tmlcchoice,y		; $8F8DCF: 99 0E 14
	jsl.l getlchoice		; $8F8DD2: 22 6D FD 8A
	lda.b d0		; $8F8DD6: A5 53
	bmi .l1		; $8F8DD8: 30 28
	lda.w pflags,x		; $8F8DDA: BD DF 0E
	and.w #$DFFF		; $8F8DDD: 29 FF DF
	ora.w #$0008		; $8F8DE0: 09 08 00
	sta.w pflags,x		; $8F8DE3: 9D DF 0E
	jsl.l $8FDBF9		; $8F8DE6: 22 F9 DB 8F  bank8F_D000: 93G loadTeamStruct
	ldy.b a2		; $8F8DEA: A4 3B
	lda.w tmflags,y		; $8F8DEC: B9 0A 14
	and.w #$FFF7		; $8F8DEF: 29 F7 FF
	sta.w tmflags,y		; $8F8DF2: 99 0A 14
	lda.b d0		; $8F8DF5: A5 53
	sta.w tmline,y		; $8F8DF7: 99 DE 13
	jsl.l setpersonel		; $8F8DFA: 22 5A BB 80
	jml.l lcfound2		; $8F8DFE: 5C B7 FC 86
.l1:
	rtl		; $8F8E02: 6B
startpause1:		;auto: CODE_8F8E03. 93G startpause1: pause started by controller 1 (sfpj off), startpause
	lda.w #$0002		; $8F8E03: A9 02 00
	trb.w sflags		; $8F8E06: 1C 8C 12
	jml.l startpause		; $8F8E09: 5C E1 F3 80
PauseExit:		;auto: CODE_8F8E0D. 92G PauseExit: restore textmap (textsave), sflags and the rink, printscores1, setvideo
	stz.w cuetimer		; $8F8E0D: 9C A9 04
	stz.w crowdvol		; $8F8E10: 9C 46 16
	jsl.l $8FE404		; $8F8E13: 22 04 E4 8F  bank8F_E000: 93G forceblack
	phx		; $8F8E17: DA
	ldx.w #$07FE		; $8F8E18: A2 FE 07
.l1:
	lda.l textsave,x		; $8F8E1B: BF 00 F8 7F
	sta.l textmap,x		; $8F8E1F: 9F 74 6E 7E
	dex		; $8F8E23: CA
	dex		; $8F8E24: CA
	bpl .l1		; $8F8E25: 10 F4
	plx		; $8F8E27: FA
	stz.b textdirtylo		; $8F8E28: 64 D0
	lda.w #$03FF		; $8F8E2A: A9 FF 03
	sta.b textdirtyhi		; $8F8E2D: 85 D2
	pla		; $8F8E2F: 68
	sta.w sflags		; $8F8E30: 8D 8C 12
	pla		; $8F8E33: 68
	sta.w sfhormode		; $8F8E34: 8D 8E 12
	bne .l2		; $8F8E37: D0 04
	jsl.l ClrHor		; $8F8E39: 22 28 A8 80
.l2:
	lda.w #$0001		; $8F8E3D: A9 01 00
	trb.w sflags		; $8F8E40: 1C 8C 12
	jsl.l printscores1		; $8F8E43: 22 5D E9 89
	jsl.l setvideo		; $8F8E47: 22 5E E3 80
	lda.b vcount		; $8F8E4B: A5 00
	sta.w lastframevc		; $8F8E4D: 8D DB 08
	sta.w oldvcount		; $8F8E50: 8D 27 04
	rtl		; $8F8E53: 6B
suba4:		;auto: CODE_8F8E54. 93G suba4: replay a4 one frame back (wrap at ReplayBufferStart unless sfwrap), RestoreReplayFrame; d7 = 0 at the end
	lda.b a4		; $8F8E54: A5 43
	cmp.w #ReplayBufferStart		; $8F8E56: C9 74 81
	bne .l1		; $8F8E59: D0 19
	lda.b a4+2		; $8F8E5B: A5 45
	cmp.w #ReplayBufferStart>>16		; $8F8E5D: C9 7E 00
	bne .l1		; $8F8E60: D0 12
	lda.w sflags		; $8F8E62: AD 8C 12
	bit.w #sfwrap		; $8F8E65: 89 10 00
	beq .l4		; $8F8E68: F0 3E
	lda.w #ReplayBufferEnd		; $8F8E6A: A9 41 FF
	sta.b a4		; $8F8E6D: 85 43
	lda.w #ReplayBufferEnd>>16		; $8F8E6F: A9 7E 00
	sta.b a4+2		; $8F8E72: 85 45
.l1:
	lda.b a4		; $8F8E74: A5 43
	sec		; $8F8E76: 38
	sbc.w #replaysize		; $8F8E77: E9 71 00
	sta.b a4		; $8F8E7A: 85 43
	lda.b a4+2		; $8F8E7C: A5 45
	sbc.w #$0000		; $8F8E7E: E9 00 00
	sta.b a4+2		; $8F8E81: 85 45
	lda.b a4		; $8F8E83: A5 43
	cmp.w ReplayBufferPtr		; $8F8E85: CD 95 04
	beq .l2		; $8F8E88: F0 04
	jml.l RestoreReplayFrame		; $8F8E8A: 5C E9 F3 87
.l2:
	lda.b a4+2		; $8F8E8E: A5 45
	cmp.w ReplayBufferPtr+2		; $8F8E90: CD 97 04
	beq .l3		; $8F8E93: F0 04
	jml.l RestoreReplayFrame		; $8F8E95: 5C E9 F3 87
.l3:
	lda.b a4		; $8F8E99: A5 43
	clc		; $8F8E9B: 18
	adc.w #replaysize		; $8F8E9C: 69 71 00
	sta.b a4		; $8F8E9F: 85 43
	lda.b a4+2		; $8F8EA1: A5 45
	adc.w #$0000		; $8F8EA3: 69 00 00
	sta.b a4+2		; $8F8EA6: 85 45
.l4:
	jsl.l RestoreReplayFrame		; $8F8EA8: 22 E9 F3 87
	stz.b d7		; $8F8EAC: 64 6F
	rtl		; $8F8EAE: 6B
adda4:		;auto: CODE_8F8EAF. 93G adda4: replay a4 one frame on unless it reaches ReplayBufferPtr; d7 = 0 at the end
	stz.b d7		; $8F8EAF: 64 6F
	lda.w sflags		; $8F8EB1: AD 8C 12
	bit.w #sf2drec		; $8F8EB4: 89 00 04
	beq .l1		; $8F8EB7: F0 27
	lda.b a4+2		; $8F8EB9: A5 45
	pha		; $8F8EBB: 48
	lda.b a4		; $8F8EBC: A5 43
	pha		; $8F8EBE: 48
	jsl.l adda43		; $8F8EBF: 22 6E F3 80
	lda.b a4		; $8F8EC3: A5 43
	sta.b tmp0		; $8F8EC5: 85 73
	lda.b a4+2		; $8F8EC7: A5 45
	sta.b tmp1		; $8F8EC9: 85 75
	pla		; $8F8ECB: 68
	sta.b a4		; $8F8ECC: 85 43
	pla		; $8F8ECE: 68
	sta.b a4+2		; $8F8ECF: 85 45
	lda.b tmp0		; $8F8ED1: A5 73
	cmp.w ReplayBufferPtr		; $8F8ED3: CD 95 04
	bne .l1		; $8F8ED6: D0 08
	lda.b tmp1		; $8F8ED8: A5 75
	cmp.w ReplayBufferPtr+2		; $8F8EDA: CD 97 04
	bne .l1		; $8F8EDD: D0 01
	rtl		; $8F8EDF: 6B
.l1:
	lda.b a4		; $8F8EE0: A5 43
	cmp.w ReplayBufferPtr		; $8F8EE2: CD 95 04
	bne .l2		; $8F8EE5: D0 08
	lda.b a4+2		; $8F8EE7: A5 45
	cmp.w ReplayBufferPtr+2		; $8F8EE9: CD 97 04
	bne .l2		; $8F8EEC: D0 01
	rtl		; $8F8EEE: 6B
.l2:
	jsl.l RestoreReplayFrame		; $8F8EEF: 22 E9 F3 87
	jml.l adda43		; $8F8EF3: 5C 6E F3 80
QueueTextDMA:		;auto: CODE_8F8EF7. SNES: DMAList entry for the changed textmap words (textdirtylo..textdirtyhi) to vram
	lda.b textdirtylo		; $8F8EF7: A5 D0
	bmi .l1		; $8F8EF9: 30 2C
	ldy.b DMAListend		; $8F8EFB: A4 A3
	sta.w DMAList+dmavram,y		; $8F8EFD: 99 58 16
	asl a		; $8F8F00: 0A
	adc.w #textmap		; $8F8F01: 69 74 6E
	sta.w DMAList,y		; $8F8F04: 99 53 16
	lda.w #textmap>>16		; $8F8F07: A9 7E 00
	sta.w DMAList+dmabank,y		; $8F8F0A: 99 55 16
	lda.b textdirtyhi		; $8F8F0D: A5 D2
	beq .l1		; $8F8F0F: F0 16
	sec		; $8F8F11: 38
	sbc.b textdirtylo		; $8F8F12: E5 D0
	inc a		; $8F8F14: 1A
	asl a		; $8F8F15: 0A
	sta.w DMAList+dmalen,y		; $8F8F16: 99 56 16
	lda.w #$FFFF		; $8F8F19: A9 FF FF
	sta.b textdirtylo		; $8F8F1C: 85 D0
	stz.b textdirtyhi		; $8F8F1E: 64 D2
	tya		; $8F8F20: 98
	clc		; $8F8F21: 18
	adc.w #dmasize		; $8F8F22: 69 07 00
	sta.b DMAListend		; $8F8F25: 85 A3
.l1:
	rtl		; $8F8F27: 6B
QueueBackmapDMA:		;auto: CODE_8F8F28. SNES: DMAList entry for backmap ($800 bytes) to vram $400
	ldy.b DMAListend		; $8F8F28: A4 A3
	lda.w #backmap		; $8F8F2A: A9 74 76
	sta.w DMAList,y		; $8F8F2D: 99 53 16
	lda.w #backmap>>16		; $8F8F30: A9 7E 00
	sta.w DMAList+dmabank,y		; $8F8F33: 99 55 16
	lda.w #$0800		; $8F8F36: A9 00 08
	sta.w DMAList+dmalen,y		; $8F8F39: 99 56 16
	lda.w #$0400		; $8F8F3C: A9 00 04
	sta.w DMAList+dmavram,y		; $8F8F3F: 99 58 16
	tya		; $8F8F42: 98
	clc		; $8F8F43: 18
	adc.w #dmasize		; $8F8F44: 69 07 00
	sta.b DMAListend		; $8F8F47: 85 A3
	rtl		; $8F8F49: 6B
ShowRinkRows:		;auto: CODE_8F8F4A (from setvideo). 93G show_rink role: DMAList entries for the IceRinkMap rows that Vscroll brought on screen (Oldrow, vramrow)
	ldy.b DMAListend		; $8F8F4A: A4 A3
	lda.w Vscroll		; $8F8F4C: AD E1 08
	clc		; $8F8F4F: 18
	adc.w #$0170		; $8F8F50: 69 70 01
	lsr a		; $8F8F53: 4A
	lsr a		; $8F8F54: 4A
	lsr a		; $8F8F55: 4A
	tax		; $8F8F56: AA
	sec		; $8F8F57: 38
	sbc.w Oldrow		; $8F8F58: ED 9B 04
	bne .l1		; $8F8F5B: D0 03
	jmp.w .l7		; $8F8F5D: 4C 17 90
.l1:
	bpl .l3		; $8F8F60: 10 2A
	stx.w Oldrow		; $8F8F62: 8E 9B 04
	eor.w #$FFFF		; $8F8F65: 49 FF FF
	inc a		; $8F8F68: 1A
	cmp.w #$0019		; $8F8F69: C9 19 00
	bcs .l2		; $8F8F6C: B0 12
	sta.b tmp1		; $8F8F6E: 85 75
	lda.w vramrow		; $8F8F70: AD 9D 04
	sec		; $8F8F73: 38
	sbc.b tmp1		; $8F8F74: E5 75
	and.w #$001F		; $8F8F76: 29 1F 00
	sta.w vramrow		; $8F8F79: 8D 9D 04
	sta.b tmp2		; $8F8F7C: 85 77
	bra .l4		; $8F8F7E: 80 33
.l2:
	lda.w #$001D		; $8F8F80: A9 1D 00
	sta.b tmp1		; $8F8F83: 85 75
	stz.w vramrow		; $8F8F85: 9C 9D 04
	stz.b tmp2		; $8F8F88: 64 77
	bra .l4		; $8F8F8A: 80 27
.l3:
	stx.w Oldrow		; $8F8F8C: 8E 9B 04
	cmp.w #$0019		; $8F8F8F: C9 19 00
	bcs .l2		; $8F8F92: B0 EC
	sta.b tmp1		; $8F8F94: 85 75
	adc.w vramrow		; $8F8F96: 6D 9D 04
	and.w #$001F		; $8F8F99: 29 1F 00
	sta.w vramrow		; $8F8F9C: 8D 9D 04
	adc.w #$001D		; $8F8F9F: 69 1D 00
	sec		; $8F8FA2: 38
	sbc.b tmp1		; $8F8FA3: E5 75
	and.w #$001F		; $8F8FA5: 29 1F 00
	sta.b tmp2		; $8F8FA8: 85 77
	txa		; $8F8FAA: 8A
	clc		; $8F8FAB: 18
	adc.w #$001D		; $8F8FAC: 69 1D 00
	sec		; $8F8FAF: 38
	sbc.b tmp1		; $8F8FB0: E5 75
	tax		; $8F8FB2: AA
.l4:
	txa		; $8F8FB3: 8A
	asl a		; $8F8FB4: 0A
	asl a		; $8F8FB5: 0A
	asl a		; $8F8FB6: 0A
	asl a		; $8F8FB7: 0A
	asl a		; $8F8FB8: 0A
	sta.b tmp0		; $8F8FB9: 85 73
	asl a		; $8F8FBB: 0A
	adc.b tmp0		; $8F8FBC: 65 73
	adc.w #IceRinkMap		; $8F8FBE: 69 CB CC
	sta.b tmp0		; $8F8FC1: 85 73
	lda.b tmp2		; $8F8FC3: A5 77
	asl a		; $8F8FC5: 0A
	asl a		; $8F8FC6: 0A
	asl a		; $8F8FC7: 0A
	asl a		; $8F8FC8: 0A
	asl a		; $8F8FC9: 0A
	adc.w #$0400		; $8F8FCA: 69 00 04
	sta.b tmp2		; $8F8FCD: 85 77
	ldx.b tmp1		; $8F8FCF: A6 75
.l5:
	lda.w #IceRinkMap>>16		; $8F8FD1: A9 83 00
	sta.w DMAList+dmabank,y		; $8F8FD4: 99 55 16
	sta.w DMAList+dmasize+dmabank,y		; $8F8FD7: 99 5C 16
	lda.b tmp2		; $8F8FDA: A5 77
	sta.w DMAList+dmavram,y		; $8F8FDC: 99 58 16
	clc		; $8F8FDF: 18
	adc.w #$0400		; $8F8FE0: 69 00 04
	sta.w DMAList+dmasize+dmavram,y		; $8F8FE3: 99 5F 16
	sec		; $8F8FE6: 38
	sbc.w #$03E0		; $8F8FE7: E9 E0 03
	cmp.w #$0800		; $8F8FEA: C9 00 08
	bne .l6		; $8F8FED: D0 03
	lda.w #$0400		; $8F8FEF: A9 00 04
.l6:
	sta.b tmp2		; $8F8FF2: 85 77
	lda.b tmp0		; $8F8FF4: A5 73
	sta.w DMAList,y		; $8F8FF6: 99 53 16
	clc		; $8F8FF9: 18
	adc.w #$0040		; $8F8FFA: 69 40 00
	sta.w DMAList+dmasize+dmasrc,y		; $8F8FFD: 99 5A 16
	adc.w #$0020		; $8F9000: 69 20 00
	sta.b tmp0		; $8F9003: 85 73
	lda.w #$0040		; $8F9005: A9 40 00
	sta.w DMAList+dmalen,y		; $8F9008: 99 56 16
	lsr a		; $8F900B: 4A
	sta.w DMAList+dmasize+dmalen,y		; $8F900C: 99 5D 16
	tya		; $8F900F: 98
	adc.w #$000E		; $8F9010: 69 0E 00
	tay		; $8F9013: A8
	dex		; $8F9014: CA
	bne .l5		; $8F9015: D0 BA
.l7:
	sty.b DMAListend		; $8F9017: 84 A3
	rtl		; $8F9019: 6B
jdtab8F:		;93G jdtab: buttons r,l,d,u -> direction 0-7, 8 = none (checksso)
	db 8,0,4,8,6,7,5,8,2,1,3,8,8,8,8,8		; $8F901A
InitScores:		;auto: CODE_8F902A (from StartGame). 93G InitScores: playoff rounds 0-1: random scores so far for the other games of the round (SetScore 1-3 times)
	lda.w OptPlayMode		; $8F902A: AD 00 16
	beq .l5		; $8F902D: F0 43
	lda.w gamelevel		; $8F902F: AD 4A 01
	cmp.w #$0002		; $8F9032: C9 02 00
	bcs .l5		; $8F9035: B0 3B
	jsl.l GetShifter		; $8F9037: 22 A4 D5 85
	lda.b d1		; $8F903B: A5 57
	asl a		; $8F903D: 0A
	sta.b a0		; $8F903E: 85 33
.l1:
	lda.b d1		; $8F9040: A5 57
	cmp.w gamenum		; $8F9042: CD 4C 01
	beq .l4		; $8F9045: F0 23
	ldy.b a0		; $8F9047: A4 33
	lda.w gsflags,y		; $8F9049: B9 EF 15
	bit.w #$0004		; $8F904C: 89 04 00
	bne .l4		; $8F904F: D0 19
	lda.w #$0000		; $8F9051: A9 00 00
	sta.w gsper,y		; $8F9054: 99 BF 15
	lda.w #$0003		; $8F9057: A9 03 00
	sta.b d0		; $8F905A: 85 53
	jsl.l randomd0		; $8F905C: 22 A3 97 80
	bra .l3		; $8F9060: 80 04
.l2:
	jsl.l SetScore		; $8F9062: 22 21 FE 8A
.l3:
	dec.b d0		; $8F9066: C6 53
	bpl .l2		; $8F9068: 10 F8
.l4:
	dec.b a0		; $8F906A: C6 33
	dec.b a0		; $8F906C: C6 33
	dec.b d1		; $8F906E: C6 57
	bpl .l1		; $8F9070: 10 CE
.l5:
	rtl		; $8F9072: 6B
ResetPassWord:		;auto: CODE_8F9073. 92G ResetPassWord: PassWord = 16 blanks ($1E) with bit 7 clear
	sep #$30		; $8F9073: E2 30
	stz.w PassWord		; $8F9075: 9C 10 16
	ldy.b #$0F		; $8F9078: A0 0F
	lda.b #$1E		; $8F907A: A9 1E
.l1:
	sta.w PassWord,y		; $8F907C: 99 10 16
	dey		; $8F907F: 88
	bne .l1		; $8F9080: D0 FA
	rep #$30		; $8F9082: C2 30
	rtl		; $8F9084: 6B
