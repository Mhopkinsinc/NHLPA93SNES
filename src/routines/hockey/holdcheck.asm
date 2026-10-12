holdcheck:		;player a2 is in hold animation looking to hold opponent a3. Entered from checkcheck .cc for SPA $CB0 or $12DC
		;   SNES: player X holds a2 (SPAHold/SPAhook), both slow to the average speed; checkagr may call a holding/hooking penalty
	lda.w pfalock,x
	ora.w pf2fight,x
	beq .nopf2fight
	jmp.w .rtl
.nopf2fight:
	lda.w position,x
	bne .position
	jmp.w .rtl
.position:
	ldy.b a2
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcc .lt
	jmp.w .rtl
.lt:
	lda.w puckc
	asl a
	cmp.b a3
	bne .nopc
	lda.w #$0008
	trb.w sflags
.nopc:
	ldy.b a2
	lda.w Xvel,x
	clc
	adc.w Xvel,y
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	sta.w Xvel,y
	lda.w Yvel,x
	clc
	adc.w Yvel,y
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	sta.w Yvel,y
	lda.w #$0C60
	sta.b d1
	sta.w pfalock,x
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$0C2E
	sta.b d1
	sta.w pfalock,x
	lda.w SPA,x
	cmp.w #$0BFC
	beq .h2
	lda.w #$1386
	sta.b d1
.h2:
	jsl.l SetSPA
	jsl.l checkagr
	lda.b d0
	cmp.w #$0007
	bcs .ex
	lda.w #$0024
	sta.b d0
	lda.w SPA,x
	cmp.w #$0C2E
	beq .pen
	lda.w #$001E
	sta.b d0
.pen:
	jsl.l AddPenalty
.ex:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.rtl:
	rtl
