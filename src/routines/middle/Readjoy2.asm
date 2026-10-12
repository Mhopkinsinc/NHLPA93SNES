Readjoy2:		;read controller 2. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses (all 8 bits), d2 = changed buttons (all 8), d3 = current held buttons (all
		;   8)
	phx
	ldx.w #$0002
	jsl.l ReadJoy
	plx
	lda.w lj2
	sta.b d2
	lda.b d1
	sta.w lj2
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
