TickerNext:		;SNES: next ticker game (restart at the last game of the round), NewTicker2
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
