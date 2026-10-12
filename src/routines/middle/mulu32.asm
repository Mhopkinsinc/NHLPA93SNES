mulu32:		;Unsigned 32-bit multiply: mulres = mula * mulb
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	sta.b mulres
	stz.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c1
	inc.b mulres+3
.c1:
	lda.b mulb+2
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+3
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c2
	inc.b mulres+3
.c2:
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+2
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+2
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+3
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	rep #$30
	lda.b mulres
	clc
	rtl
