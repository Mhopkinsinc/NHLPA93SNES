MesAreaDone:		;End a string built in mesarea and set a1 to it
	lda.b a1
	sec
	sbc.w #mesarea
	sta.w mesarea
	lda.w #mesarea
	sta.b a1
	rtl
