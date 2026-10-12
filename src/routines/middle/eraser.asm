eraser:		;fill rectangle with char. d0/d1 = x/y size of rectangle, d2 = char word to fill with, printx/y/m define top left corner to start at
		;   SNES: fill d0 x d1 textmap words at printx/printy (print map printm) with tile d2 (+ printfontset)
	phx
	lda.b d2
	clc
	adc.w printfontset
	sta.b d2
	stz.b d1+2
.row:
	lda.w printy
	clc
	adc.b d1+2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	ldy.b d0
	lda.b d2
.col:
	sta.l textmap,x
	inx
	inx
	dey
	bne .col
	inc.b d1+2
	lda.b d1+2
	cmp.b d1
	bne .row
	plx
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	cmp.b textdirtylo
	bcs .hi
	sta.b textdirtylo
.hi:
	lda.w printy
	clc
	adc.b d1
	and.w #$001F
	sta.w printy
	dec a
	and.w #$001F
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.b d0
	dec a
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
