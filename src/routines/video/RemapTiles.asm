RemapTiles:		;Copy tiles to video memory with each pixel color remapped through a table
	lda.w #$000E
	sta.b tmp2+1
.tile:
	rep #$30
	ldy.b tmp2+1
	lda.b [a0],y
	sta.b tmp0
	tya
	clc
	adc.w #$0010
	tay
	lda.b [a0],y
	sta.b tmp1
	sep #$30
	ldx.b tmp2+1
	lda.b #$07
	sta.b tmp2
.pixel:
	ldy.b #$00
	asl.b tmp1+1
	bcc .lt
	ldy.b #$08
.lt:
	asl.b tmp1
	bcc .lt2
	iny
	iny
	iny
	iny
.lt2:
	asl.b tmp0+1
	bcc .lt3
	iny
	iny
.lt3:
	asl.b tmp0
	bcc .lt4
	iny
.lt4:
	lda.b [a1],y
	lsr a
	rol.b mula,x
	lsr a
	rol.b mula+1,x
	lsr a
	rol.b mula+16,x
	lsr a
	rol.b mula+17,x
	dec.b tmp2
	bpl .pixel
	dec.b tmp2+1
	dec.b tmp2+1
	bpl .tile
	rep #$30
	ldx.w #$0000
.out:
	lda.b mula,x
	sta.w VMDATAL
	inx
	inx
	cpx.w #$0020
	bne .out
	lda.b a0
	clc
	adc.w #$0020
	sta.b a0
	dec.b d0
	bne RemapTiles
	rtl
