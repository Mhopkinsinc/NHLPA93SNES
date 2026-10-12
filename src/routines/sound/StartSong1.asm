StartSong1:		;SNES: start music cue 1 (home goal) unless it plays: the in-game sound set, then MusicCue with 4; cuetimer = its length
	lda.w cursong
	cmp.w #$0001
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0004
	jsl.l MusicCue		; driver command A (music cue)
	lda.w #$0001
	sta.w cursong
	lda.w #$0240
	sta.w cuetimer
.rtl:
	rtl
