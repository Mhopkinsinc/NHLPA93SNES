skateto:		;Skate toward d0 / d1, with a routine in a0 for avoiding others; slow down near the target
	lda.w position,x
	beq .tick
	lda.w pflags,x
	and.w #$8000
	ora.w sfhormode
	bne .tick
	lda.b d0
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0088
	bcs .tick
	lda.w Xpos,x
	sec
	sbc.b d0
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b tmp0
	lda.w Ypos,x
	sec
	sbc.b d1
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	clc
	adc.b tmp0
	cmp.w #55
	bcs .tick
	lda.w Xvel,x
	sta.b mula
	lda.w #7
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
	lda.w #7
	sta.b mulb
	jsl.l muls32
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	lsr.b mulres+2
	ror a
	sta.w Yvel,x
.tick:		;every 12/60 second
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .go
	jmp.w .ex
.go:
	adc.w #11
	sta.w temp2,x
	jsl.l avdgoal
	lda.w #13
	sta.b d0+2
	lda.b d0
	bit.w #$8000
	beq .near
	eor.w #$FFFF
	inc a
.near:
	cmp.w #$0088
	bcs .av
	lda.w #18
	sta.b d0+2
.av:
	lda.b deltax
	ora.b deltay
	beq .lead
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	bra .vt
.lead:		;aim ahead of the velocity
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .lx
	ora.w #$FF00
.lx:
	eor.w #$FFFF
	inc a
	clc
	adc.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Yvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .ly
	ora.w #$FF00
.ly:
	eor.w #$FFFF
	inc a
	clc
	adc.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	lda.b d0
	bit.w #$8000
	beq .cx
	eor.w #$FFFF
	inc a
.cx:
	cmp.b d0+2
	bcs .vt
	lda.b d1
	bit.w #$8000
	beq .cy
	eor.w #$FFFF
	inc a
.cy:
	cmp.b d0+2
	bcs .vt
	lda.w #9
	sta.b d0
	bra .nvt
.vt:
	jsl.l vtoa
.nvt:		;jsr (a0) through jmlvector
	lda.b a0
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector
	lda.b d0
	sta.w temp2b,x
	cmp.w #8
	bcc .ex
	lda.w Xvel,x
	ora.w Yvel,x
	bne .ex
	lda.w puckx
	sta.b d0
	lda.w pucky
	sta.b d1
	lda.w pf2fight+puckobj
	beq .nf
	lda.w xc1
	sta.b d0
	lda.w yc1
	sta.b d1
.nf:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	sec
	sbc.w Ypos,x
	sta.b d1
	jsl.l vtoa
	sec
	sbc.w facedir,x
	beq .ex
	eor.w #$FFFF
	inc a
	and.w #$0004
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.w facedir,x
.ex:
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc
unusedFF88:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
