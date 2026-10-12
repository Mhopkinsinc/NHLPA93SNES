SPCGameUpload:		;Wait for the sound queue to empty, then upload the in-game sample set
	phy
	phx
	pha
.qwait:
	lda.b sndqin
	cmp.b sndqout
	bne .qwait
	lda.b vcount
	clc
	adc.w #$0006
.vblank:
	cmp.b vcount
	bne .vblank
	lda.w #$0001		; sndbank 1, no song
	sta.b sndlock
	sta.w sndbank
	stz.w cursong
	lda.w #GameSoundUpload&$FFFF		; sndptr = GameSoundUpload
	sta.b sndptr
	lda.w #(GameSoundUpload>>8)&$FFFF
	sta.b sndptr+1
	jsl.l SPCUpload
	sep #$20
	lda.b #NMITIMEN_NMI|NMITIMEN_JOY
	sta.w NMITIMEN
	rep #$30
	lda.w #$000A
	sta.w sndsettle
	pla
	plx
	ply
	rtl
