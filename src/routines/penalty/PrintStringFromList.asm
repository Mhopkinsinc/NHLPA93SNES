PrintStringFromList:		;print string d0 of the String list a1 with printsmall
		;   SNES: print string d0 of the list [a1]
	lda.b d0
	bne .skip
	jml.l print
.skip:
	lda.b [a1]
	clc
	adc.b a1
	sta.b a1
	dec.b d0
	bra PrintStringFromList
