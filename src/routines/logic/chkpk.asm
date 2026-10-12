chkpk:		;Z set if player X is killing a penalty
	lda.w sflags
	and.w #sf2pwrplay		; sf2pwrplay
	bne chkpk2
	inc a
	rtl
