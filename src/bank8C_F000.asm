; $8CF000-$8CFFFF  ROM $67000-$67FFF: the last SpriteSet0 tiles, checksso (video93_2: off-screen player arrows), chk4pass (logic93_3),
; $FF fill.
org $8CF000
	incbin "../data/Sprites/set00.chr":$63E6..$7000		; $8CF000-$8CFC19
SpriteSet0End:
	assert SpriteSet0End-SpriteSet0 == $7C0+896*32
checksso:		;auto: CODE_8CFC1A (from setvideo). 93G checksso (video93_2): arrows for the two pad players when they are off screen (SNES also on the horizontal rink); falls into .ca for player 2
	lda.w #2		; $8CFC1A: A9 02 00  player 1: ffo 1, sso 0, SPFarrow
	sta.b a0		; $8CFC1D: 85 33
	stz.b a3		; $8CFC1F: 64 3F
	lda.w #SPFarrow		; $8CFC21: A9 80 01
	sta.b d3		; $8CFC24: 85 5F
	jsl.l .ca		; $8CFC26: 22 3C FC 8C
	inc.b a0		; $8CFC2A: E6 33
	inc.b a0		; $8CFC2C: E6 33
	inc.b a3		; $8CFC2E: E6 3F
	inc.b a3		; $8CFC30: E6 3F
	lda.w #SPFarrow+3		; $8CFC32: A9 83 01  player 2: SPFarrow+3
	sta.b d3		; $8CFC35: 85 5F
	jsl.l .ca		; $8CFC37: 22 3C FC 8C
.rtl:
	rtl		; $8CFC3B: 6B
.ca:		;93G .ca: a0 = pad object (ffo index), a3 = sso, d3 = first arrow frame
	ldy.b a0		; $8CFC3C: A4 33
	lda.w ffoz,y		; $8CFC3E: B9 28 01
	bmi .rtl		; $8CFC41: 30 F8
	ldx.b a3		; $8CFC43: A6 3F
	lda.w #$FFFF		; $8CFC45: A9 FF FF  frame -1: no arrow
	sta.w ssoframe,x		; $8CFC48: 9D B3 08
	lda.w ffox,y		; $8CFC4B: B9 14 01
	sta.b d0		; $8CFC4E: 85 53
	lda.w ffoy,y		; $8CFC50: B9 1E 01
	sta.b d1		; $8CFC53: 85 57
	lda.w sfhormode		; $8CFC55: AD 8E 12
	beq .nhor		; $8CFC58: F0 13
	lda.b d1		; $8CFC5A: A5 57  horizontal rink: x = -y, y = x - $C5
	eor.w #$FFFF		; $8CFC5C: 49 FF FF
	inc a		; $8CFC5F: 1A
	sta.b d0		; $8CFC60: 85 53
	lda.w ffox,y		; $8CFC62: B9 14 01
	sec		; $8CFC65: 38
	sbc.w #$C5		; $8CFC66: E9 C5 00
	sta.b d1		; $8CFC69: 85 57
	bra .hord		; $8CFC6B: 80 10
.nhor:
	lda.b d0		; $8CFC6D: A5 53
	sec		; $8CFC6F: 38
	sbc.w Hpos		; $8CFC70: ED 54 01
	sta.b d0		; $8CFC73: 85 53
	lda.b d1		; $8CFC75: A5 57
	sec		; $8CFC77: 38
	sbc.w Vpos		; $8CFC78: ED DF 08
	sta.b d1		; $8CFC7B: 85 57
.hord:		;d2 = off-screen directions as joystick bits
	stz.b d2		; $8CFC7D: 64 5B
	lda.b d0		; $8CFC7F: A5 53
	sec		; $8CFC81: 38
	sbc.w #116		; $8CFC82: E9 74 00  right of the screen
	bmi .r0		; $8CFC85: 30 04
	bvc .rb		; $8CFC87: 50 04
	bra .zero		; $8CFC89: 80 07
.r0:
	bvc .zero		; $8CFC8B: 50 05
.rb:
	lda.w #8		; $8CFC8D: A9 08 00
	sta.b d2		; $8CFC90: 85 5B
