PutDigits2:		;Write the two digit number d0 as two characters at [a1], blank leading zero
	lda.w #$2020		; blank, then the tens digit when d0 >= 10
	sta.b tmp0
	lda.b d0
	and.w #$00FF
	cmp.w #$000A
	bcc .ones
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.w #$0030
	sta.b tmp0
.ones:
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
