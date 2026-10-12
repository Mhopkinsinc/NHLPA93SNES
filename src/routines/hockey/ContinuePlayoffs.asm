ContinuePlayoffs:		;continue playoffs: read the playoff state back from the password bits, rebuild the tree.
		;   SNES: no caller found
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
	lda.w #passbits		; a3 = passbits
	sta.b a3
	lda.w #$0000
	sta.b a3+2
	jsl.l ReadPassBits
	lda.w gamelevel
	ora.b bosgames
	sta.b d0
	beq .ex
	jsl.l maketree
	lda.w #$0007		; menu value from pojoy
	sec
	sbc.w pojoy
	sta.w OptPlayers
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
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
