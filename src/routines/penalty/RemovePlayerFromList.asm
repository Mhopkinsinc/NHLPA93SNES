RemovePlayerFromList:		;remove the entry before a0 from a penalty box list by shifting the rest down (list ends with a negative byte). Return a0 = removed slot. Called from PenGoalStuff
		;   ProcessPenaltyList
		;   SNES: remove entry a0 from the penalty box list (tmboxlist) by shifting the rest down
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
