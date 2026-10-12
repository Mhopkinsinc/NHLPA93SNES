Readjoy1:		;Read pad 1: d0 = direction, d1 = new presses, d2 = changed buttons, d3 = buttons held
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
