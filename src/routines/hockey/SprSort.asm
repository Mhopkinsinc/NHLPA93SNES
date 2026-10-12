SprSort:		;Sort the objects by screen position for drawing
	phx
	phy
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	ldx.w #$0000
	lda.w sfhormode		; horizontal mode sorts by x
	bne .xlist
.loop0:
	lda.w Ypos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .loop0
	bra .loop
.xlist:
	lda.w Xpos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .xlist
.loop:
	stz.b d2
	ldx.w #$0000
.0:
	lda.w OOlist+1,x
	and.w #$00FF
	sta.b d1
	lda.w OOlist,x
	and.w #$00FF
	sta.b d0
	tay
	lda.w Ylist,y
	ldy.b d1
	sec
	sbc.w Ylist,y
	beq .1
	bmi .neg
	bvc .swap
	bra .1
.neg:
	bvc .1
.swap:
	lda.w OOlist,x
	xba
	sta.w OOlist,x
	txa
	sta.w OOlistpos,y
	inc a
	ldy.b d0
	sta.w OOlistpos,y
	inc.b d2
.1:
	inx
	cpx.w #$000F
	bne .0
	lda.b d2		; swapped: sort again
	bne .loop
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ply
	plx
	rtl
