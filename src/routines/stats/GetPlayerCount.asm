GetPlayerCount:		;d0 = the number of players on team a2's roster
	lda.b a0+2		; save a0
	pha
	lda.b a0
	pha
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.w #Playerdata
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.b d0
.count:
	inc.b d0
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	lda.b [a0]
	cmp.w #$0002
	bne .count
	pla
	sta.b a0
	pla
	sta.b a0+2
	rtl