.zero:		;93G .0
	lda.b d0		; $8CFC92: A5 53
	sec		; $8CFC94: 38
	sbc.w #-116		; $8CFC95: E9 8C FF  left
	beq .lb		; $8CFC98: F0 08
	bmi .l0		; $8CFC9A: 30 04
	bvs .lb		; $8CFC9C: 70 04
	bra .one		; $8CFC9E: 80 07
.l0:
	bvs .one		; $8CFCA0: 70 05
.lb:
	lda.w #4		; $8CFCA2: A9 04 00
	tsb.b d2		; $8CFCA5: 04 5B
.one:		;93G .1
	lda.b d1		; $8CFCA7: A5 57
	sec		; $8CFCA9: 38
	sbc.w #100		; $8CFCAA: E9 64 00  above
	bmi .u0		; $8CFCAD: 30 04
	bvc .ub		; $8CFCAF: 50 04
	bra .two		; $8CFCB1: 80 04
.u0:
	bvc .two		; $8CFCB3: 50 02
.ub:
	inc.b d2		; $8CFCB5: E6 5B
.two:		;93G .2
	lda.b d1		; $8CFCB7: A5 57
	sec		; $8CFCB9: 38
	sbc.w #-100		; $8CFCBA: E9 9C FF  below
	beq .db		; $8CFCBD: F0 08
	bmi .d0		; $8CFCBF: 30 04
	bvs .db		; $8CFCC1: 70 04
	bra .three		; $8CFCC3: 80 06
.d0:
	bvs .three		; $8CFCC5: 70 04
.db:
	inc.b d2		; $8CFCC7: E6 5B
	inc.b d2		; $8CFCC9: E6 5B
.three:		;93G .3
	ldx.b d2		; $8CFCCB: A6 5B  on screen: no arrow
	bne .off		; $8CFCCD: D0 03
	jmp.w .rtl		; $8CFCCF: 4C 3B FC
.off:
	lda.l $8F901A,x		; $8CFCD2: BF 1A 90 8F  jdtab ($8F901A): direction 0-7
	and.w #$00FF		; $8CFCD6: 29 FF 00
	asl a		; $8CFCD9: 0A
	asl a		; $8CFCDA: 0A
	asl a		; $8CFCDB: 0A
	tax		; $8CFCDC: AA
	lda.l .tab,x		; $8CFCDD: BF 43 FD 8C  .tab: x spot (0 = keep), y spot, frame add, flip bits
	beq .four		; $8CFCE1: F0 02
	sta.b d0		; $8CFCE3: 85 53
.four:		;93G .4
	lda.b d0		; $8CFCE5: A5 53
	clc		; $8CFCE7: 18
	adc.w #$0100		; $8CFCE8: 69 00 01
	ldy.b a3		; $8CFCEB: A4 3F
	sta.w ssox,y		; $8CFCED: 99 C3 08
	lda.l .tab+2,x		; $8CFCF0: BF 45 FD 8C
	beq .five		; $8CFCF4: F0 02
	sta.b d1		; $8CFCF6: 85 57
.five:		;93G .5
	lda.b d1		; $8CFCF8: A5 57
	eor.w #$FFFF		; $8CFCFA: 49 FF FF
	inc a		; $8CFCFD: 1A
	clc		; $8CFCFE: 18
	adc.w #$00F0		; $8CFCFF: 69 F0 00
	sta.w ssoy,y		; $8CFD02: 99 CB 08
	lda.b d3		; $8CFD05: A5 5F
	clc		; $8CFD07: 18
	adc.l .tab+4,x		; $8CFD08: 7F 47 FD 8C
	sta.w ssoframe,y		; $8CFD0C: 99 B3 08
	lda.l .tab+6,x		; $8CFD0F: BF 49 FD 8C
	sta.w ssoattr,y		; $8CFD13: 99 AB 08
	ldx.b a3		; $8CFD16: A6 3F
	lda.w ssox,x		; $8CFD18: BD C3 08
	sec		; $8CFD1B: 38
	sbc.w #$0080		; $8CFD1C: E9 80 00
	sta.b sprx		; $8CFD1F: 85 C9
	lda.w ssoy,x		; $8CFD21: BD CB 08
	sec		; $8CFD24: 38
	sbc.w #$0080		; $8CFD25: E9 80 00
	sta.b spry		; $8CFD28: 85 CB
	lda.w ssoframe,x		; $8CFD2A: BD B3 08
	sta.b sprframe		; $8CFD2D: 85 C3
	lda.w ssoattr,x		; $8CFD2F: BD AB 08
	and.w #attrxflip		; $8CFD32: 29 00 08
	sta.b sprhflip		; $8CFD35: 85 A5
	lda.w ssoattr,x		; $8CFD37: BD AB 08
	and.w #$1000		; $8CFD3A: 29 00 10
	sta.b sprvflip		; $8CFD3D: 85 CD
	jml.l $8FEC68		; $8CFD3F: 5C 68 EC 8F  addframe2, bank $8F: 93G addframe2
