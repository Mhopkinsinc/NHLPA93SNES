holdplayer:		;Hold button: hook, or with an impact hold the player who last hit X
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
