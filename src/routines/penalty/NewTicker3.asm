NewTicker3:		;Show the ticker box for game d3: round, period and both teams with their scores
	lda.b d3
	asl a
	sta.b a0
	tay
	lda.w gsflags,y
	bit.w #$0006
	bne NewTicker2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
	lda.w sflags
	bit.w #$0001
	bne .pj
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
.pj:
	lda.w sfhormode
	bne .frame
	lda.w printy
	sec
	sbc.w #$0005
	sta.w printy
.frame:
	lda.w #$001C
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	lda.b vcount
	sta.w tickervc
	inc.w printx
	lda.w printy
	sec
	sbc.w #$0004
	sta.w printy
	lda.w printx
	pha
	jsl.l GetShifter
	lda.w #$2400
	sta.w printa
	jsl.l printz
	dw $001C		; printz inline string: length (counts itself), then control bytes / text
	db "                          "
	lda.b $01,s
	sta.w printx
	lda.b d3
	clc
	adc.b d2
	sta.b d0
	lda.w #GameLabels
	sta.b a1
	lda.w #GameLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	lda.b $01,s
	clc
	adc.w #$0015
	sta.w printx
	ldy.b a0
	lda.w gsper,y
	dec a
	sta.b d0
	lda.w #PerLabels
	sta.b a1
	lda.w #PerLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	lda.w #$2000
	sta.w printa
	ldy.b a0
	lda.w gst1,y
	sta.b d0
	lda.w gss1,y
	sta.b d1
	jsl.l TickerTeam
	ldy.b a0
	lda.w gst2,y
	sta.b d0
	lda.w gss2,y
	sta.b d1
	jsl.l TickerTeam
	pla
	rtl
