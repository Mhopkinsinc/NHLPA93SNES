AddPenalty:		;add penalty d0 (PenaltyList offset) for player X. Ignored while the clock is stopped, when penalties are off, or offsides when offsides
		;   are off. Falls into AddPenalty2
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.b d0
	cmp.w #PenIcing		; icing always counts
	beq AddPenalty2
	lda.w OptPen		; penalties off
	beq .rtl
	lda.w gmode
	bit.w #gmoffs		; offsides on: all count
	bne AddPenalty2
	lda.b d0
	cmp.w #PenOffsides		; offsides off: no offsides penalty
	bne AddPenalty2
.rtl:
	rtl
