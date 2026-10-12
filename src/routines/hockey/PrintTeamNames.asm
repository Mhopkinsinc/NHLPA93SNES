PrintTeamNames:		;SNES: regular season: HomeTeam/VisTeam from the options; print both team names (DrawTeamBlocks), then setteams
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .savea
	ldx.b xsave
	lda.w OptPlayMode		; OptPlayMode 0: teams from the options
	bne .print
	lda.w OptTeam1
	sta.w HomeTeam
	lda.w OptTeam2
	sta.w VisTeam
.print:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$02,$01
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; print team d1 name
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BE,$15,$01
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks		; print team d1 name
	jsl.l setteams
	stx.b xsave
	ldx.w #$000A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
