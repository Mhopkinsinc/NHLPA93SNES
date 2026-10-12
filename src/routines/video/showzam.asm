showzam:		;zamboni. Called from setvideo.
		;   SNES: on the horizontal rink the zamboni sprite ($22D) moves with the time since vcountmark
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne showzam
	sbc.w vcountmark
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .rtl
	lda.w sfhormode
	beq .rtl
	lda.b tmp0
	lsr a
	lsr a
	sta.b sprx
	lda.w #$00C8
	sta.b spry
	lda.w #$022D
	sta.b sprframe
	jsl.l addframe
.rtl:
	rtl
