startpause2:		;pause intiated by cont 2
		;   SNES: pause started by controller 2 (sflags bit 1), then startpause
	lda.w #sfpj
	tsb.w sflags
	jml.l startpause
