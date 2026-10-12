printbigz:		;see print big. String macro should follow the bsr/jsr to this routine. 93 keeps a1 (92 popped the return into a1)
		;   SNES: printz for printbig: the string follows the jsl inline (length word counting itself); step the return address past it and go to printbig
	lda.b $03,s		; farptr-style: a1 = the inline string after the caller
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l printbig		; print the inline string
