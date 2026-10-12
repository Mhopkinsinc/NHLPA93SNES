StartSong3:		;SNES: start music cue 3 (third period, Gameloop by p3cue) unless it plays: the in-game sound set, then MusicCue with 6; cuetimer = its length
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
