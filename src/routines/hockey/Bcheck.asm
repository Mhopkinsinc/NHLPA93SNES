Bcheck:		;player a2 is in SPA $B44 and a3 is the other player. Entered from checkcheck .cc. If OptPen is 0 and a2 is joystick controlled, a2 needs randomd0($10 + a2 checking rating - a3
		;   legstr) >= $C. If a3 is within 1 direction of where a2 faces, a3 falls and checkagr may call penalty $20 on a2. Sets collflag to -1
		;   SNES: a2 checks a3 with SPA $B44: if a3 is in front (within one direction) he falls; checkagr may call a penalty $20 (charging) on
		;   a2
	ldy.b a2
	lda.w pfalock,x
	beq .pos
	jmp.w .rtl
.pos:
	lda.w position,x
	bne .fight
	jmp.w .rtl
.fight:
	lda.w pf2fight,x
	bne .rtl
	lda.w OptPen		; penalties off: a2 needs randomd0($10 + aggression - a3 legstr) >= 12
	bne .dir
	lda.w pflags,y
	bit.w #pfjoycon
	beq .dir
	lda.w #16
	clc
	adc.w aggress,y
	sec
	sbc.w legstr,x
	jsl.l randoma
	cmp.w #12
	bcc .rtl
.dir:
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
	lda.b d0		; within one direction of a2 facing
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .rtl
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l FallDown		; a3 falls
	jsl.l checkagr
	lda.b d0
	cmp.w #$0005
	bcs .swap
	lda.w #$20		; penalty $20
	sta.b d0
	jsl.l AddPenalty
.swap:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.rtl:
	rtl
