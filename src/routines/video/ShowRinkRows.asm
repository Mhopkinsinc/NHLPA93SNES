ShowRinkRows:		;show_rink part: DMAList entries for the IceRinkMap rows that Vscroll brought on screen (Oldrow, vramrow)
	ldy.b DMAListend
	lda.w Vscroll
	clc
	adc.w #$0170
	lsr a
	lsr a
	lsr a
	tax
	sec
	sbc.w Oldrow
	bne .moved
	jmp.w .done
.moved:
	bpl .down
	stx.w Oldrow
	eor.w #$FFFF
	inc a
	cmp.w #$0019
	bcs .redraw
	sta.b tmp1
	lda.w vramrow
	sec
	sbc.b tmp1
	and.w #$001F
	sta.w vramrow
	sta.b tmp2
	bra .rows
.redraw:
	lda.w #$001D
	sta.b tmp1
	stz.w vramrow
	stz.b tmp2
	bra .rows
.down:
	stx.w Oldrow
	cmp.w #$0019
	bcs .redraw
	sta.b tmp1
	adc.w vramrow
	and.w #$001F
	sta.w vramrow
	adc.w #$001D
	sec
	sbc.b tmp1
	and.w #$001F
	sta.b tmp2
	txa
	clc
	adc.w #$001D
	sec
	sbc.b tmp1
	tax
.rows:
	txa
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b tmp0
	asl a
	adc.b tmp0
	adc.w #IceRinkMap
	sta.b tmp0
	lda.b tmp2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w #$0400
	sta.b tmp2
	ldx.b tmp1
.rowloop:
	lda.w #IceRinkMap>>16
	sta.w DMAList+dmabank,y
	sta.w DMAList+dmasize+dmabank,y
	lda.b tmp2
	sta.w DMAList+dmavram,y
	clc
	adc.w #$0400
	sta.w DMAList+dmasize+dmavram,y
	sec
	sbc.w #$03E0
	cmp.w #$0800
	bne .nowrap
	lda.w #$0400
.nowrap:
	sta.b tmp2
	lda.b tmp0
	sta.w DMAList,y
	clc
	adc.w #$0040
	sta.w DMAList+dmasize+dmasrc,y
	adc.w #$0020
	sta.b tmp0
	lda.w #$0040
	sta.w DMAList+dmalen,y
	lsr a
	sta.w DMAList+dmasize+dmalen,y
	tya
	adc.w #$000E
	tay
	dex
	bne .rowloop
.done:
	sty.b DMAListend
	rtl
