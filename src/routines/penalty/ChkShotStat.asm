ChkShotStat:		;add to shot stat if a shot was taken
		;   SNES: if a shot was taken (sf2shot, cleared here), add 1 to the shooting team tmshots
	lda.w #sf2shot
	trb.w sflags
	beq .rtl
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	phx
	lda.w shotplayer
	asl a
	tax
	stx.b a3		; a3 = the shooter
	lda.w #$0001
	sta.b d0
	lda.w #tmshots
	sta.b d1
	jsl.l addteamstat
	plx
	stx.b a3
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
.rtl:
	rtl
