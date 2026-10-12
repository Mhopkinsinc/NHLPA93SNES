GetPeriodTimeRemaining:		;return d0 = (gsp << 14 | PerTimeTotal) - gameclock. Called from Goal (ScoreSum entry) and InProgress
		;   SNES: d0 = (gsp << 14 | PerTimeTotal) - gameclock (Goal and InProgress log it)
	lda.w gsp		; gsp in bits 14-15
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	ora.w PerTimeTotal
	sec
	sbc.w gameclock
	sta.b d0
	rtl
