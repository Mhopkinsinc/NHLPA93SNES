; Utilities (print, joypads, math, decompression).
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $89FC8F
CopyWords:		;SNES: copy d0 bytes (words) from [d2] to [d1]; d0-d5 and X kept
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
