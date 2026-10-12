newcheck:		;start a new check sound. Called from checkcx; FallDown branches here when the player who fell did not have the puck
		;   SNES: check sound SFXcheck + random 0/1
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXcheck
	pha
	jsl.l sfx
	rtl
