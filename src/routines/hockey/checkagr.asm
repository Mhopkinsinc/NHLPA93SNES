checkagr:		;Penalty roll for player X: small results call a penalty. Joystick players are judged less often, players
		;   near the puck more often
	lda.w #$0014
	sec
	sbc.w GGSleft,x
	asl a
	asl a
	asl a
	asl a
	sta.b d0
	lda.w pflags,x
	bit.w #$0008
	beq .nojoy
	asl.b d0
.nojoy:
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .xpos
	eor.w #$FFFF
	inc a
.xpos:
	cmp.w #$0029
	bcs .far
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .ypos
	eor.w #$FFFF
	inc a
.ypos:
	cmp.w #$0029
	bcs .far
	lsr.b d0
.far:
	jml.l randomd0
