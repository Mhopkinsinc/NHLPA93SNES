prefmes:		;print message for penalty d0 (negative clears it). Vertical mode: framed under the ref. Horizontal mode: one centered line on row $B
		;   SNES: print the message of penalty d0 (negative clears it). Vertical: framed under the ref at y $A, centred by its length; horizontal (sfhormode):
		;   ClearPenaltyMessage, one centred line at x $11, y $B. Saves d0-d2, a1
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
.savea1:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea1
	ldx.b xsave
	lda.w sfhormode
	beq .nosfhormode
	jmp.w .hor
.nosfhormode:
	lda.b d0
	bpl .d0pos
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0A
	lda.w #$000D
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jmp.w .ex
.d0pos:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0A
	ldy.b d0
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip:
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	dec a
	dec a
	sta.b d0
	beq .ex
	inc a
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	bpl .pos
	stz.w printx
.pos:
	lda.b [a1]
	sta.b d0
	tay
	dec.b a1
	lda.b [a1],y
	inc.b a1
	and.w #$00FF
	bne .nonzero
	dec.b d0
.nonzero:
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	dec.w printy
	dec.w printy
	inc.w printx
	jsl.l print
	bra .ex
.hor:
	jsl.l ClearPenaltyMessage
	lda.b d0
	bmi .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip2:
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jsl.l print
.ex:
	stx.b xsave
	ldx.w #$0002
.resta1:
	pla
	sta.b a1,x
	dex
	dex
	bpl .resta1
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
