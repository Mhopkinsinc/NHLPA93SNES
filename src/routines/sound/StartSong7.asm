StartSong7:		;SNES: start song 7 (driver command 2); no caller found
	lda.w cursong
	cmp.w #7
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$02
	sta.w APUIO0
	rep #$30
	lda.w #7
	sta.w cursong
.rtl:
	rtl
