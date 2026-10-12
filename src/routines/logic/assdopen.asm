assdopen:		;asstab $D. add player a3 to penalty box
		;   SNES: add player X to the penalty box (PBnum), position -1, frame 0
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
