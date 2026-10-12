BitstoPW:		;convert passbits into password text
		;   SNES: convert passbits into the 16 password characters (SuperDiv by PWrange)
	ldx.w #$000F
.char:
	lda.w #PWrange		; PassWord[x] = passbits mod PWrange
	sta.b d0
	jsl.l SuperDiv
	sep #$20
	lda.b d0
	sta.w PassWord,x
	rep #$30
	dex
	bpl .char
	rtl
