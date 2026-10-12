doplayeracc:		;player a3 gets acc. in d0 dir
		;   SNES: player X skates in direction d0 (0-7; 8 glides, 9 stops when moving); goalies use goalieacc. Sets pfrev to skate backwards in his own
		;   zone, turns facedir/facefrac toward d0 (.ftab * d7, slower when fast), SPAturnl/SPAturnr or SPAglide/SPAglideback; revplayeracc when moving
	lda.w position,x
	bne .skater
	jml.l goalieacc
.skater:
	lda.w #SPAglide
	sta.b d1
	lda.w pfrev,x
	beq .d0
	lda.w #SPAglideback
	sta.b d1
.d0:
	lda.b d0
	and.w #$000F
	sta.b d0
	cmp.w #$0008
	bcc .d1
	cmp.w #$0009
	bne .cgl
	lda.w Xvel,x
	ora.w Yvel,x
	beq .cgl
	jml.l dostop
.cgl:		;no turn animation playing (pf2aip): SetSPA
	lda.w pf2aip,x
	bne .rtl
	jml.l SetSPA
.rtl:
	rtl
.d1:		;a direction: pfrev, then the turn
	lda.b d1
	pha
	lda.b d0
	pha
	sta.b d2
	txa
	lsr a
	cmp.w puckc
	bne .nocarrier
	jmp.w .clrrev
.nocarrier:
	lda.w puckx
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d3
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .sx
	ora.w #$FE00
.sx:
	clc
	adc.w pucky
	sec
	sbc.b d3
	sta.b d1
	lda.w pfgoal,x
	bne .c1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
	lda.b d2
	eor.w #$0004
	sta.b d2
.c1:
	lda.w pfrev,x
	bne .inrev
	lda.b d3
	bpl .clrrev
	lda.b d2
	cmp.w #$0004
	bne .clrrev
	jsl.l vtoa
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .clrrev
	bra .rev
.inrev:
	lda.b d2
	sec
	sbc.w #$0003
	and.w #$0007
	cmp.w #$0003
	bcs .clrrev
	jsl.l vtoa
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcs .clrrev
.rev:
	lda.w pfrev,x
	bne .done
	lda.w Xvel,x
	sta.b d0
	ora.w Yvel,x
	beq .setrev
	lda.w Yvel,x
	sta.b d1
	jsl.l vtoa
	sec
	sbc.b $01,s
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .done
.setrev:
	inc a
	sta.w pfrev,x
	bra .done
.clrrev:
	stz.w pfrev,x
.done:		;turn rate = .ftab (direction difference) * d7; 0: noturn0
	pla
	sta.b d0
	pla
	sta.b d1
	lda.w facedir,x
	sta.b d2
	lda.b d0
	sec
	sbc.b d2
	and.w #$0007
	asl a
	sta.b d0
	tax
	lda.l .ftab,x
	ldx.b a3
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l muls16
	sta.b tmp0
	lda.b tmp0
	bne .turn
	jml.l noturn0
.turn:
	lda.w Xvel,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.w Yvel,x
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d4
	lda.b mulres+2
	adc.b d4+2
	sta.b d3
	lda.w #$0300
	sec
	sbc.b d3
	sta.b d4
	sec
	sbc.w #$0180
	bmi .neg
	bvs .vs
	bra .iok
.neg:
	bvs .iok
.vs:
	lda.w #$0180
	sta.b d4
.iok:
	lda.b tmp0
	sta.b mula
	lda.b d4
	sta.b mulb
	jsl.l muls32
	sta.b d4
	lda.b mulres+2
	sta.b d4+2
	lda.w pfrev,x
	beq .i0
	lda.w #$0000
	sec
	sbc.b d4
	sta.b d4
	lda.w #$0000
	sbc.b d4+2
	sta.b d4+2
.i0:		;facedir.l + d4
	lda.w facefrac,x
	clc
	adc.b d4
	sta.w facefrac,x
	lda.w facedir,x
	adc.b d4+2
	and.w #$0007
	sta.w facedir,x
	sta.b d2
	lda.b d3
	cmp.w #$0015
	bcc .s3
	stz.b d1
	lda.b tmp0
	bpl .s1
	lda.w #SPAturnl-SPAturnr
	sta.b d1
.s1:
	lda.w attribute,x
	bit.w #$0800
	beq .s2
	lda.b d1
	eor.w #SPAturnl-SPAturnr
	sta.b d1
.s2:		;SPAturnr (or SPAturnl), pf2aip
	lda.b d1
	clc
	adc.w #SPAturnr
	sta.b d1
	sta.w pf2aip,x
.s3:
	jsl.l SetSPA
	lda.b d3
	cmp.w #$0003
	bcc .rtl2
	jml.l revplayeracc
.rtl2:
	rtl
.ftab:		;turn rate by the direction difference
	dw 0,23,23,23,0,-23,-23,-23
