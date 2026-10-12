TickerTeam:		;SNES: ticker line: team d0 name (TeamList record) and score d1, one row down
	lda.b $04,s
	sta.w printx
	inc.w printy
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	asl.b d0
	asl.b d0
	ldy.b d0
	lda.b [a1],y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #Teamname
	lda.b [a1],y
	adc.b a1
	sta.b a1
	jsl.l print
	lda.b $04,s
	clc
	adc.w #$0017
	sta.w printx
	lda.b d1
	sta.b d0
	jsl.l PushNumber
	jml.l print
