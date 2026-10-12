makepde:		;pass d0 as value to be scaled by player a0's energy level
		;   SNES: d0 = rating A (on entry) scaled by the energy of player a0: A*energy/$1000
	pha
	stx.b xsave
	ldx.w #$0000
.save:		;movem d1/a2-a3
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	ldx.b a0		; a3 = a0 for getpde
	stx.b a3
	jsl.l getpde
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a2,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d1,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	pla
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	asl a		; *16, high word: *energy/$1000
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	asl a
	rol.b mulres+2
	lda.b mulres+2
	sta.b d0
	clc
	rtl
