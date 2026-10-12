Sweepcheck:		;Start a sweep check by player X
	lda.w #SPAsweepchk		; SPAsweepchk $B44, pfalock
	sta.b d1
	sta.w pfalock,x
	jmp.w SetSPA
