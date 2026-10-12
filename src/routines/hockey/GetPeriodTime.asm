GetPeriodTime:		;return d0 = period length in seconds for the period length option
		;   SNES: d0 = period length in seconds for OptPerlen
	phx
	lda.w OptPerlen
	asl a
	tax
	lda.l GetPeriodTime_timetab,x
	sta.b d0
	plx
	rtl
