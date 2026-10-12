chkpk2:		;Z set if player X is on the short-handed team (sf2pwrtm vs pfteam)
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
