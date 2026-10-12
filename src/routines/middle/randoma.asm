randoma:		;randomd0 with A = range: returns A = random 0..range-1 (high word of random*range). C clear
	pha
	jsl.l random
	sta.b mula
	pla
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	lda.b mulres+2
	clc
	rtl
