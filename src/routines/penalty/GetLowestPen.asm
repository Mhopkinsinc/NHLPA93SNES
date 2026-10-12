GetLowestPen:		;d0 = the power play time left, from the penalty box times. a2 = team on the power play, a3 = the shorthanded team
	stz.b d0
	stz.b d3
	lda.b a2
	beq .a
	lda.w #$001A
.a:
	sta.b a0
.top:
	ldy.b a0		; penalty box list of the power play team ($80 ends)
	inc.b a0
	lda.w tmboxlist,y
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .t2
	lda.b a2
	beq .h0
	lda.w #$0034
.h0:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y
	sta.b d2
	bit.w #$4000		; tmpdst bit 14: not timed
	bne .top
	lda.b d2
	sec
	sbc.b d3
	sta.b d2
	clc
	adc.b d0
	sta.b d0
	lda.b d2
	sta.b d3
	bra .top
.t2:
	ldy.b a3		; shorthanded team
	lda.w tmap,y
	cmp.w #6
	beq .rtl
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
	lda.b a3
	beq .b
	lda.w #$001A
.b:
	sta.b a0
.t3:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .rtl
	lda.b a3
	beq .h1
	lda.w #$0034
.h1:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .t3
	lda.b d0
	sec
	sbc.w tmpdst,y
	bmi .lt
	bvc .add
	bra .rtl
.lt:
	bvc .rtl
.add:
	lda.b d0
	clc
	adc.b d3
	sta.b d0
.rtl:
	rtl
