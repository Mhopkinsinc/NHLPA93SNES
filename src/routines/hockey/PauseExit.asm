PauseExit:		;restore graphics and return from pause mode
		;   SNES: restore textmap (textsave), sflags and the rink, printscores1, setvideo
	stz.w cuetimer
	stz.w crowdvol
	jsl.l forceblack
	phx
	ldx.w #$07FE
.restoretext:
	lda.l textsave,x
	sta.l textmap,x
	dex
	dex
	bpl .restoretext
	plx
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .hor
	jsl.l ClrHor
.hor:
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1
	jsl.l setvideo
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	rtl
