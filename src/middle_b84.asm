; middle_b84: 93G middle93_1/middle93_2: utilities (print, joypads, math, decompression).
; Bank $84. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $84EA39
PutDigits2:		;SNES: write the 2 digit number d0 (BCD byte, blank leading zero) as 2 characters at [a1], a1 += 2
	lda.w #$2020		; blank, then the tens digit when d0 >= 10
	sta.b tmp0
	lda.b d0
	and.w #$00FF
	cmp.w #$000A
	bcc .lo
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.w #$0030
	sta.b tmp0
.lo:
	lda.b d0
	and.w #$000F
	clc
	adc.w #$0030
	sta.b tmp0+1
	lda.b tmp0
	sta.b [a1]
	inc.b a1
	inc.b a1
	rtl

org $84FAD2
Readjoy12:		;SNES: Readjoy1 and Readjoy2, d1 = the new presses of both pads
	jsl.l Readjoy1		; pad 1 or pad 2
	lda.b d1
	pha
	jsl.l Readjoy2
	pla
	ora.b d1
	sta.b d1
	rtl
