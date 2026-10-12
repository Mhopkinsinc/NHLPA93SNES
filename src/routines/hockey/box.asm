box:		;Erase the goal box
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
