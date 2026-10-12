setpersonel:		;this will set personel on team a2 according to team a2's registers
		;   SNES: set the personel of team a2 from SetPlList: keep the players already on the ice, place the rest
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0018
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .savea
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #$0005
	sta.b d4
.l0:
	lda.w #$FFFF		; newpos = newpnum = -1 for the 6 objects
	sta.w newpos,x
	sta.w newpnum,x
	inx
	inx
	stx.b a3
	dec.b d4
	bpl .l0
	jsl.l SetPlList
	lda.w #$0005
	sta.b d4
	lda.w #PlList		; a4 = PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.1:		;wanted players already on the ice keep their object
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.2:
	inx
	inx
	stx.b a3
	lda.w pnum,x
	and.w #$00FF
	sta.b tmp0
	lda.b d5
	and.w #$00FF
	cmp.b tmp0
	beq .found
	dec.b d3
	bpl .2
	bra .next
.found:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np
	ora.w #$FF00
.np:
	sta.w newpos,x
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn
	ora.w #$FF00
.npn:
	sta.w newpnum,x
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next:
	dec.b d4
	bpl .1
	lda.w #$0005
	sta.b d4
	lda.w #PlList
	sta.b a4
	lda.w #PlList>>16
	sta.b a4+2
.3:		;the rest go to objects with no requested player
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d5
	beq .next2
	dec.b d5
	lda.w #$0005
	sta.b d3
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.4:
	inx
	inx
	stx.b a3
	lda.w newpnum,x
	bit.w #$0080
	bne .free
	dec.b d3
	bpl .4
	bra .chkpos
.free:
	stx.b a0
.chkpos:
	lda.w position,x
	bpl .put
	dec.b d3
	bpl .4
.put:
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	bit.w #$0080
	beq .np2
	ora.w #$FF00
.np2:
	ldy.b a0
	sta.w newpos,y
	lda.b d5
	and.w #$00FF
	bit.w #$0080
	beq .npn2
	ora.w #$FF00
.npn2:
	sta.w newpnum,y
	ldy.b d4
	sep #$20
	lda.b #$00
	sta.b [a4],y
	rep #$20
.next2:
	dec.b d4
	bpl .3
	stx.b xsave
	ldx.w #$0012
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0016
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
