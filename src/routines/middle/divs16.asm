divs16:		;SNES: signed 16 / 16 divide: A = mulres = mulb / mula (toward zero; also left in mula and mulb); uses mulsign, mulcnt
	stz.b mulsign
	lda.b mula
	bpl .mulapos
	eor.w #$FFFF
	inc a
	inc.b mulsign
.mulapos:
	sta.b mula+2
	stz.b mula
	lda.w #$0010
	sta.b mulcnt
	lda.b mulb
	bpl .loop
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mulsign
.loop:
	lsr.b mula+2
	ror.b mula
	asl.b mulres
	lda.b mulb
	cmp.b mula
	lda.w #$0000
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	inc.b mulres
.next:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .pos
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.pos:
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
