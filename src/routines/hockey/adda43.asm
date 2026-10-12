adda43:		;Step a4 to the next replay frame, wrapping around the replay buffer
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	bcc .nc
	inc.b a4+2
.nc:
	cmp.w #ReplayBufferEnd&$FFFF		; past the end of the buffer: wrap
	bne .rtl
	lda.b a4+2
	cmp.w #ReplayBufferEnd>>16
	bne .rtl
	lda.w #ReplayBufferStart&$FFFF
	sta.b a4
	lda.w #ReplayBufferStart>>16
	sta.b a4+2
.rtl:
	rtl
