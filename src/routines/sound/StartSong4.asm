StartSong4:		;Start music cue 4 unless it is already playing. Unused
	lda.w cursong
	cmp.w #$0004
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0007
	jsl.l MusicCue		; driver command A (music cue)
	lda.w #$0004
	sta.w cursong
	lda.w #$022E
	sta.w cuetimer
.rtl:
	rtl
