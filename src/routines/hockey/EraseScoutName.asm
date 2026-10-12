EraseScoutName:		;SNES: blank the 11 x 2 showcased player name area (ScoutNamePos, eraser)
	jsl.l ScoutNamePos
	lda.w #$000B
	sta.b d0
	lda.w #$0002
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser
