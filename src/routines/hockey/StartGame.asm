StartGame:		;reset game state for a new game, then start the first period
		;   SNES: reset the game state (gmode, offsides option, team stats, scores, gsp), restoreteams, then on to the period start
	stz.w gmode
	lda.w OptPen		; OptPen 1: offsides on
	cmp.w #1
	bne .go
	lda.w #gmoffs
	tsb.w gmode
.go:
	jsl.l ClearTeamStats
	stz.w ScoreSumbytes
	stz.w gsp
	stz.w ChkCnt
	jsl.l restoreteams
	jsl.l InitScores
	jsl.l UpdateScores
	jml.l StartPer		; on to the period start
