; $8D8000-$8D900B  ROM $68000-$6900B: maketree (hockey93_09), InitPPU, StartPer (hockey93_01), GetLowestPen (penalty93_1), Bcheck (hockey93_03),
; NewPO93, eraser, DrawTeamBlocks, EASNLogo (penalty93_2), PeriodOver, GetPlayerName, updatesound, asstab, mulu16, puckshadow, setd0player;
; then SpriteSet10 (frame set 10), tiles continue to bank8D_E000.
org $8D8000
maketree:		;auto: CODE_8D8000. 93G maketree (hockey93_09): potree from playoffseats (postarts) and WinBits; reset the games of this round (.sett), then FigureJoy
	stx.b xsave		; $8D8000: 86 0A
	ldx.w #$0000		; $8D8002: A2 00 00
.pushd:
	lda.b d0,x		; $8D8005: B5 53
	pha		; $8D8007: 48
	inx		; $8D8008: E8
	inx		; $8D8009: E8
	cpx.w #$0014		; $8D800A: E0 14 00
	bne .pushd		; $8D800D: D0 F6
	ldx.b xsave		; $8D800F: A6 0A
	stx.b xsave		; $8D8011: 86 0A
	ldx.w #$0000		; $8D8013: A2 00 00
.pusha:
	lda.b a0,x		; $8D8016: B5 33
	pha		; $8D8018: 48
	inx		; $8D8019: E8
	inx		; $8D801A: E8
	cpx.w #$0010		; $8D801B: E0 10 00
	bne .pusha		; $8D801E: D0 F6
	ldx.b xsave		; $8D8020: A6 0A
	lda.w postarts		; $8D8022: AD 51 04  a1 = playoffseats + 16 * postarts
	asl a		; $8D8025: 0A
	asl a		; $8D8026: 0A
	asl a		; $8D8027: 0A
	asl a		; $8D8028: 0A
	sta.b d1		; $8D8029: 85 57
	lda.w #potree		; $8D802B: A9 53 04
	sta.b a0		; $8D802E: 85 33
	lda.w #$0000		; $8D8030: A9 00 00
	sta.b a0+2		; $8D8033: 85 35
	lda.w #playoffseats		; $8D8035: A9 B8 C4
	clc		; $8D8038: 18
	adc.b d1		; $8D8039: 65 57
	sta.b a1		; $8D803B: 85 37
	lda.w #playoffseats>>16		; $8D803D: A9 83 00
	sta.b a1+2		; $8D8040: 85 39
	ldy.w #$000E		; $8D8042: A0 0E 00
	sty.b d2		; $8D8045: 84 5B
.first:		;first round: 16 teams from the tree
	lda.b [a1],y		; $8D8047: B7 37
	sta.b [a0],y		; $8D8049: 97 33
	dey		; $8D804B: 88
	dey		; $8D804C: 88
	bpl .first		; $8D804D: 10 F8
	lda.w #potree+16		; $8D804F: A9 63 04  winners into potree+16..
	sta.b a1		; $8D8052: 85 37
	lda.b a0+2		; $8D8054: A5 35
	sta.b a1+2		; $8D8056: 85 39
	lda.w WinBits		; $8D8058: AD E7 08
	sta.b d0		; $8D805B: 85 53
.zero:		;93G .0: winbit picks the team of each pair
	lda.b d0		; $8D805D: A5 53
	and.w #$0001		; $8D805F: 29 01 00
	sta.b d1		; $8D8062: 85 57
	tay		; $8D8064: A8
	sep #$20		; $8D8065: E2 20
	lda.b [a0],y		; $8D8067: B7 33
	sta.b [a1]		; $8D8069: 87 37
	rep #$20		; $8D806B: C2 20
	inc.b a1		; $8D806D: E6 37
	inc.b a0		; $8D806F: E6 33
	inc.b a0		; $8D8071: E6 33
	lsr.b d0		; $8D8073: 46 53
	dec.b d2		; $8D8075: C6 5B
	bpl .zero		; $8D8077: 10 E4
	jsl.l GetShifter		; $8D8079: 22 A4 D5 85  d1 = games of this round, d2 = first slot
	lda.b d1		; $8D807D: A5 57
	bmi .nogames		; $8D807F: 30 33
	lda.b d2		; $8D8081: A5 5B
	asl a		; $8D8083: 0A
	adc.w #potree		; $8D8084: 69 53 04
	sta.b a0		; $8D8087: 85 33
	lda.w #$0000		; $8D8089: A9 00 00
	sta.b a0+2		; $8D808C: 85 35
	stz.b a1		; $8D808E: 64 37
.two:		;93G .2
	ldx.b a1		; $8D8090: A6 37
	stz.w gss1,x		; $8D8092: 9E CF 15
	stz.w gss2,x		; $8D8095: 9E DF 15
	stz.w gsper,x		; $8D8098: 9E BF 15
	lda.w gsflags,x		; $8D809B: BD EF 15
	and.w #~gsfhl&$FFFF		; $8D809E: 29 FD FF
	sta.w gsflags,x		; $8D80A1: 9D EF 15
	jsl.l .sett		; $8D80A4: 22 D3 80 8D
	inc.b a1		; $8D80A8: E6 37
	inc.b a1		; $8D80AA: E6 37
	dec.b d1		; $8D80AC: C6 57
	bpl .two		; $8D80AE: 10 E0
	jsl.l FigureJoy		; $8D80B0: 22 7D 80 8B
.nogames:
	stx.b xsave		; $8D80B4: 86 0A
	ldx.w #$000E		; $8D80B6: A2 0E 00
.popa:
	pla		; $8D80B9: 68
	sta.b a0,x		; $8D80BA: 95 33
	dex		; $8D80BC: CA
	dex		; $8D80BD: CA
	bpl .popa		; $8D80BE: 10 F9
	ldx.b xsave		; $8D80C0: A6 0A
	stx.b xsave		; $8D80C2: 86 0A
	ldx.w #$0012		; $8D80C4: A2 12 00
.popd:
	pla		; $8D80C7: 68
	sta.b d0,x		; $8D80C8: 95 53
	dex		; $8D80CA: CA
	dex		; $8D80CB: CA
	bpl .popd		; $8D80CC: 10 F9
	ldx.b xsave		; $8D80CE: A6 0A
	ldx.b a3		; $8D80D0: A6 3F
	rtl		; $8D80D2: 6B
.sett:		;93G .sett: series games 2, 3, 5 in tree order, the others flipped (gsftf)
	lda.b bosgames		; $8D80D3: A5 D6  bosgames 2, 3, 5
	cmp.w #$0002		; $8D80D5: C9 02 00
	beq .flip		; $8D80D8: F0 28
	cmp.w #$0003		; $8D80DA: C9 03 00
	beq .flip		; $8D80DD: F0 23
	cmp.w #$0005		; $8D80DF: C9 05 00
	beq .flip		; $8D80E2: F0 1E
	lda.w gsflags,x		; $8D80E4: BD EF 15
	ora.w #gsftf		; $8D80E7: 09 01 00
	sta.w gsflags,x		; $8D80EA: 9D EF 15
	lda.b [a0]		; $8D80ED: A7 33
	inc.b a0		; $8D80EF: E6 33
	and.w #$00FF		; $8D80F1: 29 FF 00
	sta.w gst2,x		; $8D80F4: 9D 8F 15
	lda.b [a0]		; $8D80F7: A7 33
	inc.b a0		; $8D80F9: E6 33
	and.w #$00FF		; $8D80FB: 29 FF 00
	sta.w gst1,x		; $8D80FE: 9D 7F 15
	rtl		; $8D8101: 6B
