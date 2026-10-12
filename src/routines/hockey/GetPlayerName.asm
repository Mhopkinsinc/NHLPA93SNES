GetPlayerName:		;mesarea = the number and name of player TempPlOffset
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea2:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea2
	ldx.b xsave
	stz.b a2
	lda.w TempPlOffset		; bit 15: away team
	sta.b d0
	bpl .name
	and.w #$00FF
	sta.b d0
	inc.b a2
	inc.b a2
.name:
	jsl.l PlayerNumName
	stx.b xsave
	ldx.w #$0002
.resta2:
	pla
	sta.b a2,x
	dex
	dex
	bpl .resta2
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
	rtl
