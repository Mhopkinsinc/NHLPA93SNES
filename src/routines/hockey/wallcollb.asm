wallcollb:		;check for puck over wall. a3 = object, d0/d1 = cos/sin of the wall. Called from checkwallcoll
		;   SNES: object X hits a wall (d0/d1 = cos/sin). The puck may go over the glass; otherwise wallcoll
	cpx.w #$001C		; not the puck: wallcoll
	beq .puck
	jmp.w wallcoll
.puck:
	lda.w Zpos+puckobj
	sec
	sbc.w #$0020		; Zpos > 32: over
	beq .z1
	bmi .v1
	bvs .z1
	bra .0
.v1:
	bvs .0
.z1:
	lda.w Zpos+puckobj
	cmp.w #$0016		; Zpos <= 21: wallcoll
	bcs .y280
	jmp.w wallcoll
.y280:
	lda.w pucky
	sec
	sbc.w #$0112		; y >= 274
	bmi .v2
	bvc .x13
	bra .0
.v2:
	bvc .0
.x13:
	lda.w puckx
	sec
	sbc.w #$000D		; x 13-15 (the goal mouth)
	bmi .v3
	bvc .x15
.wc1:
	jmp.w wallcoll
.v3:
	bvc .wc1
.x15:
	lda.w puckx
	sec
	sbc.w #$000F
	beq .vy
	bmi .v4
	bvs .vy
	bra wallcoll
.v4:
	bvs wallcoll
.vy:
	lda.w puckvy
	sec
	sbc.w #$0FA0		; Yvel >= $FA0
	bmi .v5
	bvc .glass
	bra wallcoll
.v5:
	bvc wallcoll
.glass:		;over the glass at the goal: shadow animation, sound, crowd
	phx
	lda.w puckvy		; halve puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	inx
	inx
	stx.b a3
	lda.w #SPAbglass		; object 15 (shadow): SPAbglass
	sta.b d1
	jsl.l SetSPA
	plx
	stx.b a3
	lda.w #SFXoverglass		; over the glass sound
	pha
	jsl.l sfx
	lda.b crowdlevel		; crowd +600
	clc
	adc.w #$0258
	sta.b crowdlevel
.0:		;puck out of play
	lda.w #sfslock		; sfslock; puck pfnc
	tsb.w sflags
	sta.w pfnc+puckobj
	lda.w pucky		; bottom: y flip
	bpl .1
	lda.w #$8000
	tsb.w attribute+puckobj
.1:
	stz.w frame+$1E		; shadow frame 0
	lda.w gmclock		; clock stopped
	bne .rtl
	lda.w ltplayer		; penalty 6 for the last touch player
	asl a
	sta.b a3
	tax
	lda.w #PenOOP
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #$001C
	stx.b a3
.rtl:
	rtl
