AddPenalty:		;Call penalty d0 on player X, unless the clock is stopped or penalties (or offsides) are turned off
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
