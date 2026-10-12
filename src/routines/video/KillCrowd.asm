KillCrowd:		;silence the crowd noise (psg). Called from Reset, SetupPauseScreen, ...
		;   SNES: crowd volume $88 (silence) to the sound driver
	lda.w #$0088
	pha
	jsl.l sfx8F
	rtl