.flip:
	lda.w gsflags,x		; $8D8102: BD EF 15
	and.w #~gsftf&$FFFF		; $8D8105: 29 FE FF
	sta.w gsflags,x		; $8D8108: 9D EF 15
	lda.b [a0]		; $8D810B: A7 33
	inc.b a0		; $8D810D: E6 33
	and.w #$00FF		; $8D810F: 29 FF 00
	sta.w gst1,x		; $8D8112: 9D 7F 15
	lda.b [a0]		; $8D8115: A7 33
	inc.b a0		; $8D8117: E6 33
	and.w #$00FF		; $8D8119: 29 FF 00
	sta.w gst2,x		; $8D811C: 9D 8F 15
	rtl		; $8D811F: 6B
InitPPU:		;auto: CODE_8D8120. SNES: all PPU and CPU I/O registers to their reset values (forced blank, mode 0, no layers, NMI off)
	sep #$20		; $8D8120: E2 20
	lda.b #$8F		; $8D8122: A9 8F
	sta.w INIDISP		; $8D8124: 8D 00 21
	stz.w OBSEL		; $8D8127: 9C 01 21
	stz.w OAMADDL		; $8D812A: 9C 02 21
	stz.w OAMADDH		; $8D812D: 9C 03 21
	stz.w BGMODE		; $8D8130: 9C 05 21
	stz.w MOSAIC		; $8D8133: 9C 06 21
	stz.w BG1SC		; $8D8136: 9C 07 21
	stz.w BG2SC		; $8D8139: 9C 08 21
	stz.w BG3SC		; $8D813C: 9C 09 21
	stz.w BG4SC		; $8D813F: 9C 0A 21
	stz.w BG12NBA		; $8D8142: 9C 0B 21
	stz.w BG34NBA		; $8D8145: 9C 0C 21
	stz.w BG1HOFS		; $8D8148: 9C 0D 21
	stz.w BG1HOFS		; $8D814B: 9C 0D 21
	stz.w BG1VOFS		; $8D814E: 9C 0E 21
	stz.w BG1VOFS		; $8D8151: 9C 0E 21
	stz.w BG2HOFS		; $8D8154: 9C 0F 21
	stz.w BG2HOFS		; $8D8157: 9C 0F 21
	stz.w BG2VOFS		; $8D815A: 9C 10 21
	stz.w BG2VOFS		; $8D815D: 9C 10 21
	stz.w BG3HOFS		; $8D8160: 9C 11 21
	stz.w BG3HOFS		; $8D8163: 9C 11 21
	stz.w BG3VOFS		; $8D8166: 9C 12 21
	stz.w BG3VOFS		; $8D8169: 9C 12 21
	stz.w BG4HOFS		; $8D816C: 9C 13 21
	stz.w BG4HOFS		; $8D816F: 9C 13 21
	stz.w BG4VOFS		; $8D8172: 9C 14 21
	stz.w BG4VOFS		; $8D8175: 9C 14 21
	lda.b #$80		; $8D8178: A9 80
	sta.w VMAIN		; $8D817A: 8D 15 21
	stz.w VMADDL		; $8D817D: 9C 16 21
	stz.w VMADDH		; $8D8180: 9C 17 21
	stz.w M7SEL		; $8D8183: 9C 1A 21
	stz.w M7A		; $8D8186: 9C 1B 21
	lda.b #$01		; $8D8189: A9 01
	sta.w M7A		; $8D818B: 8D 1B 21
	stz.w M7B		; $8D818E: 9C 1C 21
	stz.w M7B		; $8D8191: 9C 1C 21
	stz.w M7C		; $8D8194: 9C 1D 21
	stz.w M7C		; $8D8197: 9C 1D 21
	stz.w M7D		; $8D819A: 9C 1E 21
	sta.w M7D		; $8D819D: 8D 1E 21
	stz.w M7X		; $8D81A0: 9C 1F 21
	stz.w M7X		; $8D81A3: 9C 1F 21
	stz.w M7Y		; $8D81A6: 9C 20 21
	stz.w M7Y		; $8D81A9: 9C 20 21
	stz.w CGADD		; $8D81AC: 9C 21 21
	stz.w W12SEL		; $8D81AF: 9C 23 21
	stz.w W34SEL		; $8D81B2: 9C 24 21
	stz.w WOBJSEL		; $8D81B5: 9C 25 21
	stz.w WH0		; $8D81B8: 9C 26 21
	stz.w WH1		; $8D81BB: 9C 27 21
	stz.w WH2		; $8D81BE: 9C 28 21
	stz.w WH3		; $8D81C1: 9C 29 21
	stz.w WBGLOG		; $8D81C4: 9C 2A 21
	stz.w WOBJLOG		; $8D81C7: 9C 2B 21
	stz.w TM		; $8D81CA: 9C 2C 21
	stz.w TS		; $8D81CD: 9C 2D 21
	stz.w TMW		; $8D81D0: 9C 2E 21
	stz.w TSW		; $8D81D3: 9C 2F 21
	lda.b #$30		; $8D81D6: A9 30
	sta.w CGWSEL		; $8D81D8: 8D 30 21
	stz.w CGADSUB		; $8D81DB: 9C 31 21
	lda.b #$E0		; $8D81DE: A9 E0
	sta.w COLDATA		; $8D81E0: 8D 32 21
	stz.w SETINI		; $8D81E3: 9C 33 21
	stz.w NMITIMEN		; $8D81E6: 9C 00 42
	lda.b #$FF		; $8D81E9: A9 FF
	sta.w WRIO		; $8D81EB: 8D 01 42
	stz.w WRMPYA		; $8D81EE: 9C 02 42
	stz.w WRMPYB		; $8D81F1: 9C 03 42
	stz.w WRDIVL		; $8D81F4: 9C 04 42
	stz.w WRDIVH		; $8D81F7: 9C 05 42
	stz.w WRDIVB		; $8D81FA: 9C 06 42
	stz.w HTIMEL		; $8D81FD: 9C 07 42
	stz.w HTIMEH		; $8D8200: 9C 08 42
	stz.w VTIMEL		; $8D8203: 9C 09 42
	stz.w VTIMEH		; $8D8206: 9C 0A 42
	stz.w MDMAEN		; $8D8209: 9C 0B 42
	stz.w HDMAEN		; $8D820C: 9C 0C 42
	lda.b #$01		; $8D820F: A9 01
	sta.w MEMSEL		; $8D8211: 8D 0D 42
	rep #$30		; $8D8214: C2 30
	rtl		; $8D8216: 6B
