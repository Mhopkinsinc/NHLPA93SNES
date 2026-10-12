startpause:		;set sfpz (startpause1 and startpause2 jump here)
	lda.w #sfpz
	tsb.w sflags
	rtl
