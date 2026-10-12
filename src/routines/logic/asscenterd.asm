asscenterd:		;Assignment: the center on defense, halfway between the puck and his goal; switches to offense when his team
		;   gets the puck
	lda.w gmclock
	beq .go
	jml.l assnothing
.go:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .nopflags
	jmp.w .rtl
.nopflags:
	bit.w #$0002
	beq .nna
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	lda.w aidef,x
	sta.w temp1,x
	lda.w puckc
	bmi .nodec
	sec
	sbc.w #$0006
	sta.b d1
	lda.w #$0006
	sta.b d0
	txa
	lsr a
	sec
	sbc.w #$0006
	eor.b d1
	bmi .nodec
	jml.l assreplace
.nodec:
	lda.w puckx
	pha
	asl a
	pla
	ror a
	sta.b d0
	lda.w #$0080
	sta.b d1
	lda.w pfgoal,x
	beq .nopfgoal
	lda.w #$FF80
	sta.b d1
	lda.w #$FFA8
	sec
	sbc.w pucky
	beq .half
	bmi .lt
	bvs .half
	bra .z1
.lt:
	bvs .z1
.half:
	lda.w #$FF80
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
	bra .z1
.rtl:
	rtl
.nopfgoal:
	lda.w #$0058
	sec
	sbc.w pucky
	bmi .lt2
	bvc .half2
	bra .z1
.lt2:
	bvc .z1
.half2:
	lda.b d1
	clc
	adc.w pucky
	pha
	asl a
	pla
	ror a
	sta.b d1
.z1:
	lda.w #rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jml.l skateto
