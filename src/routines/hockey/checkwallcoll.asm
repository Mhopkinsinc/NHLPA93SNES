checkwallcoll:		;d2/d3 = x/y to test, a3 = object, wcradiusx/wcradiusy = radius. Called from checkcoll
		;   SNES: d2/d3 = x/y, object X, wcradiusx/y. Corner circles, goals, then side and end boards
	lda.w #$012A		; d3 = $12A - wcradiusy, d2 = $88 - wcradiusx; corner centers 64 in
	sec
	sbc.w wcradiusy
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d5
	lda.w #$0088
	sec
	sbc.w wcradiusx
	pha
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0040
	sta.b d4
	lda.b d3
	pha
	ldy.b d2
	phy
	sec
	sbc.b d5
	beq .negy
	bmi .neg
	bvs .negy
	bra .ctc
.neg:
	bvs .ctc
.negy:
	lda.b d2
	sec
	sbc.b d4
	bmi .neg1
	bvc .gl1
	bra .circle
.neg1:
	bvc .circle
.gl1:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .neg2
	bvc .goal13
	bra .circle
.neg2:
	bvc .circle
.goal13:		;goal at the -y end (object 13)
	lda.w #$001A
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.ctc:
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	beq .c2
	bmi .neg3
	bvs .c2
.exit1:
	jmp.w .exit
.neg3:
	bvs .exit1
.c2:
	lda.b d2
	sec
	sbc.b d4
	bmi .neg4
	bvc .c3
	bra .circle
.neg4:
	bvc .circle
.c3:
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .neg5
	bvc .goal12
	bra .circle
.neg5:
	bvc .circle
.goal12:		;goal at the +y end (object 12)
	lda.w #$0018
	sta.b a2
	jsl.l checkgoal
	jmp.w .exit
.circle:		;distance from the corner center (max+min/4)
	lda.b d2
	sec
	sbc.b d4
	sta.b d2
	eor.w #$FFFF
	inc a
	sta.b d1
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	sta.b mula
	lda.b d3
	sec
	sbc.b d5
	sta.b d0
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	sta.b mulb
	cmp.b mula
	bcc .m2
	lda.b mula
	lsr a
	lsr a
	adc.b mulb
	bra .dist
.m2:
	lsr a
	lsr a
	adc.b mula
.dist:
	cmp.w #$0041		; inside the radius 64 circle: no hit
	bcc .exit
	sta.b d3		; cos = dy*256/r, sin = dx*256/r
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d0
	sta.b mulb+1
	bpl .cos
	lda.w #$FFFF
	sta.b mulb+3
.cos:
	jsl.l divs
	sta.b d0
	lda.b d3
	sta.b mula
	stz.b mulb
	stz.b mulb+2
	lda.b d1
	sta.b mulb+1
	bpl .sin
	lda.w #$FFFF
	sta.b mulb+3
.sin:
	jsl.l divs
	sta.b d1
	jsl.l wallcollb
.exit:		;no corner hit: the side and end boards
	pla
	sta.b d2
	pla
	sta.b d3
	pla
	sta.b d4
	pla
	sta.b d5
	lda.w Wallcos,x		; corner hit: done
	ora.w Wallsin,x
	bne .rtl
	lda.w #$0100		; side walls: cos $100, sin 0
	sta.b d0
	stz.b d1
	lda.b d3
	sec
	sbc.b d5
	bmi .neg6
	bvs .s1
.b1:
	jmp.w wallcollb
.neg6:
	bvs .b1
.s1:
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d5
	eor.w #$FFFF
	inc a
	sta.b d5
	sec
	sbc.b d3
	bmi .neg7
	bvs .s2
.b2:
	jmp.w wallcollb
.neg7:
	bvs .b2
.s2:
	lda.b d0
	pha
	lda.b d1
	sta.b d0
	pla
	sta.b d1
	lda.b d2
	sec
	sbc.b d4
	bmi .neg8
	bvs .s3
.b3:
	jmp.w wallcollb
.neg8:
	bvs .b3
.s3:
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	lda.b d4
	eor.w #$FFFF
	inc a
	sta.b d4
	sec
	sbc.b d2
	bmi .neg9
	bvs .rtl
.b4:
	jmp.w wallcollb
.neg9:
	bvs .b4
.rtl:
	rtl
