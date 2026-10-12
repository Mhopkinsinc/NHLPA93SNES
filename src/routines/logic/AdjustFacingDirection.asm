AdjustFacingDirection:		;Turn facedir one step
		;   SNES: turn facedir of goalie X one step toward d0, not past the sides of the net
	lda.w facedir,x
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bne .turn
	jmp.w assgoalie_rtl
.turn:
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .add
	cmp.w #$0006
	bne .dn
.add:
	clc
	adc.b d0
	sta.b d1
	lda.w pfgoal,x
	bne .other
	lda.b d1
	cmp.w #$0002
	bcc .neg
	cmp.w #$0007
	beq .neg
	bra .set
.other:
	lda.b d1
	cmp.w #$0003
	bcc .set
	cmp.w #$0006
	bcs .set
.neg:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	clc
	adc.b d1
	sta.b d1
.dn:
	lda.b d1
	clc
	adc.b d0
	sta.b d1
.set:
	lda.b d1
	and.w #$0007
	sta.b d1
	sta.w facedir,x
	rtl
