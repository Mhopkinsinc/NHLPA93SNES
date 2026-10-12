ScoutPlayerExit:		;SNES: the showcased player of team a2 skates off (EraseScoutName, tmflags bit 1)
	jsl.l EraseScoutName
	ldy.b a2
	lda.w tmflags,y
	ora.w #$0002
	sta.w tmflags,y
.rtl:
	rtl
