InitScoutDisplay:		;SNES: scouting report scroll state reset; a0 = TestList (the text buffer)
	lda.w #$FFFF
	sta.w VertLineScrolling
	sta.w PlayerScrollCtr
	stz.w SelectedPlayerIdx
	stz.w ScoutingReportTimer
	lda.w #TestList&$FFFF
	sta.b a0
	lda.w #TestList>>16
	sta.b a0+2
	rtl
