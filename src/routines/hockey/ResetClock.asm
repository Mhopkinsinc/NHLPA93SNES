ResetClock:		;Set the period length and stop the clock
	jsl.l GetPeriodTime
	lda.w gsp		; gsp >= 3 (overtime) and OptPlayMode 0: 600 seconds
	sec
	sbc.w #$0003
	bmi .neg
	bvc .overtime
	bra .set
.neg:
	bvc .set
.overtime:
	lda.w OptPlayMode
	bne .set
	lda.w #600
	sta.b d0
.set:
	lda.b d0		; gameclock = PerTimeTotal = d0, gmclock
	sta.w gameclock
	sta.w PerTimeTotal
	sta.w gmclock
	rtl
unusedFF85:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
