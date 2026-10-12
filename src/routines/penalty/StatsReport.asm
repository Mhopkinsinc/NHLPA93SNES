StatsReport:		;Clear the text screen, draw the horizontal rink scoreboard background, then the scoreboard
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0020
	sta.b d0
	lda.w #$001D
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0418
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.row:
	ldy.w #$0020
.col:
	lda.l HorRinkMap,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .col
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .row
	lda.w #$0800
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.row2:
	ldy.w #$0020
.col2:
	lda.l HorRinkMap+$10,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .col2
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .row2
	jmp.w USBoard
