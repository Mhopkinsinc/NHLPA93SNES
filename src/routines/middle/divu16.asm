divu16:		;Unsigned 16-bit divide: mulres = mulb / mula, with the remainder after the quotient
	lda.b mula
	sta.b mula+2
	stz.b mula
	lda.w #$0010		; 16 quotient bits
	sta.b mulb+2
.loop:
	asl.b mulres
	lsr.b mula+2
	ror.b mula
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
	dec.b mulb+2
	bne .loop
	lda.b mulb
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
