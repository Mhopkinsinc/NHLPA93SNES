show_rink:		;using hpos and vpos set scroll cords; queue rink map rows on the dma list (a5)
		;   SNES: vertical rink: Hscroll = Hpos - 128, Vscroll = -Vpos - 112 (the rows are sent elsewhere)
	lda.w sfhormode
	bne .rtl
	lda.w Hpos
	sec
	sbc.w #$0080
	sta.w Hscroll
	lda.w Vpos
	eor.w #$FFFF
	inc a
	sec
	sbc.w #$0070
	sta.w Vscroll
.rtl:
	rtl
