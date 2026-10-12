a2offsides:		;Offsides if the player's team is flagged and the puck is past the blue line
	ldy.b a2
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	bne .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w #blueline		; blueline
	bmi .neg
	bvc .team
	bra .rtl
.neg:
	bvc .rtl
.team:
	stz.b a0
	lda.w pfteam,y
	beq .1
	lda.w #$0002
	sta.b a0
.1:
	ldy.b a0
	lda.w tmflags,y
	bit.w #tmfoffside		; team flagged offsides
	beq .rtl
	lda.w gmode
	bit.w #gmhl		; gmhl
	bne .rtl
	ldx.b a2		; exg a2,a3
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #PenOffsides		; PenOffsides
	sta.b d0
	jsl.l AddPenalty		; AddPenalty
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
.rtl:
	rtl
