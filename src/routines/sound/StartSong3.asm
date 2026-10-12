StartSong3:		;Start the third period music unless it is already playing
	lda.w cursong
	cmp.w #$0003
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0006
	jsl.l MusicCue		; driver command A (music cue)
	lda.w #$0003
	sta.w cursong
	lda.w #$0474
	sta.w cuetimer
.rtl:
	rtl
