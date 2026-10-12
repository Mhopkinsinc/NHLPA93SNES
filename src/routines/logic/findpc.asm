findpc:		;When and where the puck will cross each goal line
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
	lda.w #blueline+goalline		; top goal line (blueline+goalline)
	sta.b d4
	ldy.w #$0000
	jsl.l findpc_calc
	lda.w #-(blueline+goalline)		; bottom goal line
	sta.b d4
	ldy.w #$0004
	jsl.l findpc_calc
	stx.b xsave
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
