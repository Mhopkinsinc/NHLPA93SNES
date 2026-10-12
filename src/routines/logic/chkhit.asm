chkhit:		;part of fight to see if player is hit
		;   SNES: part of the fight, is player X hit by opponent a0?
	stx.b xsave
	ldx.w #$0000
.save:		;movem d0/a0-a3 to the stack
	lda.b d0,x
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
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	ldy.b a0		; Y = opponent
	lda.w frame,x
	cmp.w oldframe,x		; same frame as last time: nothing new
	beq .ex
	cmp.w #SPFfight+2		; gloves dropped frame
	beq .dropped
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	bit.w #$8000
	beq .dx
	eor.w #$FFFF
	inc a
.dx:
	cmp.w #$0017		; within 22 in x
	bcs .ex
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	bit.w #$8000
	beq .dy
	eor.w #$FFFF
	inc a
.dy:
	cmp.w #$0009		; within 8 in y
	bcs .ex
	lda.w frame,x
	cmp.w #SPFfight+6		; high punch frames
	bne .1
	jmp.w .hithigh
.1:
	cmp.w #SPFfight+6+5
	bne .2
	jmp.w .hithigh
.2:
	cmp.w #SPFfight+7		; low punch frames
	bne .3
	jmp.w .hitlow
.3:
	cmp.w #SPFfight+7+5
	bne .4
	jmp.w .hitlow
.4:
	cmp.w #SPFfight+4		; grab frames
	beq .grab
	cmp.w #SPFfight+4+5
	beq .grab
.ex:		;movem the registers back (global: CwdFight/FightFall paths jump here)
	stx.b xsave
	ldx.w #$000E
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
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3		; X = a3 again
	rtl
.dropped:		;gloves dropped, glovecords from xc1/yc1 (x clamped +-90)
	lda.w pflags,x
	and.w #~pf2npc&$FFFF		; clear pf2npc: gloves dropped
	sta.w pflags,x
	lda.w xc1
	sta.b d0
	sec
	sbc.w #$005A
	bmi .neg
	bvc .cl1
	bra .chkneg
.neg:
	bvc .chkneg
.cl1:
	lda.w #$005A
	sta.b d0
.chkneg:
	lda.b d0
	sec
	sbc.w #$FFA6
	beq .cl2
	bmi .neg1
	bvs .cl2
	bra .drcont
.neg1:
	bvs .drcont
.cl2:
	lda.w #$FFA6
	sta.b d0
.drcont:
	lda.b d0
	lsr a
	lsr a
	and.w #$00FF
	bne .dr0
	inc a
.dr0:
	sta.w glovecords		; glovecords x byte (0 becomes 1)
	lda.w yc1
	lsr a
	lsr a
	sep #$20
	sta.w glovecords+1		; glovecords y byte
	rep #$30
	bra .ex
.grab:		;exg a0,a3: the opponent is held
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	lda.w #SPAfheld
	sta.b d1
	sta.w pf2aip,x
	jsl.l SetSPA
	jmp.w .ex
.hithigh:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001		; pf2aip
	sta.w pf2aip,x
	dec.w temp3,x		; strength -1; out of strength: falls
	bmi FightFall
	lda.w #SPAfhith
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhithigh
	pha
	jsl.l sfx
	jmp.w .ex
.hitlow:
	ldx.b a0
	ldy.b a3
	stx.b a3
	sty.b a0
	jsl.l CwdFight
	lda.w #$0001
	sta.w pf2aip,x
	dec.w temp3,x
	bmi FightFall
	lda.w #SPAfhitl
	sta.b d1
	jsl.l SetSPA
	lda.w #SFXhitlow
	pha
	jsl.l sfx
	jmp.w .ex
