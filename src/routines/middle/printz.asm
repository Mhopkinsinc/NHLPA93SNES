printz:		;print with the string following the call, returning after it. Keeps a1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.b $07,s		; a1 = return address+1: the string
	sta.b a1+2
	lda.b $05,s
	inc a
	sta.b a1
	lda.b [a1]		; return past the string
	clc
	adc.b $05,s
	sta.b $05,s
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	rtl
