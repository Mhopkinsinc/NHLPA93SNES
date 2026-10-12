passtoa0:		;pass puck to player a0
		;   SNES: pass the puck from player a3 to player a0 (no pass count on the SNES): lead him by his velocity, solve the travel time d2
		;   (sroot, divs16; 1-$18), then puckvz, the puck temp1/nopuck, the target temp3/temp4, puckvx/puckvy
	jsl.l loadTeamStruct
	lda.b a0
	lsr a
	sta.w passReceiverPlayerNum
	lda.w passspeed
	lsr a
	lsr a
	bit.w #$2000
	beq .sx
	ora.w #$C000
.sx:
	sta.b d5
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
.skip:
	lda.w #$0013
	sta.b d0
	jsl.l assinsert
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	tya
	jsl.l GetHot
	ldy.b a0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lsr a
	lsr a
	bit.w #$2000
	beq .sy
	ora.w #$C000
.sy:
	sta.b d3
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	lsr a
	lsr a
	bit.w #$2000
	beq .sx2
	ora.w #$C000
.sx2:
	sta.b d2
	lda.w Yvel,y
	sta.b mulb
	lda.w #$00F0
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	sta.b d1
	pha
	lda.w Xvel,y
	sta.b mulb
	lda.w #$00F0
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	sta.b d0
	pha
	sta.b mulb
	lda.b d2
	sta.b mula
	jsl.l muls16
	sta.b d0
	lda.b d3
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls16
	adc.b d0
	asl a
	sta.b d4
	lda.b $01,s
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d0
	lda.b $03,s
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d1
	lda.b d5
	sta.b mula
	eor.w #$FFFF
	inc a
	sta.b mulb
	jsl.l muls16
	adc.b d0
	clc
	adc.b d1
	sta.b d5
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls16
	sta.b d2
	lda.b d3
	sta.b mula
	sta.b mulb
	jsl.l muls16
	adc.b d2
	sta.b mulb
	lda.b d5
	sta.b mula
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	asl.b d3
	rol.b d3+2
	asl.b d3
	rol.b d3+2
	lda.b d4
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b d3
	sta.b d0
	lda.b mulres+2
	sbc.b d3+2
	sta.b d0+2
	jsl.l sroot
	lda.w #$0001
	sta.b d3
	lda.b d5
	lsr a
	lsr a
	bit.w #$2000
	beq .sx3
	ora.w #$C000
.sx3:
	sta.b d5
	lda.b d5
	bne .0
	lda.w #$0001
	sta.b d5
.0:
	lda.b d0
	sta.b d2
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d2
	sec
	sbc.b d4
	sta.b mulb
	lda.b d5
	sta.b mula
	jsl.l divs16
	sta.b d2
	bpl .pos
	dec.b d3
	bpl .0
.pos:
	bne .1
	inc.b d2
.1:
	lda.b d2
	cmp.w #$0019
	bcc .2
	lda.w #$0018
	sta.b d2
.2:
	lda.b d2
	sep #$20
	sta.w puckvz+1
	rep #$30
	cmp.w #$000C
	bcc .3
	sep #$20
	lda.b #$0C
	sta.w puckvz+1
	rep #$30
.3:
	ldy.b a0
	lda.b d2
	asl a
	asl a
	asl a
	sec
	sbc.w #$000A
	sta.w temp1,y
	sec
	sbc.w #$0006
	sta.w nopuck+puckobj
	pla
	sta.b d0
	sta.b mulb
	pla
	sta.b d1
	lda.b d2
	sta.b mula
	jsl.l muls32
	lda.b mulres+2
	lsr a
	lda.b mulres
	ror a
	sta.b d0
	lda.b mulres+2
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	pla
	clc
	adc.b d0
	sta.b d0
	clc
	adc.w puckx
	ldy.b a0
	sta.w temp3,y
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b mulres+2
	lsr a
	lda.b mulres
	ror a
	sta.b d1
	lda.b mulres+2
	pha
	asl a
	pla
	ror a
	sta.b d1+2
	pla
	clc
	adc.b d1
	sta.b d1
	clc
	adc.w pucky
	ldy.b a0
	sta.w temp4,y
	lda.w #$0078
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l mulu16
	sta.b d2
	sta.b mula
	lda.b d0
	sta.b mulb+2
	lda.b d0+2
	sta.b mulb
	jsl.l divs
	sta.b d0
	sta.w puckvx
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb+2
	lda.b d1+2
	sta.b mulb
	jsl.l divs
	sta.b d1
	sta.w puckvy
	rtl
