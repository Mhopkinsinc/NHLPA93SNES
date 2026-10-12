CheckInjury:		;Once a second, count down to the next injury and show it when the count reaches zero
	dec.w InjCntDown
	bne .rtl
	jmp.w ShowInjuryBox
.rtl:
	rtl
