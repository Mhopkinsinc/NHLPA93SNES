CheckBump:		;Goalie X pushed against the net with the puck near: if he is moving fast, bump the net, stop him and
		;   call a goalie holding penalty
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.w seed		; 1 in 32 frames
	and.w #$001F
	bne .ex
	ldy.b a2
	lda.w pucky		; puck within 41 of the net in y
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0029
	bcs .ex
	lda.w Xvel,x
	sta.b d0
	lda.w Yvel,x
	sta.b d1
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	cmp.w #$2001
	bcs .bb
	lda.b d0
	bit.w #$8000
	beq .vx
	eor.w #$FFFF
	inc a
.vx:
	cmp.w #$2001
	bcs .bb
.ex:
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
.bb:		;drop the saved d0-d3 and the jsl return: return to the caller of checkgoalp
	pla
	pla
	pla
	pla
	pla
	sep #$20
	pla
	rep #$30
	lda.b d0		; net Xvel/Yvel = speed / 4; player stops
	lsr a
	lsr a
	bit.w #$2000
	beq .sx
	ora.w #$C000
.sx:
	sta.b d0
	ldy.b a2
	sta.w Xvel,y
	lda.b d1
	lsr a
	lsr a
	bit.w #$2000
	beq .sy
	ora.w #$C000
.sy:
	sta.b d1
	sta.w Yvel,y
	stz.w Xvel,x
	stz.w Yvel,x
	lda.w #sfslock
	tsb.w sflags
	lda.w gmclock
	bne .rtl
	lda.w #PenGhold
	sta.b d0
	jmp.w AddPenalty2
