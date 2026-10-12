randoma:		;A = a random number from 0 to A-1
	pha
	jsl.l random
	sta.b mula
	pla
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	lda.b mulres+2
	clc
	rtl
