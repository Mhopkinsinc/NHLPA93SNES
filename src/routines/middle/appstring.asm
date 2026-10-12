appstring:		;append string a1 to string a3
		;   SNES: append string [a1] to the string [a3]
	lda.w #$0002
	sta.b tmp0
	lda.b [a3]
	sta.b tmp1
.loop:
	lda.b tmp0
	cmp.b [a1]
	beq .done
	tay
	lda.b [a1],y
	ldy.b tmp1
	sta.b [a3],y
	inc.b tmp0
	inc.b tmp1
	bra .loop
.done:
	lda.b tmp1
	sta.b [a3]
	rtl
