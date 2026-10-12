wallcoll:		;Bounce object X off a wall: the puck loses speed and spins; a hard hit makes a sound
	lda.b d0		; Wallcos/Wallsin
	sta.w Wallcos,x
	lda.b d1
	sta.w Wallsin,x
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d2,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.b d1		; v1n = (Yvel*cos - Xvel*sin)/256, negated; v1t = (Xvel*cos + Yvel*sin)/256
	pha
	lda.b d0
	pha
	sta.b mulb
	lda.w Yvel,x
	sta.b mula
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Xvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d0
	sec
	sbc.b mulres
	sta.b d0
	lda.b d0+2
	sbc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	eor.w #$FFFF
	inc a
	sta.b d2
	lda.w Xvel,x
	sta.b mula
	lda.b $01,s
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.w Yvel,x
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b d0+2
	adc.b mulres+2
	sta.b d0+2
	lda.b d0+1
	sta.b d3
	cpx.w #$001C
	beq .puck
	jmp.w .player
.puck:
	lda.w #sf2shot		; puck: clear sf2shot
	trb.w sflags
	lda.b d2		; moving away from the wall
	bmi .pn
	jmp.w .nocoll
.pn:
	lsr a		; normal speed /4
	lsr a
	bit.w #$2000
	beq .pn1
	ora.w #$C000
.pn1:
	sta.b d2
	sec
	sbc.w #$FC00		; hard hit (v1n <= -$400): pop up, flip, sound by speed
	beq .hard
	bmi .neg
	bvs .hard
	bra .pok
.neg:
	bvs .pok
.hard:
	lda.w #$0800
	jsl.l randoma
	eor.w #$FFFF
	inc a
	sta.w puckvz
	sta.b d0
	jsl.l puckflip
	lda.w #SFXpuckwall1
	pha
	lda.b d2
	sec
	sbc.w #$EE00
	bmi .neg1
	bvc .s2
	bra .snd
.neg1:
	bvc .snd
.s2:
	pla
	lda.w #SFXpuckwall1+1
	pha
	lda.b d2
	sec
	sbc.w #$F800
	bmi .neg2
	bvc .s3
	bra .snd
.neg2:
	bvc .snd
.s3:
	pla
	lda.w #SFXpuckwall1+2
	pha
.snd:
	jsl.l sfx
.pok:		;reduce the tangent speed of the puck
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .t1
	ora.w #$FC00
.t1:
	sta.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	lda.b d3
	sec
	sbc.b d0
	sec
	sbc.b d0+2
	sta.b d3
	bra .noadd
.player:
	lda.b d2
	sec
	sbc.w #$03E8		; player: v1n > 1000: no collision
	beq .p1
	bmi .neg3
	bvs .p1
.nocoll1:
	jmp.w .nocoll
.neg3:
	bvs .nocoll1
.p1:
	lda.b d2
	sec
	sbc.w #$F000		; v1n <= -$1000 and impact >= 10: board sound
	beq .imp
	bmi .neg4
	bvs .imp
	bra .nosfx
.neg4:
	bvs .nosfx
.imp:
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .neg5
	bvc .psnd
	bra .nosfx
.neg5:
	bvc .nosfx
.psnd:
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXplayerwall
	pha
	jsl.l sfx
.nosfx:
	lda.b d2
	lsr a
	lsr a
	bit.w #$2000
	beq .n1
	ora.w #$C000
.n1:
	sta.b d2
	sec
	sbc.w #$FC7C		; v1n >= -900: -1000
	bmi .neg6
	bvc .min
	bra .noadd
.neg6:
	bvc .noadd
.min:
	lda.w #$FC18
	sta.b d2
.noadd:		;rotate back: new Xvel/Yvel
	lda.b $01,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b $03,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	lda.b tmp0
	sec
	sbc.b mulres
	sta.b tmp0
	lda.b tmp1
	sbc.b mulres+2
	sta.b tmp1
	lda.b tmp0+1
	sta.w Xvel,x
	lda.b $03,s
	sta.b mula
	lda.b d3
	sta.b mulb
	jsl.l muls32
	sta.b d3
	lda.b mulres+2
	sta.b d3+2
	lda.b $01,s
	sta.b mula
	lda.b d2
	sta.b mulb
	jsl.l muls32
	adc.b d3
	sta.b d3
	lda.b d3+2
	adc.b mulres+2
	sta.b d3+2
	lda.b d3+1
	sta.w Yvel,x
	lda.w Zvel,x		; moving up: Zvel = 0
	bmi .nocoll
	stz.w Zvel,x
.nocoll:
	pla
	pla
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d2,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
