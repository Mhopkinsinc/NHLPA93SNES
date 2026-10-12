ProcessInputWithRepeat:		;nodiag, then key repeat on d1-d3 from Readjoy1/2. A change (d2) resets the delay to 15 frames; while the same buttons stay held, every 4 frames return d1 = held
		;   buttons (d3). Called from Pausemode, menus and IntermissionLoop
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
