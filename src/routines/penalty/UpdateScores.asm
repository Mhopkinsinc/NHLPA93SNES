UpdateScores:		;update ticker score values. Called from PeriodOver
		;   SNES: update the ticker scores of the other playoff games (not gamenum, not over)
	jsl.l GetShifter		; GetShifter: d1 = games - 1
	lda.b d1
	sta.w TickerNum
	asl a
	sta.b a0
.top:
	lda.b d1
	cmp.w gamenum
	beq .next
	ldy.b a0
	lda.w gsflags,y		; clear gsfhl; game not over: SetScore
	and.w #~gsfhl&$FFFF
	sta.w gsflags,y
	bit.w #gsfso
	bne .next
	jsl.l SetScore
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
	rtl
