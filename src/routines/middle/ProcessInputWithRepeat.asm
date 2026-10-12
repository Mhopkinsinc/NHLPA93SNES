ProcessInputWithRepeat:		;Read pads 1 and 2 with key repeat: a held button repeats after a delay. Used by the pause menu and menus
	jsl.l nullrtl85
	lda.b d3
	beq .rtl
	lda.b d2		; d2 = changed buttons
	bne .chg
	dec.w repeatdelay
	bpl .rtl
	lda.w #4
	sta.w repeatdelay
	lda.b d3
	sta.b d1
.rtl:
	rtl
.chg:
	lda.w #15
	sta.w repeatdelay
	rtl
