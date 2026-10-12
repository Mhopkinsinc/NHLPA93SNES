PushTime:		;convert d0 into string format of minutes:seconds. Return a1 = string. 93 pads the minutes to 2 places with a space
		;   SNES: mesarea string m:ss of the time d0 (seconds)
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
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
	lda.w #$0006
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	dec.b a1
	lda.b #$3A
	sta.b [a1]
	rep #$30
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
	beq .noz
	dec.b a1
	sep #$20
	adc.b #$30
	sta.b [a1]
	rep #$30
.noz:
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
