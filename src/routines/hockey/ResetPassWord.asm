ResetPassWord:		;copy '-' char into password
		;   SNES: PassWord byte 0 = 0, bytes 1-15 = $1E (blank)
	sep #$30
	stz.w PassWord
	ldy.b #$0F
	lda.b #$1E
.blank:
	sta.w PassWord,y
	dey
	bne .blank
	rep #$30
	rtl
