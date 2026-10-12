CalcAngleOffset:		;d4 = cross product of goalie vector d0/d1 and post vector
		;   SNES: d4 = (goalie vector d0/d1 x post vector d3/d4 from the puck) / d2
	lda.b d3
	sec
	sbc.w puckx
	sta.b d3
	lda.b d4
	sec
	sbc.w pucky
	sta.b mulb
	lda.b d0
	sta.b mula
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.b d1
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b d4
	sec
	sbc.b d3
	sta.b mulb
	lda.b d4+2
	sbc.b d3+2
	sta.b mulb+2
	lda.b d2
	sta.b mula
	jsl.l divs
	sta.b d4
	rtl
