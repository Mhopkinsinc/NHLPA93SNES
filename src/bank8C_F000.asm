; $8CF000-$8CFFFF  ROM $67000-$67FFF: the last SpriteSet0 tiles, checksso (video93_2: off-screen player arrows), chk4pass (logic93_3),
; $FF fill.
org $8CF000
	incbin "../data/Sprites/set00.chr":$63E6..$7000		; $8CF000-$8CFC19
SpriteSet0End:
	assert SpriteSet0End-SpriteSet0 == $7C0+896*32
checksso:		;93G checksso (video93_2): arrows for the two pad players when they are off screen (SNES also on the horizontal rink); falls into .ca for player 2
	lda.w #2		; player 1: ffo 1, sso 0, SPFarrow
	sta.b a0
	stz.b a3
	lda.w #SPFarrow
	sta.b d3
	jsl.l .ca
	inc.b a0
	inc.b a0
	inc.b a3
	inc.b a3
	lda.w #SPFarrow+3		; player 2: SPFarrow+3
	sta.b d3
	jsl.l .ca
.rtl:
	rtl
.ca:		;93G .ca: a0 = pad object (ffo index), a3 = sso, d3 = first arrow frame
	ldy.b a0
	lda.w ffoz,y
	bmi .rtl
	ldx.b a3
	lda.w #$FFFF		; frame -1: no arrow
	sta.w ssoframe,x
	lda.w ffox,y
	sta.b d0
	lda.w ffoy,y
	sta.b d1
	lda.w sfhormode
	beq .nhor
	lda.b d1		; horizontal rink: x = -y, y = x - $C5
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w ffox,y
	sec
	sbc.w #$C5
	sta.b d1
	bra .hord
.nhor:
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.hord:		;d2 = off-screen directions as joystick bits
	stz.b d2
	lda.b d0
	sec
	sbc.w #116		; right of the screen
	bmi .r0
	bvc .rb
	bra .zero
.r0:
	bvc .zero
.rb:
	lda.w #8
	sta.b d2
.zero:		;93G .0
	lda.b d0
	sec
	sbc.w #-116		; left
	beq .lb
	bmi .neg
	bvs .lb
	bra .one
.neg:
	bvs .one
.lb:
	lda.w #4
	tsb.b d2
.one:		;93G .1
	lda.b d1
	sec
	sbc.w #100		; above
	bmi .u0
	bvc .ub
	bra .two
.u0:
	bvc .two
.ub:
	inc.b d2
.two:		;93G .2
	lda.b d1
	sec
	sbc.w #-100		; below
	beq .db
	bmi .d0
	bvs .db
	bra .three
.d0:
	bvs .three
.db:
	inc.b d2
	inc.b d2
.three:		;93G .3
	ldx.b d2		; on screen: no arrow
	bne .off
	jmp.w .rtl
.off:
	lda.l jdtab8F,x		; jdtab ($8F901A): direction 0-7
	and.w #$00FF
	asl a
	asl a
	asl a
	tax
	lda.l .tab,x		; .tab: x spot (0 = keep), y spot, frame add, flip bits
	beq .four
	sta.b d0
.four:		;93G .4
	lda.b d0
	clc
	adc.w #$0100
	ldy.b a3
	sta.w ssox,y
	lda.l .tab+2,x
	beq .five
	sta.b d1
.five:		;93G .5
	lda.b d1
	eor.w #$FFFF
	inc a
	clc
	adc.w #$00F0
	sta.w ssoy,y
	lda.b d3
	clc
	adc.l .tab+4,x
	sta.w ssoframe,y
	lda.l .tab+6,x
	sta.w ssoattr,y
	ldx.b a3
	lda.w ssox,x
	sec
	sbc.w #$0080
	sta.b sprx
	lda.w ssoy,x
	sec
	sbc.w #$0080
	sta.b spry
	lda.w ssoframe,x
	sta.b sprframe
	lda.w ssoattr,x
	and.w #attrxflip
	sta.b sprhflip
	lda.w ssoattr,x
	and.w #$1000
	sta.b sprvflip
	jml.l addframe		; addframe2, bank $8F: 93G addframe2
