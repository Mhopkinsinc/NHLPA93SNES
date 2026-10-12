EASNLogo:		;Draw easn.map at x 1, y $19 on the vertical ice rink if no power play. Falls into DrawEASNMap
		;   SNES: the EASN logo (7 x 2 words, EASNLogoMap) at x 1, y $19 of the rink map unless a power play is on
	lda.w sflags
	bit.w #sf2pwrplay
	bne .rtl
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	stz.b tmp0
	stz.b tmp1
	lda.w #$0002
	sta.b tmp2
.row:
	lda.w #$0007
	sta.b tmp2+2
.col:
	ldx.b tmp0
	lda.l EASNLogoMap,x
	clc
	adc.w unusedchars
	adc.w charofs
	ldx.b tmp1
	ora.w #$2000
	sta.l textmap+$642,x
	inc.b tmp0
	inc.b tmp0
	inc.b tmp1
	inc.b tmp1
	dec.b tmp2+2
	bne .col
	lda.b tmp1
	clc
	adc.w #$0032
	sta.b tmp1
	dec.b tmp2
	bne .row
	lda.w #$0321		; dirty range of the rink map rows
	cmp.b textdirtylo
	bcs .hi
	sta.b textdirtylo
.hi:
	lda.w #$0347
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
