show_rink:		;Set the rink scroll from the camera position
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
