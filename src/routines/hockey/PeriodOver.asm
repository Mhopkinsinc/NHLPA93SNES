PeriodOver:		;End of a period: the next period, overtime for a tied playoff game, or game over
	jsl.l forceblack
	inc.w gsp		; next period
	lda.w gmode
	eor.w #gmdir
	sta.w gmode
	lda.w gsp
	cmp.w #$0003		; after overtime (period 4+)
	beq .ot
	bcc .next
	lda.w #$0003
	sta.w gsp
	lda.w OptPlayMode
	bne .ot
	lda.w #$0004
	sta.w gsp
.ot:
	lda.w tmscore		; tied: overtime
	cmp.w tmscore+2
	beq .next
	lda.w #$0004
	sta.w gsp
.next:
	jsl.l ResetClock
	jsl.l SetHor
	jsl.l setvideo
	jsl.l UpdateScores
	jsl.l Intermission
	lda.w gsp
	cmp.w #$0004
	bne .per
	jml.l GameOver
.per:
	jmp.w StartPer
