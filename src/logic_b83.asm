; logic_b83: 93G logic93_1..logic93_5: player logic and the assignments (asstab).
; Bank $83. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $83FDFC
assgoalietopuck:		;asstab $F. 93 only: goalie skates out to a loose puck (inserted by (93G logic93_3)
		;   SNES: goalie skates out to a loose puck (inserted by assgoalie) while the puck moves toward him and the tmnear stats
		;   allow it, else assexit
	lda.w pflags,x		; joystick controlled or clock stopped: assexit
	and.w #pfjoycon
	ora.w gmclock
	beq .chk
	jml.l assexit
.chk:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .go
	lda.w aidef,x
	lsr a
	lsr a
	clc
	adc.w temp1,x
	bpl .st
	lda.w #$0000
.st:
	sta.w temp1,x
	lda.w puckc		; carried puck: assexit
	bmi .pc
	jml.l assexit
.pc:
	lda.w puckvy		; puck moving away from my goal: assexit
	sta.b tmp0
	lda.w pfgoal,x
	beq .dir
	lda.b tmp0
	eor.w #$FFFF
	inc a
	sta.b tmp0
.dir:
	lda.b tmp0
	bpl .tm
	jml.l assexit
.tm:
	stz.b a1		; tmnear of my team >= $E10 and of the other >= $640
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .t0
	stz.b a2
	lda.w #$0002
	sta.b a1
.t0:
	ldy.b a1
	lda.w tmnear,y
	cmp.w #$0E10
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .t1
	jml.l assexit
.t1:
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$0640
	lda.w tmnear+4,y
	sbc.w #$0000
	bcs .go
	jml.l assexit
.go:		;skatetopuck
	jml.l skatetopuck
unusedFF83:		;unused, $FF fill to the end of the bank
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
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF
