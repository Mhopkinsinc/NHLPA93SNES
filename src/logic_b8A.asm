; Player logic and the assignments (asstab).
; Bank $8A. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8AFD0C
lineinput:		;process input for line changes
		;   SNES: line change input, d1 = new buttons: Y/B/A choose line choice 0-2 (lcfound); else skate with the dpad
	lda.b d1
	pha
	stz.b a2
	lda.w pfteam,x		; a2 = the team of player X
	beq .zero
	inc.b a2
	inc.b a2
.zero:
	ldy.b a2
	lda.w tmflags,y		; tmflags bit 0: start line change mode
	bit.w #tmflcc
	beq .one
	and.w #~tmflcc&$FFFF
	sta.w tmflags,y
	jsl.l lcfound2
	jsl.l SetLCmode2
.one:
	pla
	sta.b d1
	stz.b d2
	bit.w #abut		; Y: choice 0
	beq .b
	jml.l lcfound		; bank $8F (d2 = choice)
.b:
	inc.b d2
	bit.w #bbut		; B: choice 1
	beq .a
	jml.l lcfound		; bank $8F (d2 = choice)
.a:
	inc.b d2
	bit.w #JOYA		; A: choice 2
	beq .dpad
	jml.l lcfound		; bank $8F (d2 = choice)
.dpad:
	lda.w pflags,x		; joystick controlled, not locked or fighting: skate
	bit.w #pfjoycon
	beq .x
	lda.w pfalock,x
	bne .x
	lda.w pf2fight,x
	bne .x
	jml.l doplayeracc		; bank $8F
.x:
	rtl
getlchoice:		;d0 = choice 0-2 of team a2 -> d0 = line 0-6 by the man advantage and tmline (.tab), -1 = none
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pushd
	ldx.b xsave
	lda.b a2		; d2 = other tmap - our tmap: players short
	eor.w #2
	tay
	lda.w tmap,y
	ldy.b a2
	sec
	sbc.w tmap,y
	sta.b d2
	beq .one
	lda.b d0		; penalty killing: +21
	clc
	adc.w #21
	sta.b d0
	lda.b d2
	bmi .one
	lda.b d0		; power play: +21 more
	clc
	adc.w #21
	sta.b d0
.one:
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
	beq .pos
	ora.w #$FF00
.pos:
	sta.b d0
	stx.b xsave
	ldx.w #$0006
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
.tab:		;line for choice 0-2 by tmline, 3 entries per line (-1 = none)
	db 0,1,2, 1,2,0, 2,0,1, 0,1,2, 0,1,2, 0,1,2, 0,1,2		; no power play: lines 0-6
	db 3,4,-1, 3,4,-1, 3,4,-1, 3,4,-1, 4,3,-1, 3,4,-1, 3,4,-1		; penalty killing: lines 0-6
	db 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 5,6,-1, 6,5,-1		; power play: lines 0-6
