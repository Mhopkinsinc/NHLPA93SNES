burst:		;Check button: a speed burst in the facing direction, which costs energy
	jsl.l getpde
	lda.w OptLine		; line changes off: no energy cost
	bne .0
	lda.b d0
	sec
	sbc.w #$00CC		; $1000/20
	sta.b d0
	jsl.l setpde
.0:		;speed = energy*$233/$10000
	lda.b d0
	sta.b mula
	lda.w #$0233
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	lda.b mulres+2
	sta.b mulb
	pha
	lda.w facedir,x
	asl a
	asl a
	tay
	lda.w #dirtab
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0],y
	iny
	iny
	sta.b mula
	jsl.l muls16
	adc.w Xvel,x
	sta.w Xvel,x
	lda.b [a0],y
	sta.b mula
	pla
	sta.b mulb
	jsl.l muls16
	adc.w Yvel,x
	sta.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	sta.b tmp0
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	clc
	adc.b tmp0
	sta.w pspeed,x		; |Xvel|+|Yvel|
	lda.w #SPAburst		; SPAburst $C7E, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
