checkfight:		;Look for the start of a fight between a2 and X after a hard hit; if it starts, both get fighting
		;   penalties and the other players stop to watch
	ldy.b a2
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .neg
	bvc .i2
.ex1:
	jmp.w .rtl
.neg:
	bvc .ex1
.i2:
	lda.w impact,y
	sec
	sbc.w #$000A
	bmi .neg1
	bvc .lock
.ex2:
	jmp.w .rtl
.neg1:
	bvc .ex2
.lock:
	lda.w pfalock,y
	ora.w pfalock,x
	beq .pen
	jmp.w .rtl
.pen:
	lda.w pflags,x
	ora.w pflags,y
	bit.w #pf2pen
	beq .pos1
	jmp.w .rtl
.pos1:
	lda.w position,x
	bne .pos2
	jmp.w .rtl
.pos2:
	lda.w position,y
	bne .clk
	jmp.w .rtl
.clk:
	lda.w gmode		; highlight, clock stopped, the puck fighting
	and.w #gmhl
	ora.w gmclock
	ora.w pf2fight+puckobj
	beq .go
	jmp.w .rtl
.go:
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
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
	ldy.w assnum+puckobj		; puck assignment pfaceoff: no fight
	lda.w asslist+puckobj*4,y
	and.w #$00FF
	cmp.w #pfaceoff
	bne .nofo
	jmp.w .ex
.nofo:
	lda.w #$0028		; d0 = 10 + max(0, 40 - ChkCnt)/4
	sec
	sbc.w ChkCnt
	bpl .pos
	lda.w #$0000
.pos:
	lsr a
	lsr a
	clc
	adc.w #$000A
	sta.b d0
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetInst
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w pf2fight,x
	bne .fight
	jmp.w .ex
.fight:		;clear ChkCnt and the check counts of both teams
	stz.w ChkCnt
	lda.w #$0000
	ldy.w #$0032
.clr:
	sta.w pchecks,y
	dey
	dey
	bpl .clr
	lda.b crowdlevel		; crowd +1000; no pass/shot dir; puckc = X; yc1 = middle; sfslock
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #sfspdir|sfssdir
	trb.w sflags
	ldy.b a2
	txa
	lsr a
	sta.w puckc
	lda.w Ypos,x
	clc
	adc.w Ypos,y
	pha
	asl a
	pla
	ror a
	sta.w yc1
	lda.w #sfslock
	tsb.w sflags
	lda.w #$0002
	sta.b d1
	lda.w Xpos,x
	sta.b d0
	sec
	sbc.w Xpos,y
	bmi .neg2
	bvc .flip
	bra .1
.neg2:
	bvc .1
.flip:
	lda.b d1
	eor.w #$0007
	sta.b d1
.1:		;face each other
	lda.b d1
	sta.w facedir,x
	eor.w #$0007
	sta.b d1
	sta.w facedir,y
	jsl.l .sf
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l .sf
	ldx.w #$0000		; others: afwatch (not unavailable, not fighting, not goalies)
	lda.w #afwatch
	sta.b d0
	lda.w #$000B
	sta.b d1
.0:		;the others watch the fight
	lda.w pflags,x
	and.w #pf2unav
	ora.w pf2fight,x
	bne .next
	lda.w position,x
	beq .next
	jsl.l assinsert
.next:
	inx
	inx
	dec.b d1
	bpl .0
	ldx.w #puckobj		; the puck: pf2fight, pnothing
	lda.w #$0001
	sta.w pf2fight+puckobj
	lda.w #pnothing
	sta.b d0
	jsl.l assinsert
	lda.w #$FFFF
	sta.b collflag
.ex:
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
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.sf:		;start the fight for X against a2
	ldy.b a2		; impactp = a2
	tya
	lsr a
	sta.w impactp,x
	lda.w #PenFight
	sta.b d0
	jsl.l AddPenalty2
	txa		; setd0player
	lsr a
	sta.b d0
	jsl.l setd0player
	lda.w #afight
	sta.b d0
	jsl.l assinsert
	lda.w attribute,x		; Xvel -$400 facing 2, else flipped and +$400
	and.w #$F7FF
	sta.w attribute,x
	lda.w #$FC00
	sta.b d1
	lda.w facedir,x
	cmp.w #$0002
	beq .sf2
	lda.w attribute,x
	ora.w #$0800
	sta.w attribute,x
	lda.w #$0400
	sta.b d1
.sf2:
	lda.b d1
	sta.w Xvel,x
	lda.w pflags,x		; unavailable, no player coll; pf2aip; SPAfight
	ora.w #pf2npc|pf2unav
	sta.w pflags,x
	stz.w pfalock,x
	lda.w #SPAfight
	sta.b d1
	sta.w pf2aip,x
	jmp.w SetSPA
