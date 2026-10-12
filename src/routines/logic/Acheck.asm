Acheck:		;start hold (or hook if a0 is ahead) on player a0
		;   SNES: player X holds a0: pfalock, SPAhook, or SPAHold when he has impact and a0 is not ahead. With pfgoal clear the bmi tests the pfgoal load, so
		;   always SPAHold then
	ldy.b a0
	lda.w #SPAhook
	sta.b d1
	sta.w pfalock,x
	lda.w impact,x
	beq .set
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d0
	lda.w pfgoal,x
	beq .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.0:
	bmi .set
	lda.w #SPAHold
	sta.b d1
.set:
	jml.l SetSPA
