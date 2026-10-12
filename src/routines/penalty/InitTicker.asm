InitTicker:		;SNES: start the ticker at the last game of the round (GetShifter) unless one is running, then NewTicker2
	lda.w TickerNum
	bmi .last
	ora.w gamenum
	bne .new
.last:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi Intermission_rtl
.new:
	jmp.w NewTicker2
