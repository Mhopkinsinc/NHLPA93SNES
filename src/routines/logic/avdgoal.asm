avdgoal:		;don't try to skate thru goal: if d0/d1 cords intersect thru goal then provide new d0/d1 cords. a3 = player
		;   SNES: if the path d0/d1 crosses a goal line (y +-258) within 40 of the net, aim beside the net (x +-60) instead
	stz.b tmp2
	lda.w #-258		; goal line at y -258 ($FEFE) and 258 ($102)
	jsl.l .ch1
	lda.w #258
	jsl.l .ch1
	lda.b tmp2
	bne .rtl
	lda.w Xpos,x		; not crossing: is the player in front of a net?
	eor.b d0
	bpl .rtl
	lda.w Ypos,x
	sec
	sbc.w #258
	bit.w #$8000
	beq .b
	eor.w #$FFFF
	inc a
.b:
	cmp.w #32
	bcc .x
	lda.w Ypos,x
	sec
	sbc.w #-258
	bit.w #$8000
	beq .c
	eor.w #$FFFF
	inc a
.c:
	cmp.w #32
	bcs .rtl
.x:
	stz.b d1
	rtl
.ch1:		;goal line A: crossed within 40 of the net: d1 = line, d0 = +-60 by Xvel, tmp2 = 1
	sta.b tmp0
	lda.b d1
	sec
	sbc.b tmp0
	sta.b tmp1
	lda.w Ypos,x
	sec
	sbc.b tmp0
	eor.b tmp1
	bpl .rtl
	lda.w Xpos,x
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #40
	bcs .rtl
	inc.b tmp2
	lda.b tmp0
	sta.b d1
	lda.w #60
	sta.b d0
	lda.w Xvel,x
	bpl .rtl
	lda.w #-60
	sta.b d0
.rtl:
	rtl
unused008D:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
