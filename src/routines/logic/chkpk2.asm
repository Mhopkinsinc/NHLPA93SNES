chkpk2:		;Z set if player X is on the shorthanded team
	lda.w pfteam,x
	bne .team2
	lda.w sflags
	and.w #sf2pwrtm		; sf2pwrtm
	eor.w #sf2pwrtm
	rtl
.team2:
	lda.w sflags
	and.w #sf2pwrtm
	rtl
