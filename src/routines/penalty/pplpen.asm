pplpen:		;Print one penalty box line: player number and time left
	lda.w printy
	cmp.w #$000B
	bcs USBoard_rtl
	lda.b a2
	beq .noa2
	lda.w #$0034
.noa2:
	adc.b d0
	tay
	lda.w tmpdst,y
	and.w #$07FF
	sta.b d2
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	ldy.w #Playerdata
	adc.b [a1],y
	sta.b a1
	lsr.b d0
.find:
	lda.b [a1]
	clc
	adc.b a1
	adc.w #$0008
	sta.b a1
	dec.b d0
	bpl .find
	lda.b a1
	sec
	sbc.w #$0008
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d0
	lda.w printx
	pha
	lda.w #mesarea+2
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	jsl.l PutDigits2
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0004
	sta.b [a1]
	jsl.l print
	lda.b d2
	sta.b d0
	jsl.l PushTime
	inc.w printx
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	rtl
