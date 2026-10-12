CopyWords:		;Copy d0 bytes from [d2] to [d1], a word at a time
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
.copy:
	lda.b [d2]
	sta.b [d1]
	inc.b d1
	inc.b d1
	inc.b d2
	inc.b d2
	dec.b d0
	dec.b d0
	bne .copy
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
