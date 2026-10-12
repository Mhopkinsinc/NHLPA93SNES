muls32:		;68k muls.w with a 32-bit result: A/mulres = low word, mulres+2 = high word of mula*mulb (signs folded around mulu)
	stz.b mulneg		; mulneg = number of negative operands
	lda.b mula
	bpl .signb
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mulneg
.signb:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mulneg
.mul:
	jsl.l mulu		; mulres = mula*mulb
	lsr.b mulneg		; odd: negate the 32-bit result
	bcc .rtl
	lda.w #$0000
	sbc.b mulres
	sta.b mula
	sta.b mulb
	sta.b mulres
	lda.w #$0000
	sbc.b mulres+2
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.b mulres
	clc
.rtl:
	rtl
