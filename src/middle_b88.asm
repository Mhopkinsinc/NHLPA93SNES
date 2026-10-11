; Utilities (print, joypads, math, decompression).
; Bank $88. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $88832F
mulu32:		;SNES: 32-bit multiply with the 8x8 hardware multiplier: A = mulres (32-bit, low word) = mula * mulb (low 32 bits). C clear
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	sta.b mulres
	stz.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c1
	inc.b mulres+3
.c1:
	lda.b mulb+2
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+3
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c2
	inc.b mulres+3
.c2:
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+2
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+2
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	lda.b mula+3
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+3
	sta.b mulres+3
	rep #$30
	lda.b mulres
	clc
	rtl

org $888942
mulu:		;68k mulu.w: mulres (32-bit) = mula * mulb; mula/mulb also get the result. A byte factor uses the mode 7 multiplier (M7A/M7B)
	lda.b mula		; mula >= $80 needs mulb < $80
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
	lda.w MPYH
	rep #$30
	and.w #$00FF
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.byteb:
	lda.b mulb		; mula < $80: byte factor
	bmi .full
	sep #$20
	sta.w M7A
	xba
	sta.w M7A
	lda.b mula
	sta.w M7B
	lda.w MPYH
	rep #$30
	and.w #$00FF
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
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
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	sta.b mulres
	stz.b mulres+2
	sep #$20
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c1
	inc.b mulres+3
.c1:
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	sep #$20
	bcc .c2
	inc.b mulres+3
.c2:
	lda.b mulb+1
	sta.w WRMPYB
	rep #$30
	rep #$30
	clc
	lda.w RDMPYL
	adc.b mulres+2
	sta.b mula+2
	sta.b mulb+2
	sta.b mulres+2
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
