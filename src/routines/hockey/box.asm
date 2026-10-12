box:		;fill a $13 x 8 rectangle at printz position $FF,$B,2 with char $7FF (eraser).
		;   SNES: erase the 19 x 9 box at x 11, y 2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$0B,$02
	lda.w #$0013
	sta.b d0
	lda.w #$0009
	sta.b d1
	lda.w blankchar
	sta.b d2
	jml.l eraser
