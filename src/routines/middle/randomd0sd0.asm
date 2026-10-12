randomd0sd0:		;randomd0s with the range in d0: d0 = random -d0..+d0 (randomd0s in bank $80 takes A)
	lda.b d0
	pha
	asl.b d0
	jsl.l randomd0
	pla
	eor.w #$FFFF
	inc a
	clc
	adc.b d0
	sta.b d0
	clc
	rtl
