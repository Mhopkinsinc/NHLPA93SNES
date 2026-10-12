startpause2:		;Pause started from controller 2
	lda.w #sfpj
	tsb.w sflags
	jml.l startpause
