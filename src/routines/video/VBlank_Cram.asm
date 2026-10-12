VBlank_Cram:		;vbint target (bank $88): DMAList, BG1 fine h-scroll Hscroll&7, BG1VOFS 0, CGRAM 0-127 from palbuffer; then VBlank_CramOnly every frame
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
	sep #$20
	lda.w Hscroll
	and.b #$07
	sta.w BG1HOFS		; BG1HOFS = Hscroll&7
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	rep #$30
	lda.w #DMA_CGRAM
	sta.w DMAP7
	lda.w #palbuffer&$FFFF		; colors 0-127
	sta.w A1T7L
	lda.w #$0100
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	lda.w #VBlank_CramOnly		; from now on: CGRAM every frame
	sta.b vbint
	ldx.w #$0012
.wait:		;short delay before leaving the handler
	dex
	bne .wait
	jmp.w vb2
