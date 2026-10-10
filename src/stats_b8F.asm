; stats_b8F: 93G stats93: roster attribute columns.
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8FFAF3
GetPlayerCount:		;d0 = players on team a2 (records until a length word of 2) (93G stats93)
		;   SNES: d0 = roster players of team a2 (its bank $83 team record: Player entries until the empty one); saves a0
	lda.b a0+2		; save a0
	pha
	lda.b a0
	pha
	ldy.b a2
	lda.w tmdata,y
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	ldy.w #Playerdata
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	stz.b d0
.loop:
	inc.b d0
	lda.b [a0]
	clc
	adc.b a0
	adc.w #$0008
	sta.b a0
	lda.b [a0]
	cmp.w #$0002
	bne .loop
	pla
	sta.b a0
	pla
	sta.b a0+2
	rtl
