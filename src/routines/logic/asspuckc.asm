asspuckc:		;Assignment: the puck carrier. Checks for offsides, line changes, shots and passes, and skates to a good spot
	txa		; not the carrier: assexit
	lsr a
	cmp.w puckc
	beq .nl
	jmp.w assexit
.nl:
	lda.w pfalock,x		; anim locked
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock		; clock stopped: assnothing
	beq .go
	jml.l assnothing
.go:
	lda.w pflags,x		; joystick controlled: assexit
	bit.w #pfjoycon
	beq .na
	jmp.w assexit
.na:
	bit.w #pfna		; new assignment: temp1 = 0, temp2b = 8, temp3 = random 0-3
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w seed
	and.w #$0003
	sta.w temp3,x
.nna:
	lda.w temp1,x		; every aioff frames: checkob, chk4lc, chk4shot, chk4pass
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	adc.w aioff,x
	bpl .set
	lda.w #$0000
.set:
	sta.w temp1,x
	jsl.l checkob
	jsl.l chk4lc
	jsl.l chk4shot
	jsl.l chk4pass
.nodec:		;d0 = 6 + temp3 (random spot), or position when offsides
	lda.w #$0006
	clc
	adc.w temp3,x
	sta.b d0
	lda.w #PuckcSpots
	sta.b a0
	lda.w #PuckcSpots>>16
	sta.b a0+2
	lda.w sflags		; sf2offsig: spot by position
	bit.w #sf2offsig
	beq .nd1
	lda.w position,x
	sta.b d0
.nd1:
	lda.b d0		; d0/d1 = spot x/y, negated for pfgoal clear
	asl a
	asl a
	tay
	lda.b [a0],y
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d1
	lda.w pfgoal,x
	bne .nd0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.nd0:
	lda.w #.chkdir		; skateto with the .chkdir callback
	sta.b a0
	lda.w #.chkdir>>16
	sta.b a0+2
	jml.l skateto		; d0/d1 = target, a0 = callback
.rtl:
	rtl
.chkdir:		;skateto callback. d0 = direction; turn away from an opponent within 20 of where the puck will be (threat = count)
	lda.b d0
	and.w #$00FF
	bit.w #$0080
	beq .cd
	ora.w #$FF00
.cd:
	sta.b d0		; d2/d3 = puck + velocity
	lda.w Xvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .x2
	ora.w #$FF00
.x2:
	clc
	adc.w puckx
	sta.b d2
	lda.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .y2
	ora.w #$FF00
.y2:
	clc
	adc.w pucky
	sta.b d3
	stz.w threat
	lda.w #$0005
	sta.b d4
	stz.b a0		; the 6 opponents
	cpx.w #$000C
	bcs .cd0
	lda.w #$000C
	sta.b a0
.cd0:
	ldy.b a0
	lda.w Xvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cx
	ora.w #$FF00
.cx:
	clc
	adc.w Xpos,y
	sec
	sbc.b d2
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #$0015
	bcs .next
	lda.w Yvel+1,y
	and.w #$00FF
	bit.w #$0080
	beq .cy
	ora.w #$FF00
.cy:
	clc
	adc.w Ypos,y
	sec
	sbc.b d3
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #$0015
	bcs .next
	inc.w threat		; threat +1; facing straight at it: turn one step either way
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	lda.w facedir,x
	eor.w #$0004
	cmp.b d0
	bne .next
	lda.w seed+2
	and.w #$0001
	clc
	adc.b d0
	and.w #$0007
	sta.b d0
.next:
	inc.b a0
	inc.b a0
	dec.b d4
	bmi .rtl2
	jmp.w .cd0
.rtl2:
	rtl
