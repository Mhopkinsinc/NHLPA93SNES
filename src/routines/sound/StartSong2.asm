StartSong2:		;SNES: start music cue 2 (period start) unless it plays: the in-game sound set, then MusicCue with 5; cuetimer = its length
	lda.w cursong
	cmp.w #$0002
	beq .rtl
	lda.w sndbank
	cmp.w #$0001
	beq .cmd
	jsl.l sndqreset
	jsl.l SPCGameUpload
.cmd:
	lda.w #$0005
	jsl.l MusicCue		; driver command A (music cue)
	lda.w #$0002
	sta.w cursong
	lda.w #$01CE
	sta.w cuetimer
.rtl:
	rtl
