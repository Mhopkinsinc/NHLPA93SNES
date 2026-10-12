printteamname:		;Print team d3's name, then move down two rows
	lda.w printx
	pha
	lda.w tmdata		; tmdata of team d3
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	lda.b d3
	beq .name
	lda.w tmdata+2
	sta.b a1
.name:
	ldy.w #Teamname
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	adc.b a1
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	inc.w printy
	rtl
