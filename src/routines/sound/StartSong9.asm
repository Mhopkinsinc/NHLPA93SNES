StartSong9:		;Start the playoff screen music unless it is already playing
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
