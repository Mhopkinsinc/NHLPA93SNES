showref:		;Referee graphics: only clears the referee flag here
	lda.w #sf2refref
	trb.w sflags
	rtl
