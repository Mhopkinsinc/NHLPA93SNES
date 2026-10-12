ScoutPlayerExit:		;The player shown for team a2 skates off
	jsl.l EraseScoutName
	ldy.b a2
	lda.w tmflags,y
	ora.w #$0002
	sta.w tmflags,y
.rtl:
	rtl
