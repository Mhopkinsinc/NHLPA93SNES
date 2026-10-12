CwdFight:		;crowd reacts to a punch; push the hit player X back by the puncher (a0) strength
	ldy.b a0
	lda.b crowdlevel
	clc
	adc.w #$0050		; +80
	sta.b crowdlevel
	lda.w #$0005		; (5 + puncher strength) * 500
	clc
	adc.w temp3,y
	sta.b mulb
	lda.w #$01F4
	sta.b mula
	jsl.l mulu16		; mulu, mulres = mula*mulb
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002		; push the other way when facing right
	bne .xveladj
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.xveladj:
	lda.w Xvel,x
	clc
	adc.b d0
	sta.w Xvel,x
	rtl
