chkatop:		;attack time of possession stat update. Called once a second from updatepentime
		;   SNES: tmATOP +1 for the team with the puck past the blue line ($58)
	stz.b d1
	lda.w pucky
	sec
	sbc.w #$0058
	beq .lo
	bmi .v1
	bvs .lo
	bra .1
.v1:
	bvs .1
.lo:
	inc.b d1
	inc.b d1
	lda.w pucky
	sec
	sbc.w #$FFA8
	bmi .v2
	bvs .1
	bra .rtl
.v2:
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
