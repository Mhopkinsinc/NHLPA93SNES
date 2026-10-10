; middle_b8D: 93G middle93_1/middle93_2: utilities (print, joypads, math, decompression).
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8D847C
eraser:		;fill rectangle with char. d0/d1 = x/y size of rectangle, d2 = char word to fill with, printx/y/m define top left corner to start at (93G middle93_2)
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

org $8D871C
mulu16:		;SNES: 16-bit multiply: A = mula = mulb = mulres = low word of mula * mulb (mode 7 multiplier for a byte factor)
	lda.b mula
	bmi .full
	cmp.w #$0080
	bcc .byteb
	lda.b mulb
	bmi .full
	cmp.w #$0080
	bcs .full
	sep #$20
	sta.w M7B
	lda.b mula
	sta.w M7A
	lda.b mula+1
	sta.w M7A
	rep #$30
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.byteb:
	lda.b mulb
	bmi .full
	sep #$20
	sta.w M7A
	xba
	sta.w M7A
	lda.b mula
	sta.w M7B
	rep #$30
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.full:
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	sta.b mulres
	lda.w RDMPYH
	sta.b mulres+1
	lda.b mulb+1
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	rep #$30
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
