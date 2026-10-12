GetPeriodTimeRemaining:		;d0 = the period and the time into it, for the goal and penalty logs
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
