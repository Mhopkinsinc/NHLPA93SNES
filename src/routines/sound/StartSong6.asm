StartSong6:		;Start the title screen music unless it is already playing
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
