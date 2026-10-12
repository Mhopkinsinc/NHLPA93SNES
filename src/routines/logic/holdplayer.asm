holdplayer:		;abut press hold. a0 = the player this one is
		;   SNES: Y pressed: hold. With impact, hold the last player who hit X (Acheck)
	lda.w #SPAhook		; pfalock
	sta.b d1
	sta.w pfalock,x
	lda.w impact,x
	bne .imp
	jmp.w SetSPA
.imp:
	lda.w impactp,x		; a0 = d0 = impactp*2
	asl a
	sta.b d0
	sta.b a0
	jml.l Acheck
