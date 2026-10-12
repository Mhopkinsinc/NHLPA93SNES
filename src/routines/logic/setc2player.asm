setc2player:		;Give controller 2 to player d0
	lda.b d0
	cmp.w c2playernum
	beq .rtl
	lda.w c2playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c2playernum
.rtl:
	rtl