StartPer:		;auto: CODE_8D8217 (from StartGame). 93G StartPer (hockey93_01): reset the stack, rink and clock, faceoff at centre ice, music cue timers, replay reset; then the game loop ($8E8000)
	lda.w #$1FFF		; $8D8217: A9 FF 1F  reset the stack
	tcs		; $8D821A: 1B
	jsl.l Readjoy1		; $8D821B: 22 0B C4 80
	jsl.l Readjoy2		; $8D821F: 22 29 C4 80
	jsl.l Readjoy1		; $8D8223: 22 0B C4 80
	jsl.l Readjoy2		; $8D8227: 22 29 C4 80
	jsl.l Readjoy1		; $8D822B: 22 0B C4 80
	jsl.l Readjoy2		; $8D822F: 22 29 C4 80
	jsl.l Readjoy1		; $8D8233: 22 0B C4 80
	jsl.l Readjoy2		; $8D8237: 22 29 C4 80
	stz.b a2		; $8D823B: 64 3B
	jsl.l reenergizeteam		; $8D823D: 22 D1 FE 80
	lda.w #$0002		; $8D8241: A9 02 00
	sta.b a2		; $8D8244: 85 3B
	jsl.l reenergizeteam		; $8D8246: 22 D1 FE 80
	jsl.l sndqreset		; $8D824A: 22 1A FA 82
	stz.b sprclock		; $8D824E: 64 A7  sprite VRAM slots
	jsl.l setupice		; $8D8250: 22 C1 B4 80
	jsl.l ResetClock		; $8D8254: 22 97 FF 85
	lda.w #$F000		; $8D8258: A9 00 F0
	tsb.w PadControlBits		; $8D825B: 0C 31 04
	lda.w #$FFFF		; $8D825E: A9 FF FF  no controlled players
	sta.w c1playernum		; $8D8261: 8D 92 12
	sta.w c2playernum		; $8D8264: 8D 94 12
	sta.w lcplayer		; $8D8267: 8D 83 01
	ldx.w #puckobj		; $8D826A: A2 1C 00  puck: puckfaceoff at centre ice
	stx.b a3		; $8D826D: 86 3F
	stz.w fox		; $8D826F: 9C 46 01
	stz.w foy		; $8D8272: 9C 48 01
	lda.w #$1B		; $8D8275: A9 1B 00
	sta.b d0		; $8D8278: 85 53
	jsl.l assreplace		; $8D827A: 22 A7 B4 80
	lda.w gsp		; $8D827E: AD F0 12  third period: p3cue = random time
	cmp.w #$0002		; $8D8281: C9 02 00
	bne .p3		; $8D8284: D0 16
	lda.w gameclock		; $8D8286: AD F2 12
	sta.b mula		; $8D8289: 85 7D
	lda.w #12		; $8D828B: A9 0C 00
	sta.b mulb		; $8D828E: 85 83
	jsl.l mulu16		; $8D8290: 22 1C 87 8D
	jsl.l randoma		; $8D8294: 22 8B AE 80
	inc a		; $8D8298: 1A
	sta.w p3cue		; $8D8299: 8D 2D 04
.p3:
	lda.w gsp		; $8D829C: AD F0 12  periods 1 and 2: mid-period cue at half time
	cmp.w #$0002		; $8D829F: C9 02 00
	bcs .blank		; $8D82A2: B0 07
	lda.w gameclock		; $8D82A4: AD F2 12
	lsr a		; $8D82A7: 4A
	sta.w midpercue		; $8D82A8: 8D 2F 04
.blank:
	lda.w blankchar		; $8D82AB: AD E7 1B
	clc		; $8D82AE: 18
	adc.w charofs		; $8D82AF: 6D CD 1B
	ldx.w #$07FE		; $8D82B2: A2 FE 07
.clr:
	sta.l textmap,x		; $8D82B5: 9F 74 6E 7E
	dex		; $8D82B9: CA
	dex		; $8D82BA: CA
	bpl .clr		; $8D82BB: 10 F8
	lda.w #sf2drec		; $8D82BD: A9 00 04  sf2drec: no replay record
	tsb.w sflags		; $8D82C0: 0C 8C 12
	lda.w #sfwrap		; $8D82C3: A9 10 00  sfwrap off
	trb.w sflags		; $8D82C6: 1C 8C 12
	stz.w lastsfx		; $8D82C9: 9C 7F 01
	lda.w #ReplayBufferStart		; $8D82CC: A9 74 81  replay buffer start
	sta.w ReplayBufferPtr		; $8D82CF: 8D 95 04
	lda.w #ReplayBufferStart>>16		; $8D82D2: A9 7E 00
	sta.w ReplayBufferPtr+2		; $8D82D5: 8D 97 04
	lda.w #$FFFF		; $8D82D8: A9 FF FF
	sta.b textdirtylo		; $8D82DB: 85 D0
	stz.b textdirtyhi		; $8D82DD: 64 D2
	inc.w percue		; $8D82DF: EE 2B 04  period start music cue
	stz.b vcount		; $8D82E2: 64 00
	stz.b vcount+2		; $8D82E4: 64 02
	stz.w lastframevc		; $8D82E6: 9C DB 08
	stz.w oldvcount		; $8D82E9: 9C 27 04
	jml.l $8E8000		; $8D82EC: 5C 00 80 8E  the game loop (bank $8E), bank $8E: the game loop
GetLowestPen:		;auto: CODE_8D82F0 (from updatepwrplay). 93G GetLowestPen (penalty93_1): a2 = team on the power play, a3 = the other. d0 = power play time left from the penalty box times
	stz.b d0		; $8D82F0: 64 53
	stz.b d3		; $8D82F2: 64 5F
	lda.b a2		; $8D82F4: A5 3B
	beq .a		; $8D82F6: F0 03
	lda.w #$001A		; $8D82F8: A9 1A 00
.a:
	sta.b a0		; $8D82FB: 85 33
.l0:
	ldy.b a0		; $8D82FD: A4 33  penalty box list of the power play team ($80 ends)
	inc.b a0		; $8D82FF: E6 33
	lda.w tmboxlist,y		; $8D8301: B9 4A 15
	and.w #$00FF		; $8D8304: 29 FF 00
	sta.b d2		; $8D8307: 85 5B
	bit.w #$0080		; $8D8309: 89 80 00
	bne .other		; $8D830C: D0 27
	lda.b a2		; $8D830E: A5 3B
	beq .h0		; $8D8310: F0 03
	lda.w #$0034		; $8D8312: A9 34 00
.h0:
	clc		; $8D8315: 18
	adc.b d2		; $8D8316: 65 5B
	tay		; $8D8318: A8
	lda.w tmpdst,y		; $8D8319: B9 E2 14
	sta.b d2		; $8D831C: 85 5B
	bit.w #$4000		; $8D831E: 89 00 40  tmpdst bit 14: not timed
	bne .l0		; $8D8321: D0 DA
	lda.b d2		; $8D8323: A5 5B
	sec		; $8D8325: 38
	sbc.b d3		; $8D8326: E5 5F
	sta.b d2		; $8D8328: 85 5B
	clc		; $8D832A: 18
	adc.b d0		; $8D832B: 65 53
	sta.b d0		; $8D832D: 85 53
	lda.b d2		; $8D832F: A5 5B
	sta.b d3		; $8D8331: 85 5F
	bra .l0		; $8D8333: 80 C8