.tab:		;93G checksso .tab: x spot, y spot, frame add, flip bits per direction (.xspot 116, .yspot 100)
	dw 0,100,0,$0000		; $8CFD43
	dw 116,100,1,$0000		; $8CFD4B
	dw 116,0,2,$0000		; $8CFD53
	dw 116,-100,1,$1000		; $8CFD5B
	dw 0,-100,0,$1000		; $8CFD63
	dw -116,-100,1,$1800		; $8CFD6B
	dw -116,0,2,$0800		; $8CFD73
	dw -116,100,1,$0800		; $8CFD7B
chk4pass:		;auto: CODE_8CFD83. 93G chk4pass (logic93_3): computer player X looks for a good pass: a random team mate, onside, ahead of the blue line rule, no opponent in the lane; then dopass and
		;   assexit
	lda.w threat		; $8CFD83: AD D3 08  no threat: pass only now and then (spodds)
	bne .dp0		; $8CFD86: D0 13
	lda.w #16		; $8CFD88: A9 10 00
	clc		; $8CFD8B: 18
	adc.w spodds,x		; $8CFD8C: 7D 5F 10
	jsl.l randoma		; $8CFD8F: 22 8B AE 80
	cmp.w #9		; $8CFD93: C9 09 00
	bcc .dp0		; $8CFD96: 90 03
	jmp.w .rtl		; $8CFD98: 4C 15 FF
.dp0:
	lda.w #6		; $8CFD9B: A9 06 00
	jsl.l randoma		; $8CFD9E: 22 8B AE 80
	sta.b d0		; $8CFDA2: 85 53
	cpx.w #12		; $8CFDA4: E0 0C 00  team mates of the away team are 6-11
	bcc .dp1		; $8CFDA7: 90 08
	lda.b d0		; $8CFDA9: A5 53
	clc		; $8CFDAB: 18
	adc.w #6		; $8CFDAC: 69 06 00
	sta.b d0		; $8CFDAF: 85 53
.dp1:
	lda.w position,x		; $8CFDB1: BD 9F 0B  not the goalie: only outside the slot
	beq .bl		; $8CFDB4: F0 25
	lda.w puckx		; $8CFDB6: AD 1B 09
	bit.w #$8000		; $8CFDB9: 89 00 80
	beq .ax		; $8CFDBC: F0 04
	eor.w #$FFFF		; $8CFDBE: 49 FF FF
	inc a		; $8CFDC1: 1A
.ax:
	cmp.w #41		; $8CFDC2: C9 29 00
	bcs .bl		; $8CFDC5: B0 14
	lda.w pucky		; $8CFDC7: AD 7B 09
	bit.w #$8000		; $8CFDCA: 89 00 80
	beq .ay		; $8CFDCD: F0 04
	eor.w #$FFFF		; $8CFDCF: 49 FF FF
	inc a		; $8CFDD2: 1A
.ay:
	cmp.w #205		; $8CFDD3: C9 CD 00
	bcc .bl		; $8CFDD6: 90 03
	jmp.w .rtl		; $8CFDD8: 4C 15 FF
.bl:
	asl.b d0		; $8CFDDB: 06 53  not to himself
	cpx.b d0		; $8CFDDD: E4 53
	bne .b1		; $8CFDDF: D0 03
	jmp.w .rtl		; $8CFDE1: 4C 15 FF
.b1:
	ldy.b d0		; $8CFDE4: A4 53
	sty.b a0		; $8CFDE6: 84 33
	lda.w position,y		; $8CFDE8: B9 9F 0B  not to the goalie or an illegal player
	bne .b2		; $8CFDEB: D0 03
	jmp.w .rtl		; $8CFDED: 4C 15 FF
