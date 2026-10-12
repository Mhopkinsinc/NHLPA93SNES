SetLCmode:		;Open the line change box when the puck carrier's team asks for it
	lda.w OptLine
	bne .rtl
	jsl.l loadTeamStruct		; loadTeamStruct: a2 = team of X
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmflc		; tmflc: team already in lc mode
	bne .rtl
	ora.w #tmflc
	sta.w tmflags,y
	lda.w #sfspdir|sfssdir		; clear sfspdir/sfssdir
	trb.w sflags
	lda.w pflags,x
	ora.w #pf2lcm		; pf2lcm
	sta.w pflags,x
	lda.w lcplayer		; remember the player when lcplayer = $FFFE
	cmp.w #$FFFE
	bne .show
	txa
	lsr a
	sta.w lcplayer
.show:
	jmp.w SetLCmode2
.rtl:
	rtl
