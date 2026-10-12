VBlank_List:		;Vblank: run the transfer list once, then go back to vb2
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	ldx.b DMAListend
	bra .next
.dmaloop:
	ldy.w DMAList+dmavram,x
	sty.w VMADDL
	ldy.w DMAList+dmalen,x
	sty.w DAS7L
	ldy.w #DMA_VRAMWORD
	sty.w DMAP7
	ldy.w DMAList+dmasrc,x
	sty.w A1T7L
	lda.w DMAList+dmabank,x
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
.next:
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	bpl .dmaloop
	rep #$30
	stz.b DMAListend
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
