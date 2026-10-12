passmode:		;dpad sets passdir until bbut changes
		;   SNES: B held: a dpad direction sets passdir (d0 | 8) before dopass
	lda.b d2
	bit.w #$8000
	bne dopass
	lda.b d0
	bit.w #$0008
	bne .rtl
	and.w #$0007
	sta.w passdir
	ora.w #$0008
	sta.b d0
	bra dopass
.rtl:
	rtl
