InitTicker:		;Start the score ticker for the other games of the round
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
