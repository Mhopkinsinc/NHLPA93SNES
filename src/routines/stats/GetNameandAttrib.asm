GetNameandAttrib:		;print player d0's name, then the column picked by d4
		;   SNES: print player d0 (number and name), then at x 26 the column d4 (attribjmp); columns above 2 average the rating nibbles masked by
		;   d4 high word
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
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
	jsl.l PlayerNumName
	jsl.l print
	lda.w #$001A
	sta.w printx
	lda.b d4		; status, energy, handed: no ratings
	cmp.w #$0003
	bcs .rate
	jmp.w .jump
.rate:
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w tmdata,y
	sta.b a0
	clc
	ldy.w #Playerdata
	adc.b [a0],y
	sta.b a0
.skip:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
	dec.b d0
	bpl .skip
	stz.b d0
	stz.b d1
	lda.w #$000F
	sta.b d2
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.bit:
	lda.b d4
	sta.b tmp0
	lda.b d4+2
	sta.b tmp1
	lda.b d2
	sta.b tmp2
.shift:
	dec.b tmp2
	bmi .test
	lsr.b tmp1
	ror.b tmp0
	bra .shift
.test:
	lsr.b tmp0
	bcc .next
	lda.b d2
	lsr a
	eor.w #$FFFF
	inc a
	dec a
	clc
	adc.b a0
	sta.b tmp0
	lda.b a0+2
	sta.b tmp1
	lda.b [tmp0]
	sta.b d3
	lda.b d2
	lsr a
	bcc .2
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d3
.2:
	lda.b d3
	and.w #$000F
	sta.b d3
	clc
	adc.b d0
	sta.b d0
	lda.b d1
	clc
	adc.w #$000F
	sta.b d1
.next:
	dec.b d2
	bpl .bit
	lda.b d4
	ldy.b d4+2
	sta.b d4+2
	sty.b d4
.jump:		;go to attribjmp[d4] through jmlvector
	lda.w #attribjmp
	sta.b a0
	lda.w #attribjmp>>16
	sta.b a0+2
	ldy.b d4
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
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
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
