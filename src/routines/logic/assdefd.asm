assdefd:		;Assignment: a defenseman on defense stays between the furthest attacker and his goal, and joins the attack
		;   when the puck is past the line
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfjoycon
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .new
	jmp.w .de3
.new:
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w pucky
	sta.b d1
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .sx
	ora.w #$FC00
.sx:
	sta.b d3
	lda.w pfgoal,x
	bne .de00
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
.de00:		;only lead when moving up ice
	lda.b d3
	bpl .v
	stz.b d3
.v:
	lda.b d3
	clc
	adc.b d1
	sta.b d3
	sec
	sbc.w #$58
	bmi .lt
	bvc .pastline
	bra .de0
.lt:
	bvc .de0
.pastline:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .de0
	lda.w puckc
	sta.b d1
	bmi .de0
	jsl.l chkpk
	beq .de0
	lda.w #1
	sta.b d0
	lda.b d1
	sec
	sbc.w #6
	sta.b d1
	txa
	lsr a
	sec
	sbc.w #6
	sta.b d2
	eor.b d1
	sta.b d1
	bmi .de0
	jml.l assreplace
.de0:
	lda.w #65
	sta.w temp3,x
	lda.w position,x
	cmp.w #$0002
	beq .de1
	lda.w #-65
	sta.w temp3,x
.de1:
	stz.b a0
	cpx.w #12
	bcs .de2
	lda.w #12
	sta.b a0
.de2:		;find the furthest-up attacker
	lda.w #5
	sta.b d2
	lda.w #-1000
	sta.b d0
	lda.w pfgoal,x
	beq .gdwn
	lda.w #1000
	sta.b d0
.gup:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gu0
	lda.w position,y
	bmi .gu0
	lda.w Yvel,y
	bmi .gu2
	lda.w #$0000
.gu2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gu2s
	ora.w #$F000
.gu2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	beq .gu3
	bmi .gt
	bvs .gu3
	bra .gu0
.gt:
	bvs .gu0
.gu3:
	lda.b d1
	sta.b d0
.gu0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gup
	lda.b d0
	sec
	sbc.w #50
	sta.b d0
	sec
	sbc.w #-190
	beq .cl1
	bmi .gt1
	bvs .cl1
	bra .gu1
.gt1:
	bvs .gu1
.cl1:
	lda.w #-220
	sta.b d0
.gu1:
	lda.b d0
	sta.w temp4,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
	bra .de3
.rtl:
	rtl
.gdwn:
	ldy.b a0
	lda.w pflags,y
	bit.w #$1000
	bne .gd0
	lda.w position,y
	bmi .gd0
	lda.w Yvel,y
	bpl .gd2
	lda.w #$0000
.gd2:
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .gd2s
	ora.w #$F000
.gd2s:
	clc
	adc.w Ypos,y
	sta.b d1
	sec
	sbc.b d0
	bmi .lt2
	bvc .gd3
	bra .gd0
.lt2:
	bvc .gd0
.gd3:
	lda.b d1
	sta.b d0
.gd0:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .gdwn
	lda.b d0
	clc
	adc.w #50
	sta.b d0
	sec
	sbc.w #190
	bmi .lt3
	bvc .cl2
	bra .gd1
.lt3:
	bvc .gd1
.cl2:
	lda.w #220
	sta.b d0
.gd1:
	lda.b d0
	sta.w temp4,x
	lda.w temp3,x
	eor.w #$FFFF
	inc a
	sta.w temp3,x
	lda.w puckx
	sta.b d0
	lda.w temp3,x
	eor.b d0
	sta.b d1
	bpl .de3
	stz.w temp3,x
.de3:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #EvadePC
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jsl.l skateto
	jml.l check4check
