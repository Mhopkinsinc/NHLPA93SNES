PlayerNumName:		;SNES: mesarea = "<uniform number> <name>" of the roster player d0 (team a2), like the Pausemode .gnum digits. Returns X = mesarea
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
	cpx.w #$0008
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
	lda.w #mesarea		; a3 = mesarea (length 4), a1 = mesarea+2
	sta.b a3
	inc a
	inc a
	sta.b a1
	lda.w #$0000
	sta.b a3+2
	sta.b a1+2
	lda.w #$0004
	sta.b [a3]
	lda.b a0		; skip the name: the uniform number byte
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2		; two digits, then a blank and the name
	jsl.l appendz
	dw $0003		; printz inline string: length (counts itself), then control bytes / text
	db " "
	stx.b xsave
	ldx.w #$0002
.poprec:
	pla
	sta.b a1,x
	dex
	dex
	bpl .poprec
	ldx.b xsave
	jsl.l appstring
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
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
	ldx.w #$0006
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
	ldx.b a3
	rtl
