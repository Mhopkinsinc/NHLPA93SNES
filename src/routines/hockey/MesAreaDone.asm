MesAreaDone:		;SNES: end a string built in mesarea: length = a1 - mesarea, a1 = mesarea
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	lda.w #mesarea
	sta.b a1
	rtl
