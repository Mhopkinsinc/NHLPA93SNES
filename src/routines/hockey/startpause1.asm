startpause1:		;pause intiated by cont 1
		;   SNES: pause started by controller 1 (sfpj off), startpause
	lda.w #$0002
	trb.w sflags
	jml.l startpause
