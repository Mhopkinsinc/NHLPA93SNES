; middle_b89: 93G middle93_1/middle93_2: utilities (print, joypads, math, decompression).
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $89FC8F
CopyWords:		;SNES: copy d0 bytes (words) from [d2] to [d1]
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
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
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
