; $89E000-$89F009  ROM $4E000-$4F009: the last SpriteSet13 tiles, printscores1 (penalty93_2) with PrintPerLabel and PrintTeamNameAndScore,
; p_music_vblank (the sound command sender), then RefTilesHor (packed ref window tiles for the horizontal rink), continued in bank89_F000.
org $89E000
	incbin "../data/Sprites/set13.chr":$46A3..$5000		; $89E000-$89E95C
SpriteSet13End:
	assert SpriteSet13End-SpriteSet13 == $5DA+640*32
printscores1:		;auto: CODE_89E95D. 93G printscores1 (penalty93_2): scoreboard. Vertical rink: period box and score box (team names and scores); horizontal rink (.sbscreen): period, team names, scores
	stx.b xsave		; $89E95D: 86 0A
	ldx.w #$0000		; $89E95F: A2 00 00
.pushd:
	lda.b d0,x		; $89E962: B5 53
	pha		; $89E964: 48
	inx		; $89E965: E8
	inx		; $89E966: E8
	cpx.w #$000C		; $89E967: E0 0C 00
	bne .pushd		; $89E96A: D0 F6
	ldx.b xsave		; $89E96C: A6 0A
	stx.b xsave		; $89E96E: 86 0A
	ldx.w #$0000		; $89E970: A2 00 00
.pusha:
	lda.b a0,x		; $89E973: B5 33
	pha		; $89E975: 48
	inx		; $89E976: E8
	inx		; $89E977: E8
	cpx.w #$0010		; $89E978: E0 10 00
	bne .pusha		; $89E97B: D0 F6
	ldx.b xsave		; $89E97D: A6 0A
	lda.w sfhormode		; $89E97F: AD 8E 12  horizontal rink
	beq .v		; $89E982: F0 03
	jmp.w .sbscreen		; $89E984: 4C 58 EA
.v:
	jsl.l printz		; $89E987: 22 0C B9 80
	dw $0005		; $89E98B  printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$17
	lda.w #9		; $89E990: A9 09 00
	sta.b d0		; $89E993: 85 53
	lda.w #5		; $89E995: A9 05 00
	sta.b d1		; $89E998: 85 57
	jsl.l $8FD69F		; $89E99A: 22 9F D6 8F  Framer 9 x 5, bank $8F: 93G Framer (d0 x d1)
	jsl.l printz		; $89E99E: 22 0C B9 80
	dw $0005		; $89E9A2  printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$18
	lda.w gsp		; $89E9A7: AD F0 12
	sta.b d0		; $89E9AA: 85 53
	lda.w #$8236		; $89E9AC: A9 36 82  period name
	sta.b a1		; $89E9AF: 85 37
	lda.w #$008F		; $89E9B1: A9 8F 00
	sta.b a1+2		; $89E9B4: 85 39
	jsl.l $8FD68C		; $89E9B6: 22 8C D6 8F  bank $8F: 93G PrintStringFromList
	jsl.l EASNLogo		; $89E9BA: 22 49 85 8D  EASNLogo, bank $8D: 93G EASNLogo
	lda.w sflags3		; $89E9BE: AD 90 12  lower line change box is up
	bit.w #sf3llcs		; $89E9C1: 89 01 00
	bne .ex		; $89E9C4: D0 73
	jsl.l printz		; $89E9C6: 22 0C B9 80
	dw $0005		; $89E9CA  printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$17
	lda.w #9		; $89E9CF: A9 09 00
	sta.b d0		; $89E9D2: 85 53
	lda.w #5		; $89E9D4: A9 05 00
	sta.b d1		; $89E9D7: 85 57
	jsl.l $8FD69F		; $89E9D9: 22 9F D6 8F  bank $8F: 93G Framer (d0 x d1)
	jsl.l printz		; $89E9DD: 22 0C B9 80
	dw $0005		; $89E9E1  printz inline string: length (counts itself), then control bytes / text
	db $BF,$1C,$18
	stz.b d3		; $89E9E6: 64 5F  home team on the lower row
	stz.b a2		; $89E9E8: 64 3B
	jsl.l PrintTeamNameAndScore		; $89E9EA: 22 D7 EA 89
	jsl.l printz		; $89E9EE: 22 0C B9 80
	dw $0005		; $89E9F2  printz inline string: length (counts itself), then control bytes / text
	db $BF,$18,$18
	inc.b d3		; $89E9F7: E6 5F
	inc.b a2		; $89E9F9: E6 3B
	inc.b a2		; $89E9FB: E6 3B
	jsl.l PrintTeamNameAndScore		; $89E9FD: 22 D7 EA 89
	stz.b a2		; $89EA01: 64 3B
	lda.w #2		; $89EA03: A9 02 00  a2/a3: the team at the top / bottom end by gmdir
	sta.b a3		; $89EA06: 85 3F
	lda.w gmode		; $89EA08: AD 88 12
	bit.w #gmdir		; $89EA0B: 89 02 00
	bne .ends		; $89EA0E: D0 07
	stz.b a3		; $89EA10: 64 3F
	lda.w #2		; $89EA12: A9 02 00
	sta.b a2		; $89EA15: 85 3B
