EvadePC:		;player a3 should avoid the puck carrier if he's on my team
		;   SNES: within 40 of the puck carrier (after one frame of both velocities) d0 = direction away from him
	lda.w puckc
	bmi .rtl
	lda.w Xvel+1,x		; x after one frame, relative to the puck carrier
	sec
	sbc.w puckvx+1
	and.w #$00FF
	bit.w #$0080
	beq .xs
	ora.w #$FF00
.xs:
	clc
	adc.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .xa
	eor.w #$FFFF
	inc a
.xa:
	cmp.w #41
	bcs .rtl
	lda.w Yvel+1,x
	sec
	sbc.w puckvy+1
	and.w #$00FF
	bit.w #$0080
	beq .ys
	ora.w #$FF00
.ys:
	clc
	adc.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .ya
	eor.w #$FFFF
	inc a
.ya:
	cmp.w #41
	bcs .rtl
	lda.w Xpos,x
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w pucky
	sta.b d1
	jml.l vtoa
.rtl:
	rtl
