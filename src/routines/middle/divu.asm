divu:		;Unsigned divide: A = mulb (32-bit) / mula, with the remainder after the quotient
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010
	sta.b mulres+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
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
	dec.b mulres+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
