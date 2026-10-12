Framer:		;Draw a frame and fill it. d0 / d1 = width / height, printx / printy / printm = top left corner

		;   SNES: a d0 x d1 box of FramerMap pieces at printx/printy
	phx
	lda.w printx
	sta.b tmp0
	lda.b d0
	sta.b tmp2
	ldx.w #$0000
	jsl.l .setter
	dec.b tmp2
	dec.b tmp2
.top:
	ldx.w #$0002
	jsl.l .setter
	dec.b tmp2
	bne .top
	ldx.w #$0004
	jsl.l .setter
	dec.b d1
	dec.b d1
.row:
	lda.b tmp0
	sta.w printx
	inc.w printy
	lda.b d0
	dec a
	dec a
	sta.b tmp2
	ldx.w #$0006
	jsl.l .setter
.mid:
	ldx.w #$0008
	jsl.l .setter
	dec.b tmp2
	bne .mid
	ldx.w #$000A
	jsl.l .setter
	dec.b d1
	bne .row
	lda.b tmp0
	sta.w printx
	inc.w printy
	dec.b d0
	dec.b d0
	ldx.w #$000C
	jsl.l .setter
.bot:
	ldx.w #$000E
	jsl.l .setter
	dec.b d0
	bne .bot
	ldx.w #$0010
	jsl.l .setter
	lda.b tmp0
	sta.w printx
	inc.w printy
	plx
	rtl
.setter:		;one FramerMap piece (X = piece * 2) at printx/printy, printx + 1
	lda.l FramerMap,x
	clc
	adc.w Framercset
	clc
	adc.w printfontset
	pha
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	pla
	ora.w printa
	sta.l textmap,x
	inc.w printx
	txa
	lsr a
	cmp.b textdirtylo
	bcs .lo
	sta.b textdirtylo
.lo:
	cmp.b textdirtyhi
	bcc .hi
	sta.b textdirtyhi
.hi:
	rtl
