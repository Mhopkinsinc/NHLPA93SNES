checkagr:		;penalty roll for player a3. Range = (20 - byte $73) * 13, doubled for a joystick player, halved within $28 of the puck in x and y. Return d0 = randomd0 of that range; the callers
		;   call a penalty when it is small. Called from checkcheck .cc, holdcheck and Bcheck
		;   SNES: range = (20 - GGSleft,x) * 16 for player X (x2 joystick controlled, /2 near the puck): small values call a penalty
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
