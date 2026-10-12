skatetopuck:		;Player X skates to the puck, slowing down near it; may sweep check when the puck comes at him
	jsl.l skatetopuckinit		; d0/d1 = puck spot
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .aim
	jmp.w .ex
.aim:		;every 10 frames: aim at the puck (avoid the goal), maybe sweep check
	adc.w #$0009		; +10
	sta.w temp2,x
	jsl.l avdgoal
	lda.b d1
	pha
	lda.b d0
	pha
	txa
	jsl.l GetHot
	lda.b d0
	eor.w #$FFFF
	inc a
	sec
	sbc.w Xvel+1,x		; - high byte of Xvel
	and.w #$00FF
	bit.w #$0080
	beq .vx
	ora.w #$FF00
.vx:
	clc
	adc.b $01,s
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sec
	sbc.w Yvel+1,x		; - high byte of Yvel
	and.w #$00FF
	bit.w #$0080
	beq .vy
	ora.w #$FF00
.vy:
	clc
	adc.b $03,s
	sec
	sbc.w Ypos,x
	sta.b d1
	pla
	pla
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x		; temp2b = direction to the puck
	lda.w position,x
	beq .ex		; goalie skips the sweep check
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.b d0
	eor.w #$0004		; puck coming toward the player
	cmp.w facedir,x
	beq .ex
	lda.w pucky
	sec
	sbc.w Ypos,x
	sta.b d1
	pha
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	pha
	jsl.l vtoa
	lda.b d0
	sta.b tmp0
	pla
	sta.b d0
	sta.b mula
	sta.b mulb
	pla
	sta.b d1
	lda.w facedir,x
	cmp.b tmp0
	bne .ex
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
	cmp.w #$0385		; 30*30
	lda.b d0+2
	sbc.w #$0000
	bcc .ex
	lda.b d0
	cmp.w #$05A5		; 38*38
	lda.b d0+2
	sbc.w #$0000
	bcc Sweepcheck
.ex:
	lda.w temp2b,x
	sta.b d0
	lda.w position,x
	beq .acc
	lda.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #$0036		; close to the puck: slow down, Xvel*7/8, Yvel*7/16
	bcs .acc
	lda.w Xvel,x
	sta.b mula
	lda.w #$0007
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	sta.b mula
	lda.w #$0007
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Yvel,x
.acc:
	jml.l doplayeracc		; d0 = direction
