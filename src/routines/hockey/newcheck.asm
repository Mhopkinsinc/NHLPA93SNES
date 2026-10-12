newcheck:		;Play a body check sound
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXcheck
	pha
	jsl.l sfx
	rtl
