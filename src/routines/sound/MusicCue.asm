MusicCue:		;SNES: send driver command A (a music cue): the sound queue becomes just A (sndqueue, out 0, in 2), under sndlock
	pha
	lda.w #$0001
	sta.b sndlock
	pla
	sta.b sndqueue
	stz.b sndqout
	lda.w #$0002
	sta.b sndqin
	stz.b sndlock
	rtl