.ends:		;SNES: one call for the team at each end of the rink (nullrtl89 does nothing)
	jsl.l printz		; $89EA17: 22 0C B9 80
	dw $0005		; $89EA1B  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0F,$01
	jsl.l nullrtl89		; $89EA20: 22 14 EB 89
	ldx.b a2		; $89EA24: A6 3B
	lda.b a3		; $89EA26: A5 3F
	sta.b a2		; $89EA28: 85 3B
	stx.b a3		; $89EA2A: 86 3F
	jsl.l printz		; $89EA2C: 22 0C B9 80
	dw $0005		; $89EA30  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0F,$1A
	jsl.l nullrtl89		; $89EA35: 22 14 EB 89
.ex:
	stx.b xsave		; $89EA39: 86 0A
	ldx.w #$000E		; $89EA3B: A2 0E 00
.popa:
	pla		; $89EA3E: 68
	sta.b a0,x		; $89EA3F: 95 33
	dex		; $89EA41: CA
	dex		; $89EA42: CA
	bpl .popa		; $89EA43: 10 F9
	ldx.b xsave		; $89EA45: A6 0A
	stx.b xsave		; $89EA47: 86 0A
	ldx.w #$000A		; $89EA49: A2 0A 00
.popd:
	pla		; $89EA4C: 68
	sta.b d0,x		; $89EA4D: 95 53
	dex		; $89EA4F: CA
	dex		; $89EA50: CA
	bpl .popd		; $89EA51: 10 F9
	ldx.b xsave		; $89EA53: A6 0A
	ldx.b a3		; $89EA55: A6 3F
	rtl		; $89EA57: 6B
.sbscreen:
	jsl.l printz		; $89EA58: 22 0C B9 80
	dw $0005		; $89EA5C  printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$05
	jsl.l PrintPerLabel		; $89EA61: 22 B1 EA 89
	jsl.l printz		; $89EA65: 22 0C B9 80
	dw $0005		; $89EA69  printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$04
	lda.w tmscore		; $89EA6E: AD D6 13  home score in big font
	sta.b d0		; $89EA71: 85 53
	jsl.l $8F8682		; $89EA73: 22 82 86 8F  bank $8F: 93G pushnumber
	jsl.l printbig		; $89EA77: 22 CE FC 8B  bank $8B: 93G printbig
	jsl.l printz		; $89EA7B: 22 0C B9 80
	dw $0005		; $89EA7F  printz inline string: length (counts itself), then control bytes / text
	db $BF,$07,$04
	lda.w tmscore+2		; $89EA84: AD D8 13  away score
	sta.b d0		; $89EA87: 85 53
	jsl.l $8F8682		; $89EA89: 22 82 86 8F  bank $8F: 93G pushnumber
	jsl.l printbig		; $89EA8D: 22 CE FC 8B  bank $8B: 93G printbig
	jsl.l printz		; $89EA91: 22 0C B9 80
	dw $0005		; $89EA95  printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$02
	stz.b d3		; $89EA9A: 64 5F
	jsl.l printteamname		; $89EA9C: 22 BC BA 80
	jsl.l printz		; $89EAA0: 22 0C B9 80
	dw $0005		; $89EAA4  printz inline string: length (counts itself), then control bytes / text
	db $BF,$06,$02
	inc.b d3		; $89EAA9: E6 5F
	jsl.l printteamname		; $89EAAB: 22 BC BA 80
	bra .ex		; $89EAAF: 80 88
