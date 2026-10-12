ChkOffsides:		;check for offsides penalty. a3 = puck. Flags the whole team (tmflags bit 4; 92 flagged each player). Called from pucknorm
		;   SNES: flag a team offsides when the puck crosses its blue line. Called from pucknorm
	lda.w gmode
	bit.w #gmoffs
	beq .rtl
	stz.b a1		; a1 = home, a2 = away; then swapped
	lda.w #$0002
	sta.b a2
	jsl.l ClearOffsidesIfAllPlayers
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l ClearOffsidesIfAllPlayers
	lda.w #blueline-4		; blueline-4
	sta.b d0
	sec
	sbc.w pucky
	beq .top
	bmi .v1
	bvs .top
	bra .neg
.v1:
	bvs .neg
.top:		;puck crossed the top line this frame?
	lda.w #blueline-4
	sec
	sbc.w OldYpos+puckobj
	beq .rtl
	bmi .v2
	bvc .t
	bra .rtl
.v2:
	bvc .rtl
.t:
	lda.w #blueline-4+$A		; +$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir		; gmdir
	beq .t0
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t0:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.0:
	ldy.b a0
	lda.w position,y
	bmi .1
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .v3
	bvs .set0
	bra .1
.v3:
	bvs .1
.set0:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside		; tmfoffside
	sta.w tmflags,y
.rtl:
	rtl
.1:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .0
	rtl
.neg:		;bottom line
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	sec
	sbc.w pucky
	bmi .v4
	bvc .b1
	bra .rtl
.v4:
	bvc .rtl
.b1:
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi .v5
	bvs .b2
	bra .rtl
.v5:
	bvs .rtl
.b2:
	lda.b d0
	sec
	sbc.w #$000A		; -$A
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	bne .t1
	lda.b a2
	ldy.b a1
	sta.b a1
	sty.b a2
.t1:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.2:
	ldy.b a0
	lda.w position,y
	bmi .3
	lda.b d0
	sec
	sbc.w Ypos,y
	beq .3
	bmi .v6
	bvc .set2
	bra .3
.v6:
	bvc .3
.set2:
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoffside
	sta.w tmflags,y
	rtl
.3:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .2
	rtl
