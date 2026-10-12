assnothing:		;A computer player stands still
	lda.w pflags,x
	bit.w #$0008
	bne .rtl
	lda.w #$0008
	sta.b d0
	jmp.w doplayeracc
.rtl:
	rtl
