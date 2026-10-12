CPgoalie:		;see if computer should pull his goalie. d1 = puck/faceoff y. Falls in from ReturnGoalies; also entered from ChkGoalies
		;   SNES: should the computer pull its goalie? d1 = puck/faceoff y. 3rd period, behind by 2, under a minute
	lda.w gsp		; 3rd period only
	cmp.w #$0002
	bne .rtl
	ldy.b a1
	lda.w tmscore,y
	ldy.b a2
	sec
	sbc.w tmscore,y
	sta.b d0
	bmi .rtl
	cmp.w #$0002		; behind by exactly 2
	bne .rtl
	lda.w gameclock
	cmp.w #$003D		; 60 seconds or less
	bcs .rtl
	lda.w tmsort,y
	tay
	lda.w pfgoal,y		; own half of the faceoff/puck
	bne .0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.0:
	lda.b d1
	bmi .rtl
	ldy.b a2
	lda.w tmgoalie,y
	ora.w #$FF00		; pull the goalie
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl
