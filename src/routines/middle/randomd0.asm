randomd0:		;d0 = a random number from 0 to d0-1
	lda.b d0
	jsl.l randoma
	sta.b d0
	rtl
