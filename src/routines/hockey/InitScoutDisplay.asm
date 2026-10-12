InitScoutDisplay:		;Reset the scouting report text scroll
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
