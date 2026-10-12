CheckInjury:		;called once per second. Count down InjCntDown, act on it at zero
		;   SNES: once a second: count InjCntDown down; at zero ShowInjuryBox
	dec.w InjCntDown
	bne .rtl
	jmp.w ShowInjuryBox
.rtl:
	rtl
