findpc_calc:		;d4 = goal line y, Y = puckcross entry offset
	lda.b d4		; d0 = line - pucky
	sec
	sbc.w pucky
	sta.b d0
	lda.w puckvy
	bne .div
	jmp.w .nocross
.div:
	sta.b mula
	lda.b d0		; mulb = d0 << 12
	stz.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	lsr a
	ror.b mulb
	bit.w #$0800
	beq .hi
	ora.w #$F000
.hi:
	sta.b mulb+2
	jsl.l divs
	bpl .time
	jmp.w .nocross
.time:
	sta.w puckcross+2,y		; frames until crossing
	lda.w puckvx
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l muls32		; x offset = puckvx*d0/puckvy, if it fits
	lda.w puckvy
	bit.w #$8000
	beq .vy
	eor.w #$FFFF
	inc a
.vy:
	sta.b mula
	lda.b mulres+2
	bit.w #$8000
	beq .ov
	eor.w #$FFFF
	inc a
.ov:
	cmp.b mula
	bcs .nocross
	lda.w puckvy
	sta.b mula
	jsl.l divs
	adc.w puckx
	sta.b d0
	sec
	sbc.w #$0088		; sideline $88
	bmi .neg
	bvc .o1
	bra .o1b
.neg:
	bvc .o1b
.o1:		;bounce off the right side boards
	lda.w #$0198		; 3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o1b:
	lda.b d0
	sec
	sbc.w #$FF78
	beq .o2
	bmi .neg1
	bvs .o2
	bra .o2b
.neg1:
	bvs .o2b
.o2:		;bounce off the left side boards
	lda.w #$FE68		; -3*$88 - x
	sec
	sbc.b d0
	sta.b d0
.o2b:
	lda.b d0
	sta.w puckcross,y
	bra .rtl
.nocross:
	lda.w #$FFFF
	sta.w puckcross+2,y
.rtl:
	rtl
