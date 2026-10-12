assnothing:		;player should do nothing
		;   SNES: a computer player stands (doplayeracc 8)
	lda.w pflags,x
	bit.w #$0008
	bne .rtl
	lda.w #$0008
	sta.b d0
	jmp.w doplayeracc
.rtl:
	rtl
