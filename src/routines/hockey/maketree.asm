maketree:		;Build the playoff tree from the seeds and the series wins, then set the controllers
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
	lda.w postarts		; a1 = playoffseats + 16 * postarts
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	lda.w #potree
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #playoffseats
	clc
	adc.b d1
	sta.b a1
	lda.w #playoffseats>>16
	sta.b a1+2
	ldy.w #$000E
	sty.b d2
.first:		;first round: 16 teams from the tree
	lda.b [a1],y
	sta.b [a0],y
	dey
	dey
	bpl .first
	lda.w #potree+16		; winners into potree+16..
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	lda.w WinBits
	sta.b d0
.0:		;winbit picks the team of each pair
	lda.b d0
	and.w #$0001
	sta.b d1
	tay
	sep #$20
	lda.b [a0],y
	sta.b [a1]
	rep #$20
	inc.b a1
	inc.b a0
	inc.b a0
	lsr.b d0
	dec.b d2
	bpl .0
	jsl.l GetShifter		; d1 = games of this round, d2 = first slot
	lda.b d1
	bmi .nogames
	lda.b d2
	asl a
	adc.w #potree
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	stz.b a1
.2:
	ldx.b a1
	stz.w gss1,x
	stz.w gss2,x
	stz.w gsper,x
	lda.w gsflags,x
	and.w #~gsfhl&$FFFF
	sta.w gsflags,x
	jsl.l .sett
	inc.b a1
	inc.b a1
	dec.b d1
	bpl .2
	jsl.l FigureJoy
.nogames:
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
	rtl
.sett:		;series games 2, 3, 5 in tree order, the others flipped (gsftf)
	lda.b bosgames		; bosgames 2, 3, 5
	cmp.w #$0002
	beq .flip
	cmp.w #$0003
	beq .flip
	cmp.w #$0005
	beq .flip
	lda.w gsflags,x
	ora.w #gsftf
	sta.w gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst2,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst1,x
	rtl
.flip:
	lda.w gsflags,x
	and.w #~gsftf&$FFFF
	sta.w gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst1,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst2,x
	rtl
