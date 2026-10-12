skatetopuckinit:		;d0/d1 = puck x/y plus half the high byte of its velocity. Called from skatetopuck and assnearest
	lda.w puckvx		; puckvx high byte / 2
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .x
	ora.w #$FF80
.x:
	clc
	adc.w puckx
	sta.b d0
	lda.w puckvy
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .y
	ora.w #$FF80
.y:
	clc
	adc.w pucky
	sta.b d1
	rtl