.other:
	ldy.b a3		; $8D8335: A4 3F  shorthanded team
	lda.w tmap,y		; $8D8337: B9 EE 13
	cmp.w #6		; $8D833A: C9 06 00
	beq .rtl		; $8D833D: F0 49
	lda.b d0		; $8D833F: A5 53
	sec		; $8D8341: 38
	sbc.b d3		; $8D8342: E5 5F
	sta.b d0		; $8D8344: 85 53
	lda.b a3		; $8D8346: A5 3F
	beq .b		; $8D8348: F0 03
	lda.w #$001A		; $8D834A: A9 1A 00
.b:
	sta.b a0		; $8D834D: 85 33
.l1:
	ldy.b a0		; $8D834F: A4 33
	lda.w tmboxlist,y		; $8D8351: B9 4A 15
	inc.b a0		; $8D8354: E6 33
	and.w #$00FF		; $8D8356: 29 FF 00
	sta.b d2		; $8D8359: 85 5B
	bit.w #$0080		; $8D835B: 89 80 00
	bne .rtl		; $8D835E: D0 28
	lda.b a3		; $8D8360: A5 3F
	beq .h1		; $8D8362: F0 03
	lda.w #$0034		; $8D8364: A9 34 00
.h1:
	clc		; $8D8367: 18
	adc.b d2		; $8D8368: 65 5B
	tay		; $8D836A: A8
	lda.w tmpdst,y		; $8D836B: B9 E2 14
	bit.w #$4000		; $8D836E: 89 00 40
	bne .l1		; $8D8371: D0 DC
	lda.b d0		; $8D8373: A5 53
	sec		; $8D8375: 38
	sbc.w tmpdst,y		; $8D8376: F9 E2 14
	bmi .lt		; $8D8379: 30 04
	bvc .add		; $8D837B: 50 04
	bra .rtl		; $8D837D: 80 09
.lt:
	bvc .rtl		; $8D837F: 50 07
.add:
	lda.b d0		; $8D8381: A5 53
	clc		; $8D8383: 18
	adc.b d3		; $8D8384: 65 5F
	sta.b d0		; $8D8386: 85 53
.rtl:
	rtl		; $8D8388: 6B
Bcheck:		;auto: CODE_8D8389 (from checkcheck). 93G Bcheck (hockey93_03): a2 checks a3 with SPA $B44: if a3 is in front (within one direction) he falls; checkagr may call a penalty $20 (charging) on
		;   a2
	ldy.b a2		; $8D8389: A4 3B
	lda.w pfalock,x		; $8D838B: BD 7F 11
	beq .pos		; $8D838E: F0 03
	jmp.w .rtl		; $8D8390: 4C 15 84
.pos:
	lda.w position,x		; $8D8393: BD 9F 0B
	bne .fight		; $8D8396: D0 03
	jmp.w .rtl		; $8D8398: 4C 15 84
.fight:
	lda.w pf2fight,x		; $8D839B: BD 5F 11
	bne .rtl		; $8D839E: D0 75
	lda.w OptPen		; $8D83A0: AD 0A 16  penalties off: a2 needs randomd0($10 + aggression - a3 legstr) >= 12
	bne .dir		; $8D83A3: D0 1C
	lda.w pflags,y		; $8D83A5: B9 DF 0E
	bit.w #pfjoycon		; $8D83A8: 89 08 00
	beq .dir		; $8D83AB: F0 14
	lda.w #16		; $8D83AD: A9 10 00
	clc		; $8D83B0: 18
	adc.w aggress,y		; $8D83B1: 79 FF 10
	sec		; $8D83B4: 38
	sbc.w legstr,x		; $8D83B5: FD 5F 0F
	jsl.l randoma		; $8D83B8: 22 8B AE 80
	cmp.w #12		; $8D83BC: C9 0C 00
	bcc .rtl		; $8D83BF: 90 54
.dir:
	lda.w Xpos,x		; $8D83C1: BD FF 08
	sec		; $8D83C4: 38
	sbc.w Xpos,y		; $8D83C5: F9 FF 08
	sta.b d0		; $8D83C8: 85 53
	lda.w Ypos,x		; $8D83CA: BD 5F 09
	sec		; $8D83CD: 38
	sbc.w Ypos,y		; $8D83CE: F9 5F 09
	sta.b d1		; $8D83D1: 85 57
	jsl.l vtoa		; $8D83D3: 22 A8 AF 80
	ldy.b a2		; $8D83D7: A4 3B
	lda.b d0		; $8D83D9: A5 53  within one direction of a2 facing
	sec		; $8D83DB: 38
	sbc.w facedir,y		; $8D83DC: F9 BF 0D
	inc a		; $8D83DF: 1A
	and.w #$0007		; $8D83E0: 29 07 00
	cmp.w #$0003		; $8D83E3: C9 03 00
	bcs .rtl		; $8D83E6: B0 2D
	ldx.b a2		; $8D83E8: A6 3B
	ldy.b a3		; $8D83EA: A4 3F
	stx.b a3		; $8D83EC: 86 3F
	sty.b a2		; $8D83EE: 84 3B
	jsl.l FallDown		; $8D83F0: 22 33 D9 80  a3 falls
	jsl.l $8FE369		; $8D83F4: 22 69 E3 8F  93G checkagr, bank $8F: 93G checkagr
	lda.b d0		; $8D83F8: A5 53
	cmp.w #$0005		; $8D83FA: C9 05 00
	bcs .swap		; $8D83FD: B0 09
	lda.w #$20		; $8D83FF: A9 20 00  penalty $20
	sta.b d0		; $8D8402: 85 53
	jsl.l AddPenalty		; $8D8404: 22 8F C1 80
.swap:
	ldx.b a2		; $8D8408: A6 3B
	ldy.b a3		; $8D840A: A4 3F
	stx.b a3		; $8D840C: 86 3F
	sty.b a2		; $8D840E: 84 3B
	lda.w #$FFFF		; $8D8410: A9 FF FF
	sta.b collflag		; $8D8413: 85 D8
.rtl:
	rtl		; $8D8415: 6B
NewPO93:		;auto: CODE_8D8416. 93G NewPO (hockey93_09): continue the playoffs from passbits (ReadPassBits, maketree, OptPlayers = 7 - pojoy); no caller found (92G NewPO is at $8B8000)
	stx.b xsave		; $8D8416: 86 0A
	ldx.w #$0000		; $8D8418: A2 00 00
.pushd:
	lda.b d0,x		; $8D841B: B5 53
	pha		; $8D841D: 48
	inx		; $8D841E: E8
	inx		; $8D841F: E8
	cpx.w #$0020		; $8D8420: E0 20 00
	bne .pushd		; $8D8423: D0 F6
	ldx.b xsave		; $8D8425: A6 0A
	stx.b xsave		; $8D8427: 86 0A
	ldx.w #$0000		; $8D8429: A2 00 00
