GoalieCount:		;d0 = the number of goalies on team a2
	lda.b a2
	tay
	and.w #$FFFD
.hang:
	bne .hang
	lda.w #TeamList>>16
	sta.b tmp1
	lda.w tmdata,y
	sta.b tmp0
	ldy.w #ScoreOdds
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0
	lda.b [tmp0]
	xba
.cnt:
	inc.b d0
	asl a
	asl a
	asl a
	asl a
	bne .cnt
	rtl
