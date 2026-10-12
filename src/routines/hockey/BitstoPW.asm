BitstoPW:		;Turn the password bits into the password characters
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
