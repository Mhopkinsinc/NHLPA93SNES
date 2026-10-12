RemovePlayerFromList:		;Remove entry a0 from a penalty box list by moving the rest down
	lda.w #$FFFF
	sta.b d2
.loop:
	inc.b d2
	lda.b a0
	clc
	adc.b d2
	tay
	sep #$20
	lda.w tmboxlist,y
	sta.w tmboxlist-1,y
	rep #$30
	bit.w #$0080
	beq .loop
	dec.b a0
	rtl
