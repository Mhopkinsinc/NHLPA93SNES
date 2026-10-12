CPgoalie:		;Should the computer pull its goalie? In the last minute of the third period when behind by two and the play
		;   is in its attacking half. d1 = puck or face off y
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
