sndqreset:		;Empty the sound command queue and stop the music cue
	lda.w #$0001		; sndlock while the queue is reset; cuetimer = 0
	sta.b sndlock
	stz.w cursong
	stz.w cuetimer
	stz.b sndqueue
	stz.b sndqout
	lda.w #$0002
	sta.b sndqin
	stz.b sndlock
	rtl
