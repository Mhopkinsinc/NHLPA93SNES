PrintPerLabel:		;Print the label of the current period
	lda.w gsp
	sta.b d0
	lda.w #PerLabels
	sta.b a0
	lda.w #PerLabels>>16
	sta.b a0+2
.next:
	lda.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	dec.b d0
	bpl .next
	jml.l print
