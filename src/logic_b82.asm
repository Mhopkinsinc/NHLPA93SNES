; Player logic and the assignments (asstab).
; Bank $82. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $82FDE7
asscentero:		;asstab 6. player a3 is center on offense
		;   SNES: player X is the center on offense. Every aidef frames: acenterd when the other team has the puck, else a random spot in the
		;   zone of the puck (.dedata), skateto with EvadePC
	lda.w pfalock,x		; anim locked: nothing
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock		; clock stopped: assnothing
	beq .go
	jml.l assnothing		; bank $8F
.go:
	jsl.l check4bench
	lda.w pflags,x		; joystick controlled: nothing
	bit.w #pfjoycon
	beq .na
	jmp.w .rtl
.na:
	bit.w #pfna		; new assignment: temp5 = -1 (old zone), temp1 = 0, temp2 = 8
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	lda.w #$FFFF
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x		; every aidef frames
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .dec
	jmp.w .nodec
.dec:
	clc
	adc.w aidef,x
	bpl .st
	lda.w #$0000
.st:
	sta.w temp1,x
	lda.w puckc		; other team has the puck: acenterd
	bmi .de0
	sec
	sbc.w #$0006
	sta.b d1
	lda.w #acenterd
	sta.b d0
	txa
	sec
	sbc.w #$000C
	eor.b d1
	bpl .de0
	jml.l assreplace
.de0:
	lda.w pucky		; d0 = pucky toward the attacking end
	sta.b d0
	lda.w pfgoal,x
	bne .de1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.de1:		;zone number
	stz.b d2
	lda.b d0
	sec
	sbc.w #$FFA8
	bmi .neg1
	bvc .z1
	bra .de2
.neg1:
	bvc .de2
.z1:
	lda.w #$0008
	sta.b d2
	lda.b d0
	sec
	sbc.w #$0058
	bmi .neg2
	bvc .z2
	bra .de2
.neg2:
	bvc .de2
.z2:
	ldy.b a2		; tmflags bit 4: stay in the middle zone
	lda.w tmflags,y
	bit.w #$0010
	bne .de2
	asl.b d2
	lda.b d0
	sec
	sbc.w #$0108
	bmi .neg3
	bvc .z3
	bra .de2
.neg3:
	bvc .de2
.z3:
	lda.w #$0018
	sta.b d2
.de2:
	lda.b d2		; same zone: new spot only 1 in 128
	cmp.w temp5,x
	bne .de3
	lda.w seed+2
	cmp.w #$0200
	bcs .nodec
.de3:
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #.dedata		; temp3/temp4 = .dedata spot + randomd0s of the range
	sta.b a0
	lda.w #.dedata>>16
	sta.b a0+2
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp3,x
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b [a0],y
	dey
	dey
	jsl.l randomd0s
	adc.b [a0],y
	sta.w temp4,x
.nodec:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.0:
	lda.w #EvadePC		; skateto with the EvadePC callback
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto		; bank $88 (d0/d1 = target, a0 = callback)
.rtl:
	rtl
.dedata:		;per zone (x, random x range, y, random y range)
	dw 0,60,-70,10		; zone 0
	dw 0,60,60,10		; zone 1
	dw 0,40,170,30		; zone 2
	dw 0,80,170,20		; zone 3
unusedFF82:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
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
