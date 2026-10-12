SuperAdd:		;1 long (d0.L) added to the 5 words at a3.
		;   SNES: passbits (8 words) += d0 (one word), the carry rippled up
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