.b2:
	bpl .b3		; $8CFDF0: 10 03
	jmp.w .rtl		; $8CFDF2: 4C 15 FF
.b3:
	lda.w pflags,y		; $8CFDF5: B9 DF 0E  not unavailable or locked
	and.w #$1000		; $8CFDF8: 29 00 10
	ora.w pfalock,y		; $8CFDFB: 19 7F 11
	beq .b4		; $8CFDFE: F0 03
	jmp.w .rtl		; $8CFE00: 4C 15 FF
.b4:
	lda.w Ypos,y		; $8CFE03: B9 5F 09
	sta.b d0		; $8CFE06: 85 53
	lda.w Ypos,x		; $8CFE08: BD 5F 09
	sta.b d1		; $8CFE0B: 85 57
	lda.w pfgoal,x		; $8CFE0D: BD 3F 11
	bne .f0		; $8CFE10: D0 10
	lda.b d0		; $8CFE12: A5 53
	eor.w #$FFFF		; $8CFE14: 49 FF FF
	inc a		; $8CFE17: 1A
	sta.b d0		; $8CFE18: 85 53
	lda.b d1		; $8CFE1A: A5 57
	eor.w #$FFFF		; $8CFE1C: 49 FF FF
	inc a		; $8CFE1F: 1A
	sta.b d1		; $8CFE20: 85 57
.f0:
	lda.w gmode		; $8CFE22: AD 88 12  offsides: no pass across the blue line
	bit.w #gmoffs		; $8CFE25: 89 20 00
	beq .oko		; $8CFE28: F0 15
	lda.b d0		; $8CFE2A: A5 53
	sec		; $8CFE2C: 38
	sbc.w #88		; $8CFE2D: E9 58 00
	sta.b tmp0		; $8CFE30: 85 73
	lda.b d1		; $8CFE32: A5 57
	sec		; $8CFE34: 38
	sbc.w #88		; $8CFE35: E9 58 00
	eor.b tmp0		; $8CFE38: 45 73
	bpl .oko		; $8CFE3A: 10 03
	jmp.w .rtl		; $8CFE3C: 4C 15 FF
.oko:
	lda.b d0		; $8CFE3F: A5 53  beyond the blue line, or not more than 15 back
	sec		; $8CFE41: 38
	sbc.w #88		; $8CFE42: E9 58 00
	beq .le		; $8CFE45: F0 08
	bmi .lt		; $8CFE47: 30 04
	bvs .le		; $8CFE49: 70 04
	bra .ok		; $8CFE4B: 80 16
.lt:
	bvs .ok		; $8CFE4D: 70 14
.le:
	lda.b d0		; $8CFE4F: A5 53
	sec		; $8CFE51: 38
	sbc.b d1		; $8CFE52: E5 57
	sta.b d0		; $8CFE54: 85 53
	sec		; $8CFE56: 38
	sbc.w #-15		; $8CFE57: E9 F1 FF
	bmi .lt2		; $8CFE5A: 30 05
	bvc .ok		; $8CFE5C: 50 05
.no:
	jmp.w .rtl		; $8CFE5E: 4C 15 FF
.lt2:
	bvc .no		; $8CFE61: 50 FB
