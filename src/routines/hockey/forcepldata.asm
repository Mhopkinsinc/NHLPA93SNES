forcepldata:		;Face offs: move team a2's players straight to their new positions
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
	ldy.b a2
	lda.w tmsort,y
	sta.b a3
	lda.w #$0005
	sta.b d4
.top:
	ldx.b a3
	lda.w newpos,x		; position = newpos (byte)
	and.w #$00FF
	bit.w #$0080
	beq .pos
	ora.w #$FF00
.pos:
	sta.b d0
	sta.w position,x
	cmp.w #$0000
	bmi .next
	jsl.l Setplass
	ldx.b a3
	lda.w position,x
	cmp.w #$0004		; center
	bne .notnear
	lda.w #anearest		; anearest
	sta.b d0
	jsl.l assinsert
.notnear:
	ldx.b a3
	lda.w newpnum,x		; tmpdst of newpnum = TMPDICE: on the ice
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w #TMPDICE
	sta.w tmpdst,y
	lsr.b d3
	jsl.l setplayer		; setplayer
.next:
	ldx.b a3
	lda.w #$FFFF		; newpnum = newpos = -1
	sta.w newpnum,x
	sta.w newpos,x
	inc.b a3
	inc.b a3
	dec.b d4
	bpl .top
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
