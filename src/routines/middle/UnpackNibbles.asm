UnpackNibbles:		;Unpack d0 4-bit values at [a0] (high nibble first) into words at nibblebuffer
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
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.w #nibblebuffer
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b d2
	bra .next
.loop:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d1
	inc.b d2
	lda.b d2
	lsr a
	bcc .lo
	dec.b a0
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
.lo:
	lda.b d1
	and.w #$000F
	sta.b [a1]
	inc.b a1
	inc.b a1
.next:
	dec.b d0
	bpl .loop
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
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
