suba4:		;a4 = address in replay buffer of current
		;   SNES: replay a4 one frame back (wrap at ReplayBufferStart unless sfwrap), RestoreReplayFrame; d7 = 0 at the end
	lda.b a4
	cmp.w #ReplayBufferStart
	bne .a4ne
	lda.b a4+2
	cmp.w #ReplayBufferStart>>16
	bne .a4ne
	lda.w sflags
	bit.w #sfwrap
	beq .end
	lda.w #ReplayBufferEnd
	sta.b a4
	lda.w #ReplayBufferEnd>>16
	sta.b a4+2
.a4ne:
	lda.b a4
	sec
	sbc.w #replaysize
	sta.b a4
	lda.b a4+2
	sbc.w #$0000
	sta.b a4+2
	lda.b a4
	cmp.w ReplayBufferPtr
	beq .a4eq
	jml.l RestoreReplayFrame
.a4eq:
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	beq .a4eq2
	jml.l RestoreReplayFrame
.a4eq2:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	lda.b a4+2
	adc.w #$0000
	sta.b a4+2
.end:
	jsl.l RestoreReplayFrame
	stz.b d7
	rtl