.pusha:
	lda.b a0,x		; $8D842C: B5 33
	pha		; $8D842E: 48
	inx		; $8D842F: E8
	inx		; $8D8430: E8
	cpx.w #$0010		; $8D8431: E0 10 00
	bne .pusha		; $8D8434: D0 F6
	ldx.b xsave		; $8D8436: A6 0A
	lda.w #passbits		; $8D8438: A9 24 16  a3 = passbits
	sta.b a3		; $8D843B: 85 3F
	lda.w #$0000		; $8D843D: A9 00 00
	sta.b a3+2		; $8D8440: 85 41
	jsl.l ReadPassBits		; $8D8442: 22 7A 81 8B
	lda.w gamelevel		; $8D8446: AD 4A 01
	ora.b bosgames		; $8D8449: 05 D6
	sta.b d0		; $8D844B: 85 53
	beq .ex		; $8D844D: F0 0E
	jsl.l maketree		; $8D844F: 22 00 80 8D
	lda.w #$0007		; $8D8453: A9 07 00  menu value from pojoy
	sec		; $8D8456: 38
	sbc.w pojoy		; $8D8457: ED 4F 04
	sta.w OptPlayers		; $8D845A: 8D 02 16
.ex:
	stx.b xsave		; $8D845D: 86 0A
	ldx.w #$000E		; $8D845F: A2 0E 00
.popa:
	pla		; $8D8462: 68
	sta.b a0,x		; $8D8463: 95 33
	dex		; $8D8465: CA
	dex		; $8D8466: CA
	bpl .popa		; $8D8467: 10 F9
	ldx.b xsave		; $8D8469: A6 0A
	stx.b xsave		; $8D846B: 86 0A
	ldx.w #$001E		; $8D846D: A2 1E 00
.popd:
	pla		; $8D8470: 68
	sta.b d0,x		; $8D8471: 95 53
	dex		; $8D8473: CA
	dex		; $8D8474: CA
	bpl .popd		; $8D8475: 10 F9
	ldx.b xsave		; $8D8477: A6 0A
	ldx.b a3		; $8D8479: A6 3F
	rtl		; $8D847B: 6B
eraser:		;auto: CODE_8D847C. 92G eraser: fill d0 x d1 textmap words at printx/printy (print map printm) with tile d2 (+ printfontset)
	phx		; $8D847C: DA
	lda.b d2		; $8D847D: A5 5B
	clc		; $8D847F: 18
	adc.w printfontset		; $8D8480: 6D CB 1B
	sta.b d2		; $8D8483: 85 5B
	stz.b d1+2		; $8D8485: 64 59
.row:
	lda.w printy		; $8D8487: AD 7D 04
	clc		; $8D848A: 18
	adc.b d1+2		; $8D848B: 65 59
	asl a		; $8D848D: 0A
	asl a		; $8D848E: 0A
	asl a		; $8D848F: 0A
	asl a		; $8D8490: 0A
	asl a		; $8D8491: 0A
	adc.w printx		; $8D8492: 6D 7B 04
	asl a		; $8D8495: 0A
	adc.b printm		; $8D8496: 65 D4
	tax		; $8D8498: AA
	ldy.b d0		; $8D8499: A4 53
	lda.b d2		; $8D849B: A5 5B
.col:
	sta.l textmap,x		; $8D849D: 9F 74 6E 7E
	inx		; $8D84A1: E8
	inx		; $8D84A2: E8
	dey		; $8D84A3: 88
	bne .col		; $8D84A4: D0 F7
	inc.b d1+2		; $8D84A6: E6 59
	lda.b d1+2		; $8D84A8: A5 59
	cmp.b d1		; $8D84AA: C5 57
	bne .row		; $8D84AC: D0 D9
	plx		; $8D84AE: FA
	lda.w printy		; $8D84AF: AD 7D 04
	asl a		; $8D84B2: 0A
	asl a		; $8D84B3: 0A
	asl a		; $8D84B4: 0A
	asl a		; $8D84B5: 0A
	asl a		; $8D84B6: 0A
	adc.w printx		; $8D84B7: 6D 7B 04
	cmp.b textdirtylo		; $8D84BA: C5 D0
	bcs .hi		; $8D84BC: B0 02
	sta.b textdirtylo		; $8D84BE: 85 D0
.hi:
	lda.w printy		; $8D84C0: AD 7D 04
	clc		; $8D84C3: 18
	adc.b d1		; $8D84C4: 65 57
	and.w #$001F		; $8D84C6: 29 1F 00
	sta.w printy		; $8D84C9: 8D 7D 04
	dec a		; $8D84CC: 3A
	and.w #$001F		; $8D84CD: 29 1F 00
	asl a		; $8D84D0: 0A
	asl a		; $8D84D1: 0A
	asl a		; $8D84D2: 0A
	asl a		; $8D84D3: 0A
	asl a		; $8D84D4: 0A
	adc.w printx		; $8D84D5: 6D 7B 04
	adc.b d0		; $8D84D8: 65 53
	dec a		; $8D84DA: 3A
	cmp.b textdirtyhi		; $8D84DB: C5 D2
	bcc .rtl		; $8D84DD: 90 02
	sta.b textdirtyhi		; $8D84DF: 85 D2
.rtl:
	rtl		; $8D84E1: 6B
DrawTeamBlocks:		;auto: CODE_8D84E2. 93G DrawTeamBlocks (hockey93_06): the 9 x 2 TeamBlocksMap block of team d1 into textmap at printx/printy (scorechars, printa)
	lda.b a2		; $8D84E2: A5 3B
	pha		; $8D84E4: 48
	phx		; $8D84E5: DA
	lda.b d1		; $8D84E6: A5 57  36 bytes per team
	sta.b mula		; $8D84E8: 85 7D
	lda.w #36		; $8D84EA: A9 24 00
	sta.b mulb		; $8D84ED: 85 83
	jsl.l mulu16		; $8D84EF: 22 1C 87 8D
	tay		; $8D84F3: A8
	lda.w #TeamBlocksMap		; $8D84F4: A9 BA CA
	sta.b a2		; $8D84F7: 85 3B
	lda.w #TeamBlocksMap>>16		; $8D84F9: A9 87 00
	sta.b a2+2		; $8D84FC: 85 3D
	lda.w printy		; $8D84FE: AD 7D 04
	asl a		; $8D8501: 0A
	asl a		; $8D8502: 0A
	asl a		; $8D8503: 0A
	asl a		; $8D8504: 0A
	asl a		; $8D8505: 0A
	adc.w printx		; $8D8506: 6D 7B 04
	asl a		; $8D8509: 0A
	adc.b printm		; $8D850A: 65 D4
	tax		; $8D850C: AA
	lda.w #9		; $8D850D: A9 09 00
	sta.b tmp0		; $8D8510: 85 73
	sta.b tmp1		; $8D8512: 85 75
