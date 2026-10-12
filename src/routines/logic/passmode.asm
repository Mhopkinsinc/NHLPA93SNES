passmode:		;Pass mode: a pad direction sets the pass direction and passes; releasing the button passes too
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
