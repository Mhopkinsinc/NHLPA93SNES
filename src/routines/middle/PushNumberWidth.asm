PushNumberWidth:		;93: convert d0 into a d1 digit base 10 string, leading zeros as spaces (the last digit always shown). Return a1 = string at
		;   PushWidthBuf
		;   SNES: a1 = PushWidthBuf: d0 as a d1 digit decimal string, right aligned with leading spaces (the last digit always shown)
	lda.w #PushWidthBuf
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b d1
	inc a
	inc a
	sta.w PushWidthBuf
	tay
	lda.w #$2020
	sta.w PushWidthBuf+2
	sta.w PushWidthBuf+4
	sta.w PushWidthBuf+6
	sta.w PushWidthBuf+8
	lda.b d0
.dig:
	sta.b mulb
	lda.w #$000A
	sta.b mula
	dey
	jsl.l divu16
	lda.b mulres+2
	sep #$20
	adc.b #$30
	sta.w PushWidthBuf,y
	rep #$20
	lda.b mulres
	bne .dig
	rtl
