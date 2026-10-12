chkpk:		;return z flag set if killing penalty
		;   SNES: Z set if player X is killing a penalty. No power play returns NE
	lda.w sflags
	and.w #sf2pwrplay		; sf2pwrplay
	bne chkpk2
	inc a
	rtl
