sroot:		;Square Root, this returns (d0.L)^.5 in d0
		;   SNES: binary search only (tmp0 = low, tmp1 = high)
	stz.b tmp0
	lda.w #$1000
	sta.b tmp1
.bs:
	lda.b tmp0
	clc
	adc.b tmp1
	ror a
	cmp.b tmp0
	beq .done
	sta.b tmp2
	sta.b mula
	sta.b mulb
	jsl.l mulu		; mulres = mula*mulb
	lda.b d0
	cmp.b mulres
	lda.b d0+2
	sbc.b mulres+2
	bcs .lo
	lda.b tmp2
	sta.b tmp1
	bra .bs
.lo:
	lda.b tmp2
	sta.b tmp0
	bra .bs
.done:
	sta.b d0
	rtl
