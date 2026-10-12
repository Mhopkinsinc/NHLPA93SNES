checkob:		;bring up little warning ref if a player on your team is over blue line. Called from doinput and asspuckc
		;   SNES: bring up the little warning ref if a player on your team is over the blue line. Called from doinput and asspuckc
	lda.w gmode
	bit.w #gmoffs		; offsides off: nothing to do
	bne .offon
	jmp.w .rts
.offon:		;movem d0-d1/a0 to the stack
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea
	ldx.b xsave
	lda.w #$0005
	sta.b d0
	stz.b a0
	cpx.w #$000C		; a0 = first object of the own team
	bcc .0
	lda.w #$000C
	sta.b a0
.0:		;d1 = blue line y ($5C), negated for the bottom goal
	lda.w #$5C		; blue line y
	sta.b d1
	lda.w pfgoal,x
	bne .top
	lda.w #-$5C
	sta.b d1
	sec
	sbc.w pucky		; puck not in this zone: no offside
	beq .bottom
	bmi .v1
	bvs .bottom
	bra .nob
.v1:
	bvs .nob
.bottom:		;any teammate below the blue line?
	ldy.b a0
	lda.w position,y
	bmi .bn
	lda.b d1
	sec
	sbc.w Ypos,y
	beq .bn
	bmi .v2
	bvs .bn
	bra .ob
.v2:
	bvs .ob
.bn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .bottom
.nob:		;no player offside: clear the offside signal, ref away
	lda.w #$0040		; d0 = $40
	sta.b d0
	lda.w #sf2offsig
	trb.w sflags		; sf2offsig
	bne .dref
.ex:		;movem the registers back
	stx.b xsave
	ldx.w #$0002
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rts:
	rtl
.ob:		;offside: set the signal, ref up
	lda.w #$0006		; d0 = 6
	sta.b d0
	lda.w #sf2offsig
	tsb.w sflags
	bne .ex
.dref:
	lda.w RefCnt		; ref idle? then bring him up
	bpl .ex
	jsl.l PushRef
	bra .ex
.top:
	lda.b d1
	sec
	sbc.w pucky
	bmi .v3
	bvc .top1
	bra .nob
.v3:
	bvc .nob
.top1:
	ldy.b a0
	lda.w position,y
	bmi .tn
	lda.b d1
	sec
	sbc.w Ypos,y
	bmi .v4
	bvc .tn
	bra .ob
.v4:
	bvc .ob
.tn:
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .top1
	bra .nob
