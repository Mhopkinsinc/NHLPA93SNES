AddPenalty2:		;Call penalty d0 on player X without the checks; used for forced calls like face offs and game over
	lda.w sfhormode		; horizontal rink: none
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.b d0
	sec
	sbc.w #$000E		; goal and up
	bmi .neg
	bvc .snd
	bra .nosnd
.neg:
	bvc .nosnd
.snd:		;goal and up: crowd and a sound
	lda.b crowdlevel		; crowd +200
	clc
	adc.w #$00C8
	sta.b crowdlevel
	lda.w #SFXcrowdboo		; home penalized: boo; visitors: cheer
	pha
	lda.w pfteam,x
	beq .sfx
	lda.w #SFXcrowdcheer
	sta.b $01,s
.sfx:
	jsl.l sfx
.nosnd:
	lda.w #PenBuf		; a1 = PenBuf, 32 slots
	sta.b a1
	lda.w #PenBuf>>16
	sta.b a1+2
	lda.w #$001F
	sta.b d1
.find:		;find a free PenBuf slot
	lda.b [a1]
	inc.b a1
	inc.b a1
	tay
	beq .put
	dec.b d1
	bpl .find
	bra .noplayer
.put:
	dec.b a1
	dec.b a1
	txa		; store (SCnum << 8) | penalty
	lsr a
	xba
	and.w #$FF00
	ora.b d0
	sta.b [a1]
	lda.w #PenaltyList>>16		; a0 = PenaltyList + [d0]
	sta.b a0+2
	lda.w #PenaltyList
	sta.b a0
	ldy.b d0
	clc
	adc.b [a0],y
	sta.b a0
	lda.b [a0]		; penalty minutes
	and.w #$00FF
	beq .noplayer
	lda.w pflags,x
	pha
	ora.w #pf2pen		; pf2pen; already set: drop this one
	sta.w pflags,x
	pla
	bit.w #pf2pen
	beq .noplayer
	lda.w #$0000
	sta.b [a1]
.noplayer:
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d1,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
