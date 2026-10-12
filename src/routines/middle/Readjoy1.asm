Readjoy1:		;read controller 1. Return d0 = direction (bit 0-3) and new button (bit 4-7) presses, d1 = new presses (all 8 bits), d2 = changed buttons (all 8), d3 = current held buttons (all
		;   8)
		;   SNES: d0 = direction, d1 = new presses, d2 = changed, d3 = held
	phx
	ldx.w #$0000
	jsl.l ReadJoy
	plx
	lda.w lj1		; d2 = changed, d3 = held, d1 = new presses
	sta.b d2
	lda.b d1
	sta.w lj1
	sta.b d3
	eor.b d2
	sta.b d2
	and.b d1
	sta.b d1
	rtl
