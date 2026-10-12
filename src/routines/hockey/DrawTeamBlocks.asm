DrawTeamBlocks:		;Draw team d1's name block at printx / printy
	lda.b a2
	pha
	phx
	lda.b d1		; 36 bytes per team
	sta.b mula
	lda.w #36
	sta.b mulb
	jsl.l mulu16
	tay
	lda.w #TeamBlocksMap
	sta.b a2
	lda.w #TeamBlocksMap>>16
	sta.b a2+2
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	lda.w #9
	sta.b tmp0
	sta.b tmp1
.row1:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w printfontset
	ora.w printa
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp0
	bne .row1
.row2:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w printfontset
	ora.w printa
	sta.l textmap+$2E,x
	iny
	iny
	inx
	inx
	dec.b tmp1
	bne .row2
	plx
	pla
	sta.b a2
	rtl
