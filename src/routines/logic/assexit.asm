assexit:		;exit current assignment on player a3
		;   SNES: exit the current assignment of player X
	lda.w assnum,x
	inc a		; next assignment
	and.w #$0007
	sta.w assnum,x
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	rtl
