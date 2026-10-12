VBlank_SprPal:		;Vblank: as VBlank, plus the sprite palettes; once, then back to vb2
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
	lda.w #DMA_OAM
	sta.w DMAP7
	lda.w #Satt
	sta.w A1T7L
	lda.w #$0220
	sta.w DAS7L
	stz.w OAMADDL
	sep #$20
	lda.b #$00
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #DMA_CGRAM		; DMAP7=$00, BBAD7=$22 (CGDATA)
	sta.w DMAP7
	lda.w #(palbuffer+$140)&$FFFF		; color $A0
	sta.w A1T7L
	lda.w #$0040		; 32 colors
	sta.w DAS7L
	sep #$20
	lda.b #$A0		; sprite palettes 2-3
	sta.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #vb2
	sta.b vbint
	jmp.w vb2
