muls16:		;68k muls.w: A = mula*mulb (signed 16-bit result, also in mula/mulb/mulres); C clear. Signs folded around the unsigned mulu16
	stz.b mula+2		; count the negative operands in mula+2
	lda.b mula
	bpl .bpos
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mula+2
.bpos:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mula+2
.mul:
	jsl.l mulu16		; mulres = mula*mulb
	lsr.b mula+2		; odd count: negate the result
	bcc .rtl
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	sta.b mulres
	clc
.rtl:
	rtl
