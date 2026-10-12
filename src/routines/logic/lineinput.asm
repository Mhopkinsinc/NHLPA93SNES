lineinput:		;process input for line changes
		;   SNES: line change input, d1 = new buttons: Y/B/A choose line choice 0-2 (lcfound); else skate with the dpad
	lda.b d1
	pha
	stz.b a2
	lda.w pfteam,x		; a2 = the team of player X
	beq .0
	inc.b a2
	inc.b a2
.0:
	ldy.b a2
	lda.w tmflags,y		; tmflags bit 0: start line change mode
	bit.w #tmflcc
	beq .1
	and.w #~tmflcc&$FFFF
	sta.w tmflags,y
	jsl.l lcfound2
	jsl.l SetLCmode2
.1:
	pla
	sta.b d1
	stz.b d2
	bit.w #abut		; Y: choice 0
	beq .b
	jml.l lcfound		; d2 = choice
.b:
	inc.b d2
	bit.w #bbut		; B: choice 1
	beq .a
	jml.l lcfound		; d2 = choice
.a:
	inc.b d2
	bit.w #JOYA		; A: choice 2
	beq .dpad
	jml.l lcfound		; d2 = choice
.dpad:
	lda.w pflags,x		; joystick controlled, not locked or fighting: skate
	bit.w #pfjoycon
	beq .x
	lda.w pfalock,x
	bne .x
	lda.w pf2fight,x
	bne .x
	jml.l doplayeracc
.x:
	rtl
