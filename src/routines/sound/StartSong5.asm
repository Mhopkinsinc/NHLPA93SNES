StartSong5:		;SNES: start music cue 5 (mid-period) unless it plays: the in-game sound set, then MusicCue with 8; cuetimer = its length
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
