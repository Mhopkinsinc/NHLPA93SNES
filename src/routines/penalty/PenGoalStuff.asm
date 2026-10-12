PenGoalStuff:		;do this stuff after a goal. a1 = scored on team, a2 = scoring team. If the scoring team had more players on ice, the first scored on player in the box without a coincidental
		;   penalty is released
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
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	jsl.l ClearPenaltyBuffer
	ldy.b a2
	lda.w tmap,y		; tmap(a2) - tmap(a1) > 0?
	ldy.b a1
	sec
	sbc.w tmap,y
	beq .ex
	bmi .v1
	bvc .more
	bra .ex
.v1:
	bvc .ex
.more:		;scoring team had more players on the ice
	lda.b a1
	beq .lst
	lda.w #$001A
.lst:
	sta.b a0
.loop:		;next player in the box list (negative = end)
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .ex
	lda.b a1
	beq .tm
	lda.w #$0034
.tm:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y		; coincidental penalty: skip
	bit.w #$4000
	bne .loop
	lda.w #$0000		; out of the box, one more on the ice, power play goal
	sta.w tmpdst,y
	jsl.l RemovePlayerFromList
	ldy.b a1
	lda.w tmap,y
	inc a
	sta.w tmap,y
	ldy.b a2
	lda.w tmPwrGoals,y
	inc a
	sta.w tmPwrGoals,y
	lda.w #tmflcc
	tsb.w tmflags		; line change box redraw
	tsb.w tmflags+2
.ex:
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
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
