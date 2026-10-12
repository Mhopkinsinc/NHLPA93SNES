setlccords:		;printx / printy and the size of team a2's line change box
	stz.b d0
	lda.b a2
	bne .0
	inc.b d0
.0:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$13,$01
	lda.w gmode		; gmdir flips it
	bit.w #gmdir
	beq .noflip
	lda.b d0
	eor.w #$0001
	sta.b d0
.noflip:
	lda.w #$0015		; printy += 21 * d0
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; mulu, A = mula*mulb
	adc.w printy
	sta.w printy
	lda.w #$0002		; getlchoice 2: no third choice: 2 rows
	sta.b d0
	jsl.l getlchoice		; d0 = possible line, -1 = none
	lda.w #$0006
	sta.b d1
	lda.b d0
	bpl .ex
	dec.b d1
	inc.w printy
.ex:
	lda.w #$000C
	sta.b d0
	rtl