.tab:		;93G checksso .tab: x spot, y spot, frame add, flip bits per direction (.xspot 116, .yspot 100)
	dw 0,100,0,$0000
	dw 116,100,1,$0000
	dw 116,0,2,$0000
	dw 116,-100,1,$1000
	dw 0,-100,0,$1000
	dw -116,-100,1,$1800
	dw -116,0,2,$0800
	dw -116,100,1,$0800
chk4pass:		;93G chk4pass (logic93_3): computer player X looks for a good pass: a random team mate, onside, ahead of the blue line rule, no opponent in the lane; then dopass and
		;   assexit
	lda.w threat		; no threat: pass only now and then (spodds)
	bne .dp0
	lda.w #16
	clc
	adc.w spodds,x
	jsl.l randoma
	cmp.w #9
	bcc .dp0
	jmp.w .rtl
.dp0:
	lda.w #6
	jsl.l randoma
	sta.b d0
	cpx.w #12		; team mates of the away team are 6-11
	bcc .dp1
	lda.b d0
	clc
	adc.w #6
	sta.b d0
.dp1:
	lda.w position,x		; not the goalie: only outside the slot
	beq .bl
	lda.w puckx
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #41
	bcs .bl
	lda.w pucky
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #205
	bcc .bl
	jmp.w .rtl
.bl:
	asl.b d0		; not to himself
	cpx.b d0
	bne .b1
	jmp.w .rtl
.b1:
	ldy.b d0
	sty.b a0
	lda.w position,y		; not to the goalie or an illegal player
	bne .b2
	jmp.w .rtl
.b2:
	bpl .b3
	jmp.w .rtl
.b3:
	lda.w pflags,y		; not unavailable or locked
	and.w #$1000
	ora.w pfalock,y
	beq .b4
	jmp.w .rtl
.b4:
	lda.w Ypos,y
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	lda.w pfgoal,x
	bne .f0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.f0:
	lda.w gmode		; offsides: no pass across the blue line
	bit.w #gmoffs
	beq .oko
	lda.b d0
	sec
	sbc.w #88
	sta.b tmp0
	lda.b d1
	sec
	sbc.w #88
	eor.b tmp0
	bpl .oko
	jmp.w .rtl
.oko:
	lda.b d0		; beyond the blue line, or not more than 15 back
	sec
	sbc.w #88
	beq .le
	bmi .lt
	bvs .le
	bra .ok
.lt:
	bvs .ok
.le:
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	sec
	sbc.w #-15
	bmi .lt2
	bvc .ok
.no:
	jmp.w .rtl
.lt2:
	bvc .no
.ok:
	lda.w Ypos,y		; passdir, d2 = distance squared
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	jsl.l vtoa
	sta.w passdir
	pla
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	pla
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d2
	lda.b mulres+2
	adc.b d2+2
	sta.b d2+2
	lda.w #5		; the 6 opponents
	sta.b d3
	stz.b a1
	cpx.w #12
	bcs .co0
	lda.w #12
	sta.b a1
.co0:
	ldy.b a1
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b tmp0
	sta.b tmp0
	lda.b mulres+2
	adc.b tmp1
	sta.b tmp1
	lda.b d2
	cmp.b tmp0
	lda.b d2+2
	sbc.b tmp1
	bcc .co1
	jsl.l vtoa		; nearer opponent in the lane: no pass
	cmp.w passdir
	beq .rtl
.co1:
	inc.b a1
	inc.b a1
	dec.b d3
	bpl .co0
	jsl.l dopass		; 93G dopass, bank $8F: 93G dopass
	lda.w position,x
	beq .rtl
	pla		; drop the return address (3 bytes): assexit returns for the caller
	sep #$20
	pla
	rep #$30
	jml.l assexit
.rtl:
	rtl
unusedFF8C:		;unused, $FF fill to the end of the bank
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
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