.row1:
	lda.b [a2],y		; $8D8514: B7 3B
	clc		; $8D8516: 18
	adc.w scorechars		; $8D8517: 6D E5 1B
	adc.w printfontset		; $8D851A: 6D CB 1B
	ora.w printa		; $8D851D: 0D 77 04
	sta.l textmap,x		; $8D8520: 9F 74 6E 7E
	iny		; $8D8524: C8
	iny		; $8D8525: C8
	inx		; $8D8526: E8
	inx		; $8D8527: E8
	dec.b tmp0		; $8D8528: C6 73
	bne .row1		; $8D852A: D0 E8
.row2:
	lda.b [a2],y		; $8D852C: B7 3B
	clc		; $8D852E: 18
	adc.w scorechars		; $8D852F: 6D E5 1B
	adc.w printfontset		; $8D8532: 6D CB 1B
	ora.w printa		; $8D8535: 0D 77 04
	sta.l textmap+$2E,x		; $8D8538: 9F A2 6E 7E
	iny		; $8D853C: C8
	iny		; $8D853D: C8
	inx		; $8D853E: E8
	inx		; $8D853F: E8
	dec.b tmp1		; $8D8540: C6 75
	bne .row2		; $8D8542: D0 E8
	plx		; $8D8544: FA
	pla		; $8D8545: 68
	sta.b a2		; $8D8546: 85 3B
	rtl		; $8D8548: 6B
EASNLogo:		;auto: CODE_8D8549. 93G EASNLogo (penalty93_2): the EASN logo (7 x 2 words, $8F824D) at x 1, y $19 of the rink map unless a power play is on
	lda.w sflags		; $8D8549: AD 8C 12
	bit.w #sf2pwrplay		; $8D854C: 89 00 20
	bne .rtl		; $8D854F: D0 57
	jsl.l printz		; $8D8551: 22 0C B9 80
	dw $0005		; $8D8555  printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	stz.b tmp0		; $8D855A: 64 73
	stz.b tmp1		; $8D855C: 64 75
	lda.w #$0002		; $8D855E: A9 02 00
	sta.b tmp2		; $8D8561: 85 77
.row:
	lda.w #$0007		; $8D8563: A9 07 00
	sta.b tmp2+2		; $8D8566: 85 79
.col:
	ldx.b tmp0		; $8D8568: A6 73
	lda.l $8F824D,x		; $8D856A: BF 4D 82 8F
	clc		; $8D856E: 18
	adc.w unusedchars		; $8D856F: 6D D3 1B
	adc.w charofs		; $8D8572: 6D CD 1B
	ldx.b tmp1		; $8D8575: A6 75
	ora.w #$2000		; $8D8577: 09 00 20
	sta.l textmap+$642,x		; $8D857A: 9F B6 74 7E
	inc.b tmp0		; $8D857E: E6 73
	inc.b tmp0		; $8D8580: E6 73
	inc.b tmp1		; $8D8582: E6 75
	inc.b tmp1		; $8D8584: E6 75
	dec.b tmp2+2		; $8D8586: C6 79
	bne .col		; $8D8588: D0 DE
	lda.b tmp1		; $8D858A: A5 75
	clc		; $8D858C: 18
	adc.w #$0032		; $8D858D: 69 32 00
	sta.b tmp1		; $8D8590: 85 75
	dec.b tmp2		; $8D8592: C6 77
	bne .row		; $8D8594: D0 CD
	lda.w #$0321		; $8D8596: A9 21 03  dirty range of the rink map rows
	cmp.b textdirtylo		; $8D8599: C5 D0
	bcs .hi		; $8D859B: B0 02
	sta.b textdirtylo		; $8D859D: 85 D0
.hi:
	lda.w #$0347		; $8D859F: A9 47 03
	cmp.b textdirtyhi		; $8D85A2: C5 D2
	bcc .rtl		; $8D85A4: 90 02
	sta.b textdirtyhi		; $8D85A6: 85 D2
.rtl:
	rtl		; $8D85A8: 6B
PeriodOver:		;auto: CODE_8D85A9 (from clockcont). 93G PeriodOver (hockey93_06): next period (gmdir flips); overtime only for a tied playoff game; gsp 4 = game over (ContinuePlayoffs), else StartPer
	jsl.l $8FE404		; $8D85A9: 22 04 E4 8F  bank $8F: 93G forceblack
	inc.w gsp		; $8D85AD: EE F0 12  next period
	lda.w gmode		; $8D85B0: AD 88 12
	eor.w #gmdir		; $8D85B3: 49 02 00
	sta.w gmode		; $8D85B6: 8D 88 12
	lda.w gsp		; $8D85B9: AD F0 12
	cmp.w #$0003		; $8D85BC: C9 03 00  after overtime (period 4+)
	beq .ot		; $8D85BF: F0 13
	bcc .next		; $8D85C1: 90 1F
	lda.w #$0003		; $8D85C3: A9 03 00
	sta.w gsp		; $8D85C6: 8D F0 12
	lda.w OptPlayMode		; $8D85C9: AD 00 16
	bne .ot		; $8D85CC: D0 06
	lda.w #$0004		; $8D85CE: A9 04 00
	sta.w gsp		; $8D85D1: 8D F0 12
.ot:
	lda.w tmscore		; $8D85D4: AD D6 13  tied: overtime
	cmp.w tmscore+2		; $8D85D7: CD D8 13
	beq .next		; $8D85DA: F0 06
	lda.w #$0004		; $8D85DC: A9 04 00
	sta.w gsp		; $8D85DF: 8D F0 12
.next:
	jsl.l ResetClock		; $8D85E2: 22 97 FF 85
	jsl.l $8F84B5		; $8D85E6: 22 B5 84 8F  bank $8F: 93G SetHor
	jsl.l setvideo		; $8D85EA: 22 5E E3 80
	jsl.l UpdateScores		; $8D85EE: 22 D1 F9 82
	jsl.l $8F86B6		; $8D85F2: 22 B6 86 8F  93G Intermission, bank $8F: 93G Intermission
	lda.w gsp		; $8D85F6: AD F0 12
	cmp.w #$0004		; $8D85F9: C9 04 00
	bne .per		; $8D85FC: D0 04
	jml.l ContinuePlayoffs		; $8D85FE: 5C 59 FC 82
.per:
	jmp.w StartPer		; $8D8602: 4C 17 82
GetPlayerName:		;auto: CODE_8D8605. SNES: mesarea = number and name of player TempPlOffset (bit 15: away team) via PlayerNumName
	stx.b xsave		; $8D8605: 86 0A
	ldx.w #$0000		; $8D8607: A2 00 00
.pushd:
	lda.b d0,x		; $8D860A: B5 53
	pha		; $8D860C: 48
	inx		; $8D860D: E8
	inx		; $8D860E: E8
	cpx.w #$0004		; $8D860F: E0 04 00
	bne .pushd		; $8D8612: D0 F6
	ldx.b xsave		; $8D8614: A6 0A
	stx.b xsave		; $8D8616: 86 0A
	ldx.w #$0000		; $8D8618: A2 00 00
