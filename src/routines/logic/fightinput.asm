fightinput:		;controller processing for fighting
		;   SNES: pad input in a fight: dpad moves (playeracc), stay near the fight spot (xc1), B/A/Y punch (SPA $F82/$F50/$F0C)
	lda.w temp3,x
	ora.w Pencntdwn
	bpl .go
	jmp.w .rtl
.go:
	lda.w SPA,x
	cmp.w #$0EDA
	bne .input
	jmp.w .rtl
.input:
	lda.b d1
	pha
	lda.b d0
	sta.b d2
	bit.w #$0008
	bne .noa
	and.w #$0007
	sta.b d2
	jsl.l playeracc
.noa:
	lda.w xc1
	clc
	adc.w #$000C
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .0
	lda.b d0
	sec
	sbc.w #$0018
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Xvel,x
	eor.b d0
	sta.b d1
	bpl .ind
	lda.b d0
	bit.w #$8000
	beq .1
	eor.w #$FFFF
	inc a
.1:
	sta.b d0
	lda.w Xvel,x
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32
	lda.w #$0006
	sta.b mula
	jsl.l divs
	sta.b d0
	lda.w Xvel,x
	sec
	sbc.b d0
	sta.w Xvel,x
.ind:
	pla
	sta.b d1
	lda.w pf2aip,x
	bne .rtl
	lda.b d1
	sta.b d2
	lda.w #$0F50
	sta.b d1
	sta.w pf2aip,x
	lda.b d2
	bit.w #$0080
	beq .p2
	jml.l SetSPA
.p2:
	lda.w #$0F82
	sta.b d1
	lda.b d2
	bit.w #$8000
	beq .p3
	jml.l SetSPA
.p3:
	lda.w #$0F0C
	sta.b d1
	lda.b d2
	bit.w #$4000
	beq .nopunch
	jml.l SetSPA
.nopunch:
	stz.w pf2aip,x
.rtl:
	rtl
