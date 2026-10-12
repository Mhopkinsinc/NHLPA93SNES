SuperAdd:		;password bits += d0
	phx
	lda.w passbits
	clc
	adc.b d0
	sta.w passbits
	bcc .ex
	ldx.w #$0002
.carry:
	inc.w passbits,x
	bne .ex
	inx
	inx
	cpx.w #16
	bne .carry
.ex:
	plx
	clc
	rtl
