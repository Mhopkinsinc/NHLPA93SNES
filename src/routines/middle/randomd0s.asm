randomd0s:		;d0 = range. Return d0 = random number (-range < d0 < range)
		;   SNES: A = range in, A = random -range..range-1 out
	sta.b tmp0
	asl a
	jsl.l randoma
	sec
	sbc.b tmp0
	clc
	rtl