.pusha:
	lda.b a2,x		; $8D861B: B5 3B
	pha		; $8D861D: 48
	inx		; $8D861E: E8
	inx		; $8D861F: E8
	cpx.w #$0004		; $8D8620: E0 04 00
	bne .pusha		; $8D8623: D0 F6
	ldx.b xsave		; $8D8625: A6 0A
	stz.b a2		; $8D8627: 64 3B
	lda.w TempPlOffset		; $8D8629: AD FA 12  bit 15: away team
	sta.b d0		; $8D862C: 85 53
	bpl .name		; $8D862E: 10 09
	and.w #$00FF		; $8D8630: 29 FF 00
	sta.b d0		; $8D8633: 85 53
	inc.b a2		; $8D8635: E6 3B
	inc.b a2		; $8D8637: E6 3B
.name:
	jsl.l PlayerNumName		; $8D8639: 22 0C CC 83
	stx.b xsave		; $8D863D: 86 0A
	ldx.w #$0002		; $8D863F: A2 02 00
.popa:
	pla		; $8D8642: 68
	sta.b a2,x		; $8D8643: 95 3B
	dex		; $8D8645: CA
	dex		; $8D8646: CA
	bpl .popa		; $8D8647: 10 F9
	ldx.b xsave		; $8D8649: A6 0A
	stx.b xsave		; $8D864B: 86 0A
	ldx.w #$0002		; $8D864D: A2 02 00
.popd:
	pla		; $8D8650: 68
	sta.b d0,x		; $8D8651: 95 53
	dex		; $8D8653: CA
	dex		; $8D8654: CA
	bpl .popd		; $8D8655: 10 F9
	ldx.b xsave		; $8D8657: A6 0A
	rtl		; $8D8659: 6B
updatesound:		;auto: CODE_8D865A (from periodicevents). 93G updatesound: move the crowd volume (asv) toward crowdlevel; send it to the sound driver when it changes (crowdvol)
	ldy.b d7		; $8D865A: A4 6F
	lda.b crowdlevel		; $8D865C: A5 DE  target volume crowdlevel * 8 + $200 (max $CFF)
	asl a		; $8D865E: 0A
	asl a		; $8D865F: 0A
	asl a		; $8D8660: 0A
	adc.w #$0200		; $8D8661: 69 00 02
	cmp.w #$0CFF		; $8D8664: C9 FF 0C
	bcc .ip		; $8D8667: 90 03
	lda.w #$0CFF		; $8D8669: A9 FF 0C
.ip:
	sta.b tmp0		; $8D866C: 85 73
.step:
	lda.b tmp0		; $8D866E: A5 73
	sec		; $8D8670: 38
	sbc.w asv		; $8D8671: ED 44 16
	lsr a		; $8D8674: 4A
	lsr a		; $8D8675: 4A
	lsr a		; $8D8676: 4A
	lsr a		; $8D8677: 4A
	bit.w #$0800		; $8D8678: 89 00 08
	beq .pos		; $8D867B: F0 03
	ora.w #$F000		; $8D867D: 09 00 F0
.pos:
	clc		; $8D8680: 18
	adc.w asv		; $8D8681: 6D 44 16
	sta.w asv		; $8D8684: 8D 44 16
	dey		; $8D8687: 88
	bne .step		; $8D8688: D0 E4
	sta.b mula		; $8D868A: 85 7D
	lda.w #$009D		; $8D868C: A9 9D 00  scale to 0-$9D, + $80
	sta.b mulb		; $8D868F: 85 83
	jsl.l mulu		; $8D8691: 22 42 89 88
	lda.b mulres+2		; $8D8695: A5 95
	adc.w #$0080		; $8D8697: 69 80 00
	cmp.w crowdvol		; $8D869A: CD 46 16
	beq .rtl		; $8D869D: F0 08
	sta.w crowdvol		; $8D869F: 8D 46 16
	pha		; $8D86A2: 48
	jsl.l $8FFE8E		; $8D86A3: 22 8E FE 8F  send it, bank $8F: send the crowd volume to the sound driver
.rtl:
	rtl		; $8D86A7: 6B
asstab:		;SNES: the assignment routines (29 long pointers) that updateplayers calls through jmlvector; numbers as 93G asstab
	dd rtss		; $8D86A8 0
	dd $8EFE73		; $8D86AC 1 assdefo (not named yet)
	dd assdefd		; $8D86B0 2
	dd asswingd		; $8D86B4 3
	dd asswingo		; $8D86B8 4
	dd $8FDB1B		; $8D86BC 5 asscenterd (not named yet)
	dd asscentero		; $8D86C0 6
	dd assscore		; $8D86C4 7
	dd $8FDA8F		; $8D86C8 8 assstanley (not named yet)
	dd $8F833F		; $8D86CC 9 asseben (not named yet)
	dd assepen		; $8D86D0 A
	dd $8E826B		; $8D86D4 B assbench (not named yet)
	dd asspenalty		; $8D86D8 C
	dd $8F8C4B		; $8D86DC D assdopen (not named yet)
	dd assgoalie		; $8D86E0 E
	dd assgoalietopuck		; $8D86E4 F
	dd asspuckc		; $8D86E8 10
	dd assnearest		; $8D86EC 11
	dd assshoot		; $8D86F0 12
	dd asspassrec		; $8D86F4 13
	dd assfight		; $8D86F8 14
	dd assfwatch		; $8D86FC 15
	dd assfaceoff		; $8D8700 16
	dd assfaceoffp1		; $8D8704 17
	dd pucknorm		; $8D8708 18
	dd puckshadow		; $8D870C 19
	dd pucknothing		; $8D8710 1A
	dd puckfaceoff		; $8D8714 1B
	dd puckfaceoff2		; $8D8718 1C
mulu16:		;auto: CODE_8D871C. SNES: 16-bit multiply: A = mula = mulb = mulres = low word of mula * mulb (mode 7 multiplier for a byte factor)
	lda.b mula		; $8D871C: A5 7D
	bmi .full		; $8D871E: 30 47
	cmp.w #$0080		; $8D8720: C9 80 00
	bcc .byteb		; $8D8723: 90 24
	lda.b mulb		; $8D8725: A5 83
	bmi .full		; $8D8727: 30 3E
	cmp.w #$0080		; $8D8729: C9 80 00
	bcs .full		; $8D872C: B0 39
	sep #$20		; $8D872E: E2 20
	sta.w M7B		; $8D8730: 8D 1C 21
	lda.b mula		; $8D8733: A5 7D
	sta.w M7A		; $8D8735: 8D 1B 21
	lda.b mula+1		; $8D8738: A5 7E
	sta.w M7A		; $8D873A: 8D 1B 21
	rep #$30		; $8D873D: C2 30
	lda.w MPYL		; $8D873F: AD 34 21
	sta.b mula		; $8D8742: 85 7D
	sta.b mulb		; $8D8744: 85 83
	sta.b mulres		; $8D8746: 85 93
	rtl		; $8D8748: 6B
