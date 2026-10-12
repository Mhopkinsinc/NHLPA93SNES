Readjoy12:		;SNES: Readjoy1 and Readjoy2, d1 = the new presses of both pads
	jsl.l Readjoy1		; pad 1 or pad 2
	lda.b d1
	pha
	jsl.l Readjoy2
	pla
	ora.b d1
	sta.b d1
	rtl
