StartSong8:		;SNES: start song 8 (no caller found) unless it plays: the boot sound set (SPCBootUpload), then driver command 9
	lda.w cursong
	cmp.w #8
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$09
	sta.w APUIO0
	rep #$30
	lda.w #8
	sta.w cursong
.rtl:
	rtl
