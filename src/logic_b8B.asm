; logic_b8B: 93G logic93_1..logic93_5: player logic and the assignments (asstab).
; Bank $8B. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8BFE47
asswingo:		;asstab 4. player a3 is winger on offense (93G logic93_3)
		;   SNES: wing on offence: pick a spot in the zone the puck is in (.dedata + random), awingd when the other team has the puck
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w gmclock
	beq .gm
	jml.l assnothing		; bank $8F: assnothing
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
	lda.w #$FFFF		; temp5 = -1: no zone yet
	sta.w temp5,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .new
	jmp.w .nodec
.new:
	clc
	adc.w aidef,x
	bpl .t1
	lda.w #$0000
.t1:
	sta.w temp1,x
	lda.w #3		; awingd
	sta.b d0
	lda.w puckc		; the other team has the puck
	bmi .de0
	sec
	sbc.w #6
	sta.b d1
	txa
	sec
	sbc.w #12
	eor.b d1
	bpl .de0
	jml.l assreplace
.de0:
	lda.w pucky		; d3 = pucky + puckvy / 64
	sta.b d0
	lda.w puckvy
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .v
	ora.w #$FC00
.v:
	clc
	adc.b d0
	sta.b d3
	lda.w pfgoal,x
	bne .de1
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
.de1:		;zone number
	stz.b d2		; zone 0: own zone
	lda.b d3
	sec
	sbc.w #-88
	bmi .lt1
	bvc .z1
	bra .de2
.lt1:
	bvc .de2
.z1:
	lda.w #8		; zone 8: centre
	sta.b d2
	lda.b d0
	sec
	sbc.w #88
	bmi .lt2
	bvc .z2
	bra .de2
.lt2:
	bvc .de2
.z2:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoffside		; offsides: stay back
	bne .de2
	asl.b d2		; zone 16: their zone
	lda.b d3
	sec
	sbc.w #264
	bmi .lt3
	bvc .z3
	bra .de2
.lt3:
	bvc .de2
.z3:
	lda.w #24		; zone 24: past the goal line
	sta.b d2
.de2:
	lda.b d2
	cmp.w temp5,x
	bne .de3
	lda.w seed		; same zone: new spot only now and then (93G HV counter, here seed)
	cmp.w #$0200
	bcs .nodec
.de3:
	lda.b d2
	sta.w temp5,x
	tay
	lda.w #.dedata		; temp3 = x + random, temp4 = y + random
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
	lda.w position,x
	cmp.w #5
	beq .one
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.one:		;93G .1
	lda.w temp4,x
	sta.b d1
	lda.w pfgoal,x
	bne .up
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.up:
	lda.w #EvadePC		; avoid the puck carrier (EvadePC)
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto
.rtl:
	rtl
.dedata:		;93G .dedata: x, x random, y, y random per zone
	dw 80,20,-70,10		; own zone
	dw 100,20,60,10		; centre
	dw 60,50,230,20		; their zone
	dw 80,30,250,20		; past the goal line

org $8BFFD3
skatetopuckinit:		;93 split from 92 skatetopuck: d0/d1 = puck x/y plus half the high byte of its velocity. Called from skatetopuck and assnearest (93G logic93_5)
	lda.w puckvx		; puckvx high byte / 2
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .x
	ora.w #$FF80
.x:
	clc
	adc.w puckx
	sta.b d0
	lda.w puckvy
	xba
	lsr a
	and.w #$007F
	bit.w #$0040
	beq .y
	ora.w #$FF80
.y:
	clc
	adc.w pucky
	sta.b d1
	rtl
