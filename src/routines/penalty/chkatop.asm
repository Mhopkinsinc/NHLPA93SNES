chkatop:		;attack time of possession stat update. Called once a second from updatepentime
		;   SNES: tmATOP +1 for the team with the puck past the blue line ($58)
	stz.b d1
	lda.w pucky
	sec
	sbc.w #$0058
	beq .lo
	bmi .neg
	bvs .lo
	bra .1
.neg:
	bvs .1
.lo:
	inc.b d1
	inc.b d1
	lda.w pucky
	sec
	sbc.w #$FFA8
	bmi .neg1
	bvs .1
	bra .rtl
.neg1:
	bvs .rtl
.1:
	lda.w gmode		; gmdir: swap the teams
	bit.w #gmdir
	beq .0
	lda.b d1
	eor.w #$0002
	sta.b d1
.0:
	ldy.b d1
	lda.w tmATOP,y
	inc a
	sta.w tmATOP,y
.rtl:
	rtl
