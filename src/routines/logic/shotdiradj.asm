shotdiradj:		;If the opposing goalie covers the middle of the net, set passdir 2 or 6 to shoot at the open side, else 0. Skipped for joystick players (pfjoycon set)
	lda.w pflags,x		; joystick player: skip
	bit.w #pfjoycon
	beq .go
	jmp.w .rtl
.go:
	lda.w #$0008
	sta.b d0
	lda.w #$0005
	sta.b d1
	lda.w #$FFFE
	sta.b a0
	lda.w pfteam,x
	bne .g
	lda.w #$000A
	sta.b a0
.g:		;find position 0 on the other team
	inc.b a0
	inc.b a0
	ldy.b a0
	lda.w position,y
	beq .found
	dec.b d1
	bpl .g
	jmp.w .x
.found:		;goalie x/y + half his velocity - puck; d2 = distance
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gx
	ora.w #$FF00
.gx:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .gy
	ora.w #$FF00
.gy:
	pha
	asl a
	pla
	ror a
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.b d0
	pha
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
	sec
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot
	lda.b d0
	sta.b d2
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w #$0012		; d3/d4 = post x/goal y
	sta.b d3
	lda.w #$0108
	sta.b d4
	lda.w pfgoal,x
	bne .l
	lda.w #$FEF8
	sta.b d4
.l:		;posts at x +-18, y +-$108
	lda.b d4
	pha
	lda.b d3
	pha
	jsl.l CalcAngleOffset
	lda.b d4
	sta.b d5
	pla
	eor.w #$FFFF
	inc a
	sta.b d3
	pla
	sta.b d4
	jsl.l CalcAngleOffset
	lda.b d4
	clc
	adc.b d5
	sta.b d4
	stz.b d0
	lda.b d4
	bit.w #$8000
	beq .abs
	eor.w #$FFFF
	inc a
.abs:
	cmp.w #$002D		; |angle| < 45: shoot at the open side
	bcs .x
	lda.w pfgoal,x
	beq .s
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
.s:
	lda.w #$0002
	sta.b d0
	lda.b d4
	bpl .x
	lda.w #$0006
	sta.b d0
.x:
	lda.b d0
	sta.w passdir
.rtl:
	rtl
