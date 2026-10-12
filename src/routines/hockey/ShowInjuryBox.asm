ShowInjuryBox:		;injury box "Injury to:" player TempPlOffset (set by setInjuryType)
		;   SNES: "Injury to:" the player TempPlOffset (GetPlayerNumInitial), "Out for period", or "the game" when pf2fight of the puck is set.
		;   Jumped to by CheckInjury; saves d0-d2, a0-a4, ends with X = a3
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
	cpx.w #$0014
	bne .savea
	ldx.b xsave
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$03
	lda.w #$0012
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	jsl.l printz
	dw $0023		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0C,$04,"Injury to:",$BF,$0C,$06,"Out for period",$BF,$0C,$05
	jsl.l GetPlayerNumInitial
	jsl.l print
	lda.w pf2fight+puckobj
	beq .period
	jsl.l printz
	dw $000D		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$06,"the game"
.period:
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
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
