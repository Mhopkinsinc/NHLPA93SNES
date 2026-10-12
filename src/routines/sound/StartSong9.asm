StartSong9:		;SNES: start song 9 (the playoff screen music, PlayoffScreen) unless it plays: the boot sound set (SPCBootUpload), then driver command 1
	lda.w cursong
	cmp.w #9
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20
	lda.b #$01
	sta.w APUIO0
	rep #$30
	lda.w #9
	sta.w cursong
.rtl:
	rtl
