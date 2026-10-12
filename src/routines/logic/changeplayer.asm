changeplayer:		;Switch controller d4 to the teammate nearest the puck, or sweep check if that is already the player
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
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.w puckvy		; puck + velocity/256 (lead the puck)
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	clc
	adc.w pucky
	pha
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	clc
	adc.w puckx
	pha
	lda.w #$0005
	sta.b d2
	lda.b d4
	tay
	eor.w #$0002		; d3 = the other controller
	sta.b d3
	lda.w #$FFFF		; d5 = best distance^2
	sta.b d5+2
	ldx.w #$0000
	lda.w cont1team,y		; controller on the home team: players 0-5, else 6-11
	cmp.w #$0001
	beq .t1
	ldx.w #$000C
.t1:
	ldy.b d3
.top:
	lda.w position,x
	bmi .next
	beq .next
	lda.w pflags,x		; pf2unav or pfalock: skip
	and.w #$1000
	ora.w pfalock,x
	bne .next
	lda.b $01,s
	sec
	sbc.w Xpos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sec
	sbc.w Ypos,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	lda.b d5
	cmp.b d0
	lda.b d5+2
	sbc.b d0+2
	bcc .next
	txa
	lsr a
	cmp.w c1playernum,y		; the other controller has him
	beq .next
	sta.b d6
	lda.b d0
	sta.b d5
	lda.b d0+2
	sta.b d5+2
.next:
	inx
	inx
	dec.b d2
	bpl .top
	ldx.b a3
	pla
	pla
	ldy.b d4
	lda.b d6
	cmp.w c1playernum,y		; same player: Sweepcheck
	bne .set
	jsl.l Sweepcheck
	bra .ex
.set:
	sta.b d0
	lda.b d4
	bne .c2
	jsl.l setc1player
	bra .ex
.c2:
	jsl.l setc2player
.ex:
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
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
