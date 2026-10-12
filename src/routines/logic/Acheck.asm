Acheck:		;Player X holds or hooks player a0
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
