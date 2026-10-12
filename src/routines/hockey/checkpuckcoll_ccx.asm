checkpuckcoll_ccx:		;d4 = object index: stick (puckstick), body (puckbody) or goalie (puckgoalie) contact
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .save
	ldx.b xsave
	lda.b d4		; a2 = object
	sta.b a2
	tay
	lsr a
	cmp.w puckc
	bne .pl
	jmp.w .exit
.pl:
	cmp.w #$000C		; not a player
	bcc .nc
	jmp.w .exit
.nc:
	lda.w pfnc,y		; no collision or nopuck
	ora.w nopuck,y
	beq .unav
	jmp.w .exit
.unav:
	lda.w pflags,y
	bit.w #pf2unav		; pf2unav: body only
	beq .z
	jmp.w .chkbody
.z:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0005		; puck above 5
	beq .zv
	bmi .neg
	bvs .zv
.body1:
	jmp.w .chkbody
.neg:
	bvs .body1
.zv:
	lda.w puckvz
	sec
	sbc.w #$0100		; puckvz > $100
	beq .stick
	bmi .neg1
	bvs .stick
.body2:
	jmp.w .chkbody
.neg1:
	bvs .body2
.stick:
	tya
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .sx
	eor.w #$FFFF
	inc a
.sx:
	cmp.w #$000F		; stick: within 14
	bcs .chkbody
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .sy
	eor.w #$FFFF
	inc a
.sy:
	cmp.w #$000F
	bcs .chkbody
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.w #$00C4		; cstick^2 ($C4), /4 if the puck is not ready to be caught
	sta.b d1
	lda.w nopuck+puckobj
	bmi .lo
	beq .lo
	lsr.b d1
	lsr.b d1
.lo:
	lda.b d1
	cmp.b d0
	lda.w #$0000
	sbc.b d0+2
	bcc .chkbody
	jsl.l puckstick
	bra .exit
.chkbody:
	lda.w position,y
	beq .chkgoalie
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .bx
	eor.w #$FFFF
	inc a
.bx:
	cmp.w #$0009		; body: within 8
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .by
	eor.w #$FFFF
	inc a
.by:
	cmp.w #$0009
	bcs .exit
	lda.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0
	cmp.w #$0041		; cbody^2
	lda.b d0+2
	sbc.w #$0000
	bcs .exit
	jsl.l puckbody
.exit:
	stx.b xsave
	ldx.w #$001A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.chkgoalie:
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	bit.w #$8000
	beq .gx
	eor.w #$FFFF
	inc a
.gx:
	cmp.w #$000D		; goalie: within 12
	bcs .exit
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	bit.w #$8000
	beq .gy
	eor.w #$FFFF
	inc a
.gy:
	cmp.w #$000D
	bcs .exit
	jsl.l puckgoalie
	bra .exit
