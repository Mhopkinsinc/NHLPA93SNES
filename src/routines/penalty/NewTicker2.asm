NewTicker2:		;goto next ticker. Return d3 = game, or neg if none left. Falls into CheckGameTickerStatus
		;   SNES: d3 = next ticker game (not the user game, no highlight coming, series not over)
	lda.w OptPlayMode
	beq .rtl
	lda.w TickerNum
	sta.b d3
	bmi .rtl
	dec.w TickerNum
	lda.b d3
	cmp.w gamenum
	beq NewTicker2
	bra NewTicker3
.rtl:
	rtl
