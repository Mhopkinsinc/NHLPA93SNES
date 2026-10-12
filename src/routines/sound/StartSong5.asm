StartSong5:		;Start the mid-period music unless it is already playing
	lda.w cursong
	cmp.w #$0005
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0008
	jsl.l MusicCue		; driver command A (music cue)
	lda.w #$0005
	sta.w cursong
	lda.w #$041A
	sta.w cuetimer
.rtl:
	rtl