PrintPerLabel:		;auto: CODE_89EAB1. SNES: print the PerLabels ($8F8236) entry for gsp (93G AdvanceStringPtr + print)
	lda.w gsp		; $89EAB1: AD F0 12
	sta.b d0		; $89EAB4: 85 53
	lda.w #$8236		; $89EAB6: A9 36 82
	sta.b a0		; $89EAB9: 85 33
	lda.w #$008F		; $89EABB: A9 8F 00
	sta.b a0+2		; $89EABE: 85 35
.next:
	lda.b a0		; $89EAC0: A5 33
	sta.b a1		; $89EAC2: 85 37
	lda.b a0+2		; $89EAC4: A5 35
	sta.b a1+2		; $89EAC6: 85 39
	lda.b [a0]		; $89EAC8: A7 33
	clc		; $89EACA: 18
	adc.b a0		; $89EACB: 65 33
	sta.b a0		; $89EACD: 85 33
	dec.b d0		; $89EACF: C6 53
	bpl .next		; $89EAD1: 10 ED
	jml.l print		; $89EAD3: 5C 2D B9 80
PrintTeamNameAndScore:		;auto: CODE_89EAD7. 93G PrintTeamNameAndScore: team name of team a2 (d3 = home/away), then its score as 2 characters (blank tens)
	jsl.l printteamname		; $89EAD7: 22 BC BA 80
	lda.w #mesarea		; $89EADB: A9 91 01
	sta.b a1		; $89EADE: 85 37
	lda.w #$0000		; $89EAE0: A9 00 00
	sta.b a1+2		; $89EAE3: 85 39
	lda.w #4		; $89EAE5: A9 04 00
	sta.b [a1]		; $89EAE8: 87 37
	lda.w #' '		; $89EAEA: A9 20 00  blank tens
	sta.w mesarea+2		; $89EAED: 8D 93 01
	ldy.b a2		; $89EAF0: A4 3B
	lda.w tmscore,y		; $89EAF2: B9 D6 13
	sta.b mulb		; $89EAF5: 85 83
	lda.w #10		; $89EAF7: A9 0A 00
	sta.b mula		; $89EAFA: 85 7D
	jsl.l divu16		; $89EAFC: 22 D8 B8 80
	beq .ones		; $89EB00: F0 06
	adc.w #'0'		; $89EB02: 69 30 00
	sta.w mesarea+2		; $89EB05: 8D 93 01
.ones:
	lda.b mulres+2		; $89EB08: A5 95
	adc.w #'0'		; $89EB0A: 69 30 00
	sta.w mesarea+3		; $89EB0D: 8D 94 01
	jml.l print		; $89EB10: 5C 2D B9 80
nullrtl89:		;auto: CODE_89EB14. does nothing (printscores1 calls it)
	rtl		; $89EB14: 6B
p_music_vblank:		;auto: CODE_89EB15 (from vblank). 93G p_music_vblank role: every other frame send the next queued sound command (sndqueue) to APUIO0, a counter to APUIO1
	lda.w sndsettle		; $89EB15: AD 9F 04  wait after the sample upload
	bne .settle		; $89EB18: D0 27
	sep #$30		; $89EB1A: E2 30
	lda.b sndlock		; $89EB1C: A5 21
	bne .ex		; $89EB1E: D0 1E
	lda.b vcount		; $89EB20: A5 00  every other frame
	lsr a		; $89EB22: 4A
	bcc .ex		; $89EB23: 90 19
	ldx.b sndqout		; $89EB25: A6 1F
	cpx.b sndqin		; $89EB27: E4 1D
	beq .ex		; $89EB29: F0 13
	lda.b sndqueue,x		; $89EB2B: B5 23
	sta.w APUIO0		; $89EB2D: 8D 40 21
	inc.b sndptr		; $89EB30: E6 1A  sndptr (low byte) doubles as the command counter here
	lda.b sndptr		; $89EB32: A5 1A
	sta.w APUIO1		; $89EB34: 8D 41 21
	txa		; $89EB37: 8A
	inc a		; $89EB38: 1A
	inc a		; $89EB39: 1A
	and.b #$0F		; $89EB3A: 29 0F
	sta.b sndqout		; $89EB3C: 85 1F
.ex:
	rep #$30		; $89EB3E: C2 30
	rtl		; $89EB40: 6B
.settle:
	dec.w sndsettle		; $89EB41: CE 9F 04
	rtl		; $89EB44: 6B
RefTilesHor:		;packed ref window tiles for the horizontal rink (104 tiles, data/RefHor.chr.pak): setupice sends them to refcharshor
	incbin "../data/RefHor.chr.pak":0..$4C5		; $89EB45-$89F009
