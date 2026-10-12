WeightedRandomSelect:		;d0 = number of word weights at nibblebuffer. Return d0 = random index, picked with those weights. Called from SetScore_getscore and UpdateTeamNameisplay
		;   SNES: d0 = random index 0..d0-1 weighted by the words in nibblebuffer
	lda.b d1+2
	pha
	lda.b d1
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #nibblebuffer
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	stz.b d1
	bra .next
.sum:
	lda.b d1
	clc
	adc.b [a1]
	sta.b d1
	inc.b a1
	inc.b a1
.next:
	dec.b d0
	bpl .sum
	lda.b d1
	sta.b d0
	jsl.l randomd0
.find:
	dec.b a1
	dec.b a1
	lda.b d0
	sec
	sbc.b [a1]
	sta.b d0
	bpl .find
	lda.b a1
	sec
	sbc.w #nibblebuffer
	lsr a
	sta.b d0
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b d1
	pla
	sta.b d1+2
	rtl
