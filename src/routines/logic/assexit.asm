assexit:		;End player X's current assignment
	lda.w assnum,x
	inc a		; next assignment
	and.w #$0007
	sta.w assnum,x
	lda.w pflags,x
	ora.w #pfna		; pfna
	sta.w pflags,x
	rtl
