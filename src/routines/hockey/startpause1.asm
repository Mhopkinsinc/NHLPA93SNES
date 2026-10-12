startpause1:		;Pause started from controller 1
	lda.w #$0002
	trb.w sflags
	jml.l startpause
