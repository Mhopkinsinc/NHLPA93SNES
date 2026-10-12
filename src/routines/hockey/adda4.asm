adda4:		;Move the replay one frame forward
	stz.b d7
	lda.w sflags
	bit.w #sf2drec
	beq .nosf2drec
	lda.b a4+2
	pha
	lda.b a4
	pha
	jsl.l adda43
	lda.b a4
	sta.b tmp0
	lda.b a4+2
	sta.b tmp1
	pla
	sta.b a4
	pla
	sta.b a4+2
	lda.b tmp0
	cmp.w ReplayBufferPtr
	bne .nosf2drec
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .nosf2drec
	rtl
.nosf2drec:
	lda.b a4
	cmp.w ReplayBufferPtr
	bne .a4ne
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .a4ne
	rtl
.a4ne:
	jsl.l RestoreReplayFrame
	jml.l adda43
