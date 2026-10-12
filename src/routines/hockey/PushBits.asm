PushBits:		;password bits = password bits * d1 + d0
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.b d0		; d0 <-> d1
	ldx.b d1
	sta.b d1
	stx.b d0
	jsl.l SuperMult		; passbits *= d0
	stz.b d0+2
	lda.b d1
	sta.b d0
	jsl.l SuperAdd		; passbits += d0
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
