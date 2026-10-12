PushNumber:		;a1 = d0 as a decimal string, no leading zeros
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
.0:
	sta.b mulb
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b mulres
	bne .0
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
