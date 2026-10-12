randomd0:		;d0 = range. Return random number in d0 (0 <= d0 < range)
		;   SNES: d0 = random 0..d0-1 (via randoma)
	lda.b d0
	jsl.l randoma
	sta.b d0
	rtl
