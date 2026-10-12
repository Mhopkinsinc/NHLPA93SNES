GoalBoxText:		;printbig strings of ShowGoalBox: GOAL!, then HAT TRICK!
	dw 13
	db $BF,$0F,$03,"GOAL!",$BF,$0C,$05
	dw 18
	db $BF,$0C,$03,"HAT TRICK!",$BF,$0C,$05
unusedFF8F:		;the end of the ROM: zero fill
	db 0,0,0,0,0
