checkint:		;check for interference penalty. player a2 interferes with a3 or vice-versa; goalie is only player who cause an interference call. Called from checkcx
		;   SNES: goalie a2 against a3 and the other way round
	lda.b d0+2		; a2 and a3 swapped for the second call
	pha
	lda.b d0
	pha
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .ci
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	pla
	sta.b d0
	pla
	sta.b d0+2
.rtl:
	rtl
.ci:		;a2 must be a goalie, clock running
	ldy.b a2
	lda.w position,y
	bne .rtl
	lda.w gmclock
	bne .rtl
	lda.w puckc		; a3 has the puck: skip the impact 26 test
	asl a
	cmp.b a3
	beq .pc
	lda.w impact,x
	sec
	sbc.w #$001A
	beq .rtl
	bmi .neg
	bvc .pc
	bra .rtl
.neg:
	bvc .rtl
.pc:		;impact of X > 2
	lda.w impact,x
	sec
	sbc.w #$0003
	beq .rtl
	bmi .neg1
	bvc .fall
	bra .rtl
.neg1:
	bvc .rtl
.fall:		;X falls
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l FallDown
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w impact,y		; impact of a2 > 31
	sec
	sbc.w #$001F
	beq .rtl
	bmi .neg2
	bvc .pen
	bra .rtl
.neg2:
	bvc .rtl
.pen:		;no double minor; penalty 3 times in (20 - GGSleft)
	lda.w pflags,x
	bit.w #pf2pen
	bne .rtl
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	jsl.l randoma
	cmp.w #$0003
	bcs .rtl
	lda.w gmode		; not in highlights
	bit.w #gmhl
	bne .rtl
	lda.w #PenInt
	sta.b d0
	jmp.w AddPenalty
