PlayerShortName:		;SNES: mesarea = "<number> <first initial>. <last name>" of roster player d0 (team a2)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea2:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	jsl.l GetPlayerRecord
	stx.b xsave
	ldx.w #$0000
.pushrec:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushrec
	ldx.b xsave
	lda.w #$0000
	sta.b a1+2
	lda.w #mesarea+2		; a1 = mesarea+2
	sta.b a1
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2		; number
	lda.w #' '
	sta.b [a1]
	inc.b a1
	stx.b xsave
	ldx.w #$0002
.poprec:
	pla
	sta.b a0,x
	dex
	dex
	bpl .poprec
	ldx.b xsave
	lda.b [a0]		; name length
	sta.b d0
	clc
	adc.b a0
	sta.b a2
	lda.b a0+2
	sta.b a2+2
	inc.b a0
	inc.b a0
	lda.b [a0]		; first initial
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.w #'.'
	sta.b [a1]
	inc.b a1
	lda.w #' '
	sta.b [a1]
	inc.b a1
.skipfirst:
	lda.b [a0]		; skip to the last name
	inc.b a0
	and.w #$00FF
	cmp.w #' '
	bne .skipfirst
.last:
	lda.b [a0]
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.b a0
	cmp.b a2
	bne .last
	jsl.l MesAreaDone
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.resta2:
	pla
	sta.b a2,x
	dex
	dex
	bpl .resta2
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
