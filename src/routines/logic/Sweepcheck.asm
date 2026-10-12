Sweepcheck:		;start sweep check on player a3
		;   SNES: start a sweep check on player X
	lda.w #SPAsweepchk		; SPAsweepchk $B44, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
