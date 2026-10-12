getlchoice:		;d0 = choice 0-2 of team a2 -> d0 = line 0-6 by the man advantage and tmline (.tab), -1 = none
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	lda.b a2		; d2 = other tmap - our tmap: players short
	eor.w #2
	tay
	lda.w tmap,y
	ldy.b a2
	sec
	sbc.w tmap,y
	sta.b d2
	beq .1
	lda.b d0		; penalty killing: +21
	clc
	adc.w #21
	sta.b d0
	lda.b d2
	bmi .1
	lda.b d0		; power play: +21 more
	clc
	adc.w #21
	sta.b d0
.1:
	ldy.b a2		; + 3 * tmline
	lda.w tmline,y
	sta.b d1
	lda.b d0
	clc
	adc.b d1
	clc
	adc.b d1
	clc
	adc.b d1
	sta.b d0
	tay
	lda.w #.tab
	sta.b a0
	lda.w #.tab>>16
	sta.b a0+2
	lda.b [a0],y
	and.w #$00FF
	bit.w #$0080
	beq .sext
	ora.w #$FF00
.sext:
	sta.b d0
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d1,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.tab:		;line for choice 0-2 by tmline, 3 entries per line (-1 = none)
	db 0,1,2, 1,2,0, 2,0,1, 0,1,2, 0,1,2, 0,1,2, 0,1,2		; no power play: lines 0-6
	db 3,4,-1, 3,4,-1, 3,4,-1, 3,4,-1, 4,3,-1, 3,4,-1, 3,4,-1		; penalty killing: lines 0-6
	db 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 6,5,-1		; power play: lines 0-6
