checkcx:		;d4 = obj. # * 2 for possible coll so check x range and distance for coll. d2 = x, d5 = delta y, a3 = moving object. Opposing players add impact and run newcheck, checkint
		;   checkcheck and checkfight; then momentum moves from a3 to a2. Called from checkplcoll
		;   SNES: Y = object near X. Opposing players add impact and run newcheck, checkint, checkcheck and checkfight; then momentum moves from X to a2
		;   (weights + 140, elasticity evalue)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .save
	ldx.b xsave
	sty.b a2		; a2 = Y; d0/d1 = relative velocity, d2/d3 = relative position
	stz.b evalue
	lda.w Xvel,x
	sec
	sbc.w Xvel,y
	sta.b d0
	lda.w Yvel,x
	sec
	sbc.w Yvel,y
	sta.b d1
	sta.b mulb
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d2
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d3
	sta.b mula
	lda.b d1
	pha
	lda.b d0
	pha
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d2
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	adc.b d1
	sta.b d1
	lda.b d1+2
	adc.b mulres+2
	bpl .v1n		; v1n < 0: no collision
	jmp.w .exit4
.v1n:		;V1n = (Vy*Dy + Vx*Dx) / 16
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lsr a
	ror.b d1
	lda.w pfteam,x		; same team: no impact
	cmp.w pfteam,y
	beq .not
	lda.b d1+1
	and.w #$00FF
	sta.b d4
	cmp.w #$0006
	bcs .g40
	lda.w #$0005
	sta.b d4
.g40:		;minimum impact 5
	clc
	adc.w impact,x
	sta.w impact,x
	lda.w impact,y
	clc
	adc.b d4
	sta.w impact,y
	lda.w pf2fight,y		; impactp = the other (not while fighting)
	bne .if
	txa
	lsr a
	sta.w impactp,y
.if:
	lda.w pf2fight,x
	bne .if2
	tya
	lsr a
	sta.w impactp,x
.if2:		;impact under 20: no check sound
	lda.b d4
	cmp.w #$0014
	bcc .n1
	lda.w puckc		; check sound only if one of them has the puck
	cmp.w SCnum,x
	beq .nc
	cmp.w SCnum,y
	bne .n1
.nc:
	jsl.l newcheck
.n1:
	jsl.l checkint
	jsl.l checkcheck
	jsl.l checkfight
.not:		;same team: no check events
	lda.b d1
	sta.b d4
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b collflag		; collflag set by holdcheck / Bcheck: no transfer
	bpl .tr
	jmp.w .exit
.tr:		;V1t = (Vx*Dy - Vy*Dx) / 16
	lda.b d2
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d3
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b d1
	sta.b d0
	lda.b mulres+2
	sbc.b d1+2
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lsr a
	ror.b d0
	lda.b d0
	sta.b d5
	lda.w weight,x		; weights + 140
	clc
	adc.w #$008C
	sta.b d0
	ldy.b a2
	lda.w weight,y
	clc
	adc.w #$008C
	sta.b d1
	sta.b mula
	lda.b evalue
	sta.b mulb
	jsl.l mulu16		; mulu, A = mula*mulb
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d7+2
	lda.b d1
	clc
	adc.b d0
	sta.b d1
	lda.b d0
	sec
	sbc.b d7+2
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls32
	lda.b d1
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.b evalue
	sta.b mulb
	lda.b d4
	sta.b mula
	jsl.l muls16
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .v2n
	ora.w #$F000
.v2n:		;V2n = V1n + V1n*e
	clc
	adc.b d0
	sta.b d1
	lda.b d5
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b tmp0
	sta.b tmp0
	lda.b tmp1
	adc.b mulres+2
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Xvel,y
	clc
	adc.b tmp0
	sta.w Xvel,x
	lda.b d5
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d0
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sec
	sbc.b tmp0
	sta.b tmp0
	lda.b mulres+2
	sbc.b tmp1
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lsr a
	ror.b tmp0
	lda.w Yvel,y
	clc
	adc.b tmp0
	sta.w Yvel,x
	lda.b d1
	sta.b mula
	lda.b d2
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
	clc
	adc.w Xvel,y
	sta.w Xvel,y
	lda.b d1
	sta.b mula
	lda.b d3
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
	clc
	adc.w Yvel,y
	sta.w Yvel,y
	lda.w #$FFFF		; collflag
	sta.b collflag
.exit:
	stx.b xsave
	ldx.w #$0016
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.exit4:		;drop the saved Vx/Vy
	pla
	pla
	bra .exit
