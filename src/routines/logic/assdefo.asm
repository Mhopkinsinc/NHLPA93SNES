assdefo:		;asstab 1. player a3 is defensive player on offense
		;   SNES: defenceman on offence: hold the blue line on his side; adefd when offside, the puck goes back past the line or the other team has it
	lda.w pfalock,x
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock
	beq .bench
	jml.l assnothing
.bench:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .na
	jmp.w .rtl
.na:
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
	clc
	adc.w aioff,x
	bpl .store
	lda.w #$0000
.store:
	sta.w temp1,x
	lda.w #2		; adefd
	sta.b d0
	ldy.b a2
	lda.w tmflags,y		; offsides: defend
	bit.w #tmfoffside
	beq .on
	jml.l assreplace
.on:
	lda.w pucky
	sta.b d1
	lda.w pfgoal,x
	bne .de1
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.de1:
	lda.b d1		; the puck back behind the blue line
	sec
	sbc.w #$5D
	bmi .lt
	bvc .pc
.def:
	jml.l assreplace
.lt:
	bvc .def
.pc:
	lda.w puckc		; the other team has the puck
	bmi .nodec
	sec
	sbc.w #6
	sta.b d1
	txa
	sec
	sbc.w #12
	eor.b d1
	bpl .nodec
	jml.l assreplace
.nodec:
	lda.w #EvadePC		; EvadePC avoidance; spot x +-80 by side, y 98 (blue line + 5)
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #80
	sta.b d0
	lda.w position,x
	cmp.w #2
	beq .1
	lda.w #-80
	sta.b d0
.1:
	lda.w #98
	sta.b d1
	lda.w pfgoal,x
	bne .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w #-98
	sta.b d1
.0:
	lda.w puckx
	eor.b d0
	bmi .2
	lda.w puckx
	bra .set
.rtl:
	rtl
.2:		;halfway to the puck
	lda.w puckx
	pha
	asl a
	pla
	ror a
	clc
	adc.b d0
.set:
	sta.b d0
	jml.l skateto
unused008E:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00
