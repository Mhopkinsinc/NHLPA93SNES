StartSong6:		;SNES: start song 6 (the title screen music, from TitleScreen and setoptions) unless it plays: the boot sound set (SPCBootUpload), then driver command 3
	lda.w cursong
	cmp.w #6
	beq .rtl
	lda.w sndbank
	cmp.w #2
	beq .cmd
	jsl.l SPCBootUpload
.cmd:
	sep #$20		; APUIO0 = 3: play song 6
	lda.b #$03
	sta.w APUIO0
	rep #$30
	lda.w #6
	sta.w cursong
.rtl:
	rtl
