freezewindow:		;Lock the view at its current position
	lda.w Vpos		; yc1 = Vpos, xc1 = Hpos, sfslock
	sta.w yc1
	lda.w Hpos
	sta.w xc1
	lda.w #sfslock
	tsb.w sflags
	rtl
