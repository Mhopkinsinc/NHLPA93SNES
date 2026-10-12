ResetPassWord:		;Blank the password
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
