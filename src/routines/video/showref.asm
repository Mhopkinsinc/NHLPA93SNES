showref:		;draw ref graphics. Called from setvideo.
		;   SNES only clears sf2refref (the ref window goes by DMA elsewhere)
	lda.w #sf2refref
	trb.w sflags
	rtl