.ok:
	lda.w Ypos,y		; $8CFE63: B9 5F 09  passdir, d2 = distance squared
	sec		; $8CFE66: 38
	sbc.w pucky		; $8CFE67: ED 7B 09
	sta.b d1		; $8CFE6A: 85 57
	pha		; $8CFE6C: 48
	lda.w Xpos,y		; $8CFE6D: B9 FF 08
	sec		; $8CFE70: 38
	sbc.w puckx		; $8CFE71: ED 1B 09
	sta.b d0		; $8CFE74: 85 53
	pha		; $8CFE76: 48
	jsl.l vtoa		; $8CFE77: 22 A8 AF 80
	sta.w passdir		; $8CFE7B: 8D 3B 04
	pla		; $8CFE7E: 68
	sta.b mula		; $8CFE7F: 85 7D
	sta.b mulb		; $8CFE81: 85 83
	jsl.l muls32		; $8CFE83: 22 DB FC 82
	sta.b d2		; $8CFE87: 85 5B
	lda.b mulres+2		; $8CFE89: A5 95
	sta.b d2+2		; $8CFE8B: 85 5D
	pla		; $8CFE8D: 68
	sta.b mula		; $8CFE8E: 85 7D
	sta.b mulb		; $8CFE90: 85 83
	jsl.l muls32		; $8CFE92: 22 DB FC 82
	adc.b d2		; $8CFE96: 65 5B
	sta.b d2		; $8CFE98: 85 5B
	lda.b mulres+2		; $8CFE9A: A5 95
	adc.b d2+2		; $8CFE9C: 65 5D
	sta.b d2+2		; $8CFE9E: 85 5D
	lda.w #5		; $8CFEA0: A9 05 00  the 6 opponents
	sta.b d3		; $8CFEA3: 85 5F
	stz.b a1		; $8CFEA5: 64 37
	cpx.w #12		; $8CFEA7: E0 0C 00
	bcs .co0		; $8CFEAA: B0 05
	lda.w #12		; $8CFEAC: A9 0C 00
	sta.b a1		; $8CFEAF: 85 37
.co0:
	ldy.b a1		; $8CFEB1: A4 37
	lda.w Ypos,y		; $8CFEB3: B9 5F 09
	sec		; $8CFEB6: 38
	sbc.w pucky		; $8CFEB7: ED 7B 09
	sta.b d1		; $8CFEBA: 85 57
	lda.w Xpos,y		; $8CFEBC: B9 FF 08
	sec		; $8CFEBF: 38
	sbc.w puckx		; $8CFEC0: ED 1B 09
	sta.b d0		; $8CFEC3: 85 53
	sta.b mula		; $8CFEC5: 85 7D
	sta.b mulb		; $8CFEC7: 85 83
	jsl.l muls32		; $8CFEC9: 22 DB FC 82
	sta.b tmp0		; $8CFECD: 85 73
	lda.b mulres+2		; $8CFECF: A5 95
	sta.b tmp1		; $8CFED1: 85 75
	lda.b d1		; $8CFED3: A5 57
	sta.b mula		; $8CFED5: 85 7D
	sta.b mulb		; $8CFED7: 85 83
	jsl.l muls32		; $8CFED9: 22 DB FC 82
	adc.b tmp0		; $8CFEDD: 65 73
	sta.b tmp0		; $8CFEDF: 85 73
	lda.b mulres+2		; $8CFEE1: A5 95
	adc.b tmp1		; $8CFEE3: 65 75
	sta.b tmp1		; $8CFEE5: 85 75
	lda.b d2		; $8CFEE7: A5 5B
	cmp.b tmp0		; $8CFEE9: C5 73
	lda.b d2+2		; $8CFEEB: A5 5D
	sbc.b tmp1		; $8CFEED: E5 75
	bcc .co1		; $8CFEEF: 90 09
	jsl.l vtoa		; $8CFEF1: 22 A8 AF 80  nearer opponent in the lane: no pass
	cmp.w passdir		; $8CFEF5: CD 3B 04
	beq .rtl		; $8CFEF8: F0 1B
.co1:
	inc.b a1		; $8CFEFA: E6 37
	inc.b a1		; $8CFEFC: E6 37
	dec.b d3		; $8CFEFE: C6 5F
	bpl .co0		; $8CFF00: 10 AF
	jsl.l $8FE458		; $8CFF02: 22 58 E4 8F  93G dopass, bank $8F: 93G dopass
	lda.w position,x		; $8CFF06: BD 9F 0B
	beq .rtl		; $8CFF09: F0 0A
	pla		; $8CFF0B: 68  drop the return address (3 bytes): assexit returns for the caller
	sep #$20		; $8CFF0C: E2 20
	pla		; $8CFF0E: 68
	rep #$30		; $8CFF0F: C2 30
	jml.l assexit		; $8CFF11: 5C F9 96 80
.rtl:
	rtl		; $8CFF15: 6B
unusedFF8C:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF16
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF26
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF36
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF46
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF56
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF66
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF76
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF86
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFF96
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFA6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFB6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFC6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFD6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFE6
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF		; $8CFFF6
