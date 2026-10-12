PickStartingGoalie:		;Pick team a2's starting goalie; computer teams in the later playoff rounds pick one at random by the
		;   scouting report weights
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	ldy.b a2
	lda.w #$0000
	sta.w tmgoalie,y
	jsl.l FigureJoy
	lda.b a2
	tay
	lsr a
	inc a
	sta.b d0
	cmp.w cont1team		; a controller team: keep goalie 0
	beq .x
	cmp.w cont2team
	beq .x
	stz.b d0
	lda.w gamelevel
	sec
	sbc.w #$0002
	beq .po
	bmi .neg
	bvs .po
	bra .set
.neg:
	bvs .set
.po:
	lda.w OptLine
	bne .set
	lda.w #TeamList
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmshots,y
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b a0
	ldy.w #ScoreOdds
	adc.b [a0],y
	sta.b a0
	lda.w #$0004
	sta.b d0
	jsl.l UnpackNibbles
	jsl.l WeightedRandomSelect
.set:
	ldy.b a2
	lda.b d0
	sta.w tmgoalie,y
.x:
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
