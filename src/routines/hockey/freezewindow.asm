freezewindow:		;lock scrolling to current position
		;   SNES: lock scrolling at the current position
	lda.w Vpos		; yc1 = Vpos, xc1 = Hpos, sfslock
	sta.w yc1
	lda.w Hpos
	sta.w xc1
	lda.w #sfslock
	tsb.w sflags
	rtl
