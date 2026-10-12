randomd0s:		;A = a random number from -A to A-1
	sta.b tmp0
	asl a
	jsl.l randoma
	sec
	sbc.b tmp0
	clc
	rtl
