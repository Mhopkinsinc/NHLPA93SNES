USBoard:		;Update the scoreboard, with the players in the penalty box and their time left
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
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
	jsl.l printscores1
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$08
	stz.b a2
	jsl.l .dispen
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$08
	lda.w #$0002
	sta.b a2
	jsl.l .dispen
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
	ldx.w #$001E
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
.dispen:		;penalty box list of team a2: timed players first
	lda.b a2
	beq .noa2
	lda.w #$001A
.noa2:
	sta.b a0
.l1:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .p2
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .l1
	jsl.l pplpen
	bra .l1
.p2:
	lda.b a2
	beq .noa23
	lda.w #$001A
.noa23:
	sta.b a0
.l2:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .rtl
	lda.b a2
	beq .noa24
	lda.w #$0034
.noa24:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	beq .l2
	jsl.l pplpen
	bra .l2
