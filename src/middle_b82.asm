; Utilities (print, joypads, math, decompression).
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82FCDB
muls32:		;68k muls.w with a 32-bit result: A/mulres = low word, mulres+2 = high word of mula*mulb (signs folded around mulu mulu)
	stz.b mulneg		; mulneg = number of negative operands
	lda.b mula
	bpl .b
	eor.w #$FFFF
	inc a
	sta.b mula
	inc.b mulneg
.b:
	lda.b mulb
	bpl .mul
	eor.w #$FFFF
	inc a
	sta.b mulb
	inc.b mulneg
.mul:
	jsl.l mulu		; bank $88, mulres = mula*mulb
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

org $82FDBF
printbigz:		;see print big. String macro should follow the bsr/jsr to this routine. 93 keeps a1 (92 popped the return into a1)
		;   SNES: printz for printbig: the string follows the jsl inline (length word counting itself); step the return address past it and go to printbig
	lda.b $03,s		; farptr-style: a1 = the inline string after the caller
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l printbig		; bank $8B: print the inline string
appendz:		;see appstring. String macro should follow the bsr/jsr to this routine
		;   SNES: like printbigz, for appstring appstring (append an inline string)
	lda.b $03,s
	sta.b a1+2
	lda.b $01,s
	inc a
	sta.b a1
	lda.b [a1]
	clc
	adc.b $01,s
	sta.b $01,s
	jml.l appstring		; bank $8F
