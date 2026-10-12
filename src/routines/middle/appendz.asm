appendz:		;appstring with the string following the call
	lda.b $03,s
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l appstring
