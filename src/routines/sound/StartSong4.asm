StartSong4:		;SNES: start music cue 4 (no caller found) unless it plays: the in-game sound set, then MusicCue with 7; cuetimer = its length
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
