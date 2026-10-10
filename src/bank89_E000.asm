; $89E000-$89F009  ROM $4E000-$4F009: the last SpriteSet13 tiles, printscores1 (penalty93_2) with PrintPerLabel and PrintTeamNameAndScore,
; p_music_vblank (the sound command sender), then RefTilesHor (packed ref window tiles for the horizontal rink), continued in bank89_F000.
org $89E000
	incbin "../data/Sprites/set13.chr":$46A3..$5000		; $89E000-$89E95C
SpriteSet13End:
	assert SpriteSet13End-SpriteSet13 == $5DA+640*32
printscores1:		;draw scoreboard. Vertical rink: period box and the score box (team names and scores). Horizontal rink (.sbscreen): period and both team logos with big scores. Called from
		;   USBoard, Pausemode, lcfound2 and others (93G penalty93_2)
		;   SNES: Vertical rink: period box and score box (team names and scores); horizontal rink (.sbscreen): period, team names, scores
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
	lda.w sfhormode		; horizontal rink
	beq .v
	jmp.w .sbscreen
.v:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$17
	lda.w #9
	sta.b d0
	lda.w #5
	sta.b d1
	jsl.l Framer		; Framer 9 x 5, bank $8F: 93G Framer (d0 x d1)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$18
	lda.w gsp
	sta.b d0
	lda.w #PerLabels		; period name
	sta.b a1
	lda.w #PerLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList		; bank $8F: 93G PrintStringFromList
	jsl.l EASNLogo		; EASNLogo, bank $8D: 93G EASNLogo
	lda.w sflags3		; lower line change box is up
	bit.w #sf3llcs
	bne .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$17
	lda.w #9
	sta.b d0
	lda.w #5
	sta.b d1
	jsl.l Framer		; bank $8F: 93G Framer (d0 x d1)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$1C,$18
	stz.b d3		; home team on the lower row
	stz.b a2
	jsl.l PrintTeamNameAndScore
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$18,$18
	inc.b d3
	inc.b a2
	inc.b a2
	jsl.l PrintTeamNameAndScore
	stz.b a2
	lda.w #2		; a2/a3: the team at the top / bottom end by gmdir
	sta.b a3
	lda.w gmode
	bit.w #gmdir
	bne .ends
	stz.b a3
	lda.w #2
	sta.b a2
.ends:		;SNES: one call for the team at each end of the rink (nullrtl89 does nothing)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0F,$01
	jsl.l nullrtl89
	ldx.b a2
	lda.b a3
	sta.b a2
	stx.b a3
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0F,$1A
	jsl.l nullrtl89
.ex:
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
.sbscreen:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$05
	jsl.l PrintPerLabel
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$04
	lda.w tmscore		; home score in big font
	sta.b d0
	jsl.l pushnumber		; bank $8F: 93G pushnumber
	jsl.l printbig		; bank $8B: 93G printbig
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$07,$04
	lda.w tmscore+2		; away score
	sta.b d0
	jsl.l pushnumber		; bank $8F: 93G pushnumber
	jsl.l printbig		; bank $8B: 93G printbig
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$17,$02
	stz.b d3
	jsl.l printteamname
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$06,$02
	inc.b d3
	jsl.l printteamname
	bra .ex
PrintPerLabel:		;SNES: print the PerLabels ($8F8236) entry for gsp (93G AdvanceStringPtr + print)
	lda.w gsp
	sta.b d0
	lda.w #PerLabels
	sta.b a0
	lda.w #PerLabels>>16
	sta.b a0+2
.next:
	lda.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	dec.b d0
	bpl .next
	jml.l print
PrintTeamNameAndScore:		;print the team name of team a2 at printx/printy, then its score as 2 digits at x $1C. Called twice from printscores1 (93G penalty93_2)
		;   SNES: team name of team a2 (d3 = home/away), then its score as 2 characters (blank tens)
	jsl.l printteamname
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #4
	sta.b [a1]
	lda.w #' '		; blank tens
	sta.w mesarea+2
	ldy.b a2
	lda.w tmscore,y
	sta.b mulb
	lda.w #10
	sta.b mula
	jsl.l divu16
	beq .ones
	adc.w #'0'
	sta.w mesarea+2
.ones:
	lda.b mulres+2
	adc.w #'0'
	sta.w mesarea+3
	jml.l print
nullrtl89:		;does nothing (printscores1 calls it)
	rtl
p_music_vblank:		;92 name (vblank handler). Clear the change bits, run the 8 track slots (d7 = track 7-0), (93G sound93)
		;   SNES: role: every other frame send the next queued sound command (sndqueue) to APUIO0, a counter to APUIO1
	lda.w sndsettle		; wait after the sample upload
	bne .settle
	sep #$30
	lda.b sndlock
	bne .ex
	lda.b vcount		; every other frame
	lsr a
	bcc .ex
	ldx.b sndqout
	cpx.b sndqin
	beq .ex
	lda.b sndqueue,x
	sta.w APUIO0
	inc.b sndptr		; sndptr (low byte) doubles as the command counter here
	lda.b sndptr
	sta.w APUIO1
	txa
	inc a
	inc a
	and.b #$0F
	sta.b sndqout
.ex:
	rep #$30
	rtl
.settle:
	dec.w sndsettle
	rtl
RefTilesHor:		;packed ref window tiles for the horizontal rink (104 tiles, data/RefHor.chr.pak): setupice sends them to refcharshor
	incbin "../data/RefHor.chr.pak":0..$4C5		; $89EB45-$89F009
