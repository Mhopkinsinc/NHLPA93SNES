printscores1:		;Draw the scoreboard: the period and score boxes on the vertical rink, or the period, teams and scores on the
		;   horizontal rink
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
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
	jsl.l Framer		; Framer 9 x 5, bank $8F (d0 x d1)
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$18
	lda.w gsp
	sta.b d0
	lda.w #PerLabels		; period name
	sta.b a1
	lda.w #PerLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	jsl.l EASNLogo
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
	jsl.l Framer		; d0 x d1
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
.ends:		;one call for the team at each end of the rink (nullrtl89 does nothing)
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
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
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
	jsl.l PushNumber
	jsl.l printbig
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$07,$04
	lda.w tmscore+2		; away score
	sta.b d0
	jsl.l PushNumber
	jsl.l printbig
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