.byteb:
	lda.b mulb		; $8D8749: A5 83
	bmi .full		; $8D874B: 30 1A
	sep #$20		; $8D874D: E2 20
	sta.w M7A		; $8D874F: 8D 1B 21
	xba		; $8D8752: EB
	sta.w M7A		; $8D8753: 8D 1B 21
	lda.b mula		; $8D8756: A5 7D
	sta.w M7B		; $8D8758: 8D 1C 21
	rep #$30		; $8D875B: C2 30
	lda.w MPYL		; $8D875D: AD 34 21
	sta.b mula		; $8D8760: 85 7D
	sta.b mulb		; $8D8762: 85 83
	sta.b mulres		; $8D8764: 85 93
	rtl		; $8D8766: 6B
.full:
	sep #$20		; $8D8767: E2 20
	lda.b mula		; $8D8769: A5 7D
	sta.w WRMPYA		; $8D876B: 8D 02 42
	lda.b mulb		; $8D876E: A5 83
	sta.w WRMPYB		; $8D8770: 8D 03 42
	clc		; $8D8773: 18
	clc		; $8D8774: 18
	clc		; $8D8775: 18
	clc		; $8D8776: 18
	lda.w RDMPYL		; $8D8777: AD 16 42
	sta.b mulres		; $8D877A: 85 93
	lda.w RDMPYH		; $8D877C: AD 17 42
	sta.b mulres+1		; $8D877F: 85 94
	lda.b mulb+1		; $8D8781: A5 84
	sta.w WRMPYB		; $8D8783: 8D 03 42
	clc		; $8D8786: 18
	clc		; $8D8787: 18
	clc		; $8D8788: 18
	clc		; $8D8789: 18
	lda.w RDMPYL		; $8D878A: AD 16 42
	adc.b mulres+1		; $8D878D: 65 94
	sta.b mulres+1		; $8D878F: 85 94
	lda.b mula+1		; $8D8791: A5 7E
	sta.w WRMPYA		; $8D8793: 8D 02 42
	lda.b mulb		; $8D8796: A5 83
	sta.w WRMPYB		; $8D8798: 8D 03 42
	clc		; $8D879B: 18
	clc		; $8D879C: 18
	clc		; $8D879D: 18
	clc		; $8D879E: 18
	lda.w RDMPYL		; $8D879F: AD 16 42
	adc.b mulres+1		; $8D87A2: 65 94
	sta.b mulres+1		; $8D87A4: 85 94
	rep #$30		; $8D87A6: C2 30
	lda.b mulres		; $8D87A8: A5 93
	sta.b mula		; $8D87AA: 85 7D
	sta.b mulb		; $8D87AC: 85 83
	clc		; $8D87AE: 18
	rtl		; $8D87AF: 6B
puckshadow:		;auto: CODE_8D87B0 (asstab $19). 93G puckshadow: the shadow object follows the puck (frame $189); else parks it behind the goal
	lda.w frame,x		; $8D87B0: BD 3F 09
	cmp.w #$0189		; $8D87B3: C9 89 01  puck frame: shadow under the puck
	bne .none		; $8D87B6: D0 1C
	lda.w puckx		; $8D87B8: AD 1B 09
	sta.w Xpos,x		; $8D87BB: 9D FF 08
	lda.w pucky		; $8D87BE: AD 7B 09
	sta.w Ypos,x		; $8D87C1: 9D 5F 09
	stz.w Zpos,x		; $8D87C4: 9E 9F 09
	lda.w sfhormode		; $8D87C7: AD 8E 12
	beq .v		; $8D87CA: F0 04
	inc.w Xpos,x		; $8D87CC: FE FF 08
	rtl		; $8D87CF: 6B
.v:
	inc.w Ypos,x		; $8D87D0: FE 5F 09
	rtl		; $8D87D3: 6B
.none:
	tay		; $8D87D4: A8
	beq .rtl		; $8D87D5: F0 23
	stz.w Xpos,x		; $8D87D7: 9E FF 08
	lda.w #300		; $8D87DA: A9 2C 01  behind the goal
	sta.w Ypos,x		; $8D87DD: 9D 5F 09
	lda.w #14		; $8D87E0: A9 0E 00
	sta.w Zpos,x		; $8D87E3: 9D 9F 09
	lda.w pucky		; $8D87E6: AD 7B 09
	bpl .rtl		; $8D87E9: 10 0F
	lda.w #$8000		; $8D87EB: A9 00 80
	sta.w attribute,x		; $8D87EE: 9D DF 09
	lda.w #-300		; $8D87F1: A9 D4 FE
	sta.w Ypos,x		; $8D87F4: 9D 5F 09
	dec.w Zpos,x		; $8D87F7: DE 9F 09
.rtl:
	rtl		; $8D87FA: 6B
setd0player:		;auto: CODE_8D87FB. 93G setd0player: give player d0 to the controller of his team (setc1player/setc2player) unless a controller has him already
	lda.b d0		; $8D87FB: A5 53
	cmp.w c1playernum		; $8D87FD: CD 92 12
	beq .rtl		; $8D8800: F0 39
	cmp.w c2playernum		; $8D8802: CD 94 12
	beq .rtl		; $8D8805: F0 34
	stz.b d1		; $8D8807: 64 57
	cmp.w #$0006		; $8D8809: C9 06 00
	bcs .away		; $8D880C: B0 02
	dec.b d1		; $8D880E: C6 57
.away:
	inc.b d1		; $8D8810: E6 57
	inc.b d1		; $8D8812: E6 57
	lda.w lastplayer		; $8D8814: AD 7D 01
	cmp.w c2playernum		; $8D8817: CD 94 12
	beq .c2		; $8D881A: F0 0B
	lda.b d1		; $8D881C: A5 57
	cmp.w cont1team		; $8D881E: CD 96 12
	bne .c2		; $8D8821: D0 04
	jml.l setc1player		; $8D8823: 5C 48 A1 80
.c2:
	lda.b d1		; $8D8827: A5 57
	cmp.w cont2team		; $8D8829: CD 98 12
	bne .c1		; $8D882C: D0 04
	jml.l setc2player		; $8D882E: 5C 5E A1 80
.c1:
	cmp.w cont1team		; $8D8832: CD 96 12
	bne .rtl		; $8D8835: D0 04
	jml.l setc1player		; $8D8837: 5C 48 A1 80
.rtl:
	rtl		; $8D883B: 6B
SpriteSet10:		;frame set 10 (frames 462-517): frames 462-517
	dw 56		; $8D883C frames
	dw 388		; $8D883E pieces
	dw 768		; $8D8840 tiles
	dw .pieces-SpriteSet10		; $8D8842
	dw .tiles-SpriteSet10		; $8D8844
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,9,18,26,33,42,49,57		; $8D8846
	dw 64,72,80,83,91,99,104,112		; $8D8856
	dw 120,130,135,143,152,158,164,171		; $8D8866
	dw 176,180,184,192,196,202,208,216		; $8D8876
	dw 224,230,236,244,251,258,264,270		; $8D8886
	dw 275,283,292,298,305,311,316,327		; $8D8896
	dw 339,345,349,355,360,367,373,380		; $8D88A6
	dw 388		; $8D88B6
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set10.pieces"		; $8D88B8-$8D8EC7
	assert .tiles-.pieces == 4*388
.tiles:		;768 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set10.chr":0..$144		; $8D8EC8-$8D900B
