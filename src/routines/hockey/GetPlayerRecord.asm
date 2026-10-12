GetPlayerRecord:		;a0 = the roster record of player d0 of team a2
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	ldy.w #Playerdata
	clc
	adc.b [a0]
	sta.b a0
	bra .cnt
.next:
	lda.b a0
	clc
	adc.b [a0]
	adc.w #$0008
	sta.b a0
.cnt:
	dec.b d0
	bpl .next
	rtl
