ClampYPosition:		;d1 = y kept inside the goal lines, measured from goal line d3. d0 = 0 if X has the puck
	lda.w puckc
	sta.b d2
	cmp.w SCnum,x
	bne .0
	stz.b d0
.0:
	lda.b d1
	sec
	sbc.w #$0103
	bmi .neg
	bvc .hi
	bra .one
.neg:
	bvc .one
.hi:
	lda.w #$0103
	sta.b d1
.one:
	lda.b d1
	sec
	sbc.w #$FEFD
	beq .lo
	bmi .neg1
	bvs .lo
	bra .two
.neg1:
	bvs .two
.lo:
	lda.w #$FEFD
	sta.b d1
.two:
	lda.b d1
	sec
	sbc.b d3
	sta.b d1
	rtl
