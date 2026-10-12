getlinee:		;d0 = line number, a2 = team struct. Return d0 = energy level of this line
		;   SNES: Returns d0 = average energy (tmpde) of the skaters of that line (priolist picks the positions)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d3,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	lda.w #TeamList>>16		; a1 = the team data (bank $83)
	sta.b a1+2
	ldy.w #LineSets		; + offset of the line sets
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b d0		; line d0: 8 bytes
	asl a
	asl a
	asl a
	adc.b a1
	sta.b a1
	stz.b mulb
	stz.b mula
	lda.w #priolist		; a0 = priolist
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	ldy.b a2		; tmap: positions - 1
	lda.w tmap,y
	sta.b d4
	bra .next
.loop:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	beq .next
	tay		; player number
	lda.b [a1],y
	and.w #$00FF
	asl a
	sta.b d3
	inc.b mula
	lda.b a2
	beq .addhome
	lda.w #$0034
.addhome:
	adc.b d3
	tay
	lda.w tmpde-2,y
	adc.b mulb
	sta.b mulb
.next:
	dec.b d4
	bpl .loop
	jsl.l divu16		; d0 = energy sum / players
	sta.b d0
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d3,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
