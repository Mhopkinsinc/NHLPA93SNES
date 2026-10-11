; Player logic and the assignments (asstab).
; Bank $89. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $89FD6A
EvadePC:		;player a3 should avoid the puck carrier if he's on my team
		;   SNES: within 40 of the puck carrier (after one frame of both velocities) d0 = direction away from him
	lda.w puckc
	bmi .rtl
	lda.w Xvel+1,x		; x after one frame, relative to the puck carrier
	sec
	sbc.w puckvx+1
	and.w #$00FF
	bit.w #$0080
	beq .xs
	ora.w #$FF00
.xs:
	clc
	adc.w Xpos,x
	sec
	sbc.w puckx
	bit.w #$8000
	beq .xa
	eor.w #$FFFF
	inc a
.xa:
	cmp.w #41
	bcs .rtl
	lda.w Yvel+1,x
	sec
	sbc.w puckvy+1
	and.w #$00FF
	bit.w #$0080
	beq .ys
	ora.w #$FF00
.ys:
	clc
	adc.w Ypos,x
	sec
	sbc.w pucky
	bit.w #$8000
	beq .ya
	eor.w #$FFFF
	inc a
.ya:
	cmp.w #41
	bcs .rtl
	lda.w Xpos,x
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w pucky
	sta.b d1
	jml.l vtoa
.rtl:
	rtl
asswingd:		;asstab 3. player a3 is wing on defense
		;   SNES: wing on defence: cover his side between the puck and the goal; awingo when the team gets the puck
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing		; bank $8F
.gm:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .chk
	jmp.w .rtl
.chk:
	bit.w #$0002
	beq .nna
	and.w #$FFFD
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
	bpl .nodec
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w puckc		; our team has the puck: awingo
	bmi .nodec
	sec
	sbc.w #6
	sta.b d1
	lda.w #4
	sta.b d0
	txa
	lsr a
	sec
	sbc.w #6
	eor.b d1
	sta.b d1
	bmi .nodec
	jml.l assreplace
.nodec:
	lda.w #100		; x 100 (left wing -100)
	sta.b d0
	lda.w position,x
	cmp.w #5
	bne .zero
	lda.w #-100
	sta.b d0
.zero:
	lda.w #158
	sta.b d1
	lda.w pfgoal,x		; pfgoal: defending the top goal
	beq .up
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w #-158
	sta.b d1
	lda.w #-78
	sta.b d2
	ldy.b a2
	lda.w tmflags,y		; offsides: stay at the blue line
	bit.w #tmfoffside
	bne .set
	lda.b d2
	sec
	sbc.w pucky
	beq .hi0
	bmi .lt
	bvs .hi0
	bra .lo
.lt:
	bvs .lo
.hi0:
	lda.w pucky
	sta.b d1
	bra .go2
.rtl:
	rtl
.lo:
	lda.w #-264
	sta.b d2
	sec
	sbc.w pucky
	bmi .lt2
	bvc .set1
	bra .go2
.lt2:
	bvc .go2
.set1:
	bra .set
.up:
	lda.w #78
	sta.b d2
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside
	bne .set
	lda.b d2
	sec
	sbc.w pucky
	bmi .lt3
	bvc .up0
	bra .hi
.lt3:
	bvc .hi
.up0:
	lda.w pucky
	sta.b d1
	bra .go2
.hi:
	lda.w #264
	sta.b d2
	sec
	sbc.w pucky
	beq .set
	bmi .lt4
	bvs .set
	bra .go2
.lt4:
	bvs .go2
.set:
	lda.b d2
	sta.b d1
.go2:
	lda.w #rtss		; a0 = rtss: no avoidance
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w puckx
	eor.b d0
	sta.b d2
	bmi .skate
	lda.w puckx
	sta.b d0
.skate:
	jml.l skateto
unusedFF89:		;unused, $FF fill to the end of the bank
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
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF
