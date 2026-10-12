NewTicker2:		;d3 = the next game for the ticker, or negative when none is left
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
