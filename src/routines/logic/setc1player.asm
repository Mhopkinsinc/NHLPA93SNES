setc1player:		;restore old player and switch to new d0 player on cont. 1
		;   SNES: restore the old player and give controller 1 to player d0
	lda.b d0
	cmp.w c1playernum
	beq .rtl
	lda.w c1playernum
	sta.b d1
	jsl.l restorepl
	lda.b d0
	sta.w c1playernum
.rtl:
	rtl
