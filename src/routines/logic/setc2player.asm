setc2player:		;restore old player and switch to new d0 player on cont. 2
		;   SNES: same for controller 2
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
