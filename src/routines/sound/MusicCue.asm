MusicCue:		;Play music cue A: the sound queue is cleared to just this command
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
