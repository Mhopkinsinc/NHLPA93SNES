linebar:		;draw the energy bar of line d0 for team a2 at printx/printy (bitmap from the bar map, 16 steps). Called from SetLCmode2
		;   SNES: energy bar of line d0 (getlinee) as 5 small font characters
	jsl.l getlinee
	lda.w printa
	pha
	lda.w #$3000
	sta.w printa
	lda.b d0
	cmp.w #$1000
	bcc .max
	lda.w #$1000
.max:
	sta.b d0
	sta.b mula
	lda.w #$002F
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	adc.w #$001D
	sta.w mesarea+2
	sta.w mesarea+3
	sta.w mesarea+4
	sta.w mesarea+5
	sta.w mesarea+6
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
	sta.b mula
	lda.w #$0054
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	inc a
	inc a
	sta.b [a1]
	jsl.l print
	pla
	sta.w printa
	rtl
