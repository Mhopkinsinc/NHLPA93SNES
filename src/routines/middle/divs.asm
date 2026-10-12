divs:		;Signed divide: A = mulb (32-bit) / mula
	stz.b mulsign		; mulsign = number of negative operands
	lda.b mula
	bpl .apos
	eor.w #$FFFF
	inc a
	inc.b mulsign
.apos:
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulcnt
	lda.b mulb+2
	bpl .loop
	lda.w #$0000
	sec
	sbc.b mulb
	sta.b mulb
	lda.w #$0000
	sbc.b mulb+2
	sta.b mulb+2
	inc.b mulsign
.loop:
	lsr.b mula+2
	ror.b mula
	asl.b mulres
	lda.b mulb
	cmp.b mula
	lda.b mulb+2
	sbc.b mula+2
	bcc .next
	lda.b mulb
	sbc.b mula
	sta.b mulb
	lda.b mulb+2
	sbc.b mula+2
	sta.b mulb+2
	inc.b mulres
.next:
	dec.b mulcnt
	bne .loop
	lsr.b mulsign
	bcc .rtl
	lda.w #$0000
	sbc.b mulres
	sta.b mulres
.rtl:
	lda.b mulres
	clc
	rtl
