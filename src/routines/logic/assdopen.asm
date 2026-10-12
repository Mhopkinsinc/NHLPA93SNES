assdopen:		;Assignment: put player X in the penalty box
	lda.w pfalock,x
	bne .rtl
	lda.w #$0010
	sta.b d0
	lda.w pfteam,x
	beq .1
	lda.w #$0001
	sta.b d0
.1:
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF
	sta.w position,x
	stz.w frame,x
.rtl:
	rtl
