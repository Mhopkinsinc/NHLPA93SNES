CompLine:		;find good line for comp to switch to. a2 = team, a1 = other team. Called from chk4lc and puckfaceoff
		;   SNES: the computer team picks a line by the man advantage, the score late in the game and the line energies (getlinee)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
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
	lda.w #$0003
	sta.b d0
	ldy.b a2
	lda.w tmap,y
	ldy.b a1
	cmp.w tmap,y
	beq .nopwr
	bpl .0
	inc.b d0
	inc.b d0
.0:
	lda.b d0
	pha
	jsl.l getlinee
	lda.b d0
	sta.b d1
	lda.b $01,s
	inc a
	sta.b d0
	jsl.l getlinee
	lda.b d1
	sec
	sbc.b d0
	bmi .d1neg
	bvs .vs
	bra .1
.d1neg:
	bvs .1
.vs:
	pla
	inc a
	pha
.1:
	pla
	ldy.b a2
	sta.w tmline,y
.ex:
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
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.nopwr:
	ldy.b a2
	bne .away
	lda.w #$0002
	sta.b d1
	lda.w #.hl1
	sta.b a0
	lda.w #.hl1>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .h0
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .h0
	php
	lda.w #.ahead
	sta.b a0
	plp
	bpl .h0
	lda.w #.behind
	sta.b a0
.h0:
	ldy.b a1
	lda.w tmline,y
	asl a
	sta.b d1
	tay
	lda.b [a0],y
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0C01
	bcc .away
	ldy.b d1
	lda.b [a0],y
	ldy.b a2
	sta.w tmline,y
	bra .ex
.hl1:		;CompLine tables: next line by tmline, score tied (7 words)
	dw 0,1,2,0,1,0,1
.ahead:		;ahead in the third period
	dw 2,0,1,2,0,2,0
.behind:		;behind in the third period
	dw 0,1,0,0,1,0,1
.away:
	lda.w #$0002
	sta.b d1
	lda.w #.al1
	sta.b a0
	lda.w #.al1>>16
	sta.b a0+2
	lda.w gsp
	cmp.w #$0002
	bne .a0
	ldy.b a2
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .a0
	php
	lda.w #.ahead2
	sta.b a0
	plp
	bpl .a0
	lda.w #.behind2
	sta.b a0
.a0:
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0F34
	bcs .got
	dec.b d1
	bpl .a0
.got:
	dec.b a0
	dec.b a0
	ldy.b a2
	lda.b [a0]
	sta.w tmline,y
	jmp.w .ex
.al1:		;the lines tried on a power play / penalty kill (3 words each)
	dw 0,1,2
.ahead2:
	dw 0,2,1
.behind2:
	dw 0,1,0
