Restart:		;Restart from scratch: reset the hardware and RAM, set the default handlers and options, then the playoff screen
	sei		; interrupts off, native mode
	clc
	xce
	rep #$30
	lda.w #$1FFF
	tcs
	lda.w #$0000
	tcd
	sep #$20
	pha
	plb
	rep #$30
	jsl.l InitPPU
	ldx.w #$0000
.clr:
	stz.b vcount,x
	inx
	cpx.w #$15FF
	bne .clr
	lda.w #$005C		; jmlvector opcode, sprite slot life 18
	sta.w jmlvector
	lda.w #$0012
	sta.b sprslotlife
	lda.b sprclock		; free all sprite VRAM slots
	sec
	sbc.w #$003C
	ldx.w #$0000
.cache:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .cache
	ldx.w #$0000
.cache2:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .cache2
	lda.w #$0020
	sta.b sprpriority
	lda.w #vb2
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	jsl.l setoptions
	jml.l PlayoffScreenOpening4
