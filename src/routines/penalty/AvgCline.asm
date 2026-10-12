AvgCline:		;d0 = the average energy of team a2's current line
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d1,x
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
	stz.b d0
	stz.b d1
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.l0:
	ldy.b a0
	lda.w position,y
	beq .next
	bmi .next
	lda.w pnum,y
	and.w #$00FF
	asl a
	sta.b d3
	lda.b a2
	beq .idx
	lda.w #$0034
.idx:
	adc.b d3
	tay
	lda.w tmpde,y
	adc.b d0
	sta.b d0
	inc.b d1
.next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .l0
	lda.b d1		; players counted
	beq .ex
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l divu16
	sta.b d0
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
	sta.b d1,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
