dopass:		;pass the puck in passdir, to the best teammate there if any.
		;   SNES: the team mate nearest the passdir lane (or passdir), puck velocity, SPA, pfalock
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
	lda.w seed+2
	and.w #$0003
	clc
	adc.w #$0098
	pha
	jsl.l sfx
	lda.w #$0004
	trb.w sflags
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0010
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	lda.w #$0007
	sta.b d0
	lda.w position,x
	beq .pa
	lda.w passacc,x
	sta.b d0
.pa:
	lda.b d0
	asl a
	asl a
	adc.w #$0090
	sta.w passspeed
	lda.w #$FFFF
	sta.b d4+2
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcc .0
	lda.w #$000C
	sta.b a1
.0:
	cpx.b a1
	bne .1
	jmp.w .next
.1:
	ldy.b a1
	lda.w position,y
	bne .2
	jmp.w .next
.2:
	lda.w pflags,y
	bit.w #$1000
	beq .3
	jmp.w .next
.3:
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	jsl.l vtoa
	pla
	sta.b d1
	pla
	sta.b d2
	lda.b d0
	sec
	sbc.w passdir
	and.w #$0007
	asl a
	asl a
	asl a
	asl a
	asl a
	and.w #$00FF
	bit.w #$0080
	beq .sx
	ora.w #$FF00
.sx:
	asl a
	asl a
	asl a
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	cmp.w #$0001
	lda.b mulres+2
	sta.b d0+2
	sbc.w #$0001
	bcs .next
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d1
	lda.b mulres+2
	sta.b d1+2
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d1
	sta.b d2
	lda.b mulres+2
	adc.b d1+2
	sta.b d2+2
	lda.b d2
	clc
	adc.b d0
	sta.b d2
	lda.b d2+2
	adc.b d0+2
	sta.b d2+2
	lda.b d4
	cmp.b d2
	lda.b d4+2
	sbc.b d2+2
	bcc .next
	lda.b d2
	sta.b d4
	lda.b d2+2
	sta.b d4+2
	lda.b a1
	sta.b a0
.next:
	inc.b a1
	inc.b a1
	dec.b d3
	bmi .done
	jmp.w .0
.done:
	lda.b d4+2
	bmi .nopp
	jsl.l passtoa0
	jmp.w .exit
.nopp:
	lda.w passdir
	asl a
	asl a
	adc.w #dirtab+2
	sta.b a0
	lda.w #dirtab>>16
	sta.b a0+2
	lda.b [a0]
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l muls32
	stz.b mulb
	lda.b mulres
	sta.b mulb+1
	lda.b mulres+2
	sta.b mulb+3
	asl.b mulb
	rol.b mulb+2
	asl.b mulb
	rol.b mulb+2
	lda.w #$0BB8
	sta.b mula
	jsl.l divs
	adc.w Yvel,x
	sta.w puckvy
	dec.b a0
	dec.b a0
	lda.b [a0]
	sta.b mulb
	lda.w passspeed
	sta.b mula
	jsl.l muls32
	stz.b mulb
	lda.b mulres
	sta.b mulb+1
	lda.b mulres+2
	sta.b mulb+3
	asl.b mulb
	rol.b mulb+2
	asl.b mulb
	rol.b mulb+2
	lda.w #$0BB8
	sta.b mula
	jsl.l divs
	adc.w Xvel,x
	sta.w puckvx
	lda.w #$1000
	jsl.l randoma
	sta.w puckvz
.exit:
	lda.w position,x
	bne .notgoalie
	lda.w pfgoal,x
	beq .g0
	lda.w puckvy
	bmi .nvy
	bra .notgoalie
.g0:
	lda.w puckvy
	bmi .notgoalie
.nvy:
	eor.w #$FFFF
	inc a
	sta.w puckvy
.notgoalie:
	lda.w puckvx
	sta.b d0
	lda.w puckvy
	sta.b d1
	jsl.l vtoa
	lda.w #$02D2
	sta.b d1
	lda.w position,x
	beq .e1
	lda.w #$06C4
	sta.b d1
	jsl.l Findhittype
	beq .e1
	lda.w #$0736
	sta.b d1
.e1:
	jsl.l SetSPA
	lda.w #$0001
	sta.w pfalock,x
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
	ldx.w #$0016
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
