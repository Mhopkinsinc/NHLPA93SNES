ShowGoalBox:		;The goal box: "GOAL!" or "HAT TRICK!" with the scorer and the assists
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
	cpx.w #$0014
	bne .savea
	ldx.b xsave
	stz.b a2
	jsl.l lcfound2
	inc.b a2
	inc.b a2
	jsl.l lcfound2
	lda.w #$0000
	sta.b a4+2
	lda.w #ScoreSum-6
	clc
	adc.w ScoreSumbytes
	sta.b a4
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02
	lda.w #$0013
	sta.b d0
	lda.w #$0005
	sta.b d1
	ldy.w #$0004
	lda.b [a4],y
	bit.w #$0080
	bne .frame
	inc.b d1
	inc.b d1
	lda.b [a4],y
	bmi .frame
	inc.b d1
.frame:
	jsl.l Framer
	stz.b a2
	ldy.w #$0002
	lda.b [a4],y
	bit.w #$0080
	beq .home
	inc.b a2
	inc.b a2
.home:
	lda.w #GoalBoxText
	sta.b a1
	lda.w #GoalBoxText>>16
	sta.b a1+2
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	ldy.b a2
	beq .tmofs
	clc
	adc.w #$001A
.tmofs:
	tay
	lda.w tmgoals,y		; goals of the scorer
	and.w #$00FF
	cmp.w #$0003
	bne .goal
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.goal:
	jsl.l printbig
	ldy.w #$0003
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0004
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0E,$06,"Assist by:",$BF,$0C,$07
	jsl.l PlayerShortName
	jsl.l print
	ldy.w #$0005
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$08
	jsl.l PlayerShortName
	jsl.l print
.ex:
	stx.b xsave
	ldx.w #$0012
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
