; $8EF00B-$8EFFFF  ROM $7700B-$77FFF: the last SpriteSet14 tiles, assdefo (logic93_2, asstab 1), zero fill.
org $8EF00B
	incbin "../data/Sprites/set14.chr":$478..$12E0		; $8EF00B-$8EFE72
SpriteSet14End:
	assert SpriteSet14End-SpriteSet14 == $11EC+151*32
assdefo:		;auto: CODE_8EFE73 (asstab 1). 93G assdefo (logic93_2): defenceman on offence: hold the blue line on his side; adefd when offside, the puck goes back past the line or the other team has it
	lda.w pfalock,x		; $8EFE73: BD 7F 11
	beq .go		; $8EFE76: F0 03
	jmp.w .rtl		; $8EFE78: 4C 4D FF
.go:
	lda.w gmclock		; $8EFE7B: AD 8A 12
	beq .gm		; $8EFE7E: F0 04
	jml.l assnothing		; $8EFE80: 5C 5A D7 8F  bank $8F: assnothing
.gm:
	jsl.l check4bench		; $8EFE84: 22 27 85 80
	lda.w pflags,x		; $8EFE88: BD DF 0E
	bit.w #$0008		; $8EFE8B: 89 08 00
	beq .chk		; $8EFE8E: F0 03
	jmp.w .rtl		; $8EFE90: 4C 4D FF
.chk:
	bit.w #$0002		; $8EFE93: 89 02 00
	beq .nna		; $8EFE96: F0 12
	and.w #$FFFD		; $8EFE98: 29 FD FF
	sta.w pflags,x		; $8EFE9B: 9D DF 0E
	stz.w temp1,x		; $8EFE9E: 9E 5F 0C
	stz.w temp2,x		; $8EFEA1: 9E 7F 0C
	lda.w #$0008		; $8EFEA4: A9 08 00
	sta.w temp2b,x		; $8EFEA7: 9D FF 0C
.nna:
	lda.w temp1,x		; $8EFEAA: BD 5F 0C
	sec		; $8EFEAD: 38
	sbc.b d7		; $8EFEAE: E5 6F
	sta.w temp1,x		; $8EFEB0: 9D 5F 0C
	bpl .nodec		; $8EFEB3: 10 59
	clc		; $8EFEB5: 18
	adc.w aioff,x		; $8EFEB6: 7D 9F 0F
	bpl .t1		; $8EFEB9: 10 03
	lda.w #$0000		; $8EFEBB: A9 00 00
.t1:
	sta.w temp1,x		; $8EFEBE: 9D 5F 0C
	lda.w #2		; $8EFEC1: A9 02 00  adefd
	sta.b d0		; $8EFEC4: 85 53
	ldy.b a2		; $8EFEC6: A4 3B
	lda.w tmflags,y		; $8EFEC8: B9 0A 14  offsides: defend
	bit.w #tmfoffside		; $8EFECB: 89 10 00
	beq .on		; $8EFECE: F0 04
	jml.l assreplace		; $8EFED0: 5C A7 B4 80
.on:
	lda.w pucky		; $8EFED4: AD 7B 09
	sta.b d1		; $8EFED7: 85 57
	lda.w pfgoal,x		; $8EFED9: BD 3F 11
	bne .de1		; $8EFEDC: D0 08
	lda.b d1		; $8EFEDE: A5 57
	eor.w #$FFFF		; $8EFEE0: 49 FF FF
	inc a		; $8EFEE3: 1A
	sta.b d1		; $8EFEE4: 85 57
.de1:
	lda.b d1		; $8EFEE6: A5 57  the puck back behind the blue line
	sec		; $8EFEE8: 38
	sbc.w #$5D		; $8EFEE9: E9 5D 00
	bmi .lt		; $8EFEEC: 30 06
	bvc .pc		; $8EFEEE: 50 06
.def:
	jml.l assreplace		; $8EFEF0: 5C A7 B4 80
.lt:
	bvc .def		; $8EFEF4: 50 FA
.pc:
	lda.w puckc		; $8EFEF6: AD BB 0E  the other team has the puck
	bmi .nodec		; $8EFEF9: 30 13
	sec		; $8EFEFB: 38
	sbc.w #6		; $8EFEFC: E9 06 00
	sta.b d1		; $8EFEFF: 85 57
	txa		; $8EFF01: 8A
	sec		; $8EFF02: 38
	sbc.w #12		; $8EFF03: E9 0C 00
	eor.b d1		; $8EFF06: 45 57
	bpl .nodec		; $8EFF08: 10 04
	jml.l assreplace		; $8EFF0A: 5C A7 B4 80
.nodec:
	lda.w #EvadePC		; $8EFF0E: A9 6A FD  EvadePC avoidance; spot x +-80 by side, y 98 (blue line + 5)
	sta.b a0		; $8EFF11: 85 33
	lda.w #EvadePC>>16		; $8EFF13: A9 89 00
	sta.b a0+2		; $8EFF16: 85 35
	lda.w #80		; $8EFF18: A9 50 00
	sta.b d0		; $8EFF1B: 85 53
	lda.w position,x		; $8EFF1D: BD 9F 0B
	cmp.w #2		; $8EFF20: C9 02 00
	beq .one		; $8EFF23: F0 05
	lda.w #-80		; $8EFF25: A9 B0 FF
	sta.b d0		; $8EFF28: 85 53
.one:		;93G .1
	lda.w #98		; $8EFF2A: A9 62 00
	sta.b d1		; $8EFF2D: 85 57
	lda.w pfgoal,x		; $8EFF2F: BD 3F 11
	bne .zero		; $8EFF32: D0 0D
	lda.b d0		; $8EFF34: A5 53
	eor.w #$FFFF		; $8EFF36: 49 FF FF
	inc a		; $8EFF39: 1A
	sta.b d0		; $8EFF3A: 85 53
	lda.w #-98		; $8EFF3C: A9 9E FF
	sta.b d1		; $8EFF3F: 85 57
.zero:		;93G .0
	lda.w puckx		; $8EFF41: AD 1B 09
	eor.b d0		; $8EFF44: 45 53
	bmi .two		; $8EFF46: 30 06
	lda.w puckx		; $8EFF48: AD 1B 09
	bra .go2		; $8EFF4B: 80 0B
.rtl:
	rtl		; $8EFF4D: 6B
.two:		;93G .2: halfway to the puck
	lda.w puckx		; $8EFF4E: AD 1B 09
	pha		; $8EFF51: 48
	asl a		; $8EFF52: 0A
	pla		; $8EFF53: 68
	ror a		; $8EFF54: 6A
	clc		; $8EFF55: 18
	adc.b d0		; $8EFF56: 65 53
.go2:
	sta.b d0		; $8EFF58: 85 53
	jml.l skateto		; $8EFF5A: 5C D0 FD 88
unused008E:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFF5E
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFF6E
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFF7E
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFF8E
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFF9E
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFFAE
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFFBE
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFFCE
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFFDE
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00		; $8EFFEE
	db $00,$00		; $8EFFFE
