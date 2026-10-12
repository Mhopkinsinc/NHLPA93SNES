TickerNext:		;Go to the next ticker game
	lda.w TickerNum
	bmi .last
	ora.w gamenum
	bne .new
.last:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi IntermissionTick_rtl
.new:
	jmp.w NewTicker2
