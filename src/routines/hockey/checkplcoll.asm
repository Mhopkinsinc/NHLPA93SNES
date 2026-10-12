checkplcoll:		;d2/d3 = x/y cords, a3 = struct. Walk up and down the OOlist from a3 and call checkcx for each object within $10 in y. Called from checkcoll
		;   SNES: d2/d3 = x/y, X = object. Walk up and down the OOlist from X and call checkcx for each object within 14 in y
	lda.w pflags,x
	bit.w #pf2npc
	beq .pl
	jmp.w .ex
.pl:
	cpx.w #$0018
	bcc .go
	jmp.w .ex
.go:
	lda.w OOlistpos,x		; d1 = position of X in OOlist
	sta.b d1
.0:		;objects higher in the list
	ldy.b d1
	cpy.w #$000F		; top of the list
	beq .cl
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.w Ylist,y
	sec
	sbc.b d3
	sta.b d5
	sec
	sbc.w #$000E
	beq .uy
	bmi .neg
	bvs .uy
	bra .cl
.neg:
	bvs .cl
.uy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ux
	eor.w #$FFFF
	inc a
.ux:
	cmp.w #$000F
	bcs .unext
	lda.w pflags,y		; not npc, nc, players only
	and.w #pf2npc
	ora.w pfnc,y
	bne .unext
	cpy.w #$0018
	bcs .unext
	jsl.l checkcx
.unext:
	inc.b d1
	bra .0
.cl:		;objects lower in the list
	lda.w OOlistpos,x
	beq .ex
	sta.b d1
.1:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	sta.b d5
	sec
	sbc.w #$000E
	beq .dy
	bmi .neg1
	bvs .dy
	bra .ex
.neg1:
	bvs .ex
.dy:
	lda.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$000F
	bcs .dnext
	lda.w pflags,y
	and.w #pf2npc
	ora.w pfnc,y
	bne .dnext
	cpy.w #$0018
	bcs .dnext
	jsl.l checkcx
.dnext:
	dec.b d1
	bne .1
.ex:
	rtl
