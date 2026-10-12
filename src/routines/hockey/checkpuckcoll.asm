checkpuckcoll:		;look for puck coll with players. a3 = puck. Entered from pucknorm
		;   SNES: puck collision with the players within 22 in y (OOlist up and down from the puck)
	lda.w Zpos+puckobj		; puck feet in the air (Zpos > 16): no collision
	sec
	sbc.w #$0010
	beq .setup
	bmi .neg
	bvs .setup
	bra .rtl
.neg:
	bvs .rtl
.setup:
	lda.w OOlistpos+puckobj		; Y = puck position in OOlist
	sta.b d1
.up:
	ldy.b d1
	cpy.w #$000F		; top object
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.w pucky
	sec
	sbc.w #$0016		; next higher object within 22 in y
	beq .cc1
	bmi .neg1
	bvs .cc1
	bra .cl
.neg1:
	bvs .cl
.cc1:
	jsl.l checkpuckcoll_ccx
	inc.b d1
	bra .up
.cl:
	lda.w OOlistpos+puckobj
	beq .rtl
	sta.b d1
.dn:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w pucky
	sec
	sbc.w Ylist,y
	sec
	sbc.w #$0016
	beq .cc2
	bmi .neg2
	bvs .cc2
	bra .rtl
.neg2:
	bvs .rtl
.cc2:
	jsl.l checkpuckcoll_ccx
	dec.b d1
	bne .dn
.rtl:
	rtl
