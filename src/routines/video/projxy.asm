projxy:		;Project a rink position (x, y, z) to screen coordinates; off screen when too far away
	lda.w sfhormode
	beq .nhor
	lda.b d0
	pha
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d0
	pla
	sec
	sbc.w #$00C5
	sta.b d1
	bra .cx
.nhor:
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.cx:
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0091		; |x| > 144: off
	bcs .off
	lda.b d0
	adc.w #$0080
	sta.b d0
	lda.b d2		; d1 += 1.5 * z
	asl a
	clc
	adc.b d2
	pha
	asl a
	pla
	ror a
	clc
	adc.b d1
	sta.b d1
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0091
	bcs .off
	lda.w #$0070
	sec
	sbc.b d1
	sta.b d1
	rtl
.off:
	lda.w #OFFSCREEN
	sta.b d1
	rtl
