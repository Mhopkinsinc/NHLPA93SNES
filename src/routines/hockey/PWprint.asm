PWprint:		;print pass word
		;   SNES: print the 16 password characters (PassWord through PasstoText) at printx/printy, unless PassWord bit 7 hides it
	lda.w PassWord
	bit.w #$0080
	beq .show
	jmp.w .rtl
.show:
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
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .savea
	ldx.b xsave
	lda.w #PasstoText		; a2 = PasstoText
	sta.b a2
	lda.w #PasstoText>>16
	sta.b a2+2
	lda.w #mesarea		; a1 = mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #PassWord
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #18		; length 18: 16 characters
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w #15
	sta.b d1
.top:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	tay
	lda.b [a2],y
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .top
	lda.w #mesarea
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l print
	stx.b xsave
	ldx.w #$000A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
